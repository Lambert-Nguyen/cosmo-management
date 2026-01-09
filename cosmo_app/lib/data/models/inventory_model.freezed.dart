// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

InventoryModel _$InventoryModelFromJson(Map<String, dynamic> json) {
  return _InventoryModel.fromJson(json);
}

/// @nodoc
mixin _$InventoryModel {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  InventoryCategory get category => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_type')
  String? get unitType => throw _privateConstructorUsedError;
  @JsonKey(name: 'par_level')
  int? get parLevel => throw _privateConstructorUsedError;
  @JsonKey(name: 'reorder_point')
  int? get reorderPoint => throw _privateConstructorUsedError;
  @JsonKey(name: 'property_id')
  int? get propertyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'property_name')
  String? get propertyName => throw _privateConstructorUsedError;
  @JsonKey(name: 'location')
  String? get location => throw _privateConstructorUsedError;
  @JsonKey(name: 'sku')
  String? get sku => throw _privateConstructorUsedError;
  @JsonKey(name: 'barcode')
  String? get barcode => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_cost')
  double? get unitCost => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_counted_at')
  DateTime? get lastCountedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_counted_by')
  int? get lastCountedById => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_counted_by_name')
  String? get lastCountedByName => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  List<String> get images => throw _privateConstructorUsedError;

  /// Serializes this InventoryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InventoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InventoryModelCopyWith<InventoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventoryModelCopyWith<$Res> {
  factory $InventoryModelCopyWith(
          InventoryModel value, $Res Function(InventoryModel) then) =
      _$InventoryModelCopyWithImpl<$Res, InventoryModel>;
  @useResult
  $Res call(
      {int id,
      String name,
      String? description,
      InventoryCategory category,
      int quantity,
      @JsonKey(name: 'unit_type') String? unitType,
      @JsonKey(name: 'par_level') int? parLevel,
      @JsonKey(name: 'reorder_point') int? reorderPoint,
      @JsonKey(name: 'property_id') int? propertyId,
      @JsonKey(name: 'property_name') String? propertyName,
      @JsonKey(name: 'location') String? location,
      @JsonKey(name: 'sku') String? sku,
      @JsonKey(name: 'barcode') String? barcode,
      @JsonKey(name: 'unit_cost') double? unitCost,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'last_counted_at') DateTime? lastCountedAt,
      @JsonKey(name: 'last_counted_by') int? lastCountedById,
      @JsonKey(name: 'last_counted_by_name') String? lastCountedByName,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      List<String> images});
}

/// @nodoc
class _$InventoryModelCopyWithImpl<$Res, $Val extends InventoryModel>
    implements $InventoryModelCopyWith<$Res> {
  _$InventoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InventoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? category = null,
    Object? quantity = null,
    Object? unitType = freezed,
    Object? parLevel = freezed,
    Object? reorderPoint = freezed,
    Object? propertyId = freezed,
    Object? propertyName = freezed,
    Object? location = freezed,
    Object? sku = freezed,
    Object? barcode = freezed,
    Object? unitCost = freezed,
    Object? isActive = null,
    Object? lastCountedAt = freezed,
    Object? lastCountedById = freezed,
    Object? lastCountedByName = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? images = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as InventoryCategory,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      unitType: freezed == unitType
          ? _value.unitType
          : unitType // ignore: cast_nullable_to_non_nullable
              as String?,
      parLevel: freezed == parLevel
          ? _value.parLevel
          : parLevel // ignore: cast_nullable_to_non_nullable
              as int?,
      reorderPoint: freezed == reorderPoint
          ? _value.reorderPoint
          : reorderPoint // ignore: cast_nullable_to_non_nullable
              as int?,
      propertyId: freezed == propertyId
          ? _value.propertyId
          : propertyId // ignore: cast_nullable_to_non_nullable
              as int?,
      propertyName: freezed == propertyName
          ? _value.propertyName
          : propertyName // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      barcode: freezed == barcode
          ? _value.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String?,
      unitCost: freezed == unitCost
          ? _value.unitCost
          : unitCost // ignore: cast_nullable_to_non_nullable
              as double?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      lastCountedAt: freezed == lastCountedAt
          ? _value.lastCountedAt
          : lastCountedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastCountedById: freezed == lastCountedById
          ? _value.lastCountedById
          : lastCountedById // ignore: cast_nullable_to_non_nullable
              as int?,
      lastCountedByName: freezed == lastCountedByName
          ? _value.lastCountedByName
          : lastCountedByName // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InventoryModelImplCopyWith<$Res>
    implements $InventoryModelCopyWith<$Res> {
  factory _$$InventoryModelImplCopyWith(_$InventoryModelImpl value,
          $Res Function(_$InventoryModelImpl) then) =
      __$$InventoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      String? description,
      InventoryCategory category,
      int quantity,
      @JsonKey(name: 'unit_type') String? unitType,
      @JsonKey(name: 'par_level') int? parLevel,
      @JsonKey(name: 'reorder_point') int? reorderPoint,
      @JsonKey(name: 'property_id') int? propertyId,
      @JsonKey(name: 'property_name') String? propertyName,
      @JsonKey(name: 'location') String? location,
      @JsonKey(name: 'sku') String? sku,
      @JsonKey(name: 'barcode') String? barcode,
      @JsonKey(name: 'unit_cost') double? unitCost,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'last_counted_at') DateTime? lastCountedAt,
      @JsonKey(name: 'last_counted_by') int? lastCountedById,
      @JsonKey(name: 'last_counted_by_name') String? lastCountedByName,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      List<String> images});
}

