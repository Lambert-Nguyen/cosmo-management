// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checklist_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChecklistItemModel _$ChecklistItemModelFromJson(Map<String, dynamic> json) {
  return _ChecklistItemModel.fromJson(json);
}

/// @nodoc
mixin _$ChecklistItemModel {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'item_type')
  ChecklistItemType get itemType => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_required')
  bool get isRequired => throw _privateConstructorUsedError;
  @JsonKey(name: 'order')
  int get order => throw _privateConstructorUsedError;
  @JsonKey(name: 'room_type')
  String? get roomType => throw _privateConstructorUsedError;

  /// Serializes this ChecklistItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChecklistItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChecklistItemModelCopyWith<ChecklistItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChecklistItemModelCopyWith<$Res> {
  factory $ChecklistItemModelCopyWith(
          ChecklistItemModel value, $Res Function(ChecklistItemModel) then) =
      _$ChecklistItemModelCopyWithImpl<$Res, ChecklistItemModel>;
  @useResult
  $Res call(
      {int id,
      String title,
      String? description,
      @JsonKey(name: 'item_type') ChecklistItemType itemType,
      @JsonKey(name: 'is_required') bool isRequired,
      @JsonKey(name: 'order') int order,
      @JsonKey(name: 'room_type') String? roomType});
}

/// @nodoc
class _$ChecklistItemModelCopyWithImpl<$Res, $Val extends ChecklistItemModel>
    implements $ChecklistItemModelCopyWith<$Res> {
  _$ChecklistItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChecklistItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? itemType = null,
    Object? isRequired = null,
    Object? order = null,
    Object? roomType = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      itemType: null == itemType
          ? _value.itemType
          : itemType // ignore: cast_nullable_to_non_nullable
              as ChecklistItemType,
      isRequired: null == isRequired
          ? _value.isRequired
          : isRequired // ignore: cast_nullable_to_non_nullable
              as bool,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      roomType: freezed == roomType
          ? _value.roomType
          : roomType // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChecklistItemModelImplCopyWith<$Res>
    implements $ChecklistItemModelCopyWith<$Res> {
  factory _$$ChecklistItemModelImplCopyWith(_$ChecklistItemModelImpl value,
          $Res Function(_$ChecklistItemModelImpl) then) =
      __$$ChecklistItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      String? description,
      @JsonKey(name: 'item_type') ChecklistItemType itemType,
      @JsonKey(name: 'is_required') bool isRequired,
      @JsonKey(name: 'order') int order,
      @JsonKey(name: 'room_type') String? roomType});
}

/// @nodoc
class __$$ChecklistItemModelImplCopyWithImpl<$Res>
    extends _$ChecklistItemModelCopyWithImpl<$Res, _$ChecklistItemModelImpl>
    implements _$$ChecklistItemModelImplCopyWith<$Res> {
  __$$ChecklistItemModelImplCopyWithImpl(_$ChecklistItemModelImpl _value,
      $Res Function(_$ChecklistItemModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChecklistItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? itemType = null,
    Object? isRequired = null,
    Object? order = null,
    Object? roomType = freezed,
  }) {
    return _then(_$ChecklistItemModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      itemType: null == itemType
          ? _value.itemType
          : itemType // ignore: cast_nullable_to_non_nullable
              as ChecklistItemType,
      isRequired: null == isRequired
          ? _value.isRequired
          : isRequired // ignore: cast_nullable_to_non_nullable
              as bool,
      order: null == order
          ? _value.order
          : order // ignore: cast_nullable_to_non_nullable
              as int,
      roomType: freezed == roomType
          ? _value.roomType
          : roomType // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChecklistItemModelImpl extends _ChecklistItemModel {
  const _$ChecklistItemModelImpl(
      {required this.id,
      required this.title,
      this.description,
      @JsonKey(name: 'item_type') required this.itemType,
      @JsonKey(name: 'is_required') this.isRequired = true,
      @JsonKey(name: 'order') this.order = 0,
      @JsonKey(name: 'room_type') this.roomType})
      : super._();

  factory _$ChecklistItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChecklistItemModelImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String? description;
  @override
  @JsonKey(name: 'item_type')
  final ChecklistItemType itemType;
  @override
  @JsonKey(name: 'is_required')
  final bool isRequired;
  @override
  @JsonKey(name: 'order')
  final int order;
  @override
  @JsonKey(name: 'room_type')
  final String? roomType;

  @override
  String toString() {
    return 'ChecklistItemModel(id: $id, title: $title, description: $description, itemType: $itemType, isRequired: $isRequired, order: $order, roomType: $roomType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChecklistItemModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.itemType, itemType) ||
                other.itemType == itemType) &&
            (identical(other.isRequired, isRequired) ||
                other.isRequired == isRequired) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.roomType, roomType) ||
                other.roomType == roomType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, description, itemType,
      isRequired, order, roomType);

  /// Create a copy of ChecklistItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChecklistItemModelImplCopyWith<_$ChecklistItemModelImpl> get copyWith =>
      __$$ChecklistItemModelImplCopyWithImpl<_$ChecklistItemModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChecklistItemModelImplToJson(
      this,
    );
  }
}

