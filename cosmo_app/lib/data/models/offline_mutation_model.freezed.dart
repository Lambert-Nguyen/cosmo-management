// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'offline_mutation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OfflineMutationModel _$OfflineMutationModelFromJson(Map<String, dynamic> json) {
  return _OfflineMutationModel.fromJson(json);
}

/// @nodoc
mixin _$OfflineMutationModel {
  /// Unique ID for this mutation (UUID)
  String get id => throw _privateConstructorUsedError;

  /// Type of mutation (create, update, delete, etc.)
  MutationType get type => throw _privateConstructorUsedError;

  /// Type of entity being mutated
  @JsonKey(name: 'entity_type')
  EntityType get entityType => throw _privateConstructorUsedError;

  /// ID of the entity (may be temporary for creates)
  @JsonKey(name: 'entity_id')
  int get entityId => throw _privateConstructorUsedError;

  /// The mutation payload (field values to update)
  Map<String, dynamic> get payload => throw _privateConstructorUsedError;

  /// Current sync status
  @JsonKey(name: 'sync_status')
  SyncStatus get syncStatus => throw _privateConstructorUsedError;

  /// When this mutation was created
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// When this mutation was successfully synced
  @JsonKey(name: 'synced_at')
  DateTime? get syncedAt => throw _privateConstructorUsedError;

  /// Number of retry attempts
  @JsonKey(name: 'retry_count')
  int get retryCount => throw _privateConstructorUsedError;

  /// Last error message if sync failed
  @JsonKey(name: 'error_message')
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Server version for conflict detection
  @JsonKey(name: 'server_version')
  int? get serverVersion => throw _privateConstructorUsedError;

  /// Serializes this OfflineMutationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OfflineMutationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OfflineMutationModelCopyWith<OfflineMutationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OfflineMutationModelCopyWith<$Res> {
  factory $OfflineMutationModelCopyWith(OfflineMutationModel value,
          $Res Function(OfflineMutationModel) then) =
      _$OfflineMutationModelCopyWithImpl<$Res, OfflineMutationModel>;
  @useResult
  $Res call(
      {String id,
      MutationType type,
      @JsonKey(name: 'entity_type') EntityType entityType,
      @JsonKey(name: 'entity_id') int entityId,
      Map<String, dynamic> payload,
      @JsonKey(name: 'sync_status') SyncStatus syncStatus,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'synced_at') DateTime? syncedAt,
      @JsonKey(name: 'retry_count') int retryCount,
      @JsonKey(name: 'error_message') String? errorMessage,
      @JsonKey(name: 'server_version') int? serverVersion});
}

/// @nodoc
class _$OfflineMutationModelCopyWithImpl<$Res,
        $Val extends OfflineMutationModel>
    implements $OfflineMutationModelCopyWith<$Res> {
  _$OfflineMutationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OfflineMutationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? entityType = null,
    Object? entityId = null,
    Object? payload = null,
    Object? syncStatus = null,
    Object? createdAt = null,
    Object? syncedAt = freezed,
    Object? retryCount = null,
    Object? errorMessage = freezed,
    Object? serverVersion = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MutationType,
      entityType: null == entityType
          ? _value.entityType
          : entityType // ignore: cast_nullable_to_non_nullable
              as EntityType,
      entityId: null == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as int,
      payload: null == payload
          ? _value.payload
          : payload // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      syncStatus: null == syncStatus
          ? _value.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as SyncStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      syncedAt: freezed == syncedAt
          ? _value.syncedAt
          : syncedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      retryCount: null == retryCount
          ? _value.retryCount
          : retryCount // ignore: cast_nullable_to_non_nullable
              as int,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      serverVersion: freezed == serverVersion
          ? _value.serverVersion
          : serverVersion // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OfflineMutationModelImplCopyWith<$Res>
    implements $OfflineMutationModelCopyWith<$Res> {
  factory _$$OfflineMutationModelImplCopyWith(_$OfflineMutationModelImpl value,
          $Res Function(_$OfflineMutationModelImpl) then) =
      __$$OfflineMutationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      MutationType type,
      @JsonKey(name: 'entity_type') EntityType entityType,
      @JsonKey(name: 'entity_id') int entityId,
      Map<String, dynamic> payload,
      @JsonKey(name: 'sync_status') SyncStatus syncStatus,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'synced_at') DateTime? syncedAt,
      @JsonKey(name: 'retry_count') int retryCount,
      @JsonKey(name: 'error_message') String? errorMessage,
      @JsonKey(name: 'server_version') int? serverVersion});
}

