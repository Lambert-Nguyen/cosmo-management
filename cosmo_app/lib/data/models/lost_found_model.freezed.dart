// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lost_found_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LostFoundModel _$LostFoundModelFromJson(Map<String, dynamic> json) {
  return _LostFoundModel.fromJson(json);
}

/// @nodoc
mixin _$LostFoundModel {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  LostFoundStatus get status => throw _privateConstructorUsedError;
  LostFoundCategory get category => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_found')
  String? get locationFound => throw _privateConstructorUsedError;
  @JsonKey(name: 'location_description')
  String? get locationDescription => throw _privateConstructorUsedError;
  @JsonKey(name: 'property_id')
  int? get propertyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'property_name')
  String? get propertyName => throw _privateConstructorUsedError;
  @JsonKey(name: 'date_found')
  DateTime? get dateFound => throw _privateConstructorUsedError;
  @JsonKey(name: 'date_lost')
  DateTime? get dateLost => throw _privateConstructorUsedError;
  @JsonKey(name: 'reported_by')
  int? get reportedById => throw _privateConstructorUsedError;
  @JsonKey(name: 'reported_by_name')
  String? get reportedByName => throw _privateConstructorUsedError;
  @JsonKey(name: 'claimed_by')
  int? get claimedById => throw _privateConstructorUsedError;
  @JsonKey(name: 'claimed_by_name')
  String? get claimedByName => throw _privateConstructorUsedError;
  @JsonKey(name: 'claimed_at')
  DateTime? get claimedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'claimant_contact')
  String? get claimantContact => throw _privateConstructorUsedError;
  @JsonKey(name: 'storage_location')
  String? get storageLocation => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_valuable')
  bool get isValuable => throw _privateConstructorUsedError;
  @JsonKey(name: 'estimated_value')
  double? get estimatedValue => throw _privateConstructorUsedError;
  List<String> get images => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'expires_at')
  DateTime? get expiresAt => throw _privateConstructorUsedError;

  /// Serializes this LostFoundModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LostFoundModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LostFoundModelCopyWith<LostFoundModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LostFoundModelCopyWith<$Res> {
  factory $LostFoundModelCopyWith(
          LostFoundModel value, $Res Function(LostFoundModel) then) =
      _$LostFoundModelCopyWithImpl<$Res, LostFoundModel>;
  @useResult
  $Res call(
      {int id,
      String title,
      String? description,
      LostFoundStatus status,
      LostFoundCategory category,
      @JsonKey(name: 'location_found') String? locationFound,
      @JsonKey(name: 'location_description') String? locationDescription,
      @JsonKey(name: 'property_id') int? propertyId,
      @JsonKey(name: 'property_name') String? propertyName,
      @JsonKey(name: 'date_found') DateTime? dateFound,
      @JsonKey(name: 'date_lost') DateTime? dateLost,
      @JsonKey(name: 'reported_by') int? reportedById,
      @JsonKey(name: 'reported_by_name') String? reportedByName,
      @JsonKey(name: 'claimed_by') int? claimedById,
      @JsonKey(name: 'claimed_by_name') String? claimedByName,
      @JsonKey(name: 'claimed_at') DateTime? claimedAt,
      @JsonKey(name: 'claimant_contact') String? claimantContact,
      @JsonKey(name: 'storage_location') String? storageLocation,
      @JsonKey(name: 'is_valuable') bool isValuable,
      @JsonKey(name: 'estimated_value') double? estimatedValue,
      List<String> images,
      String? notes,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'expires_at') DateTime? expiresAt});
}