abstract class _ChecklistItemModel extends ChecklistItemModel {
  const factory _ChecklistItemModel(
          {required final int id,
          required final String title,
          final String? description,
          @JsonKey(name: 'item_type') required final ChecklistItemType itemType,
          @JsonKey(name: 'is_required') final bool isRequired,
          @JsonKey(name: 'order') final int order,
          @JsonKey(name: 'room_type') final String? roomType}) =
      _$ChecklistItemModelImpl;
  const _ChecklistItemModel._() : super._();

  factory _ChecklistItemModel.fromJson(Map<String, dynamic> json) =
      _$ChecklistItemModelImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String? get description;
  @override
  @JsonKey(name: 'item_type')
  ChecklistItemType get itemType;
  @override
  @JsonKey(name: 'is_required')
  bool get isRequired;
  @override
  @JsonKey(name: 'order')
  int get order;
  @override
  @JsonKey(name: 'room_type')
  String? get roomType;

  /// Create a copy of ChecklistItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChecklistItemModelImplCopyWith<_$ChecklistItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChecklistResponseModel _$ChecklistResponseModelFromJson(
    Map<String, dynamic> json) {
  return _ChecklistResponseModel.fromJson(json);
}

/// @nodoc
mixin _$ChecklistResponseModel {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'item')
  int get itemId => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_completed')
  bool get isCompleted => throw _privateConstructorUsedError;
  @JsonKey(name: 'text_response')
  String? get textResponse => throw _privateConstructorUsedError;
  @JsonKey(name: 'number_response')
  double? get numberResponse => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_by')
  int? get completedBy => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this ChecklistResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChecklistResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChecklistResponseModelCopyWith<ChecklistResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChecklistResponseModelCopyWith<$Res> {
  factory $ChecklistResponseModelCopyWith(ChecklistResponseModel value,
          $Res Function(ChecklistResponseModel) then) =
      _$ChecklistResponseModelCopyWithImpl<$Res, ChecklistResponseModel>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'item') int itemId,
      @JsonKey(name: 'is_completed') bool isCompleted,
      @JsonKey(name: 'text_response') String? textResponse,
      @JsonKey(name: 'number_response') double? numberResponse,
      @JsonKey(name: 'completed_at') DateTime? completedAt,
      @JsonKey(name: 'completed_by') int? completedBy,
      String? notes});
}

/// @nodoc
class _$ChecklistResponseModelCopyWithImpl<$Res,
        $Val extends ChecklistResponseModel>
    implements $ChecklistResponseModelCopyWith<$Res> {
  _$ChecklistResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChecklistResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? itemId = null,
    Object? isCompleted = null,
    Object? textResponse = freezed,
    Object? numberResponse = freezed,
    Object? completedAt = freezed,
    Object? completedBy = freezed,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as int,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      textResponse: freezed == textResponse
          ? _value.textResponse
          : textResponse // ignore: cast_nullable_to_non_nullable
              as String?,
      numberResponse: freezed == numberResponse
          ? _value.numberResponse
          : numberResponse // ignore: cast_nullable_to_non_nullable
              as double?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedBy: freezed == completedBy
          ? _value.completedBy
          : completedBy // ignore: cast_nullable_to_non_nullable
              as int?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChecklistResponseModelImplCopyWith<$Res>
    implements $ChecklistResponseModelCopyWith<$Res> {
  factory _$$ChecklistResponseModelImplCopyWith(
          _$ChecklistResponseModelImpl value,
          $Res Function(_$ChecklistResponseModelImpl) then) =
      __$$ChecklistResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'item') int itemId,
      @JsonKey(name: 'is_completed') bool isCompleted,
      @JsonKey(name: 'text_response') String? textResponse,
      @JsonKey(name: 'number_response') double? numberResponse,
      @JsonKey(name: 'completed_at') DateTime? completedAt,
      @JsonKey(name: 'completed_by') int? completedBy,
      String? notes});
}

