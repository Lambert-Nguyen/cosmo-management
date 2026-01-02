/// Task repository for Cosmo Management
///
/// Handles task-related data operations.
library;

import '../../core/config/api_config.dart';
import '../models/checklist_model.dart';
import '../models/dashboard_model.dart';
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
  String _taskChecklistCacheKey(int id) => 'task_checklist_$id';
  static const String _taskCountsCacheKey = 'task_counts';
  static const String _dashboardCacheKey = 'staff_dashboard';

  // ============================================
  // Staff Module Methods
  // ============================================

  /// Get task counts by status
  Future<TaskCountModel> getTaskCounts() async {
    return getCachedOrFetch<TaskCountModel>(
      cacheKey: _taskCountsCacheKey,
      fetchFunction: () async {
        final response = await apiService.get(ApiConfig.taskCountByStatus);
        return TaskCountModel.fromJson(response);
      },
      fromJson: (json) => TaskCountModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Get today's tasks for a user
  Future<List<TaskModel>> getTodaysTasks(int userId) async {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    final response = await apiService.get(
      ApiConfig.tasks,
      queryParameters: {
        'assigned_to': userId,
        'due_date__gte': todayStart.toIso8601String(),
        'due_date__lt': todayEnd.toIso8601String(),
        'status__in': 'pending,in_progress',
        'ordering': 'due_date',
      },
    );

    final paginated = PaginatedTasks.fromJson(response);
    return paginated.results;
  }

  /// Get task with full checklist data
  Future<TaskModel> getTaskWithChecklist(int id) async {
    return getCachedOrFetch<TaskModel>(
      cacheKey: _taskChecklistCacheKey(id),
      fetchFunction: () async {
        final response = await apiService.get(
          ApiConfig.taskDetail(id),
          queryParameters: {'include': 'checklist'},
        );
        return TaskModel.fromJson(response);
      },
      fromJson: (json) => TaskModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Assign task to current user
  Future<TaskModel> assignToMe(int taskId) async {
    final response = await apiService.post(ApiConfig.taskAssignToMe(taskId));
    await invalidateCache(_taskCacheKey(taskId));
    await invalidateCache(_taskChecklistCacheKey(taskId));
    return TaskModel.fromJson(response);
  }

  /// Set task status via dedicated endpoint
  Future<TaskModel> setStatus(int taskId, TaskStatus status) async {
    final response = await apiService.post(
      ApiConfig.taskSetStatus(taskId),
      data: {'status': status.value},
    );
    await invalidateCache(_taskCacheKey(taskId));
    await invalidateCache(_taskChecklistCacheKey(taskId));
    await invalidateCache(_taskCountsCacheKey);
    return TaskModel.fromJson(response);
  }

  /// Duplicate a task
  Future<TaskModel> duplicateTask(int taskId) async {
    final response = await apiService.post(ApiConfig.taskDuplicate(taskId));
    return TaskModel.fromJson(response);
  }

  /// Get task checklist
  Future<TaskChecklistModel> getTaskChecklist(int taskId) async {
    final response = await apiService.get(ApiConfig.taskChecklist(taskId));
    return TaskChecklistModel.fromJson(response);
  }

  /// Submit checklist response
  Future<ChecklistResponseModel> submitChecklistResponse({
    required int taskId,
    required int checklistItemId,
    bool? isCompleted,
    String? textValue,
    double? numberValue,
    List<String>? photoUrls,
    String? notes,
  }) async {
    final response = await apiService.post(
      ApiConfig.checklistRespond(taskId),
      data: {
        'checklist_item_id': checklistItemId,
        if (isCompleted != null) 'is_completed': isCompleted,
        if (textValue != null) 'text_response': textValue,
        if (numberValue != null) 'number_response': numberValue,
        if (photoUrls != null) 'photo_urls': photoUrls,
        if (notes != null) 'notes': notes,
      },
    );
    await invalidateCache(_taskChecklistCacheKey(taskId));
    return ChecklistResponseModel.fromJson(response);
  }

  /// Mute task notifications
  Future<void> muteTask(int taskId) async {
    await apiService.post(ApiConfig.taskMute(taskId));
    await invalidateCache(_taskCacheKey(taskId));
  }

  /// Unmute task notifications
  Future<void> unmuteTask(int taskId) async {
    await apiService.post(ApiConfig.taskUnmute(taskId));
    await invalidateCache(_taskCacheKey(taskId));
  }

  /// Get staff dashboard data
  Future<StaffDashboardModel> getStaffDashboard() async {
    return getCachedOrFetch<StaffDashboardModel>(
      cacheKey: _dashboardCacheKey,
      fetchFunction: () async {
        final response = await apiService.get(ApiConfig.staffDashboard);
        return StaffDashboardModel.fromJson(response);
      },
      fromJson: (json) =>
          StaffDashboardModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Upload checklist photo
  ///
  /// Returns the URL of the uploaded photo
  Future<String> uploadChecklistPhoto({
    required int checklistItemId,
    required String filePath,
  }) async {
    final response = await apiService.uploadFile<Map<String, dynamic>>(
      ApiConfig.checklistPhotoUpload(checklistItemId),
      filePath: filePath,
      fieldName: 'photo',
    );
    return response['url'] as String? ?? response['photo_url'] as String;
  }

  /// Invalidate dashboard cache
  Future<void> invalidateDashboardCache() async {
    await invalidateCache(_dashboardCacheKey);
    await invalidateCache(_taskCountsCacheKey);
  }
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
