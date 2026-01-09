/// Lost & Found list item widget for Cosmo Management
///
/// Displays a lost/found item in a list with status and actions.
library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/lost_found_model.dart';
import 'lost_found_status_badge.dart';

/// Lost & Found list item widget
class LostFoundListItem extends StatelessWidget {
  final LostFoundModel item;
  final VoidCallback? onTap;
  final VoidCallback? onClaim;

  const LostFoundListItem({
    super.key,
    required this.item,
    this.onTap,
    this.onClaim,
  });

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
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category icon or photo thumbnail
              _buildThumbnail(context),
              const SizedBox(width: AppSpacing.md),

              // Item info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and status
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        LostFoundStatusBadge(status: item.status),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxs),

                    // Category and location
                    Row(
                      children: [
                        Icon(
                          _getCategoryIcon(item.category),
                          size: 14,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: AppSpacing.xxs),
                        Text(
                          item.category.displayName,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        if (item.propertyName != null) ...[
                          Text(
                            ' • ',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              item.propertyName!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),

                    // Description preview
                    if (item.description != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        item.description!,
                        style: theme.textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                    // Time and indicators
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        // Time indicator
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: AppSpacing.xxs),
                        Text(
                          _getTimeDisplay(),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),

                        // Valuable indicator
                        if (item.isValuable) ...[
                          const SizedBox(width: AppSpacing.sm),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.xs,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.warning.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.diamond_outlined,
                                  size: 12,
                                  color: AppColors.warning,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  'Valuable',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: AppColors.warning,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        // Expiring soon indicator
                        if (item.isExpiringSoon) ...[
                          const SizedBox(width: AppSpacing.sm),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.xs,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Expiring',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: AppColors.error,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],

                        // Photos indicator
                        if (item.hasPhotos) ...[
                          const SizedBox(width: AppSpacing.sm),
                          Icon(
                            Icons.photo_library_outlined,
                            size: 14,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${item.images.length}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Claim button
              if (onClaim != null) ...[
                const SizedBox(width: AppSpacing.sm),
                IconButton(
                  icon: const Icon(Icons.check_circle_outline),
                  onPressed: onClaim,
                  tooltip: 'Claim Item',
                  color: AppColors.success,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context) {
    final theme = Theme.of(context);

    if (item.hasPhotos) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        child: Image.network(
          item.images.first,
          width: 56,
          height: 56,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildCategoryIcon(context),
        ),
      );
    }

    return _buildCategoryIcon(context);
  }

  Widget _buildCategoryIcon(BuildContext context) {
    final color = _getCategoryColor(item.category);
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      child: Icon(
        _getCategoryIcon(item.category),
        color: color,
        size: 28,
      ),
    );
  }

  String _getTimeDisplay() {
    final days = item.daysSinceReported;
    if (days == 0) return 'Today';
    if (days == 1) return 'Yesterday';
    if (days < 7) return '$days days ago';
    if (days < 30) return '${days ~/ 7} weeks ago';
    return '${days ~/ 30} months ago';
  }

  Color _getCategoryColor(LostFoundCategory category) {
    return switch (category) {
      LostFoundCategory.keys => Colors.amber,
      LostFoundCategory.documents => Colors.blue,
      LostFoundCategory.electronics => Colors.indigo,
      LostFoundCategory.clothing => Colors.purple,
      LostFoundCategory.jewelry => Colors.pink,
      LostFoundCategory.bags => Colors.brown,
      LostFoundCategory.personal => Colors.teal,
      LostFoundCategory.valuables => Colors.orange,
      LostFoundCategory.other => Colors.grey,
    };
  }

  IconData _getCategoryIcon(LostFoundCategory category) {
    return switch (category) {
      LostFoundCategory.keys => Icons.key,
      LostFoundCategory.documents => Icons.description,
      LostFoundCategory.electronics => Icons.devices,
      LostFoundCategory.clothing => Icons.checkroom,
      LostFoundCategory.jewelry => Icons.diamond,
      LostFoundCategory.bags => Icons.luggage,
      LostFoundCategory.personal => Icons.person,
      LostFoundCategory.valuables => Icons.attach_money,
      LostFoundCategory.other => Icons.category,
    };
  }
}