/// @nodoc
class __$$ChecklistResponseModelImplCopyWithImpl<$Res>
    extends _$ChecklistResponseModelCopyWithImpl<$Res,
        _$ChecklistResponseModelImpl>
    implements _$$ChecklistResponseModelImplCopyWith<$Res> {
  __$$ChecklistResponseModelImplCopyWithImpl(
      _$ChecklistResponseModelImpl _value,
      $Res Function(_$ChecklistResponseModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChecklistResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? itemId = null,
    Object? isCompleted = null,
    Object? textResponse = freezed,
    Object? numberResponse = freezed,
    Object? completedAt = freezed,
    Object? completedBy = freezed,
    Object? notes = freezed,
  }) {
    return _then(_$ChecklistResponseModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as int,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      textResponse: freezed == textResponse
          ? _value.textResponse
          : textResponse // ignore: cast_nullable_to_non_nullable
              as String?,
      numberResponse: freezed == numberResponse
          ? _value.numberResponse
          : numberResponse // ignore: cast_nullable_to_non_nullable
              as double?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedBy: freezed == completedBy
          ? _value.completedBy
          : completedBy // ignore: cast_nullable_to_non_nullable
              as int?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChecklistResponseModelImpl extends _ChecklistResponseModel {
  const _$ChecklistResponseModelImpl(
      {required this.id,
      @JsonKey(name: 'item') required this.itemId,
      @JsonKey(name: 'is_completed') this.isCompleted = false,
      @JsonKey(name: 'text_response') this.textResponse,
      @JsonKey(name: 'number_response') this.numberResponse,
      @JsonKey(name: 'completed_at') this.completedAt,
      @JsonKey(name: 'completed_by') this.completedBy,
      this.notes})
      : super._();

  factory _$ChecklistResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChecklistResponseModelImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'item')
  final int itemId;
  @override
  @JsonKey(name: 'is_completed')
  final bool isCompleted;
  @override
  @JsonKey(name: 'text_response')
  final String? textResponse;
  @override
  @JsonKey(name: 'number_response')
  final double? numberResponse;
  @override
  @JsonKey(name: 'completed_at')
  final DateTime? completedAt;
  @override
  @JsonKey(name: 'completed_by')
  final int? completedBy;
  @override
  final String? notes;

  @override
  String toString() {
    return 'ChecklistResponseModel(id: $id, itemId: $itemId, isCompleted: $isCompleted, textResponse: $textResponse, numberResponse: $numberResponse, completedAt: $completedAt, completedBy: $completedBy, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChecklistResponseModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.textResponse, textResponse) ||
                other.textResponse == textResponse) &&
            (identical(other.numberResponse, numberResponse) ||
                other.numberResponse == numberResponse) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.completedBy, completedBy) ||
                other.completedBy == completedBy) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, itemId, isCompleted,
      textResponse, numberResponse, completedAt, completedBy, notes);

  /// Create a copy of ChecklistResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChecklistResponseModelImplCopyWith<_$ChecklistResponseModelImpl>
      get copyWith => __$$ChecklistResponseModelImplCopyWithImpl<
          _$ChecklistResponseModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChecklistResponseModelImplToJson(
      this,
    );
  }
}

abstract class _ChecklistResponseModel extends ChecklistResponseModel {
  const factory _ChecklistResponseModel(
      {required final int id,
      @JsonKey(name: 'item') required final int itemId,
      @JsonKey(name: 'is_completed') final bool isCompleted,
      @JsonKey(name: 'text_response') final String? textResponse,
      @JsonKey(name: 'number_response') final double? numberResponse,
      @JsonKey(name: 'completed_at') final DateTime? completedAt,
      @JsonKey(name: 'completed_by') final int? completedBy,
      final String? notes}) = _$ChecklistResponseModelImpl;
  const _ChecklistResponseModel._() : super._();

