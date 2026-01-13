// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BookingModel _$BookingModelFromJson(Map<String, dynamic> json) {
  return _BookingModel.fromJson(json);
}

/// @nodoc
mixin _$BookingModel {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'property_id')
  int get propertyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'property_name')
  String? get propertyName => throw _privateConstructorUsedError;
  @JsonKey(name: 'guest_name')
  String? get guestName => throw _privateConstructorUsedError;
  @JsonKey(name: 'guest_email')
  String? get guestEmail => throw _privateConstructorUsedError;
  @JsonKey(name: 'guest_phone')
  String? get guestPhone => throw _privateConstructorUsedError;
  @JsonKey(name: 'check_in')
  DateTime get checkIn => throw _privateConstructorUsedError;
  @JsonKey(name: 'check_out')
  DateTime get checkOut => throw _privateConstructorUsedError;
  @JsonKey(name: 'num_guests')
  int? get numGuests => throw _privateConstructorUsedError;
  BookingStatus get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'booking_source')
  String? get bookingSource => throw _privateConstructorUsedError;
  @JsonKey(name: 'confirmation_code')
  String? get confirmationCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_amount')
  double? get totalAmount => throw _privateConstructorUsedError;
  String? get currency => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'special_requests')
  String? get specialRequests => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this BookingModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingModelCopyWith<BookingModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingModelCopyWith<$Res> {
  factory $BookingModelCopyWith(
          BookingModel value, $Res Function(BookingModel) then) =
      _$BookingModelCopyWithImpl<$Res, BookingModel>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'property_id') int propertyId,
      @JsonKey(name: 'property_name') String? propertyName,
      @JsonKey(name: 'guest_name') String? guestName,
      @JsonKey(name: 'guest_email') String? guestEmail,
      @JsonKey(name: 'guest_phone') String? guestPhone,
      @JsonKey(name: 'check_in') DateTime checkIn,
      @JsonKey(name: 'check_out') DateTime checkOut,
      @JsonKey(name: 'num_guests') int? numGuests,
      BookingStatus status,
      @JsonKey(name: 'booking_source') String? bookingSource,
      @JsonKey(name: 'confirmation_code') String? confirmationCode,
      @JsonKey(name: 'total_amount') double? totalAmount,
      String? currency,
      String? notes,
      @JsonKey(name: 'special_requests') String? specialRequests,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class _$BookingModelCopyWithImpl<$Res, $Val extends BookingModel>
    implements $BookingModelCopyWith<$Res> {
  _$BookingModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? propertyId = null,
    Object? propertyName = freezed,
    Object? guestName = freezed,
    Object? guestEmail = freezed,
    Object? guestPhone = freezed,
    Object? checkIn = null,
    Object? checkOut = null,
    Object? numGuests = freezed,
    Object? status = null,
    Object? bookingSource = freezed,
    Object? confirmationCode = freezed,
    Object? totalAmount = freezed,
    Object? currency = freezed,
    Object? notes = freezed,
    Object? specialRequests = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      propertyId: null == propertyId
          ? _value.propertyId
          : propertyId // ignore: cast_nullable_to_non_nullable
              as int,
      propertyName: freezed == propertyName
          ? _value.propertyName
          : propertyName // ignore: cast_nullable_to_non_nullable
              as String?,
      guestName: freezed == guestName
          ? _value.guestName
          : guestName // ignore: cast_nullable_to_non_nullable
              as String?,
      guestEmail: freezed == guestEmail
          ? _value.guestEmail
          : guestEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      guestPhone: freezed == guestPhone
          ? _value.guestPhone
          : guestPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      checkIn: null == checkIn
          ? _value.checkIn
          : checkIn // ignore: cast_nullable_to_non_nullable
              as DateTime,
      checkOut: null == checkOut
          ? _value.checkOut
          : checkOut // ignore: cast_nullable_to_non_nullable
              as DateTime,
      numGuests: freezed == numGuests
          ? _value.numGuests
          : numGuests // ignore: cast_nullable_to_non_nullable
              as int?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as BookingStatus,
      bookingSource: freezed == bookingSource
          ? _value.bookingSource
          : bookingSource // ignore: cast_nullable_to_non_nullable
              as String?,
      confirmationCode: freezed == confirmationCode
          ? _value.confirmationCode
          : confirmationCode // ignore: cast_nullable_to_non_nullable
              as String?,
      totalAmount: freezed == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      specialRequests: freezed == specialRequests
          ? _value.specialRequests
          : specialRequests // ignore: cast_nullable_to_non_nullable
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
abstract class _$$BookingModelImplCopyWith<$Res>
    implements $BookingModelCopyWith<$Res> {
  factory _$$BookingModelImplCopyWith(
          _$BookingModelImpl value, $Res Function(_$BookingModelImpl) then) =
      __$$BookingModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'property_id') int propertyId,
      @JsonKey(name: 'property_name') String? propertyName,
      @JsonKey(name: 'guest_name') String? guestName,
      @JsonKey(name: 'guest_email') String? guestEmail,
      @JsonKey(name: 'guest_phone') String? guestPhone,
      @JsonKey(name: 'check_in') DateTime checkIn,
      @JsonKey(name: 'check_out') DateTime checkOut,
      @JsonKey(name: 'num_guests') int? numGuests,
      BookingStatus status,
      @JsonKey(name: 'booking_source') String? bookingSource,
      @JsonKey(name: 'confirmation_code') String? confirmationCode,
      @JsonKey(name: 'total_amount') double? totalAmount,
      String? currency,
      String? notes,
      @JsonKey(name: 'special_requests') String? specialRequests,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt});
}

