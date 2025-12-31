import 'package:flutter_test/flutter_test.dart';
import 'package:cosmo_app/data/models/notification_model.dart';

void main() {
  group('NotificationModel', () {
    test('should create notification with required fields', () {
      const notification = NotificationModel(
        id: 1,
        title: 'Test Notification',
      );

      expect(notification.id, 1);
      expect(notification.title, 'Test Notification');
      expect(notification.isRead, isFalse); // default
    });

    test('should create notification with all fields', () {
      final notification = NotificationModel(
        id: 1,
        title: 'Task Assigned',
        message: 'You have been assigned a new task',
        notificationType: 'task',
        isRead: true,
        createdAt: DateTime(2024, 12, 25, 10, 30),
        readAt: DateTime(2024, 12, 25, 11, 0),
        actionUrl: '/tasks/123',
        relatedObjectType: 'task',
        relatedObjectId: 123,
      );

      expect(notification.message, 'You have been assigned a new task');
      expect(notification.notificationType, 'task');
      expect(notification.isRead, isTrue);
      expect(notification.actionUrl, '/tasks/123');
      expect(notification.relatedObjectId, 123);
    });

    group('timeAgo', () {
      test('should return empty string when no createdAt', () {
        const notification = NotificationModel(
          id: 1,
          title: 'Test',
        );

        expect(notification.timeAgo, '');
      });

      test('should return "Just now" for recent notifications', () {
        final notification = NotificationModel(
          id: 1,
          title: 'Test',
          createdAt: DateTime.now().subtract(const Duration(seconds: 30)),
        );

        expect(notification.timeAgo, 'Just now');
      });

      test('should return minutes ago', () {
        final notification = NotificationModel(
          id: 1,
          title: 'Test',
          createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
        );

        expect(notification.timeAgo, '15m ago');
      });

      test('should return hours ago', () {
        final notification = NotificationModel(
          id: 1,
          title: 'Test',
          createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        );

        expect(notification.timeAgo, '3h ago');
      });

      test('should return days ago for less than a week', () {
        final notification = NotificationModel(
          id: 1,
          title: 'Test',
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        );

        expect(notification.timeAgo, '5d ago');
      });

      test('should return date for more than a week', () {
        final notification = NotificationModel(
          id: 1,
          title: 'Test',
          createdAt: DateTime(2024, 1, 15),
        );

        expect(notification.timeAgo, '15/1/2024');
      });
    });

    group('JSON serialization', () {
      test('should serialize to JSON', () {
        const notification = NotificationModel(
          id: 1,
          title: 'Test Notification',
          message: 'Test message',
          isRead: true,
        );

        final json = notification.toJson();

        expect(json['id'], 1);
        expect(json['title'], 'Test Notification');
        expect(json['message'], 'Test message');
        expect(json['is_read'], true);
      });

      test('should deserialize from JSON', () {
        final json = {
          'id': 1,
          'title': 'Task Completed',
          'message': 'Your task has been completed',
          'notification_type': 'task',
          'is_read': false,
          'action_url': '/tasks/456',
          'related_object_type': 'task',
          'related_object_id': 456,
        };

        final notification = NotificationModel.fromJson(json);

        expect(notification.id, 1);
        expect(notification.title, 'Task Completed');
        expect(notification.message, 'Your task has been completed');
        expect(notification.notificationType, 'task');
        expect(notification.isRead, isFalse);
        expect(notification.relatedObjectId, 456);
      });

      test('should handle null values in JSON', () {
        final json = {
          'id': 1,
          'title': 'Simple Notification',
        };

        final notification = NotificationModel.fromJson(json);

        expect(notification.id, 1);
        expect(notification.title, 'Simple Notification');
        expect(notification.message, isNull);
        expect(notification.notificationType, isNull);
        expect(notification.isRead, isFalse);
      });
    });

    group('copyWith', () {
      test('should create copy with updated fields', () {
        const original = NotificationModel(
          id: 1,
          title: 'Original',
          isRead: false,
        );

        final updated = original.copyWith(isRead: true);

        expect(original.isRead, isFalse);
        expect(updated.isRead, isTrue);
        expect(updated.id, original.id);
        expect(updated.title, original.title);
      });
    });

    group('equality', () {
      test('should be equal when all fields match', () {
        const notification1 = NotificationModel(id: 1, title: 'Test');
        const notification2 = NotificationModel(id: 1, title: 'Test');

        expect(notification1, equals(notification2));
      });

      test('should not be equal when fields differ', () {
        const notification1 = NotificationModel(id: 1, title: 'Test');
        const notification2 = NotificationModel(id: 2, title: 'Test');

        expect(notification1, isNot(equals(notification2)));
      });
    });
  });
}