  factory _ChecklistResponseModel.fromJson(Map<String, dynamic> json) =
      _$ChecklistResponseModelImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'item')
  int get itemId;
  @override
  @JsonKey(name: 'is_completed')
  bool get isCompleted;
  @override
  @JsonKey(name: 'text_response')
  String? get textResponse;
  @override
  @JsonKey(name: 'number_response')
  double? get numberResponse;
  @override
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt;
  @override
  @JsonKey(name: 'completed_by')
  int? get completedBy;
  @override
  String? get notes;

  /// Create a copy of ChecklistResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChecklistResponseModelImplCopyWith<_$ChecklistResponseModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ChecklistPhotoModel _$ChecklistPhotoModelFromJson(Map<String, dynamic> json) {
  return _ChecklistPhotoModel.fromJson(json);
}

/// @nodoc
mixin _$ChecklistPhotoModel {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'checklist_response')
  int? get checklistResponseId => throw _privateConstructorUsedError;
  String get image => throw _privateConstructorUsedError;
  @JsonKey(name: 'photo_type')
  String get photoType => throw _privateConstructorUsedError;
  @JsonKey(name: 'uploaded_at')
  DateTime? get uploadedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'uploaded_by')
  int? get uploadedBy => throw _privateConstructorUsedError;

  /// Serializes this ChecklistPhotoModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChecklistPhotoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChecklistPhotoModelCopyWith<ChecklistPhotoModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChecklistPhotoModelCopyWith<$Res> {
  factory $ChecklistPhotoModelCopyWith(
          ChecklistPhotoModel value, $Res Function(ChecklistPhotoModel) then) =
      _$ChecklistPhotoModelCopyWithImpl<$Res, ChecklistPhotoModel>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'checklist_response') int? checklistResponseId,
      String image,
      @JsonKey(name: 'photo_type') String photoType,
      @JsonKey(name: 'uploaded_at') DateTime? uploadedAt,
      @JsonKey(name: 'uploaded_by') int? uploadedBy});
}

/// @nodoc
class _$ChecklistPhotoModelCopyWithImpl<$Res, $Val extends ChecklistPhotoModel>
    implements $ChecklistPhotoModelCopyWith<$Res> {
  _$ChecklistPhotoModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChecklistPhotoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? checklistResponseId = freezed,
    Object? image = null,
    Object? photoType = null,
    Object? uploadedAt = freezed,
    Object? uploadedBy = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      checklistResponseId: freezed == checklistResponseId
          ? _value.checklistResponseId
          : checklistResponseId // ignore: cast_nullable_to_non_nullable
              as int?,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      photoType: null == photoType
          ? _value.photoType
          : photoType // ignore: cast_nullable_to_non_nullable
              as String,
      uploadedAt: freezed == uploadedAt
          ? _value.uploadedAt
          : uploadedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      uploadedBy: freezed == uploadedBy
          ? _value.uploadedBy
          : uploadedBy // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChecklistPhotoModelImplCopyWith<$Res>
    implements $ChecklistPhotoModelCopyWith<$Res> {
  factory _$$ChecklistPhotoModelImplCopyWith(_$ChecklistPhotoModelImpl value,
          $Res Function(_$ChecklistPhotoModelImpl) then) =
      __$$ChecklistPhotoModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'checklist_response') int? checklistResponseId,
      String image,
      @JsonKey(name: 'photo_type') String photoType,
      @JsonKey(name: 'uploaded_at') DateTime? uploadedAt,
      @JsonKey(name: 'uploaded_by') int? uploadedBy});
}

