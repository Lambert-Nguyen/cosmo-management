// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calendar_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CalendarEventModel _$CalendarEventModelFromJson(Map<String, dynamic> json) {
  return _CalendarEventModel.fromJson(json);
}

/// @nodoc
mixin _$CalendarEventModel {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'event_type')
  CalendarEventType get eventType => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_date')
  DateTime get startDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_date')
  DateTime? get endDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'all_day')
  bool get allDay => throw _privateConstructorUsedError;
  @JsonKey(name: 'property_id')
  int? get propertyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'property_name')
  String? get propertyName => throw _privateConstructorUsedError;
  @JsonKey(name: 'booking_id')
  int? get bookingId => throw _privateConstructorUsedError;
  @JsonKey(name: 'task_id')
  int? get taskId => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;

  /// Serializes this CalendarEventModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CalendarEventModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CalendarEventModelCopyWith<CalendarEventModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CalendarEventModelCopyWith<$Res> {
  factory $CalendarEventModelCopyWith(
          CalendarEventModel value, $Res Function(CalendarEventModel) then) =
      _$CalendarEventModelCopyWithImpl<$Res, CalendarEventModel>;
  @useResult
  $Res call(
      {int id,
      String title,
      @JsonKey(name: 'event_type') CalendarEventType eventType,
      @JsonKey(name: 'start_date') DateTime startDate,
      @JsonKey(name: 'end_date') DateTime? endDate,
      @JsonKey(name: 'all_day') bool allDay,
      @JsonKey(name: 'property_id') int? propertyId,
      @JsonKey(name: 'property_name') String? propertyName,
      @JsonKey(name: 'booking_id') int? bookingId,
      @JsonKey(name: 'task_id') int? taskId,
      String? description,
      String? status,
      String? color});
}

/// @nodoc
class _$CalendarEventModelCopyWithImpl<$Res, $Val extends CalendarEventModel>
    implements $CalendarEventModelCopyWith<$Res> {
  _$CalendarEventModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CalendarEventModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? eventType = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? allDay = null,
    Object? propertyId = freezed,
    Object? propertyName = freezed,
    Object? bookingId = freezed,
    Object? taskId = freezed,
    Object? description = freezed,
    Object? status = freezed,
    Object? color = freezed,
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
      eventType: null == eventType
          ? _value.eventType
          : eventType // ignore: cast_nullable_to_non_nullable
              as CalendarEventType,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      allDay: null == allDay
          ? _value.allDay
          : allDay // ignore: cast_nullable_to_non_nullable
              as bool,
      propertyId: freezed == propertyId
          ? _value.propertyId
          : propertyId // ignore: cast_nullable_to_non_nullable
              as int?,
      propertyName: freezed == propertyName
          ? _value.propertyName
          : propertyName // ignore: cast_nullable_to_non_nullable
              as String?,
      bookingId: freezed == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as int?,
      taskId: freezed == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as int?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CalendarEventModelImplCopyWith<$Res>
    implements $CalendarEventModelCopyWith<$Res> {
  factory _$$CalendarEventModelImplCopyWith(_$CalendarEventModelImpl value,
          $Res Function(_$CalendarEventModelImpl) then) =
      __$$CalendarEventModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      @JsonKey(name: 'event_type') CalendarEventType eventType,
      @JsonKey(name: 'start_date') DateTime startDate,
      @JsonKey(name: 'end_date') DateTime? endDate,
      @JsonKey(name: 'all_day') bool allDay,
      @JsonKey(name: 'property_id') int? propertyId,
      @JsonKey(name: 'property_name') String? propertyName,
      @JsonKey(name: 'booking_id') int? bookingId,
      @JsonKey(name: 'task_id') int? taskId,
      String? description,
      String? status,
      String? color});
}