/// @nodoc
class __$$InventoryModelImplCopyWithImpl<$Res>
    extends _$InventoryModelCopyWithImpl<$Res, _$InventoryModelImpl>
    implements _$$InventoryModelImplCopyWith<$Res> {
  __$$InventoryModelImplCopyWithImpl(
      _$InventoryModelImpl _value, $Res Function(_$InventoryModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of InventoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? category = null,
    Object? quantity = null,
    Object? unitType = freezed,
    Object? parLevel = freezed,
    Object? reorderPoint = freezed,
    Object? propertyId = freezed,
    Object? propertyName = freezed,
    Object? location = freezed,
    Object? sku = freezed,
    Object? barcode = freezed,
    Object? unitCost = freezed,
    Object? isActive = null,
    Object? lastCountedAt = freezed,
    Object? lastCountedById = freezed,
    Object? lastCountedByName = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? images = null,
  }) {
    return _then(_$InventoryModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as InventoryCategory,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      unitType: freezed == unitType
          ? _value.unitType
          : unitType // ignore: cast_nullable_to_non_nullable
              as String?,
      parLevel: freezed == parLevel
          ? _value.parLevel
          : parLevel // ignore: cast_nullable_to_non_nullable
              as int?,
      reorderPoint: freezed == reorderPoint
          ? _value.reorderPoint
          : reorderPoint // ignore: cast_nullable_to_non_nullable
              as int?,
      propertyId: freezed == propertyId
          ? _value.propertyId
          : propertyId // ignore: cast_nullable_to_non_nullable
              as int?,
      propertyName: freezed == propertyName
          ? _value.propertyName
          : propertyName // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      barcode: freezed == barcode
          ? _value.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String?,
      unitCost: freezed == unitCost
          ? _value.unitCost
          : unitCost // ignore: cast_nullable_to_non_nullable
              as double?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      lastCountedAt: freezed == lastCountedAt
          ? _value.lastCountedAt
          : lastCountedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastCountedById: freezed == lastCountedById
          ? _value.lastCountedById
          : lastCountedById // ignore: cast_nullable_to_non_nullable
              as int?,
      lastCountedByName: freezed == lastCountedByName
          ? _value.lastCountedByName
          : lastCountedByName // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InventoryModelImpl extends _InventoryModel {
  const _$InventoryModelImpl(
      {required this.id,
      required this.name,
      this.description,
      this.category = InventoryCategory.other,
      this.quantity = 0,
      @JsonKey(name: 'unit_type') this.unitType,
      @JsonKey(name: 'par_level') this.parLevel,
      @JsonKey(name: 'reorder_point') this.reorderPoint,
      @JsonKey(name: 'property_id') this.propertyId,
      @JsonKey(name: 'property_name') this.propertyName,
      @JsonKey(name: 'location') this.location,
      @JsonKey(name: 'sku') this.sku,
      @JsonKey(name: 'barcode') this.barcode,
      @JsonKey(name: 'unit_cost') this.unitCost,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'last_counted_at') this.lastCountedAt,
      @JsonKey(name: 'last_counted_by') this.lastCountedById,
      @JsonKey(name: 'last_counted_by_name') this.lastCountedByName,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      final List<String> images = const []})
      : _images = images,
        super._();

  factory _$InventoryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$InventoryModelImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey()
  final InventoryCategory category;
  @override
  @JsonKey()
  final int quantity;
  @override
  @JsonKey(name: 'unit_type')
  final String? unitType;
  @override
  @JsonKey(name: 'par_level')
  final int? parLevel;
  @override
  @JsonKey(name: 'reorder_point')
  final int? reorderPoint;
  @override
  @JsonKey(name: 'property_id')
  final int? propertyId;
  @override
  @JsonKey(name: 'property_name')
  final String? propertyName;
  @override
  @JsonKey(name: 'location')
  final String? location;
  @override
  @JsonKey(name: 'sku')
  final String? sku;
  @override
  @JsonKey(name: 'barcode')
  final String? barcode;
  @override
  @JsonKey(name: 'unit_cost')
  final double? unitCost;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'last_counted_at')
  final DateTime? lastCountedAt;
  @override
  @JsonKey(name: 'last_counted_by')
  final int? lastCountedById;
  @override
  @JsonKey(name: 'last_counted_by_name')
  final String? lastCountedByName;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  final List<String> _images;
  @override
  @JsonKey()
  List<String> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  String toString() {
    return 'InventoryModel(id: $id, name: $name, description: $description, category: $category, quantity: $quantity, unitType: $unitType, parLevel: $parLevel, reorderPoint: $reorderPoint, propertyId: $propertyId, propertyName: $propertyName, location: $location, sku: $sku, barcode: $barcode, unitCost: $unitCost, isActive: $isActive, lastCountedAt: $lastCountedAt, lastCountedById: $lastCountedById, lastCountedByName: $lastCountedByName, createdAt: $createdAt, updatedAt: $updatedAt, images: $images)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unitType, unitType) ||
                other.unitType == unitType) &&
            (identical(other.parLevel, parLevel) ||
                other.parLevel == parLevel) &&
            (identical(other.reorderPoint, reorderPoint) ||
                other.reorderPoint == reorderPoint) &&
            (identical(other.propertyId, propertyId) ||
                other.propertyId == propertyId) &&
            (identical(other.propertyName, propertyName) ||
                other.propertyName == propertyName) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.barcode, barcode) || other.barcode == barcode) &&
            (identical(other.unitCost, unitCost) ||
                other.unitCost == unitCost) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.lastCountedAt, lastCountedAt) ||
                other.lastCountedAt == lastCountedAt) &&
            (identical(other.lastCountedById, lastCountedById) ||
                other.lastCountedById == lastCountedById) &&
            (identical(other.lastCountedByName, lastCountedByName) ||
                other.lastCountedByName == lastCountedByName) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._images, _images));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        description,
        category,
        quantity,
        unitType,
        parLevel,
        reorderPoint,
        propertyId,
        propertyName,
        location,
        sku,
        barcode,
        unitCost,
        isActive,
        lastCountedAt,
        lastCountedById,
        lastCountedByName,
        createdAt,
        updatedAt,
        const DeepCollectionEquality().hash(_images)
      ]);

  /// Create a copy of InventoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InventoryModelImplCopyWith<_$InventoryModelImpl> get copyWith =>
      __$$InventoryModelImplCopyWithImpl<_$InventoryModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InventoryModelImplToJson(
      this,
    );
  }
}

