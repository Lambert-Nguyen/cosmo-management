// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'property_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PropertyModel _$PropertyModelFromJson(Map<String, dynamic> json) {
  return _PropertyModel.fromJson(json);
}

/// @nodoc
mixin _$PropertyModel {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'property_type')
  String? get propertyType => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get state => throw _privateConstructorUsedError;
  @JsonKey(name: 'zip_code')
  String? get zipCode => throw _privateConstructorUsedError;
  String? get country => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_number')
  String? get unitNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'floor_number')
  int? get floorNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'square_feet')
  double? get squareFeet => throw _privateConstructorUsedError;
  int? get bedrooms => throw _privateConstructorUsedError;
  int? get bathrooms => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_occupancy')
  int? get maxOccupancy => throw _privateConstructorUsedError;
  PropertyStatus get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @JsonKey(name: 'primary_image')
  String? get primaryImage => throw _privateConstructorUsedError;
  List<String> get images => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'manager_id')
  int? get managerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'manager_name')
  String? get managerName => throw _privateConstructorUsedError;

  /// Serializes this PropertyModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PropertyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PropertyModelCopyWith<PropertyModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PropertyModelCopyWith<$Res> {
  factory $PropertyModelCopyWith(
          PropertyModel value, $Res Function(PropertyModel) then) =
      _$PropertyModelCopyWithImpl<$Res, PropertyModel>;
  @useResult
  $Res call(
      {int id,
      String name,
      String? description,
      @JsonKey(name: 'property_type') String? propertyType,
      String? address,
      String? city,
      String? state,
      @JsonKey(name: 'zip_code') String? zipCode,
      String? country,
      @JsonKey(name: 'unit_number') String? unitNumber,
      @JsonKey(name: 'floor_number') int? floorNumber,
      @JsonKey(name: 'square_feet') double? squareFeet,
      int? bedrooms,
      int? bathrooms,
      @JsonKey(name: 'max_occupancy') int? maxOccupancy,
      PropertyStatus status,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'primary_image') String? primaryImage,
      List<String> images,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'manager_id') int? managerId,
      @JsonKey(name: 'manager_name') String? managerName});
}

/// @nodoc
class _$PropertyModelCopyWithImpl<$Res, $Val extends PropertyModel>
    implements $PropertyModelCopyWith<$Res> {
  _$PropertyModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PropertyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? propertyType = freezed,
    Object? address = freezed,
    Object? city = freezed,
    Object? state = freezed,
    Object? zipCode = freezed,
    Object? country = freezed,
    Object? unitNumber = freezed,
    Object? floorNumber = freezed,
    Object? squareFeet = freezed,
    Object? bedrooms = freezed,
    Object? bathrooms = freezed,
    Object? maxOccupancy = freezed,
    Object? status = null,
    Object? isActive = null,
    Object? primaryImage = freezed,
    Object? images = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? managerId = freezed,
    Object? managerName = freezed,
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
      propertyType: freezed == propertyType
          ? _value.propertyType
          : propertyType // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
      zipCode: freezed == zipCode
          ? _value.zipCode
          : zipCode // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      unitNumber: freezed == unitNumber
          ? _value.unitNumber
          : unitNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      floorNumber: freezed == floorNumber
          ? _value.floorNumber
          : floorNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      squareFeet: freezed == squareFeet
          ? _value.squareFeet
          : squareFeet // ignore: cast_nullable_to_non_nullable
              as double?,
      bedrooms: freezed == bedrooms
          ? _value.bedrooms
          : bedrooms // ignore: cast_nullable_to_non_nullable
              as int?,
      bathrooms: freezed == bathrooms
          ? _value.bathrooms
          : bathrooms // ignore: cast_nullable_to_non_nullable
              as int?,
      maxOccupancy: freezed == maxOccupancy
          ? _value.maxOccupancy
          : maxOccupancy // ignore: cast_nullable_to_non_nullable
              as int?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PropertyStatus,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      primaryImage: freezed == primaryImage
          ? _value.primaryImage
          : primaryImage // ignore: cast_nullable_to_non_nullable
              as String?,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      managerId: freezed == managerId
          ? _value.managerId
          : managerId // ignore: cast_nullable_to_non_nullable
              as int?,
      managerName: freezed == managerName
          ? _value.managerName
          : managerName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PropertyModelImplCopyWith<$Res>
    implements $PropertyModelCopyWith<$Res> {
  factory _$$PropertyModelImplCopyWith(
          _$PropertyModelImpl value, $Res Function(_$PropertyModelImpl) then) =
      __$$PropertyModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      String? description,
      @JsonKey(name: 'property_type') String? propertyType,
      String? address,
      String? city,
      String? state,
      @JsonKey(name: 'zip_code') String? zipCode,
      String? country,
      @JsonKey(name: 'unit_number') String? unitNumber,
      @JsonKey(name: 'floor_number') int? floorNumber,
      @JsonKey(name: 'square_feet') double? squareFeet,
      int? bedrooms,
      int? bathrooms,
      @JsonKey(name: 'max_occupancy') int? maxOccupancy,
      PropertyStatus status,
      @JsonKey(name: 'is_active') bool isActive,
      @JsonKey(name: 'primary_image') String? primaryImage,
      List<String> images,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'manager_id') int? managerId,
      @JsonKey(name: 'manager_name') String? managerName});
}

