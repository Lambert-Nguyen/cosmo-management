/// Photo upload notifier for Cosmo Management
///
/// StateNotifier for managing photo upload queue and progress.
library;

import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../data/models/photo_model.dart';
import '../../../data/repositories/photo_repository.dart';

/// Photo upload state
sealed class PhotoUploadState {
  const PhotoUploadState();
}

/// Initial state (no uploads)
class PhotoUploadInitial extends PhotoUploadState {
  const PhotoUploadInitial();
}

/// Upload in progress state
class PhotoUploadInProgress extends PhotoUploadState {
  final List<PhotoUploadItem> items;
  final bool isUploading;
  final double overallProgress;

  const PhotoUploadInProgress({
    required this.items,
    this.isUploading = false,
    this.overallProgress = 0.0,
  });

  PhotoUploadInProgress copyWith({
    List<PhotoUploadItem>? items,
    bool? isUploading,
    double? overallProgress,
  }) {
    return PhotoUploadInProgress(
      items: items ?? this.items,
      isUploading: isUploading ?? this.isUploading,
      overallProgress: overallProgress ?? this.overallProgress,
    );
  }

  /// Get count of pending uploads
  int get pendingCount =>
      items.where((i) => i.status == PhotoUploadStatus.pending).length;

  /// Get count of completed uploads
  int get completedCount =>
      items.where((i) => i.status == PhotoUploadStatus.uploaded).length;

  /// Get count of failed uploads
  int get failedCount =>
      items.where((i) => i.status == PhotoUploadStatus.failed).length;

  /// Calculate overall progress
  double get calculatedProgress {
    if (items.isEmpty) return 0.0;
    final totalProgress = items.fold(0.0, (sum, item) => sum + item.progress);
    return totalProgress / items.length;
  }
}

/// Upload completed state
class PhotoUploadCompleted extends PhotoUploadState {
  final PhotoUploadResult result;

  const PhotoUploadCompleted(this.result);
}

/// Upload error state
class PhotoUploadError extends PhotoUploadState {
  final String message;
  final List<PhotoUploadItem> failedItems;

  const PhotoUploadError({
    required this.message,
    this.failedItems = const [],
  });
}

/// Photo upload notifier
class PhotoUploadNotifier extends StateNotifier<PhotoUploadState> {
  final PhotoRepository _repository;
  final _uuid = const Uuid();

  PhotoUploadNotifier(this._repository) : super(const PhotoUploadInitial());

  /// Add files to upload queue
  void addFiles(
    List<File> files, {
    PhotoType type = PhotoType.general,
    String? entityType,
    int? entityId,
    String? caption,
  }) {
    final currentItems = state is PhotoUploadInProgress
        ? (state as PhotoUploadInProgress).items
        : <PhotoUploadItem>[];

    final newItems = files.map((file) {
      return PhotoUploadItem(
        localId: _uuid.v4(),
        filePath: file.path,
        fileName: file.path.split('/').last,
        fileSize: file.lengthSync(),
        type: type,
        entityType: entityType,
        entityId: entityId,
        caption: caption,
      );
    }).toList();

    state = PhotoUploadInProgress(
      items: [...currentItems, ...newItems],
      isUploading: false,
    );
  }

  /// Add file paths to upload queue
  void addFilePaths(
    List<String> paths, {
    PhotoType type = PhotoType.general,
    String? entityType,
    int? entityId,
    String? caption,
  }) {
    addFiles(
      paths.map((p) => File(p)).toList(),
      type: type,
      entityType: entityType,
      entityId: entityId,
      caption: caption,
    );
  }