abstract class _InventoryModel extends InventoryModel {
  const factory _InventoryModel(
      {required final int id,
      required final String name,
      final String? description,
      final InventoryCategory category,
      final int quantity,
      @JsonKey(name: 'unit_type') final String? unitType,
      @JsonKey(name: 'par_level') final int? parLevel,
      @JsonKey(name: 'reorder_point') final int? reorderPoint,
      @JsonKey(name: 'property_id') final int? propertyId,
      @JsonKey(name: 'property_name') final String? propertyName,
      @JsonKey(name: 'location') final String? location,
      @JsonKey(name: 'sku') final String? sku,
      @JsonKey(name: 'barcode') final String? barcode,
      @JsonKey(name: 'unit_cost') final double? unitCost,
      @JsonKey(name: 'is_active') final bool isActive,
      @JsonKey(name: 'last_counted_at') final DateTime? lastCountedAt,
      @JsonKey(name: 'last_counted_by') final int? lastCountedById,
      @JsonKey(name: 'last_counted_by_name') final String? lastCountedByName,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at') final DateTime? updatedAt,
      final List<String> images}) = _$InventoryModelImpl;
  const _InventoryModel._() : super._();

  factory _InventoryModel.fromJson(Map<String, dynamic> json) =
      _$InventoryModelImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  InventoryCategory get category;
  @override
  int get quantity;
  @override
  @JsonKey(name: 'unit_type')
  String? get unitType;
  @override
  @JsonKey(name: 'par_level')
  int? get parLevel;
  @override
  @JsonKey(name: 'reorder_point')
  int? get reorderPoint;
  @override
  @JsonKey(name: 'property_id')
  int? get propertyId;
  @override
  @JsonKey(name: 'property_name')
  String? get propertyName;
  @override
  @JsonKey(name: 'location')
  String? get location;
  @override
  @JsonKey(name: 'sku')
  String? get sku;
  @override
  @JsonKey(name: 'barcode')
  String? get barcode;
  @override
  @JsonKey(name: 'unit_cost')
  double? get unitCost;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'last_counted_at')
  DateTime? get lastCountedAt;
  @override
  @JsonKey(name: 'last_counted_by')
  int? get lastCountedById;
  @override
  @JsonKey(name: 'last_counted_by_name')
  String? get lastCountedByName;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  List<String> get images;

  /// Create a copy of InventoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InventoryModelImplCopyWith<_$InventoryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InventoryTransactionModel _$InventoryTransactionModelFromJson(
    Map<String, dynamic> json) {
  return _InventoryTransactionModel.fromJson(json);
}

