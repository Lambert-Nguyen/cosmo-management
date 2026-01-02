// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TaskCountModel _$TaskCountModelFromJson(Map<String, dynamic> json) {
  return _TaskCountModel.fromJson(json);
}

/// @nodoc
mixin _$TaskCountModel {
  int get pending => throw _privateConstructorUsedError;
  @JsonKey(name: 'in_progress')
  int get inProgress => throw _privateConstructorUsedError;
  int get completed => throw _privateConstructorUsedError;
  int get overdue => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;

  /// Serializes this TaskCountModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskCountModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskCountModelCopyWith<TaskCountModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskCountModelCopyWith<$Res> {
  factory $TaskCountModelCopyWith(
          TaskCountModel value, $Res Function(TaskCountModel) then) =
      _$TaskCountModelCopyWithImpl<$Res, TaskCountModel>;
  @useResult
  $Res call(
      {int pending,
      @JsonKey(name: 'in_progress') int inProgress,
      int completed,
      int overdue,
      int total});
}

/// @nodoc
class _$TaskCountModelCopyWithImpl<$Res, $Val extends TaskCountModel>
    implements $TaskCountModelCopyWith<$Res> {
  _$TaskCountModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskCountModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pending = null,
    Object? inProgress = null,
    Object? completed = null,
    Object? overdue = null,
    Object? total = null,
  }) {
    return _then(_value.copyWith(
      pending: null == pending
          ? _value.pending
          : pending // ignore: cast_nullable_to_non_nullable
              as int,
      inProgress: null == inProgress
          ? _value.inProgress
          : inProgress // ignore: cast_nullable_to_non_nullable
              as int,
      completed: null == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as int,
      overdue: null == overdue
          ? _value.overdue
          : overdue // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TaskCountModelImplCopyWith<$Res>
    implements $TaskCountModelCopyWith<$Res> {
  factory _$$TaskCountModelImplCopyWith(_$TaskCountModelImpl value,
          $Res Function(_$TaskCountModelImpl) then) =
      __$$TaskCountModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int pending,
      @JsonKey(name: 'in_progress') int inProgress,
      int completed,
      int overdue,
      int total});
}

/// @nodoc
class __$$TaskCountModelImplCopyWithImpl<$Res>
    extends _$TaskCountModelCopyWithImpl<$Res, _$TaskCountModelImpl>
    implements _$$TaskCountModelImplCopyWith<$Res> {
  __$$TaskCountModelImplCopyWithImpl(
      _$TaskCountModelImpl _value, $Res Function(_$TaskCountModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of TaskCountModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pending = null,
    Object? inProgress = null,
    Object? completed = null,
    Object? overdue = null,
    Object? total = null,
  }) {
    return _then(_$TaskCountModelImpl(
      pending: null == pending
          ? _value.pending
          : pending // ignore: cast_nullable_to_non_nullable
              as int,
      inProgress: null == inProgress
          ? _value.inProgress
          : inProgress // ignore: cast_nullable_to_non_nullable
              as int,
      completed: null == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as int,
      overdue: null == overdue
          ? _value.overdue
          : overdue // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskCountModelImpl extends _TaskCountModel {
  const _$TaskCountModelImpl(
      {this.pending = 0,
      @JsonKey(name: 'in_progress') this.inProgress = 0,
      this.completed = 0,
      this.overdue = 0,
      this.total = 0})
      : super._();

  factory _$TaskCountModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskCountModelImplFromJson(json);

  @override
  @JsonKey()
  final int pending;
  @override
  @JsonKey(name: 'in_progress')
  final int inProgress;
  @override
  @JsonKey()
  final int completed;
  @override
  @JsonKey()
  final int overdue;
  @override
  @JsonKey()
  final int total;

  @override
  String toString() {
    return 'TaskCountModel(pending: $pending, inProgress: $inProgress, completed: $completed, overdue: $overdue, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskCountModelImpl &&
            (identical(other.pending, pending) || other.pending == pending) &&
            (identical(other.inProgress, inProgress) ||
                other.inProgress == inProgress) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.overdue, overdue) || other.overdue == overdue) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, pending, inProgress, completed, overdue, total);

  /// Create a copy of TaskCountModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskCountModelImplCopyWith<_$TaskCountModelImpl> get copyWith =>
      __$$TaskCountModelImplCopyWithImpl<_$TaskCountModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskCountModelImplToJson(
      this,
    );
  }
}

abstract class _TaskCountModel extends TaskCountModel {
  const factory _TaskCountModel(
      {final int pending,
      @JsonKey(name: 'in_progress') final int inProgress,
      final int completed,
      final int overdue,
      final int total}) = _$TaskCountModelImpl;
  const _TaskCountModel._() : super._();

  factory _TaskCountModel.fromJson(Map<String, dynamic> json) =
      _$TaskCountModelImpl.fromJson;

  @override
  int get pending;
  @override
  @JsonKey(name: 'in_progress')
  int get inProgress;
  @override
  int get completed;
  @override
  int get overdue;
  @override
  int get total;

  /// Create a copy of TaskCountModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskCountModelImplCopyWith<_$TaskCountModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ActivityModel _$ActivityModelFromJson(Map<String, dynamic> json) {
  return _ActivityModel.fromJson(json);
}

/// @nodoc
mixin _$ActivityModel {
  int get id => throw _privateConstructorUsedError;
  String get action => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'task_id')
  int? get taskId => throw _privateConstructorUsedError;
  @JsonKey(name: 'task_title')
  String? get taskTitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  int? get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_name')
  String? get userName => throw _privateConstructorUsedError;

  /// Serializes this ActivityModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivityModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityModelCopyWith<ActivityModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityModelCopyWith<$Res> {
  factory $ActivityModelCopyWith(
          ActivityModel value, $Res Function(ActivityModel) then) =
      _$ActivityModelCopyWithImpl<$Res, ActivityModel>;
  @useResult
  $Res call(
      {int id,
      String action,
      String? description,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'task_id') int? taskId,
      @JsonKey(name: 'task_title') String? taskTitle,
      @JsonKey(name: 'user_id') int? userId,
      @JsonKey(name: 'user_name') String? userName});
}

