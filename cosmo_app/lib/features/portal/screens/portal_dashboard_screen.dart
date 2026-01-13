/// Portal dashboard screen for Cosmo Management
///
/// Main dashboard showing property stats and overview.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../router/route_names.dart';
import '../../staff/widgets/stat_card.dart';
import '../providers/portal_providers.dart';
import 'portal_shell.dart';

/// Portal dashboard screen
///
/// Shows property stats and quick actions for property owners.
class PortalDashboardScreen extends ConsumerWidget {
  const PortalDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(portalDashboardProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Navigate to notifications
            },
          ),
        ],
      ),
      body: switch (dashboardState) {
        PortalDashboardInitial() ||
        PortalDashboardLoading() =>
          const PortalLoadingState(message: 'Loading dashboard...'),
        PortalDashboardError(message: final msg) => PortalErrorState(
            message: msg,
            onRetry: () =>
                ref.read(portalDashboardProvider.notifier).refresh(),
          ),
        PortalDashboardLoaded(stats: final stats) => RefreshIndicator(
            onRefresh: () =>
                ref.read(portalDashboardProvider.notifier).refresh(),
            child: CustomScrollView(
              slivers: [
                // Stat cards
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.md),
                    child: StatCardsRow(
                      stats: _buildDashboardStats(stats),
                      onStatTap: (index) => _onStatTap(context, index),
                    ),
                  ),
                ),

                // Quick Actions Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quick Actions',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        _QuickActionsGrid(
                          checkInsToday: stats.checkInsToday,
                          checkOutsToday: stats.checkOutsToday,
                          photosPending: stats.photosPendingApproval,
                        ),
                      ],
                    ),
                  ),
                ),

                // Today's Activity Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      children: [
                        Text(
                          "Today's Activity",
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () =>
                              context.push(RouteNames.portalCalendar),
                          child: const Text('View Calendar'),
                        ),
                      ],
                    ),
                  ),
                ),

                // Activity cards
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: _TodayActivityCard(
                      checkInsToday: stats.checkInsToday,
                      checkOutsToday: stats.checkOutsToday,
                    ),
                  ),
                ),

                // Bottom padding
                const SliverToBoxAdapter(
                  child: SizedBox(height: 80),
                ),
              ],
            ),
          ),
      },
    );
  }

  List<StatCardData> _buildDashboardStats(stats) {
    return [
      StatCardData(
        label: 'Properties',
        count: stats.totalProperties,
        icon: Icons.home_work,
        color: AppColors.primary,
      ),
      StatCardData(
        label: 'Active',
        count: stats.activeBookings,
        icon: Icons.hotel,
        color: AppColors.success,
      ),
      StatCardData(
        label: 'Upcoming',
        count: stats.upcomingBookings,
        icon: Icons.calendar_today,
        color: AppColors.info,
      ),
      StatCardData(
        label: 'Photos',
        count: stats.photosPendingApproval,
        icon: Icons.photo_library,
        color: AppColors.warning,
      ),
    ];
  }

  void _onStatTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.push(RouteNames.portalProperties);
        break;
      case 1:
      case 2:
        context.push(RouteNames.portalBookings);
        break;
      case 3:
        context.push(RouteNames.portalPhotos);
        break;
    }
  }
}

/// Quick actions grid widget
class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid({
    required this.checkInsToday,
    required this.checkOutsToday,
    required this.photosPending,
  });

  final int checkInsToday;
  final int checkOutsToday;
  final int photosPending;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionCard(
            icon: Icons.login,
            label: 'Check-ins',
            count: checkInsToday,
            color: AppColors.success,
            onTap: () => context.push(RouteNames.portalBookings),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _QuickActionCard(
            icon: Icons.logout,
            label: 'Check-outs',
            count: checkOutsToday,
            color: AppColors.info,
            onTap: () => context.push(RouteNames.portalBookings),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _QuickActionCard(
            icon: Icons.photo_camera,
            label: 'Review',
            count: photosPending,
            color: AppColors.warning,
            onTap: () => context.push(RouteNames.portalPhotos),
          ),
        ),
      ],
    );
  }
}

/// Quick action card widget
class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final int count;
  final Color color;
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
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  if (count > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        count.toString(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Today's activity card
class _TodayActivityCard extends StatelessWidget {
  const _TodayActivityCard({
    required this.checkInsToday,
    required this.checkOutsToday,
  });

  final int checkInsToday;
  final int checkOutsToday;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (checkInsToday == 0 && checkOutsToday == 0) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              Icon(
                Icons.event_available,
                size: 48,
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'No activity today',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Check the calendar for upcoming bookings',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Column(
        children: [
          if (checkInsToday > 0)
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.login, color: AppColors.success),
              ),
              title: Text('$checkInsToday Check-in${checkInsToday > 1 ? 's' : ''} Today'),
              subtitle: const Text('Guests arriving'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(RouteNames.portalBookings),
            ),
          if (checkInsToday > 0 && checkOutsToday > 0)
            const Divider(height: 1),
          if (checkOutsToday > 0)
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.logout, color: AppColors.info),
              ),
              title: Text('$checkOutsToday Check-out${checkOutsToday > 1 ? 's' : ''} Today'),
              subtitle: const Text('Guests departing'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(RouteNames.portalBookings),
            ),
        ],
      ),
    );
  }
}