  /// Start uploading all pending items
  Future<void> startUpload() async {
    if (state is! PhotoUploadInProgress) return;

    final currentState = state as PhotoUploadInProgress;
    if (currentState.isUploading) return;

    state = currentState.copyWith(isUploading: true);

    final items = List<PhotoUploadItem>.from(currentState.items);
    var uploaded = 0;
    var failed = 0;
    final photoIds = <int>[];
    final errors = <String>[];

    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      if (item.status != PhotoUploadStatus.pending) continue;

      // Update status to uploading
      items[i] = item.copyWith(status: PhotoUploadStatus.uploading);
      state = PhotoUploadInProgress(items: items, isUploading: true);

      try {
        final photo = await _repository.uploadPhoto(
          filePath: item.filePath,
          type: item.type,
          entityType: item.entityType,
          entityId: item.entityId,
          caption: item.caption,
          onProgress: (progress) {
            items[i] = item.copyWith(progress: progress);
            state = PhotoUploadInProgress(items: items, isUploading: true);
          },
        );

        items[i] = item.copyWith(
          status: PhotoUploadStatus.uploaded,
          progress: 1.0,
          serverId: photo.id,
          serverUrl: photo.url,
        );
        uploaded++;
        photoIds.add(photo.id);
      } catch (e) {
        items[i] = item.copyWith(
          status: PhotoUploadStatus.failed,
          errorMessage: e.toString(),
        );
        failed++;
        errors.add('${item.fileName}: ${e.toString()}');
      }

      state = PhotoUploadInProgress(items: items, isUploading: true);
    }

    // All uploads complete
    final result = PhotoUploadResult(
      total: items.length,
      uploaded: uploaded,
      failed: failed,
      photoIds: photoIds,
      errors: errors,
      completedAt: DateTime.now(),
    );

    if (failed == 0) {
      state = PhotoUploadCompleted(result);
    } else {
      state = PhotoUploadError(
        message: 'Some uploads failed',
        failedItems: items.where((i) => i.isFailed).toList(),
      );
    }
  }

  /// Retry failed uploads
  Future<void> retryFailed() async {
    if (state is PhotoUploadError) {
      final errorState = state as PhotoUploadError;
      final retryItems = errorState.failedItems.map((item) {
        return item.copyWith(
          status: PhotoUploadStatus.pending,
          progress: 0.0,
          errorMessage: null,
        );
      }).toList();

      state = PhotoUploadInProgress(items: retryItems);
      await startUpload();
    }
  }

  /// Remove item from queue
  void removeItem(String localId) {
    if (state is PhotoUploadInProgress) {
      final currentState = state as PhotoUploadInProgress;
      final updatedItems =
          currentState.items.where((i) => i.localId != localId).toList();

      if (updatedItems.isEmpty) {
        state = const PhotoUploadInitial();
      } else {
        state = currentState.copyWith(items: updatedItems);
      }
    }
  }

  /// Clear all uploads
  void clear() {
    state = const PhotoUploadInitial();
  }

  /// Cancel current upload
  void cancel() {
    if (state is PhotoUploadInProgress) {
      final currentState = state as PhotoUploadInProgress;
      // Mark uploading items as pending
      final items = currentState.items.map((item) {
        if (item.status == PhotoUploadStatus.uploading) {
          return item.copyWith(status: PhotoUploadStatus.pending, progress: 0.0);
        }
        return item;
      }).toList();

      state = PhotoUploadInProgress(items: items, isUploading: false);
    }
  }
}

/// Extension for PhotoUploadItem copyWith (since it's Freezed)
extension PhotoUploadItemCopyWith on PhotoUploadItem {
  PhotoUploadItem copyWith({
    String? localId,
    String? filePath,
    String? fileName,
    int? fileSize,
    double? progress,
    PhotoUploadStatus? status,
    String? errorMessage,
    int? serverId,
    String? serverUrl,
    PhotoType? type,
    String? entityType,
    int? entityId,
    String? caption,
  }) {
    return PhotoUploadItem(
      localId: localId ?? this.localId,
      filePath: filePath ?? this.filePath,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      progress: progress ?? this.progress,
      status: status ?? this.status,
      errorMessage: errorMessage,
      serverId: serverId ?? this.serverId,
      serverUrl: serverUrl ?? this.serverUrl,
      type: type ?? this.type,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      caption: caption ?? this.caption,
    );
  }
}