/// @nodoc
class _$ActivityModelCopyWithImpl<$Res, $Val extends ActivityModel>
    implements $ActivityModelCopyWith<$Res> {
  _$ActivityModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivityModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? action = null,
    Object? description = freezed,
    Object? createdAt = null,
    Object? taskId = freezed,
    Object? taskTitle = freezed,
    Object? userId = freezed,
    Object? userName = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      taskId: freezed == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as int?,
      taskTitle: freezed == taskTitle
          ? _value.taskTitle
          : taskTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ActivityModelImplCopyWith<$Res>
    implements $ActivityModelCopyWith<$Res> {
  factory _$$ActivityModelImplCopyWith(
          _$ActivityModelImpl value, $Res Function(_$ActivityModelImpl) then) =
      __$$ActivityModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String action,
      String? description,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'task_id') int? taskId,
      @JsonKey(name: 'task_title') String? taskTitle,
      @JsonKey(name: 'user_id') int? userId,
      @JsonKey(name: 'user_name') String? userName});
}

/// @nodoc
class __$$ActivityModelImplCopyWithImpl<$Res>
    extends _$ActivityModelCopyWithImpl<$Res, _$ActivityModelImpl>
    implements _$$ActivityModelImplCopyWith<$Res> {
  __$$ActivityModelImplCopyWithImpl(
      _$ActivityModelImpl _value, $Res Function(_$ActivityModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ActivityModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? action = null,
    Object? description = freezed,
    Object? createdAt = null,
    Object? taskId = freezed,
    Object? taskTitle = freezed,
    Object? userId = freezed,
    Object? userName = freezed,
  }) {
    return _then(_$ActivityModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      taskId: freezed == taskId
          ? _value.taskId
          : taskId // ignore: cast_nullable_to_non_nullable
              as int?,
      taskTitle: freezed == taskTitle
          ? _value.taskTitle
          : taskTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      userName: freezed == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityModelImpl extends _ActivityModel {
  const _$ActivityModelImpl(
      {required this.id,
      required this.action,
      this.description,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'task_id') this.taskId,
      @JsonKey(name: 'task_title') this.taskTitle,
      @JsonKey(name: 'user_id') this.userId,
      @JsonKey(name: 'user_name') this.userName})
      : super._();

  factory _$ActivityModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityModelImplFromJson(json);

  @override
  final int id;
  @override
  final String action;
  @override
  final String? description;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'task_id')
  final int? taskId;
  @override
  @JsonKey(name: 'task_title')
  final String? taskTitle;
  @override
  @JsonKey(name: 'user_id')
  final int? userId;
  @override
  @JsonKey(name: 'user_name')
  final String? userName;

  @override
  String toString() {
    return 'ActivityModel(id: $id, action: $action, description: $description, createdAt: $createdAt, taskId: $taskId, taskTitle: $taskTitle, userId: $userId, userName: $userName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.taskId, taskId) || other.taskId == taskId) &&
            (identical(other.taskTitle, taskTitle) ||
                other.taskTitle == taskTitle) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, action, description,
      createdAt, taskId, taskTitle, userId, userName);

  /// Create a copy of ActivityModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityModelImplCopyWith<_$ActivityModelImpl> get copyWith =>
      __$$ActivityModelImplCopyWithImpl<_$ActivityModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityModelImplToJson(
      this,
    );
  }
}