/// @nodoc
class __$$CalendarEventModelImplCopyWithImpl<$Res>
    extends _$CalendarEventModelCopyWithImpl<$Res, _$CalendarEventModelImpl>
    implements _$$CalendarEventModelImplCopyWith<$Res> {
  __$$CalendarEventModelImplCopyWithImpl(_$CalendarEventModelImpl _value,
      $Res Function(_$CalendarEventModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of CalendarEventModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? eventType = null,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? allDay = null,
    Object? propertyId = freezed,
    Object? propertyName = freezed,
    Object? bookingId = freezed,
    Object? taskId = freezed,
    Object? description = freezed,
    Object? status = freezed,
    Object? color = freezed,
  }) {
    return _then(_$CalendarEventModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      eventType: null == eventType
          ? _value.eventType
          : eventType // ignore: cast_nullable_to_non_nullable
              as CalendarEventType,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      allDay: null == allDay
          ? _value.allDay
          : allDay // ignore: cast_nullable_to_non_nullable
              as bool,
      propertyId: freezed == propertyId
          ? _value.propertyId
          : propertyId // ignore: cast_nullable_to_non_nullable
              as int?,
      propertyName: freezed == propertyName
          ? _value.propertyName
          : propertyName // ignore: cast_nullable_to_non_nullable
              as String?,
      bookingId: freezed == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as int?,
      taskId: freezed == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as int?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CalendarEventModelImpl extends _CalendarEventModel {
  const _$CalendarEventModelImpl(
      {required this.id,
      required this.title,
      @JsonKey(name: 'event_type') required this.eventType,
      @JsonKey(name: 'start_date') required this.startDate,
      @JsonKey(name: 'end_date') this.endDate,
      @JsonKey(name: 'all_day') this.allDay = false,
      @JsonKey(name: 'property_id') this.propertyId,
      @JsonKey(name: 'property_name') this.propertyName,
      @JsonKey(name: 'booking_id') this.bookingId,
      @JsonKey(name: 'task_id') this.taskId,
      this.description,
      this.status,
      this.color})
      : super._();

  factory _$CalendarEventModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CalendarEventModelImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  @JsonKey(name: 'event_type')
  final CalendarEventType eventType;
  @override
  @JsonKey(name: 'start_date')
  final DateTime startDate;
  @override
  @JsonKey(name: 'end_date')
  final DateTime? endDate;
  @override
  @JsonKey(name: 'all_day')
  final bool allDay;
  @override
  @JsonKey(name: 'property_id')
  final int? propertyId;
  @override
  @JsonKey(name: 'property_name')
  final String? propertyName;
  @override
  @JsonKey(name: 'booking_id')
  final int? bookingId;
  @override
  @JsonKey(name: 'task_id')
  final int? taskId;
  @override
  final String? description;
  @override
  final String? status;
  @override
  final String? color;

  @override
  String toString() {
    return 'CalendarEventModel(id: $id, title: $title, eventType: $eventType, startDate: $startDate, endDate: $endDate, allDay: $allDay, propertyId: $propertyId, propertyName: $propertyName, bookingId: $bookingId, taskId: $taskId, description: $description, status: $status, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CalendarEventModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.eventType, eventType) ||
                other.eventType == eventType) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.allDay, allDay) || other.allDay == allDay) &&
            (identical(other.propertyId, propertyId) ||
                other.propertyId == propertyId) &&
            (identical(other.propertyName, propertyName) ||
                other.propertyName == propertyName) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.color, color) || other.color == color));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      eventType,
      startDate,
      endDate,
      allDay,
      propertyId,
      propertyName,
      bookingId,
      taskId,
      description,
      status,
      color);

  /// Create a copy of CalendarEventModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CalendarEventModelImplCopyWith<_$CalendarEventModelImpl> get copyWith =>
      __$$CalendarEventModelImplCopyWithImpl<_$CalendarEventModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CalendarEventModelImplToJson(
      this,
    );
  }
}

