// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskCountModelImpl _$$TaskCountModelImplFromJson(Map<String, dynamic> json) =>
    _$TaskCountModelImpl(
      pending: (json['pending'] as num?)?.toInt() ?? 0,
      inProgress: (json['in_progress'] as num?)?.toInt() ?? 0,
      completed: (json['completed'] as num?)?.toInt() ?? 0,
      overdue: (json['overdue'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$TaskCountModelImplToJson(
        _$TaskCountModelImpl instance) =>
    <String, dynamic>{
      'pending': instance.pending,
      'in_progress': instance.inProgress,
      'completed': instance.completed,
      'overdue': instance.overdue,
      'total': instance.total,
    };

_$ActivityModelImpl _$$ActivityModelImplFromJson(Map<String, dynamic> json) =>
    _$ActivityModelImpl(
      id: (json['id'] as num).toInt(),
      action: json['action'] as String,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      taskId: (json['task_id'] as num?)?.toInt(),
      taskTitle: json['task_title'] as String?,
      userId: (json['user_id'] as num?)?.toInt(),
      userName: json['user_name'] as String?,
    );

Map<String, dynamic> _$$ActivityModelImplToJson(_$ActivityModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'action': instance.action,
      'description': instance.description,
      'created_at': instance.createdAt.toIso8601String(),
      'task_id': instance.taskId,
      'task_title': instance.taskTitle,
      'user_id': instance.userId,
      'user_name': instance.userName,
    };

_$StaffDashboardModelImpl _$$StaffDashboardModelImplFromJson(
        Map<String, dynamic> json) =>
    _$StaffDashboardModelImpl(
      taskCounts:
          TaskCountModel.fromJson(json['task_counts'] as Map<String, dynamic>),
      todaysTasks: (json['todays_tasks'] as List<dynamic>?)
              ?.map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      upcomingTasks: (json['upcoming_tasks'] as List<dynamic>?)
              ?.map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      overdueTasks: (json['overdue_tasks'] as List<dynamic>?)
              ?.map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      recentActivity: (json['recent_activity'] as List<dynamic>?)
              ?.map((e) => ActivityModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      serverTime: json['server_time'] == null
          ? null
          : DateTime.parse(json['server_time'] as String),
    );

Map<String, dynamic> _$$StaffDashboardModelImplToJson(
        _$StaffDashboardModelImpl instance) =>
    <String, dynamic>{
      'task_counts': instance.taskCounts,
      'todays_tasks': instance.todaysTasks,
      'upcoming_tasks': instance.upcomingTasks,
      'overdue_tasks': instance.overdueTasks,
      'recent_activity': instance.recentActivity,
      'server_time': instance.serverTime?.toIso8601String(),
    };

_$DashboardStatModelImpl _$$DashboardStatModelImplFromJson(
        Map<String, dynamic> json) =>
    _$DashboardStatModelImpl(
      label: json['label'] as String,
      count: (json['count'] as num).toInt(),
      color: json['color'] as String,
      icon: json['icon'] as String?,
      filterStatus:
          $enumDecodeNullable(_$TaskStatusEnumMap, json['filterStatus']),
      filterOverdue: json['filterOverdue'] as bool?,
    );

Map<String, dynamic> _$$DashboardStatModelImplToJson(
        _$DashboardStatModelImpl instance) =>
    <String, dynamic>{
      'label': instance.label,
      'count': instance.count,
      'color': instance.color,
      'icon': instance.icon,
      'filterStatus': _$TaskStatusEnumMap[instance.filterStatus],
      'filterOverdue': instance.filterOverdue,
    };

const _$TaskStatusEnumMap = {
  TaskStatus.pending: 'pending',
  TaskStatus.inProgress: 'in_progress',
  TaskStatus.completed: 'completed',
  TaskStatus.cancelled: 'cancelled',
  TaskStatus.onHold: 'on_hold',
};