/// @nodoc
class __$$ChecklistPhotoModelImplCopyWithImpl<$Res>
    extends _$ChecklistPhotoModelCopyWithImpl<$Res, _$ChecklistPhotoModelImpl>
    implements _$$ChecklistPhotoModelImplCopyWith<$Res> {
  __$$ChecklistPhotoModelImplCopyWithImpl(_$ChecklistPhotoModelImpl _value,
      $Res Function(_$ChecklistPhotoModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChecklistPhotoModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? checklistResponseId = freezed,
    Object? image = null,
    Object? photoType = null,
    Object? uploadedAt = freezed,
    Object? uploadedBy = freezed,
  }) {
    return _then(_$ChecklistPhotoModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      checklistResponseId: freezed == checklistResponseId
          ? _value.checklistResponseId
          : checklistResponseId // ignore: cast_nullable_to_non_nullable
              as int?,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      photoType: null == photoType
          ? _value.photoType
          : photoType // ignore: cast_nullable_to_non_nullable
              as String,
      uploadedAt: freezed == uploadedAt
          ? _value.uploadedAt
          : uploadedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      uploadedBy: freezed == uploadedBy
          ? _value.uploadedBy
          : uploadedBy // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChecklistPhotoModelImpl implements _ChecklistPhotoModel {
  const _$ChecklistPhotoModelImpl(
      {required this.id,
      @JsonKey(name: 'checklist_response') this.checklistResponseId,
      required this.image,
      @JsonKey(name: 'photo_type') this.photoType = 'checklist',
      @JsonKey(name: 'uploaded_at') this.uploadedAt,
      @JsonKey(name: 'uploaded_by') this.uploadedBy});

  factory _$ChecklistPhotoModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChecklistPhotoModelImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'checklist_response')
  final int? checklistResponseId;
  @override
  final String image;
  @override
  @JsonKey(name: 'photo_type')
  final String photoType;
  @override
  @JsonKey(name: 'uploaded_at')
  final DateTime? uploadedAt;
  @override
  @JsonKey(name: 'uploaded_by')
  final int? uploadedBy;

  @override
  String toString() {
    return 'ChecklistPhotoModel(id: $id, checklistResponseId: $checklistResponseId, image: $image, photoType: $photoType, uploadedAt: $uploadedAt, uploadedBy: $uploadedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChecklistPhotoModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.checklistResponseId, checklistResponseId) ||
                other.checklistResponseId == checklistResponseId) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.photoType, photoType) ||
                other.photoType == photoType) &&
            (identical(other.uploadedAt, uploadedAt) ||
                other.uploadedAt == uploadedAt) &&
            (identical(other.uploadedBy, uploadedBy) ||
                other.uploadedBy == uploadedBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, checklistResponseId, image,
      photoType, uploadedAt, uploadedBy);

  /// Create a copy of ChecklistPhotoModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChecklistPhotoModelImplCopyWith<_$ChecklistPhotoModelImpl> get copyWith =>
      __$$ChecklistPhotoModelImplCopyWithImpl<_$ChecklistPhotoModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChecklistPhotoModelImplToJson(
      this,
    );
  }
}

abstract class _ChecklistPhotoModel implements ChecklistPhotoModel {
  const factory _ChecklistPhotoModel(
          {required final int id,
          @JsonKey(name: 'checklist_response') final int? checklistResponseId,
          required final String image,
          @JsonKey(name: 'photo_type') final String photoType,
          @JsonKey(name: 'uploaded_at') final DateTime? uploadedAt,
          @JsonKey(name: 'uploaded_by') final int? uploadedBy}) =
      _$ChecklistPhotoModelImpl;

  factory _ChecklistPhotoModel.fromJson(Map<String, dynamic> json) =
      _$ChecklistPhotoModelImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'checklist_response')
  int? get checklistResponseId;
  @override
  String get image;
  @override
  @JsonKey(name: 'photo_type')
  String get photoType;
  @override
  @JsonKey(name: 'uploaded_at')
  DateTime? get uploadedAt;
  @override
  @JsonKey(name: 'uploaded_by')
  int? get uploadedBy;

  /// Create a copy of ChecklistPhotoModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChecklistPhotoModelImplCopyWith<_$ChecklistPhotoModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TaskChecklistModel _$TaskChecklistModelFromJson(Map<String, dynamic> json) {
  return _TaskChecklistModel.fromJson(json);
}