/// @nodoc
class _$LostFoundModelCopyWithImpl<$Res, $Val extends LostFoundModel>
    implements $LostFoundModelCopyWith<$Res> {
  _$LostFoundModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LostFoundModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? status = null,
    Object? category = null,
    Object? locationFound = freezed,
    Object? locationDescription = freezed,
    Object? propertyId = freezed,
    Object? propertyName = freezed,
    Object? dateFound = freezed,
    Object? dateLost = freezed,
    Object? reportedById = freezed,
    Object? reportedByName = freezed,
    Object? claimedById = freezed,
    Object? claimedByName = freezed,
    Object? claimedAt = freezed,
    Object? claimantContact = freezed,
    Object? storageLocation = freezed,
    Object? isValuable = null,
    Object? estimatedValue = freezed,
    Object? images = null,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? expiresAt = freezed,
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
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as LostFoundStatus,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as LostFoundCategory,
      locationFound: freezed == locationFound
          ? _value.locationFound
          : locationFound // ignore: cast_nullable_to_non_nullable
              as String?,
      locationDescription: freezed == locationDescription
          ? _value.locationDescription
          : locationDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      propertyId: freezed == propertyId
          ? _value.propertyId
          : propertyId // ignore: cast_nullable_to_non_nullable
              as int?,
      propertyName: freezed == propertyName
          ? _value.propertyName
          : propertyName // ignore: cast_nullable_to_non_nullable
              as String?,
      dateFound: freezed == dateFound
          ? _value.dateFound
          : dateFound // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      dateLost: freezed == dateLost
          ? _value.dateLost
          : dateLost // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reportedById: freezed == reportedById
          ? _value.reportedById
          : reportedById // ignore: cast_nullable_to_non_nullable
              as int?,
      reportedByName: freezed == reportedByName
          ? _value.reportedByName
          : reportedByName // ignore: cast_nullable_to_non_nullable
              as String?,
      claimedById: freezed == claimedById
          ? _value.claimedById
          : claimedById // ignore: cast_nullable_to_non_nullable
              as int?,
      claimedByName: freezed == claimedByName
          ? _value.claimedByName
          : claimedByName // ignore: cast_nullable_to_non_nullable
              as String?,
      claimedAt: freezed == claimedAt
          ? _value.claimedAt
          : claimedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      claimantContact: freezed == claimantContact
          ? _value.claimantContact
          : claimantContact // ignore: cast_nullable_to_non_nullable
              as String?,
      storageLocation: freezed == storageLocation
          ? _value.storageLocation
          : storageLocation // ignore: cast_nullable_to_non_nullable
              as String?,
      isValuable: null == isValuable
          ? _value.isValuable
          : isValuable // ignore: cast_nullable_to_non_nullable
              as bool,
      estimatedValue: freezed == estimatedValue
          ? _value.estimatedValue
          : estimatedValue // ignore: cast_nullable_to_non_nullable
              as double?,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LostFoundModelImplCopyWith<$Res>
    implements $LostFoundModelCopyWith<$Res> {
  factory _$$LostFoundModelImplCopyWith(_$LostFoundModelImpl value,
          $Res Function(_$LostFoundModelImpl) then) =
      __$$LostFoundModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      String? description,
      LostFoundStatus status,
      LostFoundCategory category,
      @JsonKey(name: 'location_found') String? locationFound,
      @JsonKey(name: 'location_description') String? locationDescription,
      @JsonKey(name: 'property_id') int? propertyId,
      @JsonKey(name: 'property_name') String? propertyName,
      @JsonKey(name: 'date_found') DateTime? dateFound,
      @JsonKey(name: 'date_lost') DateTime? dateLost,
      @JsonKey(name: 'reported_by') int? reportedById,
      @JsonKey(name: 'reported_by_name') String? reportedByName,
      @JsonKey(name: 'claimed_by') int? claimedById,
      @JsonKey(name: 'claimed_by_name') String? claimedByName,
      @JsonKey(name: 'claimed_at') DateTime? claimedAt,
      @JsonKey(name: 'claimant_contact') String? claimantContact,
      @JsonKey(name: 'storage_location') String? storageLocation,
      @JsonKey(name: 'is_valuable') bool isValuable,
      @JsonKey(name: 'estimated_value') double? estimatedValue,
      List<String> images,
      String? notes,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'expires_at') DateTime? expiresAt});
}

