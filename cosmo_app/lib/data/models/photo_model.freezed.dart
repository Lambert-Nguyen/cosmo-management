// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'photo_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PhotoModel _$PhotoModelFromJson(Map<String, dynamic> json) {
  return _PhotoModel.fromJson(json);
}

/// @nodoc
mixin _$PhotoModel {
  int get id => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  @JsonKey(name: 'thumbnail_url')
  String? get thumbnailUrl => throw _privateConstructorUsedError;
  PhotoType get type => throw _privateConstructorUsedError;
  PhotoApprovalStatus get approvalStatus => throw _privateConstructorUsedError;
  String? get caption => throw _privateConstructorUsedError;
  @JsonKey(name: 'task_id')
  int? get taskId => throw _privateConstructorUsedError;
  @JsonKey(name: 'checklist_item_id')
  int? get checklistItemId => throw _privateConstructorUsedError;
  @JsonKey(name: 'checklist_response_id')
  int? get checklistResponseId => throw _privateConstructorUsedError;
  @JsonKey(name: 'inventory_id')
  int? get inventoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'lost_found_id')
  int? get lostFoundId => throw _privateConstructorUsedError;
  @JsonKey(name: 'property_id')
  int? get propertyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'property_name')
  String? get propertyName => throw _privateConstructorUsedError;
  @JsonKey(name: 'uploaded_by')
  int? get uploadedById => throw _privateConstructorUsedError;
  @JsonKey(name: 'uploaded_by_name')
  String? get uploadedByName => throw _privateConstructorUsedError;
  @JsonKey(name: 'approved_by')
  int? get approvedById => throw _privateConstructorUsedError;
  @JsonKey(name: 'approved_by_name')
  String? get approvedByName => throw _privateConstructorUsedError;
  @JsonKey(name: 'approved_at')
  DateTime? get approvedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'rejection_reason')
  String? get rejectionReason => throw _privateConstructorUsedError;
  @JsonKey(name: 'file_size')
  int? get fileSize => throw _privateConstructorUsedError;
  @JsonKey(name: 'width')
  int? get width => throw _privateConstructorUsedError;
  @JsonKey(name: 'height')
  int? get height => throw _privateConstructorUsedError;
  @JsonKey(name: 'mime_type')
  String? get mimeType => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this PhotoModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PhotoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PhotoModelCopyWith<PhotoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PhotoModelCopyWith<$Res> {
  factory $PhotoModelCopyWith(
          PhotoModel value, $Res Function(PhotoModel) then) =
      _$PhotoModelCopyWithImpl<$Res, PhotoModel>;
  @useResult
  $Res call(
      {int id,
      String url,
      @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
      PhotoType type,
      PhotoApprovalStatus approvalStatus,
      String? caption,
      @JsonKey(name: 'task_id') int? taskId,
      @JsonKey(name: 'checklist_item_id') int? checklistItemId,
      @JsonKey(name: 'checklist_response_id') int? checklistResponseId,
      @JsonKey(name: 'inventory_id') int? inventoryId,
      @JsonKey(name: 'lost_found_id') int? lostFoundId,
      @JsonKey(name: 'property_id') int? propertyId,
      @JsonKey(name: 'property_name') String? propertyName,
      @JsonKey(name: 'uploaded_by') int? uploadedById,
      @JsonKey(name: 'uploaded_by_name') String? uploadedByName,
      @JsonKey(name: 'approved_by') int? approvedById,
      @JsonKey(name: 'approved_by_name') String? approvedByName,
      @JsonKey(name: 'approved_at') DateTime? approvedAt,
      @JsonKey(name: 'rejection_reason') String? rejectionReason,
      @JsonKey(name: 'file_size') int? fileSize,
      @JsonKey(name: 'width') int? width,
      @JsonKey(name: 'height') int? height,
      @JsonKey(name: 'mime_type') String? mimeType,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$PhotoModelCopyWithImpl<$Res, $Val extends PhotoModel>
    implements $PhotoModelCopyWith<$Res> {
  _$PhotoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PhotoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? url = null,
    Object? thumbnailUrl = freezed,
    Object? type = null,
    Object? approvalStatus = null,
    Object? caption = freezed,
    Object? taskId = freezed,
    Object? checklistItemId = freezed,
    Object? checklistResponseId = freezed,
    Object? inventoryId = freezed,
    Object? lostFoundId = freezed,
    Object? propertyId = freezed,
    Object? propertyName = freezed,
    Object? uploadedById = freezed,
    Object? uploadedByName = freezed,
    Object? approvedById = freezed,
    Object? approvedByName = freezed,
    Object? approvedAt = freezed,
    Object? rejectionReason = freezed,
    Object? fileSize = freezed,
    Object? width = freezed,
    Object? height = freezed,
    Object? mimeType = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PhotoType,
      approvalStatus: null == approvalStatus
          ? _value.approvalStatus
          : approvalStatus // ignore: cast_nullable_to_non_nullable
              as PhotoApprovalStatus,
      caption: freezed == caption
          ? _value.caption
          : caption // ignore: cast_nullable_to_non_nullable
              as String?,
      taskId: freezed == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as int?,
      checklistItemId: freezed == checklistItemId
          ? _value.checklistItemId
          : checklistItemId // ignore: cast_nullable_to_non_nullable
              as int?,
      checklistResponseId: freezed == checklistResponseId
          ? _value.checklistResponseId
          : checklistResponseId // ignore: cast_nullable_to_non_nullable
              as int?,
      inventoryId: freezed == inventoryId
          ? _value.inventoryId
          : inventoryId // ignore: cast_nullable_to_non_nullable
              as int?,
      lostFoundId: freezed == lostFoundId
          ? _value.lostFoundId
          : lostFoundId // ignore: cast_nullable_to_non_nullable
              as int?,
      propertyId: freezed == propertyId
          ? _value.propertyId
          : propertyId // ignore: cast_nullable_to_non_nullable
              as int?,
      propertyName: freezed == propertyName
          ? _value.propertyName
          : propertyName // ignore: cast_nullable_to_non_nullable
              as String?,
      uploadedById: freezed == uploadedById
          ? _value.uploadedById
          : uploadedById // ignore: cast_nullable_to_non_nullable
              as int?,
      uploadedByName: freezed == uploadedByName
          ? _value.uploadedByName
          : uploadedByName // ignore: cast_nullable_to_non_nullable
              as String?,
      approvedById: freezed == approvedById
          ? _value.approvedById
          : approvedById // ignore: cast_nullable_to_non_nullable
              as int?,
      approvedByName: freezed == approvedByName
          ? _value.approvedByName
          : approvedByName // ignore: cast_nullable_to_non_nullable
              as String?,
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      fileSize: freezed == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int?,
      width: freezed == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int?,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int?,
      mimeType: freezed == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PhotoModelImplCopyWith<$Res>
    implements $PhotoModelCopyWith<$Res> {
  factory _$$PhotoModelImplCopyWith(
          _$PhotoModelImpl value, $Res Function(_$PhotoModelImpl) then) =
      __$$PhotoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String url,
      @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
      PhotoType type,
      PhotoApprovalStatus approvalStatus,
      String? caption,
      @JsonKey(name: 'task_id') int? taskId,
      @JsonKey(name: 'checklist_item_id') int? checklistItemId,
      @JsonKey(name: 'checklist_response_id') int? checklistResponseId,
      @JsonKey(name: 'inventory_id') int? inventoryId,
      @JsonKey(name: 'lost_found_id') int? lostFoundId,
      @JsonKey(name: 'property_id') int? propertyId,
      @JsonKey(name: 'property_name') String? propertyName,
      @JsonKey(name: 'uploaded_by') int? uploadedById,
      @JsonKey(name: 'uploaded_by_name') String? uploadedByName,
      @JsonKey(name: 'approved_by') int? approvedById,
      @JsonKey(name: 'approved_by_name') String? approvedByName,
      @JsonKey(name: 'approved_at') DateTime? approvedAt,
      @JsonKey(name: 'rejection_reason') String? rejectionReason,
      @JsonKey(name: 'file_size') int? fileSize,
      @JsonKey(name: 'width') int? width,
      @JsonKey(name: 'height') int? height,
      @JsonKey(name: 'mime_type') String? mimeType,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$PhotoModelImplCopyWithImpl<$Res>
    extends _$PhotoModelCopyWithImpl<$Res, _$PhotoModelImpl>
    implements _$$PhotoModelImplCopyWith<$Res> {
  __$$PhotoModelImplCopyWithImpl(
      _$PhotoModelImpl _value, $Res Function(_$PhotoModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of PhotoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? url = null,
    Object? thumbnailUrl = freezed,
    Object? type = null,
    Object? approvalStatus = null,
    Object? caption = freezed,
    Object? taskId = freezed,
    Object? checklistItemId = freezed,
    Object? checklistResponseId = freezed,
    Object? inventoryId = freezed,
    Object? lostFoundId = freezed,
    Object? propertyId = freezed,
    Object? propertyName = freezed,
    Object? uploadedById = freezed,
    Object? uploadedByName = freezed,
    Object? approvedById = freezed,
    Object? approvedByName = freezed,
    Object? approvedAt = freezed,
    Object? rejectionReason = freezed,
    Object? fileSize = freezed,
    Object? width = freezed,
    Object? height = freezed,
    Object? mimeType = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$PhotoModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailUrl: freezed == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PhotoType,
      approvalStatus: null == approvalStatus
          ? _value.approvalStatus
          : approvalStatus // ignore: cast_nullable_to_non_nullable
              as PhotoApprovalStatus,
      caption: freezed == caption
          ? _value.caption
          : caption // ignore: cast_nullable_to_non_nullable
              as String?,
      taskId: freezed == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as int?,
      checklistItemId: freezed == checklistItemId
          ? _value.checklistItemId
          : checklistItemId // ignore: cast_nullable_to_non_nullable
              as int?,
      checklistResponseId: freezed == checklistResponseId
          ? _value.checklistResponseId
          : checklistResponseId // ignore: cast_nullable_to_non_nullable
              as int?,
      inventoryId: freezed == inventoryId
          ? _value.inventoryId
          : inventoryId // ignore: cast_nullable_to_non_nullable
              as int?,
      lostFoundId: freezed == lostFoundId
          ? _value.lostFoundId
          : lostFoundId // ignore: cast_nullable_to_non_nullable
              as int?,
      propertyId: freezed == propertyId
          ? _value.propertyId
          : propertyId // ignore: cast_nullable_to_non_nullable
              as int?,
      propertyName: freezed == propertyName
          ? _value.propertyName
          : propertyName // ignore: cast_nullable_to_non_nullable
              as String?,
      uploadedById: freezed == uploadedById
          ? _value.uploadedById
          : uploadedById // ignore: cast_nullable_to_non_nullable
              as int?,
      uploadedByName: freezed == uploadedByName
          ? _value.uploadedByName
          : uploadedByName // ignore: cast_nullable_to_non_nullable
              as String?,
      approvedById: freezed == approvedById
          ? _value.approvedById
          : approvedById // ignore: cast_nullable_to_non_nullable
              as int?,
      approvedByName: freezed == approvedByName
          ? _value.approvedByName
          : approvedByName // ignore: cast_nullable_to_non_nullable
              as String?,
      approvedAt: freezed == approvedAt
          ? _value.approvedAt
          : approvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      rejectionReason: freezed == rejectionReason
          ? _value.rejectionReason
          : rejectionReason // ignore: cast_nullable_to_non_nullable
              as String?,
      fileSize: freezed == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int?,
      width: freezed == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int?,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int?,
      mimeType: freezed == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PhotoModelImpl extends _PhotoModel {
  const _$PhotoModelImpl(
      {required this.id,
      required this.url,
      @JsonKey(name: 'thumbnail_url') this.thumbnailUrl,
      this.type = PhotoType.general,
      this.approvalStatus = PhotoApprovalStatus.pending,
      this.caption,
      @JsonKey(name: 'task_id') this.taskId,
      @JsonKey(name: 'checklist_item_id') this.checklistItemId,
      @JsonKey(name: 'checklist_response_id') this.checklistResponseId,
      @JsonKey(name: 'inventory_id') this.inventoryId,
      @JsonKey(name: 'lost_found_id') this.lostFoundId,
      @JsonKey(name: 'property_id') this.propertyId,
      @JsonKey(name: 'property_name') this.propertyName,
      @JsonKey(name: 'uploaded_by') this.uploadedById,
      @JsonKey(name: 'uploaded_by_name') this.uploadedByName,
      @JsonKey(name: 'approved_by') this.approvedById,
      @JsonKey(name: 'approved_by_name') this.approvedByName,
      @JsonKey(name: 'approved_at') this.approvedAt,
      @JsonKey(name: 'rejection_reason') this.rejectionReason,
      @JsonKey(name: 'file_size') this.fileSize,
      @JsonKey(name: 'width') this.width,
      @JsonKey(name: 'height') this.height,
      @JsonKey(name: 'mime_type') this.mimeType,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt})
      : super._();

  factory _$PhotoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PhotoModelImplFromJson(json);

  @override
  final int id;
  @override
  final String url;
  @override
  @JsonKey(name: 'thumbnail_url')
  final String? thumbnailUrl;
  @override
  @JsonKey()
  final PhotoType type;
  @override
  @JsonKey()
  final PhotoApprovalStatus approvalStatus;
  @override
  final String? caption;
  @override
  @JsonKey(name: 'task_id')
  final int? taskId;
  @override
  @JsonKey(name: 'checklist_item_id')
  final int? checklistItemId;
  @override
  @JsonKey(name: 'checklist_response_id')
  final int? checklistResponseId;
  @override
  @JsonKey(name: 'inventory_id')
  final int? inventoryId;
  @override
  @JsonKey(name: 'lost_found_id')
  final int? lostFoundId;
  @override
  @JsonKey(name: 'property_id')
  final int? propertyId;
  @override
  @JsonKey(name: 'property_name')
  final String? propertyName;
  @override
  @JsonKey(name: 'uploaded_by')
  final int? uploadedById;
  @override
  @JsonKey(name: 'uploaded_by_name')
  final String? uploadedByName;
  @override
  @JsonKey(name: 'approved_by')
  final int? approvedById;
  @override
  @JsonKey(name: 'approved_by_name')
  final String? approvedByName;
  @override
  @JsonKey(name: 'approved_at')
  final DateTime? approvedAt;
  @override
  @JsonKey(name: 'rejection_reason')
  final String? rejectionReason;
  @override
  @JsonKey(name: 'file_size')
  final int? fileSize;
  @override
  @JsonKey(name: 'width')
  final int? width;
  @override
  @JsonKey(name: 'height')
  final int? height;
  @override
  @JsonKey(name: 'mime_type')
  final String? mimeType;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'PhotoModel(id: $id, url: $url, thumbnailUrl: $thumbnailUrl, type: $type, approvalStatus: $approvalStatus, caption: $caption, taskId: $taskId, checklistItemId: $checklistItemId, checklistResponseId: $checklistResponseId, inventoryId: $inventoryId, lostFoundId: $lostFoundId, propertyId: $propertyId, propertyName: $propertyName, uploadedById: $uploadedById, uploadedByName: $uploadedByName, approvedById: $approvedById, approvedByName: $approvedByName, approvedAt: $approvedAt, rejectionReason: $rejectionReason, fileSize: $fileSize, width: $width, height: $height, mimeType: $mimeType, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PhotoModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.approvalStatus, approvalStatus) ||
                other.approvalStatus == approvalStatus) &&
            (identical(other.caption, caption) || other.caption == caption) &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.checklistItemId, checklistItemId) ||
                other.checklistItemId == checklistItemId) &&
            (identical(other.checklistResponseId, checklistResponseId) ||
                other.checklistResponseId == checklistResponseId) &&
            (identical(other.inventoryId, inventoryId) ||
                other.inventoryId == inventoryId) &&
            (identical(other.lostFoundId, lostFoundId) ||
                other.lostFoundId == lostFoundId) &&
            (identical(other.propertyId, propertyId) ||
                other.propertyId == propertyId) &&
            (identical(other.propertyName, propertyName) ||
                other.propertyName == propertyName) &&
            (identical(other.uploadedById, uploadedById) ||
                other.uploadedById == uploadedById) &&
            (identical(other.uploadedByName, uploadedByName) ||
                other.uploadedByName == uploadedByName) &&
            (identical(other.approvedById, approvedById) ||
                other.approvedById == approvedById) &&
            (identical(other.approvedByName, approvedByName) ||
                other.approvedByName == approvedByName) &&
            (identical(other.approvedAt, approvedAt) ||
                other.approvedAt == approvedAt) &&
            (identical(other.rejectionReason, rejectionReason) ||
                other.rejectionReason == rejectionReason) &&
            (identical(other.fileSize, fileSize) ||
                other.fileSize == fileSize) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        url,
        thumbnailUrl,
        type,
        approvalStatus,
        caption,
        taskId,
        checklistItemId,
        checklistResponseId,
        inventoryId,
        lostFoundId,
        propertyId,
        propertyName,
        uploadedById,
        uploadedByName,
        approvedById,
        approvedByName,
        approvedAt,
        rejectionReason,
        fileSize,
        width,
        height,
        mimeType,
        createdAt,
        updatedAt
      ]);

  /// Create a copy of PhotoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PhotoModelImplCopyWith<_$PhotoModelImpl> get copyWith =>
      __$$PhotoModelImplCopyWithImpl<_$PhotoModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PhotoModelImplToJson(
      this,
    );
  }
}

abstract class _PhotoModel extends PhotoModel {
  const factory _PhotoModel(
      {required final int id,
      required final String url,
      @JsonKey(name: 'thumbnail_url') final String? thumbnailUrl,
      final PhotoType type,
      final PhotoApprovalStatus approvalStatus,
      final String? caption,
      @JsonKey(name: 'task_id') final int? taskId,
      @JsonKey(name: 'checklist_item_id') final int? checklistItemId,
      @JsonKey(name: 'checklist_response_id') final int? checklistResponseId,
      @JsonKey(name: 'inventory_id') final int? inventoryId,
      @JsonKey(name: 'lost_found_id') final int? lostFoundId,
      @JsonKey(name: 'property_id') final int? propertyId,
      @JsonKey(name: 'property_name') final String? propertyName,
      @JsonKey(name: 'uploaded_by') final int? uploadedById,
      @JsonKey(name: 'uploaded_by_name') final String? uploadedByName,
      @JsonKey(name: 'approved_by') final int? approvedById,
      @JsonKey(name: 'approved_by_name') final String? approvedByName,
      @JsonKey(name: 'approved_at') final DateTime? approvedAt,
      @JsonKey(name: 'rejection_reason') final String? rejectionReason,
      @JsonKey(name: 'file_size') final int? fileSize,
      @JsonKey(name: 'width') final int? width,
      @JsonKey(name: 'height') final int? height,
      @JsonKey(name: 'mime_type') final String? mimeType,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at')
      final DateTime? updatedAt}) = _$PhotoModelImpl;
  const _PhotoModel._() : super._();

  factory _PhotoModel.fromJson(Map<String, dynamic> json) =
      _$PhotoModelImpl.fromJson;

  @override
  int get id;
  @override
  String get url;
  @override
  @JsonKey(name: 'thumbnail_url')
  String? get thumbnailUrl;
  @override
  PhotoType get type;
  @override
  PhotoApprovalStatus get approvalStatus;
  @override
  String? get caption;
  @override
  @JsonKey(name: 'task_id')
  int? get taskId;
  @override
  @JsonKey(name: 'checklist_item_id')
  int? get checklistItemId;
  @override
  @JsonKey(name: 'checklist_response_id')
  int? get checklistResponseId;
  @override
  @JsonKey(name: 'inventory_id')
  int? get inventoryId;
  @override
  @JsonKey(name: 'lost_found_id')
  int? get lostFoundId;
  @override
  @JsonKey(name: 'property_id')
  int? get propertyId;
  @override
  @JsonKey(name: 'property_name')
  String? get propertyName;
  @override
  @JsonKey(name: 'uploaded_by')
  int? get uploadedById;
  @override
  @JsonKey(name: 'uploaded_by_name')
  String? get uploadedByName;
  @override
  @JsonKey(name: 'approved_by')
  int? get approvedById;
  @override
  @JsonKey(name: 'approved_by_name')
  String? get approvedByName;
  @override
  @JsonKey(name: 'approved_at')
  DateTime? get approvedAt;
  @override
  @JsonKey(name: 'rejection_reason')
  String? get rejectionReason;
  @override
  @JsonKey(name: 'file_size')
  int? get fileSize;
  @override
  @JsonKey(name: 'width')
  int? get width;
  @override
  @JsonKey(name: 'height')
  int? get height;
  @override
  @JsonKey(name: 'mime_type')
  String? get mimeType;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of PhotoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PhotoModelImplCopyWith<_$PhotoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PhotoComparisonModel _$PhotoComparisonModelFromJson(Map<String, dynamic> json) {
  return _PhotoComparisonModel.fromJson(json);
}

/// @nodoc
mixin _$PhotoComparisonModel {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'task_id')
  int? get taskId => throw _privateConstructorUsedError;
  @JsonKey(name: 'task_title')
  String? get taskTitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'property_id')
  int? get propertyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'property_name')
  String? get propertyName => throw _privateConstructorUsedError;
  @JsonKey(name: 'before_photo')
  PhotoModel? get beforePhoto => throw _privateConstructorUsedError;
  @JsonKey(name: 'after_photo')
  PhotoModel? get afterPhoto => throw _privateConstructorUsedError;
  @JsonKey(name: 'before_url')
  String? get beforeUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'after_url')
  String? get afterUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_description')
  String? get locationDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'comparison_notes')
  String? get comparisonNotes => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_by')
  int? get createdById => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_by_name')
  String? get createdByName => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this PhotoComparisonModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PhotoComparisonModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PhotoComparisonModelCopyWith<PhotoComparisonModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PhotoComparisonModelCopyWith<$Res> {
  factory $PhotoComparisonModelCopyWith(PhotoComparisonModel value,
          $Res Function(PhotoComparisonModel) then) =
      _$PhotoComparisonModelCopyWithImpl<$Res, PhotoComparisonModel>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'task_id') int? taskId,
      @JsonKey(name: 'task_title') String? taskTitle,
      @JsonKey(name: 'property_id') int? propertyId,
      @JsonKey(name: 'property_name') String? propertyName,
      @JsonKey(name: 'before_photo') PhotoModel? beforePhoto,
      @JsonKey(name: 'after_photo') PhotoModel? afterPhoto,
      @JsonKey(name: 'before_url') String? beforeUrl,
      @JsonKey(name: 'after_url') String? afterUrl,
      @JsonKey(name: 'location_description') String? locationDescription,
      @JsonKey(name: 'comparison_notes') String? comparisonNotes,
      @JsonKey(name: 'created_by') int? createdById,
      @JsonKey(name: 'created_by_name') String? createdByName,
      @JsonKey(name: 'created_at') DateTime? createdAt});

  $PhotoModelCopyWith<$Res>? get beforePhoto;
  $PhotoModelCopyWith<$Res>? get afterPhoto;
}

