/// Task model for Cosmo Management
///
/// Freezed model for task data with JSON serialization.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import 'checklist_model.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

/// Task model
///
/// Represents a task/work order in the system.
@freezed
class TaskModel with _$TaskModel {
  const factory TaskModel({
    required int id,
    required String title,
    String? description,
    @JsonKey(name: 'task_type') String? taskType,
    @Default(TaskStatus.pending) TaskStatus status,
    @Default(TaskPriority.medium) TaskPriority priority,
    @JsonKey(name: 'property_id') int? propertyId,
    @JsonKey(name: 'property_name') String? propertyName,
    @JsonKey(name: 'assigned_to') int? assignedToId,
    @JsonKey(name: 'assigned_to_name') String? assignedToName,
    @JsonKey(name: 'created_by') int? createdById,
    @JsonKey(name: 'created_by_name') String? createdByName,
    @JsonKey(name: 'due_date') DateTime? dueDate,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @Default([]) List<String> images,
    String? notes,
    @JsonKey(name: 'estimated_duration') int? estimatedDurationMinutes,
    @JsonKey(name: 'actual_duration') int? actualDurationMinutes,

    /// Checklist data (when included in response)
    TaskChecklistModel? checklist,

    /// Checklist progress summary
    @JsonKey(name: 'checklist_progress') ChecklistProgressModel? checklistProgress,

    /// Whether checklist has incomplete blocking items
    @JsonKey(name: 'has_blocking_items') @Default(false) bool hasBlockingItems,
  }) = _TaskModel;

  const TaskModel._();

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);

  /// Check if task is overdue
  bool get isOverdue {
    if (dueDate == null) return false;
    if (status == TaskStatus.completed || status == TaskStatus.cancelled) {
      return false;
    }
    return DateTime.now().isAfter(dueDate!);
  }

  /// Check if task is completed
  bool get isCompleted => status == TaskStatus.completed;

  /// Check if task is in progress
  bool get isInProgress => status == TaskStatus.inProgress;

  /// Check if task is pending
  bool get isPending => status == TaskStatus.pending;

  /// Days until due (negative if overdue)
  int? get daysUntilDue {
    if (dueDate == null) return null;
    return dueDate!.difference(DateTime.now()).inDays;
  }

  /// Human-readable due date status
  String get dueDateStatus {
    if (dueDate == null) return 'No due date';
    final days = daysUntilDue!;
    if (days < 0) return 'Overdue by ${-days} day${days == -1 ? '' : 's'}';
    if (days == 0) return 'Due today';
    if (days == 1) return 'Due tomorrow';
    return 'Due in $days days';
  }
}

/// Task status enum
@JsonEnum(valueField: 'value')
enum TaskStatus {
  @JsonValue('pending')
  pending('pending', 'Pending'),
  @JsonValue('in_progress')
  inProgress('in_progress', 'In Progress'),
  @JsonValue('completed')
  completed('completed', 'Completed'),
  @JsonValue('cancelled')
  cancelled('cancelled', 'Cancelled'),
  @JsonValue('on_hold')
  onHold('on_hold', 'On Hold');

  final String value;
  final String displayName;

  const TaskStatus(this.value, this.displayName);
}

/// Task priority enum
@JsonEnum(valueField: 'value')
enum TaskPriority {
  @JsonValue('low')
  low('low', 'Low'),
  @JsonValue('medium')
  medium('medium', 'Medium'),
  @JsonValue('high')
  high('high', 'High'),
  @JsonValue('urgent')
  urgent('urgent', 'Urgent');

  final String value;
  final String displayName;

  const TaskPriority(this.value, this.displayName);
}