/// @nodoc
class __$$LostFoundModelImplCopyWithImpl<$Res>
    extends _$LostFoundModelCopyWithImpl<$Res, _$LostFoundModelImpl>
    implements _$$LostFoundModelImplCopyWith<$Res> {
  __$$LostFoundModelImplCopyWithImpl(
      _$LostFoundModelImpl _value, $Res Function(_$LostFoundModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of LostFoundModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? status = null,
    Object? category = null,
    Object? locationFound = freezed,
    Object? locationDescription = freezed,
    Object? propertyId = freezed,
    Object? propertyName = freezed,
    Object? dateFound = freezed,
    Object? dateLost = freezed,
    Object? reportedById = freezed,
    Object? reportedByName = freezed,
    Object? claimedById = freezed,
    Object? claimedByName = freezed,
    Object? claimedAt = freezed,
    Object? claimantContact = freezed,
    Object? storageLocation = freezed,
    Object? isValuable = null,
    Object? estimatedValue = freezed,
    Object? images = null,
    Object? notes = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? expiresAt = freezed,
  }) {
    return _then(_$LostFoundModelImpl(
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
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as LostFoundStatus,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as LostFoundCategory,
      locationFound: freezed == locationFound
          ? _value.locationFound
          : locationFound // ignore: cast_nullable_to_non_nullable
              as String?,
      locationDescription: freezed == locationDescription
          ? _value.locationDescription
          : locationDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      propertyId: freezed == propertyId
          ? _value.propertyId
          : propertyId // ignore: cast_nullable_to_non_nullable
              as int?,
      propertyName: freezed == propertyName
          ? _value.propertyName
          : propertyName // ignore: cast_nullable_to_non_nullable
              as String?,
      dateFound: freezed == dateFound
          ? _value.dateFound
          : dateFound // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      dateLost: freezed == dateLost
          ? _value.dateLost
          : dateLost // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      reportedById: freezed == reportedById
          ? _value.reportedById
          : reportedById // ignore: cast_nullable_to_non_nullable
              as int?,
      reportedByName: freezed == reportedByName
          ? _value.reportedByName
          : reportedByName // ignore: cast_nullable_to_non_nullable
              as String?,
      claimedById: freezed == claimedById
          ? _value.claimedById
          : claimedById // ignore: cast_nullable_to_non_nullable
              as int?,
      claimedByName: freezed == claimedByName
          ? _value.claimedByName
          : claimedByName // ignore: cast_nullable_to_non_nullable
              as String?,
      claimedAt: freezed == claimedAt
          ? _value.claimedAt
          : claimedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      claimantContact: freezed == claimantContact
          ? _value.claimantContact
          : claimantContact // ignore: cast_nullable_to_non_nullable
              as String?,
      storageLocation: freezed == storageLocation
          ? _value.storageLocation
          : storageLocation // ignore: cast_nullable_to_non_nullable
              as String?,
      isValuable: null == isValuable
          ? _value.isValuable
          : isValuable // ignore: cast_nullable_to_non_nullable
              as bool,
      estimatedValue: freezed == estimatedValue
          ? _value.estimatedValue
          : estimatedValue // ignore: cast_nullable_to_non_nullable
              as double?,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<String>,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LostFoundModelImpl extends _LostFoundModel {
  const _$LostFoundModelImpl(
      {required this.id,
      required this.title,
      this.description,
      this.status = LostFoundStatus.found,
      this.category = LostFoundCategory.other,
      @JsonKey(name: 'location_found') this.locationFound,
      @JsonKey(name: 'location_description') this.locationDescription,
      @JsonKey(name: 'property_id') this.propertyId,
      @JsonKey(name: 'property_name') this.propertyName,
      @JsonKey(name: 'date_found') this.dateFound,
      @JsonKey(name: 'date_lost') this.dateLost,
      @JsonKey(name: 'reported_by') this.reportedById,
      @JsonKey(name: 'reported_by_name') this.reportedByName,
      @JsonKey(name: 'claimed_by') this.claimedById,
      @JsonKey(name: 'claimed_by_name') this.claimedByName,
      @JsonKey(name: 'claimed_at') this.claimedAt,
      @JsonKey(name: 'claimant_contact') this.claimantContact,
      @JsonKey(name: 'storage_location') this.storageLocation,
      @JsonKey(name: 'is_valuable') this.isValuable = false,
      @JsonKey(name: 'estimated_value') this.estimatedValue,
      final List<String> images = const [],
      this.notes,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'expires_at') this.expiresAt})
      : _images = images,
        super._();

  factory _$LostFoundModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LostFoundModelImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String? description;
  @override
  @JsonKey()
  final LostFoundStatus status;
  @override
  @JsonKey()
  final LostFoundCategory category;
  @override
  @JsonKey(name: 'location_found')
  final String? locationFound;
  @override
  @JsonKey(name: 'location_description')
  final String? locationDescription;
  @override
  @JsonKey(name: 'property_id')
  final int? propertyId;
  @override
  @JsonKey(name: 'property_name')
  final String? propertyName;
  @override
  @JsonKey(name: 'date_found')
  final DateTime? dateFound;
  @override
  @JsonKey(name: 'date_lost')
  final DateTime? dateLost;
  @override
  @JsonKey(name: 'reported_by')
  final int? reportedById;
  @override
  @JsonKey(name: 'reported_by_name')
  final String? reportedByName;
  @override
  @JsonKey(name: 'claimed_by')
  final int? claimedById;
  @override
  @JsonKey(name: 'claimed_by_name')
  final String? claimedByName;
  @override
  @JsonKey(name: 'claimed_at')
  final DateTime? claimedAt;
  @override
  @JsonKey(name: 'claimant_contact')
  final String? claimantContact;
  @override
  @JsonKey(name: 'storage_location')
  final String? storageLocation;
  @override
  @JsonKey(name: 'is_valuable')
  final bool isValuable;
  @override
  @JsonKey(name: 'estimated_value')
  final double? estimatedValue;
  final List<String> _images;
  @override
  @JsonKey()
  List<String> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  final String? notes;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @override
  @JsonKey(name: 'expires_at')
  final DateTime? expiresAt;

  @override
  String toString() {
    return 'LostFoundModel(id: $id, title: $title, description: $description, status: $status, category: $category, locationFound: $locationFound, locationDescription: $locationDescription, propertyId: $propertyId, propertyName: $propertyName, dateFound: $dateFound, dateLost: $dateLost, reportedById: $reportedById, reportedByName: $reportedByName, claimedById: $claimedById, claimedByName: $claimedByName, claimedAt: $claimedAt, claimantContact: $claimantContact, storageLocation: $storageLocation, isValuable: $isValuable, estimatedValue: $estimatedValue, images: $images, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LostFoundModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.locationFound, locationFound) ||
                other.locationFound == locationFound) &&
            (identical(other.locationDescription, locationDescription) ||
                other.locationDescription == locationDescription) &&
            (identical(other.propertyId, propertyId) ||
                other.propertyId == propertyId) &&
            (identical(other.propertyName, propertyName) ||
                other.propertyName == propertyName) &&
            (identical(other.dateFound, dateFound) ||
                other.dateFound == dateFound) &&
            (identical(other.dateLost, dateLost) ||
                other.dateLost == dateLost) &&
            (identical(other.reportedById, reportedById) ||
                other.reportedById == reportedById) &&
            (identical(other.reportedByName, reportedByName) ||
                other.reportedByName == reportedByName) &&
            (identical(other.claimedById, claimedById) ||
                other.claimedById == claimedById) &&
            (identical(other.claimedByName, claimedByName) ||
                other.claimedByName == claimedByName) &&
            (identical(other.claimedAt, claimedAt) ||
                other.claimedAt == claimedAt) &&
            (identical(other.claimantContact, claimantContact) ||
                other.claimantContact == claimantContact) &&
            (identical(other.storageLocation, storageLocation) ||
                other.storageLocation == storageLocation) &&
            (identical(other.isValuable, isValuable) ||
                other.isValuable == isValuable) &&
            (identical(other.estimatedValue, estimatedValue) ||
                other.estimatedValue == estimatedValue) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        title,
        description,
        status,
        category,
        locationFound,
        locationDescription,
        propertyId,
        propertyName,
        dateFound,
        dateLost,
        reportedById,
        reportedByName,
        claimedById,
        claimedByName,
        claimedAt,
        claimantContact,
        storageLocation,
        isValuable,
        estimatedValue,
        const DeepCollectionEquality().hash(_images),
        notes,
        createdAt,
        updatedAt,
        expiresAt
      ]);

  /// Create a copy of LostFoundModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LostFoundModelImplCopyWith<_$LostFoundModelImpl> get copyWith =>
      __$$LostFoundModelImplCopyWithImpl<_$LostFoundModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LostFoundModelImplToJson(
      this,
    );
  }
}