/// @nodoc
class __$$PropertyModelImplCopyWithImpl<$Res>
    extends _$PropertyModelCopyWithImpl<$Res, _$PropertyModelImpl>
    implements _$$PropertyModelImplCopyWith<$Res> {
  __$$PropertyModelImplCopyWithImpl(
      _$PropertyModelImpl _value, $Res Function(_$PropertyModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of PropertyModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? propertyType = freezed,
    Object? address = freezed,
    Object? city = freezed,
    Object? state = freezed,
    Object? zipCode = freezed,
    Object? country = freezed,
    Object? unitNumber = freezed,
    Object? floorNumber = freezed,
    Object? squareFeet = freezed,
    Object? bedrooms = freezed,
    Object? bathrooms = freezed,
    Object? maxOccupancy = freezed,
    Object? status = null,
    Object? isActive = null,
    Object? primaryImage = freezed,
    Object? images = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? managerId = freezed,
    Object? managerName = freezed,
  }) {
    return _then(_$PropertyModelImpl(
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
      propertyType: freezed == propertyType
          ? _value.propertyType
          : propertyType // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
      zipCode: freezed == zipCode
          ? _value.zipCode
          : zipCode // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      unitNumber: freezed == unitNumber
          ? _value.unitNumber
          : unitNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      floorNumber: freezed == floorNumber
          ? _value.floorNumber
          : floorNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      squareFeet: freezed == squareFeet
          ? _value.squareFeet
          : squareFeet // ignore: cast_nullable_to_non_nullable
              as double?,
      bedrooms: freezed == bedrooms
          ? _value.bedrooms
          : bedrooms // ignore: cast_nullable_to_non_nullable
              as int?,
      bathrooms: freezed == bathrooms
          ? _value.bathrooms
          : bathrooms // ignore: cast_nullable_to_non_nullable
              as int?,
      maxOccupancy: freezed == maxOccupancy
          ? _value.maxOccupancy
          : maxOccupancy // ignore: cast_nullable_to_non_nullable
              as int?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PropertyStatus,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      primaryImage: freezed == primaryImage
          ? _value.primaryImage
          : primaryImage // ignore: cast_nullable_to_non_nullable
              as String?,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      managerId: freezed == managerId
          ? _value.managerId
          : managerId // ignore: cast_nullable_to_non_nullable
              as int?,
      managerName: freezed == managerName
          ? _value.managerName
          : managerName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PropertyModelImpl extends _PropertyModel {
  const _$PropertyModelImpl(
      {required this.id,
      required this.name,
      this.description,
      @JsonKey(name: 'property_type') this.propertyType,
      this.address,
      this.city,
      this.state,
      @JsonKey(name: 'zip_code') this.zipCode,
      this.country,
      @JsonKey(name: 'unit_number') this.unitNumber,
      @JsonKey(name: 'floor_number') this.floorNumber,
      @JsonKey(name: 'square_feet') this.squareFeet,
      this.bedrooms,
      this.bathrooms,
      @JsonKey(name: 'max_occupancy') this.maxOccupancy,
      this.status = PropertyStatus.available,
      @JsonKey(name: 'is_active') this.isActive = true,
      @JsonKey(name: 'primary_image') this.primaryImage,
      final List<String> images = const [],
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'manager_id') this.managerId,
      @JsonKey(name: 'manager_name') this.managerName})
      : _images = images,
        super._();

  factory _$PropertyModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PropertyModelImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey(name: 'property_type')
  final String? propertyType;
  @override
  final String? address;
  @override
  final String? city;
  @override
  final String? state;
  @override
  @JsonKey(name: 'zip_code')
  final String? zipCode;
  @override
  final String? country;
  @override
  @JsonKey(name: 'unit_number')
  final String? unitNumber;
  @override
  @JsonKey(name: 'floor_number')
  final int? floorNumber;
  @override
  @JsonKey(name: 'square_feet')
  final double? squareFeet;
  @override
  final int? bedrooms;
  @override
  final int? bathrooms;
  @override
  @JsonKey(name: 'max_occupancy')
  final int? maxOccupancy;
  @override
  @JsonKey()
  final PropertyStatus status;
  @override
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @JsonKey(name: 'primary_image')
  final String? primaryImage;
  final List<String> _images;
  @override
  @JsonKey()
  List<String> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @override
  @JsonKey(name: 'manager_id')
  final int? managerId;
  @override
  @JsonKey(name: 'manager_name')
  final String? managerName;

  @override
  String toString() {
    return 'PropertyModel(id: $id, name: $name, description: $description, propertyType: $propertyType, address: $address, city: $city, state: $state, zipCode: $zipCode, country: $country, unitNumber: $unitNumber, floorNumber: $floorNumber, squareFeet: $squareFeet, bedrooms: $bedrooms, bathrooms: $bathrooms, maxOccupancy: $maxOccupancy, status: $status, isActive: $isActive, primaryImage: $primaryImage, images: $images, createdAt: $createdAt, updatedAt: $updatedAt, managerId: $managerId, managerName: $managerName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PropertyModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.propertyType, propertyType) ||
                other.propertyType == propertyType) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.zipCode, zipCode) || other.zipCode == zipCode) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.unitNumber, unitNumber) ||
                other.unitNumber == unitNumber) &&
            (identical(other.floorNumber, floorNumber) ||
                other.floorNumber == floorNumber) &&
            (identical(other.squareFeet, squareFeet) ||
                other.squareFeet == squareFeet) &&
            (identical(other.bedrooms, bedrooms) ||
                other.bedrooms == bedrooms) &&
            (identical(other.bathrooms, bathrooms) ||
                other.bathrooms == bathrooms) &&
            (identical(other.maxOccupancy, maxOccupancy) ||
                other.maxOccupancy == maxOccupancy) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.primaryImage, primaryImage) ||
                other.primaryImage == primaryImage) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.managerId, managerId) ||
                other.managerId == managerId) &&
            (identical(other.managerName, managerName) ||
                other.managerName == managerName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        description,
        propertyType,
        address,
        city,
        state,
        zipCode,
        country,
        unitNumber,
        floorNumber,
        squareFeet,
        bedrooms,
        bathrooms,
        maxOccupancy,
        status,
        isActive,
        primaryImage,
        const DeepCollectionEquality().hash(_images),
        createdAt,
        updatedAt,
        managerId,
        managerName
      ]);

  /// Create a copy of PropertyModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PropertyModelImplCopyWith<_$PropertyModelImpl> get copyWith =>
      __$$PropertyModelImplCopyWithImpl<_$PropertyModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PropertyModelImplToJson(
      this,
    );
  }
}

