// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CalendarEventModelImpl _$$CalendarEventModelImplFromJson(
        Map<String, dynamic> json) =>
    _$CalendarEventModelImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      eventType: $enumDecode(_$CalendarEventTypeEnumMap, json['event_type']),
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
      allDay: json['all_day'] as bool? ?? false,
      propertyId: (json['property_id'] as num?)?.toInt(),
      propertyName: json['property_name'] as String?,
      bookingId: (json['booking_id'] as num?)?.toInt(),
      taskId: (json['task_id'] as num?)?.toInt(),
      description: json['description'] as String?,
      status: json['status'] as String?,
      color: json['color'] as String?,
    );

Map<String, dynamic> _$$CalendarEventModelImplToJson(
        _$CalendarEventModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'event_type': _$CalendarEventTypeEnumMap[instance.eventType]!,
      'start_date': instance.startDate.toIso8601String(),
      'end_date': instance.endDate?.toIso8601String(),
      'all_day': instance.allDay,
      'property_id': instance.propertyId,
      'property_name': instance.propertyName,
      'booking_id': instance.bookingId,
      'task_id': instance.taskId,
      'description': instance.description,
      'status': instance.status,
      'color': instance.color,
    };

const _$CalendarEventTypeEnumMap = {
  CalendarEventType.booking: 'booking',
  CalendarEventType.task: 'task',
  CalendarEventType.checkout: 'checkout',
  CalendarEventType.checkin: 'checkin',
  CalendarEventType.maintenance: 'maintenance',
  CalendarEventType.blocked: 'blocked',
};

_$CalendarDateRangeImpl _$$CalendarDateRangeImplFromJson(
        Map<String, dynamic> json) =>
    _$CalendarDateRangeImpl(
      start: DateTime.parse(json['start'] as String),
      end: DateTime.parse(json['end'] as String),
    );

Map<String, dynamic> _$$CalendarDateRangeImplToJson(
        _$CalendarDateRangeImpl instance) =>
    <String, dynamic>{
      'start': instance.start.toIso8601String(),
      'end': instance.end.toIso8601String(),
    };

_$PortalDashboardStatsImpl _$$PortalDashboardStatsImplFromJson(
        Map<String, dynamic> json) =>
    _$PortalDashboardStatsImpl(
      totalProperties: (json['total_properties'] as num?)?.toInt() ?? 0,
      activeBookings: (json['active_bookings'] as num?)?.toInt() ?? 0,
      upcomingBookings: (json['upcoming_bookings'] as num?)?.toInt() ?? 0,
      pendingTasks: (json['pending_tasks'] as num?)?.toInt() ?? 0,
      photosPendingApproval:
          (json['photos_pending_approval'] as num?)?.toInt() ?? 0,
      checkInsToday: (json['check_ins_today'] as num?)?.toInt() ?? 0,
      checkOutsToday: (json['check_outs_today'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$PortalDashboardStatsImplToJson(
        _$PortalDashboardStatsImpl instance) =>
    <String, dynamic>{
      'total_properties': instance.totalProperties,
      'active_bookings': instance.activeBookings,
      'upcoming_bookings': instance.upcomingBookings,
      'pending_tasks': instance.pendingTasks,
      'photos_pending_approval': instance.photosPendingApproval,
      'check_ins_today': instance.checkInsToday,
      'check_outs_today': instance.checkOutsToday,
    };
