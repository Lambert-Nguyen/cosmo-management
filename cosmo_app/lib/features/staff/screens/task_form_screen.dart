/// Task form screen for Cosmo Management
///
/// Create or edit a task.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/inputs/app_text_field.dart';
import '../../../data/models/task_model.dart';

/// Task form screen for creating or editing tasks
class TaskFormScreen extends ConsumerStatefulWidget {
  const TaskFormScreen({
    super.key,
    this.taskId,
  });

  /// If null, creating a new task; otherwise editing existing
  final int? taskId;

  bool get isEditing => taskId != null;

  @override
  ConsumerState<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends ConsumerState<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  TaskPriority _priority = TaskPriority.medium;
  DateTime? _dueDate;
  int? _propertyId;
  int? _assigneeId;
  bool _isLoading = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      _loadTask();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadTask() async {
    // TODO: Load existing task data for editing
  }

  void _onFieldChanged() {
    if (!_hasChanges) {
      setState(() => _hasChanges = true);
    }
  }

  Future<void> _selectDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_dueDate ?? DateTime.now()),
      );

      setState(() {
        _dueDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          time?.hour ?? 12,
          time?.minute ?? 0,
        );
        _hasChanges = true;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // TODO: Implement save logic
      await Future.delayed(const Duration(seconds: 1)); // Placeholder

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isEditing
                  ? 'Task updated successfully'
                  : 'Task created successfully',
            ),
          ),
        );
        context.pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<bool> _onWillPop() async {
    if (!_hasChanges) return true;

    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text(
          'You have unsaved changes. Are you sure you want to discard them?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep Editing'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );

    return shouldPop ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_hasChanges,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && mounted) {
          context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.isEditing ? 'Edit Task' : 'New Task'),
          actions: [
            TextButton(
              onPressed: _isLoading ? null : _save,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save'),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              // Title
              AppTextField(
                controller: _titleController,
                label: 'Title',
                hint: 'Enter task title',
                isRequired: true,
                onChanged: (_) => _onFieldChanged(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Title is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),

              // Description
              AppTextField(
                controller: _descriptionController,
                label: 'Description',
                hint: 'Enter task description',
                maxLines: 4,
                onChanged: (_) => _onFieldChanged(),
              ),
              const SizedBox(height: AppSpacing.md),

              // Priority selector
              _PrioritySelector(
                value: _priority,
                onChanged: (priority) {
                  setState(() {
                    _priority = priority;
                    _hasChanges = true;
                  });
                },
              ),
              const SizedBox(height: AppSpacing.md),

              // Due date
              _DueDateField(
                value: _dueDate,
                onTap: _selectDueDate,
                onClear: () {
                  setState(() {
                    _dueDate = null;
                    _hasChanges = true;
                  });
                },
              ),
              const SizedBox(height: AppSpacing.md),

              // Property dropdown
              _PropertyDropdown(
                value: _propertyId,
                onChanged: (value) {
                  setState(() {
                    _propertyId = value;
                    _hasChanges = true;
                  });
                },
              ),
              const SizedBox(height: AppSpacing.md),

              // Assignee dropdown
              _AssigneeDropdown(
                value: _assigneeId,
                onChanged: (value) {
                  setState(() {
                    _assigneeId = value;
                    _hasChanges = true;
                  });
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: FilledButton(
              onPressed: _isLoading ? null : _save,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(widget.isEditing ? 'Update Task' : 'Create Task'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Priority selector widget
class _PrioritySelector extends StatelessWidget {
  const _PrioritySelector({
    required this.value,
    required this.onChanged,
  });

  final TaskPriority value;
  final void Function(TaskPriority) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Priority',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: AppSpacing.xs),
        SegmentedButton<TaskPriority>(
          segments: [
            for (final priority in TaskPriority.values)
              ButtonSegment(
                value: priority,
                label: Text(priority.displayName),
                icon: Icon(_getPriorityIcon(priority), size: 18),
              ),
          ],
          selected: {value},
          onSelectionChanged: (selected) => onChanged(selected.first),
          showSelectedIcon: false,
        ),
      ],
    );
  }

  IconData _getPriorityIcon(TaskPriority priority) {
    return switch (priority) {
      TaskPriority.low => Icons.arrow_downward,
      TaskPriority.medium => Icons.remove,
      TaskPriority.high => Icons.arrow_upward,
      TaskPriority.urgent => Icons.priority_high,
    };
  }
}

/// Due date field widget
class _DueDateField extends StatelessWidget {
  const _DueDateField({
    required this.value,
    required this.onTap,
    required this.onClear,
  });

  final DateTime? value;
  final VoidCallback onTap;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Due Date',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: AppSpacing.xs),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    value != null ? _formatDate(value!) : 'Select due date',
                    style: value != null
                        ? null
                        : TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                  ),
                ),
                if (value != null)
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: onClear,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = date.difference(now);

    if (diff.inDays == 0) {
      return 'Today at ${_formatTime(date)}';
    } else if (diff.inDays == 1) {
      return 'Tomorrow at ${_formatTime(date)}';
    } else {
      return '${date.day}/${date.month}/${date.year} at ${_formatTime(date)}';
    }
  }

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

/// Property dropdown
class _PropertyDropdown extends StatelessWidget {
  const _PropertyDropdown({
    required this.value,
    required this.onChanged,
  });

  final int? value;
  final void Function(int?) onChanged;

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch properties from provider
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Property',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: AppSpacing.xs),
        DropdownButtonFormField<int>(
          value: value,
          decoration: const InputDecoration(
            hintText: 'Select property',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 1, child: Text('Property 1')),
            DropdownMenuItem(value: 2, child: Text('Property 2')),
            DropdownMenuItem(value: 3, child: Text('Property 3')),
          ],
          onChanged: onChanged,
        ),
      ],
    );
  }
}

/// Assignee dropdown
class _AssigneeDropdown extends StatelessWidget {
  const _AssigneeDropdown({
    required this.value,
    required this.onChanged,
  });

  final int? value;
  final void Function(int?) onChanged;

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch staff members from provider
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Assign To',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: AppSpacing.xs),
        DropdownButtonFormField<int>(
          value: value,
          decoration: const InputDecoration(
            hintText: 'Select assignee (optional)',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: null, child: Text('Unassigned')),
            DropdownMenuItem(value: 1, child: Text('Staff Member 1')),
            DropdownMenuItem(value: 2, child: Text('Staff Member 2')),
          ],
          onChanged: onChanged,
        ),
      ],
    );
  }
}