abstract class _LostFoundModel extends LostFoundModel {
  const factory _LostFoundModel(
      {required final int id,
      required final String title,
      final String? description,
      final LostFoundStatus status,
      final LostFoundCategory category,
      @JsonKey(name: 'location_found') final String? locationFound,
      @JsonKey(name: 'location_description') final String? locationDescription,
      @JsonKey(name: 'property_id') final int? propertyId,
      @JsonKey(name: 'property_name') final String? propertyName,
      @JsonKey(name: 'date_found') final DateTime? dateFound,
      @JsonKey(name: 'date_lost') final DateTime? dateLost,
      @JsonKey(name: 'reported_by') final int? reportedById,
      @JsonKey(name: 'reported_by_name') final String? reportedByName,
      @JsonKey(name: 'claimed_by') final int? claimedById,
      @JsonKey(name: 'claimed_by_name') final String? claimedByName,
      @JsonKey(name: 'claimed_at') final DateTime? claimedAt,
      @JsonKey(name: 'claimant_contact') final String? claimantContact,
      @JsonKey(name: 'storage_location') final String? storageLocation,
      @JsonKey(name: 'is_valuable') final bool isValuable,
      @JsonKey(name: 'estimated_value') final double? estimatedValue,
      final List<String> images,
      final String? notes,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at') final DateTime? updatedAt,
      @JsonKey(name: 'expires_at')
      final DateTime? expiresAt}) = _$LostFoundModelImpl;
  const _LostFoundModel._() : super._();

  factory _LostFoundModel.fromJson(Map<String, dynamic> json) =
      _$LostFoundModelImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String? get description;
  @override
  LostFoundStatus get status;
  @override
  LostFoundCategory get category;
  @override
  @JsonKey(name: 'location_found')
  String? get locationFound;
  @override
  @JsonKey(name: 'location_description')
  String? get locationDescription;
  @override
  @JsonKey(name: 'property_id')
  int? get propertyId;
  @override
  @JsonKey(name: 'property_name')
  String? get propertyName;
  @override
  @JsonKey(name: 'date_found')
  DateTime? get dateFound;
  @override
  @JsonKey(name: 'date_lost')
  DateTime? get dateLost;
  @override
  @JsonKey(name: 'reported_by')
  int? get reportedById;
  @override
  @JsonKey(name: 'reported_by_name')
  String? get reportedByName;
  @override
  @JsonKey(name: 'claimed_by')
  int? get claimedById;
  @override
  @JsonKey(name: 'claimed_by_name')
  String? get claimedByName;
  @override
  @JsonKey(name: 'claimed_at')
  DateTime? get claimedAt;
  @override
  @JsonKey(name: 'claimant_contact')
  String? get claimantContact;
  @override
  @JsonKey(name: 'storage_location')
  String? get storageLocation;
  @override
  @JsonKey(name: 'is_valuable')
  bool get isValuable;
  @override
  @JsonKey(name: 'estimated_value')
  double? get estimatedValue;
  @override
  List<String> get images;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(name: 'expires_at')
  DateTime? get expiresAt;

  /// Create a copy of LostFoundModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LostFoundModelImplCopyWith<_$LostFoundModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LostFoundClaimModel _$LostFoundClaimModelFromJson(Map<String, dynamic> json) {
  return _LostFoundClaimModel.fromJson(json);
}

