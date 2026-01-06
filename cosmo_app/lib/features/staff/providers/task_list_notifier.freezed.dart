// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_list_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TaskListFilter _$TaskListFilterFromJson(Map<String, dynamic> json) {
  return _TaskListFilter.fromJson(json);
}

/// @nodoc
mixin _$TaskListFilter {
  TaskStatus? get status => throw _privateConstructorUsedError;
  TaskPriority? get priority => throw _privateConstructorUsedError;
  int? get propertyId => throw _privateConstructorUsedError;
  String? get propertyName => throw _privateConstructorUsedError;
  bool get overdueOnly => throw _privateConstructorUsedError;
  String? get search => throw _privateConstructorUsedError;
  String get sortBy => throw _privateConstructorUsedError;
  bool get ascending => throw _privateConstructorUsedError;

  /// Serializes this TaskListFilter to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskListFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskListFilterCopyWith<TaskListFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskListFilterCopyWith<$Res> {
  factory $TaskListFilterCopyWith(
          TaskListFilter value, $Res Function(TaskListFilter) then) =
      _$TaskListFilterCopyWithImpl<$Res, TaskListFilter>;
  @useResult
  $Res call(
      {TaskStatus? status,
      TaskPriority? priority,
      int? propertyId,
      String? propertyName,
      bool overdueOnly,
      String? search,
      String sortBy,
      bool ascending});
}

/// @nodoc
class _$TaskListFilterCopyWithImpl<$Res, $Val extends TaskListFilter>
    implements $TaskListFilterCopyWith<$Res> {
  _$TaskListFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskListFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? priority = freezed,
    Object? propertyId = freezed,
    Object? propertyName = freezed,
    Object? overdueOnly = null,
    Object? search = freezed,
    Object? sortBy = null,
    Object? ascending = null,
  }) {
    return _then(_value.copyWith(
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TaskStatus?,
      priority: freezed == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as TaskPriority?,
      propertyId: freezed == propertyId
          ? _value.propertyId
          : propertyId // ignore: cast_nullable_to_non_nullable
              as int?,
      propertyName: freezed == propertyName
          ? _value.propertyName
          : propertyName // ignore: cast_nullable_to_non_nullable
              as String?,
      overdueOnly: null == overdueOnly
          ? _value.overdueOnly
          : overdueOnly // ignore: cast_nullable_to_non_nullable
              as bool,
      search: freezed == search
          ? _value.search
          : search // ignore: cast_nullable_to_non_nullable
              as String?,
      sortBy: null == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as String,
      ascending: null == ascending
          ? _value.ascending
          : ascending // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TaskListFilterImplCopyWith<$Res>
    implements $TaskListFilterCopyWith<$Res> {
  factory _$$TaskListFilterImplCopyWith(_$TaskListFilterImpl value,
          $Res Function(_$TaskListFilterImpl) then) =
      __$$TaskListFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {TaskStatus? status,
      TaskPriority? priority,
      int? propertyId,
      String? propertyName,
      bool overdueOnly,
      String? search,
      String sortBy,
      bool ascending});
}

/// @nodoc
class __$$TaskListFilterImplCopyWithImpl<$Res>
    extends _$TaskListFilterCopyWithImpl<$Res, _$TaskListFilterImpl>
    implements _$$TaskListFilterImplCopyWith<$Res> {
  __$$TaskListFilterImplCopyWithImpl(
      _$TaskListFilterImpl _value, $Res Function(_$TaskListFilterImpl) _then)
      : super(_value, _then);

  /// Create a copy of TaskListFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? priority = freezed,
    Object? propertyId = freezed,
    Object? propertyName = freezed,
    Object? overdueOnly = null,
    Object? search = freezed,
    Object? sortBy = null,
    Object? ascending = null,
  }) {
    return _then(_$TaskListFilterImpl(
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TaskStatus?,
      priority: freezed == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as TaskPriority?,
      propertyId: freezed == propertyId
          ? _value.propertyId
          : propertyId // ignore: cast_nullable_to_non_nullable
              as int?,
      propertyName: freezed == propertyName
          ? _value.propertyName
          : propertyName // ignore: cast_nullable_to_non_nullable
              as String?,
      overdueOnly: null == overdueOnly
          ? _value.overdueOnly
          : overdueOnly // ignore: cast_nullable_to_non_nullable
              as bool,
      search: freezed == search
          ? _value.search
          : search // ignore: cast_nullable_to_non_nullable
              as String?,
      sortBy: null == sortBy
          ? _value.sortBy
          : sortBy // ignore: cast_nullable_to_non_nullable
              as String,
      ascending: null == ascending
          ? _value.ascending
          : ascending // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskListFilterImpl implements _TaskListFilter {
  const _$TaskListFilterImpl(
      {this.status,
      this.priority,
      this.propertyId,
      this.propertyName,
      this.overdueOnly = false,
      this.search,
      this.sortBy = 'due_date',
      this.ascending = true});

  factory _$TaskListFilterImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskListFilterImplFromJson(json);

  @override
  final TaskStatus? status;
  @override
  final TaskPriority? priority;
  @override
  final int? propertyId;
  @override
  final String? propertyName;
  @override
  @JsonKey()
  final bool overdueOnly;
  @override
  final String? search;
  @override
  @JsonKey()
  final String sortBy;
  @override
  @JsonKey()
  final bool ascending;

  @override
  String toString() {
    return 'TaskListFilter(status: $status, priority: $priority, propertyId: $propertyId, propertyName: $propertyName, overdueOnly: $overdueOnly, search: $search, sortBy: $sortBy, ascending: $ascending)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskListFilterImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.propertyId, propertyId) ||
                other.propertyId == propertyId) &&
            (identical(other.propertyName, propertyName) ||
                other.propertyName == propertyName) &&
            (identical(other.overdueOnly, overdueOnly) ||
                other.overdueOnly == overdueOnly) &&
            (identical(other.search, search) || other.search == search) &&
            (identical(other.sortBy, sortBy) || other.sortBy == sortBy) &&
            (identical(other.ascending, ascending) ||
                other.ascending == ascending));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, status, priority, propertyId,
      propertyName, overdueOnly, search, sortBy, ascending);

  /// Create a copy of TaskListFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskListFilterImplCopyWith<_$TaskListFilterImpl> get copyWith =>
      __$$TaskListFilterImplCopyWithImpl<_$TaskListFilterImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskListFilterImplToJson(
      this,
    );
  }
}

abstract class _TaskListFilter implements TaskListFilter {
  const factory _TaskListFilter(
      {final TaskStatus? status,
      final TaskPriority? priority,
      final int? propertyId,
      final String? propertyName,
      final bool overdueOnly,
      final String? search,
      final String sortBy,
      final bool ascending}) = _$TaskListFilterImpl;

  factory _TaskListFilter.fromJson(Map<String, dynamic> json) =
      _$TaskListFilterImpl.fromJson;

  @override
  TaskStatus? get status;
  @override
  TaskPriority? get priority;
  @override
  int? get propertyId;
  @override
  String? get propertyName;
  @override
  bool get overdueOnly;
  @override
  String? get search;
  @override
  String get sortBy;
  @override
  bool get ascending;

  /// Create a copy of TaskListFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskListFilterImplCopyWith<_$TaskListFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