/// @nodoc
class __$$BookingModelImplCopyWithImpl<$Res>
    extends _$BookingModelCopyWithImpl<$Res, _$BookingModelImpl>
    implements _$$BookingModelImplCopyWith<$Res> {
  __$$BookingModelImplCopyWithImpl(
      _$BookingModelImpl _value, $Res Function(_$BookingModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? propertyId = null,
    Object? propertyName = freezed,
    Object? guestName = freezed,
    Object? guestEmail = freezed,
    Object? guestPhone = freezed,
    Object? checkIn = null,
    Object? checkOut = null,
    Object? numGuests = freezed,
    Object? status = null,
    Object? bookingSource = freezed,
    Object? confirmationCode = freezed,
    Object? totalAmount = freezed,
    Object? currency = freezed,
    Object? notes = freezed,
    Object? specialRequests = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$BookingModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      propertyId: null == propertyId
          ? _value.propertyId
          : propertyId // ignore: cast_nullable_to_non_nullable
              as int,
      propertyName: freezed == propertyName
          ? _value.propertyName
          : propertyName // ignore: cast_nullable_to_non_nullable
              as String?,
      guestName: freezed == guestName
          ? _value.guestName
          : guestName // ignore: cast_nullable_to_non_nullable
              as String?,
      guestEmail: freezed == guestEmail
          ? _value.guestEmail
          : guestEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      guestPhone: freezed == guestPhone
          ? _value.guestPhone
          : guestPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      checkIn: null == checkIn
          ? _value.checkIn
          : checkIn // ignore: cast_nullable_to_non_nullable
              as DateTime,
      checkOut: null == checkOut
          ? _value.checkOut
          : checkOut // ignore: cast_nullable_to_non_nullable
              as DateTime,
      numGuests: freezed == numGuests
          ? _value.numGuests
          : numGuests // ignore: cast_nullable_to_non_nullable
              as int?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as BookingStatus,
      bookingSource: freezed == bookingSource
          ? _value.bookingSource
          : bookingSource // ignore: cast_nullable_to_non_nullable
              as String?,
      confirmationCode: freezed == confirmationCode
          ? _value.confirmationCode
          : confirmationCode // ignore: cast_nullable_to_non_nullable
              as String?,
      totalAmount: freezed == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      currency: freezed == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      specialRequests: freezed == specialRequests
          ? _value.specialRequests
          : specialRequests // ignore: cast_nullable_to_non_nullable
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
class _$BookingModelImpl extends _BookingModel {
  const _$BookingModelImpl(
      {required this.id,
      @JsonKey(name: 'property_id') required this.propertyId,
      @JsonKey(name: 'property_name') this.propertyName,
      @JsonKey(name: 'guest_name') this.guestName,
      @JsonKey(name: 'guest_email') this.guestEmail,
      @JsonKey(name: 'guest_phone') this.guestPhone,
      @JsonKey(name: 'check_in') required this.checkIn,
      @JsonKey(name: 'check_out') required this.checkOut,
      @JsonKey(name: 'num_guests') this.numGuests,
      this.status = BookingStatus.confirmed,
      @JsonKey(name: 'booking_source') this.bookingSource,
      @JsonKey(name: 'confirmation_code') this.confirmationCode,
      @JsonKey(name: 'total_amount') this.totalAmount,
      this.currency,
      this.notes,
      @JsonKey(name: 'special_requests') this.specialRequests,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt})
      : super._();

  factory _$BookingModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingModelImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'property_id')
  final int propertyId;
  @override
  @JsonKey(name: 'property_name')
  final String? propertyName;
  @override
  @JsonKey(name: 'guest_name')
  final String? guestName;
  @override
  @JsonKey(name: 'guest_email')
  final String? guestEmail;
  @override
  @JsonKey(name: 'guest_phone')
  final String? guestPhone;
  @override
  @JsonKey(name: 'check_in')
  final DateTime checkIn;
  @override
  @JsonKey(name: 'check_out')
  final DateTime checkOut;
  @override
  @JsonKey(name: 'num_guests')
  final int? numGuests;
  @override
  @JsonKey()
  final BookingStatus status;
  @override
  @JsonKey(name: 'booking_source')
  final String? bookingSource;
  @override
  @JsonKey(name: 'confirmation_code')
  final String? confirmationCode;
  @override
  @JsonKey(name: 'total_amount')
  final double? totalAmount;
  @override
  final String? currency;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'special_requests')
  final String? specialRequests;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'BookingModel(id: $id, propertyId: $propertyId, propertyName: $propertyName, guestName: $guestName, guestEmail: $guestEmail, guestPhone: $guestPhone, checkIn: $checkIn, checkOut: $checkOut, numGuests: $numGuests, status: $status, bookingSource: $bookingSource, confirmationCode: $confirmationCode, totalAmount: $totalAmount, currency: $currency, notes: $notes, specialRequests: $specialRequests, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.propertyId, propertyId) ||
                other.propertyId == propertyId) &&
            (identical(other.propertyName, propertyName) ||
                other.propertyName == propertyName) &&
            (identical(other.guestName, guestName) ||
                other.guestName == guestName) &&
            (identical(other.guestEmail, guestEmail) ||
                other.guestEmail == guestEmail) &&
            (identical(other.guestPhone, guestPhone) ||
                other.guestPhone == guestPhone) &&
            (identical(other.checkIn, checkIn) || other.checkIn == checkIn) &&
            (identical(other.checkOut, checkOut) ||
                other.checkOut == checkOut) &&
            (identical(other.numGuests, numGuests) ||
                other.numGuests == numGuests) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.bookingSource, bookingSource) ||
                other.bookingSource == bookingSource) &&
            (identical(other.confirmationCode, confirmationCode) ||
                other.confirmationCode == confirmationCode) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.specialRequests, specialRequests) ||
                other.specialRequests == specialRequests) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      propertyId,
      propertyName,
      guestName,
      guestEmail,
      guestPhone,
      checkIn,
      checkOut,
      numGuests,
      status,
      bookingSource,
      confirmationCode,
      totalAmount,
      currency,
      notes,
      specialRequests,
      createdAt,
      updatedAt);

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingModelImplCopyWith<_$BookingModelImpl> get copyWith =>
      __$$BookingModelImplCopyWithImpl<_$BookingModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingModelImplToJson(
      this,
    );
  }
}