abstract class _CalendarEventModel extends CalendarEventModel {
  const factory _CalendarEventModel(
      {required final int id,
      required final String title,
      @JsonKey(name: 'event_type') required final CalendarEventType eventType,
      @JsonKey(name: 'start_date') required final DateTime startDate,
      @JsonKey(name: 'end_date') final DateTime? endDate,
      @JsonKey(name: 'all_day') final bool allDay,
      @JsonKey(name: 'property_id') final int? propertyId,
      @JsonKey(name: 'property_name') final String? propertyName,
      @JsonKey(name: 'booking_id') final int? bookingId,
      @JsonKey(name: 'task_id') final int? taskId,
      final String? description,
      final String? status,
      final String? color}) = _$CalendarEventModelImpl;
  const _CalendarEventModel._() : super._();

  factory _CalendarEventModel.fromJson(Map<String, dynamic> json) =
      _$CalendarEventModelImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  @JsonKey(name: 'event_type')
  CalendarEventType get eventType;
  @override
  @JsonKey(name: 'start_date')
  DateTime get startDate;
  @override
  @JsonKey(name: 'end_date')
  DateTime? get endDate;
  @override
  @JsonKey(name: 'all_day')
  bool get allDay;
  @override
  @JsonKey(name: 'property_id')
  int? get propertyId;
  @override
  @JsonKey(name: 'property_name')
  String? get propertyName;
  @override
  @JsonKey(name: 'booking_id')
  int? get bookingId;
  @override
  @JsonKey(name: 'task_id')
  int? get taskId;
  @override
  String? get description;
  @override
  String? get status;
  @override
  String? get color;

  /// Create a copy of CalendarEventModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CalendarEventModelImplCopyWith<_$CalendarEventModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CalendarDateRange _$CalendarDateRangeFromJson(Map<String, dynamic> json) {
  return _CalendarDateRange.fromJson(json);
}

/// @nodoc
mixin _$CalendarDateRange {
  DateTime get start => throw _privateConstructorUsedError;
  DateTime get end => throw _privateConstructorUsedError;

  /// Serializes this CalendarDateRange to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CalendarDateRange
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CalendarDateRangeCopyWith<CalendarDateRange> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CalendarDateRangeCopyWith<$Res> {
  factory $CalendarDateRangeCopyWith(
          CalendarDateRange value, $Res Function(CalendarDateRange) then) =
      _$CalendarDateRangeCopyWithImpl<$Res, CalendarDateRange>;
  @useResult
  $Res call({DateTime start, DateTime end});
}

/// @nodoc
class _$CalendarDateRangeCopyWithImpl<$Res, $Val extends CalendarDateRange>
    implements $CalendarDateRangeCopyWith<$Res> {
  _$CalendarDateRangeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CalendarDateRange
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? start = null,
    Object? end = null,
  }) {
    return _then(_value.copyWith(
      start: null == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as DateTime,
      end: null == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CalendarDateRangeImplCopyWith<$Res>
    implements $CalendarDateRangeCopyWith<$Res> {
  factory _$$CalendarDateRangeImplCopyWith(_$CalendarDateRangeImpl value,
          $Res Function(_$CalendarDateRangeImpl) then) =
      __$$CalendarDateRangeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime start, DateTime end});
}

/// @nodoc
class __$$CalendarDateRangeImplCopyWithImpl<$Res>
    extends _$CalendarDateRangeCopyWithImpl<$Res, _$CalendarDateRangeImpl>
    implements _$$CalendarDateRangeImplCopyWith<$Res> {
  __$$CalendarDateRangeImplCopyWithImpl(_$CalendarDateRangeImpl _value,
      $Res Function(_$CalendarDateRangeImpl) _then)
      : super(_value, _then);

  /// Create a copy of CalendarDateRange
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? start = null,
    Object? end = null,
  }) {
    return _then(_$CalendarDateRangeImpl(
      start: null == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as DateTime,
      end: null == end
          ? _value.end
          : end // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CalendarDateRangeImpl extends _CalendarDateRange {
  const _$CalendarDateRangeImpl({required this.start, required this.end})
      : super._();

  factory _$CalendarDateRangeImpl.fromJson(Map<String, dynamic> json) =>
      _$$CalendarDateRangeImplFromJson(json);

  @override
  final DateTime start;
  @override
  final DateTime end;

  @override
  String toString() {
    return 'CalendarDateRange(start: $start, end: $end)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CalendarDateRangeImpl &&
            (identical(other.start, start) || other.start == start) &&
            (identical(other.end, end) || other.end == end));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, start, end);

  /// Create a copy of CalendarDateRange
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CalendarDateRangeImplCopyWith<_$CalendarDateRangeImpl> get copyWith =>
      __$$CalendarDateRangeImplCopyWithImpl<_$CalendarDateRangeImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CalendarDateRangeImplToJson(
      this,
    );
  }
}

