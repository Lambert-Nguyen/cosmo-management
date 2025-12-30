/// App card widget for Cosmo Management
library;

import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';

/// Styled card component
///
/// Provides consistent card styling with optional tap handler
/// and various content configurations.
class AppCard extends StatelessWidget {
  /// Card content
  final Widget child;

  /// Optional tap handler
  final VoidCallback? onTap;

  /// Custom padding (defaults to AppSpacing.card)
  final EdgeInsetsGeometry? padding;

  /// Custom margin
  final EdgeInsetsGeometry? margin;

  /// Whether to show a border
  final bool showBorder;

  /// Custom background color
  final Color? backgroundColor;

  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.showBorder = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardContent = Padding(
      padding: padding ?? AppSpacing.card,
      child: child,
    );

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.cardTheme.color,
        borderRadius: AppSpacing.borderRadiusMd,
        border: showBorder
            ? Border.all(
                color: theme.colorScheme.outlineVariant,
              )
            : null,
      ),
      child: onTap != null
          ? Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: AppSpacing.borderRadiusMd,
                child: cardContent,
              ),
            )
          : cardContent,
    );
  }
}

/// List item card with leading, title, subtitle, and trailing
class ListItemCard extends StatelessWidget {
  /// Leading widget (usually an icon or avatar)
  final Widget? leading;

  /// Title text
  final String title;

  /// Subtitle text
  final String? subtitle;

  /// Trailing widget
  final Widget? trailing;

  /// Tap handler
  final VoidCallback? onTap;

  const ListItemCard({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      onTap: onTap,
      padding: AppSpacing.listItem,
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: AppSpacing.md),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: AppSpacing.sm),
            trailing!,
          ],
        ],
      ),
    );
  }
}