/// @nodoc
class __$$OfflineMutationModelImplCopyWithImpl<$Res>
    extends _$OfflineMutationModelCopyWithImpl<$Res, _$OfflineMutationModelImpl>
    implements _$$OfflineMutationModelImplCopyWith<$Res> {
  __$$OfflineMutationModelImplCopyWithImpl(_$OfflineMutationModelImpl _value,
      $Res Function(_$OfflineMutationModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of OfflineMutationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? entityType = null,
    Object? entityId = null,
    Object? payload = null,
    Object? syncStatus = null,
    Object? createdAt = null,
    Object? syncedAt = freezed,
    Object? retryCount = null,
    Object? errorMessage = freezed,
    Object? serverVersion = freezed,
  }) {
    return _then(_$OfflineMutationModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MutationType,
      entityType: null == entityType
          ? _value.entityType
          : entityType // ignore: cast_nullable_to_non_nullable
              as EntityType,
      entityId: null == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as int,
      payload: null == payload
          ? _value._payload
          : payload // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      syncStatus: null == syncStatus
          ? _value.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as SyncStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      syncedAt: freezed == syncedAt
          ? _value.syncedAt
          : syncedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      retryCount: null == retryCount
          ? _value.retryCount
          : retryCount // ignore: cast_nullable_to_non_nullable
              as int,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      serverVersion: freezed == serverVersion
          ? _value.serverVersion
          : serverVersion // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OfflineMutationModelImpl extends _OfflineMutationModel {
  const _$OfflineMutationModelImpl(
      {required this.id,
      required this.type,
      @JsonKey(name: 'entity_type') required this.entityType,
      @JsonKey(name: 'entity_id') required this.entityId,
      required final Map<String, dynamic> payload,
      @JsonKey(name: 'sync_status') this.syncStatus = SyncStatus.pending,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'synced_at') this.syncedAt,
      @JsonKey(name: 'retry_count') this.retryCount = 0,
      @JsonKey(name: 'error_message') this.errorMessage,
      @JsonKey(name: 'server_version') this.serverVersion})
      : _payload = payload,
        super._();

  factory _$OfflineMutationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OfflineMutationModelImplFromJson(json);

  /// Unique ID for this mutation (UUID)
  @override
  final String id;

  /// Type of mutation (create, update, delete, etc.)
  @override
  final MutationType type;

  /// Type of entity being mutated
  @override
  @JsonKey(name: 'entity_type')
  final EntityType entityType;

  /// ID of the entity (may be temporary for creates)
  @override
  @JsonKey(name: 'entity_id')
  final int entityId;

  /// The mutation payload (field values to update)
  final Map<String, dynamic> _payload;

  /// The mutation payload (field values to update)
  @override
  Map<String, dynamic> get payload {
    if (_payload is EqualUnmodifiableMapView) return _payload;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_payload);
  }

  /// Current sync status
  @override
  @JsonKey(name: 'sync_status')
  final SyncStatus syncStatus;

  /// When this mutation was created
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// When this mutation was successfully synced
  @override
  @JsonKey(name: 'synced_at')
  final DateTime? syncedAt;

  /// Number of retry attempts
  @override
  @JsonKey(name: 'retry_count')
  final int retryCount;

  /// Last error message if sync failed
  @override
  @JsonKey(name: 'error_message')
  final String? errorMessage;

  /// Server version for conflict detection
  @override
  @JsonKey(name: 'server_version')
  final int? serverVersion;

  @override
  String toString() {
    return 'OfflineMutationModel(id: $id, type: $type, entityType: $entityType, entityId: $entityId, payload: $payload, syncStatus: $syncStatus, createdAt: $createdAt, syncedAt: $syncedAt, retryCount: $retryCount, errorMessage: $errorMessage, serverVersion: $serverVersion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OfflineMutationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            const DeepCollectionEquality().equals(other._payload, _payload) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.syncedAt, syncedAt) ||
                other.syncedAt == syncedAt) &&
            (identical(other.retryCount, retryCount) ||
                other.retryCount == retryCount) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.serverVersion, serverVersion) ||
                other.serverVersion == serverVersion));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      entityType,
      entityId,
      const DeepCollectionEquality().hash(_payload),
      syncStatus,
      createdAt,
      syncedAt,
      retryCount,
      errorMessage,
      serverVersion);

  /// Create a copy of OfflineMutationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OfflineMutationModelImplCopyWith<_$OfflineMutationModelImpl>
      get copyWith =>
          __$$OfflineMutationModelImplCopyWithImpl<_$OfflineMutationModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OfflineMutationModelImplToJson(
      this,
    );
  }
}

