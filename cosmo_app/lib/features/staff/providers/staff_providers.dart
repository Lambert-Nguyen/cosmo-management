/// Staff providers for Cosmo Management
///
/// Riverpod providers for staff module state management.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/service_providers.dart';
import '../../../data/models/dashboard_model.dart';
import '../../../data/models/offline_mutation_model.dart';
import '../../../data/models/task_model.dart';
import '../../../data/repositories/offline_mutation_repository.dart';
import 'offline_sync_notifier.dart';
import 'staff_dashboard_notifier.dart';
import 'task_detail_notifier.dart';
import 'task_list_notifier.dart';

export 'offline_sync_notifier.dart';
export 'staff_dashboard_notifier.dart';
export 'task_detail_notifier.dart';
export 'task_list_notifier.dart';

// ============================================
// Repository Providers
// ============================================

/// Offline mutation repository provider
///
/// Must be overridden in ProviderScope with initialized instance.
final offlineMutationRepositoryProvider =
    Provider<OfflineMutationRepository>((ref) {
  throw UnimplementedError(
    'offlineMutationRepositoryProvider must be overridden in ProviderScope',
  );
});

// ============================================
// Staff Dashboard Providers
// ============================================

/// Staff dashboard notifier provider
final staffDashboardProvider =
    StateNotifierProvider<StaffDashboardNotifier, StaffDashboardState>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) {
    throw StateError('User must be authenticated to access staff dashboard');
  }

  return StaffDashboardNotifier(
    taskRepository: ref.watch(taskRepositoryProvider),
    connectivityService: ref.watch(connectivityServiceProvider),
    storageService: ref.watch(storageServiceProvider),
    userId: user.id,
  );
});

/// Dashboard task counts provider (convenience)
final taskCountsProvider = Provider<TaskCountModel?>((ref) {
  final dashboardState = ref.watch(staffDashboardProvider);
  return switch (dashboardState) {
    StaffDashboardLoaded(taskCounts: final counts) => counts,
    _ => null,
  };
});

/// Today's tasks provider (convenience)
final todaysTasksProvider = Provider<List<TaskModel>>((ref) {
  final dashboardState = ref.watch(staffDashboardProvider);
  return switch (dashboardState) {
    StaffDashboardLoaded(todaysTasks: final tasks) => tasks,
    _ => [],
  };
});

// ============================================
// Task List Providers
// ============================================

/// Task list notifier provider
final taskListProvider =
    StateNotifierProvider<TaskListNotifier, TaskListState>((ref) {
  return TaskListNotifier(
    taskRepository: ref.watch(taskRepositoryProvider),
    connectivityService: ref.watch(connectivityServiceProvider),
    storageService: ref.watch(storageServiceProvider),
  );
});

/// Current task list filter provider (convenience)
final taskListFilterProvider = Provider<TaskListFilter>((ref) {
  final notifier = ref.watch(taskListProvider.notifier);
  return notifier.currentFilter;
});

// ============================================
// Task Detail Providers
// ============================================

/// Task detail notifier provider (family by task ID)
final taskDetailProvider = StateNotifierProvider.family<TaskDetailNotifier,
    TaskDetailState, int>((ref, taskId) {
  return TaskDetailNotifier(
    taskRepository: ref.watch(taskRepositoryProvider),
    mutationRepository: ref.watch(offlineMutationRepositoryProvider),
    connectivityService: ref.watch(connectivityServiceProvider),
    storageService: ref.watch(storageServiceProvider),
    taskId: taskId,
  );
});

// ============================================
// Offline Sync Providers
// ============================================

/// Offline sync notifier provider
final offlineSyncProvider =
    StateNotifierProvider<OfflineSyncNotifier, OfflineSyncState>((ref) {
  return OfflineSyncNotifier(
    mutationRepository: ref.watch(offlineMutationRepositoryProvider),
    apiService: ref.watch(apiServiceProvider),
    connectivityService: ref.watch(connectivityServiceProvider),
  );
});

/// Sync status provider (convenience)
final syncStatusProvider = Provider<SyncStatusModel>((ref) {
  final syncState = ref.watch(offlineSyncProvider);
  return switch (syncState) {
    OfflineSyncIdle(status: final s) => s,
    OfflineSyncInProgress() => const SyncStatusModel(isSyncing: true),
    OfflineSyncComplete() => const SyncStatusModel(),
    OfflineSyncError() => const SyncStatusModel(),
  };
});

/// Is syncing provider
final isSyncingProvider = Provider<bool>((ref) {
  final syncState = ref.watch(offlineSyncProvider);
  return syncState is OfflineSyncInProgress;
});

/// Has pending changes provider
final hasPendingChangesProvider = Provider<bool>((ref) {
  final status = ref.watch(syncStatusProvider);
  return status.hasPendingChanges;
});

/// Pending count provider
final pendingCountProvider = Provider<int>((ref) {
  final status = ref.watch(syncStatusProvider);
  return status.totalPending;
});

// ============================================
// Connectivity Providers
// ============================================

/// Is offline provider
final isOfflineProvider = Provider<bool>((ref) {
  final connectivity = ref.watch(connectivityServiceProvider);
  return !connectivity.isConnected;
});
