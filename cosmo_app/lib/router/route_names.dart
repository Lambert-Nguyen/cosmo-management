/// Route name constants for Cosmo Management
///
/// Centralizes all route paths for type-safe navigation.
library;

/// Route path constants
///
/// Use these instead of raw strings for navigation.
class RouteNames {
  RouteNames._();

  // ============================================
  // Auth Routes
  // ============================================

  /// Splash/loading screen
  static const String splash = '/';

  /// Login screen
  static const String login = '/login';

  /// Register screen
  static const String register = '/register';

  /// Forgot password screen
  static const String forgotPassword = '/forgot-password';

  /// Password reset confirmation (from email link)
  static const String resetPassword = '/reset-password';

  // ============================================
  // Main App Routes
  // ============================================

  /// Home/dashboard
  static const String home = '/home';

  /// Tasks list
  static const String tasks = '/tasks';

  /// Task detail (use with id parameter)
  static String taskDetail(String id) => '/tasks/$id';

  /// Create new task
  static const String taskCreate = '/tasks/create';

  /// Properties list
  static const String properties = '/properties';

  /// Property detail
  static String propertyDetail(String id) => '/properties/$id';

  /// Notifications
  static const String notifications = '/notifications';

  // ============================================
  // Settings & Profile
  // ============================================

  /// Settings
  static const String settings = '/settings';

  /// User profile
  static const String profile = '/profile';

  // ============================================
  // Chat Routes
  // ============================================

  /// Chat rooms list
  static const String chat = '/chat';

  /// Chat room detail
  static String chatRoom(String id) => '/chat/$id';

  // ============================================
  // Manager Routes
  // ============================================

  /// Manager dashboard
  static const String managerDashboard = '/manager';

  /// Staff management
  static const String staffManagement = '/manager/staff';

  /// Reports
  static const String reports = '/manager/reports';

  // ============================================
  // Portal Routes
  // ============================================

  /// Portal home
  static const String portal = '/portal';

  /// Service requests
  static const String serviceRequests = '/portal/requests';

  // ============================================
  // Staff Routes
  // ============================================

  /// Staff dashboard
  static const String staffDashboard = '/staff';

  /// Staff task list
  static const String staffTaskList = '/staff/tasks';

  /// Staff task detail
  static String staffTaskDetail(int id) => '/staff/tasks/$id';

  /// Staff create task
  static const String staffTaskCreate = '/staff/tasks/create';

  /// Staff edit task
  static String staffTaskEdit(int id) => '/staff/tasks/$id/edit';

  /// Staff schedule
  static const String staffSchedule = '/staff/schedule';

  /// Staff profile
  static const String staffProfile = '/staff/profile';
}
