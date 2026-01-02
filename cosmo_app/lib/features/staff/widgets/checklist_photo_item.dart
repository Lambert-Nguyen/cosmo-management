/// Checklist photo item widget for Cosmo Management
///
/// Photo capture/display checklist item.
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/checklist_model.dart';

/// Photo checklist item
///
/// Displays photo capture button or captured photo.
class ChecklistPhotoItem extends StatelessWidget {
  const ChecklistPhotoItem({
    super.key,
    required this.item,
    required this.onPhotoTaken,
    this.response,
    this.photos = const [],
    this.isRequired = false,
    this.isOffline = false,
  });

  final ChecklistItemModel item;
  final ChecklistResponseModel? response;
  final List<ChecklistPhotoModel> photos;
  final void Function(String photoPath) onPhotoTaken;
  final bool isRequired;
  final bool isOffline;

  bool get hasPhoto => photos.isNotEmpty;
  bool get isCompleted => response?.isCompleted ?? false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label row
          Row(
            children: [
              Expanded(
                child: Text(
                  item.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (isRequired && !hasPhoto)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Required',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ),
              if (hasPhoto)
                const Icon(
                  Icons.check_circle,
                  size: 18,
                  color: AppColors.success,
                ),
            ],
          ),

          // Notes
          if (item.description != null && item.description!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xxs),
            Text(
              item.description!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],

          const SizedBox(height: AppSpacing.sm),

          // Photo area
          if (hasPhoto)
            _buildPhotoPreview(context)
          else
            _buildCaptureButton(context),
        ],
      ),
    );
  }

  Widget _buildPhotoPreview(BuildContext context) {
    final photo = photos.first;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Photo grid for multiple photos
        if (photos.length > 1)
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: photos.length + 1, // +1 for add button
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.xs),
              itemBuilder: (context, index) {
                if (index == photos.length) {
                  return _buildAddMoreButton(context);
                }
                return _buildPhotoThumbnail(context, photos[index]);
              },
            ),
          )
        else
          // Single photo display
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                _buildPhoto(photo.image),
                Positioned(
                  top: AppSpacing.xs,
                  right: AppSpacing.xs,
                  child: _PhotoActionButtons(
                    onRetake: () => _showPhotoOptions(context),
                    onView: () => _viewPhoto(context, photo.image),
                  ),
                ),
              ],
            ),
          ),

        // Timestamp
        if (photo.uploadedAt != null) ...[
          const SizedBox(height: AppSpacing.xxs),
          Text(
            'Captured ${_formatTimestamp(photo.uploadedAt!)}',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPhotoThumbnail(BuildContext context, ChecklistPhotoModel photo) {
    return GestureDetector(
      onTap: () => _viewPhoto(context, photo.image),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 100,
          height: 100,
          child: _buildPhoto(photo.image, height: 100),
        ),
      ),
    );
  }

  Widget _buildAddMoreButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPhotoOptions(context),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo, color: Colors.grey),
            SizedBox(height: 4),
            Text('Add', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoto(String path, {double height = 150}) {
    // Check if it's a network URL or local file
    if (path.startsWith('http')) {
      return Image.network(
        path,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildPhotoError(height),
        loadingBuilder: (_, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildPhotoLoading(height);
        },
      );
    } else {
      return Image.file(
        File(path),
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildPhotoError(height),
      );
    }
  }

  Widget _buildPhotoError(double height) {
    return Container(
      height: height,
      width: double.infinity,
      color: Colors.grey[200],
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image, size: 32, color: Colors.grey),
          SizedBox(height: AppSpacing.xs),
          Text('Failed to load photo'),
        ],
      ),
    );
  }

  Widget _buildPhotoLoading(double height) {
    return Container(
      height: height,
      width: double.infinity,
      color: Colors.grey[200],
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildCaptureButton(BuildContext context) {
    return InkWell(
      onTap: () => _showPhotoOptions(context),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: isRequired ? AppColors.error : Colors.grey[300]!,
            width: isRequired ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[50],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_a_photo,
              size: 32,
              color: isRequired ? AppColors.error : Colors.grey[600],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              isOffline ? 'Take Photo (Offline)' : 'Take Photo',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isRequired ? AppColors.error : Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _takePhoto(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickFromGallery(context);
              },
            ),
            if (hasPhoto)
              ListTile(
                leading: const Icon(Icons.delete, color: AppColors.error),
                title: const Text(
                  'Remove Photo',
                  style: TextStyle(color: AppColors.error),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Clear photo by passing empty string
                  onPhotoTaken('');
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _takePhoto(BuildContext context) async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (image != null) {
        onPhotoTaken(image.path);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error taking photo: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _pickFromGallery(BuildContext context) async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (image != null) {
        onPhotoTaken(image.path);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking photo: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _viewPhoto(BuildContext context, String path) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _PhotoViewScreen(photoPath: path),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';

    return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
  }
}

/// Photo action buttons overlay
class _PhotoActionButtons extends StatelessWidget {
  const _PhotoActionButtons({
    required this.onRetake,
    required this.onView,
  });

  final VoidCallback onRetake;
  final VoidCallback onView;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildButton(
          icon: Icons.fullscreen,
          onTap: onView,
        ),
        const SizedBox(width: AppSpacing.xxs),
        _buildButton(
          icon: Icons.camera_alt,
          onTap: onRetake,
        ),
      ],
    );
  }

  Widget _buildButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.black54,
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(
            icon,
            size: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

/// Full screen photo view
class _PhotoViewScreen extends StatelessWidget {
  const _PhotoViewScreen({required this.photoPath});

  final String photoPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: photoPath.startsWith('http')
              ? Image.network(photoPath)
              : Image.file(File(photoPath)),
        ),
      ),
    );
  }
}