/// @nodoc
mixin _$LostFoundClaimModel {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'lost_found_id')
  int get lostFoundId => throw _privateConstructorUsedError;
  @JsonKey(name: 'claimed_by')
  int get claimedById => throw _privateConstructorUsedError;
  @JsonKey(name: 'claimed_by_name')
  String? get claimedByName => throw _privateConstructorUsedError;
  @JsonKey(name: 'claimant_contact')
  String? get claimantContact => throw _privateConstructorUsedError;
  @JsonKey(name: 'identification_provided')
  String? get identificationProvided => throw _privateConstructorUsedError;
  @JsonKey(name: 'verification_notes')
  String? get verificationNotes => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_verified')
  bool get isVerified => throw _privateConstructorUsedError;
  @JsonKey(name: 'claimed_at')
  DateTime? get claimedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'processed_by')
  int? get processedById => throw _privateConstructorUsedError;
  @JsonKey(name: 'processed_by_name')
  String? get processedByName => throw _privateConstructorUsedError;

  /// Serializes this LostFoundClaimModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LostFoundClaimModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LostFoundClaimModelCopyWith<LostFoundClaimModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LostFoundClaimModelCopyWith<$Res> {
  factory $LostFoundClaimModelCopyWith(
          LostFoundClaimModel value, $Res Function(LostFoundClaimModel) then) =
      _$LostFoundClaimModelCopyWithImpl<$Res, LostFoundClaimModel>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'lost_found_id') int lostFoundId,
      @JsonKey(name: 'claimed_by') int claimedById,
      @JsonKey(name: 'claimed_by_name') String? claimedByName,
      @JsonKey(name: 'claimant_contact') String? claimantContact,
      @JsonKey(name: 'identification_provided') String? identificationProvided,
      @JsonKey(name: 'verification_notes') String? verificationNotes,
      @JsonKey(name: 'is_verified') bool isVerified,
      @JsonKey(name: 'claimed_at') DateTime? claimedAt,
      @JsonKey(name: 'processed_by') int? processedById,
      @JsonKey(name: 'processed_by_name') String? processedByName});
}

/// @nodoc
class _$LostFoundClaimModelCopyWithImpl<$Res, $Val extends LostFoundClaimModel>
    implements $LostFoundClaimModelCopyWith<$Res> {
  _$LostFoundClaimModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LostFoundClaimModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? lostFoundId = null,
    Object? claimedById = null,
    Object? claimedByName = freezed,
    Object? claimantContact = freezed,
    Object? identificationProvided = freezed,
    Object? verificationNotes = freezed,
    Object? isVerified = null,
    Object? claimedAt = freezed,
    Object? processedById = freezed,
    Object? processedByName = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      lostFoundId: null == lostFoundId
          ? _value.lostFoundId
          : lostFoundId // ignore: cast_nullable_to_non_nullable
              as int,
      claimedById: null == claimedById
          ? _value.claimedById
          : claimedById // ignore: cast_nullable_to_non_nullable
              as int,
      claimedByName: freezed == claimedByName
          ? _value.claimedByName
          : claimedByName // ignore: cast_nullable_to_non_nullable
              as String?,
      claimantContact: freezed == claimantContact
          ? _value.claimantContact
          : claimantContact // ignore: cast_nullable_to_non_nullable
              as String?,
      identificationProvided: freezed == identificationProvided
          ? _value.identificationProvided
          : identificationProvided // ignore: cast_nullable_to_non_nullable
              as String?,
      verificationNotes: freezed == verificationNotes
          ? _value.verificationNotes
          : verificationNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      claimedAt: freezed == claimedAt
          ? _value.claimedAt
          : claimedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      processedById: freezed == processedById
          ? _value.processedById
          : processedById // ignore: cast_nullable_to_non_nullable
              as int?,
      processedByName: freezed == processedByName
          ? _value.processedByName
          : processedByName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LostFoundClaimModelImplCopyWith<$Res>
    implements $LostFoundClaimModelCopyWith<$Res> {
  factory _$$LostFoundClaimModelImplCopyWith(_$LostFoundClaimModelImpl value,
          $Res Function(_$LostFoundClaimModelImpl) then) =
      __$$LostFoundClaimModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'lost_found_id') int lostFoundId,
      @JsonKey(name: 'claimed_by') int claimedById,
      @JsonKey(name: 'claimed_by_name') String? claimedByName,
      @JsonKey(name: 'claimant_contact') String? claimantContact,
      @JsonKey(name: 'identification_provided') String? identificationProvided,
      @JsonKey(name: 'verification_notes') String? verificationNotes,
      @JsonKey(name: 'is_verified') bool isVerified,
      @JsonKey(name: 'claimed_at') DateTime? claimedAt,
      @JsonKey(name: 'processed_by') int? processedById,
      @JsonKey(name: 'processed_by_name') String? processedByName});
}

