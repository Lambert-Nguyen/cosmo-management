// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingModelImpl _$$BookingModelImplFromJson(Map<String, dynamic> json) =>
    _$BookingModelImpl(
      id: (json['id'] as num).toInt(),
      propertyId: (json['property_id'] as num).toInt(),
      propertyName: json['property_name'] as String?,
      guestName: json['guest_name'] as String?,
      guestEmail: json['guest_email'] as String?,
      guestPhone: json['guest_phone'] as String?,
      checkIn: DateTime.parse(json['check_in'] as String),
      checkOut: DateTime.parse(json['check_out'] as String),
      numGuests: (json['num_guests'] as num?)?.toInt(),
      status: $enumDecodeNullable(_$BookingStatusEnumMap, json['status']) ??
          BookingStatus.confirmed,
      bookingSource: json['booking_source'] as String?,
      confirmationCode: json['confirmation_code'] as String?,
      totalAmount: (json['total_amount'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      notes: json['notes'] as String?,
      specialRequests: json['special_requests'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$BookingModelImplToJson(_$BookingModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'property_id': instance.propertyId,
      'property_name': instance.propertyName,
      'guest_name': instance.guestName,
      'guest_email': instance.guestEmail,
      'guest_phone': instance.guestPhone,
      'check_in': instance.checkIn.toIso8601String(),
      'check_out': instance.checkOut.toIso8601String(),
      'num_guests': instance.numGuests,
      'status': _$BookingStatusEnumMap[instance.status]!,
      'booking_source': instance.bookingSource,
      'confirmation_code': instance.confirmationCode,
      'total_amount': instance.totalAmount,
      'currency': instance.currency,
      'notes': instance.notes,
      'special_requests': instance.specialRequests,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$BookingStatusEnumMap = {
  BookingStatus.pending: 'pending',
  BookingStatus.confirmed: 'confirmed',
  BookingStatus.checkedIn: 'checked_in',
  BookingStatus.checkedOut: 'checked_out',
  BookingStatus.completed: 'completed',
  BookingStatus.cancelled: 'cancelled',
  BookingStatus.noShow: 'no_show',
};

_$PaginatedBookingsImpl _$$PaginatedBookingsImplFromJson(
        Map<String, dynamic> json) =>
    _$PaginatedBookingsImpl(
      count: (json['count'] as num).toInt(),
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>)
          .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PaginatedBookingsImplToJson(
        _$PaginatedBookingsImpl instance) =>
    <String, dynamic>{
      'count': instance.count,
      'next': instance.next,
      'previous': instance.previous,
      'results': instance.results,
    };
