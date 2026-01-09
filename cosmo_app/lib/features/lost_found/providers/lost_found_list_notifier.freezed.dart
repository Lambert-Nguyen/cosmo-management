// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lost_found_list_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LostFoundFilter {
  String? get search => throw _privateConstructorUsedError;
  LostFoundStatus? get status => throw _privateConstructorUsedError;
  LostFoundCategory? get category => throw _privateConstructorUsedError;
  int? get propertyId => throw _privateConstructorUsedError;
  String? get propertyName => throw _privateConstructorUsedError;
  bool get needsAttentionOnly => throw _privateConstructorUsedError;

  /// Create a copy of LostFoundFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LostFoundFilterCopyWith<LostFoundFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LostFoundFilterCopyWith<$Res> {
  factory $LostFoundFilterCopyWith(
          LostFoundFilter value, $Res Function(LostFoundFilter) then) =
      _$LostFoundFilterCopyWithImpl<$Res, LostFoundFilter>;
  @useResult
  $Res call(
      {String? search,
      LostFoundStatus? status,
      LostFoundCategory? category,
      int? propertyId,
      String? propertyName,
      bool needsAttentionOnly});
}

/// @nodoc
class _$LostFoundFilterCopyWithImpl<$Res, $Val extends LostFoundFilter>
    implements $LostFoundFilterCopyWith<$Res> {
  _$LostFoundFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LostFoundFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? search = freezed,
    Object? status = freezed,
    Object? category = freezed,
    Object? propertyId = freezed,
    Object? propertyName = freezed,
    Object? needsAttentionOnly = null,
  }) {
    return _then(_value.copyWith(
      search: freezed == search
          ? _value.search
          : search // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as LostFoundStatus?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as LostFoundCategory?,
      propertyId: freezed == propertyId
          ? _value.propertyId
          : propertyId // ignore: cast_nullable_to_non_nullable
              as int?,
      propertyName: freezed == propertyName
          ? _value.propertyName
          : propertyName // ignore: cast_nullable_to_non_nullable
              as String?,
      needsAttentionOnly: null == needsAttentionOnly
          ? _value.needsAttentionOnly
          : needsAttentionOnly // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LostFoundFilterImplCopyWith<$Res>
    implements $LostFoundFilterCopyWith<$Res> {
  factory _$$LostFoundFilterImplCopyWith(_$LostFoundFilterImpl value,
          $Res Function(_$LostFoundFilterImpl) then) =
      __$$LostFoundFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? search,
      LostFoundStatus? status,
      LostFoundCategory? category,
      int? propertyId,
      String? propertyName,
      bool needsAttentionOnly});
}

/// @nodoc
class __$$LostFoundFilterImplCopyWithImpl<$Res>
    extends _$LostFoundFilterCopyWithImpl<$Res, _$LostFoundFilterImpl>
    implements _$$LostFoundFilterImplCopyWith<$Res> {
  __$$LostFoundFilterImplCopyWithImpl(
      _$LostFoundFilterImpl _value, $Res Function(_$LostFoundFilterImpl) _then)
      : super(_value, _then);

  /// Create a copy of LostFoundFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? search = freezed,
    Object? status = freezed,
    Object? category = freezed,
    Object? propertyId = freezed,
    Object? propertyName = freezed,
    Object? needsAttentionOnly = null,
  }) {
    return _then(_$LostFoundFilterImpl(
      search: freezed == search
          ? _value.search
          : search // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as LostFoundStatus?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as LostFoundCategory?,
      propertyId: freezed == propertyId
          ? _value.propertyId
          : propertyId // ignore: cast_nullable_to_non_nullable
              as int?,
      propertyName: freezed == propertyName
          ? _value.propertyName
          : propertyName // ignore: cast_nullable_to_non_nullable
              as String?,
      needsAttentionOnly: null == needsAttentionOnly
          ? _value.needsAttentionOnly
          : needsAttentionOnly // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$LostFoundFilterImpl extends _LostFoundFilter {
  const _$LostFoundFilterImpl(
      {this.search,
      this.status,
      this.category,
      this.propertyId,
      this.propertyName,
      this.needsAttentionOnly = false})
      : super._();

  @override
  final String? search;
  @override
  final LostFoundStatus? status;
  @override
  final LostFoundCategory? category;
  @override
  final int? propertyId;
  @override
  final String? propertyName;
  @override
  @JsonKey()
  final bool needsAttentionOnly;

  @override
  String toString() {
    return 'LostFoundFilter(search: $search, status: $status, category: $category, propertyId: $propertyId, propertyName: $propertyName, needsAttentionOnly: $needsAttentionOnly)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LostFoundFilterImpl &&
            (identical(other.search, search) || other.search == search) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.propertyId, propertyId) ||
                other.propertyId == propertyId) &&
            (identical(other.propertyName, propertyName) ||
                other.propertyName == propertyName) &&
            (identical(other.needsAttentionOnly, needsAttentionOnly) ||
                other.needsAttentionOnly == needsAttentionOnly));
  }

  @override
  int get hashCode => Object.hash(runtimeType, search, status, category,
      propertyId, propertyName, needsAttentionOnly);

  /// Create a copy of LostFoundFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LostFoundFilterImplCopyWith<_$LostFoundFilterImpl> get copyWith =>
      __$$LostFoundFilterImplCopyWithImpl<_$LostFoundFilterImpl>(
          this, _$identity);
}

abstract class _LostFoundFilter extends LostFoundFilter {
  const factory _LostFoundFilter(
      {final String? search,
      final LostFoundStatus? status,
      final LostFoundCategory? category,
      final int? propertyId,
      final String? propertyName,
      final bool needsAttentionOnly}) = _$LostFoundFilterImpl;
  const _LostFoundFilter._() : super._();

  @override
  String? get search;
  @override
  LostFoundStatus? get status;
  @override
  LostFoundCategory? get category;
  @override
  int? get propertyId;
  @override
  String? get propertyName;
  @override
  bool get needsAttentionOnly;

  /// Create a copy of LostFoundFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LostFoundFilterImplCopyWith<_$LostFoundFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