abstract class _BookingModel extends BookingModel {
  const factory _BookingModel(
          {required final int id,
          @JsonKey(name: 'property_id') required final int propertyId,
          @JsonKey(name: 'property_name') final String? propertyName,
          @JsonKey(name: 'guest_name') final String? guestName,
          @JsonKey(name: 'guest_email') final String? guestEmail,
          @JsonKey(name: 'guest_phone') final String? guestPhone,
          @JsonKey(name: 'check_in') required final DateTime checkIn,
          @JsonKey(name: 'check_out') required final DateTime checkOut,
          @JsonKey(name: 'num_guests') final int? numGuests,
          final BookingStatus status,
          @JsonKey(name: 'booking_source') final String? bookingSource,
          @JsonKey(name: 'confirmation_code') final String? confirmationCode,
          @JsonKey(name: 'total_amount') final double? totalAmount,
          final String? currency,
          final String? notes,
          @JsonKey(name: 'special_requests') final String? specialRequests,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt}) =
      _$BookingModelImpl;
  const _BookingModel._() : super._();

  factory _BookingModel.fromJson(Map<String, dynamic> json) =
      _$BookingModelImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'property_id')
  int get propertyId;
  @override
  @JsonKey(name: 'property_name')
  String? get propertyName;
  @override
  @JsonKey(name: 'guest_name')
  String? get guestName;
  @override
  @JsonKey(name: 'guest_email')
  String? get guestEmail;
  @override
  @JsonKey(name: 'guest_phone')
  String? get guestPhone;
  @override
  @JsonKey(name: 'check_in')
  DateTime get checkIn;
  @override
  @JsonKey(name: 'check_out')
  DateTime get checkOut;
  @override
  @JsonKey(name: 'num_guests')
  int? get numGuests;
  @override
  BookingStatus get status;
  @override
  @JsonKey(name: 'booking_source')
  String? get bookingSource;
  @override
  @JsonKey(name: 'confirmation_code')
  String? get confirmationCode;
  @override
  @JsonKey(name: 'total_amount')
  double? get totalAmount;
  @override
  String? get currency;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'special_requests')
  String? get specialRequests;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of BookingModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingModelImplCopyWith<_$BookingModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PaginatedBookings _$PaginatedBookingsFromJson(Map<String, dynamic> json) {
  return _PaginatedBookings.fromJson(json);
}