/// @nodoc
mixin _$InventoryTransactionModel {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'inventory_id')
  int get inventoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'inventory_name')
  String? get inventoryName => throw _privateConstructorUsedError;
  InventoryTransactionType get type => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'quantity_before')
  int? get quantityBefore => throw _privateConstructorUsedError;
  @JsonKey(name: 'quantity_after')
  int? get quantityAfter => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'property_id')
  int? get propertyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'property_name')
  String? get propertyName => throw _privateConstructorUsedError;
  @JsonKey(name: 'task_id')
  int? get taskId => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_by')
  int? get createdById => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_by_name')
  String? get createdByName => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this InventoryTransactionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InventoryTransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InventoryTransactionModelCopyWith<InventoryTransactionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InventoryTransactionModelCopyWith<$Res> {
  factory $InventoryTransactionModelCopyWith(InventoryTransactionModel value,
          $Res Function(InventoryTransactionModel) then) =
      _$InventoryTransactionModelCopyWithImpl<$Res, InventoryTransactionModel>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'inventory_id') int inventoryId,
      @JsonKey(name: 'inventory_name') String? inventoryName,
      InventoryTransactionType type,
      int quantity,
      @JsonKey(name: 'quantity_before') int? quantityBefore,
      @JsonKey(name: 'quantity_after') int? quantityAfter,
      String? notes,
      @JsonKey(name: 'property_id') int? propertyId,
      @JsonKey(name: 'property_name') String? propertyName,
      @JsonKey(name: 'task_id') int? taskId,
      @JsonKey(name: 'created_by') int? createdById,
      @JsonKey(name: 'created_by_name') String? createdByName,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class _$InventoryTransactionModelCopyWithImpl<$Res,
        $Val extends InventoryTransactionModel>
    implements $InventoryTransactionModelCopyWith<$Res> {
  _$InventoryTransactionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InventoryTransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? inventoryId = null,
    Object? inventoryName = freezed,
    Object? type = null,
    Object? quantity = null,
    Object? quantityBefore = freezed,
    Object? quantityAfter = freezed,
    Object? notes = freezed,
    Object? propertyId = freezed,
    Object? propertyName = freezed,
    Object? taskId = freezed,
    Object? createdById = freezed,
    Object? createdByName = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      inventoryId: null == inventoryId
          ? _value.inventoryId
          : inventoryId // ignore: cast_nullable_to_non_nullable
              as int,
      inventoryName: freezed == inventoryName
          ? _value.inventoryName
          : inventoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as InventoryTransactionType,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      quantityBefore: freezed == quantityBefore
          ? _value.quantityBefore
          : quantityBefore // ignore: cast_nullable_to_non_nullable
              as int?,
      quantityAfter: freezed == quantityAfter
          ? _value.quantityAfter
          : quantityAfter // ignore: cast_nullable_to_non_nullable
              as int?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      propertyId: freezed == propertyId
          ? _value.propertyId
          : propertyId // ignore: cast_nullable_to_non_nullable
              as int?,
      propertyName: freezed == propertyName
          ? _value.propertyName
          : propertyName // ignore: cast_nullable_to_non_nullable
              as String?,
      taskId: freezed == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as int?,
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
}

