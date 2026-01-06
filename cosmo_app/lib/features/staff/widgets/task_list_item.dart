/// Task list item widget for Cosmo Management
///
/// Displays a task in a list with status, priority, and due date.
library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/models/task_model.dart';

/// Task list item
///
/// Compact card showing task summary for lists.
class TaskListItem extends StatelessWidget {
  const TaskListItem({
    super.key,
    required this.task,
    this.onTap,
    this.onStatusTap,
    this.showProperty = true,
    this.showAssignee = false,
    this.trailing,
  });

  final TaskModel task;
  final VoidCallback? onTap;
  final VoidCallback? onStatusTap;
  final bool showProperty;
  final bool showAssignee;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with status and priority
              Row(
                children: [
                  StatusBadge.taskStatus(task.status.value),
                  const SizedBox(width: AppSpacing.xs),
                  StatusBadge.priority(task.priority.value),
                  const Spacer(),
                  if (task.checklistProgress != null)
                    _buildProgressIndicator(context),
                  if (trailing != null) trailing!,
                ],
              ),
              const SizedBox(height: AppSpacing.sm),

              // Title
              Text(
                task.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  decoration: task.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              // Property name
              if (showProperty && task.propertyName != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Icon(
                      Icons.home_outlined,
                      size: 14,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: AppSpacing.xxs),
                    Expanded(
                      child: Text(
                        task.propertyName!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],

              // Assignee
              if (showAssignee && task.assignedToName != null) ...[
                const SizedBox(height: AppSpacing.xxs),
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 14,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: AppSpacing.xxs),
                    Expanded(
                      child: Text(
                        task.assignedToName!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],

              // Due date
              if (task.dueDate != null) ...[
                const SizedBox(height: AppSpacing.sm),
                _buildDueDate(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDueDate(BuildContext context) {
    final theme = Theme.of(context);
    final color = task.isOverdue
        ? AppColors.error
        : task.daysUntilDue != null && task.daysUntilDue! <= 1
            ? AppColors.warning
            : theme.colorScheme.onSurfaceVariant;

    return Row(
      children: [
        Icon(
          task.isOverdue ? Icons.warning_amber_rounded : Icons.schedule,
          size: 14,
          color: color,
        ),
        const SizedBox(width: AppSpacing.xxs),
        Text(
          task.dueDateStatus,
          style: theme.textTheme.bodySmall?.copyWith(
            color: color,
            fontWeight: task.isOverdue ? FontWeight.w600 : null,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    final progress = task.checklistProgress!;
    final percentage = progress.percentage / 100;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 40,
          height: 4,
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation(
              percentage >= 1.0 ? AppColors.success : AppColors.primary,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xxs),
        Text(
          progress.displayString,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}

/// Compact version of task list item for dashboard
class TaskListItemCompact extends StatelessWidget {
  const TaskListItemCompact({
    super.key,
    required this.task,
    this.onTap,
  });

  final TaskModel task;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xxs,
      ),
      leading: _buildStatusIcon(),
      title: Text(
        task.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodyMedium?.copyWith(
          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: task.dueDate != null
          ? Text(
              task.dueDateStatus,
              style: theme.textTheme.bodySmall?.copyWith(
                color: task.isOverdue ? AppColors.error : null,
              ),
            )
          : null,
      trailing: StatusBadge.priority(task.priority.value),
    );
  }

  Widget _buildStatusIcon() {
    final color = switch (task.status) {
      TaskStatus.completed => AppColors.taskCompleted,
      TaskStatus.inProgress => AppColors.taskInProgress,
      TaskStatus.pending => AppColors.taskPending,
      TaskStatus.cancelled => AppColors.taskCancelled,
      TaskStatus.onHold => AppColors.taskPending,
    };

    final icon = switch (task.status) {
      TaskStatus.completed => Icons.check_circle,
      TaskStatus.inProgress => Icons.play_circle_filled,
      TaskStatus.pending => Icons.circle_outlined,
      TaskStatus.cancelled => Icons.cancel,
      TaskStatus.onHold => Icons.pause_circle,
    };

    return Icon(icon, color: color, size: 24);
  }
}
