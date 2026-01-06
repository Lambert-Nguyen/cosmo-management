// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TaskModel _$TaskModelFromJson(Map<String, dynamic> json) {
  return _TaskModel.fromJson(json);
}

/// @nodoc
mixin _$TaskModel {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'task_type')
  String? get taskType => throw _privateConstructorUsedError;
  TaskStatus get status => throw _privateConstructorUsedError;
  TaskPriority get priority => throw _privateConstructorUsedError;
  @JsonKey(name: 'property_id')
  int? get propertyId => throw _privateConstructorUsedError;
  @JsonKey(name: 'property_name')
  String? get propertyName => throw _privateConstructorUsedError;
  @JsonKey(name: 'assigned_to')
  int? get assignedToId => throw _privateConstructorUsedError;
  @JsonKey(name: 'assigned_to_name')
  String? get assignedToName => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_by')
  int? get createdById => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_by_name')
  String? get createdByName => throw _privateConstructorUsedError;
  @JsonKey(name: 'due_date')
  DateTime? get dueDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  List<String> get images => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'estimated_duration')
  int? get estimatedDurationMinutes => throw _privateConstructorUsedError;
  @JsonKey(name: 'actual_duration')
  int? get actualDurationMinutes => throw _privateConstructorUsedError;

  /// Checklist data (when included in response)
  TaskChecklistModel? get checklist => throw _privateConstructorUsedError;

  /// Checklist progress summary
  @JsonKey(name: 'checklist_progress')
  ChecklistProgressModel? get checklistProgress =>
      throw _privateConstructorUsedError;

  /// Whether checklist has incomplete blocking items
  @JsonKey(name: 'has_blocking_items')
  bool get hasBlockingItems => throw _privateConstructorUsedError;

  /// Serializes this TaskModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskModelCopyWith<TaskModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskModelCopyWith<$Res> {
  factory $TaskModelCopyWith(TaskModel value, $Res Function(TaskModel) then) =
      _$TaskModelCopyWithImpl<$Res, TaskModel>;
  @useResult
  $Res call(
      {int id,
      String title,
      String? description,
      @JsonKey(name: 'task_type') String? taskType,
      TaskStatus status,
      TaskPriority priority,
      @JsonKey(name: 'property_id') int? propertyId,
      @JsonKey(name: 'property_name') String? propertyName,
      @JsonKey(name: 'assigned_to') int? assignedToId,
      @JsonKey(name: 'assigned_to_name') String? assignedToName,
      @JsonKey(name: 'created_by') int? createdById,
      @JsonKey(name: 'created_by_name') String? createdByName,
      @JsonKey(name: 'due_date') DateTime? dueDate,
      @JsonKey(name: 'completed_at') DateTime? completedAt,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      List<String> images,
      String? notes,
      @JsonKey(name: 'estimated_duration') int? estimatedDurationMinutes,
      @JsonKey(name: 'actual_duration') int? actualDurationMinutes,
      TaskChecklistModel? checklist,
      @JsonKey(name: 'checklist_progress')
      ChecklistProgressModel? checklistProgress,
      @JsonKey(name: 'has_blocking_items') bool hasBlockingItems});

  $TaskChecklistModelCopyWith<$Res>? get checklist;
  $ChecklistProgressModelCopyWith<$Res>? get checklistProgress;
}

