// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) {
  return _NotificationModel.fromJson(json);
}

/// @nodoc
mixin _$NotificationModel {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  @JsonKey(name: 'notification_type')
  String? get notificationType => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_read')
  bool get isRead => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'read_at')
  DateTime? get readAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'action_url')
  String? get actionUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'related_object_type')
  String? get relatedObjectType => throw _privateConstructorUsedError;
  @JsonKey(name: 'related_object_id')
  int? get relatedObjectId => throw _privateConstructorUsedError;

  /// Serializes this NotificationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationModelCopyWith<NotificationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationModelCopyWith<$Res> {
  factory $NotificationModelCopyWith(
          NotificationModel value, $Res Function(NotificationModel) then) =
      _$NotificationModelCopyWithImpl<$Res, NotificationModel>;
  @useResult
  $Res call(
      {int id,
      String title,
      String? message,
      @JsonKey(name: 'notification_type') String? notificationType,
      @JsonKey(name: 'is_read') bool isRead,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'read_at') DateTime? readAt,
      @JsonKey(name: 'action_url') String? actionUrl,
      @JsonKey(name: 'related_object_type') String? relatedObjectType,
      @JsonKey(name: 'related_object_id') int? relatedObjectId});
}

/// @nodoc
class _$NotificationModelCopyWithImpl<$Res, $Val extends NotificationModel>
    implements $NotificationModelCopyWith<$Res> {
  _$NotificationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? message = freezed,
    Object? notificationType = freezed,
    Object? isRead = null,
    Object? createdAt = freezed,
    Object? readAt = freezed,
    Object? actionUrl = freezed,
    Object? relatedObjectType = freezed,
    Object? relatedObjectId = freezed,
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
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      notificationType: freezed == notificationType
          ? _value.notificationType
          : notificationType // ignore: cast_nullable_to_non_nullable
              as String?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      actionUrl: freezed == actionUrl
          ? _value.actionUrl
          : actionUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      relatedObjectType: freezed == relatedObjectType
          ? _value.relatedObjectType
          : relatedObjectType // ignore: cast_nullable_to_non_nullable
              as String?,
      relatedObjectId: freezed == relatedObjectId
          ? _value.relatedObjectId
          : relatedObjectId // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationModelImplCopyWith<$Res>
    implements $NotificationModelCopyWith<$Res> {
  factory _$$NotificationModelImplCopyWith(_$NotificationModelImpl value,
          $Res Function(_$NotificationModelImpl) then) =
      __$$NotificationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      String? message,
      @JsonKey(name: 'notification_type') String? notificationType,
      @JsonKey(name: 'is_read') bool isRead,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'read_at') DateTime? readAt,
      @JsonKey(name: 'action_url') String? actionUrl,
      @JsonKey(name: 'related_object_type') String? relatedObjectType,
      @JsonKey(name: 'related_object_id') int? relatedObjectId});
}

/// @nodoc
class __$$NotificationModelImplCopyWithImpl<$Res>
    extends _$NotificationModelCopyWithImpl<$Res, _$NotificationModelImpl>
    implements _$$NotificationModelImplCopyWith<$Res> {
  __$$NotificationModelImplCopyWithImpl(_$NotificationModelImpl _value,
      $Res Function(_$NotificationModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? message = freezed,
    Object? notificationType = freezed,
    Object? isRead = null,
    Object? createdAt = freezed,
    Object? readAt = freezed,
    Object? actionUrl = freezed,
    Object? relatedObjectType = freezed,
    Object? relatedObjectId = freezed,
  }) {
    return _then(_$NotificationModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      notificationType: freezed == notificationType
          ? _value.notificationType
          : notificationType // ignore: cast_nullable_to_non_nullable
              as String?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      actionUrl: freezed == actionUrl
          ? _value.actionUrl
          : actionUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      relatedObjectType: freezed == relatedObjectType
          ? _value.relatedObjectType
          : relatedObjectType // ignore: cast_nullable_to_non_nullable
              as String?,
      relatedObjectId: freezed == relatedObjectId
          ? _value.relatedObjectId
          : relatedObjectId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationModelImpl extends _NotificationModel {
  const _$NotificationModelImpl(
      {required this.id,
      required this.title,
      this.message,
      @JsonKey(name: 'notification_type') this.notificationType,
      @JsonKey(name: 'is_read') this.isRead = false,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'read_at') this.readAt,
      @JsonKey(name: 'action_url') this.actionUrl,
      @JsonKey(name: 'related_object_type') this.relatedObjectType,
      @JsonKey(name: 'related_object_id') this.relatedObjectId})
      : super._();

  factory _$NotificationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationModelImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String? message;
  @override
  @JsonKey(name: 'notification_type')
  final String? notificationType;
  @override
  @JsonKey(name: 'is_read')
  final bool isRead;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'read_at')
  final DateTime? readAt;
  @override
  @JsonKey(name: 'action_url')
  final String? actionUrl;
  @override
  @JsonKey(name: 'related_object_type')
  final String? relatedObjectType;
  @override
  @JsonKey(name: 'related_object_id')
  final int? relatedObjectId;

  @override
  String toString() {
    return 'NotificationModel(id: $id, title: $title, message: $message, notificationType: $notificationType, isRead: $isRead, createdAt: $createdAt, readAt: $readAt, actionUrl: $actionUrl, relatedObjectType: $relatedObjectType, relatedObjectId: $relatedObjectId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.notificationType, notificationType) ||
                other.notificationType == notificationType) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.readAt, readAt) || other.readAt == readAt) &&
            (identical(other.actionUrl, actionUrl) ||
                other.actionUrl == actionUrl) &&
            (identical(other.relatedObjectType, relatedObjectType) ||
                other.relatedObjectType == relatedObjectType) &&
            (identical(other.relatedObjectId, relatedObjectId) ||
                other.relatedObjectId == relatedObjectId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      message,
      notificationType,
      isRead,
      createdAt,
      readAt,
      actionUrl,
      relatedObjectType,
      relatedObjectId);

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationModelImplCopyWith<_$NotificationModelImpl> get copyWith =>
      __$$NotificationModelImplCopyWithImpl<_$NotificationModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationModelImplToJson(
      this,
    );
  }
}

abstract class _NotificationModel extends NotificationModel {
  const factory _NotificationModel(
          {required final int id,
          required final String title,
          final String? message,
          @JsonKey(name: 'notification_type') final String? notificationType,
          @JsonKey(name: 'is_read') final bool isRead,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'read_at') final DateTime? readAt,
          @JsonKey(name: 'action_url') final String? actionUrl,
          @JsonKey(name: 'related_object_type') final String? relatedObjectType,
          @JsonKey(name: 'related_object_id') final int? relatedObjectId}) =
      _$NotificationModelImpl;
  const _NotificationModel._() : super._();

  factory _NotificationModel.fromJson(Map<String, dynamic> json) =
      _$NotificationModelImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String? get message;
  @override
  @JsonKey(name: 'notification_type')
  String? get notificationType;
  @override
  @JsonKey(name: 'is_read')
  bool get isRead;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'read_at')
  DateTime? get readAt;
  @override
  @JsonKey(name: 'action_url')
  String? get actionUrl;
  @override
  @JsonKey(name: 'related_object_type')
  String? get relatedObjectType;
  @override
  @JsonKey(name: 'related_object_id')
  int? get relatedObjectId;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationModelImplCopyWith<_$NotificationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
