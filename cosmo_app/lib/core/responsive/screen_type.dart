/// Screen type definitions for responsive layouts
///
/// Follows Material Design 3 adaptive layout guidelines.
/// https://m3.material.io/foundations/layout/applying-layout
library;

import 'package:flutter/widgets.dart';

/// Screen type based on window width class
///
/// Material Design 3 defines three main window size classes:
/// - Compact: 0-599dp (phones in portrait)
/// - Medium: 600-839dp (tablets in portrait, foldables)
/// - Expanded: 840dp+ (tablets in landscape, desktops)
enum ScreenType {
  /// Compact screens (< 600dp)
  /// Phones in portrait mode
  compact,

  /// Medium screens (600-839dp)
  /// Tablets in portrait, foldables, small laptops
  medium,

  /// Expanded screens (>= 840dp)
  /// Tablets in landscape, desktops
  expanded,
}

/// Extension methods for ScreenType
extension ScreenTypeExtension on ScreenType {
  /// Whether this is a compact screen (phone)
  bool get isCompact => this == ScreenType.compact;

  /// Whether this is a medium screen (tablet)
  bool get isMedium => this == ScreenType.medium;

  /// Whether this is an expanded screen (desktop)
  bool get isExpanded => this == ScreenType.expanded;

  /// Whether this screen should show a navigation rail
  bool get showNavigationRail => this != ScreenType.compact;

  /// Whether this screen should show bottom navigation
  bool get showBottomNavigation => this == ScreenType.compact;

  /// Whether content should use max width constraints
  bool get constrainContent => this == ScreenType.expanded;

  /// Get number of columns for a grid layout
  int get gridColumns {
    switch (this) {
      case ScreenType.compact:
        return 1;
      case ScreenType.medium:
        return 2;
      case ScreenType.expanded:
        return 3;
    }
  }
}

/// Breakpoint values for responsive layouts
class Breakpoints {
  Breakpoints._();

  /// Compact (phone) max width
  static const double compact = 600;

  /// Medium (tablet) max width
  static const double medium = 840;

  /// Maximum content width for expanded screens
  static const double maxContentWidth = 1200;

  /// Navigation rail width
  static const double railWidth = 80;

  /// Extended navigation rail width (with labels)
  static const double railExtendedWidth = 256;

  /// Get screen type from width
  static ScreenType fromWidth(double width) {
    if (width < compact) {
      return ScreenType.compact;
    } else if (width < medium) {
      return ScreenType.medium;
    } else {
      return ScreenType.expanded;
    }
  }

  /// Get screen type from BuildContext
  static ScreenType of(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return fromWidth(width);
  }
}
