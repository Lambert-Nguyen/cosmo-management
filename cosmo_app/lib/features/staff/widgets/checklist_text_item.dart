/// Checklist text item widget for Cosmo Management
///
/// Text input checklist item.
library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/checklist_model.dart';

/// Text input checklist item
///
/// Displays a text field for user input.
class ChecklistTextItem extends StatefulWidget {
  const ChecklistTextItem({
    super.key,
    required this.item,
    required this.onSubmitted,
    this.response,
  });

  final ChecklistItemModel item;
  final ChecklistResponseModel? response;
  final void Function(String text) onSubmitted;

  @override
  State<ChecklistTextItem> createState() => _ChecklistTextItemState();
}

class _ChecklistTextItemState extends State<ChecklistTextItem> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _isEditing = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.response?.textResponse ?? '',
    );
    _focusNode = FocusNode();

    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(ChecklistTextItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update controller if response changed externally
    if (widget.response?.textResponse != oldWidget.response?.textResponse) {
      _controller.text = widget.response?.textResponse ?? '';
      _hasChanges = false;
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final currentText = widget.response?.textResponse ?? '';
    setState(() {
      _hasChanges = _controller.text != currentText;
    });
  }

  void _onFocusChanged() {
    setState(() {
      _isEditing = _focusNode.hasFocus;
    });

    // Auto-save when losing focus if there are changes
    if (!_focusNode.hasFocus && _hasChanges) {
      _submit();
    }
  }

  void _submit() {
    if (_controller.text.isNotEmpty) {
      widget.onSubmitted(_controller.text);
      setState(() {
        _hasChanges = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasValue = widget.response?.textResponse?.isNotEmpty ?? false;

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
                  widget.item.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (widget.item.isRequired && !hasValue)
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
              if (hasValue && !_isEditing)
                const Icon(
                  Icons.check_circle,
                  size: 18,
                  color: AppColors.success,
                ),
            ],
          ),

          // Notes
          if (widget.item.description != null &&
              widget.item.description!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xxs),
            Text(
              widget.item.description!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],

          const SizedBox(height: AppSpacing.sm),

          // Text field
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            maxLines: 3,
            minLines: 1,
            decoration: InputDecoration(
              hintText: 'Enter your response...',
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: _isEditing ? null : Colors.grey[50],
              suffixIcon: _hasChanges
                  ? IconButton(
                      icon: const Icon(Icons.check, color: AppColors.success),
                      onPressed: _submit,
                      tooltip: 'Save',
                    )
                  : null,
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
          ),

          // Status info
          if (widget.response != null && !_isEditing) ...[
            const SizedBox(height: AppSpacing.xxs),
            if (widget.response!.completedAt != null)
              Text(
                'Last updated ${_formatTimestamp(widget.response!.completedAt!)}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ],
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

/// Read-only text response display
class TextResponseDisplay extends StatelessWidget {
  const TextResponseDisplay({
    super.key,
    required this.item,
    this.response,
    this.onEdit,
  });

  final ChecklistItemModel item;
  final ChecklistResponseModel? response;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
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
              if (onEdit != null)
                IconButton(
                  icon: const Icon(Icons.edit, size: 18),
                  onPressed: onEdit,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),

          const SizedBox(height: AppSpacing.xs),

          // Response text
          if (response?.textResponse != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                response!.textResponse!,
                style: theme.textTheme.bodyMedium,
              ),
            )
          else
            Text(
              'No response',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }
}
