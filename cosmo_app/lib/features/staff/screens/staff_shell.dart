/// Staff shell screen for Cosmo Management
///
/// Adaptive navigation shell for staff screens.
/// Uses bottom navigation on mobile and navigation rail on desktop.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/responsive/responsive.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/offline_banner.dart';
import '../widgets/sync_indicator.dart';

/// Staff navigation destinations
const _staffDestinations = [
  AdaptiveDestination(
    icon: Icons.dashboard_outlined,
    selectedIcon: Icons.dashboard,
    label: 'Dashboard',
  ),
  AdaptiveDestination(
    icon: Icons.task_outlined,
    selectedIcon: Icons.task,
    label: 'Tasks',
  ),
  AdaptiveDestination(
    icon: Icons.inventory_2_outlined,
    selectedIcon: Icons.inventory_2,
    label: 'Inventory',
  ),
  AdaptiveDestination(
    icon: Icons.search_outlined,
    selectedIcon: Icons.search,
    label: 'Lost & Found',
  ),
  AdaptiveDestination(
    icon: Icons.calendar_today_outlined,
    selectedIcon: Icons.calendar_today,
    label: 'Schedule',
  ),
  AdaptiveDestination(
    icon: Icons.person_outline,
    selectedIcon: Icons.person,
    label: 'Profile',
  ),
];

/// Staff navigation shell
///
/// Provides adaptive navigation for staff screens:
/// - Bottom navigation on compact screens (mobile)
/// - Navigation rail on medium/expanded screens (tablet/desktop)
class StaffShell extends ConsumerWidget {
  const StaffShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenTypeBuilder(
      builder: (context, screenType) {
        final body = Column(
          children: [
            // Offline banner at top
            const OfflineBanner(),
            // Main content
            Expanded(child: navigationShell),
          ],
        );

        if (screenType.isCompact) {
          return _buildCompactLayout(context, body);
        }
        return _buildExpandedLayout(context, body, screenType);
      },
    );
  }

  Widget _buildCompactLayout(BuildContext context, Widget body) {
    return Scaffold(
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: _staffDestinations
            .map(
              (dest) => NavigationDestination(
                icon: Icon(dest.icon),
                selectedIcon: Icon(dest.selectedIcon),
                label: dest.label,
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildExpandedLayout(
    BuildContext context,
    Widget body,
    ScreenType screenType,
  ) {
    final theme = Theme.of(context);
    final extended = screenType.isExpanded;

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: _onDestinationSelected,
            extended: extended,
            minWidth: Breakpoints.railWidth,
            minExtendedWidth: Breakpoints.railExtendedWidth,
            labelType: extended
                ? NavigationRailLabelType.none
                : NavigationRailLabelType.selected,
            backgroundColor: theme.colorScheme.surfaceContainerLow,
            leading: extended
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Staff',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : null,
            destinations: _staffDestinations
                .map(
                  (dest) => NavigationRailDestination(
                    icon: Icon(dest.icon),
                    selectedIcon: Icon(dest.selectedIcon),
                    label: Text(dest.label),
                  ),
                )
                .toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: body),
        ],
      ),
    );
  }
}

/// Staff app bar with sync indicator
class StaffAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const StaffAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showSync = true,
  });

  final String title;
  final List<Widget>? actions;
  final bool showSync;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: Text(title),
      actions: [
        if (showSync) const SyncIndicatorButton(),
        ...?actions,
      ],
    );
  }
}

/// Empty state widget for staff screens
class StaffEmptyState extends StatelessWidget {
  const StaffEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
    this.actionLabel,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? action;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null && actionLabel != null) ...[
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: action,
                icon: const Icon(Icons.add),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Loading state widget for staff screens
class StaffLoadingState extends StatelessWidget {
  const StaffLoadingState({
    super.key,
    this.message,
  });

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Error state widget for staff screens
class StaffErrorState extends StatelessWidget {
  const StaffErrorState({
    super.key,
    required this.message,
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: theme.textTheme.titleLarge?.copyWith(
                color: AppColors.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
