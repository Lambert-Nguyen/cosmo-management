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

  /// Task count by status
  /// GET /api/tasks/count-by-status/
  static const String taskCountByStatus = '/api/tasks/count-by-status/';

  /// Assign task to current user
  /// POST /api/tasks/{id}/assign_to_me/
  static String taskAssignToMe(int id) => '/api/tasks/$id/assign_to_me/';

  /// Set task status
  /// POST /api/tasks/{id}/set_status/
  static String taskSetStatus(int id) => '/api/tasks/$id/set_status/';

  /// Mute task notifications
  /// POST /api/tasks/{id}/mute/
  static String taskMute(int id) => '/api/tasks/$id/mute/';

  /// Unmute task notifications
  /// POST /api/tasks/{id}/unmute/
  static String taskUnmute(int id) => '/api/tasks/$id/unmute/';

  /// Task images
  /// GET/POST /api/tasks/{id}/images/
  static String taskImages(int id) => '/api/tasks/$id/images/';

  /// Task image detail
  /// GET/PATCH/DELETE /api/tasks/{taskId}/images/{imageId}/
  static String taskImageDetail(int taskId, int imageId) =>
      '/api/tasks/$taskId/images/$imageId/';

  // ============================================
  // Staff Module Endpoints
  // ============================================

  /// Staff dashboard
  /// GET /api/mobile/dashboard/
  static const String staffDashboard = '/api/mobile/dashboard/';

  /// Offline sync
  /// POST /api/mobile/offline-sync/
  static const String offlineSync = '/api/mobile/offline-sync/';

  /// Staff task duplicate
  /// POST /api/staff/tasks/{id}/duplicate/
  static String taskDuplicate(int id) => '/api/staff/tasks/$id/duplicate/';

  /// Staff task progress
  /// GET /api/staff/tasks/{id}/progress/
  static String taskProgress(int id) => '/api/staff/tasks/$id/progress/';

  // ============================================
  // Checklist Endpoints
  // ============================================

  /// Task checklist
  /// GET /api/tasks/{id}/checklist/
  static String taskChecklist(int id) => '/api/tasks/$id/checklist/';

  /// Submit checklist response
  /// POST /api/tasks/{taskId}/checklist/respond/
  static String checklistRespond(int taskId) =>
      '/api/tasks/$taskId/checklist/respond/';

  /// Checklist item photo upload
  /// POST /api/staff/checklist/{itemId}/photo/
  static String checklistPhotoUpload(int itemId) =>
      '/api/staff/checklist/$itemId/photo/';

  /// Checklist photo deletion
  /// DELETE /api/staff/checklist/photos/{photoId}/
  static String checklistPhotoDelete(int photoId) =>
      '/api/staff/checklist/photos/$photoId/';

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
  // Staff Inventory Endpoints
  // ============================================

  /// Staff inventory lookup (with property filter)
  /// GET /api/staff/inventory/
  static const String staffInventory = '/api/staff/inventory/';

  /// Staff inventory detail
  /// GET /api/staff/inventory/{id}/
  static String staffInventoryDetail(int id) => '/api/staff/inventory/$id/';

  /// Staff inventory transactions list
  /// GET /api/staff/inventory/transactions/
  static const String staffInventoryTransactions =
      '/api/staff/inventory/transactions/';

  /// Log inventory transaction
  /// POST /api/staff/inventory/transaction/
  static const String staffInventoryTransaction =
      '/api/staff/inventory/transaction/';

  /// Get low stock alerts
  /// GET /api/staff/inventory/low-stock/
  static const String staffInventoryLowStock = '/api/staff/inventory/low-stock/';

  /// Report inventory shortage (creates restocking task)
  /// POST /api/staff/inventory/{id}/shortage/
  static String staffInventoryShortage(int id) =>
      '/api/staff/inventory/$id/shortage/';

  /// Inventory categories
  /// GET /api/staff/inventory/categories/
  static const String staffInventoryCategories =
      '/api/staff/inventory/categories/';

  // ============================================
  // Lost & Found Endpoints
  // ============================================

  /// Lost & found items list/create
  /// GET/POST /api/staff/lost-found/
  static const String staffLostFound = '/api/staff/lost-found/';

  /// Lost & found item detail
  /// GET/PUT/PATCH/DELETE /api/staff/lost-found/{id}/
  static String staffLostFoundDetail(int id) => '/api/staff/lost-found/$id/';

  /// Claim a found item
  /// POST /api/staff/lost-found/{id}/claim/
  static String staffLostFoundClaim(int id) => '/api/staff/lost-found/$id/claim/';

  /// Archive a lost & found item
  /// POST /api/staff/lost-found/{id}/archive/
  static String staffLostFoundArchive(int id) =>
      '/api/staff/lost-found/$id/archive/';

  /// Lost & found statistics
  /// GET /api/staff/lost-found/stats/
  static const String staffLostFoundStats = '/api/staff/lost-found/stats/';

  // ============================================
  // Photo Endpoints
  // ============================================

  /// Batch photo upload
  /// POST /api/staff/photos/upload/
  static const String staffPhotoUpload = '/api/staff/photos/upload/';

  /// Photo list (filterable by entity)
  /// GET /api/staff/photos/
  static const String staffPhotos = '/api/staff/photos/';

  /// Photo detail
  /// GET/DELETE /api/staff/photos/{id}/
  static String staffPhotoDetail(int id) => '/api/staff/photos/$id/';

  /// Photo comparison pairs for a task
  /// GET /api/staff/photos/comparison/{taskId}/
  static String staffPhotoComparison(int taskId) =>
      '/api/staff/photos/comparison/$taskId/';

  /// Approve/reject photo
  /// POST /api/staff/photos/{id}/review/
  static String staffPhotoReview(int id) => '/api/staff/photos/$id/review/';

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
