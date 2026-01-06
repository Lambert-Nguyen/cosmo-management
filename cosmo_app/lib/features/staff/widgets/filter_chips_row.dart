/// Filter chips row widget for Cosmo Management
///
/// Horizontal scrolling filter chips for task filtering.
library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/task_model.dart';

/// Filter chip data
class FilterChipData {
  const FilterChipData({
    required this.label,
    required this.value,
    this.icon,
    this.color,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color? color;
}

/// Horizontal filter chips row
class FilterChipsRow extends StatelessWidget {
  const FilterChipsRow({
    super.key,
    required this.chips,
    required this.selectedValues,
    required this.onChipTap,
    this.showClearAll = true,
    this.onClearAll,
  });

  final List<FilterChipData> chips;
  final Set<String> selectedValues;
  final void Function(String value) onChipTap;
  final bool showClearAll;
  final VoidCallback? onClearAll;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: chips.length + (showClearAll && selectedValues.isNotEmpty ? 1 : 0),
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.xs),
        itemBuilder: (context, index) {
          if (showClearAll && selectedValues.isNotEmpty && index == 0) {
            return ActionChip(
              label: const Text('Clear'),
              avatar: const Icon(Icons.clear, size: 16),
              onPressed: onClearAll,
            );
          }

          final chipIndex = showClearAll && selectedValues.isNotEmpty ? index - 1 : index;
          final chip = chips[chipIndex];
          final isSelected = selectedValues.contains(chip.value);

          return FilterChip(
            label: Text(chip.label),
            avatar: chip.icon != null
                ? Icon(
                    chip.icon,
                    size: 16,
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : chip.color,
                  )
                : null,
            selected: isSelected,
            selectedColor: chip.color ?? Theme.of(context).colorScheme.primary,
            checkmarkColor: Theme.of(context).colorScheme.onPrimary,
            onSelected: (_) => onChipTap(chip.value),
          );
        },
      ),
    );
  }
}

/// Task status filter chips
class TaskStatusFilterChips extends StatelessWidget {
  const TaskStatusFilterChips({
    super.key,
    required this.selectedStatus,
    required this.onStatusSelected,
    this.showOverdue = true,
    this.isOverdueSelected = false,
    this.onOverdueSelected,
  });

  final TaskStatus? selectedStatus;
  final void Function(TaskStatus?) onStatusSelected;
  final bool showOverdue;
  final bool isOverdueSelected;
  final void Function(bool)? onOverdueSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        children: [
          // All chip
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.xs),
            child: FilterChip(
              label: const Text('All'),
              selected: selectedStatus == null && !isOverdueSelected,
              onSelected: (_) {
                onStatusSelected(null);
                onOverdueSelected?.call(false);
              },
            ),
          ),

          // Status chips
          for (final status in TaskStatus.values.where((s) =>
              s != TaskStatus.cancelled && s != TaskStatus.onHold)) ...[
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.xs),
              child: FilterChip(
                label: Text(status.displayName),
                avatar: Icon(
                  _getStatusIcon(status),
                  size: 16,
                  color: selectedStatus == status
                      ? Theme.of(context).colorScheme.onPrimary
                      : _getStatusColor(status),
                ),
                selected: selectedStatus == status,
                selectedColor: _getStatusColor(status),
                checkmarkColor: Theme.of(context).colorScheme.onPrimary,
                onSelected: (_) {
                  onStatusSelected(
                    selectedStatus == status ? null : status,
                  );
                  if (status != selectedStatus) {
                    onOverdueSelected?.call(false);
                  }
                },
              ),
            ),
          ],

          // Overdue chip
          if (showOverdue)
            FilterChip(
              label: const Text('Overdue'),
              avatar: Icon(
                Icons.warning_amber_rounded,
                size: 16,
                color: isOverdueSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : AppColors.taskOverdue,
              ),
              selected: isOverdueSelected,
              selectedColor: AppColors.taskOverdue,
              checkmarkColor: Theme.of(context).colorScheme.onPrimary,
              onSelected: (selected) {
                onOverdueSelected?.call(selected);
                if (selected) onStatusSelected(null);
              },
            ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(TaskStatus status) {
    return switch (status) {
      TaskStatus.pending => Icons.schedule,
      TaskStatus.inProgress => Icons.play_circle_outline,
      TaskStatus.completed => Icons.check_circle_outline,
      TaskStatus.cancelled => Icons.cancel_outlined,
      TaskStatus.onHold => Icons.pause_circle_outline,
    };
  }

  Color _getStatusColor(TaskStatus status) {
    return switch (status) {
      TaskStatus.pending => AppColors.taskPending,
      TaskStatus.inProgress => AppColors.taskInProgress,
      TaskStatus.completed => AppColors.taskCompleted,
      TaskStatus.cancelled => AppColors.taskCancelled,
      TaskStatus.onHold => AppColors.taskPending,
    };
  }
}

/// Task priority filter chips
class TaskPriorityFilterChips extends StatelessWidget {
  const TaskPriorityFilterChips({
    super.key,
    required this.selectedPriority,
    required this.onPrioritySelected,
  });

  final TaskPriority? selectedPriority;
  final void Function(TaskPriority?) onPrioritySelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: [
        for (final priority in TaskPriority.values)
          FilterChip(
            label: Text(priority.displayName),
            selected: selectedPriority == priority,
            selectedColor: _getPriorityColor(priority),
            checkmarkColor: Theme.of(context).colorScheme.onPrimary,
            onSelected: (_) {
              onPrioritySelected(
                selectedPriority == priority ? null : priority,
              );
            },
          ),
      ],
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    return switch (priority) {
      TaskPriority.low => AppColors.priorityLow,
      TaskPriority.medium => AppColors.priorityMedium,
      TaskPriority.high => AppColors.priorityHigh,
      TaskPriority.urgent => AppColors.priorityUrgent,
    };
  }
}