/// @nodoc
abstract class _$$InventoryTransactionModelImplCopyWith<$Res>
    implements $InventoryTransactionModelCopyWith<$Res> {
  factory _$$InventoryTransactionModelImplCopyWith(
          _$InventoryTransactionModelImpl value,
          $Res Function(_$InventoryTransactionModelImpl) then) =
      __$$InventoryTransactionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'inventory_id') int inventoryId,
      @JsonKey(name: 'inventory_name') String? inventoryName,
      InventoryTransactionType type,
      int quantity,
      @JsonKey(name: 'quantity_before') int? quantityBefore,
      @JsonKey(name: 'quantity_after') int? quantityAfter,
      String? notes,
      @JsonKey(name: 'property_id') int? propertyId,
      @JsonKey(name: 'property_name') String? propertyName,
      @JsonKey(name: 'task_id') int? taskId,
      @JsonKey(name: 'created_by') int? createdById,
      @JsonKey(name: 'created_by_name') String? createdByName,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class __$$InventoryTransactionModelImplCopyWithImpl<$Res>
    extends _$InventoryTransactionModelCopyWithImpl<$Res,
        _$InventoryTransactionModelImpl>
    implements _$$InventoryTransactionModelImplCopyWith<$Res> {
  __$$InventoryTransactionModelImplCopyWithImpl(
      _$InventoryTransactionModelImpl _value,
      $Res Function(_$InventoryTransactionModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of InventoryTransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? inventoryId = null,
    Object? inventoryName = freezed,
    Object? type = null,
    Object? quantity = null,
    Object? quantityBefore = freezed,
    Object? quantityAfter = freezed,
    Object? notes = freezed,
    Object? propertyId = freezed,
    Object? propertyName = freezed,
    Object? taskId = freezed,
    Object? createdById = freezed,
    Object? createdByName = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$InventoryTransactionModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      inventoryId: null == inventoryId
          ? _value.inventoryId
          : inventoryId // ignore: cast_nullable_to_non_nullable
              as int,
      inventoryName: freezed == inventoryName
          ? _value.inventoryName
          : inventoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as InventoryTransactionType,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      quantityBefore: freezed == quantityBefore
          ? _value.quantityBefore
          : quantityBefore // ignore: cast_nullable_to_non_nullable
              as int?,
      quantityAfter: freezed == quantityAfter
          ? _value.quantityAfter
          : quantityAfter // ignore: cast_nullable_to_non_nullable
              as int?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      propertyId: freezed == propertyId
          ? _value.propertyId
          : propertyId // ignore: cast_nullable_to_non_nullable
              as int?,
      propertyName: freezed == propertyName
          ? _value.propertyName
          : propertyName // ignore: cast_nullable_to_non_nullable
              as String?,
      taskId: freezed == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as int?,
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
class _$InventoryTransactionModelImpl extends _InventoryTransactionModel {
  const _$InventoryTransactionModelImpl(
      {required this.id,
      @JsonKey(name: 'inventory_id') required this.inventoryId,
      @JsonKey(name: 'inventory_name') this.inventoryName,
      required this.type,
      required this.quantity,
      @JsonKey(name: 'quantity_before') this.quantityBefore,
      @JsonKey(name: 'quantity_after') this.quantityAfter,
      this.notes,
      @JsonKey(name: 'property_id') this.propertyId,
      @JsonKey(name: 'property_name') this.propertyName,
      @JsonKey(name: 'task_id') this.taskId,
      @JsonKey(name: 'created_by') this.createdById,
      @JsonKey(name: 'created_by_name') this.createdByName,
      @JsonKey(name: 'created_at') this.createdAt})
      : super._();

  factory _$InventoryTransactionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$InventoryTransactionModelImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'inventory_id')
  final int inventoryId;
  @override
  @JsonKey(name: 'inventory_name')
  final String? inventoryName;
  @override
  final InventoryTransactionType type;
  @override
  final int quantity;
  @override
  @JsonKey(name: 'quantity_before')
  final int? quantityBefore;
  @override
  @JsonKey(name: 'quantity_after')
  final int? quantityAfter;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'property_id')
  final int? propertyId;
  @override
  @JsonKey(name: 'property_name')
  final String? propertyName;
  @override
  @JsonKey(name: 'task_id')
  final int? taskId;
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
    return 'InventoryTransactionModel(id: $id, inventoryId: $inventoryId, inventoryName: $inventoryName, type: $type, quantity: $quantity, quantityBefore: $quantityBefore, quantityAfter: $quantityAfter, notes: $notes, propertyId: $propertyId, propertyName: $propertyName, taskId: $taskId, createdById: $createdById, createdByName: $createdByName, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InventoryTransactionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.inventoryId, inventoryId) ||
                other.inventoryId == inventoryId) &&
            (identical(other.inventoryName, inventoryName) ||
                other.inventoryName == inventoryName) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.quantityBefore, quantityBefore) ||
                other.quantityBefore == quantityBefore) &&
            (identical(other.quantityAfter, quantityAfter) ||
                other.quantityAfter == quantityAfter) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.propertyId, propertyId) ||
                other.propertyId == propertyId) &&
            (identical(other.propertyName, propertyName) ||
                other.propertyName == propertyName) &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
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
      inventoryId,
      inventoryName,
      type,
      quantity,
      quantityBefore,
      quantityAfter,
      notes,
      propertyId,
      propertyName,
      taskId,
      createdById,
      createdByName,
      createdAt);

  /// Create a copy of InventoryTransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InventoryTransactionModelImplCopyWith<_$InventoryTransactionModelImpl>
      get copyWith => __$$InventoryTransactionModelImplCopyWithImpl<
          _$InventoryTransactionModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InventoryTransactionModelImplToJson(
      this,
    );
  }
}

