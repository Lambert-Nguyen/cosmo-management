/// Responsive builder widget for adaptive layouts
///
/// Provides easy-to-use widgets for building responsive UIs.
library;

import 'package:flutter/material.dart';

import 'screen_type.dart';

/// A builder widget that provides different layouts based on screen size
///
/// Example:
/// ```dart
/// ResponsiveBuilder(
///   compact: (context) => MobileLayout(),
///   medium: (context) => TabletLayout(),
///   expanded: (context) => DesktopLayout(),
/// )
/// ```
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    required this.compact,
    this.medium,
    this.expanded,
    super.key,
  });

  /// Builder for compact screens (< 600dp)
  final Widget Function(BuildContext context) compact;

  /// Builder for medium screens (600-839dp)
  /// Falls back to compact if not provided
  final Widget Function(BuildContext context)? medium;

  /// Builder for expanded screens (>= 840dp)
  /// Falls back to medium, then compact if not provided
  final Widget Function(BuildContext context)? expanded;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenType = Breakpoints.fromWidth(constraints.maxWidth);

        switch (screenType) {
          case ScreenType.compact:
            return compact(context);
          case ScreenType.medium:
            return (medium ?? compact)(context);
          case ScreenType.expanded:
            return (expanded ?? medium ?? compact)(context);
        }
      },
    );
  }
}

/// A simpler builder that just provides screen type
class ScreenTypeBuilder extends StatelessWidget {
  const ScreenTypeBuilder({
    required this.builder,
    super.key,
  });

  /// Builder that receives the current screen type
  final Widget Function(BuildContext context, ScreenType screenType) builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenType = Breakpoints.fromWidth(constraints.maxWidth);
        return builder(context, screenType);
      },
    );
  }
}

/// Widget that shows different values based on screen type
///
/// Example:
/// ```dart
/// ResponsiveValue<int>(
///   compact: 1,
///   medium: 2,
///   expanded: 3,
///   builder: (context, value) => GridView.count(
///     crossAxisCount: value,
///     children: items,
///   ),
/// )
/// ```
class ResponsiveValue<T> extends StatelessWidget {
  const ResponsiveValue({
    required this.compact,
    required this.builder,
    this.medium,
    this.expanded,
    super.key,
  });

  /// Value for compact screens
  final T compact;

  /// Value for medium screens (defaults to compact)
  final T? medium;

  /// Value for expanded screens (defaults to medium, then compact)
  final T? expanded;

  /// Builder that receives the responsive value
  final Widget Function(BuildContext context, T value) builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenType = Breakpoints.fromWidth(constraints.maxWidth);
        final T value;

        switch (screenType) {
          case ScreenType.compact:
            value = compact;
          case ScreenType.medium:
            value = medium ?? compact;
          case ScreenType.expanded:
            value = expanded ?? medium ?? compact;
        }

        return builder(context, value);
      },
    );
  }
}

/// Wrapper that constrains content width on large screens
///
/// On expanded screens, centers content with a maximum width.
/// On smaller screens, content fills available space.
class ResponsiveCenter extends StatelessWidget {
  const ResponsiveCenter({
    required this.child,
    this.maxWidth = Breakpoints.maxContentWidth,
    this.padding,
    super.key,
  });

  /// The child widget to center
  final Widget child;

  /// Maximum width for the content
  final double maxWidth;

  /// Optional padding around the centered content
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: padding != null
            ? Padding(padding: padding!, child: child)
            : child,
      ),
    );
  }
}

/// A row that becomes a column on compact screens
class ResponsiveRowColumn extends StatelessWidget {
  const ResponsiveRowColumn({
    required this.children,
    this.rowMainAxisAlignment = MainAxisAlignment.start,
    this.rowCrossAxisAlignment = CrossAxisAlignment.center,
    this.columnMainAxisAlignment = MainAxisAlignment.start,
    this.columnCrossAxisAlignment = CrossAxisAlignment.stretch,
    this.rowSpacing = 16,
    this.columnSpacing = 16,
    super.key,
  });

  /// Children widgets
  final List<Widget> children;

  /// Row main axis alignment
  final MainAxisAlignment rowMainAxisAlignment;

  /// Row cross axis alignment
  final CrossAxisAlignment rowCrossAxisAlignment;

  /// Column main axis alignment
  final MainAxisAlignment columnMainAxisAlignment;

  /// Column cross axis alignment
  final CrossAxisAlignment columnCrossAxisAlignment;

  /// Spacing between items in row mode
  final double rowSpacing;

  /// Spacing between items in column mode
  final double columnSpacing;

  @override
  Widget build(BuildContext context) {
    return ScreenTypeBuilder(
      builder: (context, screenType) {
        if (screenType.isCompact) {
          return Column(
            mainAxisAlignment: columnMainAxisAlignment,
            crossAxisAlignment: columnCrossAxisAlignment,
            mainAxisSize: MainAxisSize.min,
            children: _addSpacing(children, columnSpacing),
          );
        }

        return Row(
          mainAxisAlignment: rowMainAxisAlignment,
          crossAxisAlignment: rowCrossAxisAlignment,
          children: _addSpacing(children, rowSpacing),
        );
      },
    );
  }

  List<Widget> _addSpacing(List<Widget> children, double spacing) {
    if (children.isEmpty) return children;

    final result = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      result.add(children[i]);
      if (i < children.length - 1) {
        result.add(SizedBox(width: spacing, height: spacing));
      }
    }
    return result;
  }
}

/// A grid that adapts column count based on screen size
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    required this.children,
    this.compactColumns = 1,
    this.mediumColumns = 2,
    this.expandedColumns = 3,
    this.spacing = 16,
    this.runSpacing = 16,
    this.childAspectRatio = 1,
    super.key,
  });

  /// Children widgets
  final List<Widget> children;

  /// Number of columns on compact screens
  final int compactColumns;

  /// Number of columns on medium screens
  final int mediumColumns;

  /// Number of columns on expanded screens
  final int expandedColumns;

  /// Horizontal spacing between items
  final double spacing;

  /// Vertical spacing between items
  final double runSpacing;

  /// Child aspect ratio
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return ResponsiveValue<int>(
      compact: compactColumns,
      medium: mediumColumns,
      expanded: expandedColumns,
      builder: (context, columns) => GridView.count(
        crossAxisCount: columns,
        mainAxisSpacing: runSpacing,
        crossAxisSpacing: spacing,
        childAspectRatio: childAspectRatio,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: children,
      ),
    );
  }
}

/// Extension methods for BuildContext to easily access screen type
extension ResponsiveContextExtension on BuildContext {
  /// Get the current screen type
  ScreenType get screenType => Breakpoints.of(this);

  /// Whether the current screen is compact (phone)
  bool get isCompact => screenType.isCompact;

  /// Whether the current screen is medium (tablet)
  bool get isMedium => screenType.isMedium;

  /// Whether the current screen is expanded (desktop)
  bool get isExpanded => screenType.isExpanded;
}
