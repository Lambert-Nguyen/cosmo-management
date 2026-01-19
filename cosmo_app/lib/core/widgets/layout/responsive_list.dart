/// Responsive list widget for adaptive layouts
///
/// Displays items in a single column on mobile and grid on larger screens.
library;

import 'package:flutter/material.dart';

import '../../responsive/responsive.dart';

/// A responsive list that shows items in different layouts based on screen size
///
/// - Compact (mobile): Single column list
/// - Medium (tablet): 2-column grid
/// - Expanded (desktop): 3-column grid with max width constraint
class ResponsiveListView<T> extends StatelessWidget {
  const ResponsiveListView({
    required this.items,
    required this.itemBuilder,
    this.padding = const EdgeInsets.all(16),
    this.spacing = 16,
    this.compactColumns = 1,
    this.mediumColumns = 2,
    this.expandedColumns = 3,
    this.maxContentWidth = Breakpoints.maxContentWidth,
    this.onRefresh,
    this.emptyWidget,
    this.loadingWidget,
    this.isLoading = false,
    this.onLoadMore,
    this.hasMore = false,
    super.key,
  });

  /// Items to display
  final List<T> items;

  /// Builder for each item
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  /// Padding around the list
  final EdgeInsets padding;

  /// Spacing between items
  final double spacing;

  /// Columns for compact screens
  final int compactColumns;

  /// Columns for medium screens
  final int mediumColumns;

  /// Columns for expanded screens
  final int expandedColumns;

  /// Max content width for desktop
  final double maxContentWidth;

  /// Optional refresh callback
  final Future<void> Function()? onRefresh;

  /// Widget to show when list is empty
  final Widget? emptyWidget;

  /// Widget to show when loading
  final Widget? loadingWidget;

  /// Whether data is loading
  final bool isLoading;

  /// Callback to load more items
  final VoidCallback? onLoadMore;

  /// Whether there are more items to load
  final bool hasMore;

  @override
  Widget build(BuildContext context) {
    if (isLoading && items.isEmpty) {
      return loadingWidget ?? const Center(child: CircularProgressIndicator());
    }

    if (items.isEmpty && emptyWidget != null) {
      return emptyWidget!;
    }

    return ScreenTypeBuilder(
      builder: (context, screenType) {
        final columns = switch (screenType) {
          ScreenType.compact => compactColumns,
          ScreenType.medium => mediumColumns,
          ScreenType.expanded => expandedColumns,
        };

        Widget content;
        if (columns == 1) {
          content = _buildListView(context, screenType);
        } else {
          content = _buildGridView(context, columns, screenType);
        }

        // Center content and constrain width on large screens
        if (screenType.isExpanded) {
          content = Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxContentWidth),
              child: content,
            ),
          );
        }

        if (onRefresh != null) {
          return RefreshIndicator(
            onRefresh: onRefresh!,
            child: content,
          );
        }

        return content;
      },
    );
  }

  Widget _buildListView(BuildContext context, ScreenType screenType) {
    return ListView.separated(
      padding: _getPadding(screenType),
      itemCount: items.length + (hasMore ? 1 : 0),
      separatorBuilder: (context, index) => SizedBox(height: spacing),
      itemBuilder: (context, index) {
        if (index >= items.length) {
          // Load more indicator
          if (onLoadMore != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              onLoadMore!();
            });
          }
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return itemBuilder(context, items[index], index);
      },
    );
  }

  Widget _buildGridView(
      BuildContext context, int columns, ScreenType screenType) {
    return GridView.builder(
      padding: _getPadding(screenType),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
        // Use a reasonable aspect ratio for cards
        childAspectRatio: _getAspectRatio(screenType),
      ),
      itemCount: items.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= items.length) {
          // Load more indicator
          if (onLoadMore != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              onLoadMore!();
            });
          }
          return const Center(child: CircularProgressIndicator());
        }
        return itemBuilder(context, items[index], index);
      },
    );
  }

  EdgeInsets _getPadding(ScreenType screenType) {
    return switch (screenType) {
      ScreenType.compact => padding,
      ScreenType.medium => EdgeInsets.all(padding.left * 1.5),
      ScreenType.expanded => EdgeInsets.all(padding.left * 2),
    };
  }

  double _getAspectRatio(ScreenType screenType) {
    // Wider cards on desktop, taller cards on tablet
    return switch (screenType) {
      ScreenType.compact => 3.0,
      ScreenType.medium => 2.5,
      ScreenType.expanded => 2.8,
    };
  }
}

/// A sliver version of responsive list for use in CustomScrollView
class ResponsiveSliverList<T> extends StatelessWidget {
  const ResponsiveSliverList({
    required this.items,
    required this.itemBuilder,
    this.spacing = 16,
    this.compactColumns = 1,
    this.mediumColumns = 2,
    this.expandedColumns = 3,
    super.key,
  });

  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final double spacing;
  final int compactColumns;
  final int mediumColumns;
  final int expandedColumns;

  @override
  Widget build(BuildContext context) {
    return ScreenTypeBuilder(
      builder: (context, screenType) {
        final columns = switch (screenType) {
          ScreenType.compact => compactColumns,
          ScreenType.medium => mediumColumns,
          ScreenType.expanded => expandedColumns,
        };

        if (columns == 1) {
          return SliverList.separated(
            itemCount: items.length,
            separatorBuilder: (context, index) => SizedBox(height: spacing),
            itemBuilder: (context, index) =>
                itemBuilder(context, items[index], index),
          );
        }

        return SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: spacing,
            crossAxisSpacing: spacing,
            childAspectRatio: 2.5,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) => itemBuilder(context, items[index], index),
            childCount: items.length,
          ),
        );
      },
    );
  }
}

/// A wrapper that adds responsive max width and centering to content
class ResponsiveContent extends StatelessWidget {
  const ResponsiveContent({
    required this.child,
    this.maxWidth = Breakpoints.maxContentWidth,
    this.padding,
    super.key,
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return ScreenTypeBuilder(
      builder: (context, screenType) {
        Widget content = child;

        if (padding != null) {
          content = Padding(padding: padding!, child: content);
        }

        if (screenType.constrainContent) {
          content = Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: content,
            ),
          );
        }

        return content;
      },
    );
  }
}

/// Responsive card that adapts its padding and elevation based on screen size
class ResponsiveCard extends StatelessWidget {
  const ResponsiveCard({
    required this.child,
    this.onTap,
    this.elevation,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return ScreenTypeBuilder(
      builder: (context, screenType) {
        final responsiveElevation = elevation ??
            (switch (screenType) {
              ScreenType.compact => 0.0,
              ScreenType.medium => 1.0,
              ScreenType.expanded => 2.0,
            });

        final responsivePadding = switch (screenType) {
          ScreenType.compact => const EdgeInsets.all(12),
          ScreenType.medium => const EdgeInsets.all(16),
          ScreenType.expanded => const EdgeInsets.all(20),
        };

        return Card(
          elevation: responsiveElevation,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: responsivePadding,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