abstract class _CalendarDateRange extends CalendarDateRange {
  const factory _CalendarDateRange(
      {required final DateTime start,
      required final DateTime end}) = _$CalendarDateRangeImpl;
  const _CalendarDateRange._() : super._();

  factory _CalendarDateRange.fromJson(Map<String, dynamic> json) =
      _$CalendarDateRangeImpl.fromJson;

  @override
  DateTime get start;
  @override
  DateTime get end;

  /// Create a copy of CalendarDateRange
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CalendarDateRangeImplCopyWith<_$CalendarDateRangeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PortalDashboardStats _$PortalDashboardStatsFromJson(Map<String, dynamic> json) {
  return _PortalDashboardStats.fromJson(json);
}

/// @nodoc
mixin _$PortalDashboardStats {
  @JsonKey(name: 'total_properties')
  int get totalProperties => throw _privateConstructorUsedError;
  @JsonKey(name: 'active_bookings')
  int get activeBookings => throw _privateConstructorUsedError;
  @JsonKey(name: 'upcoming_bookings')
  int get upcomingBookings => throw _privateConstructorUsedError;
  @JsonKey(name: 'pending_tasks')
  int get pendingTasks => throw _privateConstructorUsedError;
  @JsonKey(name: 'photos_pending_approval')
  int get photosPendingApproval => throw _privateConstructorUsedError;
  @JsonKey(name: 'check_ins_today')
  int get checkInsToday => throw _privateConstructorUsedError;
  @JsonKey(name: 'check_outs_today')
  int get checkOutsToday => throw _privateConstructorUsedError;

  /// Serializes this PortalDashboardStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PortalDashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PortalDashboardStatsCopyWith<PortalDashboardStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PortalDashboardStatsCopyWith<$Res> {
  factory $PortalDashboardStatsCopyWith(PortalDashboardStats value,
          $Res Function(PortalDashboardStats) then) =
      _$PortalDashboardStatsCopyWithImpl<$Res, PortalDashboardStats>;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_properties') int totalProperties,
      @JsonKey(name: 'active_bookings') int activeBookings,
      @JsonKey(name: 'upcoming_bookings') int upcomingBookings,
      @JsonKey(name: 'pending_tasks') int pendingTasks,
      @JsonKey(name: 'photos_pending_approval') int photosPendingApproval,
      @JsonKey(name: 'check_ins_today') int checkInsToday,
      @JsonKey(name: 'check_outs_today') int checkOutsToday});
}