/// @nodoc
class _$TaskModelCopyWithImpl<$Res, $Val extends TaskModel>
    implements $TaskModelCopyWith<$Res> {
  _$TaskModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? taskType = freezed,
    Object? status = null,
    Object? priority = null,
    Object? propertyId = freezed,
    Object? propertyName = freezed,
    Object? assignedToId = freezed,
    Object? assignedToName = freezed,
    Object? createdById = freezed,
    Object? createdByName = freezed,
    Object? dueDate = freezed,
    Object? completedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? images = null,
    Object? notes = freezed,
    Object? estimatedDurationMinutes = freezed,
    Object? actualDurationMinutes = freezed,
    Object? checklist = freezed,
    Object? checklistProgress = freezed,
    Object? hasBlockingItems = null,
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
      taskType: freezed == taskType
          ? _value.taskType
          : taskType // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TaskStatus,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as TaskPriority,
      propertyId: freezed == propertyId
          ? _value.propertyId
          : propertyId // ignore: cast_nullable_to_non_nullable
              as int?,
      propertyName: freezed == propertyName
          ? _value.propertyName
          : propertyName // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedToId: freezed == assignedToId
          ? _value.assignedToId
          : assignedToId // ignore: cast_nullable_to_non_nullable
              as int?,
      assignedToName: freezed == assignedToName
          ? _value.assignedToName
          : assignedToName // ignore: cast_nullable_to_non_nullable
              as String?,
      createdById: freezed == createdById
          ? _value.createdById
          : createdById // ignore: cast_nullable_to_non_nullable
              as int?,
      createdByName: freezed == createdByName
          ? _value.createdByName
          : createdByName // ignore: cast_nullable_to_non_nullable
              as String?,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      estimatedDurationMinutes: freezed == estimatedDurationMinutes
          ? _value.estimatedDurationMinutes
          : estimatedDurationMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      actualDurationMinutes: freezed == actualDurationMinutes
          ? _value.actualDurationMinutes
          : actualDurationMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      checklist: freezed == checklist
          ? _value.checklist
          : checklist // ignore: cast_nullable_to_non_nullable
              as TaskChecklistModel?,
      checklistProgress: freezed == checklistProgress
          ? _value.checklistProgress
          : checklistProgress // ignore: cast_nullable_to_non_nullable
              as ChecklistProgressModel?,
      hasBlockingItems: null == hasBlockingItems
          ? _value.hasBlockingItems
          : hasBlockingItems // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of TaskModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TaskChecklistModelCopyWith<$Res>? get checklist {
    if (_value.checklist == null) {
      return null;
    }

    return $TaskChecklistModelCopyWith<$Res>(_value.checklist!, (value) {
      return _then(_value.copyWith(checklist: value) as $Val);
    });
  }

  /// Create a copy of TaskModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChecklistProgressModelCopyWith<$Res>? get checklistProgress {
    if (_value.checklistProgress == null) {
      return null;
    }

    return $ChecklistProgressModelCopyWith<$Res>(_value.checklistProgress!,
        (value) {
      return _then(_value.copyWith(checklistProgress: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TaskModelImplCopyWith<$Res>
    implements $TaskModelCopyWith<$Res> {
  factory _$$TaskModelImplCopyWith(
          _$TaskModelImpl value, $Res Function(_$TaskModelImpl) then) =
      __$$TaskModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      String? description,
      @JsonKey(name: 'task_type') String? taskType,
      TaskStatus status,
      TaskPriority priority,
      @JsonKey(name: 'property_id') int? propertyId,
      @JsonKey(name: 'property_name') String? propertyName,
      @JsonKey(name: 'assigned_to') int? assignedToId,
      @JsonKey(name: 'assigned_to_name') String? assignedToName,
      @JsonKey(name: 'created_by') int? createdById,
      @JsonKey(name: 'created_by_name') String? createdByName,
      @JsonKey(name: 'due_date') DateTime? dueDate,
      @JsonKey(name: 'completed_at') DateTime? completedAt,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      List<String> images,
      String? notes,
      @JsonKey(name: 'estimated_duration') int? estimatedDurationMinutes,
      @JsonKey(name: 'actual_duration') int? actualDurationMinutes,
      TaskChecklistModel? checklist,
      @JsonKey(name: 'checklist_progress')
      ChecklistProgressModel? checklistProgress,
      @JsonKey(name: 'has_blocking_items') bool hasBlockingItems});

  @override
  $TaskChecklistModelCopyWith<$Res>? get checklist;
  @override
  $ChecklistProgressModelCopyWith<$Res>? get checklistProgress;
}

/// @nodoc
class __$$TaskModelImplCopyWithImpl<$Res>
    extends _$TaskModelCopyWithImpl<$Res, _$TaskModelImpl>
    implements _$$TaskModelImplCopyWith<$Res> {
  __$$TaskModelImplCopyWithImpl(
      _$TaskModelImpl _value, $Res Function(_$TaskModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of TaskModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? taskType = freezed,
    Object? status = null,
    Object? priority = null,
    Object? propertyId = freezed,
    Object? propertyName = freezed,
    Object? assignedToId = freezed,
    Object? assignedToName = freezed,
    Object? createdById = freezed,
    Object? createdByName = freezed,
    Object? dueDate = freezed,
    Object? completedAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? images = null,
    Object? notes = freezed,
    Object? estimatedDurationMinutes = freezed,
    Object? actualDurationMinutes = freezed,
    Object? checklist = freezed,
    Object? checklistProgress = freezed,
    Object? hasBlockingItems = null,
  }) {
    return _then(_$TaskModelImpl(
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
      taskType: freezed == taskType
          ? _value.taskType
          : taskType // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TaskStatus,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as TaskPriority,
      propertyId: freezed == propertyId
          ? _value.propertyId
          : propertyId // ignore: cast_nullable_to_non_nullable
              as int?,
      propertyName: freezed == propertyName
          ? _value.propertyName
          : propertyName // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedToId: freezed == assignedToId
          ? _value.assignedToId
          : assignedToId // ignore: cast_nullable_to_non_nullable
              as int?,
      assignedToName: freezed == assignedToName
          ? _value.assignedToName
          : assignedToName // ignore: cast_nullable_to_non_nullable
              as String?,
      createdById: freezed == createdById
          ? _value.createdById
          : createdById // ignore: cast_nullable_to_non_nullable
              as int?,
      createdByName: freezed == createdByName
          ? _value.createdByName
          : createdByName // ignore: cast_nullable_to_non_nullable
              as String?,
      dueDate: freezed == dueDate
          ? _value.dueDate
          : dueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      estimatedDurationMinutes: freezed == estimatedDurationMinutes
          ? _value.estimatedDurationMinutes
          : estimatedDurationMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      actualDurationMinutes: freezed == actualDurationMinutes
          ? _value.actualDurationMinutes
          : actualDurationMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      checklist: freezed == checklist
          ? _value.checklist
          : checklist // ignore: cast_nullable_to_non_nullable
              as TaskChecklistModel?,
      checklistProgress: freezed == checklistProgress
          ? _value.checklistProgress
          : checklistProgress // ignore: cast_nullable_to_non_nullable
              as ChecklistProgressModel?,
      hasBlockingItems: null == hasBlockingItems
          ? _value.hasBlockingItems
          : hasBlockingItems // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskModelImpl extends _TaskModel {
  const _$TaskModelImpl(
      {required this.id,
      required this.title,
      this.description,
      @JsonKey(name: 'task_type') this.taskType,
      this.status = TaskStatus.pending,
      this.priority = TaskPriority.medium,
      @JsonKey(name: 'property_id') this.propertyId,
      @JsonKey(name: 'property_name') this.propertyName,
      @JsonKey(name: 'assigned_to') this.assignedToId,
      @JsonKey(name: 'assigned_to_name') this.assignedToName,
      @JsonKey(name: 'created_by') this.createdById,
      @JsonKey(name: 'created_by_name') this.createdByName,
      @JsonKey(name: 'due_date') this.dueDate,
      @JsonKey(name: 'completed_at') this.completedAt,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      final List<String> images = const [],
      this.notes,
      @JsonKey(name: 'estimated_duration') this.estimatedDurationMinutes,
      @JsonKey(name: 'actual_duration') this.actualDurationMinutes,
      this.checklist,
      @JsonKey(name: 'checklist_progress') this.checklistProgress,
      @JsonKey(name: 'has_blocking_items') this.hasBlockingItems = false})
      : _images = images,
        super._();

  factory _$TaskModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskModelImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String? description;
  @override
  @JsonKey(name: 'task_type')
  final String? taskType;
  @override
  @JsonKey()
  final TaskStatus status;
  @override
  @JsonKey()
  final TaskPriority priority;
  @override
  @JsonKey(name: 'property_id')
  final int? propertyId;
  @override
  @JsonKey(name: 'property_name')
  final String? propertyName;
  @override
  @JsonKey(name: 'assigned_to')
  final int? assignedToId;
  @override
  @JsonKey(name: 'assigned_to_name')
  final String? assignedToName;
  @override
  @JsonKey(name: 'created_by')
  final int? createdById;
  @override
  @JsonKey(name: 'created_by_name')
  final String? createdByName;
  @override
  @JsonKey(name: 'due_date')
  final DateTime? dueDate;
  @override
  @JsonKey(name: 'completed_at')
  final DateTime? completedAt;
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
  final String? notes;
  @override
  @JsonKey(name: 'estimated_duration')
  final int? estimatedDurationMinutes;
  @override
  @JsonKey(name: 'actual_duration')
  final int? actualDurationMinutes;

  /// Checklist data (when included in response)
  @override
  final TaskChecklistModel? checklist;

  /// Checklist progress summary
  @override
  @JsonKey(name: 'checklist_progress')
  final ChecklistProgressModel? checklistProgress;

  /// Whether checklist has incomplete blocking items
  @override
  @JsonKey(name: 'has_blocking_items')
  final bool hasBlockingItems;

  @override
  String toString() {
    return 'TaskModel(id: $id, title: $title, description: $description, taskType: $taskType, status: $status, priority: $priority, propertyId: $propertyId, propertyName: $propertyName, assignedToId: $assignedToId, assignedToName: $assignedToName, createdById: $createdById, createdByName: $createdByName, dueDate: $dueDate, completedAt: $completedAt, createdAt: $createdAt, updatedAt: $updatedAt, images: $images, notes: $notes, estimatedDurationMinutes: $estimatedDurationMinutes, actualDurationMinutes: $actualDurationMinutes, checklist: $checklist, checklistProgress: $checklistProgress, hasBlockingItems: $hasBlockingItems)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.taskType, taskType) ||
                other.taskType == taskType) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.propertyId, propertyId) ||
                other.propertyId == propertyId) &&
            (identical(other.propertyName, propertyName) ||
                other.propertyName == propertyName) &&
            (identical(other.assignedToId, assignedToId) ||
                other.assignedToId == assignedToId) &&
            (identical(other.assignedToName, assignedToName) ||
                other.assignedToName == assignedToName) &&
            (identical(other.createdById, createdById) ||
                other.createdById == createdById) &&
            (identical(other.createdByName, createdByName) ||
                other.createdByName == createdByName) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(
                    other.estimatedDurationMinutes, estimatedDurationMinutes) ||
                other.estimatedDurationMinutes == estimatedDurationMinutes) &&
            (identical(other.actualDurationMinutes, actualDurationMinutes) ||
                other.actualDurationMinutes == actualDurationMinutes) &&
            (identical(other.checklist, checklist) ||
                other.checklist == checklist) &&
            (identical(other.checklistProgress, checklistProgress) ||
                other.checklistProgress == checklistProgress) &&
            (identical(other.hasBlockingItems, hasBlockingItems) ||
                other.hasBlockingItems == hasBlockingItems));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        title,
        description,
        taskType,
        status,
        priority,
        propertyId,
        propertyName,
        assignedToId,
        assignedToName,
        createdById,
        createdByName,
        dueDate,
        completedAt,
        createdAt,
        updatedAt,
        const DeepCollectionEquality().hash(_images),
        notes,
        estimatedDurationMinutes,
        actualDurationMinutes,
        checklist,
        checklistProgress,
        hasBlockingItems
      ]);

  /// Create a copy of TaskModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskModelImplCopyWith<_$TaskModelImpl> get copyWith =>
      __$$TaskModelImplCopyWithImpl<_$TaskModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskModelImplToJson(
      this,
    );
  }
}

