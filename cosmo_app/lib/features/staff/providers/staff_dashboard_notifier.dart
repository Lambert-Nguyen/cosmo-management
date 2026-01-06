/// Staff dashboard notifier for Cosmo Management
///
/// Manages staff dashboard state including task counts and today's tasks.
library;

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/connectivity_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../data/models/dashboard_model.dart';
import '../../../data/models/task_model.dart';
import '../../../data/repositories/task_repository.dart';

/// State for staff dashboard
sealed class StaffDashboardState {
  const StaffDashboardState();
}

/// Initial state before loading
class StaffDashboardInitial extends StaffDashboardState {
  const StaffDashboardInitial();
}

/// Loading state while fetching data
class StaffDashboardLoading extends StaffDashboardState {
  const StaffDashboardLoading();
}

/// Loaded state with dashboard data
class StaffDashboardLoaded extends StaffDashboardState {
  final TaskCountModel taskCounts;
  final List<TaskModel> todaysTasks;
  final List<TaskModel> overdueTasks;
  final bool isOffline;

  const StaffDashboardLoaded({
    required this.taskCounts,
    required this.todaysTasks,
    this.overdueTasks = const [],
    this.isOffline = false,
  });

  /// Create a copy with updated values
  StaffDashboardLoaded copyWith({
    TaskCountModel? taskCounts,
    List<TaskModel>? todaysTasks,
    List<TaskModel>? overdueTasks,
    bool? isOffline,
  }) {
    return StaffDashboardLoaded(
      taskCounts: taskCounts ?? this.taskCounts,
      todaysTasks: todaysTasks ?? this.todaysTasks,
      overdueTasks: overdueTasks ?? this.overdueTasks,
      isOffline: isOffline ?? this.isOffline,
    );
  }
}

/// Error state when loading fails
class StaffDashboardError extends StaffDashboardState {
  final String message;
  final bool canRetry;

  const StaffDashboardError(this.message, {this.canRetry = true});
}

/// Staff dashboard notifier
///
/// Fetches and manages dashboard data with offline support.
class StaffDashboardNotifier extends StateNotifier<StaffDashboardState> {
  final TaskRepository _taskRepository;
  final ConnectivityService _connectivityService;
  final StorageService _storageService;
  final int _userId;

  StreamSubscription? _connectivitySubscription;

  static const String _cacheKey = 'staff_dashboard_cache';

  StaffDashboardNotifier({
    required TaskRepository taskRepository,
    required ConnectivityService connectivityService,
    required StorageService storageService,
    required int userId,
  })  : _taskRepository = taskRepository,
        _connectivityService = connectivityService,
        _storageService = storageService,
        _userId = userId,
        super(const StaffDashboardInitial()) {
    _init();
  }

  Future<void> _init() async {
    // Listen for connectivity changes
    _connectivitySubscription = _connectivityService.statusStream.listen(
      (status) {
        if (status != ConnectivityStatus.offline) {
          // Refresh when coming back online
          refresh();
        } else {
          // Update state to show offline
          final current = state;
          if (current is StaffDashboardLoaded) {
            state = current.copyWith(isOffline: true);
          }
        }
      },
    );

    // Initial load
    await refresh();
  }

  /// Refresh dashboard data
  Future<void> refresh() async {
    // Don't show loading if we already have data
    if (state is! StaffDashboardLoaded) {
      state = const StaffDashboardLoading();
    }

    try {
      final isOnline = _connectivityService.isConnected;

      if (isOnline) {
        // Fetch fresh data from API
        final taskCounts = await _taskRepository.getTaskCounts();
        final todaysTasks = await _taskRepository.getTodaysTasks(_userId);

        // Get overdue tasks
        final overdueResult = await _taskRepository.getOverdueTasks();
        final overdueTasks = overdueResult.results;

        final loaded = StaffDashboardLoaded(
          taskCounts: taskCounts,
          todaysTasks: todaysTasks,
          overdueTasks: overdueTasks,
          isOffline: false,
        );

        // Cache for offline
        await _cacheData(loaded);

        state = loaded;
      } else {
        // Try to load from cache
        await _loadFromCache();
      }
    } catch (e) {
      // On error, try cache first
      final cached = await _loadFromCache();
      if (!cached) {
        state = StaffDashboardError(
          'Failed to load dashboard: ${e.toString()}',
        );
      }
    }
  }

  /// Load data from cache
  Future<bool> _loadFromCache() async {
    try {
      final cachedData = await _storageService.getCachedData(_cacheKey);
      if (cachedData != null) {
        final taskCounts = TaskCountModel.fromJson(
          cachedData['taskCounts'] as Map<String, dynamic>,
        );
        final todaysTasks = (cachedData['todaysTasks'] as List)
            .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
            .toList();
        final overdueTasks = (cachedData['overdueTasks'] as List?)
            ?.map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
            .toList() ?? [];

        state = StaffDashboardLoaded(
          taskCounts: taskCounts,
          todaysTasks: todaysTasks,
          overdueTasks: overdueTasks,
          isOffline: true,
        );
        return true;
      }
    } catch (_) {
      // Cache corrupted
    }
    return false;
  }

  /// Cache data for offline use
  Future<void> _cacheData(StaffDashboardLoaded data) async {
    await _storageService.cacheData(_cacheKey, {
      'taskCounts': data.taskCounts.toJson(),
      'todaysTasks': data.todaysTasks.map((t) => t.toJson()).toList(),
      'overdueTasks': data.overdueTasks.map((t) => t.toJson()).toList(),
    });
  }

  /// Update a task in the local state (optimistic update)
  void updateTaskLocally(TaskModel updatedTask) {
    final current = state;
    if (current is! StaffDashboardLoaded) return;

    final updatedTodaysTasks = current.todaysTasks.map((task) {
      return task.id == updatedTask.id ? updatedTask : task;
    }).toList();

    final updatedOverdueTasks = current.overdueTasks.map((task) {
      return task.id == updatedTask.id ? updatedTask : task;
    }).toList();

    state = current.copyWith(
      todaysTasks: updatedTodaysTasks,
      overdueTasks: updatedOverdueTasks,
    );
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}