/// @nodoc
class _$PortalDashboardStatsCopyWithImpl<$Res,
        $Val extends PortalDashboardStats>
    implements $PortalDashboardStatsCopyWith<$Res> {
  _$PortalDashboardStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PortalDashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalProperties = null,
    Object? activeBookings = null,
    Object? upcomingBookings = null,
    Object? pendingTasks = null,
    Object? photosPendingApproval = null,
    Object? checkInsToday = null,
    Object? checkOutsToday = null,
  }) {
    return _then(_value.copyWith(
      totalProperties: null == totalProperties
          ? _value.totalProperties
          : totalProperties // ignore: cast_nullable_to_non_nullable
              as int,
      activeBookings: null == activeBookings
          ? _value.activeBookings
          : activeBookings // ignore: cast_nullable_to_non_nullable
              as int,
      upcomingBookings: null == upcomingBookings
          ? _value.upcomingBookings
          : upcomingBookings // ignore: cast_nullable_to_non_nullable
              as int,
      pendingTasks: null == pendingTasks
          ? _value.pendingTasks
          : pendingTasks // ignore: cast_nullable_to_non_nullable
              as int,
      photosPendingApproval: null == photosPendingApproval
          ? _value.photosPendingApproval
          : photosPendingApproval // ignore: cast_nullable_to_non_nullable
              as int,
      checkInsToday: null == checkInsToday
          ? _value.checkInsToday
          : checkInsToday // ignore: cast_nullable_to_non_nullable
              as int,
      checkOutsToday: null == checkOutsToday
          ? _value.checkOutsToday
          : checkOutsToday // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PortalDashboardStatsImplCopyWith<$Res>
    implements $PortalDashboardStatsCopyWith<$Res> {
  factory _$$PortalDashboardStatsImplCopyWith(_$PortalDashboardStatsImpl value,
          $Res Function(_$PortalDashboardStatsImpl) then) =
      __$$PortalDashboardStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_properties') int totalProperties,
      @JsonKey(name: 'active_bookings') int activeBookings,
      @JsonKey(name: 'upcoming_bookings') int upcomingBookings,
      @JsonKey(name: 'pending_tasks') int pendingTasks,
      @JsonKey(name: 'photos_pending_approval') int photosPendingApproval,
      @JsonKey(name: 'check_ins_today') int checkInsToday,
      @JsonKey(name: 'check_outs_today') int checkOutsToday});
}

/// @nodoc
class __$$PortalDashboardStatsImplCopyWithImpl<$Res>
    extends _$PortalDashboardStatsCopyWithImpl<$Res, _$PortalDashboardStatsImpl>
    implements _$$PortalDashboardStatsImplCopyWith<$Res> {
  __$$PortalDashboardStatsImplCopyWithImpl(_$PortalDashboardStatsImpl _value,
      $Res Function(_$PortalDashboardStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of PortalDashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalProperties = null,
    Object? activeBookings = null,
    Object? upcomingBookings = null,
    Object? pendingTasks = null,
    Object? photosPendingApproval = null,
    Object? checkInsToday = null,
    Object? checkOutsToday = null,
  }) {
    return _then(_$PortalDashboardStatsImpl(
      totalProperties: null == totalProperties
          ? _value.totalProperties
          : totalProperties // ignore: cast_nullable_to_non_nullable
              as int,
      activeBookings: null == activeBookings
          ? _value.activeBookings
          : activeBookings // ignore: cast_nullable_to_non_nullable
              as int,
      upcomingBookings: null == upcomingBookings
          ? _value.upcomingBookings
          : upcomingBookings // ignore: cast_nullable_to_non_nullable
              as int,
      pendingTasks: null == pendingTasks
          ? _value.pendingTasks
          : pendingTasks // ignore: cast_nullable_to_non_nullable
              as int,
      photosPendingApproval: null == photosPendingApproval
          ? _value.photosPendingApproval
          : photosPendingApproval // ignore: cast_nullable_to_non_nullable
              as int,
      checkInsToday: null == checkInsToday
          ? _value.checkInsToday
          : checkInsToday // ignore: cast_nullable_to_non_nullable
              as int,
      checkOutsToday: null == checkOutsToday
          ? _value.checkOutsToday
          : checkOutsToday // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PortalDashboardStatsImpl implements _PortalDashboardStats {
  const _$PortalDashboardStatsImpl(
      {@JsonKey(name: 'total_properties') this.totalProperties = 0,
      @JsonKey(name: 'active_bookings') this.activeBookings = 0,
      @JsonKey(name: 'upcoming_bookings') this.upcomingBookings = 0,
      @JsonKey(name: 'pending_tasks') this.pendingTasks = 0,
      @JsonKey(name: 'photos_pending_approval') this.photosPendingApproval = 0,
      @JsonKey(name: 'check_ins_today') this.checkInsToday = 0,
      @JsonKey(name: 'check_outs_today') this.checkOutsToday = 0});

  factory _$PortalDashboardStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$PortalDashboardStatsImplFromJson(json);

  @override
  @JsonKey(name: 'total_properties')
  final int totalProperties;
  @override
  @JsonKey(name: 'active_bookings')
  final int activeBookings;
  @override
  @JsonKey(name: 'upcoming_bookings')
  final int upcomingBookings;
  @override
  @JsonKey(name: 'pending_tasks')
  final int pendingTasks;
  @override
  @JsonKey(name: 'photos_pending_approval')
  final int photosPendingApproval;
  @override
  @JsonKey(name: 'check_ins_today')
  final int checkInsToday;
  @override
  @JsonKey(name: 'check_outs_today')
  final int checkOutsToday;

  @override
  String toString() {
    return 'PortalDashboardStats(totalProperties: $totalProperties, activeBookings: $activeBookings, upcomingBookings: $upcomingBookings, pendingTasks: $pendingTasks, photosPendingApproval: $photosPendingApproval, checkInsToday: $checkInsToday, checkOutsToday: $checkOutsToday)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PortalDashboardStatsImpl &&
            (identical(other.totalProperties, totalProperties) ||
                other.totalProperties == totalProperties) &&
            (identical(other.activeBookings, activeBookings) ||
                other.activeBookings == activeBookings) &&
            (identical(other.upcomingBookings, upcomingBookings) ||
                other.upcomingBookings == upcomingBookings) &&
            (identical(other.pendingTasks, pendingTasks) ||
                other.pendingTasks == pendingTasks) &&
            (identical(other.photosPendingApproval, photosPendingApproval) ||
                other.photosPendingApproval == photosPendingApproval) &&
            (identical(other.checkInsToday, checkInsToday) ||
                other.checkInsToday == checkInsToday) &&
            (identical(other.checkOutsToday, checkOutsToday) ||
                other.checkOutsToday == checkOutsToday));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalProperties,
      activeBookings,
      upcomingBookings,
      pendingTasks,
      photosPendingApproval,
      checkInsToday,
      checkOutsToday);

  /// Create a copy of PortalDashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PortalDashboardStatsImplCopyWith<_$PortalDashboardStatsImpl>
      get copyWith =>
          __$$PortalDashboardStatsImplCopyWithImpl<_$PortalDashboardStatsImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PortalDashboardStatsImplToJson(
      this,
    );
  }
}

abstract class _PortalDashboardStats implements PortalDashboardStats {
  const factory _PortalDashboardStats(
      {@JsonKey(name: 'total_properties') final int totalProperties,
      @JsonKey(name: 'active_bookings') final int activeBookings,
      @JsonKey(name: 'upcoming_bookings') final int upcomingBookings,
      @JsonKey(name: 'pending_tasks') final int pendingTasks,
      @JsonKey(name: 'photos_pending_approval') final int photosPendingApproval,
      @JsonKey(name: 'check_ins_today') final int checkInsToday,
      @JsonKey(name: 'check_outs_today')
      final int checkOutsToday}) = _$PortalDashboardStatsImpl;

  factory _PortalDashboardStats.fromJson(Map<String, dynamic> json) =
      _$PortalDashboardStatsImpl.fromJson;

  @override
  @JsonKey(name: 'total_properties')
  int get totalProperties;
  @override
  @JsonKey(name: 'active_bookings')
  int get activeBookings;
  @override
  @JsonKey(name: 'upcoming_bookings')
  int get upcomingBookings;
  @override
  @JsonKey(name: 'pending_tasks')
  int get pendingTasks;
  @override
  @JsonKey(name: 'photos_pending_approval')
  int get photosPendingApproval;
  @override
  @JsonKey(name: 'check_ins_today')
  int get checkInsToday;
  @override
  @JsonKey(name: 'check_outs_today')
  int get checkOutsToday;

  /// Create a copy of PortalDashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PortalDashboardStatsImplCopyWith<_$PortalDashboardStatsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
