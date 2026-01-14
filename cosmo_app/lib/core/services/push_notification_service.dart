/// Push notification service for Cosmo Management
///
/// Handles Firebase Cloud Messaging (FCM) for push notifications.
library;

import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Notification channel configuration
class NotificationChannels {
  NotificationChannels._();

  static const taskAssignment = AndroidNotificationChannel(
    'task_assignment',
    'Task Assignments',
    description: 'Notifications for new task assignments',
    importance: Importance.high,
  );

  static const taskUpdates = AndroidNotificationChannel(
    'task_updates',
    'Task Updates',
    description: 'Notifications for task status changes',
    importance: Importance.defaultImportance,
  );

  static const lowStock = AndroidNotificationChannel(
    'low_stock',
    'Low Stock Alerts',
    description: 'Notifications for inventory low stock alerts',
    importance: Importance.high,
  );

  static const booking = AndroidNotificationChannel(
    'booking',
    'Booking Updates',
    description: 'Notifications for booking changes',
    importance: Importance.defaultImportance,
  );

  static const general = AndroidNotificationChannel(
    'general',
    'General',
    description: 'General notifications',
    importance: Importance.defaultImportance,
  );

  static List<AndroidNotificationChannel> get all => [
        taskAssignment,
        taskUpdates,
        lowStock,
        booking,
        general,
      ];
}

/// Callback type for handling notification taps
typedef NotificationTapCallback = void Function(Map<String, dynamic> data);

/// Service for handling push notifications
class PushNotificationService {
  PushNotificationService({
    FirebaseMessaging? messaging,
    FlutterLocalNotificationsPlugin? localNotifications,
  })  : _messaging = messaging ?? FirebaseMessaging.instance,
        _localNotifications =
            localNotifications ?? FlutterLocalNotificationsPlugin();

  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _localNotifications;

  final _messageController = StreamController<RemoteMessage>.broadcast();
  NotificationTapCallback? _onNotificationTap;

  /// Stream of incoming messages
  Stream<RemoteMessage> get messages => _messageController.stream;

  /// Initialize the notification service
  Future<void> initialize({
    NotificationTapCallback? onNotificationTap,
  }) async {
    _onNotificationTap = onNotificationTap;

    // Request permission
    await _requestPermission();

    // Initialize local notifications
    await _initializeLocalNotifications();

    // Create notification channels for Android
    await _createNotificationChannels();

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle notification taps when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Check for initial message (app launched from notification)
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }
  }

  /// Request notification permission
  Future<bool> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }

  /// Initialize local notifications plugin
  Future<void> _initializeLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null) {
          // Parse payload and trigger callback
          _onNotificationTap?.call({'payload': response.payload});
        }
      },
    );
  }

  /// Create notification channels for Android
  Future<void> _createNotificationChannels() async {
    if (Platform.isAndroid) {
      final androidPlugin =
          _localNotifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        for (final channel in NotificationChannels.all) {
          await androidPlugin.createNotificationChannel(channel);
        }
      }
    }
  }

  /// Handle foreground message
  void _handleForegroundMessage(RemoteMessage message) {
    _messageController.add(message);

    // Show local notification for foreground messages
    final notification = message.notification;
    if (notification != null) {
      _showLocalNotification(
        title: notification.title ?? 'Cosmo Management',
        body: notification.body ?? '',
        channelId: _getChannelId(message.data),
        payload: message.data.toString(),
      );
    }
  }

  /// Handle notification tap
  void _handleNotificationTap(RemoteMessage message) {
    _onNotificationTap?.call(message.data);
  }

  /// Get appropriate channel ID based on notification data
  String _getChannelId(Map<String, dynamic> data) {
    final type = data['type'] as String?;
    switch (type) {
      case 'task_assignment':
        return NotificationChannels.taskAssignment.id;
      case 'task_update':
        return NotificationChannels.taskUpdates.id;
      case 'low_stock':
        return NotificationChannels.lowStock.id;
      case 'booking':
        return NotificationChannels.booking.id;
      default:
        return NotificationChannels.general.id;
    }
  }

  /// Show a local notification
  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String channelId = 'general',
    String? payload,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelId,
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: payload,
    );
  }

  /// Get the FCM token for this device
  Future<String?> getToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error getting FCM token: $e');
      }
      return null;
    }
  }

  /// Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
  }

  /// Dispose the service
  void dispose() {
    _messageController.close();
  }
}

/// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background message
  // Note: This runs in a separate isolate, so we can't access app state
  if (kDebugMode) {
    debugPrint('Background message: ${message.messageId}');
  }
}
