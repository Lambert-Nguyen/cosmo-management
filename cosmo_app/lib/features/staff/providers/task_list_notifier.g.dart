// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_list_notifier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskListFilterImpl _$$TaskListFilterImplFromJson(Map<String, dynamic> json) =>
    _$TaskListFilterImpl(
      status: $enumDecodeNullable(_$TaskStatusEnumMap, json['status']),
      priority: $enumDecodeNullable(_$TaskPriorityEnumMap, json['priority']),
      propertyId: (json['propertyId'] as num?)?.toInt(),
      propertyName: json['propertyName'] as String?,
      overdueOnly: json['overdueOnly'] as bool? ?? false,
      search: json['search'] as String?,
      sortBy: json['sortBy'] as String? ?? 'due_date',
      ascending: json['ascending'] as bool? ?? true,
    );

Map<String, dynamic> _$$TaskListFilterImplToJson(
        _$TaskListFilterImpl instance) =>
    <String, dynamic>{
      'status': _$TaskStatusEnumMap[instance.status],
      'priority': _$TaskPriorityEnumMap[instance.priority],
      'propertyId': instance.propertyId,
      'propertyName': instance.propertyName,
      'overdueOnly': instance.overdueOnly,
      'search': instance.search,
      'sortBy': instance.sortBy,
      'ascending': instance.ascending,
    };

const _$TaskStatusEnumMap = {
  TaskStatus.pending: 'pending',
  TaskStatus.inProgress: 'in_progress',
  TaskStatus.completed: 'completed',
  TaskStatus.cancelled: 'cancelled',
  TaskStatus.onHold: 'on_hold',
};

const _$TaskPriorityEnumMap = {
  TaskPriority.low: 'low',
  TaskPriority.medium: 'medium',
  TaskPriority.high: 'high',
  TaskPriority.urgent: 'urgent',
};
