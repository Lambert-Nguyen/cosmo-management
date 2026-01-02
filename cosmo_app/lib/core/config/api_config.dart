/// API configuration and endpoints for Cosmo Management
///
/// Centralizes all API endpoint definitions for easy maintenance.
/// Based on the backend Django REST framework endpoints.
library;

class ApiConfig {
  ApiConfig._();

  // ============================================
  // Authentication Endpoints (JWT)
  // ============================================

  /// Obtain JWT access + refresh tokens
  /// POST /api/token/
  static const String tokenObtain = '/api/token/';

  /// Refresh expired access token
  /// POST /api/token/refresh/
  static const String tokenRefresh = '/api/token/refresh/';

  /// Verify token validity
  /// POST /api/token/verify/
  static const String tokenVerify = '/api/token/verify/';

  /// Revoke single token (logout)
  /// POST /api/token/revoke/
  static const String tokenRevoke = '/api/token/revoke/';

  /// Revoke all user tokens
  /// POST /api/token/revoke-all/
  static const String tokenRevokeAll = '/api/token/revoke-all/';

  // ============================================
  // Registration Endpoints
  // ============================================

  /// Register new user
  /// POST /api/register/
  static const String register = '/api/register/';

  /// Validate invite code before registration
  /// POST /api/validate-invite/
  static const String validateInvite = '/api/validate-invite/';

  // ============================================
  // Password Reset Endpoints
  // ============================================

  /// Change password (authenticated)
  /// POST /api/users/change-password/
  static const String changePassword = '/api/users/change-password/';

  /// Request password reset (unauthenticated)
  /// POST /api/password-reset/
  static const String passwordReset = '/api/password-reset/';

  /// Confirm password reset with token
  /// POST /api/password-reset/confirm/
  static const String passwordResetConfirm = '/api/password-reset/confirm/';

  // ============================================
  // User Endpoints
  // ============================================

  /// Get current user profile
  /// GET /api/users/me/
  static const String userMe = '/api/users/me/';

  /// User list/create
  /// GET/POST /api/users/
  static const String users = '/api/users/';

  /// User detail/update/delete
  /// GET/PUT/PATCH/DELETE /api/users/{id}/
  static String userDetail(int id) => '/api/users/$id/';

  // ============================================
  // Task Endpoints
  // ============================================

  /// Task list/create
  /// GET/POST /api/tasks/
  static const String tasks = '/api/tasks/';

  /// Task detail/update/delete
  /// GET/PUT/PATCH/DELETE /api/tasks/{id}/
  static String taskDetail(int id) => '/api/tasks/$id/';

  /// Assigned tasks for current user
  /// GET /api/tasks/assigned/
  static const String tasksAssigned = '/api/tasks/assigned/';

  /// Tasks by status
  /// GET /api/tasks/by-status/?status={status}
  static String tasksByStatus(String status) =>
      '/api/tasks/by-status/?status=$status';

  // ============================================
  // Property Endpoints
  // ============================================

  /// Property list/create
  /// GET/POST /api/properties/
  static const String properties = '/api/properties/';

  /// Property detail/update/delete
  /// GET/PUT/PATCH/DELETE /api/properties/{id}/
  static String propertyDetail(int id) => '/api/properties/$id/';

  // ============================================
  // Notification Endpoints
  // ============================================

  /// Notification list
  /// GET /api/notifications/
  static const String notifications = '/api/notifications/';

  /// Notification detail
  /// GET /api/notifications/{id}/
  static String notificationDetail(int id) => '/api/notifications/$id/';

  /// Mark notification as read
  /// POST /api/notifications/{id}/mark-read/
  static String notificationMarkRead(int id) =>
      '/api/notifications/$id/mark-read/';

  /// Mark all notifications as read
  /// POST /api/notifications/mark-all-read/
  static const String notificationsMarkAllRead =
      '/api/notifications/mark-all-read/';

  /// Unread notification count
  /// GET /api/notifications/unread-count/
  static const String notificationsUnreadCount =
      '/api/notifications/unread-count/';

  // ============================================
  // Inventory Endpoints
  // ============================================

  /// Inventory list/create
  /// GET/POST /api/inventory/
  static const String inventory = '/api/inventory/';

  /// Inventory detail/update/delete
  /// GET/PUT/PATCH/DELETE /api/inventory/{id}/
  static String inventoryDetail(int id) => '/api/inventory/$id/';

  // ============================================
  // Report Endpoints
  // ============================================

  /// Reports list/create
  /// GET/POST /api/reports/
  static const String reports = '/api/reports/';

  /// Report detail
  /// GET /api/reports/{id}/
  static String reportDetail(int id) => '/api/reports/$id/';

  // ============================================
  // Chat/Messaging Endpoints
  // ============================================

  /// Chat rooms list
  /// GET /api/chat/rooms/
  static const String chatRooms = '/api/chat/rooms/';

  /// Chat room messages
  /// GET /api/chat/rooms/{id}/messages/
  static String chatMessages(int roomId) => '/api/chat/rooms/$roomId/messages/';

  /// Send message
  /// POST /api/chat/rooms/{id}/messages/
  static String sendMessage(int roomId) => '/api/chat/rooms/$roomId/messages/';
}
