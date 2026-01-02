/// Task detail screen for Cosmo Management
///
/// Shows full task details with checklist.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/service_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../data/models/task_model.dart';
import '../../../router/route_names.dart';
import '../providers/staff_providers.dart';
import '../widgets/checklist_section.dart';
import '../widgets/sync_indicator.dart';
import 'staff_shell.dart';

/// Task detail screen
///
/// Shows task details, status actions, and checklist.
class TaskDetailScreen extends ConsumerWidget {
  const TaskDetailScreen({
    super.key,
    required this.taskId,
  });

  final int taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(taskDetailProvider(taskId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          const SyncIndicatorButton(),
          PopupMenuButton<String>(
            onSelected: (value) => _onMenuAction(context, ref, value),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Edit'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'duplicate',
                child: ListTile(
                  leading: Icon(Icons.copy),
                  title: Text('Duplicate'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'delete',
                child: ListTile(
                  leading: Icon(Icons.delete, color: AppColors.error),
                  title: Text('Delete', style: TextStyle(color: AppColors.error)),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: switch (taskState) {
        TaskDetailInitial() ||
        TaskDetailLoading() =>
          const StaffLoadingState(message: 'Loading task...'),
        TaskDetailError(message: final msg) => StaffErrorState(
            message: msg,
            onRetry: () =>
                ref.read(taskDetailProvider(taskId).notifier).load(),
          ),
        TaskDetailLoaded(
          task: final task,
          checklist: final checklist,
          isOffline: final isOffline,
        ) =>
          RefreshIndicator(
            onRefresh: () =>
                ref.read(taskDetailProvider(taskId).notifier).load(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header card
                  _TaskHeaderCard(task: task),

                  // Status action buttons
                  _StatusActionButtons(
                    task: task,
                    onStatusChange: (status) => ref
                        .read(taskDetailProvider(taskId).notifier)
                        .updateStatus(status),
                  ),

                  // Description
                  if (task.description != null &&
                      task.description!.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    _DescriptionSection(description: task.description!),
                  ],

                  // Checklist
                  if (checklist != null && checklist.items.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    ChecklistSection(
                      checklist: checklist,
                      isOffline: isOffline,
                      onItemCompleted: (itemId, completed) => ref
                          .read(taskDetailProvider(taskId).notifier)
                          .submitChecklistResponse(
                            checklistItemId: itemId,
                            isCompleted: completed,
                          ),
                      onTextSubmitted: (itemId, text) => ref
                          .read(taskDetailProvider(taskId).notifier)
                          .submitChecklistResponse(
                            checklistItemId: itemId,
                            textValue: text,
                          ),
                      onNumberSubmitted: (itemId, number) => ref
                          .read(taskDetailProvider(taskId).notifier)
                          .submitChecklistResponse(
                            checklistItemId: itemId,
                            numberValue: number,
                          ),
                      onPhotoTaken: (itemId, path) {
                        if (path.isEmpty) return; // Skip if clearing photo
                        ref
                            .read(taskDetailProvider(taskId).notifier)
                            .uploadChecklistPhoto(
                              checklistItemId: itemId,
                              filePath: path,
                            );
                      },
                    ),
                  ],

                  // Notes section
                  if (task.notes != null && task.notes!.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    _NotesSection(notes: task.notes!),
                  ],
                ],
              ),
            ),
          ),
        TaskDetailActionLoading(task: final task) => Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TaskHeaderCard(task: task),
                    _StatusActionButtons(
                      task: task,
                      onStatusChange: (_) {},
                      enabled: false,
                    ),
                  ],
                ),
              ),
              const Positioned.fill(
                child: ColoredBox(
                  color: Colors.black26,
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
            ],
          ),
      },
    );
  }

  void _onMenuAction(BuildContext context, WidgetRef ref, String action) {
    switch (action) {
      case 'edit':
        context.push(RouteNames.staffTaskEdit(taskId));
      case 'duplicate':
        _duplicateTask(context, ref);
      case 'delete':
        _confirmDelete(context, ref);
    }
  }

  Future<void> _duplicateTask(BuildContext context, WidgetRef ref) async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final taskRepository = ref.read(taskRepositoryProvider);
      final newTask = await taskRepository.duplicateTask(taskId);

      // Refresh task list
      ref.read(taskListProvider.notifier).loadTasks(refresh: true);

      // Refresh dashboard
      ref.read(staffDashboardProvider.notifier).refresh();

      if (context.mounted) {
        // Close loading dialog
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Task duplicated successfully'),
            action: SnackBarAction(
              label: 'View',
              onPressed: () => context.push(RouteNames.staffTaskDetail(newTask.id)),
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        // Close loading dialog
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error duplicating task: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text(
          'Are you sure you want to delete this task? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        final taskRepository = ref.read(taskRepositoryProvider);
        await taskRepository.deleteTask(taskId);

        // Remove from task list locally
        ref.read(taskListProvider.notifier).removeTaskLocally(taskId);

        // Refresh dashboard
        ref.read(staffDashboardProvider.notifier).refresh();

        if (context.mounted) {
          // Close loading dialog
          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Task deleted successfully')),
          );

          // Go back to task list
          context.pop();
        }
      } catch (e) {
        if (context.mounted) {
          // Close loading dialog
          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting task: $e'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }
}

/// Task header card with key info
class _TaskHeaderCard extends StatelessWidget {
  const _TaskHeaderCard({required this.task});

  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.all(AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status and priority badges
            Row(
              children: [
                StatusBadge.taskStatus(task.status.value),
                const SizedBox(width: AppSpacing.xs),
                StatusBadge.priority(task.priority.value),
                const Spacer(),
                if (task.checklistProgress != null)
                  _buildChecklistProgress(context),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            // Title
            Text(
              task.title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),

            // Property
            if (task.propertyName != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Icon(
                    Icons.home_outlined,
                    size: 18,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    task.propertyName!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],

            // Assignee
            if (task.assignedToName != null) ...[
              const SizedBox(height: AppSpacing.xxs),
              Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 18,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    task.assignedToName!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],

            // Due date
            if (task.dueDate != null) ...[
              const SizedBox(height: AppSpacing.xxs),
              Row(
                children: [
                  Icon(
                    task.isOverdue
                        ? Icons.warning_amber_rounded
                        : Icons.schedule,
                    size: 18,
                    color: task.isOverdue
                        ? AppColors.error
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    task.dueDateStatus,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: task.isOverdue
                          ? AppColors.error
                          : theme.colorScheme.onSurfaceVariant,
                      fontWeight: task.isOverdue ? FontWeight.w600 : null,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildChecklistProgress(BuildContext context) {
    final progress = task.checklistProgress!;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: progress.isComplete
            ? AppColors.success.withValues(alpha: 0.1)
            : AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.checklist,
            size: 14,
            color: progress.isComplete ? AppColors.success : AppColors.primary,
          ),
          const SizedBox(width: 4),
          Text(
            progress.displayString,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: progress.isComplete
                      ? AppColors.success
                      : AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

/// Status action buttons
class _StatusActionButtons extends StatelessWidget {
  const _StatusActionButtons({
    required this.task,
    required this.onStatusChange,
    this.enabled = true,
  });

  final TaskModel task;
  final void Function(TaskStatus status) onStatusChange;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final availableStatuses = _getAvailableStatuses();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [
          for (final status in availableStatuses)
            _StatusButton(
              status: status,
              isSelected: task.status == status,
              onPressed: enabled ? () => onStatusChange(status) : null,
            ),
        ],
      ),
    );
  }

  List<TaskStatus> _getAvailableStatuses() {
    return switch (task.status) {
      TaskStatus.pending => [
          TaskStatus.pending,
          TaskStatus.inProgress,
        ],
      TaskStatus.inProgress => [
          TaskStatus.inProgress,
          TaskStatus.completed,
          TaskStatus.onHold,
        ],
      TaskStatus.onHold => [
          TaskStatus.onHold,
          TaskStatus.inProgress,
          TaskStatus.cancelled,
        ],
      TaskStatus.completed => [
          TaskStatus.completed,
          TaskStatus.inProgress,
        ],
      TaskStatus.cancelled => [
          TaskStatus.cancelled,
          TaskStatus.pending,
        ],
    };
  }
}

/// Individual status button
class _StatusButton extends StatelessWidget {
  const _StatusButton({
    required this.status,
    required this.isSelected,
    this.onPressed,
  });

  final TaskStatus status;
  final bool isSelected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor();

    return isSelected
        ? FilledButton.icon(
            onPressed: null,
            icon: Icon(_getStatusIcon(), size: 18),
            label: Text(status.displayName),
            style: FilledButton.styleFrom(
              backgroundColor: color,
              disabledBackgroundColor: color,
              disabledForegroundColor: Colors.white,
            ),
          )
        : OutlinedButton.icon(
            onPressed: onPressed,
            icon: Icon(_getStatusIcon(), size: 18),
            label: Text(status.displayName),
            style: OutlinedButton.styleFrom(
              foregroundColor: color,
              side: BorderSide(color: color),
            ),
          );
  }

  IconData _getStatusIcon() {
    return switch (status) {
      TaskStatus.pending => Icons.schedule,
      TaskStatus.inProgress => Icons.play_circle_outline,
      TaskStatus.completed => Icons.check_circle_outline,
      TaskStatus.cancelled => Icons.cancel_outlined,
      TaskStatus.onHold => Icons.pause_circle_outline,
    };
  }

  Color _getStatusColor() {
    return switch (status) {
      TaskStatus.pending => AppColors.taskPending,
      TaskStatus.inProgress => AppColors.taskInProgress,
      TaskStatus.completed => AppColors.taskCompleted,
      TaskStatus.cancelled => AppColors.taskCancelled,
      TaskStatus.onHold => AppColors.taskPending,
    };
  }
}

/// Description section
class _DescriptionSection extends StatelessWidget {
  const _DescriptionSection({required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

/// Notes section
class _NotesSection extends StatelessWidget {
  const _NotesSection({required this.notes});

  final String notes;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notes',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber.shade200),
            ),
            child: Text(
              notes,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