/// @nodoc
mixin _$PaginatedBookings {
  int get count => throw _privateConstructorUsedError;
  String? get next => throw _privateConstructorUsedError;
  String? get previous => throw _privateConstructorUsedError;
  List<BookingModel> get results => throw _privateConstructorUsedError;

  /// Serializes this PaginatedBookings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaginatedBookings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaginatedBookingsCopyWith<PaginatedBookings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginatedBookingsCopyWith<$Res> {
  factory $PaginatedBookingsCopyWith(
          PaginatedBookings value, $Res Function(PaginatedBookings) then) =
      _$PaginatedBookingsCopyWithImpl<$Res, PaginatedBookings>;
  @useResult
  $Res call(
      {int count, String? next, String? previous, List<BookingModel> results});
}

/// @nodoc
class _$PaginatedBookingsCopyWithImpl<$Res, $Val extends PaginatedBookings>
    implements $PaginatedBookingsCopyWith<$Res> {
  _$PaginatedBookingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaginatedBookings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? count = null,
    Object? next = freezed,
    Object? previous = freezed,
    Object? results = null,
  }) {
    return _then(_value.copyWith(
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      next: freezed == next
          ? _value.next
          : next // ignore: cast_nullable_to_non_nullable
              as String?,
      previous: freezed == previous
          ? _value.previous
          : previous // ignore: cast_nullable_to_non_nullable
              as String?,
      results: null == results
          ? _value.results
          : results // ignore: cast_nullable_to_non_nullable
              as List<BookingModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaginatedBookingsImplCopyWith<$Res>
    implements $PaginatedBookingsCopyWith<$Res> {
  factory _$$PaginatedBookingsImplCopyWith(_$PaginatedBookingsImpl value,
          $Res Function(_$PaginatedBookingsImpl) then) =
      __$$PaginatedBookingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int count, String? next, String? previous, List<BookingModel> results});
}

/// @nodoc
class __$$PaginatedBookingsImplCopyWithImpl<$Res>
    extends _$PaginatedBookingsCopyWithImpl<$Res, _$PaginatedBookingsImpl>
    implements _$$PaginatedBookingsImplCopyWith<$Res> {
  __$$PaginatedBookingsImplCopyWithImpl(_$PaginatedBookingsImpl _value,
      $Res Function(_$PaginatedBookingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaginatedBookings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? count = null,
    Object? next = freezed,
    Object? previous = freezed,
    Object? results = null,
  }) {
    return _then(_$PaginatedBookingsImpl(
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      next: freezed == next
          ? _value.next
          : next // ignore: cast_nullable_to_non_nullable
              as String?,
      previous: freezed == previous
          ? _value.previous
          : previous // ignore: cast_nullable_to_non_nullable
              as String?,
      results: null == results
          ? _value._results
          : results // ignore: cast_nullable_to_non_nullable
              as List<BookingModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaginatedBookingsImpl implements _PaginatedBookings {
  const _$PaginatedBookingsImpl(
      {required this.count,
      this.next,
      this.previous,
      required final List<BookingModel> results})
      : _results = results;

  factory _$PaginatedBookingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaginatedBookingsImplFromJson(json);

  @override
  final int count;
  @override
  final String? next;
  @override
  final String? previous;
  final List<BookingModel> _results;
  @override
  List<BookingModel> get results {
    if (_results is EqualUnmodifiableListView) return _results;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_results);
  }

  @override
  String toString() {
    return 'PaginatedBookings(count: $count, next: $next, previous: $previous, results: $results)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginatedBookingsImpl &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.next, next) || other.next == next) &&
            (identical(other.previous, previous) ||
                other.previous == previous) &&
            const DeepCollectionEquality().equals(other._results, _results));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, count, next, previous,
      const DeepCollectionEquality().hash(_results));

  /// Create a copy of PaginatedBookings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginatedBookingsImplCopyWith<_$PaginatedBookingsImpl> get copyWith =>
      __$$PaginatedBookingsImplCopyWithImpl<_$PaginatedBookingsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaginatedBookingsImplToJson(
      this,
    );
  }
}

abstract class _PaginatedBookings implements PaginatedBookings {
  const factory _PaginatedBookings(
      {required final int count,
      final String? next,
      final String? previous,
      required final List<BookingModel> results}) = _$PaginatedBookingsImpl;

  factory _PaginatedBookings.fromJson(Map<String, dynamic> json) =
      _$PaginatedBookingsImpl.fromJson;

  @override
  int get count;
  @override
  String? get next;
  @override
  String? get previous;
  @override
  List<BookingModel> get results;

  /// Create a copy of PaginatedBookings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaginatedBookingsImplCopyWith<_$PaginatedBookingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
