/// Photo model for Cosmo Management
///
/// Freezed model for photo upload and comparison with JSON serialization.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'photo_model.freezed.dart';
part 'photo_model.g.dart';

/// Photo type for categorization
@JsonEnum(valueField: 'value')
enum PhotoType {
  @JsonValue('before')
  before('before', 'Before'),
  @JsonValue('after')
  after('after', 'After'),
  @JsonValue('damage')
  damage('damage', 'Damage'),
  @JsonValue('inventory')
  inventory('inventory', 'Inventory'),
  @JsonValue('lost_found')
  lostFound('lost_found', 'Lost & Found'),
  @JsonValue('general')
  general('general', 'General');

  final String value;
  final String displayName;

  const PhotoType(this.value, this.displayName);

  /// Check if this is a comparison photo
  bool get isComparison => this == before || this == after;
}

/// Photo approval status
@JsonEnum(valueField: 'value')
enum PhotoApprovalStatus {
  @JsonValue('pending')
  pending('pending', 'Pending'),
  @JsonValue('approved')
  approved('approved', 'Approved'),
  @JsonValue('rejected')
  rejected('rejected', 'Rejected');

  final String value;
  final String displayName;

  const PhotoApprovalStatus(this.value, this.displayName);
}

/// Photo upload status (local state)
enum PhotoUploadStatus {
  pending('Pending'),
  uploading('Uploading'),
  uploaded('Uploaded'),
  failed('Failed');

  final String displayName;

  const PhotoUploadStatus(this.displayName);
}