/// @nodoc
class _$PhotoComparisonModelCopyWithImpl<$Res,
        $Val extends PhotoComparisonModel>
    implements $PhotoComparisonModelCopyWith<$Res> {
  _$PhotoComparisonModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PhotoComparisonModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? taskId = freezed,
    Object? taskTitle = freezed,
    Object? propertyId = freezed,
    Object? propertyName = freezed,
    Object? beforePhoto = freezed,
    Object? afterPhoto = freezed,
    Object? beforeUrl = freezed,
    Object? afterUrl = freezed,
    Object? locationDescription = freezed,
    Object? comparisonNotes = freezed,
    Object? createdById = freezed,
    Object? createdByName = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      taskId: freezed == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as int?,
      taskTitle: freezed == taskTitle
          ? _value.taskTitle
          : taskTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      propertyId: freezed == propertyId
          ? _value.propertyId
          : propertyId // ignore: cast_nullable_to_non_nullable
              as int?,
      propertyName: freezed == propertyName
          ? _value.propertyName
          : propertyName // ignore: cast_nullable_to_non_nullable
              as String?,
      beforePhoto: freezed == beforePhoto
          ? _value.beforePhoto
          : beforePhoto // ignore: cast_nullable_to_non_nullable
              as PhotoModel?,
      afterPhoto: freezed == afterPhoto
          ? _value.afterPhoto
          : afterPhoto // ignore: cast_nullable_to_non_nullable
              as PhotoModel?,
      beforeUrl: freezed == beforeUrl
          ? _value.beforeUrl
          : beforeUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      afterUrl: freezed == afterUrl
          ? _value.afterUrl
          : afterUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      locationDescription: freezed == locationDescription
          ? _value.locationDescription
          : locationDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      comparisonNotes: freezed == comparisonNotes
          ? _value.comparisonNotes
          : comparisonNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdById: freezed == createdById
          ? _value.createdById
          : createdById // ignore: cast_nullable_to_non_nullable
              as int?,
      createdByName: freezed == createdByName
          ? _value.createdByName
          : createdByName // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  /// Create a copy of PhotoComparisonModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PhotoModelCopyWith<$Res>? get beforePhoto {
    if (_value.beforePhoto == null) {
      return null;
    }

    return $PhotoModelCopyWith<$Res>(_value.beforePhoto!, (value) {
      return _then(_value.copyWith(beforePhoto: value) as $Val);
    });
  }

  /// Create a copy of PhotoComparisonModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PhotoModelCopyWith<$Res>? get afterPhoto {
    if (_value.afterPhoto == null) {
      return null;
    }

    return $PhotoModelCopyWith<$Res>(_value.afterPhoto!, (value) {
      return _then(_value.copyWith(afterPhoto: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PhotoComparisonModelImplCopyWith<$Res>
    implements $PhotoComparisonModelCopyWith<$Res> {
  factory _$$PhotoComparisonModelImplCopyWith(_$PhotoComparisonModelImpl value,
          $Res Function(_$PhotoComparisonModelImpl) then) =
      __$$PhotoComparisonModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'task_id') int? taskId,
      @JsonKey(name: 'task_title') String? taskTitle,
      @JsonKey(name: 'property_id') int? propertyId,
      @JsonKey(name: 'property_name') String? propertyName,
      @JsonKey(name: 'before_photo') PhotoModel? beforePhoto,
      @JsonKey(name: 'after_photo') PhotoModel? afterPhoto,
      @JsonKey(name: 'before_url') String? beforeUrl,
      @JsonKey(name: 'after_url') String? afterUrl,
      @JsonKey(name: 'location_description') String? locationDescription,
      @JsonKey(name: 'comparison_notes') String? comparisonNotes,
      @JsonKey(name: 'created_by') int? createdById,
      @JsonKey(name: 'created_by_name') String? createdByName,
      @JsonKey(name: 'created_at') DateTime? createdAt});

  @override
  $PhotoModelCopyWith<$Res>? get beforePhoto;
  @override
  $PhotoModelCopyWith<$Res>? get afterPhoto;
}

/// @nodoc
class __$$PhotoComparisonModelImplCopyWithImpl<$Res>
    extends _$PhotoComparisonModelCopyWithImpl<$Res, _$PhotoComparisonModelImpl>
    implements _$$PhotoComparisonModelImplCopyWith<$Res> {
  __$$PhotoComparisonModelImplCopyWithImpl(_$PhotoComparisonModelImpl _value,
      $Res Function(_$PhotoComparisonModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of PhotoComparisonModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? taskId = freezed,
    Object? taskTitle = freezed,
    Object? propertyId = freezed,
    Object? propertyName = freezed,
    Object? beforePhoto = freezed,
    Object? afterPhoto = freezed,
    Object? beforeUrl = freezed,
    Object? afterUrl = freezed,
    Object? locationDescription = freezed,
    Object? comparisonNotes = freezed,
    Object? createdById = freezed,
    Object? createdByName = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$PhotoComparisonModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      taskId: freezed == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as int?,
      taskTitle: freezed == taskTitle
          ? _value.taskTitle
          : taskTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      propertyId: freezed == propertyId
          ? _value.propertyId
          : propertyId // ignore: cast_nullable_to_non_nullable
              as int?,
      propertyName: freezed == propertyName
          ? _value.propertyName
          : propertyName // ignore: cast_nullable_to_non_nullable
              as String?,
      beforePhoto: freezed == beforePhoto
          ? _value.beforePhoto
          : beforePhoto // ignore: cast_nullable_to_non_nullable
              as PhotoModel?,
      afterPhoto: freezed == afterPhoto
          ? _value.afterPhoto
          : afterPhoto // ignore: cast_nullable_to_non_nullable
              as PhotoModel?,
      beforeUrl: freezed == beforeUrl
          ? _value.beforeUrl
          : beforeUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      afterUrl: freezed == afterUrl
          ? _value.afterUrl
          : afterUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      locationDescription: freezed == locationDescription
          ? _value.locationDescription
          : locationDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      comparisonNotes: freezed == comparisonNotes
          ? _value.comparisonNotes
          : comparisonNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdById: freezed == createdById
          ? _value.createdById
          : createdById // ignore: cast_nullable_to_non_nullable
              as int?,
      createdByName: freezed == createdByName
          ? _value.createdByName
          : createdByName // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PhotoComparisonModelImpl extends _PhotoComparisonModel {
  const _$PhotoComparisonModelImpl(
      {required this.id,
      @JsonKey(name: 'task_id') this.taskId,
      @JsonKey(name: 'task_title') this.taskTitle,
      @JsonKey(name: 'property_id') this.propertyId,
      @JsonKey(name: 'property_name') this.propertyName,
      @JsonKey(name: 'before_photo') this.beforePhoto,
      @JsonKey(name: 'after_photo') this.afterPhoto,
      @JsonKey(name: 'before_url') this.beforeUrl,
      @JsonKey(name: 'after_url') this.afterUrl,
      @JsonKey(name: 'location_description') this.locationDescription,
      @JsonKey(name: 'comparison_notes') this.comparisonNotes,
      @JsonKey(name: 'created_by') this.createdById,
      @JsonKey(name: 'created_by_name') this.createdByName,
      @JsonKey(name: 'created_at') this.createdAt})
      : super._();

  factory _$PhotoComparisonModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PhotoComparisonModelImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'task_id')
  final int? taskId;
  @override
  @JsonKey(name: 'task_title')
  final String? taskTitle;
  @override
  @JsonKey(name: 'property_id')
  final int? propertyId;
  @override
  @JsonKey(name: 'property_name')
  final String? propertyName;
  @override
  @JsonKey(name: 'before_photo')
  final PhotoModel? beforePhoto;
  @override
  @JsonKey(name: 'after_photo')
  final PhotoModel? afterPhoto;
  @override
  @JsonKey(name: 'before_url')
  final String? beforeUrl;
  @override
  @JsonKey(name: 'after_url')
  final String? afterUrl;
  @override
  @JsonKey(name: 'location_description')
  final String? locationDescription;
  @override
  @JsonKey(name: 'comparison_notes')
  final String? comparisonNotes;
  @override
  @JsonKey(name: 'created_by')
  final int? createdById;
  @override
  @JsonKey(name: 'created_by_name')
  final String? createdByName;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'PhotoComparisonModel(id: $id, taskId: $taskId, taskTitle: $taskTitle, propertyId: $propertyId, propertyName: $propertyName, beforePhoto: $beforePhoto, afterPhoto: $afterPhoto, beforeUrl: $beforeUrl, afterUrl: $afterUrl, locationDescription: $locationDescription, comparisonNotes: $comparisonNotes, createdById: $createdById, createdByName: $createdByName, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PhotoComparisonModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.taskTitle, taskTitle) ||
                other.taskTitle == taskTitle) &&
            (identical(other.propertyId, propertyId) ||
                other.propertyId == propertyId) &&
            (identical(other.propertyName, propertyName) ||
                other.propertyName == propertyName) &&
            (identical(other.beforePhoto, beforePhoto) ||
                other.beforePhoto == beforePhoto) &&
            (identical(other.afterPhoto, afterPhoto) ||
                other.afterPhoto == afterPhoto) &&
            (identical(other.beforeUrl, beforeUrl) ||
                other.beforeUrl == beforeUrl) &&
            (identical(other.afterUrl, afterUrl) ||
                other.afterUrl == afterUrl) &&
            (identical(other.locationDescription, locationDescription) ||
                other.locationDescription == locationDescription) &&
            (identical(other.comparisonNotes, comparisonNotes) ||
                other.comparisonNotes == comparisonNotes) &&
            (identical(other.createdById, createdById) ||
                other.createdById == createdById) &&
            (identical(other.createdByName, createdByName) ||
                other.createdByName == createdByName) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      taskId,
      taskTitle,
      propertyId,
      propertyName,
      beforePhoto,
      afterPhoto,
      beforeUrl,
      afterUrl,
      locationDescription,
      comparisonNotes,
      createdById,
      createdByName,
      createdAt);

  /// Create a copy of PhotoComparisonModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PhotoComparisonModelImplCopyWith<_$PhotoComparisonModelImpl>
      get copyWith =>
          __$$PhotoComparisonModelImplCopyWithImpl<_$PhotoComparisonModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PhotoComparisonModelImplToJson(
      this,
    );
  }
}

