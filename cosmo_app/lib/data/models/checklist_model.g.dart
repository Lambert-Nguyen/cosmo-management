// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChecklistItemModelImpl _$$ChecklistItemModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ChecklistItemModelImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String?,
      itemType: $enumDecode(_$ChecklistItemTypeEnumMap, json['item_type']),
      isRequired: json['is_required'] as bool? ?? true,
      order: (json['order'] as num?)?.toInt() ?? 0,
      roomType: json['room_type'] as String?,
    );

Map<String, dynamic> _$$ChecklistItemModelImplToJson(
        _$ChecklistItemModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'item_type': _$ChecklistItemTypeEnumMap[instance.itemType]!,
      'is_required': instance.isRequired,
      'order': instance.order,
      'room_type': instance.roomType,
    };

const _$ChecklistItemTypeEnumMap = {
  ChecklistItemType.check: 'check',
  ChecklistItemType.photoRequired: 'photo_required',
  ChecklistItemType.photoOptional: 'photo_optional',
  ChecklistItemType.textInput: 'text_input',
  ChecklistItemType.numberInput: 'number_input',
  ChecklistItemType.blocking: 'blocking',
};

_$ChecklistResponseModelImpl _$$ChecklistResponseModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ChecklistResponseModelImpl(
      id: (json['id'] as num).toInt(),
      itemId: (json['item'] as num).toInt(),
      isCompleted: json['is_completed'] as bool? ?? false,
      textResponse: json['text_response'] as String?,
      numberResponse: (json['number_response'] as num?)?.toDouble(),
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
      completedBy: (json['completed_by'] as num?)?.toInt(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$ChecklistResponseModelImplToJson(
        _$ChecklistResponseModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'item': instance.itemId,
      'is_completed': instance.isCompleted,
      'text_response': instance.textResponse,
      'number_response': instance.numberResponse,
      'completed_at': instance.completedAt?.toIso8601String(),
      'completed_by': instance.completedBy,
      'notes': instance.notes,
    };

_$ChecklistPhotoModelImpl _$$ChecklistPhotoModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ChecklistPhotoModelImpl(
      id: (json['id'] as num).toInt(),
      checklistResponseId: (json['checklist_response'] as num?)?.toInt(),
      image: json['image'] as String,
      photoType: json['photo_type'] as String? ?? 'checklist',
      uploadedAt: json['uploaded_at'] == null
          ? null
          : DateTime.parse(json['uploaded_at'] as String),
      uploadedBy: (json['uploaded_by'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ChecklistPhotoModelImplToJson(
        _$ChecklistPhotoModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'checklist_response': instance.checklistResponseId,
      'image': instance.image,
      'photo_type': instance.photoType,
      'uploaded_at': instance.uploadedAt?.toIso8601String(),
      'uploaded_by': instance.uploadedBy,
    };

_$TaskChecklistModelImpl _$$TaskChecklistModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TaskChecklistModelImpl(
      id: (json['id'] as num).toInt(),
      taskId: (json['task'] as num).toInt(),
      templateId: (json['template'] as num?)?.toInt(),
      templateName: json['template_name'] as String?,
      items: (json['items'] as List<dynamic>?)
              ?.map(
                  (e) => ChecklistItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      responses: (json['responses'] as List<dynamic>?)
              ?.map((e) =>
                  ChecklistResponseModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      photos: (json['photos'] as List<dynamic>?)
              ?.map((e) =>
                  ChecklistPhotoModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      startedAt: json['started_at'] == null
          ? null
          : DateTime.parse(json['started_at'] as String),
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
      completedBy: (json['completed_by'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$TaskChecklistModelImplToJson(
        _$TaskChecklistModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'task': instance.taskId,
      'template': instance.templateId,
      'template_name': instance.templateName,
      'items': instance.items,
      'responses': instance.responses,
      'photos': instance.photos,
      'started_at': instance.startedAt?.toIso8601String(),
      'completed_at': instance.completedAt?.toIso8601String(),
      'completed_by': instance.completedBy,
    };

_$ChecklistProgressModelImpl _$$ChecklistProgressModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ChecklistProgressModelImpl(
      completed: (json['completed'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$ChecklistProgressModelImplToJson(
        _$ChecklistProgressModelImpl instance) =>
    <String, dynamic>{
      'completed': instance.completed,
      'total': instance.total,
      'percentage': instance.percentage,
    };
