/// Lost & Found status badge widget for Cosmo Management
///
/// Displays a colored badge indicating the status of a lost/found item.
library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/lost_found_model.dart';

/// Lost & Found status badge widget
class LostFoundStatusBadge extends StatelessWidget {
  final LostFoundStatus status;
  final bool showIcon;
  final bool compact;

  const LostFoundStatusBadge({
    super.key,
    required this.status,
    this.showIcon = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (color, bgColor, icon) = _getStatusStyle();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? AppSpacing.xs : AppSpacing.sm,
        vertical: compact ? 2 : AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(compact ? 4 : 6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(icon, size: compact ? 12 : 14, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            status.displayName.toUpperCase(),
            style: (compact ? theme.textTheme.labelSmall : theme.textTheme.labelMedium)
                ?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  (Color, Color, IconData) _getStatusStyle() {
    return switch (status) {
      LostFoundStatus.lost => (
          AppColors.error,
          AppColors.error.withOpacity(0.1),
          Icons.search_off,
        ),
      LostFoundStatus.found => (
          AppColors.info,
          AppColors.info.withOpacity(0.1),
          Icons.find_in_page,
        ),
      LostFoundStatus.claimed => (
          AppColors.success,
          AppColors.success.withOpacity(0.1),
          Icons.check_circle_outline,
        ),
      LostFoundStatus.archived => (
          Colors.grey,
          Colors.grey.withOpacity(0.1),
          Icons.archive,
        ),
      LostFoundStatus.expired => (
          AppColors.warning,
          AppColors.warning.withOpacity(0.1),
          Icons.timer_off,
        ),
    };
  }
}

/// Status icon widget (without text)
class LostFoundStatusIcon extends StatelessWidget {
  final LostFoundStatus status;
  final double size;

  const LostFoundStatusIcon({
    super.key,
    required this.status,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    final (color, _, icon) = _getStatusInfo();
    return Icon(icon, color: color, size: size);
  }

  (Color, Color, IconData) _getStatusInfo() {
    return switch (status) {
      LostFoundStatus.lost => (AppColors.error, AppColors.error, Icons.search_off),
      LostFoundStatus.found => (AppColors.info, AppColors.info, Icons.find_in_page),
      LostFoundStatus.claimed => (AppColors.success, AppColors.success, Icons.check_circle),
      LostFoundStatus.archived => (Colors.grey, Colors.grey, Icons.archive),
      LostFoundStatus.expired => (AppColors.warning, AppColors.warning, Icons.timer_off),
    };
  }
}