abstract class _PhotoComparisonModel extends PhotoComparisonModel {
  const factory _PhotoComparisonModel(
      {required final int id,
      @JsonKey(name: 'task_id') final int? taskId,
      @JsonKey(name: 'task_title') final String? taskTitle,
      @JsonKey(name: 'property_id') final int? propertyId,
      @JsonKey(name: 'property_name') final String? propertyName,
      @JsonKey(name: 'before_photo') final PhotoModel? beforePhoto,
      @JsonKey(name: 'after_photo') final PhotoModel? afterPhoto,
      @JsonKey(name: 'before_url') final String? beforeUrl,
      @JsonKey(name: 'after_url') final String? afterUrl,
      @JsonKey(name: 'location_description') final String? locationDescription,
      @JsonKey(name: 'comparison_notes') final String? comparisonNotes,
      @JsonKey(name: 'created_by') final int? createdById,
      @JsonKey(name: 'created_by_name') final String? createdByName,
      @JsonKey(name: 'created_at')
      final DateTime? createdAt}) = _$PhotoComparisonModelImpl;
  const _PhotoComparisonModel._() : super._();

  factory _PhotoComparisonModel.fromJson(Map<String, dynamic> json) =
      _$PhotoComparisonModelImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'task_id')
  int? get taskId;
  @override
  @JsonKey(name: 'task_title')
  String? get taskTitle;
  @override
  @JsonKey(name: 'property_id')
  int? get propertyId;
  @override
  @JsonKey(name: 'property_name')
  String? get propertyName;
  @override
  @JsonKey(name: 'before_photo')
  PhotoModel? get beforePhoto;
  @override
  @JsonKey(name: 'after_photo')
  PhotoModel? get afterPhoto;
  @override
  @JsonKey(name: 'before_url')
  String? get beforeUrl;
  @override
  @JsonKey(name: 'after_url')
  String? get afterUrl;
  @override
  @JsonKey(name: 'location_description')
  String? get locationDescription;
  @override
  @JsonKey(name: 'comparison_notes')
  String? get comparisonNotes;
  @override
  @JsonKey(name: 'created_by')
  int? get createdById;
  @override
  @JsonKey(name: 'created_by_name')
  String? get createdByName;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of PhotoComparisonModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PhotoComparisonModelImplCopyWith<_$PhotoComparisonModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

