/// Photo gallery screen for Cosmo Management Portal
///
/// Displays photos pending approval for portal users.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/photo_model.dart';
import '../providers/portal_providers.dart';
import 'portal_shell.dart';

/// Photo gallery screen
///
/// Shows photos pending approval with approve/reject actions.
class PhotoGalleryScreen extends ConsumerWidget {
  const PhotoGalleryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photoState = ref.watch(photoGalleryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Review'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(photoGalleryProvider.notifier).refresh(),
          ),
        ],
      ),
      body: switch (photoState) {
        PhotoGalleryInitial() ||
        PhotoGalleryLoading() =>
          const PortalLoadingState(message: 'Loading photos...'),
        PhotoGalleryError(message: final msg) => PortalErrorState(
            message: msg,
            onRetry: () => ref.read(photoGalleryProvider.notifier).refresh(),
          ),
        PhotoGalleryLoaded(
          photos: final photos,
          totalCount: final totalCount,
        ) =>
          photos.isEmpty
              ? const PortalEmptyState(
                  icon: Icons.photo_library_outlined,
                  title: 'No photos to review',
                  subtitle: 'Photos pending approval will appear here',
                )
              : Column(
                  children: [
                    // Header with count
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Row(
                        children: [
                          Icon(
                            Icons.pending_actions,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            '$totalCount photo${totalCount > 1 ? 's' : ''} pending review',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),

                    // Photo grid
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () =>
                            ref.read(photoGalleryProvider.notifier).refresh(),
                        child: GridView.builder(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: AppSpacing.sm,
                            mainAxisSpacing: AppSpacing.sm,
                          ),
                          itemCount: photos.length,
                          itemBuilder: (context, index) {
                            final photo = photos[index];
                            return _PhotoCard(
                              photo: photo,
                              onApprove: () {
                                ref
                                    .read(photoGalleryProvider.notifier)
                                    .approvePhoto(photo.id);
                              },
                              onReject: () {
                                _showRejectDialog(context, ref, photo.id);
                              },
                              onTap: () {
                                _showPhotoDetail(context, ref, photo);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
      },
    );
  }

  void _showRejectDialog(BuildContext context, WidgetRef ref, int photoId) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Photo'),
        content: TextField(
          controller: reasonController,
          decoration: const InputDecoration(
            labelText: 'Reason (optional)',
            hintText: 'Enter reason for rejection',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(photoGalleryProvider.notifier).rejectPhoto(
                    photoId,
                    reason: reasonController.text.isNotEmpty
                        ? reasonController.text
                        : null,
                  );
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  void _showPhotoDetail(BuildContext context, WidgetRef ref, PhotoModel photo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _PhotoDetailSheet(
        photo: photo,
        onApprove: () {
          ref.read(photoGalleryProvider.notifier).approvePhoto(photo.id);
          Navigator.pop(context);
        },
        onReject: () {
          Navigator.pop(context);
          _showRejectDialog(context, ref, photo.id);
        },
      ),
    );
  }
}

/// Photo card widget
class _PhotoCard extends StatelessWidget {
  const _PhotoCard({
    required this.photo,
    required this.onApprove,
    required this.onReject,
    required this.onTap,
  });

  final PhotoModel photo;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Photo
            Expanded(
              child: Image.network(
                photo.displayUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildPlaceholder(theme),
              ),
            ),

            // Info and actions
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Photo type
                  Text(
                    photo.type.displayName,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: AppSpacing.xs),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onReject,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.error,
                            side: const BorderSide(color: AppColors.error),
                            padding: const EdgeInsets.symmetric(vertical: 4),
                          ),
                          child: const Icon(Icons.close, size: 20),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: FilledButton(
                          onPressed: onApprove,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.success,
                            padding: const EdgeInsets.symmetric(vertical: 4),
                          ),
                          child: const Icon(Icons.check, size: 20),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 48,
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        ),
      ),
    );
  }
}

/// Photo detail bottom sheet
class _PhotoDetailSheet extends StatelessWidget {
  const _PhotoDetailSheet({
    required this.photo,
    required this.onApprove,
    required this.onReject,
  });

  final PhotoModel photo;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Photo
              Expanded(
                child: InteractiveViewer(
                  child: Image.network(
                    photo.url,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 64,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),

              // Details and actions
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Photo info
                      Text(
                        photo.type.displayName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),

                      if (photo.caption != null) ...[
                        Text(
                          photo.caption!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                      ],

                      // Uploaded date
                      if (photo.createdAt != null)
                        Text(
                          'Uploaded ${_formatDate(photo.createdAt!)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),

                      const SizedBox(height: AppSpacing.md),

                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: onReject,
                              icon: const Icon(Icons.close),
                              label: const Text('Reject'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.error,
                                side: const BorderSide(color: AppColors.error),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: onApprove,
                              icon: const Icon(Icons.check),
                              label: const Text('Approve'),
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.success,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