abstract class _InventoryTransactionModel extends InventoryTransactionModel {
  const factory _InventoryTransactionModel(
          {required final int id,
          @JsonKey(name: 'inventory_id') required final int inventoryId,
          @JsonKey(name: 'inventory_name') final String? inventoryName,
          required final InventoryTransactionType type,
          required final int quantity,
          @JsonKey(name: 'quantity_before') final int? quantityBefore,
          @JsonKey(name: 'quantity_after') final int? quantityAfter,
          final String? notes,
          @JsonKey(name: 'property_id') final int? propertyId,
          @JsonKey(name: 'property_name') final String? propertyName,
          @JsonKey(name: 'task_id') final int? taskId,
          @JsonKey(name: 'created_by') final int? createdById,
          @JsonKey(name: 'created_by_name') final String? createdByName,
          @JsonKey(name: 'created_at') final DateTime? createdAt}) =
      _$InventoryTransactionModelImpl;
  const _InventoryTransactionModel._() : super._();

  factory _InventoryTransactionModel.fromJson(Map<String, dynamic> json) =
      _$InventoryTransactionModelImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'inventory_id')
  int get inventoryId;
  @override
  @JsonKey(name: 'inventory_name')
  String? get inventoryName;
  @override
  InventoryTransactionType get type;
  @override
  int get quantity;
  @override
  @JsonKey(name: 'quantity_before')
  int? get quantityBefore;
  @override
  @JsonKey(name: 'quantity_after')
  int? get quantityAfter;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'property_id')
  int? get propertyId;
  @override
  @JsonKey(name: 'property_name')
  String? get propertyName;
  @override
  @JsonKey(name: 'task_id')
  int? get taskId;
  @override
  @JsonKey(name: 'created_by')
  int? get createdById;
  @override
  @JsonKey(name: 'created_by_name')
  String? get createdByName;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of InventoryTransactionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InventoryTransactionModelImplCopyWith<_$InventoryTransactionModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

LowStockAlertModel _$LowStockAlertModelFromJson(Map<String, dynamic> json) {
  return _LowStockAlertModel.fromJson(json);
}

/// @nodoc
mixin _$LowStockAlertModel {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'inventory_id')
  int get inventoryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'inventory_name')
  String get inventoryName => throw _privateConstructorUsedError;
  InventoryCategory get category => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_quantity')
  int get currentQuantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'par_level')
  int? get parLevel => throw _privateConstructorUsedError;
  @JsonKey(name: 'reorder_point')
  int? get reorderPoint => throw _privateConstructorUsedError;
  @JsonKey(name: 'property_id')
  int? get propertyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'property_name')
  String? get propertyName => throw _privateConstructorUsedError;
  @JsonKey(name: 'shortage_amount')
  int? get shortageAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_critical')
  bool get isCritical => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this LowStockAlertModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LowStockAlertModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LowStockAlertModelCopyWith<LowStockAlertModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LowStockAlertModelCopyWith<$Res> {
  factory $LowStockAlertModelCopyWith(
          LowStockAlertModel value, $Res Function(LowStockAlertModel) then) =
      _$LowStockAlertModelCopyWithImpl<$Res, LowStockAlertModel>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'inventory_id') int inventoryId,
      @JsonKey(name: 'inventory_name') String inventoryName,
      InventoryCategory category,
      @JsonKey(name: 'current_quantity') int currentQuantity,
      @JsonKey(name: 'par_level') int? parLevel,
      @JsonKey(name: 'reorder_point') int? reorderPoint,
      @JsonKey(name: 'property_id') int? propertyId,
      @JsonKey(name: 'property_name') String? propertyName,
      @JsonKey(name: 'shortage_amount') int? shortageAmount,
      @JsonKey(name: 'is_critical') bool isCritical,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class _$LowStockAlertModelCopyWithImpl<$Res, $Val extends LowStockAlertModel>
    implements $LowStockAlertModelCopyWith<$Res> {
  _$LowStockAlertModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LowStockAlertModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? inventoryId = null,
    Object? inventoryName = null,
    Object? category = null,
    Object? currentQuantity = null,
    Object? parLevel = freezed,
    Object? reorderPoint = freezed,
    Object? propertyId = freezed,
    Object? propertyName = freezed,
    Object? shortageAmount = freezed,
    Object? isCritical = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      inventoryId: null == inventoryId
          ? _value.inventoryId
          : inventoryId // ignore: cast_nullable_to_non_nullable
              as int,
      inventoryName: null == inventoryName
          ? _value.inventoryName
          : inventoryName // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as InventoryCategory,
      currentQuantity: null == currentQuantity
          ? _value.currentQuantity
          : currentQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      parLevel: freezed == parLevel
          ? _value.parLevel
          : parLevel // ignore: cast_nullable_to_non_nullable
              as int?,
      reorderPoint: freezed == reorderPoint
          ? _value.reorderPoint
          : reorderPoint // ignore: cast_nullable_to_non_nullable
              as int?,
      propertyId: freezed == propertyId
          ? _value.propertyId
          : propertyId // ignore: cast_nullable_to_non_nullable
              as int?,
      propertyName: freezed == propertyName
          ? _value.propertyName
          : propertyName // ignore: cast_nullable_to_non_nullable
              as String?,
      shortageAmount: freezed == shortageAmount
          ? _value.shortageAmount
          : shortageAmount // ignore: cast_nullable_to_non_nullable
              as int?,
      isCritical: null == isCritical
          ? _value.isCritical
          : isCritical // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LowStockAlertModelImplCopyWith<$Res>
    implements $LowStockAlertModelCopyWith<$Res> {
  factory _$$LowStockAlertModelImplCopyWith(_$LowStockAlertModelImpl value,
          $Res Function(_$LowStockAlertModelImpl) then) =
      __$$LowStockAlertModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'inventory_id') int inventoryId,
      @JsonKey(name: 'inventory_name') String inventoryName,
      InventoryCategory category,
      @JsonKey(name: 'current_quantity') int currentQuantity,
      @JsonKey(name: 'par_level') int? parLevel,
      @JsonKey(name: 'reorder_point') int? reorderPoint,
      @JsonKey(name: 'property_id') int? propertyId,
      @JsonKey(name: 'property_name') String? propertyName,
      @JsonKey(name: 'shortage_amount') int? shortageAmount,
      @JsonKey(name: 'is_critical') bool isCritical,
      @JsonKey(name: 'created_at') DateTime? createdAt});
}