PhotoUploadItem _$PhotoUploadItemFromJson(Map<String, dynamic> json) {
  return _PhotoUploadItem.fromJson(json);
}

/// @nodoc
mixin _$PhotoUploadItem {
  /// Local identifier for this upload
  String get localId => throw _privateConstructorUsedError;

  /// Local file path
  @JsonKey(name: 'file_path')
  String get filePath => throw _privateConstructorUsedError;

  /// File name
  @JsonKey(name: 'file_name')
  String get fileName => throw _privateConstructorUsedError;

  /// File size in bytes
  @JsonKey(name: 'file_size')
  int? get fileSize => throw _privateConstructorUsedError;

  /// Upload progress (0.0 to 1.0)
  double get progress => throw _privateConstructorUsedError;

  /// Current upload status
  PhotoUploadStatus get status => throw _privateConstructorUsedError;

  /// Error message if failed
  @JsonKey(name: 'error_message')
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Server photo ID after successful upload
  @JsonKey(name: 'server_id')
  int? get serverId => throw _privateConstructorUsedError;

  /// Server URL after successful upload
  @JsonKey(name: 'server_url')
  String? get serverUrl => throw _privateConstructorUsedError;

  /// Photo type
  PhotoType get type => throw _privateConstructorUsedError;

  /// Associated entity type
  @JsonKey(name: 'entity_type')
  String? get entityType => throw _privateConstructorUsedError;

  /// Associated entity ID
  @JsonKey(name: 'entity_id')
  int? get entityId => throw _privateConstructorUsedError;

  /// Caption/description
  String? get caption => throw _privateConstructorUsedError;

  /// Serializes this PhotoUploadItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PhotoUploadItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PhotoUploadItemCopyWith<PhotoUploadItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PhotoUploadItemCopyWith<$Res> {
  factory $PhotoUploadItemCopyWith(
          PhotoUploadItem value, $Res Function(PhotoUploadItem) then) =
      _$PhotoUploadItemCopyWithImpl<$Res, PhotoUploadItem>;
  @useResult
  $Res call(
      {String localId,
      @JsonKey(name: 'file_path') String filePath,
      @JsonKey(name: 'file_name') String fileName,
      @JsonKey(name: 'file_size') int? fileSize,
      double progress,
      PhotoUploadStatus status,
      @JsonKey(name: 'error_message') String? errorMessage,
      @JsonKey(name: 'server_id') int? serverId,
      @JsonKey(name: 'server_url') String? serverUrl,
      PhotoType type,
      @JsonKey(name: 'entity_type') String? entityType,
      @JsonKey(name: 'entity_id') int? entityId,
      String? caption});
}

