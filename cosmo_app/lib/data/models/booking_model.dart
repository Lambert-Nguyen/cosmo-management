/// Booking model for Cosmo Management
///
/// Freezed model for booking data with JSON serialization.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_model.freezed.dart';
part 'booking_model.g.dart';

/// Booking model
///
/// Represents a property booking/reservation in the system.
@freezed
class BookingModel with _$BookingModel {
  const factory BookingModel({
    required int id,
    @JsonKey(name: 'property_id') required int propertyId,
    @JsonKey(name: 'property_name') String? propertyName,
    @JsonKey(name: 'guest_name') String? guestName,
    @JsonKey(name: 'guest_email') String? guestEmail,
    @JsonKey(name: 'guest_phone') String? guestPhone,
    @JsonKey(name: 'check_in') required DateTime checkIn,
    @JsonKey(name: 'check_out') required DateTime checkOut,
    @JsonKey(name: 'num_guests') int? numGuests,
    @Default(BookingStatus.confirmed) BookingStatus status,
    @JsonKey(name: 'booking_source') String? bookingSource,
    @JsonKey(name: 'confirmation_code') String? confirmationCode,
    @JsonKey(name: 'total_amount') double? totalAmount,
    String? currency,
    String? notes,
    @JsonKey(name: 'special_requests') String? specialRequests,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _BookingModel;

  const BookingModel._();

  factory BookingModel.fromJson(Map<String, dynamic> json) =>
      _$BookingModelFromJson(json);

  /// Check if booking is currently active (guest is checked in)
  bool get isActive {
    final now = DateTime.now();
    return status == BookingStatus.checkedIn ||
        (status == BookingStatus.confirmed &&
            now.isAfter(checkIn) &&
            now.isBefore(checkOut));
  }

  /// Check if booking is upcoming
  bool get isUpcoming {
    final now = DateTime.now();
    return (status == BookingStatus.confirmed ||
            status == BookingStatus.pending) &&
        now.isBefore(checkIn);
  }

  /// Check if booking is past
  bool get isPast {
    final now = DateTime.now();
    return status == BookingStatus.checkedOut ||
        status == BookingStatus.completed ||
        now.isAfter(checkOut);
  }

  /// Duration of stay in nights
  int get nights => checkOut.difference(checkIn).inDays;

  /// Days until check-in (negative if past)
  int get daysUntilCheckIn => checkIn.difference(DateTime.now()).inDays;

  /// Human-readable booking period
  String get bookingPeriod {
    final checkInStr =
        '${checkIn.month}/${checkIn.day}/${checkIn.year}';
    final checkOutStr =
        '${checkOut.month}/${checkOut.day}/${checkOut.year}';
    return '$checkInStr - $checkOutStr';
  }

  /// Human-readable status for display
  String get statusDisplay {
    final days = daysUntilCheckIn;
    if (status == BookingStatus.confirmed && days >= 0) {
      if (days == 0) return 'Arriving today';
      if (days == 1) return 'Arriving tomorrow';
      return 'Arriving in $days days';
    }
    return status.displayName;
  }
}

/// Booking status enum
@JsonEnum(valueField: 'value')
enum BookingStatus {
  @JsonValue('pending')
  pending('pending', 'Pending'),
  @JsonValue('confirmed')
  confirmed('confirmed', 'Confirmed'),
  @JsonValue('checked_in')
  checkedIn('checked_in', 'Checked In'),
  @JsonValue('checked_out')
  checkedOut('checked_out', 'Checked Out'),
  @JsonValue('completed')
  completed('completed', 'Completed'),
  @JsonValue('cancelled')
  cancelled('cancelled', 'Cancelled'),
  @JsonValue('no_show')
  noShow('no_show', 'No Show');

  final String value;
  final String displayName;

  const BookingStatus(this.value, this.displayName);
}

/// Paginated booking response
@freezed
class PaginatedBookings with _$PaginatedBookings {
  const factory PaginatedBookings({
    required int count,
    String? next,
    String? previous,
    required List<BookingModel> results,
  }) = _PaginatedBookings;

  factory PaginatedBookings.fromJson(Map<String, dynamic> json) =>
      _$PaginatedBookingsFromJson(json);
}
