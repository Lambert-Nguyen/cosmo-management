/// Task detail notifier for Cosmo Management
///
/// Manages task detail state including checklist operations.
library;

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/connectivity_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../data/models/checklist_model.dart';
import '../../../data/models/offline_mutation_model.dart';
import '../../../data/models/task_model.dart';
import '../../../data/repositories/offline_mutation_repository.dart';
import '../../../data/repositories/task_repository.dart';

/// State for task detail
sealed class TaskDetailState {
  const TaskDetailState();
}

/// Initial state
class TaskDetailInitial extends TaskDetailState {
  const TaskDetailInitial();
}

/// Loading state
class TaskDetailLoading extends TaskDetailState {
  const TaskDetailLoading();
}

/// Loaded state with task and checklist
class TaskDetailLoaded extends TaskDetailState {
  final TaskModel task;
  final TaskChecklistModel? checklist;
  final bool isOffline;
  final bool hasUnsyncedChanges;

  const TaskDetailLoaded({
    required this.task,
    this.checklist,
    this.isOffline = false,
    this.hasUnsyncedChanges = false,
  });

  /// Create a copy with updated values
  TaskDetailLoaded copyWith({
    TaskModel? task,
    TaskChecklistModel? checklist,
    bool? isOffline,
    bool? hasUnsyncedChanges,
  }) {
    return TaskDetailLoaded(
      task: task ?? this.task,
      checklist: checklist ?? this.checklist,
      isOffline: isOffline ?? this.isOffline,
      hasUnsyncedChanges: hasUnsyncedChanges ?? this.hasUnsyncedChanges,
    );
  }
}

/// Action in progress (status change, checklist update)
class TaskDetailActionLoading extends TaskDetailState {
  final TaskModel task;
  final String actionMessage;

  const TaskDetailActionLoading(this.task, this.actionMessage);
}

/// Error state
class TaskDetailError extends TaskDetailState {
  final String message;
  final TaskModel? lastTask;

  const TaskDetailError(this.message, [this.lastTask]);
}

/// Task detail notifier
///
/// Manages task detail with checklist and offline support.
class TaskDetailNotifier extends StateNotifier<TaskDetailState> {
  final TaskRepository _taskRepository;
  final OfflineMutationRepository _mutationRepository;
  final ConnectivityService _connectivityService;
  final StorageService _storageService;
  final int _taskId;

  StreamSubscription? _connectivitySubscription;

  TaskDetailNotifier({
    required TaskRepository taskRepository,
    required OfflineMutationRepository mutationRepository,
    required ConnectivityService connectivityService,
    required StorageService storageService,
    required int taskId,
  })  : _taskRepository = taskRepository,
        _mutationRepository = mutationRepository,
        _connectivityService = connectivityService,
        _storageService = storageService,
        _taskId = taskId,
        super(const TaskDetailInitial()) {
    _init();
  }

  void _init() {
    _connectivitySubscription = _connectivityService.statusStream.listen(
      (status) {
        if (status != ConnectivityStatus.offline) {
          // Refresh when coming back online
          load();
        } else {
          // Update state to show offline
          final current = state;
          if (current is TaskDetailLoaded) {
            state = current.copyWith(isOffline: true);
          }
        }
      },
    );

    // Initial load
    load();
  }

  /// Load task detail
  Future<void> load() async {
    state = const TaskDetailLoading();

    try {
      final isOnline = _connectivityService.isConnected;

      if (isOnline) {
        final task = await _taskRepository.getTaskWithChecklist(_taskId);

        // Get checklist if available
        TaskChecklistModel? checklist;
        try {
          checklist = await _taskRepository.getTaskChecklist(_taskId);
        } catch (_) {
          // Checklist might not exist
        }

        // Cache for offline
        await _cacheTaskDetail(task, checklist);

        state = TaskDetailLoaded(
          task: task,
          checklist: checklist,
          isOffline: false,
        );
      } else {
        // Load from cache
        final cached = await _loadFromCache();
        if (!cached) {
          state = const TaskDetailError('Task not available offline');
        }
      }
    } catch (e) {
      // Try cache on error
      final cached = await _loadFromCache();
      if (!cached) {
        state = TaskDetailError(e.toString());
      }
    }
  }

  /// Update task status
  Future<void> updateStatus(TaskStatus status) async {
    final currentState = state;
    if (currentState is! TaskDetailLoaded) return;

    state = TaskDetailActionLoading(currentState.task, 'Updating status...');

    try {
      if (_connectivityService.isConnected) {
        final updated = await _taskRepository.setStatus(_taskId, status);
        state = TaskDetailLoaded(
          task: updated,
          checklist: currentState.checklist,
        );
      } else {
        // Queue for offline sync
        await _mutationRepository.queueStatusChange(
          taskId: _taskId,
          status: status.value,
        );

        // Optimistic update
        final updatedTask = currentState.task.copyWith(status: status);
        await _cacheTaskDetail(updatedTask, currentState.checklist);

        state = TaskDetailLoaded(
          task: updatedTask,
          checklist: currentState.checklist,
          isOffline: true,
          hasUnsyncedChanges: true,
        );
      }
    } catch (e) {
      state = TaskDetailLoaded(
        task: currentState.task,
        checklist: currentState.checklist,
      );
      rethrow;
    }
  }