/// @nodoc
class _$PhotoUploadItemCopyWithImpl<$Res, $Val extends PhotoUploadItem>
    implements $PhotoUploadItemCopyWith<$Res> {
  _$PhotoUploadItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PhotoUploadItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? localId = null,
    Object? filePath = null,
    Object? fileName = null,
    Object? fileSize = freezed,
    Object? progress = null,
    Object? status = null,
    Object? errorMessage = freezed,
    Object? serverId = freezed,
    Object? serverUrl = freezed,
    Object? type = null,
    Object? entityType = freezed,
    Object? entityId = freezed,
    Object? caption = freezed,
  }) {
    return _then(_value.copyWith(
      localId: null == localId
          ? _value.localId
          : localId // ignore: cast_nullable_to_non_nullable
              as String,
      filePath: null == filePath
          ? _value.filePath
          : filePath // ignore: cast_nullable_to_non_nullable
              as String,
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      fileSize: freezed == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int?,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PhotoUploadStatus,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      serverId: freezed == serverId
          ? _value.serverId
          : serverId // ignore: cast_nullable_to_non_nullable
              as int?,
      serverUrl: freezed == serverUrl
          ? _value.serverUrl
          : serverUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PhotoType,
      entityType: freezed == entityType
          ? _value.entityType
          : entityType // ignore: cast_nullable_to_non_nullable
              as String?,
      entityId: freezed == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as int?,
      caption: freezed == caption
          ? _value.caption
          : caption // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PhotoUploadItemImplCopyWith<$Res>
    implements $PhotoUploadItemCopyWith<$Res> {
  factory _$$PhotoUploadItemImplCopyWith(_$PhotoUploadItemImpl value,
          $Res Function(_$PhotoUploadItemImpl) then) =
      __$$PhotoUploadItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String localId,
      @JsonKey(name: 'file_path') String filePath,
      @JsonKey(name: 'file_name') String fileName,
      @JsonKey(name: 'file_size') int? fileSize,
      double progress,
      PhotoUploadStatus status,
      @JsonKey(name: 'error_message') String? errorMessage,
      @JsonKey(name: 'server_id') int? serverId,
      @JsonKey(name: 'server_url') String? serverUrl,
      PhotoType type,
      @JsonKey(name: 'entity_type') String? entityType,
      @JsonKey(name: 'entity_id') int? entityId,
      String? caption});
}

/// @nodoc
class __$$PhotoUploadItemImplCopyWithImpl<$Res>
    extends _$PhotoUploadItemCopyWithImpl<$Res, _$PhotoUploadItemImpl>
    implements _$$PhotoUploadItemImplCopyWith<$Res> {
  __$$PhotoUploadItemImplCopyWithImpl(
      _$PhotoUploadItemImpl _value, $Res Function(_$PhotoUploadItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of PhotoUploadItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? localId = null,
    Object? filePath = null,
    Object? fileName = null,
    Object? fileSize = freezed,
    Object? progress = null,
    Object? status = null,
    Object? errorMessage = freezed,
    Object? serverId = freezed,
    Object? serverUrl = freezed,
    Object? type = null,
    Object? entityType = freezed,
    Object? entityId = freezed,
    Object? caption = freezed,
  }) {
    return _then(_$PhotoUploadItemImpl(
      localId: null == localId
          ? _value.localId
          : localId // ignore: cast_nullable_to_non_nullable
              as String,
      filePath: null == filePath
          ? _value.filePath
          : filePath // ignore: cast_nullable_to_non_nullable
              as String,
      fileName: null == fileName
          ? _value.fileName
          : fileName // ignore: cast_nullable_to_non_nullable
              as String,
      fileSize: freezed == fileSize
          ? _value.fileSize
          : fileSize // ignore: cast_nullable_to_non_nullable
              as int?,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PhotoUploadStatus,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      serverId: freezed == serverId
          ? _value.serverId
          : serverId // ignore: cast_nullable_to_non_nullable
              as int?,
      serverUrl: freezed == serverUrl
          ? _value.serverUrl
          : serverUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PhotoType,
      entityType: freezed == entityType
          ? _value.entityType
          : entityType // ignore: cast_nullable_to_non_nullable
              as String?,
      entityId: freezed == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as int?,
      caption: freezed == caption
          ? _value.caption
          : caption // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PhotoUploadItemImpl extends _PhotoUploadItem {
  const _$PhotoUploadItemImpl(
      {required this.localId,
      @JsonKey(name: 'file_path') required this.filePath,
      @JsonKey(name: 'file_name') required this.fileName,
      @JsonKey(name: 'file_size') this.fileSize,
      this.progress = 0.0,
      this.status = PhotoUploadStatus.pending,
      @JsonKey(name: 'error_message') this.errorMessage,
      @JsonKey(name: 'server_id') this.serverId,
      @JsonKey(name: 'server_url') this.serverUrl,
      this.type = PhotoType.general,
      @JsonKey(name: 'entity_type') this.entityType,
      @JsonKey(name: 'entity_id') this.entityId,
      this.caption})
      : super._();

  factory _$PhotoUploadItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$PhotoUploadItemImplFromJson(json);

  /// Local identifier for this upload
  @override
  final String localId;

  /// Local file path
  @override
  @JsonKey(name: 'file_path')
  final String filePath;

  /// File name
  @override
  @JsonKey(name: 'file_name')
  final String fileName;

  /// File size in bytes
  @override
  @JsonKey(name: 'file_size')
  final int? fileSize;

  /// Upload progress (0.0 to 1.0)
  @override
  @JsonKey()
  final double progress;

  /// Current upload status
  @override
  @JsonKey()
  final PhotoUploadStatus status;

  /// Error message if failed
  @override
  @JsonKey(name: 'error_message')
  final String? errorMessage;

  /// Server photo ID after successful upload
  @override
  @JsonKey(name: 'server_id')
  final int? serverId;

  /// Server URL after successful upload
  @override
  @JsonKey(name: 'server_url')
  final String? serverUrl;

  /// Photo type
  @override
  @JsonKey()
  final PhotoType type;

  /// Associated entity type
  @override
  @JsonKey(name: 'entity_type')
  final String? entityType;

  /// Associated entity ID
  @override
  @JsonKey(name: 'entity_id')
  final int? entityId;

  /// Caption/description
  @override
  final String? caption;

  @override
  String toString() {
    return 'PhotoUploadItem(localId: $localId, filePath: $filePath, fileName: $fileName, fileSize: $fileSize, progress: $progress, status: $status, errorMessage: $errorMessage, serverId: $serverId, serverUrl: $serverUrl, type: $type, entityType: $entityType, entityId: $entityId, caption: $caption)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PhotoUploadItemImpl &&
            (identical(other.localId, localId) || other.localId == localId) &&
            (identical(other.filePath, filePath) ||
                other.filePath == filePath) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.fileSize, fileSize) ||
                other.fileSize == fileSize) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.serverId, serverId) ||
                other.serverId == serverId) &&
            (identical(other.serverUrl, serverUrl) ||
                other.serverUrl == serverUrl) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.caption, caption) || other.caption == caption));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      localId,
      filePath,
      fileName,
      fileSize,
      progress,
      status,
      errorMessage,
      serverId,
      serverUrl,
      type,
      entityType,
      entityId,
      caption);

  /// Create a copy of PhotoUploadItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PhotoUploadItemImplCopyWith<_$PhotoUploadItemImpl> get copyWith =>
      __$$PhotoUploadItemImplCopyWithImpl<_$PhotoUploadItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PhotoUploadItemImplToJson(
      this,
    );
  }
}