/// @nodoc
mixin _$TaskChecklistModel {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'task')
  int get taskId => throw _privateConstructorUsedError;
  @JsonKey(name: 'template')
  int? get templateId => throw _privateConstructorUsedError;
  @JsonKey(name: 'template_name')
  String? get templateName => throw _privateConstructorUsedError;
  List<ChecklistItemModel> get items => throw _privateConstructorUsedError;
  List<ChecklistResponseModel> get responses =>
      throw _privateConstructorUsedError;
  List<ChecklistPhotoModel> get photos => throw _privateConstructorUsedError;
  @JsonKey(name: 'started_at')
  DateTime? get startedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_by')
  int? get completedBy => throw _privateConstructorUsedError;

  /// Serializes this TaskChecklistModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskChecklistModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskChecklistModelCopyWith<TaskChecklistModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskChecklistModelCopyWith<$Res> {
  factory $TaskChecklistModelCopyWith(
          TaskChecklistModel value, $Res Function(TaskChecklistModel) then) =
      _$TaskChecklistModelCopyWithImpl<$Res, TaskChecklistModel>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'task') int taskId,
      @JsonKey(name: 'template') int? templateId,
      @JsonKey(name: 'template_name') String? templateName,
      List<ChecklistItemModel> items,
      List<ChecklistResponseModel> responses,
      List<ChecklistPhotoModel> photos,
      @JsonKey(name: 'started_at') DateTime? startedAt,
      @JsonKey(name: 'completed_at') DateTime? completedAt,
      @JsonKey(name: 'completed_by') int? completedBy});
}

/// @nodoc
class _$TaskChecklistModelCopyWithImpl<$Res, $Val extends TaskChecklistModel>
    implements $TaskChecklistModelCopyWith<$Res> {
  _$TaskChecklistModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskChecklistModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? taskId = null,
    Object? templateId = freezed,
    Object? templateName = freezed,
    Object? items = null,
    Object? responses = null,
    Object? photos = null,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
    Object? completedBy = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      taskId: null == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as int,
      templateId: freezed == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as int?,
      templateName: freezed == templateName
          ? _value.templateName
          : templateName // ignore: cast_nullable_to_non_nullable
              as String?,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ChecklistItemModel>,
      responses: null == responses
          ? _value.responses
          : responses // ignore: cast_nullable_to_non_nullable
              as List<ChecklistResponseModel>,
      photos: null == photos
          ? _value.photos
          : photos // ignore: cast_nullable_to_non_nullable
              as List<ChecklistPhotoModel>,
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedBy: freezed == completedBy
          ? _value.completedBy
          : completedBy // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TaskChecklistModelImplCopyWith<$Res>
    implements $TaskChecklistModelCopyWith<$Res> {
  factory _$$TaskChecklistModelImplCopyWith(_$TaskChecklistModelImpl value,
          $Res Function(_$TaskChecklistModelImpl) then) =
      __$$TaskChecklistModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'task') int taskId,
      @JsonKey(name: 'template') int? templateId,
      @JsonKey(name: 'template_name') String? templateName,
      List<ChecklistItemModel> items,
      List<ChecklistResponseModel> responses,
      List<ChecklistPhotoModel> photos,
      @JsonKey(name: 'started_at') DateTime? startedAt,
      @JsonKey(name: 'completed_at') DateTime? completedAt,
      @JsonKey(name: 'completed_by') int? completedBy});
}

