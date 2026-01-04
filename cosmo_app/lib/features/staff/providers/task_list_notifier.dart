/// Task list notifier for Cosmo Management
///
/// Manages task list state with filtering and pagination.
library;

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/services/connectivity_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../data/models/task_model.dart';
import '../../../data/repositories/task_repository.dart';

part 'task_list_notifier.freezed.dart';
part 'task_list_notifier.g.dart';

/// Filter options for task list
@freezed
class TaskListFilter with _$TaskListFilter {
  const factory TaskListFilter({
    TaskStatus? status,
    TaskPriority? priority,
    int? propertyId,
    String? propertyName,
    @Default(false) bool overdueOnly,
    String? search,
    @Default('due_date') String sortBy,
    @Default(true) bool ascending,
  }) = _TaskListFilter;

  factory TaskListFilter.fromJson(Map<String, dynamic> json) =>
      _$TaskListFilterFromJson(json);
}

/// State for task list
sealed class TaskListState {
  const TaskListState();
}

/// Initial state before loading
class TaskListInitial extends TaskListState {
  const TaskListInitial();
}

/// Loading state (with optional existing tasks for pagination)
class TaskListLoading extends TaskListState {
  final List<TaskModel> existingTasks;
  final bool isLoadingMore;

  const TaskListLoading({
    this.existingTasks = const [],
    this.isLoadingMore = false,
  });
}

/// Loaded state with tasks
class TaskListLoaded extends TaskListState {
  final List<TaskModel> tasks;
  final bool hasMore;
  final int totalCount;
  final TaskListFilter filter;
  final bool isOffline;

  const TaskListLoaded({
    required this.tasks,
    required this.hasMore,
    required this.totalCount,
    required this.filter,
    this.isOffline = false,
  });

  /// Create a copy with updated values
  TaskListLoaded copyWith({
    List<TaskModel>? tasks,
    bool? hasMore,
    int? totalCount,
    TaskListFilter? filter,
    bool? isOffline,
  }) {
    return TaskListLoaded(
      tasks: tasks ?? this.tasks,
      hasMore: hasMore ?? this.hasMore,
      totalCount: totalCount ?? this.totalCount,
      filter: filter ?? this.filter,
      isOffline: isOffline ?? this.isOffline,
    );
  }
}

/// Error state
class TaskListError extends TaskListState {
  final String message;
  final List<TaskModel> cachedTasks;

  const TaskListError(this.message, [this.cachedTasks = const []]);
}

/// Task list notifier
///
/// Manages task list with filtering, search, and pagination.
class TaskListNotifier extends StateNotifier<TaskListState> {
  final TaskRepository _taskRepository;
  final ConnectivityService _connectivityService;
  final StorageService _storageService;

  int _currentPage = 1;
  static const int _pageSize = 20;
  TaskListFilter _currentFilter = const TaskListFilter();

  StreamSubscription? _connectivitySubscription;

  TaskListNotifier({
    required TaskRepository taskRepository,
    required ConnectivityService connectivityService,
    required StorageService storageService,
  })  : _taskRepository = taskRepository,
        _connectivityService = connectivityService,
        _storageService = storageService,
        super(const TaskListInitial()) {
    _init();
  }

  void _init() {
    _connectivitySubscription = _connectivityService.statusStream.listen(
      (status) {
        if (status != ConnectivityStatus.offline) {
          // Refresh when coming back online
          loadTasks(refresh: true);
        } else {
          // Update state to show offline
          final current = state;
          if (current is TaskListLoaded) {
            state = current.copyWith(isOffline: true);
          }
        }
      },
    );
  }

  /// Current filter
  TaskListFilter get currentFilter => _currentFilter;