abstract class _OfflineMutationModel extends OfflineMutationModel {
  const factory _OfflineMutationModel(
          {required final String id,
          required final MutationType type,
          @JsonKey(name: 'entity_type') required final EntityType entityType,
          @JsonKey(name: 'entity_id') required final int entityId,
          required final Map<String, dynamic> payload,
          @JsonKey(name: 'sync_status') final SyncStatus syncStatus,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'synced_at') final DateTime? syncedAt,
          @JsonKey(name: 'retry_count') final int retryCount,
          @JsonKey(name: 'error_message') final String? errorMessage,
          @JsonKey(name: 'server_version') final int? serverVersion}) =
      _$OfflineMutationModelImpl;
  const _OfflineMutationModel._() : super._();

  factory _OfflineMutationModel.fromJson(Map<String, dynamic> json) =
      _$OfflineMutationModelImpl.fromJson;

  /// Unique ID for this mutation (UUID)
  @override
  String get id;

  /// Type of mutation (create, update, delete, etc.)
  @override
  MutationType get type;

  /// Type of entity being mutated
  @override
  @JsonKey(name: 'entity_type')
  EntityType get entityType;

  /// ID of the entity (may be temporary for creates)
  @override
  @JsonKey(name: 'entity_id')
  int get entityId;

  /// The mutation payload (field values to update)
  @override
  Map<String, dynamic> get payload;

  /// Current sync status
  @override
  @JsonKey(name: 'sync_status')
  SyncStatus get syncStatus;

  /// When this mutation was created
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;

  /// When this mutation was successfully synced
  @override
  @JsonKey(name: 'synced_at')
  DateTime? get syncedAt;

  /// Number of retry attempts
  @override
  @JsonKey(name: 'retry_count')
  int get retryCount;

  /// Last error message if sync failed
  @override
  @JsonKey(name: 'error_message')
  String? get errorMessage;

  /// Server version for conflict detection
  @override
  @JsonKey(name: 'server_version')
  int? get serverVersion;

  /// Create a copy of OfflineMutationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OfflineMutationModelImplCopyWith<_$OfflineMutationModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SyncStatusModel _$SyncStatusModelFromJson(Map<String, dynamic> json) {
  return _SyncStatusModel.fromJson(json);
}

/// @nodoc
mixin _$SyncStatusModel {
  /// Number of mutations pending sync
  int get pendingCount => throw _privateConstructorUsedError;

  /// Number of mutations that failed to sync
  int get failedCount => throw _privateConstructorUsedError;

  /// Whether a sync is currently in progress
  bool get isSyncing => throw _privateConstructorUsedError;

  /// When the last successful sync occurred
  DateTime? get lastSyncAt => throw _privateConstructorUsedError;

  /// Last error message if any
  String? get lastError => throw _privateConstructorUsedError;

  /// Serializes this SyncStatusModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SyncStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SyncStatusModelCopyWith<SyncStatusModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncStatusModelCopyWith<$Res> {
  factory $SyncStatusModelCopyWith(
          SyncStatusModel value, $Res Function(SyncStatusModel) then) =
      _$SyncStatusModelCopyWithImpl<$Res, SyncStatusModel>;
  @useResult
  $Res call(
      {int pendingCount,
      int failedCount,
      bool isSyncing,
      DateTime? lastSyncAt,
      String? lastError});
}

