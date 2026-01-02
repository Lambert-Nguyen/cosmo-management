import 'package:flutter_test/flutter_test.dart';
import 'package:cosmo_app/data/models/task_model.dart';

void main() {
  group('TaskModel', () {
    test('should create task with required fields', () {
      const task = TaskModel(
        id: 1,
        title: 'Test Task',
      );

      expect(task.id, 1);
      expect(task.title, 'Test Task');
      expect(task.status, TaskStatus.pending); // default
      expect(task.priority, TaskPriority.medium); // default
    });

    test('should create task with all fields', () {
      final task = TaskModel(
        id: 1,
        title: 'Test Task',
        description: 'Task description',
        taskType: 'maintenance',
        status: TaskStatus.inProgress,
        priority: TaskPriority.high,
        propertyId: 10,
        assignedToId: 5,
        dueDate: DateTime(2024, 12, 31),
      );

      expect(task.description, 'Task description');
      expect(task.taskType, 'maintenance');
      expect(task.status, TaskStatus.inProgress);
      expect(task.priority, TaskPriority.high);
      expect(task.propertyId, 10);
      expect(task.assignedToId, 5);
    });

    group('isOverdue', () {
      test('should return false when no due date', () {
        const task = TaskModel(id: 1, title: 'Test');
        expect(task.isOverdue, isFalse);
      });

      test('should return false when completed', () {
        final task = TaskModel(
          id: 1,
          title: 'Test',
          status: TaskStatus.completed,
          dueDate: DateTime.now().subtract(const Duration(days: 1)),
        );
        expect(task.isOverdue, isFalse);
      });

      test('should return false when cancelled', () {
        final task = TaskModel(
          id: 1,
          title: 'Test',
          status: TaskStatus.cancelled,
          dueDate: DateTime.now().subtract(const Duration(days: 1)),
        );
        expect(task.isOverdue, isFalse);
      });

      test('should return true when past due date and not completed', () {
        final task = TaskModel(
          id: 1,
          title: 'Test',
          status: TaskStatus.pending,
          dueDate: DateTime.now().subtract(const Duration(days: 1)),
        );
        expect(task.isOverdue, isTrue);
      });

      test('should return false when due date is in future', () {
        final task = TaskModel(
          id: 1,
          title: 'Test',
          status: TaskStatus.pending,
          dueDate: DateTime.now().add(const Duration(days: 1)),
        );
        expect(task.isOverdue, isFalse);
      });
    });

    group('status checks', () {
      test('isCompleted should return true for completed status', () {
        const task = TaskModel(
          id: 1,
          title: 'Test',
          status: TaskStatus.completed,
        );
        expect(task.isCompleted, isTrue);
      });

      test('isInProgress should return true for in_progress status', () {
        const task = TaskModel(
          id: 1,
          title: 'Test',
          status: TaskStatus.inProgress,
        );
        expect(task.isInProgress, isTrue);
      });

      test('isPending should return true for pending status', () {
        const task = TaskModel(
          id: 1,
          title: 'Test',
          status: TaskStatus.pending,
        );
        expect(task.isPending, isTrue);
      });
    });

    group('daysUntilDue', () {
      test('should return null when no due date', () {
        const task = TaskModel(id: 1, title: 'Test');
        expect(task.daysUntilDue, isNull);
      });

      test('should return positive days for future due date', () {
        final task = TaskModel(
          id: 1,
          title: 'Test',
          dueDate: DateTime.now().add(const Duration(days: 5)),
        );
        expect(task.daysUntilDue, greaterThanOrEqualTo(4));
      });

      test('should return negative days for past due date', () {
        final task = TaskModel(
          id: 1,
          title: 'Test',
          dueDate: DateTime.now().subtract(const Duration(days: 3)),
        );
        expect(task.daysUntilDue, lessThan(0));
      });
    });

    group('dueDateStatus', () {
      test('should return "No due date" when no due date', () {
        const task = TaskModel(id: 1, title: 'Test');
        expect(task.dueDateStatus, 'No due date');
      });

      test('should return "Due today" when due today', () {
        final task = TaskModel(
          id: 1,
          title: 'Test',
          dueDate: DateTime.now(),
        );
        expect(task.dueDateStatus, 'Due today');
      });
    });

    group('JSON serialization', () {
      test('should serialize to JSON', () {
        const task = TaskModel(
          id: 1,
          title: 'Test Task',
          status: TaskStatus.inProgress,
          priority: TaskPriority.high,
        );

        final json = task.toJson();

        expect(json['id'], 1);
        expect(json['title'], 'Test Task');
        expect(json['status'], 'in_progress');
        expect(json['priority'], 'high');
      });

      test('should deserialize from JSON', () {
        final json = {
          'id': 1,
          'title': 'Test Task',
          'status': 'completed',
          'priority': 'urgent',
          'property_id': 10,
        };

        final task = TaskModel.fromJson(json);

        expect(task.id, 1);
        expect(task.title, 'Test Task');
        expect(task.status, TaskStatus.completed);
        expect(task.priority, TaskPriority.urgent);
        expect(task.propertyId, 10);
      });
    });
  });

  group('TaskStatus', () {
    test('should have correct values', () {
      expect(TaskStatus.pending.value, 'pending');
      expect(TaskStatus.inProgress.value, 'in_progress');
      expect(TaskStatus.completed.value, 'completed');
      expect(TaskStatus.cancelled.value, 'cancelled');
      expect(TaskStatus.onHold.value, 'on_hold');
    });

    test('should have display names', () {
      expect(TaskStatus.pending.displayName, 'Pending');
      expect(TaskStatus.inProgress.displayName, 'In Progress');
      expect(TaskStatus.completed.displayName, 'Completed');
    });
  });

  group('TaskPriority', () {
    test('should have correct values', () {
      expect(TaskPriority.low.value, 'low');
      expect(TaskPriority.medium.value, 'medium');
      expect(TaskPriority.high.value, 'high');
      expect(TaskPriority.urgent.value, 'urgent');
    });

    test('should have display names', () {
      expect(TaskPriority.low.displayName, 'Low');
      expect(TaskPriority.urgent.displayName, 'Urgent');
    });
  });
}