abstract class _PropertyModel extends PropertyModel {
  const factory _PropertyModel(
          {required final int id,
          required final String name,
          final String? description,
          @JsonKey(name: 'property_type') final String? propertyType,
          final String? address,
          final String? city,
          final String? state,
          @JsonKey(name: 'zip_code') final String? zipCode,
          final String? country,
          @JsonKey(name: 'unit_number') final String? unitNumber,
          @JsonKey(name: 'floor_number') final int? floorNumber,
          @JsonKey(name: 'square_feet') final double? squareFeet,
          final int? bedrooms,
          final int? bathrooms,
          @JsonKey(name: 'max_occupancy') final int? maxOccupancy,
          final PropertyStatus status,
          @JsonKey(name: 'is_active') final bool isActive,
          @JsonKey(name: 'primary_image') final String? primaryImage,
          final List<String> images,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt,
          @JsonKey(name: 'manager_id') final int? managerId,
          @JsonKey(name: 'manager_name') final String? managerName}) =
      _$PropertyModelImpl;
  const _PropertyModel._() : super._();

  factory _PropertyModel.fromJson(Map<String, dynamic> json) =
      _$PropertyModelImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  @JsonKey(name: 'property_type')
  String? get propertyType;
  @override
  String? get address;
  @override
  String? get city;
  @override
  String? get state;
  @override
  @JsonKey(name: 'zip_code')
  String? get zipCode;
  @override
  String? get country;
  @override
  @JsonKey(name: 'unit_number')
  String? get unitNumber;
  @override
  @JsonKey(name: 'floor_number')
  int? get floorNumber;
  @override
  @JsonKey(name: 'square_feet')
  double? get squareFeet;
  @override
  int? get bedrooms;
  @override
  int? get bathrooms;
  @override
  @JsonKey(name: 'max_occupancy')
  int? get maxOccupancy;
  @override
  PropertyStatus get status;
  @override
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @JsonKey(name: 'primary_image')
  String? get primaryImage;
  @override
  List<String> get images;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(name: 'manager_id')
  int? get managerId;
  @override
  @JsonKey(name: 'manager_name')
  String? get managerName;

  /// Create a copy of PropertyModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PropertyModelImplCopyWith<_$PropertyModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
