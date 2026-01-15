/// Analytics service for Cosmo Management
///
/// Tracks user actions and app events using Firebase Analytics.
library;

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Analytics event names
class AnalyticsEvents {
  AnalyticsEvents._();

  // Authentication
  static const login = 'login';
  static const logout = 'logout';
  static const loginFailed = 'login_failed';

  // Navigation
  static const screenView = 'screen_view';

  // Tasks
  static const taskViewed = 'task_viewed';
  static const taskStarted = 'task_started';
  static const taskCompleted = 'task_completed';
  static const taskPhotosUploaded = 'task_photos_uploaded';

  // Inventory
  static const inventoryViewed = 'inventory_viewed';
  static const inventoryTransaction = 'inventory_transaction';
  static const lowStockAlert = 'low_stock_alert';

  // Portal
  static const bookingViewed = 'booking_viewed';
  static const calendarViewed = 'calendar_viewed';

  // Photos
  static const photoUploaded = 'photo_uploaded';
  static const photoCompressed = 'photo_compressed';
}

/// Analytics parameter keys
class AnalyticsParams {
  AnalyticsParams._();

  static const userId = 'user_id';
  static const userRole = 'user_role';
  static const screenName = 'screen_name';
  static const taskId = 'task_id';
  static const taskType = 'task_type';
  static const propertyId = 'property_id';
  static const itemId = 'item_id';
  static const transactionType = 'transaction_type';
  static const photoCount = 'photo_count';
  static const compressionSavings = 'compression_savings_percent';
  static const errorMessage = 'error_message';
}

/// Service for tracking analytics events
class AnalyticsService {
  AnalyticsService({
    FirebaseAnalytics? analytics,
  }) : _analytics = analytics ?? FirebaseAnalytics.instance;

  final FirebaseAnalytics _analytics;

  /// Get the analytics observer for navigation tracking
  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  /// Set user ID for tracking
  Future<void> setUserId(String? userId) async {
    await _analytics.setUserId(id: userId);
  }

  /// Set user properties
  Future<void> setUserProperties({
    String? role,
    String? propertyAccess,
  }) async {
    if (role != null) {
      await _analytics.setUserProperty(name: 'user_role', value: role);
    }
    if (propertyAccess != null) {
      await _analytics.setUserProperty(
        name: 'property_access',
        value: propertyAccess,
      );
    }
  }

  /// Log screen view
  Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
  }

  /// Log login event
  Future<void> logLogin({String? method}) async {
    await _analytics.logLogin(loginMethod: method ?? 'email');
  }

  /// Log logout event
  Future<void> logLogout() async {
    await _logEvent(AnalyticsEvents.logout);
  }

  /// Log login failure
  Future<void> logLoginFailed(String error) async {
    await _logEvent(
      AnalyticsEvents.loginFailed,
      parameters: {AnalyticsParams.errorMessage: error},
    );
  }

  /// Log task events
  Future<void> logTaskViewed(int taskId, String taskType) async {
    await _logEvent(
      AnalyticsEvents.taskViewed,
      parameters: {
        AnalyticsParams.taskId: taskId,
        AnalyticsParams.taskType: taskType,
      },
    );
  }

  Future<void> logTaskStarted(int taskId) async {
    await _logEvent(
      AnalyticsEvents.taskStarted,
      parameters: {AnalyticsParams.taskId: taskId},
    );
  }

  Future<void> logTaskCompleted(int taskId) async {
    await _logEvent(
      AnalyticsEvents.taskCompleted,
      parameters: {AnalyticsParams.taskId: taskId},
    );
  }

  /// Log photo upload
  Future<void> logPhotoUploaded({
    int? taskId,
    int photoCount = 1,
  }) async {
    await _logEvent(
      AnalyticsEvents.photoUploaded,
      parameters: {
        if (taskId != null) AnalyticsParams.taskId: taskId,
        AnalyticsParams.photoCount: photoCount,
      },
    );
  }

  /// Log photo compression
  Future<void> logPhotoCompressed(double savingsPercent) async {
    await _logEvent(
      AnalyticsEvents.photoCompressed,
      parameters: {
        AnalyticsParams.compressionSavings: savingsPercent.round(),
      },
    );
  }

  /// Log inventory transaction
  Future<void> logInventoryTransaction({
    required int itemId,
    required String transactionType,
  }) async {
    await _logEvent(
      AnalyticsEvents.inventoryTransaction,
      parameters: {
        AnalyticsParams.itemId: itemId,
        AnalyticsParams.transactionType: transactionType,
      },
    );
  }

  /// Log low stock alert viewed
  Future<void> logLowStockAlert(int alertCount) async {
    await _logEvent(
      AnalyticsEvents.lowStockAlert,
      parameters: {'alert_count': alertCount},
    );
  }

  /// Log generic event
  Future<void> _logEvent(
    String name, {
    Map<String, Object>? parameters,
  }) async {
    try {
      await _analytics.logEvent(
        name: name,
        parameters: parameters,
      );
    } catch (e) {
      // Log errors in debug mode only
      if (kDebugMode) {
        debugPrint('Analytics error: $e');
      }
    }
  }
}
