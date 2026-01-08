// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline_mutation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OfflineMutationModelImpl _$$OfflineMutationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$OfflineMutationModelImpl(
      id: json['id'] as String,
      type: $enumDecode(_$MutationTypeEnumMap, json['type']),
      entityType: $enumDecode(_$EntityTypeEnumMap, json['entity_type']),
      entityId: (json['entity_id'] as num).toInt(),
      payload: json['payload'] as Map<String, dynamic>,
      syncStatus:
          $enumDecodeNullable(_$SyncStatusEnumMap, json['sync_status']) ??
              SyncStatus.pending,
      createdAt: DateTime.parse(json['created_at'] as String),
      syncedAt: json['synced_at'] == null
          ? null
          : DateTime.parse(json['synced_at'] as String),
      retryCount: (json['retry_count'] as num?)?.toInt() ?? 0,
      errorMessage: json['error_message'] as String?,
      serverVersion: (json['server_version'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$OfflineMutationModelImplToJson(
        _$OfflineMutationModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$MutationTypeEnumMap[instance.type]!,
      'entity_type': _$EntityTypeEnumMap[instance.entityType]!,
      'entity_id': instance.entityId,
      'payload': instance.payload,
      'sync_status': _$SyncStatusEnumMap[instance.syncStatus]!,
      'created_at': instance.createdAt.toIso8601String(),
      'synced_at': instance.syncedAt?.toIso8601String(),
      'retry_count': instance.retryCount,
      'error_message': instance.errorMessage,
      'server_version': instance.serverVersion,
    };

const _$MutationTypeEnumMap = {
  MutationType.create: 'create',
  MutationType.update: 'update',
  MutationType.delete: 'delete',
  MutationType.statusChange: 'status_change',
  MutationType.checklistResponse: 'checklist_response',
  MutationType.assign: 'assign',
};

const _$EntityTypeEnumMap = {
  EntityType.task: 'task',
  EntityType.checklistResponse: 'checklist_response',
  EntityType.inventory: 'inventory',
  EntityType.inventoryTransaction: 'inventory_transaction',
  EntityType.lostFound: 'lost_found',
  EntityType.photo: 'photo',
};

const _$SyncStatusEnumMap = {
  SyncStatus.pending: 'pending',
  SyncStatus.syncing: 'syncing',
  SyncStatus.synced: 'synced',
  SyncStatus.failed: 'failed',
  SyncStatus.conflict: 'conflict',
};

_$SyncStatusModelImpl _$$SyncStatusModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SyncStatusModelImpl(
      pendingCount: (json['pendingCount'] as num?)?.toInt() ?? 0,
      failedCount: (json['failedCount'] as num?)?.toInt() ?? 0,
      isSyncing: json['isSyncing'] as bool? ?? false,
      lastSyncAt: json['lastSyncAt'] == null
          ? null
          : DateTime.parse(json['lastSyncAt'] as String),
      lastError: json['lastError'] as String?,
    );

Map<String, dynamic> _$$SyncStatusModelImplToJson(
        _$SyncStatusModelImpl instance) =>
    <String, dynamic>{
      'pendingCount': instance.pendingCount,
      'failedCount': instance.failedCount,
      'isSyncing': instance.isSyncing,
      'lastSyncAt': instance.lastSyncAt?.toIso8601String(),
      'lastError': instance.lastError,
    };

_$SyncResultModelImpl _$$SyncResultModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SyncResultModelImpl(
      syncedCount: (json['syncedCount'] as num?)?.toInt() ?? 0,
      failedCount: (json['failedCount'] as num?)?.toInt() ?? 0,
      conflictCount: (json['conflictCount'] as num?)?.toInt() ?? 0,
      errors: (json['errors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$$SyncResultModelImplToJson(
        _$SyncResultModelImpl instance) =>
    <String, dynamic>{
      'syncedCount': instance.syncedCount,
      'failedCount': instance.failedCount,
      'conflictCount': instance.conflictCount,
      'errors': instance.errors,
      'completedAt': instance.completedAt?.toIso8601String(),
    };
