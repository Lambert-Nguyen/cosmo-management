/// Before/After slider widget for Cosmo Management
///
/// Interactive slider for comparing before and after photos.
library;

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/theme/app_spacing.dart';

/// Before/After comparison slider widget
class BeforeAfterSlider extends StatefulWidget {
  final String? beforeUrl;
  final String? afterUrl;
  final double initialPosition;
  final Color dividerColor;
  final double dividerWidth;
  final bool showLabels;

  const BeforeAfterSlider({
    super.key,
    this.beforeUrl,
    this.afterUrl,
    this.initialPosition = 0.5,
    this.dividerColor = Colors.white,
    this.dividerWidth = 3.0,
    this.showLabels = true,
  });

  @override
  State<BeforeAfterSlider> createState() => _BeforeAfterSliderState();
}

class _BeforeAfterSliderState extends State<BeforeAfterSlider> {
  late double _sliderPosition;

  @override
  void initState() {
    super.initState();
    _sliderPosition = widget.initialPosition;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.beforeUrl == null && widget.afterUrl == null) {
      return _buildPlaceholder(context);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onHorizontalDragUpdate: (details) {
            setState(() {
              _sliderPosition += details.delta.dx / constraints.maxWidth;
              _sliderPosition = _sliderPosition.clamp(0.0, 1.0);
            });
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              // After image (full width, underneath)
              if (widget.afterUrl != null)
                _buildImage(widget.afterUrl!, 'After'),

              // Before image (clipped)
              if (widget.beforeUrl != null)
                ClipRect(
                  clipper: _SliderClipper(_sliderPosition),
                  child: _buildImage(widget.beforeUrl!, 'Before'),
                ),

              // Divider line with handle
              Positioned(
                left: constraints.maxWidth * _sliderPosition - widget.dividerWidth / 2,
                top: 0,
                bottom: 0,
                child: _buildDivider(constraints.maxHeight),
              ),

              // Labels
              if (widget.showLabels) ...[
                Positioned(
                  left: AppSpacing.md,
                  top: AppSpacing.md,
                  child: _buildLabel('BEFORE'),
                ),
                Positioned(
                  right: AppSpacing.md,
                  top: AppSpacing.md,
                  child: _buildLabel('AFTER'),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildImage(String url, String label) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (_, __) => Container(
        color: Colors.grey[300],
        child: const Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (_, __, ___) => Container(
        color: Colors.grey[300],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.broken_image, size: 48, color: Colors.grey),
            const SizedBox(height: AppSpacing.sm),
            Text('$label image unavailable'),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(double height) {
    return Column(
      children: [
        Expanded(
          child: Container(
            width: widget.dividerWidth,
            color: widget.dividerColor,
          ),
        ),
        // Handle
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: widget.dividerColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(64),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.compare_arrows,
            color: Colors.black54,
          ),
        ),
        Expanded(
          child: Container(
            width: widget.dividerWidth,
            color: widget.dividerColor,
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.compare,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No photos to compare',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom clipper for the before image
class _SliderClipper extends CustomClipper<Rect> {
  final double position;

  _SliderClipper(this.position);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width * position, size.height);
  }

  @override
  bool shouldReclip(_SliderClipper oldClipper) {
    return position != oldClipper.position;
  }
}

/// Simple side-by-side comparison (no slider)
class BeforeAfterSideBySide extends StatelessWidget {
  final String? beforeUrl;
  final String? afterUrl;

  const BeforeAfterSideBySide({
    super.key,
    this.beforeUrl,
    this.afterUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              _buildLabel(context, 'BEFORE'),
              Expanded(child: _buildImage(beforeUrl)),
            ],
          ),
        ),
        const SizedBox(width: 2),
        Expanded(
          child: Column(
            children: [
              _buildLabel(context, 'AFTER'),
              Expanded(child: _buildImage(afterUrl)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(BuildContext context, String text) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      color: theme.colorScheme.surfaceContainerHighest,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildImage(String? url) {
    if (url == null) {
      return Container(
        color: Colors.grey[200],
        child: const Center(
          child: Icon(Icons.image_not_supported, size: 32, color: Colors.grey),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (_, __) => Container(
        color: Colors.grey[200],
        child: const Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (_, __, ___) => Container(
        color: Colors.grey[200],
        child: const Icon(Icons.broken_image, color: Colors.grey),
      ),
    );
  }
}
