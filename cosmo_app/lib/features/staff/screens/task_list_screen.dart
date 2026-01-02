/// Task list screen for Cosmo Management
///
/// Filterable list of all tasks.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../data/models/task_model.dart';
import '../../../router/route_names.dart';
import '../providers/staff_providers.dart';
import '../widgets/filter_chips_row.dart';
import '../widgets/sync_indicator.dart';
import '../widgets/task_list_item.dart';
import 'staff_shell.dart';

/// Task list screen
///
/// Shows filterable list of tasks with pagination.
class TaskListScreen extends ConsumerStatefulWidget {
  const TaskListScreen({
    super.key,
    this.initialStatus,
  });

  final String? initialStatus;

  @override
  ConsumerState<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends ConsumerState<TaskListScreen> {
  final _scrollController = ScrollController();
  TaskStatus? _selectedStatus;
  bool _showOverdue = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Parse initial status
    if (widget.initialStatus != null) {
      _selectedStatus = TaskStatus.values.cast<TaskStatus?>().firstWhere(
            (s) => s?.value == widget.initialStatus,
            orElse: () => null,
          );
      if (widget.initialStatus == 'overdue') {
        _showOverdue = true;
        _selectedStatus = null;
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Load more when near bottom
      ref.read(taskListProvider.notifier).loadMore();
    }
  }

  void _onStatusSelected(TaskStatus? status) {
    setState(() {
      _selectedStatus = status;
      _showOverdue = false;
    });
    ref.read(taskListProvider.notifier).setStatusFilter(status);
    ref.read(taskListProvider.notifier).setOverdueFilter(false);
  }

  void _onOverdueSelected(bool selected) {
    setState(() {
      _showOverdue = selected;
      if (selected) _selectedStatus = null;
    });
    ref.read(taskListProvider.notifier).setStatusFilter(null);
    ref.read(taskListProvider.notifier).setOverdueFilter(selected);
  }

  @override
  Widget build(BuildContext context) {
    final taskListState = ref.watch(taskListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
          const SyncIndicatorButton(),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          TaskStatusFilterChips(
            selectedStatus: _selectedStatus,
            onStatusSelected: _onStatusSelected,
            showOverdue: true,
            isOverdueSelected: _showOverdue,
            onOverdueSelected: _onOverdueSelected,
          ),

          // Task list
          Expanded(
            child: switch (taskListState) {
              TaskListInitial() ||
              TaskListLoading() =>
                const StaffLoadingState(message: 'Loading tasks...'),
              TaskListError(message: final msg) => StaffErrorState(
                  message: msg,
                  onRetry: () =>
                      ref.read(taskListProvider.notifier).loadTasks(refresh: true),
                ),
              TaskListLoaded(
                tasks: final tasks,
                hasMore: final hasMore,
              ) =>
                tasks.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: () =>
                            ref.read(taskListProvider.notifier).loadTasks(refresh: true),
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.only(
                            top: AppSpacing.sm,
                            bottom: 80,
                          ),
                          itemCount: tasks.length + (hasMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == tasks.length) {
                              return _buildLoadMoreIndicator();
                            }

                            final task = tasks[index];
                            return TaskListItem(
                              task: task,
                              onTap: () => context.push(
                                RouteNames.staffTaskDetail(task.id),
                              ),
                            );
                          },
                        ),
                      ),
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(RouteNames.staffTaskCreate),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    String title;
    String subtitle;

    if (_showOverdue) {
      title = 'No overdue tasks';
      subtitle = 'Great job staying on top of your tasks!';
    } else if (_selectedStatus != null) {
      title = 'No ${_selectedStatus!.displayName.toLowerCase()} tasks';
      subtitle = 'Try a different filter or create a new task.';
    } else {
      title = 'No tasks found';
      subtitle = 'Create your first task to get started.';
    }

    return StaffEmptyState(
      icon: Icons.task_outlined,
      title: title,
      subtitle: subtitle,
      action: () => context.push(RouteNames.staffTaskCreate),
      actionLabel: 'Create Task',
    );
  }

  Widget _buildLoadMoreIndicator() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Center(
        child: TextButton(
          onPressed: () => ref.read(taskListProvider.notifier).loadMore(),
          child: const Text('Load more'),
        ),
      ),
    );
  }
}
