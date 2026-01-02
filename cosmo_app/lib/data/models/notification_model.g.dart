// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationModelImpl _$$NotificationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationModelImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      message: json['message'] as String?,
      notificationType: json['notification_type'] as String?,
      isRead: json['is_read'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      readAt: json['read_at'] == null
          ? null
          : DateTime.parse(json['read_at'] as String),
      actionUrl: json['action_url'] as String?,
      relatedObjectType: json['related_object_type'] as String?,
      relatedObjectId: (json['related_object_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$NotificationModelImplToJson(
        _$NotificationModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'message': instance.message,
      'notification_type': instance.notificationType,
      'is_read': instance.isRead,
      'created_at': instance.createdAt?.toIso8601String(),
      'read_at': instance.readAt?.toIso8601String(),
      'action_url': instance.actionUrl,
      'related_object_type': instance.relatedObjectType,
      'related_object_id': instance.relatedObjectId,
    };
