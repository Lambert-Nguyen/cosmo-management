/// Photo repository for Cosmo Management
///
/// Handles photo upload and comparison operations.
library;

import 'dart:io';

import '../../core/config/api_config.dart';
import '../../core/services/image_compression_service.dart';
import '../models/photo_model.dart';
import 'base_repository.dart';

/// Repository for photo operations
class PhotoRepository extends BaseRepository {
  PhotoRepository({
    required super.apiService,
    required super.storageService,
    ImageCompressionService? compressionService,
  }) : _compressionService = compressionService ?? ImageCompressionService();

  final ImageCompressionService _compressionService;

  // Cache keys
  String _taskPhotosCacheKey(int taskId) => 'photos_task_$taskId';
  String _comparisonCacheKey(int taskId) => 'photo_comparison_$taskId';

  // ============================================
  // Photo Upload
  // ============================================

  /// Upload a single photo with optional compression
  Future<PhotoModel> uploadPhoto({
    required String filePath,
    PhotoType type = PhotoType.general,
    String? entityType,
    int? entityId,
    String? caption,
    bool compressBeforeUpload = true,
    ImageCompressionConfig compressionConfig = const ImageCompressionConfig(),
    void Function(double progress)? onProgress,
  }) async {
    final file = File(filePath);
    if (!file.existsSync()) {
      throw Exception('File not found: $filePath');
    }

    // Compress image if enabled and file is large enough
    var uploadPath = filePath;
    CompressionResult? compressionResult;

    if (compressBeforeUpload && _compressionService.needsCompression(filePath)) {
      compressionResult = await _compressionService.compressImage(
        filePath,
        config: compressionConfig,
      );
      uploadPath = compressionResult.path;
    }

    final additionalData = <String, dynamic>{
      'type': type.value,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (caption != null) 'caption': caption,
    };

    try {
      final response = await apiService.uploadFile<Map<String, dynamic>>(
        ApiConfig.staffPhotoUpload,
        filePath: uploadPath,
        fieldName: 'file',
        additionalData: additionalData,
        onSendProgress: onProgress != null
            ? (sent, total) => onProgress(sent / total)
            : null,
      );

      return PhotoModel.fromJson(response);
    } finally {
      // Clean up compressed temp file if created
      if (compressionResult != null && uploadPath != filePath) {
        await _compressionService.cleanupTempFiles([uploadPath]);
      }
    }
  }

  /// Upload multiple photos in batch
  Future<PhotoUploadResult> uploadPhotos({
    required List<String> filePaths,
    PhotoType type = PhotoType.general,
    String? entityType,
    int? entityId,
    void Function(int uploaded, int total)? onProgress,
  }) async {
    var uploaded = 0;
    var failed = 0;
    final photoIds = <int>[];
    final errors = <String>[];

    for (final path in filePaths) {
      try {
        final photo = await uploadPhoto(
          filePath: path,
          type: type,
          entityType: entityType,
          entityId: entityId,
        );
        uploaded++;
        photoIds.add(photo.id);
      } catch (e) {
        failed++;
        errors.add('${path.split('/').last}: ${e.toString()}');
      }
      onProgress?.call(uploaded + failed, filePaths.length);
    }

    return PhotoUploadResult(
      total: filePaths.length,
      uploaded: uploaded,
      failed: failed,
      photoIds: photoIds,
      errors: errors,
      completedAt: DateTime.now(),
    );
  }

  // ============================================
  // Photo Retrieval
  // ============================================

  /// Get photos for a specific task
  Future<List<PhotoModel>> getPhotosByTask(int taskId) async {
    final response = await apiService.get(
      ApiConfig.staffPhotos,
      queryParameters: {'task_id': taskId},
    );

    final List<dynamic> results = response['results'] ?? response;
    return results
        .map((e) => PhotoModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Get photos by entity type and ID
  Future<List<PhotoModel>> getPhotosByEntity({
    required String entityType,
    required int entityId,
  }) async {
    final response = await apiService.get(
      ApiConfig.staffPhotos,
      queryParameters: {
        'entity_type': entityType,
        'entity_id': entityId,
      },
    );

    final List<dynamic> results = response['results'] ?? response;
    return results
        .map((e) => PhotoModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Get photo by ID
  Future<PhotoModel> getPhotoById(int id) async {
    final response = await apiService.get(ApiConfig.staffPhotoDetail(id));
    return PhotoModel.fromJson(response);
  }

  // ============================================
  // Photo Comparison
  // ============================================

  /// Get before/after comparison pairs for a task
  Future<List<PhotoComparisonModel>> getPhotoComparisons(int taskId) async {
    return getCachedOrFetch<List<PhotoComparisonModel>>(
      cacheKey: _comparisonCacheKey(taskId),
      fetchFunction: () async {
        final response = await apiService.get(
          ApiConfig.staffPhotoComparison(taskId),
        );

        final List<dynamic> results = response['results'] ?? response;
        return results
            .map((e) => PhotoComparisonModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
      fromJson: (json) {
        final List<dynamic> list = json as List<dynamic>;
        return list
            .map((e) => PhotoComparisonModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  // ============================================
  // Photo Actions
  // ============================================

  /// Delete a photo
  Future<void> deletePhoto(int id) async {
    await apiService.delete(ApiConfig.staffPhotoDetail(id));
  }

  /// Review a photo (approve/reject)
  Future<PhotoModel> reviewPhoto(
    int id, {
    required bool approved,
    String? rejectionReason,
  }) async {
    final response = await apiService.post(
      ApiConfig.staffPhotoReview(id),
      data: {
        'approved': approved,
        if (!approved && rejectionReason != null)
          'rejection_reason': rejectionReason,
      },
    );

    return PhotoModel.fromJson(response);
  }

  // ============================================
  // Cache Management
  // ============================================

  /// Invalidate task photos cache
  Future<void> invalidateTaskPhotosCache(int taskId) async {
    await invalidateCache(_taskPhotosCacheKey(taskId));
    await invalidateCache(_comparisonCacheKey(taskId));
  }
}
