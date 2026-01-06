/// Checklist section widget for Cosmo Management
///
/// Expandable sections showing checklist items grouped by type.
library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/checklist_model.dart';
import 'checklist_check_item.dart';
import 'checklist_number_item.dart';
import 'checklist_photo_item.dart';
import 'checklist_text_item.dart';

/// Expandable checklist section
///
/// Groups checklist items by type with completion count.
class ChecklistSection extends StatelessWidget {
  const ChecklistSection({
    super.key,
    required this.checklist,
    required this.onItemCompleted,
    required this.onTextSubmitted,
    required this.onNumberSubmitted,
    required this.onPhotoTaken,
    this.isOffline = false,
  });

  final TaskChecklistModel checklist;
  final void Function(int itemId, bool completed) onItemCompleted;
  final void Function(int itemId, String text) onTextSubmitted;
  final void Function(int itemId, double number) onNumberSubmitted;
  final void Function(int itemId, String photoPath) onPhotoTaken;
  final bool isOffline;

  @override
  Widget build(BuildContext context) {
    if (checklist.items.isEmpty) {
      return const SizedBox.shrink();
    }

    // Group items by type
    final grouped = checklist.itemsByType;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Overall progress
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            children: [
              Text(
                'Checklist',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(width: AppSpacing.sm),
              _buildProgressBadge(context),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        // Progress bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: checklist.completionPercentage / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation(
                checklist.completionPercentage >= 100
                    ? AppColors.success
                    : AppColors.primary,
              ),
              minHeight: 6,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Grouped sections
        for (final entry in grouped.entries)
          _ChecklistTypeSection(
            type: entry.key,
            items: entry.value,
            checklist: checklist,
            onItemCompleted: onItemCompleted,
            onTextSubmitted: onTextSubmitted,
            onNumberSubmitted: onNumberSubmitted,
            onPhotoTaken: onPhotoTaken,
            isOffline: isOffline,
          ),
      ],
    );
  }

  Widget _buildProgressBadge(BuildContext context) {
    final completed = checklist.completedItems;
    final total = checklist.totalItems;
    final isComplete = completed == total && total > 0;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: isComplete
            ? AppColors.success.withValues(alpha: 0.1)
            : AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$completed/$total',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: isComplete ? AppColors.success : AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

/// Section for a specific checklist item type
class _ChecklistTypeSection extends StatelessWidget {
  const _ChecklistTypeSection({
    required this.type,
    required this.items,
    required this.checklist,
    required this.onItemCompleted,
    required this.onTextSubmitted,
    required this.onNumberSubmitted,
    required this.onPhotoTaken,
    required this.isOffline,
  });

  final ChecklistItemType type;
  final List<ChecklistItemModel> items;
  final TaskChecklistModel checklist;
  final void Function(int itemId, bool completed) onItemCompleted;
  final void Function(int itemId, String text) onTextSubmitted;
  final void Function(int itemId, double number) onNumberSubmitted;
  final void Function(int itemId, String photoPath) onPhotoTaken;
  final bool isOffline;

  @override
  Widget build(BuildContext context) {
    final completionCount = checklist.getCompletionCountForType(type);
    final parts = completionCount.split('/');
    final completedCount = int.tryParse(parts[0]) ?? 0;
    final totalCount = int.tryParse(parts[1]) ?? 0;
    final isAllCompleted = completedCount == totalCount && totalCount > 0;

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: ExpansionTile(
        initiallyExpanded: !isAllCompleted,
        leading: Icon(
          _getTypeIcon(),
          color: isAllCompleted ? AppColors.success : _getTypeColor(),
        ),
        title: Text(_getTypeLabel()),
        subtitle: Text(
          '$completionCount completed',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isAllCompleted ? AppColors.success : null,
              ),
        ),
        trailing: isAllCompleted
            ? const Icon(Icons.check_circle, color: AppColors.success)
            : null,
        children: [
          for (final item in items) _buildItem(context, item),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, ChecklistItemModel item) {
    final response = checklist.getResponseForItem(item.id);
    final photos = response != null
        ? checklist.getPhotosForResponse(response.id)
        : <ChecklistPhotoModel>[];

    return switch (type) {
      ChecklistItemType.check ||
      ChecklistItemType.blocking =>
        ChecklistCheckItem(
          item: item,
          response: response,
          onChanged: (completed) => onItemCompleted(item.id, completed),
          isBlocking: type == ChecklistItemType.blocking,
        ),
      ChecklistItemType.photoRequired ||
      ChecklistItemType.photoOptional =>
        ChecklistPhotoItem(
          item: item,
          response: response,
          photos: photos,
          onPhotoTaken: (path) => onPhotoTaken(item.id, path),
          isRequired: type == ChecklistItemType.photoRequired,
          isOffline: isOffline,
        ),
      ChecklistItemType.textInput => ChecklistTextItem(
          item: item,
          response: response,
          onSubmitted: (text) => onTextSubmitted(item.id, text),
        ),
      ChecklistItemType.numberInput => ChecklistNumberItem(
          item: item,
          response: response,
          onSubmitted: (number) => onNumberSubmitted(item.id, number),
        ),
    };
  }

  IconData _getTypeIcon() {
    return switch (type) {
      ChecklistItemType.check => Icons.check_box_outlined,
      ChecklistItemType.blocking => Icons.block,
      ChecklistItemType.photoRequired => Icons.camera_alt,
      ChecklistItemType.photoOptional => Icons.add_a_photo_outlined,
      ChecklistItemType.textInput => Icons.text_fields,
      ChecklistItemType.numberInput => Icons.numbers,
    };
  }

  Color _getTypeColor() {
    return switch (type) {
      ChecklistItemType.check => AppColors.primary,
      ChecklistItemType.blocking => AppColors.error,
      ChecklistItemType.photoRequired => AppColors.warning,
      ChecklistItemType.photoOptional => AppColors.info,
      ChecklistItemType.textInput => AppColors.primary,
      ChecklistItemType.numberInput => AppColors.primary,
    };
  }

  String _getTypeLabel() {
    return switch (type) {
      ChecklistItemType.check => 'Checkboxes',
      ChecklistItemType.blocking => 'Blocking Items',
      ChecklistItemType.photoRequired => 'Required Photos',
      ChecklistItemType.photoOptional => 'Optional Photos',
      ChecklistItemType.textInput => 'Text Inputs',
      ChecklistItemType.numberInput => 'Number Inputs',
    };
  }
}

/// Simple flat checklist (non-grouped)
class FlatChecklist extends StatelessWidget {
  const FlatChecklist({
    super.key,
    required this.checklist,
    required this.onItemCompleted,
    required this.onTextSubmitted,
    required this.onNumberSubmitted,
    required this.onPhotoTaken,
    this.isOffline = false,
  });

  final TaskChecklistModel checklist;
  final void Function(int itemId, bool completed) onItemCompleted;
  final void Function(int itemId, String text) onTextSubmitted;
  final void Function(int itemId, double number) onNumberSubmitted;
  final void Function(int itemId, String photoPath) onPhotoTaken;
  final bool isOffline;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in checklist.items) _buildItem(item),
      ],
    );
  }

  Widget _buildItem(ChecklistItemModel item) {
    final response = checklist.getResponseForItem(item.id);
    final photos = response != null
        ? checklist.getPhotosForResponse(response.id)
        : <ChecklistPhotoModel>[];

    return switch (item.itemType) {
      ChecklistItemType.check ||
      ChecklistItemType.blocking =>
        ChecklistCheckItem(
          item: item,
          response: response,
          onChanged: (completed) => onItemCompleted(item.id, completed),
          isBlocking: item.itemType == ChecklistItemType.blocking,
        ),
      ChecklistItemType.photoRequired ||
      ChecklistItemType.photoOptional =>
        ChecklistPhotoItem(
          item: item,
          response: response,
          photos: photos,
          onPhotoTaken: (path) => onPhotoTaken(item.id, path),
          isRequired: item.itemType == ChecklistItemType.photoRequired,
          isOffline: isOffline,
        ),
      ChecklistItemType.textInput => ChecklistTextItem(
          item: item,
          response: response,
          onSubmitted: (text) => onTextSubmitted(item.id, text),
        ),
      ChecklistItemType.numberInput => ChecklistNumberItem(
          item: item,
          response: response,
          onSubmitted: (number) => onNumberSubmitted(item.id, number),
        ),
    };
  }
}
