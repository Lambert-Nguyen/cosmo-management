// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PhotoModelImpl _$$PhotoModelImplFromJson(Map<String, dynamic> json) =>
    _$PhotoModelImpl(
      id: (json['id'] as num).toInt(),
      url: json['url'] as String,
      thumbnailUrl: json['thumbnail_url'] as String?,
      type: $enumDecodeNullable(_$PhotoTypeEnumMap, json['type']) ??
          PhotoType.general,
      approvalStatus: $enumDecodeNullable(
              _$PhotoApprovalStatusEnumMap, json['approvalStatus']) ??
          PhotoApprovalStatus.pending,
      caption: json['caption'] as String?,
      taskId: (json['task_id'] as num?)?.toInt(),
      checklistItemId: (json['checklist_item_id'] as num?)?.toInt(),
      checklistResponseId: (json['checklist_response_id'] as num?)?.toInt(),
      inventoryId: (json['inventory_id'] as num?)?.toInt(),
      lostFoundId: (json['lost_found_id'] as num?)?.toInt(),
      propertyId: (json['property_id'] as num?)?.toInt(),
      propertyName: json['property_name'] as String?,
      uploadedById: (json['uploaded_by'] as num?)?.toInt(),
      uploadedByName: json['uploaded_by_name'] as String?,
      approvedById: (json['approved_by'] as num?)?.toInt(),
      approvedByName: json['approved_by_name'] as String?,
      approvedAt: json['approved_at'] == null
          ? null
          : DateTime.parse(json['approved_at'] as String),
      rejectionReason: json['rejection_reason'] as String?,
      fileSize: (json['file_size'] as num?)?.toInt(),
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
      mimeType: json['mime_type'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$PhotoModelImplToJson(_$PhotoModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'thumbnail_url': instance.thumbnailUrl,
      'type': _$PhotoTypeEnumMap[instance.type]!,
      'approvalStatus': _$PhotoApprovalStatusEnumMap[instance.approvalStatus]!,
      'caption': instance.caption,
      'task_id': instance.taskId,
      'checklist_item_id': instance.checklistItemId,
      'checklist_response_id': instance.checklistResponseId,
      'inventory_id': instance.inventoryId,
      'lost_found_id': instance.lostFoundId,
      'property_id': instance.propertyId,
      'property_name': instance.propertyName,
      'uploaded_by': instance.uploadedById,
      'uploaded_by_name': instance.uploadedByName,
      'approved_by': instance.approvedById,
      'approved_by_name': instance.approvedByName,
      'approved_at': instance.approvedAt?.toIso8601String(),
      'rejection_reason': instance.rejectionReason,
      'file_size': instance.fileSize,
      'width': instance.width,
      'height': instance.height,
      'mime_type': instance.mimeType,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$PhotoTypeEnumMap = {
  PhotoType.before: 'before',
  PhotoType.after: 'after',
  PhotoType.damage: 'damage',
  PhotoType.inventory: 'inventory',
  PhotoType.lostFound: 'lost_found',
  PhotoType.general: 'general',
};

const _$PhotoApprovalStatusEnumMap = {
  PhotoApprovalStatus.pending: 'pending',
  PhotoApprovalStatus.approved: 'approved',
  PhotoApprovalStatus.rejected: 'rejected',
};

_$PhotoComparisonModelImpl _$$PhotoComparisonModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PhotoComparisonModelImpl(
      id: (json['id'] as num).toInt(),
      taskId: (json['task_id'] as num?)?.toInt(),
      taskTitle: json['task_title'] as String?,
      propertyId: (json['property_id'] as num?)?.toInt(),
      propertyName: json['property_name'] as String?,
      beforePhoto: json['before_photo'] == null
          ? null
          : PhotoModel.fromJson(json['before_photo'] as Map<String, dynamic>),
      afterPhoto: json['after_photo'] == null
          ? null
          : PhotoModel.fromJson(json['after_photo'] as Map<String, dynamic>),
      beforeUrl: json['before_url'] as String?,
      afterUrl: json['after_url'] as String?,
      locationDescription: json['location_description'] as String?,
      comparisonNotes: json['comparison_notes'] as String?,
      createdById: (json['created_by'] as num?)?.toInt(),
      createdByName: json['created_by_name'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$PhotoComparisonModelImplToJson(
        _$PhotoComparisonModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'task_id': instance.taskId,
      'task_title': instance.taskTitle,
      'property_id': instance.propertyId,
      'property_name': instance.propertyName,
      'before_photo': instance.beforePhoto,
      'after_photo': instance.afterPhoto,
      'before_url': instance.beforeUrl,
      'after_url': instance.afterUrl,
      'location_description': instance.locationDescription,
      'comparison_notes': instance.comparisonNotes,
      'created_by': instance.createdById,
      'created_by_name': instance.createdByName,
      'created_at': instance.createdAt?.toIso8601String(),
    };

_$PhotoUploadItemImpl _$$PhotoUploadItemImplFromJson(
        Map<String, dynamic> json) =>
    _$PhotoUploadItemImpl(
      localId: json['localId'] as String,
      filePath: json['file_path'] as String,
      fileName: json['file_name'] as String,
      fileSize: (json['file_size'] as num?)?.toInt(),
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      status: $enumDecodeNullable(_$PhotoUploadStatusEnumMap, json['status']) ??
          PhotoUploadStatus.pending,
      errorMessage: json['error_message'] as String?,
      serverId: (json['server_id'] as num?)?.toInt(),
      serverUrl: json['server_url'] as String?,
      type: $enumDecodeNullable(_$PhotoTypeEnumMap, json['type']) ??
          PhotoType.general,
      entityType: json['entity_type'] as String?,
      entityId: (json['entity_id'] as num?)?.toInt(),
      caption: json['caption'] as String?,
    );

Map<String, dynamic> _$$PhotoUploadItemImplToJson(
        _$PhotoUploadItemImpl instance) =>
    <String, dynamic>{
      'localId': instance.localId,
      'file_path': instance.filePath,
      'file_name': instance.fileName,
      'file_size': instance.fileSize,
      'progress': instance.progress,
      'status': _$PhotoUploadStatusEnumMap[instance.status]!,
      'error_message': instance.errorMessage,
      'server_id': instance.serverId,
      'server_url': instance.serverUrl,
      'type': _$PhotoTypeEnumMap[instance.type]!,
      'entity_type': instance.entityType,
      'entity_id': instance.entityId,
      'caption': instance.caption,
    };

const _$PhotoUploadStatusEnumMap = {
  PhotoUploadStatus.pending: 'pending',
  PhotoUploadStatus.uploading: 'uploading',
  PhotoUploadStatus.uploaded: 'uploaded',
  PhotoUploadStatus.failed: 'failed',
};

_$PhotoUploadResultImpl _$$PhotoUploadResultImplFromJson(
        Map<String, dynamic> json) =>
    _$PhotoUploadResultImpl(
      total: (json['total'] as num?)?.toInt() ?? 0,
      uploaded: (json['uploaded'] as num?)?.toInt() ?? 0,
      failed: (json['failed'] as num?)?.toInt() ?? 0,
      photoIds: (json['photo_ids'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      errors: (json['errors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
    );

Map<String, dynamic> _$$PhotoUploadResultImplToJson(
        _$PhotoUploadResultImpl instance) =>
    <String, dynamic>{
      'total': instance.total,
      'uploaded': instance.uploaded,
      'failed': instance.failed,
      'photo_ids': instance.photoIds,
      'errors': instance.errors,
      'completed_at': instance.completedAt?.toIso8601String(),
    };
