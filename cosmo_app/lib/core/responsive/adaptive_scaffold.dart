/// Adaptive scaffold that switches between bottom nav and navigation rail
///
/// Automatically uses bottom navigation on compact screens and
/// navigation rail on medium/expanded screens.
library;

import 'package:flutter/material.dart';

import 'screen_type.dart';
import 'responsive_builder.dart';

/// Navigation destination for adaptive navigation
class AdaptiveDestination {
  const AdaptiveDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  /// Icon when not selected
  final IconData icon;

  /// Icon when selected
  final IconData selectedIcon;

  /// Label text
  final String label;
}

/// Adaptive scaffold with automatic navigation type switching
///
/// On compact screens: Uses NavigationBar (bottom)
/// On medium screens: Uses NavigationRail
/// On expanded screens: Uses NavigationRail with labels
class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({
    required this.body,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.appBar,
    this.floatingActionButton,
    this.showLabelsOnRail = false,
    super.key,
  });

  /// The main content body
  final Widget body;

  /// Navigation destinations
  final List<AdaptiveDestination> destinations;

  /// Currently selected index
  final int selectedIndex;

  /// Callback when destination is selected
  final ValueChanged<int> onDestinationSelected;

  /// Optional app bar
  final PreferredSizeWidget? appBar;

  /// Optional floating action button
  final Widget? floatingActionButton;

  /// Whether to show labels on navigation rail
  final bool showLabelsOnRail;

  @override
  Widget build(BuildContext context) {
    return ScreenTypeBuilder(
      builder: (context, screenType) {
        if (screenType.isCompact) {
          return _buildWithBottomNav(context);
        }
        return _buildWithRail(context, screenType);
      },
    );
  }

  Widget _buildWithBottomNav(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: destinations
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

  Widget _buildWithRail(BuildContext context, ScreenType screenType) {
    final theme = Theme.of(context);
    final extended = screenType.isExpanded && showLabelsOnRail;

    return Scaffold(
      appBar: appBar,
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            extended: extended,
            minWidth: Breakpoints.railWidth,
            minExtendedWidth: Breakpoints.railExtendedWidth,
            labelType: extended
                ? NavigationRailLabelType.none
                : NavigationRailLabelType.selected,
            backgroundColor: theme.colorScheme.surfaceContainerLow,
            destinations: destinations
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
      floatingActionButton: floatingActionButton,
    );
  }
}

/// A shell widget that provides adaptive navigation for StatefulShellRoute
///
/// Use this as a wrapper for GoRouter's StatefulShellRoute to get
/// adaptive navigation behavior.
class AdaptiveNavigationShell extends StatelessWidget {
  const AdaptiveNavigationShell({
    required this.navigationShell,
    required this.destinations,
    this.appBarBuilder,
    this.floatingActionButton,
    this.showLabelsOnRail = true,
    super.key,
  });

  /// The navigation shell from GoRouter
  final Widget navigationShell;

  /// Navigation destinations
  final List<AdaptiveDestination> destinations;

  /// Optional app bar builder
  final PreferredSizeWidget Function(BuildContext context)? appBarBuilder;

  /// Optional floating action button
  final Widget? floatingActionButton;

  /// Whether to show labels on the navigation rail
  final bool showLabelsOnRail;

  @override
  Widget build(BuildContext context) {
    return ScreenTypeBuilder(
      builder: (context, screenType) {
        if (screenType.isCompact) {
          return Scaffold(
            appBar: appBarBuilder?.call(context),
            body: navigationShell,
            floatingActionButton: floatingActionButton,
          );
        }

        return Scaffold(
          appBar: appBarBuilder?.call(context),
          body: Row(
            children: [
              _NavigationRailFromShell(
                destinations: destinations,
                screenType: screenType,
                showLabels: showLabelsOnRail,
              ),
              const VerticalDivider(thickness: 1, width: 1),
              Expanded(child: navigationShell),
            ],
          ),
          floatingActionButton: floatingActionButton,
        );
      },
    );
  }
}

class _NavigationRailFromShell extends StatelessWidget {
  const _NavigationRailFromShell({
    required this.destinations,
    required this.screenType,
    required this.showLabels,
  });

  final List<AdaptiveDestination> destinations;
  final ScreenType screenType;
  final bool showLabels;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final extended = screenType.isExpanded && showLabels;

    return NavigationRail(
      selectedIndex: _getSelectedIndex(context),
      onDestinationSelected: (index) => _onDestinationSelected(context, index),
      extended: extended,
      minWidth: Breakpoints.railWidth,
      minExtendedWidth: Breakpoints.railExtendedWidth,
      labelType: extended
          ? NavigationRailLabelType.none
          : NavigationRailLabelType.selected,
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      destinations: destinations
          .map(
            (dest) => NavigationRailDestination(
              icon: Icon(dest.icon),
              selectedIcon: Icon(dest.selectedIcon),
              label: Text(dest.label),
            ),
          )
          .toList(),
    );
  }

  int _getSelectedIndex(BuildContext context) {
    // This would typically be connected to GoRouter's currentIndex
    // For now, return 0 as default
    return 0;
  }

  void _onDestinationSelected(BuildContext context, int index) {
    // This would typically navigate using GoRouter
  }
}

/// Responsive padding that adapts to screen size
class ResponsivePadding extends StatelessWidget {
  const ResponsivePadding({
    required this.child,
    this.compactPadding = const EdgeInsets.all(16),
    this.mediumPadding = const EdgeInsets.all(24),
    this.expandedPadding = const EdgeInsets.all(32),
    super.key,
  });

  final Widget child;
  final EdgeInsets compactPadding;
  final EdgeInsets mediumPadding;
  final EdgeInsets expandedPadding;

  @override
  Widget build(BuildContext context) {
    return ResponsiveValue<EdgeInsets>(
      compact: compactPadding,
      medium: mediumPadding,
      expanded: expandedPadding,
      builder: (context, padding) => Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}

/// Responsive container with max width on large screens
class ResponsiveContainer extends StatelessWidget {
  const ResponsiveContainer({
    required this.child,
    this.maxWidth = Breakpoints.maxContentWidth,
    this.backgroundColor,
    super.key,
  });

  final Widget child;
  final double maxWidth;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      ),
    );
  }
}