abstract class _ActivityModel extends ActivityModel {
  const factory _ActivityModel(
          {required final int id,
          required final String action,
          final String? description,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'task_id') final int? taskId,
          @JsonKey(name: 'task_title') final String? taskTitle,
          @JsonKey(name: 'user_id') final int? userId,
          @JsonKey(name: 'user_name') final String? userName}) =
      _$ActivityModelImpl;
  const _ActivityModel._() : super._();

  factory _ActivityModel.fromJson(Map<String, dynamic> json) =
      _$ActivityModelImpl.fromJson;

  @override
  int get id;
  @override
  String get action;
  @override
  String? get description;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'task_id')
  int? get taskId;
  @override
  @JsonKey(name: 'task_title')
  String? get taskTitle;
  @override
  @JsonKey(name: 'user_id')
  int? get userId;
  @override
  @JsonKey(name: 'user_name')
  String? get userName;

  /// Create a copy of ActivityModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityModelImplCopyWith<_$ActivityModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StaffDashboardModel _$StaffDashboardModelFromJson(Map<String, dynamic> json) {
  return _StaffDashboardModel.fromJson(json);
}

/// @nodoc
mixin _$StaffDashboardModel {
  /// Task counts by status
  @JsonKey(name: 'task_counts')
  TaskCountModel get taskCounts => throw _privateConstructorUsedError;

  /// Tasks due today
  @JsonKey(name: 'todays_tasks')
  List<TaskModel> get todaysTasks => throw _privateConstructorUsedError;

  /// Upcoming tasks (next 7 days)
  @JsonKey(name: 'upcoming_tasks')
  List<TaskModel> get upcomingTasks => throw _privateConstructorUsedError;

  /// Overdue tasks requiring attention
  @JsonKey(name: 'overdue_tasks')
  List<TaskModel> get overdueTasks => throw _privateConstructorUsedError;

  /// Recent activity log
  @JsonKey(name: 'recent_activity')
  List<ActivityModel> get recentActivity => throw _privateConstructorUsedError;

  /// Server timestamp for sync
  @JsonKey(name: 'server_time')
  DateTime? get serverTime => throw _privateConstructorUsedError;

  /// Serializes this StaffDashboardModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StaffDashboardModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StaffDashboardModelCopyWith<StaffDashboardModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StaffDashboardModelCopyWith<$Res> {
  factory $StaffDashboardModelCopyWith(
          StaffDashboardModel value, $Res Function(StaffDashboardModel) then) =
      _$StaffDashboardModelCopyWithImpl<$Res, StaffDashboardModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'task_counts') TaskCountModel taskCounts,
      @JsonKey(name: 'todays_tasks') List<TaskModel> todaysTasks,
      @JsonKey(name: 'upcoming_tasks') List<TaskModel> upcomingTasks,
      @JsonKey(name: 'overdue_tasks') List<TaskModel> overdueTasks,
      @JsonKey(name: 'recent_activity') List<ActivityModel> recentActivity,
      @JsonKey(name: 'server_time') DateTime? serverTime});

  $TaskCountModelCopyWith<$Res> get taskCounts;
}

