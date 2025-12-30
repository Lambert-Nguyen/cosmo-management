/// Status badge widget for Cosmo Management
library;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Status badge for displaying status indicators
///
/// Used for task status, priority levels, and notification badges.
class StatusBadge extends StatelessWidget {
  /// Badge label
  final String label;

  /// Badge color
  final Color color;

  /// Text color (defaults to white or black based on color brightness)
  final Color? textColor;

  /// Badge size
  final BadgeSize size;

  /// Whether to show as outlined style
  final bool outlined;

  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.textColor,
    this.size = BadgeSize.medium,
    this.outlined = false,
  });

  /// Create a status badge from task status
  factory StatusBadge.taskStatus(String status) {
    final (color, label) = switch (status.toLowerCase()) {
      'pending' => (AppColors.taskPending, 'Pending'),
      'in_progress' || 'in progress' => (AppColors.taskInProgress, 'In Progress'),
      'completed' => (AppColors.taskCompleted, 'Completed'),
      'cancelled' => (AppColors.taskCancelled, 'Cancelled'),
      'overdue' => (AppColors.taskOverdue, 'Overdue'),
      _ => (AppColors.taskPending, status),
    };
    return StatusBadge(label: label, color: color);
  }

  /// Create a priority badge
  factory StatusBadge.priority(String priority) {
    final (color, label) = switch (priority.toLowerCase()) {
      'low' => (AppColors.priorityLow, 'Low'),
      'medium' => (AppColors.priorityMedium, 'Medium'),
      'high' => (AppColors.priorityHigh, 'High'),
      'urgent' => (AppColors.priorityUrgent, 'Urgent'),
      _ => (AppColors.priorityLow, priority),
    };
    return StatusBadge(label: label, color: color);
  }

  @override
  Widget build(BuildContext context) {
    final (fontSize, paddingH, paddingV) = switch (size) {
      BadgeSize.small => (10.0, AppSpacing.xs, 2.0),
      BadgeSize.medium => (12.0, AppSpacing.sm, AppSpacing.xxs),
      BadgeSize.large => (14.0, AppSpacing.md, AppSpacing.xs),
    };

    final effectiveTextColor = textColor ??
        (color.computeLuminance() > 0.5 ? Colors.black : Colors.white);

    if (outlined) {
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: paddingH,
          vertical: paddingV,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: color),
          borderRadius: AppSpacing.borderRadiusSm,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: paddingH,
        vertical: paddingV,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: AppSpacing.borderRadiusSm,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
          color: effectiveTextColor,
        ),
      ),
    );
  }
}

/// Notification count badge
///
/// Shows unread count on icons or avatars.
class CountBadge extends StatelessWidget {
  /// Count to display
  final int count;

  /// Maximum count before showing "99+"
  final int maxCount;

  /// Badge color
  final Color? color;

  /// Whether to show when count is zero
  final bool showZero;

  const CountBadge({
    super.key,
    required this.count,
    this.maxCount = 99,
    this.color,
    this.showZero = false,
  });

  @override
  Widget build(BuildContext context) {
    if (count == 0 && !showZero) {
      return const SizedBox.shrink();
    }

    final displayText = count > maxCount ? '$maxCount+' : count.toString();
    final badgeColor = color ?? Theme.of(context).colorScheme.error;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 2,
      ),
      constraints: const BoxConstraints(minWidth: 18),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Text(
        displayText,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// Badge size variants
enum BadgeSize {
  small,
  medium,
  large,
}
