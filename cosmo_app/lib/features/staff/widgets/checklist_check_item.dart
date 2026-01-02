/// Checklist check item widget for Cosmo Management
///
/// Checkbox type checklist item.
library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/checklist_model.dart';

/// Checkbox checklist item
///
/// Displays a checkbox with label and optional notes.
class ChecklistCheckItem extends StatelessWidget {
  const ChecklistCheckItem({
    super.key,
    required this.item,
    required this.onChanged,
    this.response,
    this.isBlocking = false,
  });

  final ChecklistItemModel item;
  final ChecklistResponseModel? response;
  final void Function(bool completed) onChanged;
  final bool isBlocking;

  bool get isCompleted => response?.isCompleted ?? false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Checkbox
          Checkbox(
            value: isCompleted,
            onChanged: (value) => onChanged(value ?? false),
            activeColor: isBlocking ? AppColors.error : AppColors.primary,
          ),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label with blocking indicator
                  Row(
                    children: [
                      if (isBlocking) ...[
                        const Icon(
                          Icons.warning_amber_rounded,
                          size: 16,
                          color: AppColors.error,
                        ),
                        const SizedBox(width: AppSpacing.xxs),
                      ],
                      Expanded(
                        child: Text(
                          item.title,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            decoration: isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: isCompleted
                                ? theme.colorScheme.onSurfaceVariant
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Notes/description
                  if (item.description != null &&
                      item.description!.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      item.description!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],

                  // Response info
                  if (response != null && isCompleted) ...[
                    const SizedBox(height: AppSpacing.xs),
                    _buildResponseInfo(context),
                  ],
                ],
              ),
            ),
          ),

          // Required indicator
          if (item.isRequired && !isCompleted)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                '*',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildResponseInfo(BuildContext context) {
    final theme = Theme.of(context);
    final completedAt = response?.completedAt;

    return Row(
      children: [
        const Icon(
          Icons.check_circle,
          size: 14,
          color: AppColors.success,
        ),
        const SizedBox(width: AppSpacing.xxs),
        Expanded(
          child: Text(
            completedAt != null
                ? 'Completed ${_formatTimestamp(completedAt)}'
                : 'Completed',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';

    return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
  }
}

/// Blocking item warning dialog
class BlockingItemDialog extends StatelessWidget {
  const BlockingItemDialog({
    super.key,
    required this.item,
    required this.onConfirm,
  });

  final ChecklistItemModel item;
  final VoidCallback onConfirm;

  static Future<bool?> show(
    BuildContext context, {
    required ChecklistItemModel item,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => BlockingItemDialog(
        item: item,
        onConfirm: () => Navigator.of(context).pop(true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: AppColors.error),
          SizedBox(width: AppSpacing.sm),
          Text('Blocking Item'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'This is a blocking item. Marking it incomplete will prevent task completion.',
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Item: ${item.title}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: onConfirm,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.error,
          ),
          child: const Text('Mark Incomplete'),
        ),
      ],
    );
  }
}
