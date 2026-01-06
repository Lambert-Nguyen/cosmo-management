/// Tests for checklist models
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:cosmo_app/data/models/checklist_model.dart';

void main() {
  group('ChecklistItemType', () {
    test('should have correct values', () {
      expect(ChecklistItemType.check.value, 'check');
      expect(ChecklistItemType.photoRequired.value, 'photo_required');
      expect(ChecklistItemType.photoOptional.value, 'photo_optional');
      expect(ChecklistItemType.textInput.value, 'text_input');
      expect(ChecklistItemType.numberInput.value, 'number_input');
      expect(ChecklistItemType.blocking.value, 'blocking');
    });

    test('requiresPhoto should return correct value', () {
      expect(ChecklistItemType.photoRequired.requiresPhoto, true);
      expect(ChecklistItemType.photoOptional.requiresPhoto, false);
      expect(ChecklistItemType.check.requiresPhoto, false);
    });

    test('canHavePhoto should return correct value', () {
      expect(ChecklistItemType.photoRequired.canHavePhoto, true);
      expect(ChecklistItemType.photoOptional.canHavePhoto, true);
      expect(ChecklistItemType.check.canHavePhoto, false);
    });

    test('isCheckbox should return correct value', () {
      expect(ChecklistItemType.check.isCheckbox, true);
      expect(ChecklistItemType.blocking.isCheckbox, true);
      expect(ChecklistItemType.textInput.isCheckbox, false);
    });
  });

  group('ChecklistItemModel', () {
    test('should create from JSON', () {
      final json = {
        'id': 1,
        'title': 'Test Item',
        'description': 'Test description',
        'item_type': 'check',
        'order': 0,
        'is_required': true,
      };

      final item = ChecklistItemModel.fromJson(json);

      expect(item.id, 1);
      expect(item.title, 'Test Item');
      expect(item.description, 'Test description');
      expect(item.itemType, ChecklistItemType.check);
      expect(item.order, 0);
      expect(item.isRequired, true);
    });

    test('should serialize to JSON', () {
      const item = ChecklistItemModel(
        id: 1,
        title: 'Test Item',
        description: 'Test description',
        itemType: ChecklistItemType.check,
        order: 0,
        isRequired: true,
      );

      final json = item.toJson();

      expect(json['id'], 1);
      expect(json['title'], 'Test Item');
      expect(json['item_type'], 'check');
    });
  });

  group('ChecklistResponseModel', () {
    test('should create from JSON', () {
      final json = {
        'id': 1,
        'item': 10,
        'is_completed': true,
        'text_response': 'Test response',
        'completed_at': '2024-01-01T12:00:00Z',
      };

      final response = ChecklistResponseModel.fromJson(json);

      expect(response.id, 1);
      expect(response.itemId, 10);
      expect(response.isCompleted, true);
      expect(response.textResponse, 'Test response');
      expect(response.completedAt, isNotNull);
    });

    test('should handle null values', () {
      final json = {
        'id': 1,
        'item': 10,
        'is_completed': false,
      };

      final response = ChecklistResponseModel.fromJson(json);

      expect(response.textResponse, isNull);
      expect(response.numberResponse, isNull);
      expect(response.completedAt, isNull);
    });

    test('hasValue should return correct value', () {
      const completedResponse = ChecklistResponseModel(
        id: 1,
        itemId: 10,
        isCompleted: true,
      );

      const textResponse = ChecklistResponseModel(
        id: 2,
        itemId: 11,
        textResponse: 'text',
      );

      const emptyResponse = ChecklistResponseModel(
        id: 3,
        itemId: 12,
      );

      expect(completedResponse.hasValue, true);
      expect(textResponse.hasValue, true);
      expect(emptyResponse.hasValue, false);
    });
  });

  group('TaskChecklistModel', () {
    test('should calculate completedItems correctly', () {
      const checklist = TaskChecklistModel(
        id: 1,
        taskId: 10,
        items: [
          ChecklistItemModel(
            id: 1,
            title: 'Item 1',
            itemType: ChecklistItemType.check,
            order: 0,
          ),
          ChecklistItemModel(
            id: 2,
            title: 'Item 2',
            itemType: ChecklistItemType.check,
            order: 1,
          ),
        ],
        responses: [
          ChecklistResponseModel(
            id: 1,
            itemId: 1,
            isCompleted: true,
          ),
        ],
      );

      expect(checklist.completedItems, 1);
      expect(checklist.totalItems, 2);
      expect(checklist.isComplete, false);
    });

    test('isComplete should be true when all required items completed', () {
      const checklist = TaskChecklistModel(
        id: 1,
        taskId: 10,
        items: [
          ChecklistItemModel(
            id: 1,
            title: 'Item 1',
            itemType: ChecklistItemType.check,
            order: 0,
            isRequired: true,
          ),
        ],
        responses: [
          ChecklistResponseModel(
            id: 1,
            itemId: 1,
            isCompleted: true,
          ),
        ],
      );

      expect(checklist.completionPercentage, 100.0);
      expect(checklist.isComplete, true);
    });

    test('itemsByType should group items correctly', () {
      const checklist = TaskChecklistModel(
        id: 1,
        taskId: 10,
        items: [
          ChecklistItemModel(
            id: 1,
            title: 'Check 1',
            itemType: ChecklistItemType.check,
            order: 0,
          ),
          ChecklistItemModel(
            id: 2,
            title: 'Photo 1',
            itemType: ChecklistItemType.photoRequired,
            order: 1,
          ),
          ChecklistItemModel(
            id: 3,
            title: 'Check 2',
            itemType: ChecklistItemType.check,
            order: 2,
          ),
        ],
        responses: [],
      );

      final byType = checklist.itemsByType;

      expect(byType[ChecklistItemType.check]?.length, 2);
      expect(byType[ChecklistItemType.photoRequired]?.length, 1);
    });

    test('getResponseForItem should return correct response', () {
      const checklist = TaskChecklistModel(
        id: 1,
        taskId: 10,
        items: [
          ChecklistItemModel(
            id: 1,
            title: 'Item 1',
            itemType: ChecklistItemType.check,
            order: 0,
          ),
        ],
        responses: [
          ChecklistResponseModel(
            id: 1,
            itemId: 1,
            isCompleted: true,
          ),
        ],
      );

      final response = checklist.getResponseForItem(1);
      expect(response?.isCompleted, true);

      final noResponse = checklist.getResponseForItem(999);
      expect(noResponse, isNull);
    });
  });

  group('ChecklistProgressModel', () {
    test('should create with correct values', () {
      const progress = ChecklistProgressModel(
        completed: 3,
        total: 10,
        percentage: 30.0,
      );

      expect(progress.completed, 3);
      expect(progress.total, 10);
      expect(progress.percentage, 30.0);
    });

    test('isComplete should work correctly', () {
      const incompleteProgress = ChecklistProgressModel(
        completed: 3,
        total: 10,
      );
      expect(incompleteProgress.isComplete, false);

      const completeProgress = ChecklistProgressModel(
        completed: 5,
        total: 5,
      );
      expect(completeProgress.isComplete, true);
    });

    test('displayString should format correctly', () {
      const progress = ChecklistProgressModel(
        completed: 3,
        total: 5,
      );

      expect(progress.displayString, '3/5');
    });
  });
}
