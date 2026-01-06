/// Offline mutation repository for Cosmo Management
///
/// Manages offline mutation queue using Hive for persistence.
library;

import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../models/offline_mutation_model.dart';

/// Repository for managing offline mutations
///
/// Stores mutations in a Hive box and provides CRUD operations
/// for managing the offline sync queue.
class OfflineMutationRepository {
  static const String _mutationsBoxName = 'offline_mutations';
  static const _uuid = Uuid();

  Box<String>? _mutationsBox;
  bool _isInitialized = false;

  /// Initialize the repository
  ///
  /// Must be called before using any other methods.
  Future<void> init() async {
    if (_isInitialized) return;
    _mutationsBox = await Hive.openBox<String>(_mutationsBoxName);
    _isInitialized = true;
  }

  /// Ensure repository is initialized
  void _ensureInitialized() {
    if (!_isInitialized || _mutationsBox == null) {
      throw StateError(
        'OfflineMutationRepository not initialized. Call init() first.',
      );
    }
  }

  /// Generate a new UUID for mutations
  String generateId() => _uuid.v4();

  /// Queue a new mutation
  ///
  /// Returns the mutation with its assigned ID.
  Future<OfflineMutationModel> queueMutation({
    required MutationType type,
    required EntityType entityType,
    required int entityId,
    required Map<String, dynamic> payload,
    int? serverVersion,
  }) async {
    _ensureInitialized();

    final mutation = OfflineMutationModel(
      id: generateId(),
      type: type,
      entityType: entityType,
      entityId: entityId,
      payload: payload,
      syncStatus: SyncStatus.pending,
      createdAt: DateTime.now(),
      serverVersion: serverVersion,
    );

    await _saveMutation(mutation);
    return mutation;
  }

  /// Queue a task status change
  Future<OfflineMutationModel> queueStatusChange({
    required int taskId,
    required String status,
  }) async {
    return queueMutation(
      type: MutationType.statusChange,
      entityType: EntityType.task,
      entityId: taskId,
      payload: {'status': status},
    );
  }

  /// Queue a checklist response
  Future<OfflineMutationModel> queueChecklistResponse({
    required int taskId,
    required int checklistItemId,
    bool? isCompleted,
    String? textValue,
    double? numberValue,
    List<String>? photoUrls,
  }) async {
    return queueMutation(
      type: MutationType.checklistResponse,
      entityType: EntityType.checklistResponse,
      entityId: checklistItemId,
      payload: {
        'task_id': taskId,
        'checklist_item_id': checklistItemId,
        if (isCompleted != null) 'is_completed': isCompleted,
        if (textValue != null) 'text_value': textValue,
        if (numberValue != null) 'number_value': numberValue,
        if (photoUrls != null) 'photo_urls': photoUrls,
      },
    );
  }

  /// Queue a task assignment
  Future<OfflineMutationModel> queueTaskAssignment({
    required int taskId,
  }) async {
    return queueMutation(
      type: MutationType.assign,
      entityType: EntityType.task,
      entityId: taskId,
      payload: {},
    );
  }

  /// Get a mutation by ID
  Future<OfflineMutationModel?> getMutation(String id) async {
    _ensureInitialized();
    final json = _mutationsBox!.get(id);
    if (json == null) return null;
    return OfflineMutationModel.fromJson(
      jsonDecode(json) as Map<String, dynamic>,
    );
  }

  /// Get all mutations
  Future<List<OfflineMutationModel>> getAllMutations() async {
    _ensureInitialized();
    final mutations = <OfflineMutationModel>[];
    for (final key in _mutationsBox!.keys) {
      final json = _mutationsBox!.get(key);
      if (json != null) {
        try {
          mutations.add(
            OfflineMutationModel.fromJson(
              jsonDecode(json) as Map<String, dynamic>,
            ),
          );
        } catch (_) {
          // Skip corrupted entries
        }
      }
    }
    return mutations;
  }

  /// Get all pending mutations (sorted by creation time)
  Future<List<OfflineMutationModel>> getPendingMutations() async {
    final all = await getAllMutations();
    final pending = all
        .where((m) =>
            m.syncStatus == SyncStatus.pending ||
            m.syncStatus == SyncStatus.failed)
        .toList();
    // Sort by creation time for FIFO processing
    pending.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return pending;
  }

  /// Get mutations that can be retried
  Future<List<OfflineMutationModel>> getRetryableMutations() async {
    final pending = await getPendingMutations();
    return pending.where((m) => m.canRetry).toList();
  }

  /// Get failed mutations that exceeded retry limit
  Future<List<OfflineMutationModel>> getFailedMutations() async {
    final all = await getAllMutations();
    return all
        .where((m) =>
            m.syncStatus == SyncStatus.failed && m.hasExceededRetries)
        .toList();
  }