/// Photo model
///
/// Represents a photo in the system (task, checklist, inventory, etc.)
@freezed
class PhotoModel with _$PhotoModel {
  const factory PhotoModel({
    required int id,
    required String url,
    @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
    @Default(PhotoType.general) PhotoType type,
    @Default(PhotoApprovalStatus.pending) PhotoApprovalStatus approvalStatus,
    String? caption,
    @JsonKey(name: 'task_id') int? taskId,
    @JsonKey(name: 'checklist_item_id') int? checklistItemId,
    @JsonKey(name: 'checklist_response_id') int? checklistResponseId,
    @JsonKey(name: 'inventory_id') int? inventoryId,
    @JsonKey(name: 'lost_found_id') int? lostFoundId,
    @JsonKey(name: 'property_id') int? propertyId,
    @JsonKey(name: 'property_name') String? propertyName,
    @JsonKey(name: 'uploaded_by') int? uploadedById,
    @JsonKey(name: 'uploaded_by_name') String? uploadedByName,
    @JsonKey(name: 'approved_by') int? approvedById,
    @JsonKey(name: 'approved_by_name') String? approvedByName,
    @JsonKey(name: 'approved_at') DateTime? approvedAt,
    @JsonKey(name: 'rejection_reason') String? rejectionReason,
    @JsonKey(name: 'file_size') int? fileSize,
    @JsonKey(name: 'width') int? width,
    @JsonKey(name: 'height') int? height,
    @JsonKey(name: 'mime_type') String? mimeType,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _PhotoModel;

  const PhotoModel._();

  factory PhotoModel.fromJson(Map<String, dynamic> json) =>
      _$PhotoModelFromJson(json);

  /// Get display URL (prefer thumbnail for lists)
  String get displayUrl => thumbnailUrl ?? url;

  /// Check if photo is approved
  bool get isApproved => approvalStatus == PhotoApprovalStatus.approved;

  /// Check if photo is pending approval
  bool get isPending => approvalStatus == PhotoApprovalStatus.pending;

  /// Check if photo was rejected
  bool get isRejected => approvalStatus == PhotoApprovalStatus.rejected;

  /// Get file size in human readable format
  String get fileSizeDisplay {
    if (fileSize == null) return 'Unknown';
    if (fileSize! < 1024) return '$fileSize B';
    if (fileSize! < 1024 * 1024) return '${(fileSize! / 1024).toStringAsFixed(1)} KB';
    return '${(fileSize! / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  /// Get dimensions string
  String? get dimensionsDisplay {
    if (width == null || height == null) return null;
    return '${width}x$height';
  }
}

/// Photo comparison pair model
///
/// Represents a before/after comparison pair.
@freezed
class PhotoComparisonModel with _$PhotoComparisonModel {
  const factory PhotoComparisonModel({
    required int id,
    @JsonKey(name: 'task_id') int? taskId,
    @JsonKey(name: 'task_title') String? taskTitle,
    @JsonKey(name: 'property_id') int? propertyId,
    @JsonKey(name: 'property_name') String? propertyName,
    @JsonKey(name: 'before_photo') PhotoModel? beforePhoto,
    @JsonKey(name: 'after_photo') PhotoModel? afterPhoto,
    @JsonKey(name: 'before_url') String? beforeUrl,
    @JsonKey(name: 'after_url') String? afterUrl,
    @JsonKey(name: 'location_description') String? locationDescription,
    @JsonKey(name: 'comparison_notes') String? comparisonNotes,
    @JsonKey(name: 'created_by') int? createdById,
    @JsonKey(name: 'created_by_name') String? createdByName,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _PhotoComparisonModel;

  const PhotoComparisonModel._();

  factory PhotoComparisonModel.fromJson(Map<String, dynamic> json) =>
      _$PhotoComparisonModelFromJson(json);

  /// Check if both photos are available
  bool get isComplete =>
      (beforePhoto != null || beforeUrl != null) &&
      (afterPhoto != null || afterUrl != null);

  /// Get before photo URL
  String? get beforePhotoUrl => beforePhoto?.url ?? beforeUrl;

  /// Get after photo URL
  String? get afterPhotoUrl => afterPhoto?.url ?? afterUrl;
}

/// Photo upload item (for batch upload tracking)
@freezed
class PhotoUploadItem with _$PhotoUploadItem {
  const factory PhotoUploadItem({
    /// Local identifier for this upload
    required String localId,

    /// Local file path
    @JsonKey(name: 'file_path') required String filePath,

    /// File name
    @JsonKey(name: 'file_name') required String fileName,

    /// File size in bytes
    @JsonKey(name: 'file_size') int? fileSize,

    /// Upload progress (0.0 to 1.0)
    @Default(0.0) double progress,

    /// Current upload status
    @Default(PhotoUploadStatus.pending) PhotoUploadStatus status,

    /// Error message if failed
    @JsonKey(name: 'error_message') String? errorMessage,

    /// Server photo ID after successful upload
    @JsonKey(name: 'server_id') int? serverId,

    /// Server URL after successful upload
    @JsonKey(name: 'server_url') String? serverUrl,

    /// Photo type
    @Default(PhotoType.general) PhotoType type,

    /// Associated entity type
    @JsonKey(name: 'entity_type') String? entityType,

    /// Associated entity ID
    @JsonKey(name: 'entity_id') int? entityId,

    /// Caption/description
    String? caption,
  }) = _PhotoUploadItem;

  const PhotoUploadItem._();

  factory PhotoUploadItem.fromJson(Map<String, dynamic> json) =>
      _$PhotoUploadItemFromJson(json);

  /// Check if upload is complete
  bool get isComplete => status == PhotoUploadStatus.uploaded;

  /// Check if upload failed
  bool get isFailed => status == PhotoUploadStatus.failed;

  /// Check if upload is in progress
  bool get isUploading => status == PhotoUploadStatus.uploading;

  /// Get progress percentage
  int get progressPercent => (progress * 100).round();
}

/// Photo upload batch result
@freezed
class PhotoUploadResult with _$PhotoUploadResult {
  const factory PhotoUploadResult({
    /// Total photos in batch
    @Default(0) int total,

    /// Successfully uploaded count
    @Default(0) int uploaded,

    /// Failed upload count
    @Default(0) int failed,

    /// List of uploaded photo IDs
    @JsonKey(name: 'photo_ids') @Default([]) List<int> photoIds,

    /// List of error messages
    @Default([]) List<String> errors,

    /// When upload completed
    @JsonKey(name: 'completed_at') DateTime? completedAt,
  }) = _PhotoUploadResult;

  const PhotoUploadResult._();

  factory PhotoUploadResult.fromJson(Map<String, dynamic> json) =>
      _$PhotoUploadResultFromJson(json);

  /// Check if all uploads succeeded
  bool get isSuccess => failed == 0 && uploaded == total;

  /// Check if any uploads failed
  bool get hasFailures => failed > 0;

  /// Get summary message
  String get summaryMessage {
    if (isSuccess) return 'Uploaded $uploaded photo${uploaded == 1 ? '' : 's'}';
    return 'Uploaded $uploaded, failed $failed';
  }
}
