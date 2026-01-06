/// Offline sync notifier for Cosmo Management
///
/// Manages offline sync state and operations.
library;

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/api_config.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/connectivity_service.dart';
import '../../../data/models/offline_mutation_model.dart';
import '../../../data/repositories/offline_mutation_repository.dart';

/// State for offline sync
sealed class OfflineSyncState {
  const OfflineSyncState();
}

/// Idle state with sync status
class OfflineSyncIdle extends OfflineSyncState {
  final SyncStatusModel status;
  const OfflineSyncIdle(this.status);
}

/// Sync in progress
class OfflineSyncInProgress extends OfflineSyncState {
  final int total;
  final int completed;
  final String currentItem;

  const OfflineSyncInProgress({
    required this.total,
    required this.completed,
    required this.currentItem,
  });

  double get progress => total > 0 ? completed / total : 0;
}

/// Sync complete
class OfflineSyncComplete extends OfflineSyncState {
  final SyncResultModel result;
  const OfflineSyncComplete(this.result);
}

/// Sync error
class OfflineSyncError extends OfflineSyncState {
  final String message;
  const OfflineSyncError(this.message);
}

/// Offline sync notifier
///
/// Manages syncing offline mutations when connectivity returns.
class OfflineSyncNotifier extends StateNotifier<OfflineSyncState> {
  final OfflineMutationRepository _mutationRepository;
  final ApiService _apiService;
  final ConnectivityService _connectivityService;

  StreamSubscription? _connectivitySubscription;
  bool _isSyncing = false;
  Completer<SyncResultModel>? _syncCompleter;

  OfflineSyncNotifier({
    required OfflineMutationRepository mutationRepository,
    required ApiService apiService,
    required ConnectivityService connectivityService,
  })  : _mutationRepository = mutationRepository,
        _apiService = apiService,
        _connectivityService = connectivityService,
        super(const OfflineSyncIdle(SyncStatusModel())) {
    _init();
  }

  Future<void> _init() async {
    // Listen for connectivity changes
    _connectivitySubscription = _connectivityService.statusStream.listen(
      (status) {
        // Use atomic check with sync lock to prevent race condition
        if (status != ConnectivityStatus.offline) {
          _tryAutoSync();
        }
      },
    );

    // Load initial status
    await refreshStatus();
  }

  /// Attempt auto-sync with lock to prevent race conditions
  void _tryAutoSync() {
    if (_isSyncing || _syncCompleter != null) return;
    syncPendingMutations();
  }

  /// Refresh sync status
  Future<void> refreshStatus() async {
    final status = await _mutationRepository.getSyncStatus();
    state = OfflineSyncIdle(status);
  }

  /// Get current pending count
  Future<int> getPendingCount() async {
    return _mutationRepository.getPendingCount();
  }

  /// Sync all pending mutations
  Future<SyncResultModel> syncPendingMutations() async {
    // Return existing sync result if already syncing
    if (_syncCompleter != null) {
      return _syncCompleter!.future;
    }

    if (_isSyncing) {
      return const SyncResultModel();
    }

    if (!_connectivityService.isConnected) {
      state = const OfflineSyncError('No internet connection');
      return const SyncResultModel(
        errors: ['No internet connection'],
      );
    }

    _isSyncing = true;
    _syncCompleter = Completer<SyncResultModel>();

    try {
      final pending = await _mutationRepository.getRetryableMutations();
      if (pending.isEmpty) {
        await refreshStatus();
        const emptyResult = SyncResultModel();
        _syncCompleter?.complete(emptyResult);
        _syncCompleter = null;
        _isSyncing = false;
        return emptyResult;
      }

      int synced = 0;
      int failed = 0;
      int conflicts = 0;
      final errors = <String>[];

      for (int i = 0; i < pending.length; i++) {
        final mutation = pending[i];

        state = OfflineSyncInProgress(
          total: pending.length,
          completed: i,
          currentItem: mutation.description,
        );

        try {
          await _mutationRepository.markSyncing(mutation.id);
          await _processMutation(mutation);
          await _mutationRepository.markSynced(mutation.id);
          synced++;
        } on ConflictException catch (e) {
          await _mutationRepository.markConflict(mutation.id, e.message);
          conflicts++;
          errors.add('Conflict: ${mutation.description}');
        } catch (e) {
          await _mutationRepository.markFailed(mutation.id, e.toString());
          failed++;
          errors.add('${mutation.description}: ${e.toString()}');
        }
      }

      // Clean up synced mutations
      await _mutationRepository.removeSyncedMutations();

      final result = SyncResultModel(
        syncedCount: synced,
        failedCount: failed,
        conflictCount: conflicts,
        errors: errors,
        completedAt: DateTime.now(),
      );

      state = OfflineSyncComplete(result);

      // Complete the sync completer
      _syncCompleter?.complete(result);

      // After a delay, go back to idle
      await Future.delayed(const Duration(seconds: 3));
      await refreshStatus();

      return result;
    } finally {
      _isSyncing = false;
      _syncCompleter = null;
    }
  }