  /// Get mutations with conflicts
  Future<List<OfflineMutationModel>> getConflictMutations() async {
    final all = await getAllMutations();
    return all.where((m) => m.syncStatus == SyncStatus.conflict).toList();
  }

  /// Update mutation status
  Future<void> updateMutationStatus(
    String id,
    SyncStatus status, {
    String? errorMessage,
    int? incrementRetryCount,
  }) async {
    _ensureInitialized();
    final mutation = await getMutation(id);
    if (mutation == null) return;

    final updated = mutation.copyWith(
      syncStatus: status,
      errorMessage: errorMessage,
      syncedAt: status == SyncStatus.synced ? DateTime.now() : null,
      retryCount: incrementRetryCount != null
          ? mutation.retryCount + incrementRetryCount
          : mutation.retryCount,
    );

    await _saveMutation(updated);
  }

  /// Mark mutation as syncing
  Future<void> markSyncing(String id) async {
    await updateMutationStatus(id, SyncStatus.syncing);
  }

  /// Mark mutation as synced
  Future<void> markSynced(String id) async {
    await updateMutationStatus(id, SyncStatus.synced);
  }

  /// Mark mutation as failed
  Future<void> markFailed(String id, String errorMessage) async {
    await updateMutationStatus(
      id,
      SyncStatus.failed,
      errorMessage: errorMessage,
      incrementRetryCount: 1,
    );
  }

  /// Mark mutation as conflict
  Future<void> markConflict(String id, String errorMessage) async {
    await updateMutationStatus(
      id,
      SyncStatus.conflict,
      errorMessage: errorMessage,
    );
  }

  /// Reset a mutation for retry (resets status to pending and clears error)
  Future<void> resetForRetry(String id) async {
    _ensureInitialized();
    final mutation = await getMutation(id);
    if (mutation == null) return;

    final updated = mutation.copyWith(
      syncStatus: SyncStatus.pending,
      errorMessage: null,
      retryCount: 0,
    );

    await _saveMutation(updated);
  }

  /// Delete a mutation
  Future<void> deleteMutation(String id) async {
    _ensureInitialized();
    await _mutationsBox!.delete(id);
  }

  /// Remove all synced mutations
  Future<int> removeSyncedMutations() async {
    _ensureInitialized();
    int removed = 0;
    final keysToRemove = <String>[];

    for (final key in _mutationsBox!.keys) {
      final json = _mutationsBox!.get(key);
      if (json != null) {
        try {
          final mutation = OfflineMutationModel.fromJson(
            jsonDecode(json) as Map<String, dynamic>,
          );
          if (mutation.syncStatus == SyncStatus.synced) {
            keysToRemove.add(key as String);
          }
        } catch (_) {
          // Remove corrupted entries
          keysToRemove.add(key as String);
        }
      }
    }

    for (final key in keysToRemove) {
      await _mutationsBox!.delete(key);
      removed++;
    }

    return removed;
  }

  /// Clear all mutations (use with caution)
  Future<void> clearAll() async {
    _ensureInitialized();
    await _mutationsBox!.clear();
  }

  /// Get sync status summary
  Future<SyncStatusModel> getSyncStatus() async {
    _ensureInitialized();
    int pending = 0;
    int failed = 0;

    for (final key in _mutationsBox!.keys) {
      final json = _mutationsBox!.get(key);
      if (json != null) {
        try {
          final mutation = OfflineMutationModel.fromJson(
            jsonDecode(json) as Map<String, dynamic>,
          );
          switch (mutation.syncStatus) {
            case SyncStatus.pending:
              pending++;
              break;
            case SyncStatus.failed:
              failed++;
              break;
            case SyncStatus.syncing:
              pending++; // Count syncing as pending
              break;
            case SyncStatus.conflict:
              failed++; // Count conflict as failed
              break;
            case SyncStatus.synced:
              // Don't count synced
              break;
          }
        } catch (_) {
          // Skip corrupted entries
        }
      }
    }

    return SyncStatusModel(
      pendingCount: pending,
      failedCount: failed,
    );
  }

  /// Get count of pending mutations
  Future<int> getPendingCount() async {
    final status = await getSyncStatus();
    return status.pendingCount;
  }

  /// Check if there are any pending mutations
  Future<bool> hasPendingMutations() async {
    final count = await getPendingCount();
    return count > 0;
  }

  /// Save mutation to Hive
  Future<void> _saveMutation(OfflineMutationModel mutation) async {
    final json = jsonEncode(mutation.toJson());
    await _mutationsBox!.put(mutation.id, json);
  }

  /// Close the repository
  Future<void> close() async {
    if (_isInitialized && _mutationsBox != null) {
      await _mutationsBox!.close();
      _isInitialized = false;
    }
  }
}
