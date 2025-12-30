/// Notification repository for Cosmo Management
///
/// Handles notification-related data operations.
library;

import '../../core/config/api_config.dart';
import '../models/notification_model.dart';
import 'base_repository.dart';

/// Notification repository
///
/// Handles CRUD operations for notifications.
class NotificationRepository extends BaseRepository {
  NotificationRepository({
    required super.apiService,
    required super.storageService,
  });

  /// Get paginated list of notifications
  Future<PaginatedNotifications> getNotifications({
    int page = 1,
    int pageSize = 20,
    bool? isRead,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
    };
    if (isRead != null) queryParams['is_read'] = isRead;

    final response = await apiService.get(
      ApiConfig.notifications,
      queryParameters: queryParams,
    );

    return PaginatedNotifications.fromJson(response);
  }

  /// Get unread notifications
  Future<PaginatedNotifications> getUnreadNotifications({
    int page = 1,
    int pageSize = 20,
  }) async {
    return getNotifications(page: page, pageSize: pageSize, isRead: false);
  }

  /// Get unread count
  Future<int> getUnreadCount() async {
    final response = await apiService.get(ApiConfig.notificationsUnreadCount);
    return response['count'] as int? ?? 0;
  }

  /// Get notification by ID
  Future<NotificationModel> getNotificationById(int id) async {
    final response = await apiService.get(ApiConfig.notificationDetail(id));
    return NotificationModel.fromJson(response);
  }

  /// Mark notification as read
  Future<NotificationModel> markAsRead(int id) async {
    final response = await apiService.post(ApiConfig.notificationMarkRead(id));
    return NotificationModel.fromJson(response);
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    await apiService.post(ApiConfig.notificationsMarkAllRead);
  }

  /// Delete notification
  Future<void> deleteNotification(int id) async {
    await apiService.delete(ApiConfig.notificationDetail(id));
  }
}

/// Paginated notifications response
class PaginatedNotifications {
  final int count;
  final String? next;
  final String? previous;
  final List<NotificationModel> results;

  PaginatedNotifications({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory PaginatedNotifications.fromJson(Map<String, dynamic> json) {
    return PaginatedNotifications(
      count: json['count'] as int? ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  bool get hasMore => next != null;
}
