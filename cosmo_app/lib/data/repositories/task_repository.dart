/// Task repository for Cosmo Management
///
/// Handles task-related data operations.
library;

import '../../core/config/api_config.dart';
import '../models/task_model.dart';
import 'base_repository.dart';

/// Task repository
///
/// Handles CRUD operations for tasks/work orders.
class TaskRepository extends BaseRepository {
  TaskRepository({
    required super.apiService,
    required super.storageService,
  });

  /// Get paginated list of tasks
  Future<PaginatedTasks> getTasks({
    int page = 1,
    int pageSize = 20,
    String? search,
    TaskStatus? status,
    TaskPriority? priority,
    int? propertyId,
    int? assignedToId,
    bool? overdue,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
    };
    if (search != null) queryParams['search'] = search;
    if (status != null) queryParams['status'] = status.value;
    if (priority != null) queryParams['priority'] = priority.value;
    if (propertyId != null) queryParams['property_id'] = propertyId;
    if (assignedToId != null) queryParams['assigned_to'] = assignedToId;
    if (overdue != null) queryParams['overdue'] = overdue;

    final response = await apiService.get(
      ApiConfig.tasks,
      queryParameters: queryParams,
    );

    return PaginatedTasks.fromJson(response);
  }

  /// Get task by ID
  Future<TaskModel> getTaskById(int id) async {
    return getCachedOrFetch<TaskModel>(
      cacheKey: _taskCacheKey(id),
      fetchFunction: () async {
        final response = await apiService.get(ApiConfig.taskDetail(id));
        return TaskModel.fromJson(response);
      },
      fromJson: (json) => TaskModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Create new task
  Future<TaskModel> createTask({
    required String title,
    String? description,
    String? taskType,
    TaskPriority priority = TaskPriority.medium,
    int? propertyId,
    int? assignedToId,
    DateTime? dueDate,
    int? estimatedDurationMinutes,
  }) async {
    final response = await apiService.post(
      ApiConfig.tasks,
      data: {
        'title': title,
        if (description != null) 'description': description,
        if (taskType != null) 'task_type': taskType,
        'priority': priority.value,
        if (propertyId != null) 'property_id': propertyId,
        if (assignedToId != null) 'assigned_to': assignedToId,
        if (dueDate != null) 'due_date': dueDate.toIso8601String(),
        if (estimatedDurationMinutes != null)
          'estimated_duration': estimatedDurationMinutes,
      },
    );
    return TaskModel.fromJson(response);
  }

  /// Update task
  Future<TaskModel> updateTask(
    int id, {
    String? title,
    String? description,
    String? taskType,
    TaskStatus? status,
    TaskPriority? priority,
    int? propertyId,
    int? assignedToId,
    DateTime? dueDate,
    String? notes,
    int? estimatedDurationMinutes,
    int? actualDurationMinutes,
  }) async {
    final data = <String, dynamic>{};
    if (title != null) data['title'] = title;
    if (description != null) data['description'] = description;
    if (taskType != null) data['task_type'] = taskType;
    if (status != null) data['status'] = status.value;
    if (priority != null) data['priority'] = priority.value;
    if (propertyId != null) data['property_id'] = propertyId;
    if (assignedToId != null) data['assigned_to'] = assignedToId;
    if (dueDate != null) data['due_date'] = dueDate.toIso8601String();
    if (notes != null) data['notes'] = notes;
    if (estimatedDurationMinutes != null) {
      data['estimated_duration'] = estimatedDurationMinutes;
    }
    if (actualDurationMinutes != null) {
      data['actual_duration'] = actualDurationMinutes;
    }

    final response = await apiService.patch(
      ApiConfig.taskDetail(id),
      data: data,
    );
    await invalidateCache(_taskCacheKey(id));
    return TaskModel.fromJson(response);
  }

  /// Delete task
  Future<void> deleteTask(int id) async {
    await apiService.delete(ApiConfig.taskDetail(id));
    await invalidateCache(_taskCacheKey(id));
  }

  /// Update task status
  Future<TaskModel> updateTaskStatus(int id, TaskStatus status) async {
    return updateTask(id, status: status);
  }

  /// Mark task as completed
  Future<TaskModel> completeTask(int id, {int? actualDurationMinutes}) async {
    return updateTask(
      id,
      status: TaskStatus.completed,
      actualDurationMinutes: actualDurationMinutes,
    );
  }

  /// Assign task to user
  Future<TaskModel> assignTask(int id, int assignedToId) async {
    return updateTask(id, assignedToId: assignedToId);
  }

  /// Get my tasks (assigned to current user)
  Future<PaginatedTasks> getMyTasks({
    required int userId,
    int page = 1,
    int pageSize = 20,
    TaskStatus? status,
  }) async {
    return getTasks(
      page: page,
      pageSize: pageSize,
      assignedToId: userId,
      status: status,
    );
  }

  /// Get overdue tasks
  Future<PaginatedTasks> getOverdueTasks({
    int page = 1,
    int pageSize = 20,
  }) async {
    return getTasks(
      page: page,
      pageSize: pageSize,
      overdue: true,
    );
  }

  /// Get tasks by property
  Future<PaginatedTasks> getTasksByProperty(
    int propertyId, {
    int page = 1,
    int pageSize = 20,
  }) async {
    return getTasks(
      page: page,
      pageSize: pageSize,
      propertyId: propertyId,
    );
  }

  String _taskCacheKey(int id) => 'task_$id';
}

/// Paginated tasks response
class PaginatedTasks {
  final int count;
  final String? next;
  final String? previous;
  final List<TaskModel> results;

  PaginatedTasks({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory PaginatedTasks.fromJson(Map<String, dynamic> json) {
    return PaginatedTasks(
      count: json['count'] as int? ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  bool get hasMore => next != null;
}
