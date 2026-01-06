/// Tests for offline mutation models
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:cosmo_app/data/models/offline_mutation_model.dart';

void main() {
  group('SyncStatus', () {
    test('should have correct values', () {
      expect(SyncStatus.pending.value, 'pending');
      expect(SyncStatus.syncing.value, 'syncing');
      expect(SyncStatus.synced.value, 'synced');
      expect(SyncStatus.failed.value, 'failed');
      expect(SyncStatus.conflict.value, 'conflict');
    });

    test('isComplete should return correct value', () {
      expect(SyncStatus.synced.isComplete, true);
      expect(SyncStatus.pending.isComplete, false);
      expect(SyncStatus.failed.isComplete, false);
    });

    test('isError should return correct value', () {
      expect(SyncStatus.failed.isError, true);
      expect(SyncStatus.conflict.isError, true);
      expect(SyncStatus.synced.isError, false);
      expect(SyncStatus.pending.isError, false);
    });

    test('needsRetry should return correct value', () {
      expect(SyncStatus.pending.needsRetry, true);
      expect(SyncStatus.failed.needsRetry, true);
      expect(SyncStatus.synced.needsRetry, false);
      expect(SyncStatus.syncing.needsRetry, false);
    });
  });

  group('OfflineMutationModel', () {
    test('should create with required fields', () {
      final mutation = OfflineMutationModel(
        id: 'test-uuid',
        type: MutationType.update,
        entityType: EntityType.task,
        entityId: 1,
        payload: {'status': 'completed'},
        createdAt: DateTime.now(),
      );

      expect(mutation.id, 'test-uuid');
      expect(mutation.type, MutationType.update);
      expect(mutation.entityType, EntityType.task);
      expect(mutation.entityId, 1);
      expect(mutation.syncStatus, SyncStatus.pending);
      expect(mutation.retryCount, 0);
    });

    test('canRetry should work correctly', () {
      final mutation = OfflineMutationModel(
        id: 'test-uuid',
        type: MutationType.update,
        entityType: EntityType.task,
        entityId: 1,
        payload: {},
        createdAt: DateTime.now(),
        syncStatus: SyncStatus.pending,
        retryCount: 0,
      );
      expect(mutation.canRetry, true);

      final maxRetriesMutation = mutation.copyWith(retryCount: 3);
      expect(maxRetriesMutation.canRetry, false);

      final syncedMutation = mutation.copyWith(syncStatus: SyncStatus.synced);
      expect(syncedMutation.canRetry, false);
    });

    test('hasExceededRetries should work correctly', () {
      final mutation = OfflineMutationModel(
        id: 'test-uuid',
        type: MutationType.update,
        entityType: EntityType.task,
        entityId: 1,
        payload: {},
        createdAt: DateTime.now(),
        retryCount: 2,
      );
      expect(mutation.hasExceededRetries, false);

      final exceededMutation = mutation.copyWith(retryCount: 3);
      expect(exceededMutation.hasExceededRetries, true);
    });

    test('description should generate correct message', () {
      final taskUpdate = OfflineMutationModel(
        id: 'test-uuid',
        type: MutationType.update,
        entityType: EntityType.task,
        entityId: 123,
        payload: {},
        createdAt: DateTime.now(),
      );
      expect(taskUpdate.description, 'Update task #123');

      final statusChange = OfflineMutationModel(
        id: 'test-uuid',
        type: MutationType.statusChange,
        entityType: EntityType.task,
        entityId: 456,
        payload: {},
        createdAt: DateTime.now(),
      );
      expect(statusChange.description, 'Update status of task #456');
    });
  });

  group('SyncStatusModel', () {
    test('should create with default values', () {
      const status = SyncStatusModel();

      expect(status.pendingCount, 0);
      expect(status.failedCount, 0);
      expect(status.isSyncing, false);
    });

    test('hasPendingChanges should work correctly', () {
      const noPending = SyncStatusModel(pendingCount: 0);
      expect(noPending.hasPendingChanges, false);

      const hasPending = SyncStatusModel(pendingCount: 5);
      expect(hasPending.hasPendingChanges, true);
    });

    test('needsSync should work correctly', () {
      const synced = SyncStatusModel();
      expect(synced.needsSync, false);

      const hasPending = SyncStatusModel(pendingCount: 1);
      expect(hasPending.needsSync, true);

      const hasErrors = SyncStatusModel(failedCount: 1);
      expect(hasErrors.needsSync, true);
    });

    test('statusMessage should return correct message', () {
      const syncing = SyncStatusModel(isSyncing: true);
      expect(syncing.statusMessage, 'Syncing...');

      const hasErrors = SyncStatusModel(failedCount: 2);
      expect(hasErrors.statusMessage, '2 failed');

      const hasPending = SyncStatusModel(pendingCount: 3);
      expect(hasPending.statusMessage, '3 pending');

      const synced = SyncStatusModel();
      expect(synced.statusMessage, 'Synced');
    });

    test('totalPending should calculate correctly', () {
      const status = SyncStatusModel(pendingCount: 3, failedCount: 2);
      expect(status.totalPending, 5);
    });
  });

  group('SyncResultModel', () {
    test('should create with default values', () {
      const result = SyncResultModel();

      expect(result.syncedCount, 0);
      expect(result.failedCount, 0);
      expect(result.conflictCount, 0);
      expect(result.errors, isEmpty);
    });

    test('isSuccess should work correctly', () {
      const success = SyncResultModel(syncedCount: 5);
      expect(success.isSuccess, true);

      const failed = SyncResultModel(syncedCount: 3, failedCount: 1);
      expect(failed.isSuccess, false);

      const conflict = SyncResultModel(syncedCount: 3, conflictCount: 1);
      expect(conflict.isSuccess, false);
    });

    test('totalProcessed should calculate correctly', () {
      const result = SyncResultModel(
        syncedCount: 5,
        failedCount: 2,
        conflictCount: 1,
      );
      expect(result.totalProcessed, 8);
    });

    test('summaryMessage should generate correct message', () {
      const success = SyncResultModel(syncedCount: 5);
      expect(success.summaryMessage, 'Synced 5 items');

      const singleSuccess = SyncResultModel(syncedCount: 1);
      expect(singleSuccess.summaryMessage, 'Synced 1 item');

      const withIssues = SyncResultModel(
        syncedCount: 3,
        failedCount: 1,
        conflictCount: 2,
      );
      expect(withIssues.summaryMessage, 'Synced 3, 1 failed, 2 conflicts');
    });
  });
}