abstract class _PhotoUploadItem extends PhotoUploadItem {
  const factory _PhotoUploadItem(
      {required final String localId,
      @JsonKey(name: 'file_path') required final String filePath,
      @JsonKey(name: 'file_name') required final String fileName,
      @JsonKey(name: 'file_size') final int? fileSize,
      final double progress,
      final PhotoUploadStatus status,
      @JsonKey(name: 'error_message') final String? errorMessage,
      @JsonKey(name: 'server_id') final int? serverId,
      @JsonKey(name: 'server_url') final String? serverUrl,
      final PhotoType type,
      @JsonKey(name: 'entity_type') final String? entityType,
      @JsonKey(name: 'entity_id') final int? entityId,
      final String? caption}) = _$PhotoUploadItemImpl;
  const _PhotoUploadItem._() : super._();

  factory _PhotoUploadItem.fromJson(Map<String, dynamic> json) =
      _$PhotoUploadItemImpl.fromJson;

  /// Local identifier for this upload
  @override
  String get localId;

  /// Local file path
  @override
  @JsonKey(name: 'file_path')
  String get filePath;

  /// File name
  @override
  @JsonKey(name: 'file_name')
  String get fileName;

  /// File size in bytes
  @override
  @JsonKey(name: 'file_size')
  int? get fileSize;

