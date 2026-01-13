/// Property card widget for Cosmo Management Portal
///
/// Displays property information in a card format.
library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/property_model.dart';

/// Property card widget
///
/// Displays property summary with image, name, address, and status.
class PropertyCard extends StatelessWidget {
  const PropertyCard({
    super.key,
    required this.property,
    this.onTap,
  });

  final PropertyModel property;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property image or placeholder
            AspectRatio(
              aspectRatio: 16 / 9,
              child: property.primaryImage != null
                  ? Image.network(
                      property.primaryImage!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildPlaceholder(theme),
                    )
                  : _buildPlaceholder(theme),
            ),

            // Property info
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and status
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          property.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _StatusBadge(status: property.status),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.xs),

                  // Address
                  if (property.shortAddress.isNotEmpty)
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: AppSpacing.xxs),
                        Expanded(
                          child: Text(
                            property.shortAddress,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: AppSpacing.xs),

                  // Property details row
                  Row(
                    children: [
                      if (property.bedrooms != null) ...[
                        _PropertyDetail(
                          icon: Icons.bed_outlined,
                          text: '${property.bedrooms}',
                        ),
                        const SizedBox(width: AppSpacing.md),
                      ],
                      if (property.bathrooms != null) ...[
                        _PropertyDetail(
                          icon: Icons.bathtub_outlined,
                          text: '${property.bathrooms}',
                        ),
                        const SizedBox(width: AppSpacing.md),
                      ],
                      if (property.maxOccupancy != null)
                        _PropertyDetail(
                          icon: Icons.people_outline,
                          text: '${property.maxOccupancy}',
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.home_work_outlined,
          size: 48,
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}

/// Status badge widget
class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final PropertyStatus status;

  @override
  Widget build(BuildContext context) {
    final (color, bgColor) = switch (status) {
      PropertyStatus.available => (AppColors.success, AppColors.successContainer),
      PropertyStatus.occupied => (AppColors.info, AppColors.infoContainer),
      PropertyStatus.maintenance => (AppColors.warning, AppColors.warningContainer),
      PropertyStatus.reserved => (AppColors.primary, AppColors.primaryContainer),
      PropertyStatus.inactive => (AppColors.error, AppColors.errorContainer),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.displayName,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

/// Property detail chip
class _PropertyDetail extends StatelessWidget {
  const _PropertyDetail({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: AppSpacing.xxs),
        Text(
          text,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Compact property card for lists
class PropertyCardCompact extends StatelessWidget {
  const PropertyCardCompact({
    super.key,
    required this.property,
    this.onTap,
    this.trailing,
  });

  final PropertyModel property;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: ListTile(
        onTap: onTap,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 56,
            height: 56,
            child: property.primaryImage != null
                ? Image.network(
                    property.primaryImage!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildPlaceholder(theme),
                  )
                : _buildPlaceholder(theme),
          ),
        ),
        title: Text(
          property.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          property.shortAddress,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: trailing ?? _StatusBadge(status: property.status),
      ),
    );
  }

  Widget _buildPlaceholder(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.home_work_outlined,
        size: 24,
        color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
      ),
    );
  }
}
