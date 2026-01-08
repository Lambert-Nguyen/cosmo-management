/// Offline mutation models for Cosmo Management
///
/// Freezed models for offline-first sync with JSON serialization.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'offline_mutation_model.freezed.dart';
part 'offline_mutation_model.g.dart';

/// Types of offline mutations
@JsonEnum(valueField: 'value')
enum MutationType {
  @JsonValue('create')
  create('create', 'Create'),
  @JsonValue('update')
  update('update', 'Update'),
  @JsonValue('delete')
  delete('delete', 'Delete'),
  @JsonValue('status_change')
  statusChange('status_change', 'Status Change'),
  @JsonValue('checklist_response')
  checklistResponse('checklist_response', 'Checklist Response'),
  @JsonValue('assign')
  assign('assign', 'Assign');

  final String value;
  final String displayName;

  const MutationType(this.value, this.displayName);
}

/// Sync status for mutations
@JsonEnum(valueField: 'value')
enum SyncStatus {
  @JsonValue('pending')
  pending('pending', 'Pending'),
  @JsonValue('syncing')
  syncing('syncing', 'Syncing'),
  @JsonValue('synced')
  synced('synced', 'Synced'),
  @JsonValue('failed')
  failed('failed', 'Failed'),
  @JsonValue('conflict')
  conflict('conflict', 'Conflict');

  final String value;
  final String displayName;

  const SyncStatus(this.value, this.displayName);

  /// Check if this status indicates completion
  bool get isComplete => this == SyncStatus.synced;

  /// Check if this status indicates an error
  bool get isError => this == SyncStatus.failed || this == SyncStatus.conflict;

  /// Check if this status needs retry
  bool get needsRetry => this == SyncStatus.pending || this == SyncStatus.failed;
}

/// Entity types that can be mutated offline
@JsonEnum(valueField: 'value')
enum EntityType {
  @JsonValue('task')
  task('task'),
  @JsonValue('checklist_response')
  checklistResponse('checklist_response'),
  @JsonValue('inventory')
  inventory('inventory'),
  @JsonValue('inventory_transaction')
  inventoryTransaction('inventory_transaction'),
  @JsonValue('lost_found')
  lostFound('lost_found'),
  @JsonValue('photo')
  photo('photo');

  final String value;

  const EntityType(this.value);
}

/// Offline mutation record
///
/// Represents a single mutation that was made while offline
/// and needs to be synced when connectivity returns.
@freezed
class OfflineMutationModel with _$OfflineMutationModel {
  const factory OfflineMutationModel({
    /// Unique ID for this mutation (UUID)
    required String id,

    /// Type of mutation (create, update, delete, etc.)
    required MutationType type,

    /// Type of entity being mutated
    @JsonKey(name: 'entity_type') required EntityType entityType,

    /// ID of the entity (may be temporary for creates)
    @JsonKey(name: 'entity_id') required int entityId,

    /// The mutation payload (field values to update)
    required Map<String, dynamic> payload,

    /// Current sync status
    @JsonKey(name: 'sync_status') @Default(SyncStatus.pending) SyncStatus syncStatus,

    /// When this mutation was created
    @JsonKey(name: 'created_at') required DateTime createdAt,

    /// When this mutation was successfully synced
    @JsonKey(name: 'synced_at') DateTime? syncedAt,

    /// Number of retry attempts
    @JsonKey(name: 'retry_count') @Default(0) int retryCount,

    /// Last error message if sync failed
    @JsonKey(name: 'error_message') String? errorMessage,

    /// Server version for conflict detection
    @JsonKey(name: 'server_version') int? serverVersion,
  }) = _OfflineMutationModel;

  const OfflineMutationModel._();

  factory OfflineMutationModel.fromJson(Map<String, dynamic> json) =>
      _$OfflineMutationModelFromJson(json);

  /// Maximum number of retries before giving up
  static const int maxRetries = 3;

  /// Check if this mutation can be retried
  bool get canRetry => retryCount < maxRetries && syncStatus.needsRetry;

  /// Check if this mutation has exceeded max retries
  bool get hasExceededRetries => retryCount >= maxRetries;

  /// Get a description of this mutation for UI
  String get description {
    final action = switch (type) {
      MutationType.create => 'Create',
      MutationType.update => 'Update',
      MutationType.delete => 'Delete',
      MutationType.statusChange => 'Update status of',
      MutationType.checklistResponse => 'Update checklist for',
      MutationType.assign => 'Assign',
    };

    final entity = switch (entityType) {
      EntityType.task => 'task',
      EntityType.checklistResponse => 'checklist item',
      EntityType.inventory => 'inventory item',
      EntityType.inventoryTransaction => 'inventory transaction',
      EntityType.lostFound => 'lost & found item',
      EntityType.photo => 'photo',
    };

    return '$action $entity #$entityId';
  }
}

/// Overall sync status summary
///
/// Aggregates the status of all pending mutations.
@freezed
class SyncStatusModel with _$SyncStatusModel {
  const factory SyncStatusModel({
    /// Number of mutations pending sync
    @Default(0) int pendingCount,

    /// Number of mutations that failed to sync
    @Default(0) int failedCount,

    /// Whether a sync is currently in progress
    @Default(false) bool isSyncing,

    /// When the last successful sync occurred
    DateTime? lastSyncAt,

    /// Last error message if any
    String? lastError,
  }) = _SyncStatusModel;

  const SyncStatusModel._();

  factory SyncStatusModel.fromJson(Map<String, dynamic> json) =>
      _$SyncStatusModelFromJson(json);

  /// Check if there are any pending changes
  bool get hasPendingChanges => pendingCount > 0;

  /// Check if there are any errors
  bool get hasErrors => failedCount > 0;

  /// Check if sync is needed
  bool get needsSync => hasPendingChanges || hasErrors;

  /// Total count of items needing attention
  int get totalPending => pendingCount + failedCount;

  /// Get status message for UI
  String get statusMessage {
    if (isSyncing) return 'Syncing...';
    if (hasErrors) return '$failedCount failed';
    if (hasPendingChanges) return '$pendingCount pending';
    return 'Synced';
  }
}

/// Sync result after attempting to sync mutations
@freezed
class SyncResultModel with _$SyncResultModel {
  const factory SyncResultModel({
    /// Number of mutations successfully synced
    @Default(0) int syncedCount,

    /// Number of mutations that failed
    @Default(0) int failedCount,

    /// Number of conflicts detected
    @Default(0) int conflictCount,

    /// List of error messages
    @Default([]) List<String> errors,

    /// When this sync completed
    DateTime? completedAt,
  }) = _SyncResultModel;

  const SyncResultModel._();

  factory SyncResultModel.fromJson(Map<String, dynamic> json) =>
      _$SyncResultModelFromJson(json);

  /// Check if sync was fully successful
  bool get isSuccess => failedCount == 0 && conflictCount == 0;

  /// Check if there were any issues
  bool get hasIssues => failedCount > 0 || conflictCount > 0;

  /// Total items processed
  int get totalProcessed => syncedCount + failedCount + conflictCount;

  /// Get summary message for UI
  String get summaryMessage {
    if (isSuccess) return 'Synced $syncedCount item${syncedCount == 1 ? '' : 's'}';
    final issues = <String>[];
    if (failedCount > 0) issues.add('$failedCount failed');
    if (conflictCount > 0) issues.add('$conflictCount conflict${conflictCount == 1 ? '' : 's'}');
    return 'Synced $syncedCount, ${issues.join(', ')}';
  }
}