abstract class _TaskModel extends TaskModel {
  const factory _TaskModel(
      {required final int id,
      required final String title,
      final String? description,
      @JsonKey(name: 'task_type') final String? taskType,
      final TaskStatus status,
      final TaskPriority priority,
      @JsonKey(name: 'property_id') final int? propertyId,
      @JsonKey(name: 'property_name') final String? propertyName,
      @JsonKey(name: 'assigned_to') final int? assignedToId,
      @JsonKey(name: 'assigned_to_name') final String? assignedToName,
      @JsonKey(name: 'created_by') final int? createdById,
      @JsonKey(name: 'created_by_name') final String? createdByName,
      @JsonKey(name: 'due_date') final DateTime? dueDate,
      @JsonKey(name: 'completed_at') final DateTime? completedAt,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at') final DateTime? updatedAt,
      final List<String> images,
      final String? notes,
      @JsonKey(name: 'estimated_duration') final int? estimatedDurationMinutes,
      @JsonKey(name: 'actual_duration') final int? actualDurationMinutes,
      final TaskChecklistModel? checklist,
      @JsonKey(name: 'checklist_progress')
      final ChecklistProgressModel? checklistProgress,
      @JsonKey(name: 'has_blocking_items')
      final bool hasBlockingItems}) = _$TaskModelImpl;
  const _TaskModel._() : super._();