  /// Upload progress (0.0 to 1.0)
  @override
  double get progress;

  /// Current upload status
  @override
  PhotoUploadStatus get status;

  /// Error message if failed
  @override
  @JsonKey(name: 'error_message')
  String? get errorMessage;

  /// Server photo ID after successful upload
  @override
  @JsonKey(name: 'server_id')
  int? get serverId;

  /// Server URL after successful upload
  @override
  @JsonKey(name: 'server_url')
  String? get serverUrl;

  /// Photo type
  @override
  PhotoType get type;

  /// Associated entity type
  @override
  @JsonKey(name: 'entity_type')
  String? get entityType;

  /// Associated entity ID
  @override
  @JsonKey(name: 'entity_id')
  int? get entityId;

  /// Caption/description
  @override
  String? get caption;

  /// Create a copy of PhotoUploadItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PhotoUploadItemImplCopyWith<_$PhotoUploadItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PhotoUploadResult _$PhotoUploadResultFromJson(Map<String, dynamic> json) {
  return _PhotoUploadResult.fromJson(json);
}

/// @nodoc
mixin _$PhotoUploadResult {
  /// Total photos in batch
  int get total => throw _privateConstructorUsedError;

  /// Successfully uploaded count
  int get uploaded => throw _privateConstructorUsedError;

  /// Failed upload count
  int get failed => throw _privateConstructorUsedError;

  /// List of uploaded photo IDs
  @JsonKey(name: 'photo_ids')
  List<int> get photoIds => throw _privateConstructorUsedError;

  /// List of error messages
  List<String> get errors => throw _privateConstructorUsedError;

  /// When upload completed
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt => throw _privateConstructorUsedError;

  /// Serializes this PhotoUploadResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PhotoUploadResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PhotoUploadResultCopyWith<PhotoUploadResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PhotoUploadResultCopyWith<$Res> {
  factory $PhotoUploadResultCopyWith(
          PhotoUploadResult value, $Res Function(PhotoUploadResult) then) =
      _$PhotoUploadResultCopyWithImpl<$Res, PhotoUploadResult>;
  @useResult
  $Res call(
      {int total,
      int uploaded,
      int failed,
      @JsonKey(name: 'photo_ids') List<int> photoIds,
      List<String> errors,
      @JsonKey(name: 'completed_at') DateTime? completedAt});
}