/// @nodoc
class __$$TaskChecklistModelImplCopyWithImpl<$Res>
    extends _$TaskChecklistModelCopyWithImpl<$Res, _$TaskChecklistModelImpl>
    implements _$$TaskChecklistModelImplCopyWith<$Res> {
  __$$TaskChecklistModelImplCopyWithImpl(_$TaskChecklistModelImpl _value,
      $Res Function(_$TaskChecklistModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of TaskChecklistModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? taskId = null,
    Object? templateId = freezed,
    Object? templateName = freezed,
    Object? items = null,
    Object? responses = null,
    Object? photos = null,
    Object? startedAt = freezed,
    Object? completedAt = freezed,
    Object? completedBy = freezed,
  }) {
    return _then(_$TaskChecklistModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      taskId: null == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as int,
      templateId: freezed == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as int?,
      templateName: freezed == templateName
          ? _value.templateName
          : templateName // ignore: cast_nullable_to_non_nullable
              as String?,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ChecklistItemModel>,
      responses: null == responses
          ? _value._responses
          : responses // ignore: cast_nullable_to_non_nullable
              as List<ChecklistResponseModel>,
      photos: null == photos
          ? _value._photos
          : photos // ignore: cast_nullable_to_non_nullable
              as List<ChecklistPhotoModel>,
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedBy: freezed == completedBy
          ? _value.completedBy
          : completedBy // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskChecklistModelImpl extends _TaskChecklistModel {
  const _$TaskChecklistModelImpl(
      {required this.id,
      @JsonKey(name: 'task') required this.taskId,
      @JsonKey(name: 'template') this.templateId,
      @JsonKey(name: 'template_name') this.templateName,
      final List<ChecklistItemModel> items = const [],
      final List<ChecklistResponseModel> responses = const [],
      final List<ChecklistPhotoModel> photos = const [],
      @JsonKey(name: 'started_at') this.startedAt,
      @JsonKey(name: 'completed_at') this.completedAt,
      @JsonKey(name: 'completed_by') this.completedBy})
      : _items = items,
        _responses = responses,
        _photos = photos,
        super._();

  factory _$TaskChecklistModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskChecklistModelImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'task')
  final int taskId;
  @override
  @JsonKey(name: 'template')
  final int? templateId;
  @override
  @JsonKey(name: 'template_name')
  final String? templateName;
  final List<ChecklistItemModel> _items;
  @override
  @JsonKey()
  List<ChecklistItemModel> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  final List<ChecklistResponseModel> _responses;
  @override
  @JsonKey()
  List<ChecklistResponseModel> get responses {
    if (_responses is EqualUnmodifiableListView) return _responses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_responses);
  }

  final List<ChecklistPhotoModel> _photos;
  @override
  @JsonKey()
  List<ChecklistPhotoModel> get photos {
    if (_photos is EqualUnmodifiableListView) return _photos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_photos);
  }

  @override
  @JsonKey(name: 'started_at')
  final DateTime? startedAt;
  @override
  @JsonKey(name: 'completed_at')
  final DateTime? completedAt;
  @override
  @JsonKey(name: 'completed_by')
  final int? completedBy;

  @override
  String toString() {
    return 'TaskChecklistModel(id: $id, taskId: $taskId, templateId: $templateId, templateName: $templateName, items: $items, responses: $responses, photos: $photos, startedAt: $startedAt, completedAt: $completedAt, completedBy: $completedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskChecklistModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.templateId, templateId) ||
                other.templateId == templateId) &&
            (identical(other.templateName, templateName) ||
                other.templateName == templateName) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            const DeepCollectionEquality()
                .equals(other._responses, _responses) &&
            const DeepCollectionEquality().equals(other._photos, _photos) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.completedBy, completedBy) ||
                other.completedBy == completedBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      taskId,
      templateId,
      templateName,
      const DeepCollectionEquality().hash(_items),
      const DeepCollectionEquality().hash(_responses),
      const DeepCollectionEquality().hash(_photos),
      startedAt,
      completedAt,
      completedBy);

  /// Create a copy of TaskChecklistModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskChecklistModelImplCopyWith<_$TaskChecklistModelImpl> get copyWith =>
      __$$TaskChecklistModelImplCopyWithImpl<_$TaskChecklistModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskChecklistModelImplToJson(
      this,
    );
  }
}

abstract class _TaskChecklistModel extends TaskChecklistModel {
  const factory _TaskChecklistModel(
          {required final int id,
          @JsonKey(name: 'task') required final int taskId,
          @JsonKey(name: 'template') final int? templateId,
          @JsonKey(name: 'template_name') final String? templateName,
          final List<ChecklistItemModel> items,
          final List<ChecklistResponseModel> responses,
          final List<ChecklistPhotoModel> photos,
          @JsonKey(name: 'started_at') final DateTime? startedAt,
          @JsonKey(name: 'completed_at') final DateTime? completedAt,
          @JsonKey(name: 'completed_by') final int? completedBy}) =
      _$TaskChecklistModelImpl;
  const _TaskChecklistModel._() : super._();

