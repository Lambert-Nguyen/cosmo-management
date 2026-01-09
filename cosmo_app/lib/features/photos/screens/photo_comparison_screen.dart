/// Photo comparison screen for Cosmo Management
///
/// Screen displaying before/after photo comparisons with interactive slider.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/loading/loading_indicator.dart';
import '../../../data/models/photo_model.dart';
import '../providers/photo_providers.dart';
import '../widgets/before_after_slider.dart';

/// Photo comparison screen
class PhotoComparisonScreen extends ConsumerStatefulWidget {
  final int taskId;
  final String? taskTitle;

  const PhotoComparisonScreen({
    super.key,
    required this.taskId,
    this.taskTitle,
  });

  @override
  ConsumerState<PhotoComparisonScreen> createState() =>
      _PhotoComparisonScreenState();
}

class _PhotoComparisonScreenState extends ConsumerState<PhotoComparisonScreen> {
  int _currentIndex = 0;
  bool _isFullscreen = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final comparisonsAsync = ref.watch(photoComparisonProvider(widget.taskId));

    return Scaffold(
      backgroundColor: _isFullscreen ? Colors.black : null,
      appBar: _isFullscreen
          ? null
          : AppBar(
              title: Text(widget.taskTitle ?? 'Photo Comparison'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.fullscreen),
                  tooltip: 'Fullscreen',
                  onPressed: () => setState(() => _isFullscreen = true),
                ),
              ],
            ),
      body: comparisonsAsync.when(
        data: (comparisons) => comparisons.isEmpty
            ? _buildEmptyState(theme)
            : _buildComparisonView(comparisons, theme),
        loading: () => const Center(child: LoadingIndicator()),
        error: (error, _) => _buildErrorState(error.toString(), theme),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.compare,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No Comparisons Available',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Upload before and after photos to compare',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: AppSpacing.md),
          Text('Error loading comparisons', style: theme.textTheme.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          Text(error),
          const SizedBox(height: AppSpacing.md),
          FilledButton(
            onPressed: () => ref.refresh(photoComparisonProvider(widget.taskId)),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonView(
    List<PhotoComparisonModel> comparisons,
    ThemeData theme,
  ) {
    final comparison = comparisons[_currentIndex];

    if (_isFullscreen) {
      return _buildFullscreenView(comparison, comparisons.length);
    }

    return Column(
      children: [
        // Comparison slider
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _isFullscreen = true),
            child: BeforeAfterSlider(
              beforeUrl: comparison.beforePhotoUrl,
              afterUrl: comparison.afterPhotoUrl,
            ),
          ),
        ),

        // Info card
        if (comparison.locationDescription != null ||
            comparison.comparisonNotes != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            color: theme.colorScheme.surfaceContainerHighest,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (comparison.locationDescription != null)
                  Text(
                    comparison.locationDescription!,
                    style: theme.textTheme.titleSmall,
                  ),
                if (comparison.comparisonNotes != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    comparison.comparisonNotes!,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),

        // Navigation
        if (comparisons.length > 1)
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _currentIndex > 0
                      ? () => setState(() => _currentIndex--)
                      : null,
                ),
                const SizedBox(width: AppSpacing.md),
                // Dot indicators
                Row(
                  children: List.generate(
                    comparisons.length,
                    (index) => Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index == _currentIndex
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outlineVariant,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: _currentIndex < comparisons.length - 1
                      ? () => setState(() => _currentIndex++)
                      : null,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildFullscreenView(PhotoComparisonModel comparison, int total) {
    return GestureDetector(
      onTap: () => setState(() => _isFullscreen = false),
      child: Stack(
        fit: StackFit.expand,
        children: [
          BeforeAfterSlider(
            beforeUrl: comparison.beforePhotoUrl,
            afterUrl: comparison.afterPhotoUrl,
          ),
          // Close button
          Positioned(
            top: MediaQuery.of(context).padding.top + AppSpacing.md,
            right: AppSpacing.md,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => setState(() => _isFullscreen = false),
              style: IconButton.styleFrom(
                backgroundColor: Colors.black54,
              ),
            ),
          ),
          // Index indicator
          if (total > 1)
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + AppSpacing.md,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(AppSpacing.md),
                  ),
                  child: Text(
                    '${_currentIndex + 1} / $total',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
