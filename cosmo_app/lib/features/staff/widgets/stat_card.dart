/// Stat card widget for Cosmo Management
///
/// Displays a statistic with count, label, and icon.
library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

/// Stat card for dashboard
///
/// Displays a count with label, icon, and color.
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.label,
    required this.count,
    this.icon,
    this.color,
    this.onTap,
    this.isSelected = false,
  });

  final String label;
  final int count;
  final IconData? icon;
  final Color? color;
  final VoidCallback? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = color ?? AppColors.primary;

    return Card(
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected
            ? BorderSide(color: cardColor, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (icon != null)
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.xs),
                      decoration: BoxDecoration(
                        color: cardColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        icon,
                        color: cardColor,
                        size: 20,
                      ),
                    ),
                  if (onTap != null)
                    Icon(
                      Icons.chevron_right,
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                count.toString(),
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cardColor,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Horizontal row of stat cards
class StatCardsRow extends StatelessWidget {
  const StatCardsRow({
    super.key,
    required this.stats,
    this.selectedIndex,
    this.onStatTap,
  });

  final List<StatCardData> stats;
  final int? selectedIndex;
  final void Function(int index)? onStatTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: stats.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final stat = stats[index];
          return SizedBox(
            width: 100,
            child: StatCard(
              label: stat.label,
              count: stat.count,
              icon: stat.icon,
              color: stat.color,
              isSelected: selectedIndex == index,
              onTap: onStatTap != null ? () => onStatTap!(index) : null,
            ),
          );
        },
      ),
    );
  }
}

/// Data for a stat card
class StatCardData {
  const StatCardData({
    required this.label,
    required this.count,
    this.icon,
    this.color,
  });

  final String label;
  final int count;
  final IconData? icon;
  final Color? color;

  /// Create default dashboard stats
  static List<StatCardData> dashboardStats({
    required int pending,
    required int inProgress,
    required int completed,
    required int overdue,
  }) {
    return [
      StatCardData(
        label: 'Pending',
        count: pending,
        icon: Icons.schedule,
        color: AppColors.taskPending,
      ),
      StatCardData(
        label: 'In Progress',
        count: inProgress,
        icon: Icons.play_circle_outline,
        color: AppColors.taskInProgress,
      ),
      StatCardData(
        label: 'Completed',
        count: completed,
        icon: Icons.check_circle_outline,
        color: AppColors.taskCompleted,
      ),
      StatCardData(
        label: 'Overdue',
        count: overdue,
        icon: Icons.warning_amber_rounded,
        color: AppColors.taskOverdue,
      ),
    ];
  }
}
