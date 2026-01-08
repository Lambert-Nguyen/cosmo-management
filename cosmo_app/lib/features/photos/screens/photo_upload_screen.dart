/// Photo upload screen for Cosmo Management
///
/// Screen for batch photo upload with progress indication.
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/photo_model.dart';
import '../providers/photo_providers.dart';
import '../providers/photo_upload_notifier.dart';
import '../widgets/upload_progress_indicator.dart';

/// Photo upload screen
class PhotoUploadScreen extends ConsumerStatefulWidget {
  final PhotoType photoType;
  final String? entityType;
  final int? entityId;
  final String? title;

  const PhotoUploadScreen({
    super.key,
    this.photoType = PhotoType.general,
    this.entityType,
    this.entityId,
    this.title,
  });

  @override
  ConsumerState<PhotoUploadScreen> createState() => _PhotoUploadScreenState();
}

class _PhotoUploadScreenState extends ConsumerState<PhotoUploadScreen> {
  final _picker = ImagePicker();
  final _selectedFiles = <File>[];

  @override
  void dispose() {
    // Clear upload state when leaving
    ref.read(photoUploadProvider.notifier).clear();
    super.dispose();
  }

  Future<void> _pickFromGallery() async {
    final images = await _picker.pickMultiImage(
      imageQuality: 85,
      maxWidth: 1920,
      maxHeight: 1920,
    );

    if (images.isNotEmpty) {
      setState(() {
        _selectedFiles.addAll(images.map((xfile) => File(xfile.path)));
      });
    }
  }

  Future<void> _pickFromCamera() async {
    final image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
      maxWidth: 1920,
      maxHeight: 1920,
    );

    if (image != null) {
      setState(() {
        _selectedFiles.add(File(image.path));
      });
    }
  }

  void _removeFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
  }

  void _startUpload() {
    if (_selectedFiles.isEmpty) return;

    ref.read(photoUploadProvider.notifier).addFiles(
          _selectedFiles,
          type: widget.photoType,
          entityType: widget.entityType,
          entityId: widget.entityId,
        );

    ref.read(photoUploadProvider.notifier).startUpload();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final uploadState = ref.watch(photoUploadProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Upload Photos'),
        actions: [
          if (_selectedFiles.isNotEmpty && uploadState is! PhotoUploadInProgress)
            TextButton(
              onPressed: _startUpload,
              child: const Text('Upload'),
            ),
        ],
      ),
      body: _buildBody(uploadState, theme),
      floatingActionButton: uploadState is! PhotoUploadInProgress
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  heroTag: 'camera',
                  onPressed: _pickFromCamera,
                  child: const Icon(Icons.camera_alt),
                ),
                const SizedBox(height: AppSpacing.md),
                FloatingActionButton.extended(
                  heroTag: 'gallery',
                  onPressed: _pickFromGallery,
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Gallery'),
                ),
              ],
            )
          : null,
    );
  }

  Widget _buildBody(PhotoUploadState state, ThemeData theme) {
    return switch (state) {
      PhotoUploadInitial() => _buildSelectionView(theme),
      PhotoUploadInProgress() => _buildUploadProgressView(state, theme),
      PhotoUploadCompleted(result: final result) => _buildCompletedView(result, theme),
      PhotoUploadError(message: final msg, failedItems: final items) =>
        _buildErrorView(msg, items, theme),
    };
  }

  Widget _buildSelectionView(ThemeData theme) {
    if (_selectedFiles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 80,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Select Photos to Upload',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Tap the buttons below to add photos',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Selected count header
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          color: theme.colorScheme.surfaceContainerHighest,
          child: Row(
            children: [
              Icon(Icons.photo_library, color: theme.colorScheme.primary),
              const SizedBox(width: AppSpacing.sm),
              Text(
                '${_selectedFiles.length} photo${_selectedFiles.length == 1 ? '' : 's'} selected',
                style: theme.textTheme.titleSmall,
              ),
              const Spacer(),
              TextButton(
                onPressed: () => setState(() => _selectedFiles.clear()),
                child: const Text('Clear All'),
              ),
            ],
          ),
        ),

        // Photo grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(AppSpacing.sm),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: AppSpacing.xs,
              mainAxisSpacing: AppSpacing.xs,
            ),
            itemCount: _selectedFiles.length,
            itemBuilder: (context, index) {
              return _buildPhotoTile(_selectedFiles[index], index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoTile(File file, int index) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.xs),
          child: Image.file(
            file,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => _removeFile(index),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadProgressView(PhotoUploadInProgress state, ThemeData theme) {
    return Column(
      children: [
        // Overall progress
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              Text(
                'Uploading Photos...',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.md),
              LinearProgressIndicator(value: state.calculatedProgress),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '${state.completedCount} of ${state.items.length} completed',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),

        // Individual items
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              final item = state.items[index];
              return UploadProgressIndicator(item: item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCompletedView(PhotoUploadResult result, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle,
            size: 80,
            color: AppColors.success,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Upload Complete!',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            result.summaryMessage,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(result),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(
    String message,
    List<PhotoUploadItem> failedItems,
    ThemeData theme,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: AppColors.error,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Upload Failed',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (failedItems.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                '${failedItems.length} file(s) failed',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.error,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: AppSpacing.md),
                FilledButton(
                  onPressed: () {
                    ref.read(photoUploadProvider.notifier).retryFailed();
                  },
                  child: const Text('Retry Failed'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
