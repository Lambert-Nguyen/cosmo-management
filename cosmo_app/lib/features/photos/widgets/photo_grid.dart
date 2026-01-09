/// Photo grid widget for Cosmo Management
///
/// Displays photos in a grid with selection support.
library;

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/photo_model.dart';

/// Photo grid widget with optional selection
class PhotoGrid extends StatelessWidget {
  final List<PhotoModel> photos;
  final Set<int> selectedIds;
  final bool selectionMode;
  final void Function(PhotoModel photo)? onPhotoTap;
  final void Function(PhotoModel photo)? onPhotoLongPress;
  final void Function(int id, bool selected)? onSelectionChanged;
  final int crossAxisCount;
  final double spacing;

  const PhotoGrid({
    super.key,
    required this.photos,
    this.selectedIds = const {},
    this.selectionMode = false,
    this.onPhotoTap,
    this.onPhotoLongPress,
    this.onSelectionChanged,
    this.crossAxisCount = 3,
    this.spacing = AppSpacing.xs,
  });

  @override
  Widget build(BuildContext context) {
    if (photos.isEmpty) {
      return _buildEmptyState(context);
    }

    return GridView.builder(
      padding: EdgeInsets.all(spacing),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        final photo = photos[index];
        final isSelected = selectedIds.contains(photo.id);

        return PhotoGridItem(
          photo: photo,
          isSelected: isSelected,
          selectionMode: selectionMode,
          onTap: () {
            if (selectionMode) {
              onSelectionChanged?.call(photo.id, !isSelected);
            } else {
              onPhotoTap?.call(photo);
            }
          },
          onLongPress: () => onPhotoLongPress?.call(photo),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No Photos',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual photo grid item
class PhotoGridItem extends StatelessWidget {
  final PhotoModel photo;
  final bool isSelected;
  final bool selectionMode;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const PhotoGridItem({
    super.key,
    required this.photo,
    this.isSelected = false,
    this.selectionMode = false,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.xs),
            child: CachedNetworkImage(
              imageUrl: photo.displayUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                color: theme.colorScheme.surfaceContainerHighest,
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              errorWidget: (_, __, ___) => Container(
                color: theme.colorScheme.surfaceContainerHighest,
                child: const Icon(Icons.broken_image),
              ),
            ),
          ),

          // Selection overlay
          if (selectionMode)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSpacing.xs),
                  color: isSelected
                      ? theme.colorScheme.primary.withAlpha(64)
                      : Colors.transparent,
                  border: isSelected
                      ? Border.all(
                          color: theme.colorScheme.primary,
                          width: 3,
                        )
                      : null,
                ),
              ),
            ),

          // Selection checkbox
          if (selectionMode)
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : Colors.white.withAlpha(200),
                  border: Border.all(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : Colors.grey,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        size: 16,
                        color: Colors.white,
                      )
                    : null,
              ),
            ),

          // Photo type indicator
          if (!selectionMode && photo.type != PhotoType.general)
            Positioned(
              bottom: 4,
              left: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: _getTypeColor(photo.type),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  photo.type.displayName.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          // Approval status indicator
          if (!selectionMode && photo.isPending)
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.warning,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.hourglass_empty,
                  size: 12,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getTypeColor(PhotoType type) {
    return switch (type) {
      PhotoType.before => Colors.blue,
      PhotoType.after => Colors.green,
      PhotoType.damage => Colors.red,
      PhotoType.inventory => Colors.orange,
      PhotoType.lostFound => Colors.purple,
      PhotoType.general => Colors.grey,
    };
  }
}