/// @nodoc
class __$$LostFoundClaimModelImplCopyWithImpl<$Res>
    extends _$LostFoundClaimModelCopyWithImpl<$Res, _$LostFoundClaimModelImpl>
    implements _$$LostFoundClaimModelImplCopyWith<$Res> {
  __$$LostFoundClaimModelImplCopyWithImpl(_$LostFoundClaimModelImpl _value,
      $Res Function(_$LostFoundClaimModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of LostFoundClaimModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? lostFoundId = null,
    Object? claimedById = null,
    Object? claimedByName = freezed,
    Object? claimantContact = freezed,
    Object? identificationProvided = freezed,
    Object? verificationNotes = freezed,
    Object? isVerified = null,
    Object? claimedAt = freezed,
    Object? processedById = freezed,
    Object? processedByName = freezed,
  }) {
    return _then(_$LostFoundClaimModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      lostFoundId: null == lostFoundId
          ? _value.lostFoundId
          : lostFoundId // ignore: cast_nullable_to_non_nullable
              as int,
      claimedById: null == claimedById
          ? _value.claimedById
          : claimedById // ignore: cast_nullable_to_non_nullable
              as int,
      claimedByName: freezed == claimedByName
          ? _value.claimedByName
          : claimedByName // ignore: cast_nullable_to_non_nullable
              as String?,
      claimantContact: freezed == claimantContact
          ? _value.claimantContact
          : claimantContact // ignore: cast_nullable_to_non_nullable
              as String?,
      identificationProvided: freezed == identificationProvided
          ? _value.identificationProvided
          : identificationProvided // ignore: cast_nullable_to_non_nullable
              as String?,
      verificationNotes: freezed == verificationNotes
          ? _value.verificationNotes
          : verificationNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      claimedAt: freezed == claimedAt
          ? _value.claimedAt
          : claimedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      processedById: freezed == processedById
          ? _value.processedById
          : processedById // ignore: cast_nullable_to_non_nullable
              as int?,
      processedByName: freezed == processedByName
          ? _value.processedByName
          : processedByName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LostFoundClaimModelImpl extends _LostFoundClaimModel {
  const _$LostFoundClaimModelImpl(
      {required this.id,
      @JsonKey(name: 'lost_found_id') required this.lostFoundId,
      @JsonKey(name: 'claimed_by') required this.claimedById,
      @JsonKey(name: 'claimed_by_name') this.claimedByName,
      @JsonKey(name: 'claimant_contact') this.claimantContact,
      @JsonKey(name: 'identification_provided') this.identificationProvided,
      @JsonKey(name: 'verification_notes') this.verificationNotes,
      @JsonKey(name: 'is_verified') this.isVerified = false,
      @JsonKey(name: 'claimed_at') this.claimedAt,
      @JsonKey(name: 'processed_by') this.processedById,
      @JsonKey(name: 'processed_by_name') this.processedByName})
      : super._();

  factory _$LostFoundClaimModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LostFoundClaimModelImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'lost_found_id')
  final int lostFoundId;
  @override
  @JsonKey(name: 'claimed_by')
  final int claimedById;
  @override
  @JsonKey(name: 'claimed_by_name')
  final String? claimedByName;
  @override
  @JsonKey(name: 'claimant_contact')
  final String? claimantContact;
  @override
  @JsonKey(name: 'identification_provided')
  final String? identificationProvided;
  @override
  @JsonKey(name: 'verification_notes')
  final String? verificationNotes;
  @override
  @JsonKey(name: 'is_verified')
  final bool isVerified;
  @override
  @JsonKey(name: 'claimed_at')
  final DateTime? claimedAt;
  @override
  @JsonKey(name: 'processed_by')
  final int? processedById;
  @override
  @JsonKey(name: 'processed_by_name')
  final String? processedByName;

  @override
  String toString() {
    return 'LostFoundClaimModel(id: $id, lostFoundId: $lostFoundId, claimedById: $claimedById, claimedByName: $claimedByName, claimantContact: $claimantContact, identificationProvided: $identificationProvided, verificationNotes: $verificationNotes, isVerified: $isVerified, claimedAt: $claimedAt, processedById: $processedById, processedByName: $processedByName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LostFoundClaimModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.lostFoundId, lostFoundId) ||
                other.lostFoundId == lostFoundId) &&
            (identical(other.claimedById, claimedById) ||
                other.claimedById == claimedById) &&
            (identical(other.claimedByName, claimedByName) ||
                other.claimedByName == claimedByName) &&
            (identical(other.claimantContact, claimantContact) ||
                other.claimantContact == claimantContact) &&
            (identical(other.identificationProvided, identificationProvided) ||
                other.identificationProvided == identificationProvided) &&
            (identical(other.verificationNotes, verificationNotes) ||
                other.verificationNotes == verificationNotes) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.claimedAt, claimedAt) ||
                other.claimedAt == claimedAt) &&
            (identical(other.processedById, processedById) ||
                other.processedById == processedById) &&
            (identical(other.processedByName, processedByName) ||
                other.processedByName == processedByName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      lostFoundId,
      claimedById,
      claimedByName,
      claimantContact,
      identificationProvided,
      verificationNotes,
      isVerified,
      claimedAt,
      processedById,
      processedByName);

  /// Create a copy of LostFoundClaimModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LostFoundClaimModelImplCopyWith<_$LostFoundClaimModelImpl> get copyWith =>
      __$$LostFoundClaimModelImplCopyWithImpl<_$LostFoundClaimModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LostFoundClaimModelImplToJson(
      this,
    );
  }
}