  factory _TaskChecklistModel.fromJson(Map<String, dynamic> json) =
      _$TaskChecklistModelImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'task')
  int get taskId;
  @override
  @JsonKey(name: 'template')
  int? get templateId;
  @override
  @JsonKey(name: 'template_name')
  String? get templateName;
  @override
  List<ChecklistItemModel> get items;
  @override
  List<ChecklistResponseModel> get responses;
  @override
  List<ChecklistPhotoModel> get photos;
  @override
  @JsonKey(name: 'started_at')
  DateTime? get startedAt;
  @override
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt;
  @override
  @JsonKey(name: 'completed_by')
  int? get completedBy;

  /// Create a copy of TaskChecklistModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskChecklistModelImplCopyWith<_$TaskChecklistModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChecklistProgressModel _$ChecklistProgressModelFromJson(
    Map<String, dynamic> json) {
  return _ChecklistProgressModel.fromJson(json);
}

/// @nodoc
mixin _$ChecklistProgressModel {
  int get completed => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  double get percentage => throw _privateConstructorUsedError;

  /// Serializes this ChecklistProgressModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChecklistProgressModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChecklistProgressModelCopyWith<ChecklistProgressModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChecklistProgressModelCopyWith<$Res> {
  factory $ChecklistProgressModelCopyWith(ChecklistProgressModel value,
          $Res Function(ChecklistProgressModel) then) =
      _$ChecklistProgressModelCopyWithImpl<$Res, ChecklistProgressModel>;
  @useResult
  $Res call({int completed, int total, double percentage});
}

/// @nodoc
class _$ChecklistProgressModelCopyWithImpl<$Res,
        $Val extends ChecklistProgressModel>
    implements $ChecklistProgressModelCopyWith<$Res> {
  _$ChecklistProgressModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChecklistProgressModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? completed = null,
    Object? total = null,
    Object? percentage = null,
  }) {
    return _then(_value.copyWith(
      completed: null == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChecklistProgressModelImplCopyWith<$Res>
    implements $ChecklistProgressModelCopyWith<$Res> {
  factory _$$ChecklistProgressModelImplCopyWith(
          _$ChecklistProgressModelImpl value,
          $Res Function(_$ChecklistProgressModelImpl) then) =
      __$$ChecklistProgressModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int completed, int total, double percentage});
}

/// @nodoc
class __$$ChecklistProgressModelImplCopyWithImpl<$Res>
    extends _$ChecklistProgressModelCopyWithImpl<$Res,
        _$ChecklistProgressModelImpl>
    implements _$$ChecklistProgressModelImplCopyWith<$Res> {
  __$$ChecklistProgressModelImplCopyWithImpl(
      _$ChecklistProgressModelImpl _value,
      $Res Function(_$ChecklistProgressModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChecklistProgressModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? completed = null,
    Object? total = null,
    Object? percentage = null,
  }) {
    return _then(_$ChecklistProgressModelImpl(
      completed: null == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChecklistProgressModelImpl extends _ChecklistProgressModel {
  const _$ChecklistProgressModelImpl(
      {this.completed = 0, this.total = 0, this.percentage = 0.0})
      : super._();

  factory _$ChecklistProgressModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChecklistProgressModelImplFromJson(json);

  @override
  @JsonKey()
  final int completed;
  @override
  @JsonKey()
  final int total;
  @override
  @JsonKey()
  final double percentage;

  @override
  String toString() {
    return 'ChecklistProgressModel(completed: $completed, total: $total, percentage: $percentage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChecklistProgressModelImpl &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, completed, total, percentage);

  /// Create a copy of ChecklistProgressModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChecklistProgressModelImplCopyWith<_$ChecklistProgressModelImpl>
      get copyWith => __$$ChecklistProgressModelImplCopyWithImpl<
          _$ChecklistProgressModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChecklistProgressModelImplToJson(
      this,
    );
  }
}

abstract class _ChecklistProgressModel extends ChecklistProgressModel {
  const factory _ChecklistProgressModel(
      {final int completed,
      final int total,
      final double percentage}) = _$ChecklistProgressModelImpl;
  const _ChecklistProgressModel._() : super._();

  factory _ChecklistProgressModel.fromJson(Map<String, dynamic> json) =
      _$ChecklistProgressModelImpl.fromJson;

  @override
  int get completed;
  @override
  int get total;
  @override
  double get percentage;

  /// Create a copy of ChecklistProgressModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChecklistProgressModelImplCopyWith<_$ChecklistProgressModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
