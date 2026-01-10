/// Property detail screen for Cosmo Management Portal
///
/// Displays detailed property information with bookings and tasks.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/property_model.dart';
import '../../../router/route_names.dart';
import '../providers/portal_providers.dart';
import '../widgets/property_card.dart';
import 'portal_shell.dart';

/// Property detail screen
///
/// Shows property details, bookings, and related tasks.
class PropertyDetailScreen extends ConsumerWidget {
  const PropertyDetailScreen({
    super.key,
    required this.propertyId,
  });

  final int propertyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final propertyAsync = ref.watch(propertyDetailProvider(propertyId));

    return Scaffold(
      body: propertyAsync.when(
        loading: () => const PortalLoadingState(message: 'Loading property...'),
        error: (error, _) => PortalErrorState(
          message: error.toString(),
          onRetry: () => ref.invalidate(propertyDetailProvider(propertyId)),
        ),
        data: (property) => _PropertyDetailContent(property: property),
      ),
    );
  }
}

class _PropertyDetailContent extends StatelessWidget {
  const _PropertyDetailContent({required this.property});

  final PropertyModel property;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomScrollView(
      slivers: [
        // App bar with property image
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              property.name,
              style: const TextStyle(
                shadows: [
                  Shadow(
                    blurRadius: 8,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
            background: property.primaryImage != null
                ? Image.network(
                    property.primaryImage!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildPlaceholder(theme),
                  )
                : _buildPlaceholder(theme),
          ),
        ),

        // Status card
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: _StatusCard(property: property),
          ),
        ),

        // Property details
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: _DetailsCard(property: property),
          ),
        ),

        // Quick actions
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: _QuickActions(propertyId: property.id),
          ),
        ),

        // Bottom padding
        const SliverToBoxAdapter(
          child: SizedBox(height: 80),
        ),
      ],
    );
  }

  Widget _buildPlaceholder(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.home_work_outlined,
          size: 64,
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.property});

  final PropertyModel property;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (statusColor, statusBg) = _getStatusColors(property.status);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: statusBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getStatusIcon(property.status),
                color: statusColor,
                size: 32,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Status',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    property.status.displayName,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  (Color, Color) _getStatusColors(PropertyStatus status) {
    return switch (status) {
      PropertyStatus.available => (AppColors.success, AppColors.successContainer),
      PropertyStatus.occupied => (AppColors.info, AppColors.infoContainer),
      PropertyStatus.maintenance => (AppColors.warning, AppColors.warningContainer),
      PropertyStatus.reserved => (AppColors.primary, AppColors.primaryContainer),
      PropertyStatus.inactive => (AppColors.error, AppColors.errorContainer),
    };
  }

  IconData _getStatusIcon(PropertyStatus status) {
    return switch (status) {
      PropertyStatus.available => Icons.check_circle,
      PropertyStatus.occupied => Icons.hotel,
      PropertyStatus.maintenance => Icons.construction,
      PropertyStatus.reserved => Icons.event,
      PropertyStatus.inactive => Icons.block,
    };
  }
}

class _DetailsCard extends StatelessWidget {
  const _DetailsCard({required this.property});

  final PropertyModel property;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Property Details',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Address
            if (property.fullAddress.isNotEmpty)
              _DetailRow(
                icon: Icons.location_on_outlined,
                label: 'Address',
                value: property.fullAddress,
              ),

            // Type
            if (property.propertyType != null)
              _DetailRow(
                icon: Icons.category_outlined,
                label: 'Type',
                value: property.propertyType!,
              ),

            // Bedrooms & Bathrooms
            if (property.bedrooms != null || property.bathrooms != null)
              _DetailRow(
                icon: Icons.bed_outlined,
                label: 'Bed / Bath',
                value: property.bedBathSummary,
              ),

            // Max occupancy
            if (property.maxOccupancy != null)
              _DetailRow(
                icon: Icons.people_outline,
                label: 'Max Occupancy',
                value: '${property.maxOccupancy} guests',
              ),

            // Square feet
            if (property.squareFeet != null)
              _DetailRow(
                icon: Icons.square_foot,
                label: 'Size',
                value: '${property.squareFeet!.toStringAsFixed(0)} sq ft',
              ),

            // Manager
            if (property.managerName != null)
              _DetailRow(
                icon: Icons.person_outline,
                label: 'Manager',
                value: property.managerName!,
              ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.propertyId});

  final int propertyId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _ActionButton(
                icon: Icons.calendar_month,
                label: 'Calendar',
                onTap: () => context.push(RouteNames.portalCalendar),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _ActionButton(
                icon: Icons.book,
                label: 'Bookings',
                onTap: () => context.push(RouteNames.portalBookings),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _ActionButton(
                icon: Icons.photo_library,
                label: 'Photos',
                onTap: () => context.push(RouteNames.portalPhotos),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              Icon(
                icon,
                color: theme.colorScheme.primary,
                size: 28,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