/// @nodoc
class _$PhotoUploadResultCopyWithImpl<$Res, $Val extends PhotoUploadResult>
    implements $PhotoUploadResultCopyWith<$Res> {
  _$PhotoUploadResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PhotoUploadResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? uploaded = null,
    Object? failed = null,
    Object? photoIds = null,
    Object? errors = null,
    Object? completedAt = freezed,
  }) {
    return _then(_value.copyWith(
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      uploaded: null == uploaded
          ? _value.uploaded
          : uploaded // ignore: cast_nullable_to_non_nullable
              as int,
      failed: null == failed
          ? _value.failed
          : failed // ignore: cast_nullable_to_non_nullable
              as int,
      photoIds: null == photoIds
          ? _value.photoIds
          : photoIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
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
abstract class _$$PhotoUploadResultImplCopyWith<$Res>
    implements $PhotoUploadResultCopyWith<$Res> {
  factory _$$PhotoUploadResultImplCopyWith(_$PhotoUploadResultImpl value,
          $Res Function(_$PhotoUploadResultImpl) then) =
      __$$PhotoUploadResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int total,
      int uploaded,
      int failed,
      @JsonKey(name: 'photo_ids') List<int> photoIds,
      List<String> errors,
      @JsonKey(name: 'completed_at') DateTime? completedAt});
}

/// @nodoc
class __$$PhotoUploadResultImplCopyWithImpl<$Res>
    extends _$PhotoUploadResultCopyWithImpl<$Res, _$PhotoUploadResultImpl>
    implements _$$PhotoUploadResultImplCopyWith<$Res> {
  __$$PhotoUploadResultImplCopyWithImpl(_$PhotoUploadResultImpl _value,
      $Res Function(_$PhotoUploadResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of PhotoUploadResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? uploaded = null,
    Object? failed = null,
    Object? photoIds = null,
    Object? errors = null,
    Object? completedAt = freezed,
  }) {
    return _then(_$PhotoUploadResultImpl(
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      uploaded: null == uploaded
          ? _value.uploaded
          : uploaded // ignore: cast_nullable_to_non_nullable
              as int,
      failed: null == failed
          ? _value.failed
          : failed // ignore: cast_nullable_to_non_nullable
              as int,
      photoIds: null == photoIds
          ? _value._photoIds
          : photoIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
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
class _$PhotoUploadResultImpl extends _PhotoUploadResult {
  const _$PhotoUploadResultImpl(
      {this.total = 0,
      this.uploaded = 0,
      this.failed = 0,
      @JsonKey(name: 'photo_ids') final List<int> photoIds = const [],
      final List<String> errors = const [],
      @JsonKey(name: 'completed_at') this.completedAt})
      : _photoIds = photoIds,
        _errors = errors,
        super._();

  factory _$PhotoUploadResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$PhotoUploadResultImplFromJson(json);

  /// Total photos in batch
  @override
  @JsonKey()
  final int total;

  /// Successfully uploaded count
  @override
  @JsonKey()
  final int uploaded;

  /// Failed upload count
  @override
  @JsonKey()
  final int failed;

  /// List of uploaded photo IDs
  final List<int> _photoIds;

  /// List of uploaded photo IDs
  @override
  @JsonKey(name: 'photo_ids')
  List<int> get photoIds {
    if (_photoIds is EqualUnmodifiableListView) return _photoIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_photoIds);
  }

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

  /// When upload completed
  @override
  @JsonKey(name: 'completed_at')
  final DateTime? completedAt;

  @override
  String toString() {
    return 'PhotoUploadResult(total: $total, uploaded: $uploaded, failed: $failed, photoIds: $photoIds, errors: $errors, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PhotoUploadResultImpl &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.uploaded, uploaded) ||
                other.uploaded == uploaded) &&
            (identical(other.failed, failed) || other.failed == failed) &&
            const DeepCollectionEquality().equals(other._photoIds, _photoIds) &&
            const DeepCollectionEquality().equals(other._errors, _errors) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      total,
      uploaded,
      failed,
      const DeepCollectionEquality().hash(_photoIds),
      const DeepCollectionEquality().hash(_errors),
      completedAt);

  /// Create a copy of PhotoUploadResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PhotoUploadResultImplCopyWith<_$PhotoUploadResultImpl> get copyWith =>
      __$$PhotoUploadResultImplCopyWithImpl<_$PhotoUploadResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PhotoUploadResultImplToJson(
      this,
    );
  }
}

abstract class _PhotoUploadResult extends PhotoUploadResult {
  const factory _PhotoUploadResult(
          {final int total,
          final int uploaded,
          final int failed,
          @JsonKey(name: 'photo_ids') final List<int> photoIds,
          final List<String> errors,
          @JsonKey(name: 'completed_at') final DateTime? completedAt}) =
      _$PhotoUploadResultImpl;
  const _PhotoUploadResult._() : super._();

  factory _PhotoUploadResult.fromJson(Map<String, dynamic> json) =
      _$PhotoUploadResultImpl.fromJson;

  /// Total photos in batch
  @override
  int get total;

  /// Successfully uploaded count
  @override
  int get uploaded;

  /// Failed upload count
  @override
  int get failed;

  /// List of uploaded photo IDs
  @override
  @JsonKey(name: 'photo_ids')
  List<int> get photoIds;

  /// List of error messages
  @override
  List<String> get errors;

  /// When upload completed
  @override
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt;

  /// Create a copy of PhotoUploadResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PhotoUploadResultImplCopyWith<_$PhotoUploadResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
