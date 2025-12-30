/// Loading indicator widgets for Cosmo Management
library;

import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

/// Circular loading indicator
///
/// Shows a centered circular progress indicator with optional message.
class LoadingIndicator extends StatelessWidget {
  /// Optional loading message
  final String? message;

  /// Size of the indicator
  final double size;

  /// Stroke width
  final double strokeWidth;

  /// Custom color
  final Color? color;

  const LoadingIndicator({
    super.key,
    this.message,
    this.size = 40,
    this.strokeWidth = 3,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: strokeWidth,
              color: color ?? Theme.of(context).colorScheme.primary,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Full screen loading overlay
///
/// Displays a semi-transparent overlay with loading indicator.
class LoadingOverlay extends StatelessWidget {
  /// Whether the overlay is visible
  final bool isLoading;

  /// Child widget to display behind the overlay
  final Widget child;

  /// Optional loading message
  final String? message;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: LoadingIndicator(message: message),
            ),
          ),
      ],
    );
  }
}

/// Shimmer loading placeholder
///
/// Displays a shimmer animation for loading placeholders.
class ShimmerLoading extends StatefulWidget {
  /// Width of the shimmer
  final double? width;

  /// Height of the shimmer
  final double height;

  /// Border radius
  final double borderRadius;

  const ShimmerLoading({
    super.key,
    this.width,
    this.height = 20,
    this.borderRadius = AppSpacing.radiusSm,
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: -1, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor =
        isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariant;
    final highlightColor = isDark ? AppColors.surfaceDark : AppColors.surface;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
              stops: [
                0.0,
                (_animation.value + 1) / 3,
                1.0,
              ],
            ),
          ),
        );
      },
    );
  }
}
