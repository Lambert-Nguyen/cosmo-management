/// Inventory list item widget for Cosmo Management
///
/// Displays an inventory item in a list with quantity and status.
library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/inventory_model.dart';

/// Inventory list item widget
class InventoryListItem extends StatelessWidget {
  final InventoryModel item;
  final VoidCallback? onTap;
  final VoidCallback? onTransaction;

  const InventoryListItem({
    super.key,
    required this.item,
    this.onTap,
    this.onTransaction,
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
            children: [
              // Category icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getCategoryColor(item.category).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                ),
                child: Icon(
                  _getCategoryIcon(item.category),
                  color: _getCategoryColor(item.category),
                ),
              ),
              const SizedBox(width: AppSpacing.md),

              // Item info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Row(
                      children: [
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
                  ],
                ),
              ),

              // Quantity and status
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildQuantityBadge(context),
                  const SizedBox(height: AppSpacing.xs),
                  _buildStatusChip(context),
                ],
              ),

              // Transaction button
              if (onTransaction != null) ...[
                const SizedBox(width: AppSpacing.sm),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: onTransaction,
                  tooltip: 'Log Transaction',
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityBadge(BuildContext context) {
    final theme = Theme.of(context);
    final color = item.isOutOfStock
        ? AppColors.error
        : item.isCriticallyLow
            ? AppColors.warning
            : item.isLowStock
                ? AppColors.warning.withOpacity(0.7)
                : theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.xs),
      ),
      child: Text(
        item.quantityDisplay,
        style: theme.textTheme.titleSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    final theme = Theme.of(context);

    if (item.isOutOfStock) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          'OUT',
          style: theme.textTheme.labelSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    if (item.isCriticallyLow) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          color: AppColors.warning,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          'CRITICAL',
          style: theme.textTheme.labelSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    if (item.isLowStock) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          color: AppColors.warning.withOpacity(0.7),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          'LOW',
          style: theme.textTheme.labelSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Color _getCategoryColor(InventoryCategory category) {
    return switch (category) {
      InventoryCategory.cleaningSupplies => Colors.blue,
      InventoryCategory.maintenance => Colors.orange,
      InventoryCategory.linens => Colors.purple,
      InventoryCategory.toiletries => Colors.teal,
      InventoryCategory.kitchen => Colors.green,
      InventoryCategory.outdoor => Colors.brown,
      InventoryCategory.electronics => Colors.indigo,
      InventoryCategory.furniture => Colors.amber,
      InventoryCategory.other => Colors.grey,
    };
  }

  IconData _getCategoryIcon(InventoryCategory category) {
    return switch (category) {
      InventoryCategory.cleaningSupplies => Icons.cleaning_services,
      InventoryCategory.maintenance => Icons.build,
      InventoryCategory.linens => Icons.bed,
      InventoryCategory.toiletries => Icons.soap,
      InventoryCategory.kitchen => Icons.kitchen,
      InventoryCategory.outdoor => Icons.park,
      InventoryCategory.electronics => Icons.electrical_services,
      InventoryCategory.furniture => Icons.chair,
      InventoryCategory.other => Icons.inventory_2,
    };
  }
}
