/// Upload progress indicator widget for Cosmo Management
///
/// Displays individual upload item progress with status.
library;

import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/photo_model.dart';

/// Upload progress indicator for a single item
class UploadProgressIndicator extends StatelessWidget {
  final PhotoUploadItem item;
  final VoidCallback? onRemove;
  final VoidCallback? onRetry;

  const UploadProgressIndicator({
    super.key,
    required this.item,
    this.onRemove,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.xs),
              child: SizedBox(
                width: 48,
                height: 48,
                child: Image.file(
                  File(item.filePath),
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.image),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),

            // Info and progress
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.fileName,
                    style: theme.textTheme.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  _buildProgressBar(theme),
                ],
              ),
            ),

            // Status icon / actions
            const SizedBox(width: AppSpacing.sm),
            _buildStatusWidget(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(ThemeData theme) {
    final (color, text) = _getStatusInfo();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: item.status == PhotoUploadStatus.uploading ? item.progress : null,
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          color: color,
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Text(
              text,
              style: theme.textTheme.labelSmall?.copyWith(color: color),
            ),
            if (item.status == PhotoUploadStatus.uploading) ...[
              const Spacer(),
              Text(
                '${item.progressPercent}%',
                style: theme.textTheme.labelSmall,
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildStatusWidget(ThemeData theme) {
    return switch (item.status) {
      PhotoUploadStatus.pending => Icon(
          Icons.hourglass_empty,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      PhotoUploadStatus.uploading => SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            value: item.progress,
          ),
        ),
      PhotoUploadStatus.uploaded => Icon(
          Icons.check_circle,
          color: AppColors.success,
        ),
      PhotoUploadStatus.failed => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error, color: AppColors.error),
            if (onRetry != null)
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: onRetry,
                tooltip: 'Retry',
                iconSize: 20,
              ),
          ],
        ),
    };
  }

  (Color, String) _getStatusInfo() {
    return switch (item.status) {
      PhotoUploadStatus.pending => (Colors.grey, 'Waiting...'),
      PhotoUploadStatus.uploading => (AppColors.info, 'Uploading...'),
      PhotoUploadStatus.uploaded => (AppColors.success, 'Complete'),
      PhotoUploadStatus.failed => (AppColors.error, item.errorMessage ?? 'Failed'),
    };
  }
}

/// Compact upload progress for use in other screens
class CompactUploadProgress extends StatelessWidget {
  final int pending;
  final int completed;
  final int failed;
  final double progress;

  const CompactUploadProgress({
    super.key,
    required this.pending,
    required this.completed,
    required this.failed,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = pending + completed + failed;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              value: progress,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Uploading $completed of $total',
                  style: theme.textTheme.labelMedium,
                ),
                if (failed > 0)
                  Text(
                    '$failed failed',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.error,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