  /// Assign task to current user
  Future<void> assignToMe() async {
    final currentState = state;
    if (currentState is! TaskDetailLoaded) return;

    state = TaskDetailActionLoading(currentState.task, 'Assigning task...');

    try {
      if (_connectivityService.isConnected) {
        final updated = await _taskRepository.assignToMe(_taskId);
        state = TaskDetailLoaded(
          task: updated,
          checklist: currentState.checklist,
        );
      } else {
        // Queue for offline sync
        await _mutationRepository.queueTaskAssignment(taskId: _taskId);

        state = TaskDetailLoaded(
          task: currentState.task,
          checklist: currentState.checklist,
          isOffline: true,
          hasUnsyncedChanges: true,
        );
      }
    } catch (e) {
      state = TaskDetailLoaded(
        task: currentState.task,
        checklist: currentState.checklist,
      );
      rethrow;
    }
  }

  /// Submit checklist response
  Future<void> submitChecklistResponse({
    required int checklistItemId,
    bool? isCompleted,
    String? textValue,
    double? numberValue,
    List<String>? photoUrls,
    String? notes,
  }) async {
    final currentState = state;
    if (currentState is! TaskDetailLoaded) return;

    try {
      if (_connectivityService.isConnected) {
        await _taskRepository.submitChecklistResponse(
          taskId: _taskId,
          checklistItemId: checklistItemId,
          isCompleted: isCompleted,
          textValue: textValue,
          numberValue: numberValue,
          photoUrls: photoUrls,
          notes: notes,
        );

        // Reload to get updated checklist
        await load();
      } else {
        // Queue for offline sync
        await _mutationRepository.queueChecklistResponse(
          taskId: _taskId,
          checklistItemId: checklistItemId,
          isCompleted: isCompleted,
          textValue: textValue,
          numberValue: numberValue,
          photoUrls: photoUrls,
        );

        // Optimistic update of checklist if we have it
        if (currentState.checklist != null) {
          final updatedResponses = _updateChecklistResponse(
            currentState.checklist!.responses,
            checklistItemId,
            isCompleted: isCompleted,
            textValue: textValue,
            numberValue: numberValue,
          );

          final updatedChecklist = currentState.checklist!.copyWith(
            responses: updatedResponses,
          );

          state = currentState.copyWith(
            checklist: updatedChecklist,
            isOffline: true,
            hasUnsyncedChanges: true,
          );
        } else {
          state = currentState.copyWith(
            isOffline: true,
            hasUnsyncedChanges: true,
          );
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Update checklist response list with new values
  List<ChecklistResponseModel> _updateChecklistResponse(
    List<ChecklistResponseModel> responses,
    int itemId, {
    bool? isCompleted,
    String? textValue,
    double? numberValue,
  }) {
    final existingIndex = responses.indexWhere((r) => r.itemId == itemId);

    if (existingIndex >= 0) {
      // Update existing response
      final existing = responses[existingIndex];
      final updated = existing.copyWith(
        isCompleted: isCompleted ?? existing.isCompleted,
        textResponse: textValue ?? existing.textResponse,
        numberResponse: numberValue ?? existing.numberResponse,
        completedAt: isCompleted == true ? DateTime.now() : existing.completedAt,
      );
      return [
        ...responses.sublist(0, existingIndex),
        updated,
        ...responses.sublist(existingIndex + 1),
      ];
    } else {
      // Create new response
      final newResponse = ChecklistResponseModel(
        id: 0, // Temporary ID
        itemId: itemId,
        isCompleted: isCompleted ?? false,
        textResponse: textValue,
        numberResponse: numberValue,
        completedAt: isCompleted == true ? DateTime.now() : null,
      );
      return [...responses, newResponse];
    }
  }

  /// Cache task detail for offline
  Future<void> _cacheTaskDetail(
    TaskModel task,
    TaskChecklistModel? checklist,
  ) async {
    await _storageService.cacheData(
      'task_detail_$_taskId',
      {
        'task': task.toJson(),
        if (checklist != null) 'checklist': checklist.toJson(),
      },
    );
  }

  /// Load from cache
  Future<bool> _loadFromCache() async {
    try {
      final cached = await _storageService.getCachedData('task_detail_$_taskId');
      if (cached != null) {
        final task = TaskModel.fromJson(
          cached['task'] as Map<String, dynamic>,
        );
        TaskChecklistModel? checklist;
        if (cached['checklist'] != null) {
          checklist = TaskChecklistModel.fromJson(
            cached['checklist'] as Map<String, dynamic>,
          );
        }

        // Check for unsynced changes
        final hasPending = await _mutationRepository.hasPendingMutations();

        state = TaskDetailLoaded(
          task: task,
          checklist: checklist,
          isOffline: true,
          hasUnsyncedChanges: hasPending,
        );
        return true;
      }
    } catch (_) {
      // Cache corrupted
    }
    return false;
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}