  /// Load tasks with current filter
  Future<void> loadTasks({bool refresh = false}) async {
    if (refresh) _currentPage = 1;

    final currentTasks = switch (state) {
      TaskListLoaded(tasks: final t) => t,
      TaskListLoading(existingTasks: final t) => t,
      _ => <TaskModel>[],
    };

    state = TaskListLoading(
      existingTasks: refresh ? [] : currentTasks,
      isLoadingMore: !refresh && currentTasks.isNotEmpty,
    );

    try {
      final isOnline = _connectivityService.isConnected;

      if (isOnline) {
        final result = await _taskRepository.getTasks(
          page: _currentPage,
          pageSize: _pageSize,
          status: _currentFilter.status,
          priority: _currentFilter.priority,
          propertyId: _currentFilter.propertyId,
          overdue: _currentFilter.overdueOnly ? true : null,
          search: _currentFilter.search,
        );

        final tasks = refresh
            ? result.results
            : [...currentTasks, ...result.results];

        // Cache for offline
        await _cacheTaskList(tasks);

        state = TaskListLoaded(
          tasks: tasks,
          hasMore: result.hasMore,
          totalCount: result.count,
          filter: _currentFilter,
          isOffline: false,
        );
      } else {
        // Load from cache
        await _loadFromCache();
      }
    } catch (e) {
      // Try cache on error
      final cached = await _loadFromCache();
      if (!cached) {
        state = TaskListError(e.toString(), currentTasks);
      }
    }
  }

  /// Load next page
  Future<void> loadMore() async {
    if (state is! TaskListLoaded) return;
    final currentState = state as TaskListLoaded;
    if (!currentState.hasMore) return;

    final previousPage = _currentPage;
    _currentPage++;
    try {
      await loadTasks();
    } catch (e) {
      // Restore page number on failure
      _currentPage = previousPage;
      rethrow;
    }
  }

  /// Update filter and reload
  Future<void> updateFilter(TaskListFilter filter) async {
    _currentFilter = filter;
    await loadTasks(refresh: true);
  }

  /// Set status filter
  Future<void> setStatusFilter(TaskStatus? status) async {
    await updateFilter(_currentFilter.copyWith(status: status));
  }

  /// Set priority filter
  Future<void> setPriorityFilter(TaskPriority? priority) async {
    await updateFilter(_currentFilter.copyWith(priority: priority));
  }

  /// Set overdue filter
  Future<void> setOverdueFilter(bool overdueOnly) async {
    await updateFilter(_currentFilter.copyWith(overdueOnly: overdueOnly));
  }

  /// Set search query
  Future<void> setSearch(String? search) async {
    await updateFilter(_currentFilter.copyWith(search: search));
  }

  /// Clear all filters
  Future<void> clearFilters() async {
    _currentFilter = const TaskListFilter();
    await loadTasks(refresh: true);
  }

  /// Update a task in the local list (optimistic update)
  void updateTaskLocally(TaskModel updatedTask) {
    final current = state;
    if (current is! TaskListLoaded) return;

    final updatedTasks = current.tasks.map((task) {
      return task.id == updatedTask.id ? updatedTask : task;
    }).toList();

    state = current.copyWith(tasks: updatedTasks);
  }

  /// Remove a task from the local list
  void removeTaskLocally(int taskId) {
    final current = state;
    if (current is! TaskListLoaded) return;

    final updatedTasks = current.tasks.where((t) => t.id != taskId).toList();
    state = current.copyWith(
      tasks: updatedTasks,
      totalCount: current.totalCount - 1,
    );
  }

  /// Cache task list for offline
  Future<void> _cacheTaskList(List<TaskModel> tasks) async {
    final cacheKey = _getCacheKey();
    await _storageService.cacheData(
      cacheKey,
      tasks.map((t) => t.toJson()).toList(),
    );
  }

  /// Load from cache
  Future<bool> _loadFromCache() async {
    try {
      final cacheKey = _getCacheKey();
      final cached = await _storageService.getCachedData(cacheKey);
      if (cached != null && cached is List) {
        final tasks = cached
            .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
            .toList();
        state = TaskListLoaded(
          tasks: tasks,
          hasMore: false,
          totalCount: tasks.length,
          filter: _currentFilter,
          isOffline: true,
        );
        return true;
      }
    } catch (_) {
      // Cache corrupted
    }
    return false;
  }

  /// Get cache key based on current filter
  String _getCacheKey() {
    final status = _currentFilter.status?.value ?? 'all';
    final priority = _currentFilter.priority?.value ?? 'all';
    return 'task_list_${status}_$priority';
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}
