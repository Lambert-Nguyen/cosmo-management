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

/// A shell widget that provides adaptive navigation with callbacks
///
/// Use this when you need adaptive navigation but want to manage
/// navigation state yourself. For GoRouter's StatefulShellRoute,
/// see StaffShell and PortalShell for implementation examples.
///
/// Example usage:
/// ```dart
/// AdaptiveNavigationShell(
///   body: currentPage,
///   destinations: myDestinations,
///   selectedIndex: currentIndex,
///   onDestinationSelected: (index) => navigateTo(index),
/// )
/// ```
class AdaptiveNavigationShell extends StatelessWidget {
  const AdaptiveNavigationShell({
    required this.body,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.appBarBuilder,
    this.floatingActionButton,
    this.showLabelsOnRail = true,
    this.leading,
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

  /// Optional app bar builder
  final PreferredSizeWidget Function(BuildContext context)? appBarBuilder;

  /// Optional floating action button
  final Widget? floatingActionButton;

  /// Whether to show labels on the navigation rail when expanded
  final bool showLabelsOnRail;

  /// Optional leading widget for the navigation rail (e.g., title)
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return ScreenTypeBuilder(
      builder: (context, screenType) {
        if (screenType.isCompact) {
          return _buildCompactLayout(context);
        }
        return _buildExpandedLayout(context, screenType);
      },
    );
  }

  Widget _buildCompactLayout(BuildContext context) {
    return Scaffold(
      appBar: appBarBuilder?.call(context),
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

  Widget _buildExpandedLayout(BuildContext context, ScreenType screenType) {
    final theme = Theme.of(context);
    final extended = screenType.isExpanded && showLabelsOnRail;

    return Scaffold(
      appBar: appBarBuilder?.call(context),
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
            leading: leading,
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