  factory _TaskModel.fromJson(Map<String, dynamic> json) =
      _$TaskModelImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  String? get description;
  @override
  @JsonKey(name: 'task_type')
  String? get taskType;
  @override
  TaskStatus get status;
  @override
  TaskPriority get priority;
  @override
  @JsonKey(name: 'property_id')
  int? get propertyId;
  @override
  @JsonKey(name: 'property_name')
  String? get propertyName;
  @override
  @JsonKey(name: 'assigned_to')
  int? get assignedToId;
  @override
  @JsonKey(name: 'assigned_to_name')
  String? get assignedToName;
  @override
  @JsonKey(name: 'created_by')
  int? get createdById;
  @override
  @JsonKey(name: 'created_by_name')
  String? get createdByName;
  @override
  @JsonKey(name: 'due_date')
  DateTime? get dueDate;
  @override
  @JsonKey(name: 'completed_at')
  DateTime? get completedAt;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  List<String> get images;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'estimated_duration')
  int? get estimatedDurationMinutes;
  @override
  @JsonKey(name: 'actual_duration')
  int? get actualDurationMinutes;

  /// Checklist data (when included in response)
  @override
  TaskChecklistModel? get checklist;

  /// Checklist progress summary
  @override
  @JsonKey(name: 'checklist_progress')
  ChecklistProgressModel? get checklistProgress;

  /// Whether checklist has incomplete blocking items
  @override
  @JsonKey(name: 'has_blocking_items')
  bool get hasBlockingItems;

  /// Create a copy of TaskModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskModelImplCopyWith<_$TaskModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
