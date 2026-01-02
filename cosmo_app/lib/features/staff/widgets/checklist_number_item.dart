/// Checklist number item widget for Cosmo Management
///
/// Number input checklist item.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/checklist_model.dart';

/// Number input checklist item
///
/// Displays a number input field with increment/decrement buttons.
class ChecklistNumberItem extends StatefulWidget {
  const ChecklistNumberItem({
    super.key,
    required this.item,
    required this.onSubmitted,
    this.response,
    this.minValue,
    this.maxValue,
    this.step = 1,
    this.unit,
  });

  final ChecklistItemModel item;
  final ChecklistResponseModel? response;
  final void Function(double number) onSubmitted;
  final double? minValue;
  final double? maxValue;
  final double step;
  final String? unit;

  @override
  State<ChecklistNumberItem> createState() => _ChecklistNumberItemState();
}

class _ChecklistNumberItemState extends State<ChecklistNumberItem> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _isEditing = false;
  bool _hasChanges = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    final initialValue = widget.response?.numberResponse;
    _controller = TextEditingController(
      text: initialValue?.toString() ?? '',
    );
    _focusNode = FocusNode();

    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(ChecklistNumberItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update controller if response changed externally
    if (widget.response?.numberResponse != oldWidget.response?.numberResponse) {
      final newValue = widget.response?.numberResponse;
      _controller.text = newValue?.toString() ?? '';
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
    final currentValue = widget.response?.numberResponse;
    final newValue = double.tryParse(_controller.text);

    setState(() {
      _hasChanges = newValue != currentValue;
      _errorText = _validate(newValue);
    });
  }

  void _onFocusChanged() {
    setState(() {
      _isEditing = _focusNode.hasFocus;
    });

    // Auto-save when losing focus if there are changes and valid
    if (!_focusNode.hasFocus && _hasChanges && _errorText == null) {
      _submit();
    }
  }

  String? _validate(double? value) {
    if (value == null && widget.item.isRequired) {
      return 'Required';
    }

    if (value != null) {
      final min = widget.minValue;
      final max = widget.maxValue;

      if (min != null && value < min) {
        return 'Must be at least $min';
      }
      if (max != null && value > max) {
        return 'Must be at most $max';
      }
    }

    return null;
  }

  void _submit() {
    final value = double.tryParse(_controller.text);
    if (value != null && _errorText == null) {
      widget.onSubmitted(value);
      setState(() {
        _hasChanges = false;
      });
    }
  }

  void _increment() {
    final current = double.tryParse(_controller.text) ?? 0;
    final newValue = current + widget.step;

    // Check max bound
    final max = widget.maxValue;
    if (max != null && newValue > max) return;

    _controller.text = _formatNumber(newValue);
    _submit();
  }

  void _decrement() {
    final current = double.tryParse(_controller.text) ?? 0;
    final newValue = current - widget.step;

    // Check min bound
    final min = widget.minValue;
    if (min != null && newValue < min) return;

    _controller.text = _formatNumber(newValue);
    _submit();
  }

  String _formatNumber(double value) {
    // Remove decimal if it's a whole number
    if (value == value.roundToDouble()) {
      return value.round().toString();
    }
    return value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasValue = widget.response?.numberResponse != null;

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
              if (hasValue && !_isEditing && _errorText == null)
                const Icon(
                  Icons.check_circle,
                  size: 18,
                  color: AppColors.success,
                ),
            ],
          ),

          // Notes and range info
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

          // Range hint
          if (widget.minValue != null || widget.maxValue != null) ...[
            const SizedBox(height: AppSpacing.xxs),
            Text(
              _getRangeHint(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],

          const SizedBox(height: AppSpacing.sm),

          // Number input with stepper
          Row(
            children: [
              // Decrement button
              _StepperButton(
                icon: Icons.remove,
                onPressed: _decrement,
                enabled: _canDecrement(),
              ),

              const SizedBox(width: AppSpacing.sm),

              // Number input
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[\d.-]')),
                  ],
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: '0',
                    border: const OutlineInputBorder(),
                    errorText: _errorText,
                    suffixText: widget.unit,
                    suffixIcon: _hasChanges && _errorText == null
                        ? IconButton(
                            icon: const Icon(Icons.check,
                                color: AppColors.success),
                            onPressed: _submit,
                            tooltip: 'Save',
                          )
                        : null,
                  ),
                  onSubmitted: (_) => _submit(),
                ),
              ),

              const SizedBox(width: AppSpacing.sm),

              // Increment button
              _StepperButton(
                icon: Icons.add,
                onPressed: _increment,
                enabled: _canIncrement(),
              ),
            ],
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

  bool _canIncrement() {
    final current = double.tryParse(_controller.text) ?? 0;
    final max = widget.maxValue;
    if (max == null) return true;
    return current + widget.step <= max;
  }

  bool _canDecrement() {
    final current = double.tryParse(_controller.text) ?? 0;
    final min = widget.minValue;
    if (min == null) return true;
    return current - widget.step >= min;
  }

  String _getRangeHint() {
    final min = widget.minValue;
    final max = widget.maxValue;
    final unit = widget.unit ?? '';

    if (min != null && max != null) {
      return 'Range: $min - $max $unit';
    } else if (min != null) {
      return 'Min: $min $unit';
    } else if (max != null) {
      return 'Max: $max $unit';
    }
    return '';
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

/// Stepper button for increment/decrement
class _StepperButton extends StatelessWidget {
  const _StepperButton({
    required this.icon,
    required this.onPressed,
    this.enabled = true,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: enabled ? AppColors.primary : Colors.grey[300],
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(
            icon,
            size: 20,
            color: enabled ? Colors.white : Colors.grey[500],
          ),
        ),
      ),
    );
  }
}

/// Read-only number display
class NumberResponseDisplay extends StatelessWidget {
  const NumberResponseDisplay({
    super.key,
    required this.item,
    this.response,
    this.unit,
    this.onEdit,
  });

  final ChecklistItemModel item;
  final ChecklistResponseModel? response;
  final String? unit;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                if (response?.numberResponse != null)
                  Text(
                    '${response!.numberResponse} ${unit ?? ''}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  )
                else
                  Text(
                    'No value',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ),
          if (onEdit != null)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
            ),
        ],
      ),
    );
  }
}
