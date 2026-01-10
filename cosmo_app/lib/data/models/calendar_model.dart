/// Calendar model for Cosmo Management
///
/// Freezed model for calendar events with JSON serialization.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_model.freezed.dart';
part 'calendar_model.g.dart';

/// Calendar event model
///
/// Represents an event on the calendar (booking, task, etc).
@freezed
class CalendarEventModel with _$CalendarEventModel {
  const factory CalendarEventModel({
    required int id,
    required String title,
    @JsonKey(name: 'event_type') required CalendarEventType eventType,
    @JsonKey(name: 'start_date') required DateTime startDate,
    @JsonKey(name: 'end_date') DateTime? endDate,
    @JsonKey(name: 'all_day') @Default(false) bool allDay,
    @JsonKey(name: 'property_id') int? propertyId,
    @JsonKey(name: 'property_name') String? propertyName,
    @JsonKey(name: 'booking_id') int? bookingId,
    @JsonKey(name: 'task_id') int? taskId,
    String? description,
    String? status,
    String? color,
  }) = _CalendarEventModel;

  const CalendarEventModel._();

  factory CalendarEventModel.fromJson(Map<String, dynamic> json) =>
      _$CalendarEventModelFromJson(json);

  /// Check if event spans multiple days
  bool get isMultiDay {
    if (endDate == null) return false;
    return !_isSameDay(startDate, endDate!);
  }

  /// Check if event is on a specific date
  bool isOnDate(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    final startOnly = DateTime(startDate.year, startDate.month, startDate.day);

    if (endDate == null) {
      return _isSameDay(dateOnly, startOnly);
    }

    final endOnly = DateTime(endDate!.year, endDate!.month, endDate!.day);
    return !dateOnly.isBefore(startOnly) && !dateOnly.isAfter(endOnly);
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Duration in days (1 for single day events)
  int get durationDays {
    if (endDate == null) return 1;
    return endDate!.difference(startDate).inDays + 1;
  }
}

/// Calendar event type enum
@JsonEnum(valueField: 'value')
enum CalendarEventType {
  @JsonValue('booking')
  booking('booking', 'Booking'),
  @JsonValue('task')
  task('task', 'Task'),
  @JsonValue('checkout')
  checkout('checkout', 'Check-out'),
  @JsonValue('checkin')
  checkin('checkin', 'Check-in'),
  @JsonValue('maintenance')
  maintenance('maintenance', 'Maintenance'),
  @JsonValue('blocked')
  blocked('blocked', 'Blocked');

  final String value;
  final String displayName;

  const CalendarEventType(this.value, this.displayName);
}

/// Calendar view mode
enum CalendarViewMode {
  month,
  week,
  day,
}

/// Calendar date range for API requests
@freezed
class CalendarDateRange with _$CalendarDateRange {
  const factory CalendarDateRange({
    required DateTime start,
    required DateTime end,
  }) = _CalendarDateRange;

  const CalendarDateRange._();

  factory CalendarDateRange.fromJson(Map<String, dynamic> json) =>
      _$CalendarDateRangeFromJson(json);

  /// Create range for a specific month
  factory CalendarDateRange.forMonth(DateTime date) {
    final start = DateTime(date.year, date.month, 1);
    final end = DateTime(date.year, date.month + 1, 0);
    return CalendarDateRange(start: start, end: end);
  }

  /// Create range for a specific week
  factory CalendarDateRange.forWeek(DateTime date) {
    final weekday = date.weekday;
    final start = date.subtract(Duration(days: weekday - 1));
    final end = start.add(const Duration(days: 6));
    return CalendarDateRange(
      start: DateTime(start.year, start.month, start.day),
      end: DateTime(end.year, end.month, end.day),
    );
  }

  /// Create range for a specific day
  factory CalendarDateRange.forDay(DateTime date) {
    final dayStart = DateTime(date.year, date.month, date.day);
    return CalendarDateRange(start: dayStart, end: dayStart);
  }
}

/// Portal dashboard stats model
@freezed
class PortalDashboardStats with _$PortalDashboardStats {
  const factory PortalDashboardStats({
    @JsonKey(name: 'total_properties') @Default(0) int totalProperties,
    @JsonKey(name: 'active_bookings') @Default(0) int activeBookings,
    @JsonKey(name: 'upcoming_bookings') @Default(0) int upcomingBookings,
    @JsonKey(name: 'pending_tasks') @Default(0) int pendingTasks,
    @JsonKey(name: 'photos_pending_approval') @Default(0) int photosPendingApproval,
    @JsonKey(name: 'check_ins_today') @Default(0) int checkInsToday,
    @JsonKey(name: 'check_outs_today') @Default(0) int checkOutsToday,
  }) = _PortalDashboardStats;

  factory PortalDashboardStats.fromJson(Map<String, dynamic> json) =>
      _$PortalDashboardStatsFromJson(json);
}