  /// Build options with idempotency key header
  ///
  /// The idempotency key ensures that replayed mutations (e.g., due to
  /// network failures or reconnects) don't create duplicate server-side
  /// writes. The server uses this key to deduplicate requests.
  Options _buildIdempotentOptions(String idempotencyKey) {
    return Options(
      headers: {'X-Idempotency-Key': idempotencyKey},
    );
  }

  /// Process a single mutation
  Future<void> _processMutation(OfflineMutationModel mutation) async {
    final options = _buildIdempotentOptions(mutation.id);

    switch (mutation.type) {
      case MutationType.create:
        await _apiService.post(
          ApiConfig.tasks,
          data: mutation.payload,
          options: options,
        );
        break;

      case MutationType.update:
        await _apiService.patch(
          ApiConfig.taskDetail(mutation.entityId),
          data: mutation.payload,
          options: options,
        );
        break;

      case MutationType.delete:
        await _apiService.delete(
          ApiConfig.taskDetail(mutation.entityId),
          options: options,
        );
        break;

      case MutationType.statusChange:
        await _apiService.post(
          ApiConfig.taskSetStatus(mutation.entityId),
          data: mutation.payload,
          options: options,
        );
        break;

      case MutationType.checklistResponse:
        final taskId = mutation.payload['task_id'] as int;
        await _apiService.post(
          ApiConfig.checklistRespond(taskId),
          data: mutation.payload,
          options: options,
        );
        break;

      case MutationType.assign:
        await _apiService.post(
          ApiConfig.taskAssignToMe(mutation.entityId),
          options: options,
        );
        break;
    }
  }

  /// Retry failed mutations
  Future<void> retryFailed() async {
    await syncPendingMutations();
  }

  /// Clear all failed mutations
  Future<void> clearFailed() async {
    final failed = await _mutationRepository.getFailedMutations();
    for (final mutation in failed) {
      await _mutationRepository.deleteMutation(mutation.id);
    }
    await refreshStatus();
  }

  /// Get all conflict mutations for resolution
  Future<List<OfflineMutationModel>> getConflicts() async {
    return _mutationRepository.getConflictMutations();
  }

  /// Resolve a conflict by keeping local changes (retry sync)
  Future<void> resolveConflictKeepLocal(String mutationId) async {
    await _mutationRepository.resetForRetry(mutationId);
    await refreshStatus();
  }

  /// Resolve a conflict by discarding local changes
  Future<void> resolveConflictDiscard(String mutationId) async {
    await _mutationRepository.deleteMutation(mutationId);
    await refreshStatus();
  }

  /// Resolve all conflicts by keeping local changes
  Future<void> resolveAllConflictsKeepLocal() async {
    final conflicts = await _mutationRepository.getConflictMutations();
    for (final conflict in conflicts) {
      await _mutationRepository.resetForRetry(conflict.id);
    }
    await refreshStatus();
  }

  /// Resolve all conflicts by discarding local changes
  Future<void> resolveAllConflictsDiscard() async {
    final conflicts = await _mutationRepository.getConflictMutations();
    for (final conflict in conflicts) {
      await _mutationRepository.deleteMutation(conflict.id);
    }
    await refreshStatus();
  }

  /// Check if sync is in progress
  bool get isSyncing => _isSyncing;

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}

/// Exception for sync conflicts
class ConflictException implements Exception {
  final String message;
  const ConflictException(this.message);

  @override
  String toString() => message;
}
