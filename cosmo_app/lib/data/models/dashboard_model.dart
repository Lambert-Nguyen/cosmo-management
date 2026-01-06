/// Dashboard models for Cosmo Management
///
/// Freezed models for staff dashboard with JSON serialization.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import 'task_model.dart';

part 'dashboard_model.freezed.dart';
part 'dashboard_model.g.dart';

/// Task count by status
///
/// Summary of task counts for dashboard display.
@freezed
class TaskCountModel with _$TaskCountModel {
  const factory TaskCountModel({
    @Default(0) int pending,
    @JsonKey(name: 'in_progress') @Default(0) int inProgress,
    @Default(0) int completed,
    @Default(0) int overdue,
    @Default(0) int total,
  }) = _TaskCountModel;

  const TaskCountModel._();

  factory TaskCountModel.fromJson(Map<String, dynamic> json) =>
      _$TaskCountModelFromJson(json);

  /// Get count for a specific status
  int getCountForStatus(TaskStatus status) {
    return switch (status) {
      TaskStatus.pending => pending,
      TaskStatus.inProgress => inProgress,
      TaskStatus.completed => completed,
      TaskStatus.cancelled => 0,
      TaskStatus.onHold => 0,
    };
  }

  /// Check if there are any overdue tasks
  bool get hasOverdue => overdue > 0;

  /// Check if there are any pending tasks
  bool get hasPending => pending > 0;

  /// Check if there are any tasks needing attention
  bool get needsAttention => hasOverdue || pending > 5;
}

/// Activity log entry
///
/// Represents a recent activity for the dashboard timeline.
@freezed
class ActivityModel with _$ActivityModel {
  const factory ActivityModel({
    required int id,
    required String action,
    String? description,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'task_id') int? taskId,
    @JsonKey(name: 'task_title') String? taskTitle,
    @JsonKey(name: 'user_id') int? userId,
    @JsonKey(name: 'user_name') String? userName,
  }) = _ActivityModel;

  const ActivityModel._();

  factory ActivityModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityModelFromJson(json);

  /// Human-readable time ago string
  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(createdAt);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${(diff.inDays / 7).floor()}w ago';
  }

  /// Get display text for this activity
  String get displayText {
    if (description != null) return description!;
    if (taskTitle != null) return '$action: $taskTitle';
    return action;
  }
}

/// Staff dashboard data
///
/// Complete dashboard data for staff view.
@freezed
class StaffDashboardModel with _$StaffDashboardModel {
  const factory StaffDashboardModel({
    /// Task counts by status
    @JsonKey(name: 'task_counts') required TaskCountModel taskCounts,

    /// Tasks due today
    @JsonKey(name: 'todays_tasks') @Default([]) List<TaskModel> todaysTasks,

    /// Upcoming tasks (next 7 days)
    @JsonKey(name: 'upcoming_tasks') @Default([]) List<TaskModel> upcomingTasks,

    /// Overdue tasks requiring attention
    @JsonKey(name: 'overdue_tasks') @Default([]) List<TaskModel> overdueTasks,

    /// Recent activity log
    @JsonKey(name: 'recent_activity') @Default([]) List<ActivityModel> recentActivity,

    /// Server timestamp for sync
    @JsonKey(name: 'server_time') DateTime? serverTime,
  }) = _StaffDashboardModel;

  const StaffDashboardModel._();

  factory StaffDashboardModel.fromJson(Map<String, dynamic> json) =>
      _$StaffDashboardModelFromJson(json);

  /// Total tasks for today
  int get todaysTaskCount => todaysTasks.length;

  /// Number of today's tasks completed
  int get todaysCompletedCount =>
      todaysTasks.where((t) => t.isCompleted).length;

  /// Today's completion percentage
  double get todaysCompletionPercentage {
    if (todaysTasks.isEmpty) return 100.0;
    return (todaysCompletedCount / todaysTasks.length) * 100;
  }

  /// Check if all today's tasks are complete
  bool get isTodayComplete => todaysTasks.every((t) => t.isCompleted);

  /// Get today's tasks sorted by priority then due time
  List<TaskModel> get todaysTasksSorted {
    final sorted = List<TaskModel>.from(todaysTasks);
    sorted.sort((a, b) {
      // First by status (pending/in-progress before completed)
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      // Then by priority (urgent first)
      final priorityCompare = b.priority.index.compareTo(a.priority.index);
      if (priorityCompare != 0) return priorityCompare;
      // Then by due date
      if (a.dueDate != null && b.dueDate != null) {
        return a.dueDate!.compareTo(b.dueDate!);
      }
      return 0;
    });
    return sorted;
  }

  /// Get tasks needing immediate attention (overdue or urgent)
  List<TaskModel> get urgentTasks {
    return [
      ...overdueTasks,
      ...todaysTasks.where((t) =>
          t.priority == TaskPriority.urgent && !t.isCompleted && !t.isOverdue),
    ];
  }
}

/// Quick stat for dashboard cards
@freezed
class DashboardStatModel with _$DashboardStatModel {
  const factory DashboardStatModel({
    required String label,
    required int count,
    required String color,
    String? icon,
    TaskStatus? filterStatus,
    bool? filterOverdue,
  }) = _DashboardStatModel;

  factory DashboardStatModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardStatModelFromJson(json);

  /// Create stat cards from task counts
  static List<DashboardStatModel> fromTaskCounts(TaskCountModel counts) {
    return [
      DashboardStatModel(
        label: 'Pending',
        count: counts.pending,
        color: 'gray',
        icon: 'clock',
        filterStatus: TaskStatus.pending,
      ),
      DashboardStatModel(
        label: 'In Progress',
        count: counts.inProgress,
        color: 'blue',
        icon: 'play',
        filterStatus: TaskStatus.inProgress,
      ),
      DashboardStatModel(
        label: 'Completed',
        count: counts.completed,
        color: 'green',
        icon: 'check',
        filterStatus: TaskStatus.completed,
      ),
      DashboardStatModel(
        label: 'Overdue',
        count: counts.overdue,
        color: 'red',
        icon: 'alert',
        filterOverdue: true,
      ),
    ];
  }
}