/// @nodoc
class __$$LowStockAlertModelImplCopyWithImpl<$Res>
    extends _$LowStockAlertModelCopyWithImpl<$Res, _$LowStockAlertModelImpl>
    implements _$$LowStockAlertModelImplCopyWith<$Res> {
  __$$LowStockAlertModelImplCopyWithImpl(_$LowStockAlertModelImpl _value,
      $Res Function(_$LowStockAlertModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of LowStockAlertModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? inventoryId = null,
    Object? inventoryName = null,
    Object? category = null,
    Object? currentQuantity = null,
    Object? parLevel = freezed,
    Object? reorderPoint = freezed,
    Object? propertyId = freezed,
    Object? propertyName = freezed,
    Object? shortageAmount = freezed,
    Object? isCritical = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$LowStockAlertModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      inventoryId: null == inventoryId
          ? _value.inventoryId
          : inventoryId // ignore: cast_nullable_to_non_nullable
              as int,
      inventoryName: null == inventoryName
          ? _value.inventoryName
          : inventoryName // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as InventoryCategory,
      currentQuantity: null == currentQuantity
          ? _value.currentQuantity
          : currentQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      parLevel: freezed == parLevel
          ? _value.parLevel
          : parLevel // ignore: cast_nullable_to_non_nullable
              as int?,
      reorderPoint: freezed == reorderPoint
          ? _value.reorderPoint
          : reorderPoint // ignore: cast_nullable_to_non_nullable
              as int?,
      propertyId: freezed == propertyId
          ? _value.propertyId
          : propertyId // ignore: cast_nullable_to_non_nullable
              as int?,
      propertyName: freezed == propertyName
          ? _value.propertyName
          : propertyName // ignore: cast_nullable_to_non_nullable
              as String?,
      shortageAmount: freezed == shortageAmount
          ? _value.shortageAmount
          : shortageAmount // ignore: cast_nullable_to_non_nullable
              as int?,
      isCritical: null == isCritical
          ? _value.isCritical
          : isCritical // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LowStockAlertModelImpl extends _LowStockAlertModel {
  const _$LowStockAlertModelImpl(
      {required this.id,
      @JsonKey(name: 'inventory_id') required this.inventoryId,
      @JsonKey(name: 'inventory_name') required this.inventoryName,
      required this.category,
      @JsonKey(name: 'current_quantity') required this.currentQuantity,
      @JsonKey(name: 'par_level') this.parLevel,
      @JsonKey(name: 'reorder_point') this.reorderPoint,
      @JsonKey(name: 'property_id') this.propertyId,
      @JsonKey(name: 'property_name') this.propertyName,
      @JsonKey(name: 'shortage_amount') this.shortageAmount,
      @JsonKey(name: 'is_critical') this.isCritical = false,
      @JsonKey(name: 'created_at') this.createdAt})
      : super._();

  factory _$LowStockAlertModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LowStockAlertModelImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'inventory_id')
  final int inventoryId;
  @override
  @JsonKey(name: 'inventory_name')
  final String inventoryName;
  @override
  final InventoryCategory category;
  @override
  @JsonKey(name: 'current_quantity')
  final int currentQuantity;
  @override
  @JsonKey(name: 'par_level')
  final int? parLevel;
  @override
  @JsonKey(name: 'reorder_point')
  final int? reorderPoint;
  @override
  @JsonKey(name: 'property_id')
  final int? propertyId;
  @override
  @JsonKey(name: 'property_name')
  final String? propertyName;
  @override
  @JsonKey(name: 'shortage_amount')
  final int? shortageAmount;
  @override
  @JsonKey(name: 'is_critical')
  final bool isCritical;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'LowStockAlertModel(id: $id, inventoryId: $inventoryId, inventoryName: $inventoryName, category: $category, currentQuantity: $currentQuantity, parLevel: $parLevel, reorderPoint: $reorderPoint, propertyId: $propertyId, propertyName: $propertyName, shortageAmount: $shortageAmount, isCritical: $isCritical, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LowStockAlertModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.inventoryId, inventoryId) ||
                other.inventoryId == inventoryId) &&
            (identical(other.inventoryName, inventoryName) ||
                other.inventoryName == inventoryName) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.currentQuantity, currentQuantity) ||
                other.currentQuantity == currentQuantity) &&
            (identical(other.parLevel, parLevel) ||
                other.parLevel == parLevel) &&
            (identical(other.reorderPoint, reorderPoint) ||
                other.reorderPoint == reorderPoint) &&
            (identical(other.propertyId, propertyId) ||
                other.propertyId == propertyId) &&
            (identical(other.propertyName, propertyName) ||
                other.propertyName == propertyName) &&
            (identical(other.shortageAmount, shortageAmount) ||
                other.shortageAmount == shortageAmount) &&
            (identical(other.isCritical, isCritical) ||
                other.isCritical == isCritical) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      inventoryId,
      inventoryName,
      category,
      currentQuantity,
      parLevel,
      reorderPoint,
      propertyId,
      propertyName,
      shortageAmount,
      isCritical,
      createdAt);

  /// Create a copy of LowStockAlertModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LowStockAlertModelImplCopyWith<_$LowStockAlertModelImpl> get copyWith =>
      __$$LowStockAlertModelImplCopyWithImpl<_$LowStockAlertModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LowStockAlertModelImplToJson(
      this,
    );
  }
}