/// @nodoc
class _$StaffDashboardModelCopyWithImpl<$Res, $Val extends StaffDashboardModel>
    implements $StaffDashboardModelCopyWith<$Res> {
  _$StaffDashboardModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StaffDashboardModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? taskCounts = null,
    Object? todaysTasks = null,
    Object? upcomingTasks = null,
    Object? overdueTasks = null,
    Object? recentActivity = null,
    Object? serverTime = freezed,
  }) {
    return _then(_value.copyWith(
      taskCounts: null == taskCounts
          ? _value.taskCounts
          : taskCounts // ignore: cast_nullable_to_non_nullable
              as TaskCountModel,
      todaysTasks: null == todaysTasks
          ? _value.todaysTasks
          : todaysTasks // ignore: cast_nullable_to_non_nullable
              as List<TaskModel>,
      upcomingTasks: null == upcomingTasks
          ? _value.upcomingTasks
          : upcomingTasks // ignore: cast_nullable_to_non_nullable
              as List<TaskModel>,
      overdueTasks: null == overdueTasks
          ? _value.overdueTasks
          : overdueTasks // ignore: cast_nullable_to_non_nullable
              as List<TaskModel>,
      recentActivity: null == recentActivity
          ? _value.recentActivity
          : recentActivity // ignore: cast_nullable_to_non_nullable
              as List<ActivityModel>,
      serverTime: freezed == serverTime
          ? _value.serverTime
          : serverTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  /// Create a copy of StaffDashboardModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TaskCountModelCopyWith<$Res> get taskCounts {
    return $TaskCountModelCopyWith<$Res>(_value.taskCounts, (value) {
      return _then(_value.copyWith(taskCounts: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StaffDashboardModelImplCopyWith<$Res>
    implements $StaffDashboardModelCopyWith<$Res> {
  factory _$$StaffDashboardModelImplCopyWith(_$StaffDashboardModelImpl value,
          $Res Function(_$StaffDashboardModelImpl) then) =
      __$$StaffDashboardModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'task_counts') TaskCountModel taskCounts,
      @JsonKey(name: 'todays_tasks') List<TaskModel> todaysTasks,
      @JsonKey(name: 'upcoming_tasks') List<TaskModel> upcomingTasks,
      @JsonKey(name: 'overdue_tasks') List<TaskModel> overdueTasks,
      @JsonKey(name: 'recent_activity') List<ActivityModel> recentActivity,
      @JsonKey(name: 'server_time') DateTime? serverTime});

  @override
  $TaskCountModelCopyWith<$Res> get taskCounts;
}

/// @nodoc
class __$$StaffDashboardModelImplCopyWithImpl<$Res>
    extends _$StaffDashboardModelCopyWithImpl<$Res, _$StaffDashboardModelImpl>
    implements _$$StaffDashboardModelImplCopyWith<$Res> {
  __$$StaffDashboardModelImplCopyWithImpl(_$StaffDashboardModelImpl _value,
      $Res Function(_$StaffDashboardModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of StaffDashboardModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? taskCounts = null,
    Object? todaysTasks = null,
    Object? upcomingTasks = null,
    Object? overdueTasks = null,
    Object? recentActivity = null,
    Object? serverTime = freezed,
  }) {
    return _then(_$StaffDashboardModelImpl(
      taskCounts: null == taskCounts
          ? _value.taskCounts
          : taskCounts // ignore: cast_nullable_to_non_nullable
              as TaskCountModel,
      todaysTasks: null == todaysTasks
          ? _value._todaysTasks
          : todaysTasks // ignore: cast_nullable_to_non_nullable
              as List<TaskModel>,
      upcomingTasks: null == upcomingTasks
          ? _value._upcomingTasks
          : upcomingTasks // ignore: cast_nullable_to_non_nullable
              as List<TaskModel>,
      overdueTasks: null == overdueTasks
          ? _value._overdueTasks
          : overdueTasks // ignore: cast_nullable_to_non_nullable
              as List<TaskModel>,
      recentActivity: null == recentActivity
          ? _value._recentActivity
          : recentActivity // ignore: cast_nullable_to_non_nullable
              as List<ActivityModel>,
      serverTime: freezed == serverTime
          ? _value.serverTime
          : serverTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StaffDashboardModelImpl extends _StaffDashboardModel {
  const _$StaffDashboardModelImpl(
      {@JsonKey(name: 'task_counts') required this.taskCounts,
      @JsonKey(name: 'todays_tasks')
      final List<TaskModel> todaysTasks = const [],
      @JsonKey(name: 'upcoming_tasks')
      final List<TaskModel> upcomingTasks = const [],
      @JsonKey(name: 'overdue_tasks')
      final List<TaskModel> overdueTasks = const [],
      @JsonKey(name: 'recent_activity')
      final List<ActivityModel> recentActivity = const [],
      @JsonKey(name: 'server_time') this.serverTime})
      : _todaysTasks = todaysTasks,
        _upcomingTasks = upcomingTasks,
        _overdueTasks = overdueTasks,
        _recentActivity = recentActivity,
        super._();

  factory _$StaffDashboardModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$StaffDashboardModelImplFromJson(json);

  /// Task counts by status
  @override
  @JsonKey(name: 'task_counts')
  final TaskCountModel taskCounts;

  /// Tasks due today
  final List<TaskModel> _todaysTasks;

  /// Tasks due today
  @override
  @JsonKey(name: 'todays_tasks')
  List<TaskModel> get todaysTasks {
    if (_todaysTasks is EqualUnmodifiableListView) return _todaysTasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_todaysTasks);
  }

  /// Upcoming tasks (next 7 days)
  final List<TaskModel> _upcomingTasks;

  /// Upcoming tasks (next 7 days)
  @override
  @JsonKey(name: 'upcoming_tasks')
  List<TaskModel> get upcomingTasks {
    if (_upcomingTasks is EqualUnmodifiableListView) return _upcomingTasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_upcomingTasks);
  }

  /// Overdue tasks requiring attention
  final List<TaskModel> _overdueTasks;

  /// Overdue tasks requiring attention
  @override
  @JsonKey(name: 'overdue_tasks')
  List<TaskModel> get overdueTasks {
    if (_overdueTasks is EqualUnmodifiableListView) return _overdueTasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_overdueTasks);
  }

  /// Recent activity log
  final List<ActivityModel> _recentActivity;

  /// Recent activity log
  @override
  @JsonKey(name: 'recent_activity')
  List<ActivityModel> get recentActivity {
    if (_recentActivity is EqualUnmodifiableListView) return _recentActivity;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentActivity);
  }

  /// Server timestamp for sync
  @override
  @JsonKey(name: 'server_time')
  final DateTime? serverTime;

  @override
  String toString() {
    return 'StaffDashboardModel(taskCounts: $taskCounts, todaysTasks: $todaysTasks, upcomingTasks: $upcomingTasks, overdueTasks: $overdueTasks, recentActivity: $recentActivity, serverTime: $serverTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StaffDashboardModelImpl &&
            (identical(other.taskCounts, taskCounts) ||
                other.taskCounts == taskCounts) &&
            const DeepCollectionEquality()
                .equals(other._todaysTasks, _todaysTasks) &&
            const DeepCollectionEquality()
                .equals(other._upcomingTasks, _upcomingTasks) &&
            const DeepCollectionEquality()
                .equals(other._overdueTasks, _overdueTasks) &&
            const DeepCollectionEquality()
                .equals(other._recentActivity, _recentActivity) &&
            (identical(other.serverTime, serverTime) ||
                other.serverTime == serverTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      taskCounts,
      const DeepCollectionEquality().hash(_todaysTasks),
      const DeepCollectionEquality().hash(_upcomingTasks),
      const DeepCollectionEquality().hash(_overdueTasks),
      const DeepCollectionEquality().hash(_recentActivity),
      serverTime);

  /// Create a copy of StaffDashboardModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StaffDashboardModelImplCopyWith<_$StaffDashboardModelImpl> get copyWith =>
      __$$StaffDashboardModelImplCopyWithImpl<_$StaffDashboardModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StaffDashboardModelImplToJson(
      this,
    );
  }
}

abstract class _StaffDashboardModel extends StaffDashboardModel {
  const factory _StaffDashboardModel(
      {@JsonKey(name: 'task_counts') required final TaskCountModel taskCounts,
      @JsonKey(name: 'todays_tasks') final List<TaskModel> todaysTasks,
      @JsonKey(name: 'upcoming_tasks') final List<TaskModel> upcomingTasks,
      @JsonKey(name: 'overdue_tasks') final List<TaskModel> overdueTasks,
      @JsonKey(name: 'recent_activity')
      final List<ActivityModel> recentActivity,
      @JsonKey(name: 'server_time')
      final DateTime? serverTime}) = _$StaffDashboardModelImpl;
  const _StaffDashboardModel._() : super._();

  factory _StaffDashboardModel.fromJson(Map<String, dynamic> json) =
      _$StaffDashboardModelImpl.fromJson;

  /// Task counts by status
  @override
  @JsonKey(name: 'task_counts')
  TaskCountModel get taskCounts;

  /// Tasks due today
  @override
  @JsonKey(name: 'todays_tasks')
  List<TaskModel> get todaysTasks;

  /// Upcoming tasks (next 7 days)
  @override
  @JsonKey(name: 'upcoming_tasks')
  List<TaskModel> get upcomingTasks;

  /// Overdue tasks requiring attention
  @override
  @JsonKey(name: 'overdue_tasks')
  List<TaskModel> get overdueTasks;

  /// Recent activity log
  @override
  @JsonKey(name: 'recent_activity')
  List<ActivityModel> get recentActivity;

  /// Server timestamp for sync
  @override
  @JsonKey(name: 'server_time')
  DateTime? get serverTime;

  /// Create a copy of StaffDashboardModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StaffDashboardModelImplCopyWith<_$StaffDashboardModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DashboardStatModel _$DashboardStatModelFromJson(Map<String, dynamic> json) {
  return _DashboardStatModel.fromJson(json);
}

/// @nodoc
mixin _$DashboardStatModel {
  String get label => throw _privateConstructorUsedError;
  int get count => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  String? get icon => throw _privateConstructorUsedError;
  TaskStatus? get filterStatus => throw _privateConstructorUsedError;
  bool? get filterOverdue => throw _privateConstructorUsedError;

  /// Serializes this DashboardStatModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DashboardStatModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardStatModelCopyWith<DashboardStatModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardStatModelCopyWith<$Res> {
  factory $DashboardStatModelCopyWith(
          DashboardStatModel value, $Res Function(DashboardStatModel) then) =
      _$DashboardStatModelCopyWithImpl<$Res, DashboardStatModel>;
  @useResult
  $Res call(
      {String label,
      int count,
      String color,
      String? icon,
      TaskStatus? filterStatus,
      bool? filterOverdue});
}

/// @nodoc
class _$DashboardStatModelCopyWithImpl<$Res, $Val extends DashboardStatModel>
    implements $DashboardStatModelCopyWith<$Res> {
  _$DashboardStatModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardStatModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? count = null,
    Object? color = null,
    Object? icon = freezed,
    Object? filterStatus = freezed,
    Object? filterOverdue = freezed,
  }) {
    return _then(_value.copyWith(
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      filterStatus: freezed == filterStatus
          ? _value.filterStatus
          : filterStatus // ignore: cast_nullable_to_non_nullable
              as TaskStatus?,
      filterOverdue: freezed == filterOverdue
          ? _value.filterOverdue
          : filterOverdue // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DashboardStatModelImplCopyWith<$Res>
    implements $DashboardStatModelCopyWith<$Res> {
  factory _$$DashboardStatModelImplCopyWith(_$DashboardStatModelImpl value,
          $Res Function(_$DashboardStatModelImpl) then) =
      __$$DashboardStatModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String label,
      int count,
      String color,
      String? icon,
      TaskStatus? filterStatus,
      bool? filterOverdue});
}

/// @nodoc
class __$$DashboardStatModelImplCopyWithImpl<$Res>
    extends _$DashboardStatModelCopyWithImpl<$Res, _$DashboardStatModelImpl>
    implements _$$DashboardStatModelImplCopyWith<$Res> {
  __$$DashboardStatModelImplCopyWithImpl(_$DashboardStatModelImpl _value,
      $Res Function(_$DashboardStatModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of DashboardStatModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? count = null,
    Object? color = null,
    Object? icon = freezed,
    Object? filterStatus = freezed,
    Object? filterOverdue = freezed,
  }) {
    return _then(_$DashboardStatModelImpl(
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      count: null == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      filterStatus: freezed == filterStatus
          ? _value.filterStatus
          : filterStatus // ignore: cast_nullable_to_non_nullable
              as TaskStatus?,
      filterOverdue: freezed == filterOverdue
          ? _value.filterOverdue
          : filterOverdue // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardStatModelImpl implements _DashboardStatModel {
  const _$DashboardStatModelImpl(
      {required this.label,
      required this.count,
      required this.color,
      this.icon,
      this.filterStatus,
      this.filterOverdue});

  factory _$DashboardStatModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardStatModelImplFromJson(json);

  @override
  final String label;
  @override
  final int count;
  @override
  final String color;
  @override
  final String? icon;
  @override
  final TaskStatus? filterStatus;
  @override
  final bool? filterOverdue;

  @override
  String toString() {
    return 'DashboardStatModel(label: $label, count: $count, color: $color, icon: $icon, filterStatus: $filterStatus, filterOverdue: $filterOverdue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardStatModelImpl &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.filterStatus, filterStatus) ||
                other.filterStatus == filterStatus) &&
            (identical(other.filterOverdue, filterOverdue) ||
                other.filterOverdue == filterOverdue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, label, count, color, icon, filterStatus, filterOverdue);

  /// Create a copy of DashboardStatModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardStatModelImplCopyWith<_$DashboardStatModelImpl> get copyWith =>
      __$$DashboardStatModelImplCopyWithImpl<_$DashboardStatModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardStatModelImplToJson(
      this,
    );
  }
}

abstract class _DashboardStatModel implements DashboardStatModel {
  const factory _DashboardStatModel(
      {required final String label,
      required final int count,
      required final String color,
      final String? icon,
      final TaskStatus? filterStatus,
      final bool? filterOverdue}) = _$DashboardStatModelImpl;

  factory _DashboardStatModel.fromJson(Map<String, dynamic> json) =
      _$DashboardStatModelImpl.fromJson;

  @override
  String get label;
  @override
  int get count;
  @override
  String get color;
  @override
  String? get icon;
  @override
  TaskStatus? get filterStatus;
  @override
  bool? get filterOverdue;

  /// Create a copy of DashboardStatModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardStatModelImplCopyWith<_$DashboardStatModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
