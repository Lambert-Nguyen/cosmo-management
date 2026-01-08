// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_list_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

InventoryFilter _$InventoryFilterFromJson(Map<String, dynamic> json) {
  return _InventoryFilter.fromJson(json);
}

/// @nodoc
mixin _$InventoryFilter {
  InventoryCategory? get category => throw _privateConstructorUsedError;
  int? get propertyId => throw _privateConstructorUsedError;
  String? get propertyName => throw _privateConstructorUsedError;
  String? get search => throw _privateConstructorUsedError;
  bool get lowStockOnly => throw _privateConstructorUsedError;
  String get sortBy => throw _privateConstructorUsedError;
  bool get ascending => throw _privateConstructorUsedError;

  /// Serializes this InventoryFilter to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InventoryFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InventoryFilterCopyWith<InventoryFilter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventoryFilterCopyWith<$Res> {
  factory $InventoryFilterCopyWith(
          InventoryFilter value, $Res Function(InventoryFilter) then) =
      _$InventoryFilterCopyWithImpl<$Res, InventoryFilter>;
  @useResult
  $Res call(
      {InventoryCategory? category,
      int? propertyId,
      String? propertyName,
      String? search,
      bool lowStockOnly,
      String sortBy,
      bool ascending});
}

/// @nodoc
class _$InventoryFilterCopyWithImpl<$Res, $Val extends InventoryFilter>
    implements $InventoryFilterCopyWith<$Res> {
  _$InventoryFilterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InventoryFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = freezed,
    Object? propertyId = freezed,
    Object? propertyName = freezed,
    Object? search = freezed,
    Object? lowStockOnly = null,
    Object? sortBy = null,
    Object? ascending = null,
  }) {
    return _then(_value.copyWith(
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as InventoryCategory?,
      propertyId: freezed == propertyId
          ? _value.propertyId
          : propertyId // ignore: cast_nullable_to_non_nullable
              as int?,
      propertyName: freezed == propertyName
          ? _value.propertyName
          : propertyName // ignore: cast_nullable_to_non_nullable
              as String?,
      search: freezed == search
          ? _value.search
          : search // ignore: cast_nullable_to_non_nullable
              as String?,
      lowStockOnly: null == lowStockOnly
          ? _value.lowStockOnly
          : lowStockOnly // ignore: cast_nullable_to_non_nullable
              as bool,
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
abstract class _$$InventoryFilterImplCopyWith<$Res>
    implements $InventoryFilterCopyWith<$Res> {
  factory _$$InventoryFilterImplCopyWith(_$InventoryFilterImpl value,
          $Res Function(_$InventoryFilterImpl) then) =
      __$$InventoryFilterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {InventoryCategory? category,
      int? propertyId,
      String? propertyName,
      String? search,
      bool lowStockOnly,
      String sortBy,
      bool ascending});
}

/// @nodoc
class __$$InventoryFilterImplCopyWithImpl<$Res>
    extends _$InventoryFilterCopyWithImpl<$Res, _$InventoryFilterImpl>
    implements _$$InventoryFilterImplCopyWith<$Res> {
  __$$InventoryFilterImplCopyWithImpl(
      _$InventoryFilterImpl _value, $Res Function(_$InventoryFilterImpl) _then)
      : super(_value, _then);

  /// Create a copy of InventoryFilter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = freezed,
    Object? propertyId = freezed,
    Object? propertyName = freezed,
    Object? search = freezed,
    Object? lowStockOnly = null,
    Object? sortBy = null,
    Object? ascending = null,
  }) {
    return _then(_$InventoryFilterImpl(
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as InventoryCategory?,
      propertyId: freezed == propertyId
          ? _value.propertyId
          : propertyId // ignore: cast_nullable_to_non_nullable
              as int?,
      propertyName: freezed == propertyName
          ? _value.propertyName
          : propertyName // ignore: cast_nullable_to_non_nullable
              as String?,
      search: freezed == search
          ? _value.search
          : search // ignore: cast_nullable_to_non_nullable
              as String?,
      lowStockOnly: null == lowStockOnly
          ? _value.lowStockOnly
          : lowStockOnly // ignore: cast_nullable_to_non_nullable
              as bool,
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
class _$InventoryFilterImpl implements _InventoryFilter {
  const _$InventoryFilterImpl(
      {this.category,
      this.propertyId,
      this.propertyName,
      this.search,
      this.lowStockOnly = false,
      this.sortBy = 'name',
      this.ascending = true});

  factory _$InventoryFilterImpl.fromJson(Map<String, dynamic> json) =>
      _$$InventoryFilterImplFromJson(json);

  @override
  final InventoryCategory? category;
  @override
  final int? propertyId;
  @override
  final String? propertyName;
  @override
  final String? search;
  @override
  @JsonKey()
  final bool lowStockOnly;
  @override
  @JsonKey()
  final String sortBy;
  @override
  @JsonKey()
  final bool ascending;

  @override
  String toString() {
    return 'InventoryFilter(category: $category, propertyId: $propertyId, propertyName: $propertyName, search: $search, lowStockOnly: $lowStockOnly, sortBy: $sortBy, ascending: $ascending)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryFilterImpl &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.propertyId, propertyId) ||
                other.propertyId == propertyId) &&
            (identical(other.propertyName, propertyName) ||
                other.propertyName == propertyName) &&
            (identical(other.search, search) || other.search == search) &&
            (identical(other.lowStockOnly, lowStockOnly) ||
                other.lowStockOnly == lowStockOnly) &&
            (identical(other.sortBy, sortBy) || other.sortBy == sortBy) &&
            (identical(other.ascending, ascending) ||
                other.ascending == ascending));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, category, propertyId,
      propertyName, search, lowStockOnly, sortBy, ascending);

  /// Create a copy of InventoryFilter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InventoryFilterImplCopyWith<_$InventoryFilterImpl> get copyWith =>
      __$$InventoryFilterImplCopyWithImpl<_$InventoryFilterImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InventoryFilterImplToJson(
      this,
    );
  }
}

abstract class _InventoryFilter implements InventoryFilter {
  const factory _InventoryFilter(
      {final InventoryCategory? category,
      final int? propertyId,
      final String? propertyName,
      final String? search,
      final bool lowStockOnly,
      final String sortBy,
      final bool ascending}) = _$InventoryFilterImpl;

  factory _InventoryFilter.fromJson(Map<String, dynamic> json) =
      _$InventoryFilterImpl.fromJson;

  @override
  InventoryCategory? get category;
  @override
  int? get propertyId;
  @override
  String? get propertyName;
  @override
  String? get search;
  @override
  bool get lowStockOnly;
  @override
  String get sortBy;
  @override
  bool get ascending;

  /// Create a copy of InventoryFilter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InventoryFilterImplCopyWith<_$InventoryFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