/// @nodoc
class _$SyncStatusModelCopyWithImpl<$Res, $Val extends SyncStatusModel>
    implements $SyncStatusModelCopyWith<$Res> {
  _$SyncStatusModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SyncStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pendingCount = null,
    Object? failedCount = null,
    Object? isSyncing = null,
    Object? lastSyncAt = freezed,
    Object? lastError = freezed,
  }) {
    return _then(_value.copyWith(
      pendingCount: null == pendingCount
          ? _value.pendingCount
          : pendingCount // ignore: cast_nullable_to_non_nullable
              as int,
      failedCount: null == failedCount
          ? _value.failedCount
          : failedCount // ignore: cast_nullable_to_non_nullable
              as int,
      isSyncing: null == isSyncing
          ? _value.isSyncing
          : isSyncing // ignore: cast_nullable_to_non_nullable
              as bool,
      lastSyncAt: freezed == lastSyncAt
          ? _value.lastSyncAt
          : lastSyncAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastError: freezed == lastError
          ? _value.lastError
          : lastError // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SyncStatusModelImplCopyWith<$Res>
    implements $SyncStatusModelCopyWith<$Res> {
  factory _$$SyncStatusModelImplCopyWith(_$SyncStatusModelImpl value,
          $Res Function(_$SyncStatusModelImpl) then) =
      __$$SyncStatusModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int pendingCount,
      int failedCount,
      bool isSyncing,
      DateTime? lastSyncAt,
      String? lastError});
}

/// @nodoc
class __$$SyncStatusModelImplCopyWithImpl<$Res>
    extends _$SyncStatusModelCopyWithImpl<$Res, _$SyncStatusModelImpl>
    implements _$$SyncStatusModelImplCopyWith<$Res> {
  __$$SyncStatusModelImplCopyWithImpl(
      _$SyncStatusModelImpl _value, $Res Function(_$SyncStatusModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SyncStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pendingCount = null,
    Object? failedCount = null,
    Object? isSyncing = null,
    Object? lastSyncAt = freezed,
    Object? lastError = freezed,
  }) {
    return _then(_$SyncStatusModelImpl(
      pendingCount: null == pendingCount
          ? _value.pendingCount
          : pendingCount // ignore: cast_nullable_to_non_nullable
              as int,
      failedCount: null == failedCount
          ? _value.failedCount
          : failedCount // ignore: cast_nullable_to_non_nullable
              as int,
      isSyncing: null == isSyncing
          ? _value.isSyncing
          : isSyncing // ignore: cast_nullable_to_non_nullable
              as bool,
      lastSyncAt: freezed == lastSyncAt
          ? _value.lastSyncAt
          : lastSyncAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastError: freezed == lastError
          ? _value.lastError
          : lastError // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SyncStatusModelImpl extends _SyncStatusModel {
  const _$SyncStatusModelImpl(
      {this.pendingCount = 0,
      this.failedCount = 0,
      this.isSyncing = false,
      this.lastSyncAt,
      this.lastError})
      : super._();

  factory _$SyncStatusModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SyncStatusModelImplFromJson(json);

  /// Number of mutations pending sync
  @override
  @JsonKey()
  final int pendingCount;

  /// Number of mutations that failed to sync
  @override
  @JsonKey()
  final int failedCount;

  /// Whether a sync is currently in progress
  @override
  @JsonKey()
  final bool isSyncing;

  /// When the last successful sync occurred
  @override
  final DateTime? lastSyncAt;

  /// Last error message if any
  @override
  final String? lastError;

  @override
  String toString() {
    return 'SyncStatusModel(pendingCount: $pendingCount, failedCount: $failedCount, isSyncing: $isSyncing, lastSyncAt: $lastSyncAt, lastError: $lastError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncStatusModelImpl &&
            (identical(other.pendingCount, pendingCount) ||
                other.pendingCount == pendingCount) &&
            (identical(other.failedCount, failedCount) ||
                other.failedCount == failedCount) &&
            (identical(other.isSyncing, isSyncing) ||
                other.isSyncing == isSyncing) &&
            (identical(other.lastSyncAt, lastSyncAt) ||
                other.lastSyncAt == lastSyncAt) &&
            (identical(other.lastError, lastError) ||
                other.lastError == lastError));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, pendingCount, failedCount, isSyncing, lastSyncAt, lastError);

  /// Create a copy of SyncStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncStatusModelImplCopyWith<_$SyncStatusModelImpl> get copyWith =>
      __$$SyncStatusModelImplCopyWithImpl<_$SyncStatusModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SyncStatusModelImplToJson(
      this,
    );
  }
}

abstract class _SyncStatusModel extends SyncStatusModel {
  const factory _SyncStatusModel(
      {final int pendingCount,
      final int failedCount,
      final bool isSyncing,
      final DateTime? lastSyncAt,
      final String? lastError}) = _$SyncStatusModelImpl;
  const _SyncStatusModel._() : super._();

  factory _SyncStatusModel.fromJson(Map<String, dynamic> json) =
      _$SyncStatusModelImpl.fromJson;

  /// Number of mutations pending sync
  @override
  int get pendingCount;

  /// Number of mutations that failed to sync
  @override
  int get failedCount;

  /// Whether a sync is currently in progress
  @override
  bool get isSyncing;

  /// When the last successful sync occurred
  @override
  DateTime? get lastSyncAt;

  /// Last error message if any
  @override
  String? get lastError;

  /// Create a copy of SyncStatusModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncStatusModelImplCopyWith<_$SyncStatusModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SyncResultModel _$SyncResultModelFromJson(Map<String, dynamic> json) {
  return _SyncResultModel.fromJson(json);
}

/// @nodoc
mixin _$SyncResultModel {
  /// Number of mutations successfully synced
  int get syncedCount => throw _privateConstructorUsedError;

  /// Number of mutations that failed
  int get failedCount => throw _privateConstructorUsedError;

  /// Number of conflicts detected
  int get conflictCount => throw _privateConstructorUsedError;

  /// List of error messages
  List<String> get errors => throw _privateConstructorUsedError;

  /// When this sync completed
  DateTime? get completedAt => throw _privateConstructorUsedError;

  /// Serializes this SyncResultModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SyncResultModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SyncResultModelCopyWith<SyncResultModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncResultModelCopyWith<$Res> {
  factory $SyncResultModelCopyWith(
          SyncResultModel value, $Res Function(SyncResultModel) then) =
      _$SyncResultModelCopyWithImpl<$Res, SyncResultModel>;
  @useResult
  $Res call(
      {int syncedCount,
      int failedCount,
      int conflictCount,
      List<String> errors,
      DateTime? completedAt});
}

/// @nodoc
class _$SyncResultModelCopyWithImpl<$Res, $Val extends SyncResultModel>
    implements $SyncResultModelCopyWith<$Res> {
  _$SyncResultModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SyncResultModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? syncedCount = null,
    Object? failedCount = null,
    Object? conflictCount = null,
    Object? errors = null,
    Object? completedAt = freezed,
  }) {
    return _then(_value.copyWith(
      syncedCount: null == syncedCount
          ? _value.syncedCount
          : syncedCount // ignore: cast_nullable_to_non_nullable
              as int,
      failedCount: null == failedCount
          ? _value.failedCount
          : failedCount // ignore: cast_nullable_to_non_nullable
              as int,
      conflictCount: null == conflictCount
          ? _value.conflictCount
          : conflictCount // ignore: cast_nullable_to_non_nullable
              as int,
      errors: null == errors
          ? _value.errors
          : errors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SyncResultModelImplCopyWith<$Res>
    implements $SyncResultModelCopyWith<$Res> {
  factory _$$SyncResultModelImplCopyWith(_$SyncResultModelImpl value,
          $Res Function(_$SyncResultModelImpl) then) =
      __$$SyncResultModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int syncedCount,
      int failedCount,
      int conflictCount,
      List<String> errors,
      DateTime? completedAt});
}

/// @nodoc
class __$$SyncResultModelImplCopyWithImpl<$Res>
    extends _$SyncResultModelCopyWithImpl<$Res, _$SyncResultModelImpl>
    implements _$$SyncResultModelImplCopyWith<$Res> {
  __$$SyncResultModelImplCopyWithImpl(
      _$SyncResultModelImpl _value, $Res Function(_$SyncResultModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SyncResultModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? syncedCount = null,
    Object? failedCount = null,
    Object? conflictCount = null,
    Object? errors = null,
    Object? completedAt = freezed,
  }) {
    return _then(_$SyncResultModelImpl(
      syncedCount: null == syncedCount
          ? _value.syncedCount
          : syncedCount // ignore: cast_nullable_to_non_nullable
              as int,
      failedCount: null == failedCount
          ? _value.failedCount
          : failedCount // ignore: cast_nullable_to_non_nullable
              as int,
      conflictCount: null == conflictCount
          ? _value.conflictCount
          : conflictCount // ignore: cast_nullable_to_non_nullable
              as int,
      errors: null == errors
          ? _value._errors
          : errors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SyncResultModelImpl extends _SyncResultModel {
  const _$SyncResultModelImpl(
      {this.syncedCount = 0,
      this.failedCount = 0,
      this.conflictCount = 0,
      final List<String> errors = const [],
      this.completedAt})
      : _errors = errors,
        super._();

  factory _$SyncResultModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SyncResultModelImplFromJson(json);

  /// Number of mutations successfully synced
  @override
  @JsonKey()
  final int syncedCount;

  /// Number of mutations that failed
  @override
  @JsonKey()
  final int failedCount;

  /// Number of conflicts detected
  @override
  @JsonKey()
  final int conflictCount;

  /// List of error messages
  final List<String> _errors;

  /// List of error messages
  @override
  @JsonKey()
  List<String> get errors {
    if (_errors is EqualUnmodifiableListView) return _errors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_errors);
  }

  /// When this sync completed
  @override
  final DateTime? completedAt;

  @override
  String toString() {
    return 'SyncResultModel(syncedCount: $syncedCount, failedCount: $failedCount, conflictCount: $conflictCount, errors: $errors, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncResultModelImpl &&
            (identical(other.syncedCount, syncedCount) ||
                other.syncedCount == syncedCount) &&
            (identical(other.failedCount, failedCount) ||
                other.failedCount == failedCount) &&
            (identical(other.conflictCount, conflictCount) ||
                other.conflictCount == conflictCount) &&
            const DeepCollectionEquality().equals(other._errors, _errors) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, syncedCount, failedCount,
      conflictCount, const DeepCollectionEquality().hash(_errors), completedAt);

  /// Create a copy of SyncResultModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncResultModelImplCopyWith<_$SyncResultModelImpl> get copyWith =>
      __$$SyncResultModelImplCopyWithImpl<_$SyncResultModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SyncResultModelImplToJson(
      this,
    );
  }
}

abstract class _SyncResultModel extends SyncResultModel {
  const factory _SyncResultModel(
      {final int syncedCount,
      final int failedCount,
      final int conflictCount,
      final List<String> errors,
      final DateTime? completedAt}) = _$SyncResultModelImpl;
  const _SyncResultModel._() : super._();

  factory _SyncResultModel.fromJson(Map<String, dynamic> json) =
      _$SyncResultModelImpl.fromJson;

  /// Number of mutations successfully synced
  @override
  int get syncedCount;

  /// Number of mutations that failed
  @override
  int get failedCount;

  /// Number of conflicts detected
  @override
  int get conflictCount;

  /// List of error messages
  @override
  List<String> get errors;

  /// When this sync completed
  @override
  DateTime? get completedAt;

  /// Create a copy of SyncResultModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncResultModelImplCopyWith<_$SyncResultModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