abstract class _LostFoundClaimModel extends LostFoundClaimModel {
  const factory _LostFoundClaimModel(
          {required final int id,
          @JsonKey(name: 'lost_found_id') required final int lostFoundId,
          @JsonKey(name: 'claimed_by') required final int claimedById,
          @JsonKey(name: 'claimed_by_name') final String? claimedByName,
          @JsonKey(name: 'claimant_contact') final String? claimantContact,
          @JsonKey(name: 'identification_provided')
          final String? identificationProvided,
          @JsonKey(name: 'verification_notes') final String? verificationNotes,
          @JsonKey(name: 'is_verified') final bool isVerified,
          @JsonKey(name: 'claimed_at') final DateTime? claimedAt,
          @JsonKey(name: 'processed_by') final int? processedById,
          @JsonKey(name: 'processed_by_name') final String? processedByName}) =
      _$LostFoundClaimModelImpl;
  const _LostFoundClaimModel._() : super._();

  factory _LostFoundClaimModel.fromJson(Map<String, dynamic> json) =
      _$LostFoundClaimModelImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'lost_found_id')
  int get lostFoundId;
  @override
  @JsonKey(name: 'claimed_by')
  int get claimedById;
  @override
  @JsonKey(name: 'claimed_by_name')
  String? get claimedByName;
  @override
  @JsonKey(name: 'claimant_contact')
  String? get claimantContact;
  @override
  @JsonKey(name: 'identification_provided')
  String? get identificationProvided;
  @override
  @JsonKey(name: 'verification_notes')
  String? get verificationNotes;
  @override
  @JsonKey(name: 'is_verified')
  bool get isVerified;
  @override
  @JsonKey(name: 'claimed_at')
  DateTime? get claimedAt;
  @override
  @JsonKey(name: 'processed_by')
  int? get processedById;
  @override
  @JsonKey(name: 'processed_by_name')
  String? get processedByName;

  /// Create a copy of LostFoundClaimModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LostFoundClaimModelImplCopyWith<_$LostFoundClaimModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LostFoundStatsModel _$LostFoundStatsModelFromJson(Map<String, dynamic> json) {
  return _LostFoundStatsModel.fromJson(json);
}

/// @nodoc
mixin _$LostFoundStatsModel {
  @JsonKey(name: 'total_lost')
  int get totalLost => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_found')
  int get totalFound => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_claimed')
  int get totalClaimed => throw _privateConstructorUsedError;
  @JsonKey(name: 'pending_claims')
  int get pendingClaims => throw _privateConstructorUsedError;
  @JsonKey(name: 'expiring_soon')
  int get expiringSoon => throw _privateConstructorUsedError;

  /// Serializes this LostFoundStatsModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LostFoundStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LostFoundStatsModelCopyWith<LostFoundStatsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LostFoundStatsModelCopyWith<$Res> {
  factory $LostFoundStatsModelCopyWith(
          LostFoundStatsModel value, $Res Function(LostFoundStatsModel) then) =
      _$LostFoundStatsModelCopyWithImpl<$Res, LostFoundStatsModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_lost') int totalLost,
      @JsonKey(name: 'total_found') int totalFound,
      @JsonKey(name: 'total_claimed') int totalClaimed,
      @JsonKey(name: 'pending_claims') int pendingClaims,
      @JsonKey(name: 'expiring_soon') int expiringSoon});
}