abstract class _LowStockAlertModel extends LowStockAlertModel {
  const factory _LowStockAlertModel(
          {required final int id,
          @JsonKey(name: 'inventory_id') required final int inventoryId,
          @JsonKey(name: 'inventory_name') required final String inventoryName,
          required final InventoryCategory category,
          @JsonKey(name: 'current_quantity') required final int currentQuantity,
          @JsonKey(name: 'par_level') final int? parLevel,
          @JsonKey(name: 'reorder_point') final int? reorderPoint,
          @JsonKey(name: 'property_id') final int? propertyId,
          @JsonKey(name: 'property_name') final String? propertyName,
          @JsonKey(name: 'shortage_amount') final int? shortageAmount,
          @JsonKey(name: 'is_critical') final bool isCritical,
          @JsonKey(name: 'created_at') final DateTime? createdAt}) =
      _$LowStockAlertModelImpl;
  const _LowStockAlertModel._() : super._();

  factory _LowStockAlertModel.fromJson(Map<String, dynamic> json) =
      _$LowStockAlertModelImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'inventory_id')
  int get inventoryId;
  @override
  @JsonKey(name: 'inventory_name')
  String get inventoryName;
  @override
  InventoryCategory get category;
  @override
  @JsonKey(name: 'current_quantity')
  int get currentQuantity;
  @override
  @JsonKey(name: 'par_level')
  int? get parLevel;
  @override
  @JsonKey(name: 'reorder_point')
  int? get reorderPoint;
  @override
  @JsonKey(name: 'property_id')
  int? get propertyId;
  @override
  @JsonKey(name: 'property_name')
  String? get propertyName;
  @override
  @JsonKey(name: 'shortage_amount')
  int? get shortageAmount;
  @override
  @JsonKey(name: 'is_critical')
  bool get isCritical;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of LowStockAlertModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LowStockAlertModelImplCopyWith<_$LowStockAlertModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
