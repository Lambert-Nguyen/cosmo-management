/// Hover effect widgets for desktop/web experience
///
/// Provides visual feedback on hover for improved desktop UX.
library;

import 'package:flutter/material.dart';

/// A widget that provides hover effects for its child
///
/// On desktop/web, shows visual feedback when the mouse hovers over the widget.
/// On mobile, this is essentially a no-op wrapper.
///
/// Example:
/// ```dart
/// HoverEffect(
///   hoverScale: 1.02,
///   hoverElevation: 4,
///   child: MyCard(),
/// )
/// ```
class HoverEffect extends StatefulWidget {
  const HoverEffect({
    required this.child,
    this.hoverScale = 1.0,
    this.hoverElevation,
    this.hoverColor,
    this.cursor = SystemMouseCursors.click,
    this.duration = const Duration(milliseconds: 150),
    this.onHover,
    super.key,
  });

  /// The child widget to apply hover effects to
  final Widget child;

  /// Scale factor when hovered (1.0 = no scale, 1.02 = 2% larger)
  final double hoverScale;

  /// Elevation when hovered (null = no elevation change)
  final double? hoverElevation;

  /// Background color overlay when hovered
  final Color? hoverColor;

  /// Mouse cursor to show on hover
  final MouseCursor cursor;

  /// Animation duration for hover transitions
  final Duration duration;

  /// Callback when hover state changes
  final void Function(bool isHovered)? onHover;

  @override
  State<HoverEffect> createState() => _HoverEffectState();
}

class _HoverEffectState extends State<HoverEffect> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.cursor,
      onEnter: (_) {
        setState(() => _isHovered = true);
        widget.onHover?.call(true);
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        widget.onHover?.call(false);
      },
      child: AnimatedContainer(
        duration: widget.duration,
        transform: Matrix4.identity()..scale(_isHovered ? widget.hoverScale : 1.0),
        transformAlignment: Alignment.center,
        child: widget.hoverElevation != null
            ? Material(
                elevation: _isHovered ? widget.hoverElevation! : 0,
                color: Colors.transparent,
                child: _buildColorOverlay(),
              )
            : _buildColorOverlay(),
      ),
    );
  }

  Widget _buildColorOverlay() {
    if (widget.hoverColor == null) return widget.child;

    return AnimatedContainer(
      duration: widget.duration,
      color: _isHovered ? widget.hoverColor : Colors.transparent,
      child: widget.child,
    );
  }
}

/// A card with built-in hover effects for desktop
///
/// Combines Material card styling with hover animations.
class HoverCard extends StatefulWidget {
  const HoverCard({
    required this.child,
    this.onTap,
    this.onLongPress,
    this.elevation = 1,
    this.hoverElevation = 4,
    this.borderRadius = 12,
    this.color,
    this.hoverColor,
    this.border,
    this.hoverBorder,
    this.padding,
    this.margin,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double elevation;
  final double hoverElevation;
  final double borderRadius;
  final Color? color;
  final Color? hoverColor;
  final BoxBorder? border;
  final BoxBorder? hoverBorder;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseColor = widget.color ?? theme.colorScheme.surfaceContainerLow;
    final hoveredColor = widget.hoverColor ?? theme.colorScheme.surfaceContainerHigh;

    return MouseRegion(
      cursor: widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: widget.margin,
          decoration: BoxDecoration(
            color: _isHovered ? hoveredColor : baseColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: _isHovered ? widget.hoverBorder ?? widget.border : widget.border,
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withValues(alpha: 0.1),
                blurRadius: _isHovered ? widget.hoverElevation * 2 : widget.elevation * 2,
                offset: Offset(0, _isHovered ? widget.hoverElevation : widget.elevation),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: Padding(
              padding: widget.padding ?? EdgeInsets.zero,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}

/// A button with hover effects
///
/// Provides scale and color transitions on hover.
class HoverButton extends StatefulWidget {
  const HoverButton({
    required this.child,
    required this.onPressed,
    this.hoverScale = 1.02,
    this.hoverColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.borderRadius = 8,
    super.key,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final double hoverScale;
  final Color? hoverColor;
  final EdgeInsets padding;
  final double borderRadius;

  @override
  State<HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<HoverButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = widget.onPressed == null;

    return MouseRegion(
      cursor: isDisabled ? MouseCursor.defer : SystemMouseCursors.click,
      onEnter: isDisabled ? null : (_) => setState(() => _isHovered = true),
      onExit: isDisabled ? null : (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          transform: Matrix4.identity()
            ..scale(_isHovered && !isDisabled ? widget.hoverScale : 1.0),
          transformAlignment: Alignment.center,
          padding: widget.padding,
          decoration: BoxDecoration(
            color: _isHovered
                ? (widget.hoverColor ?? theme.colorScheme.primaryContainer)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

/// A list tile with hover effects
///
/// Provides visual feedback on hover, suitable for list items.
class HoverListTile extends StatefulWidget {
  const HoverListTile({
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.hoverColor,
    this.selectedColor,
    this.isSelected = false,
    super.key,
  });

  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsets contentPadding;
  final Color? hoverColor;
  final Color? selectedColor;
  final bool isSelected;

  @override
  State<HoverListTile> createState() => _HoverListTileState();
}

class _HoverListTileState extends State<HoverListTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hoverColor =
        widget.hoverColor ?? theme.colorScheme.surfaceContainerHighest;
    final selectedColor =
        widget.selectedColor ?? theme.colorScheme.primaryContainer;

    Color? backgroundColor;
    if (widget.isSelected) {
      backgroundColor = selectedColor;
    } else if (_isHovered) {
      backgroundColor = hoverColor;
    }

    return MouseRegion(
      cursor:
          widget.onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          color: backgroundColor,
          padding: widget.contentPadding,
          child: Row(
            children: [
              if (widget.leading != null) ...[
                widget.leading!,
                const SizedBox(width: 16),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    widget.title,
                    if (widget.subtitle != null) ...[
                      const SizedBox(height: 4),
                      widget.subtitle!,
                    ],
                  ],
                ),
              ),
              if (widget.trailing != null) ...[
                const SizedBox(width: 16),
                widget.trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Extension to check if platform supports hover
extension HoverContextExtension on BuildContext {
  /// Returns true if the platform supports hover interactions (desktop/web)
  bool get supportsHover {
    final platform = Theme.of(this).platform;
    return platform == TargetPlatform.windows ||
        platform == TargetPlatform.macOS ||
        platform == TargetPlatform.linux;
  }
}