/// @nodoc
class _$LostFoundStatsModelCopyWithImpl<$Res, $Val extends LostFoundStatsModel>
    implements $LostFoundStatsModelCopyWith<$Res> {
  _$LostFoundStatsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LostFoundStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalLost = null,
    Object? totalFound = null,
    Object? totalClaimed = null,
    Object? pendingClaims = null,
    Object? expiringSoon = null,
  }) {
    return _then(_value.copyWith(
      totalLost: null == totalLost
          ? _value.totalLost
          : totalLost // ignore: cast_nullable_to_non_nullable
              as int,
      totalFound: null == totalFound
          ? _value.totalFound
          : totalFound // ignore: cast_nullable_to_non_nullable
              as int,
      totalClaimed: null == totalClaimed
          ? _value.totalClaimed
          : totalClaimed // ignore: cast_nullable_to_non_nullable
              as int,
      pendingClaims: null == pendingClaims
          ? _value.pendingClaims
          : pendingClaims // ignore: cast_nullable_to_non_nullable
              as int,
      expiringSoon: null == expiringSoon
          ? _value.expiringSoon
          : expiringSoon // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LostFoundStatsModelImplCopyWith<$Res>
    implements $LostFoundStatsModelCopyWith<$Res> {
  factory _$$LostFoundStatsModelImplCopyWith(_$LostFoundStatsModelImpl value,
          $Res Function(_$LostFoundStatsModelImpl) then) =
      __$$LostFoundStatsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_lost') int totalLost,
      @JsonKey(name: 'total_found') int totalFound,
      @JsonKey(name: 'total_claimed') int totalClaimed,
      @JsonKey(name: 'pending_claims') int pendingClaims,
      @JsonKey(name: 'expiring_soon') int expiringSoon});
}

/// @nodoc
class __$$LostFoundStatsModelImplCopyWithImpl<$Res>
    extends _$LostFoundStatsModelCopyWithImpl<$Res, _$LostFoundStatsModelImpl>
    implements _$$LostFoundStatsModelImplCopyWith<$Res> {
  __$$LostFoundStatsModelImplCopyWithImpl(_$LostFoundStatsModelImpl _value,
      $Res Function(_$LostFoundStatsModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of LostFoundStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalLost = null,
    Object? totalFound = null,
    Object? totalClaimed = null,
    Object? pendingClaims = null,
    Object? expiringSoon = null,
  }) {
    return _then(_$LostFoundStatsModelImpl(
      totalLost: null == totalLost
          ? _value.totalLost
          : totalLost // ignore: cast_nullable_to_non_nullable
              as int,
      totalFound: null == totalFound
          ? _value.totalFound
          : totalFound // ignore: cast_nullable_to_non_nullable
              as int,
      totalClaimed: null == totalClaimed
          ? _value.totalClaimed
          : totalClaimed // ignore: cast_nullable_to_non_nullable
              as int,
      pendingClaims: null == pendingClaims
          ? _value.pendingClaims
          : pendingClaims // ignore: cast_nullable_to_non_nullable
              as int,
      expiringSoon: null == expiringSoon
          ? _value.expiringSoon
          : expiringSoon // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LostFoundStatsModelImpl extends _LostFoundStatsModel {
  const _$LostFoundStatsModelImpl(
      {@JsonKey(name: 'total_lost') this.totalLost = 0,
      @JsonKey(name: 'total_found') this.totalFound = 0,
      @JsonKey(name: 'total_claimed') this.totalClaimed = 0,
      @JsonKey(name: 'pending_claims') this.pendingClaims = 0,
      @JsonKey(name: 'expiring_soon') this.expiringSoon = 0})
      : super._();

  factory _$LostFoundStatsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$LostFoundStatsModelImplFromJson(json);

  @override
  @JsonKey(name: 'total_lost')
  final int totalLost;
  @override
  @JsonKey(name: 'total_found')
  final int totalFound;
  @override
  @JsonKey(name: 'total_claimed')
  final int totalClaimed;
  @override
  @JsonKey(name: 'pending_claims')
  final int pendingClaims;
  @override
  @JsonKey(name: 'expiring_soon')
  final int expiringSoon;

  @override
  String toString() {
    return 'LostFoundStatsModel(totalLost: $totalLost, totalFound: $totalFound, totalClaimed: $totalClaimed, pendingClaims: $pendingClaims, expiringSoon: $expiringSoon)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LostFoundStatsModelImpl &&
            (identical(other.totalLost, totalLost) ||
                other.totalLost == totalLost) &&
            (identical(other.totalFound, totalFound) ||
                other.totalFound == totalFound) &&
            (identical(other.totalClaimed, totalClaimed) ||
                other.totalClaimed == totalClaimed) &&
            (identical(other.pendingClaims, pendingClaims) ||
                other.pendingClaims == pendingClaims) &&
            (identical(other.expiringSoon, expiringSoon) ||
                other.expiringSoon == expiringSoon));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, totalLost, totalFound,
      totalClaimed, pendingClaims, expiringSoon);

  /// Create a copy of LostFoundStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LostFoundStatsModelImplCopyWith<_$LostFoundStatsModelImpl> get copyWith =>
      __$$LostFoundStatsModelImplCopyWithImpl<_$LostFoundStatsModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LostFoundStatsModelImplToJson(
      this,
    );
  }
}

abstract class _LostFoundStatsModel extends LostFoundStatsModel {
  const factory _LostFoundStatsModel(
          {@JsonKey(name: 'total_lost') final int totalLost,
          @JsonKey(name: 'total_found') final int totalFound,
          @JsonKey(name: 'total_claimed') final int totalClaimed,
          @JsonKey(name: 'pending_claims') final int pendingClaims,
          @JsonKey(name: 'expiring_soon') final int expiringSoon}) =
      _$LostFoundStatsModelImpl;
  const _LostFoundStatsModel._() : super._();

  factory _LostFoundStatsModel.fromJson(Map<String, dynamic> json) =
      _$LostFoundStatsModelImpl.fromJson;

  @override
  @JsonKey(name: 'total_lost')
  int get totalLost;
  @override
  @JsonKey(name: 'total_found')
  int get totalFound;
  @override
  @JsonKey(name: 'total_claimed')
  int get totalClaimed;
  @override
  @JsonKey(name: 'pending_claims')
  int get pendingClaims;
  @override
  @JsonKey(name: 'expiring_soon')
  int get expiringSoon;

  /// Create a copy of LostFoundStatsModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LostFoundStatsModelImplCopyWith<_$LostFoundStatsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
