/// Checklist models for Cosmo Management
///
/// Freezed models for task checklists with JSON serialization.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'checklist_model.freezed.dart';
part 'checklist_model.g.dart';

/// Checklist item type enum
///
/// Matches backend ChecklistItem.item_type choices.
@JsonEnum(valueField: 'value')
enum ChecklistItemType {
  @JsonValue('check')
  check('check', 'Checkbox'),
  @JsonValue('photo_required')
  photoRequired('photo_required', 'Photo Required'),
  @JsonValue('photo_optional')
  photoOptional('photo_optional', 'Photo Optional'),
  @JsonValue('text_input')
  textInput('text_input', 'Text Input'),
  @JsonValue('number_input')
  numberInput('number_input', 'Number Input'),
  @JsonValue('blocking')
  blocking('blocking', 'Blocking');

  final String value;
  final String displayName;

  const ChecklistItemType(this.value, this.displayName);

  /// Whether this type requires a photo
  bool get requiresPhoto => this == ChecklistItemType.photoRequired;

  /// Whether this type can have a photo
  bool get canHavePhoto =>
      this == ChecklistItemType.photoRequired ||
      this == ChecklistItemType.photoOptional;

  /// Whether this type requires text input
  bool get requiresTextInput => this == ChecklistItemType.textInput;

  /// Whether this type requires number input
  bool get requiresNumberInput => this == ChecklistItemType.numberInput;

  /// Whether this type is a simple checkbox
  bool get isCheckbox =>
      this == ChecklistItemType.check || this == ChecklistItemType.blocking;
}

/// Individual checklist item definition
///
/// Represents an item in a checklist template.
@freezed
class ChecklistItemModel with _$ChecklistItemModel {
  const factory ChecklistItemModel({
    required int id,
    required String title,
    String? description,
    @JsonKey(name: 'item_type') required ChecklistItemType itemType,
    @JsonKey(name: 'is_required') @Default(true) bool isRequired,
    @JsonKey(name: 'order') @Default(0) int order,
    @JsonKey(name: 'room_type') String? roomType,
  }) = _ChecklistItemModel;

  const ChecklistItemModel._();

  factory ChecklistItemModel.fromJson(Map<String, dynamic> json) =>
      _$ChecklistItemModelFromJson(json);
}

/// Response/completion for a checklist item
///
/// Tracks user completion and input for a specific checklist item.
@freezed
class ChecklistResponseModel with _$ChecklistResponseModel {
  const factory ChecklistResponseModel({
    required int id,
    @JsonKey(name: 'item') required int itemId,
    @JsonKey(name: 'is_completed') @Default(false) bool isCompleted,
    @JsonKey(name: 'text_response') String? textResponse,
    @JsonKey(name: 'number_response') double? numberResponse,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @JsonKey(name: 'completed_by') int? completedBy,
    String? notes,
  }) = _ChecklistResponseModel;

  const ChecklistResponseModel._();

  factory ChecklistResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ChecklistResponseModelFromJson(json);

  /// Check if response has any value
  bool get hasValue =>
      isCompleted || textResponse != null || numberResponse != null;
}

/// Photo attached to a checklist response
@freezed
class ChecklistPhotoModel with _$ChecklistPhotoModel {
  const factory ChecklistPhotoModel({
    required int id,
    @JsonKey(name: 'checklist_response') int? checklistResponseId,
    required String image,
    @JsonKey(name: 'photo_type') @Default('checklist') String photoType,
    @JsonKey(name: 'uploaded_at') DateTime? uploadedAt,
    @JsonKey(name: 'uploaded_by') int? uploadedBy,
  }) = _ChecklistPhotoModel;

  factory ChecklistPhotoModel.fromJson(Map<String, dynamic> json) =>
      _$ChecklistPhotoModelFromJson(json);
}

/// Task checklist with items and responses
///
/// Represents the full checklist for a task including all items and responses.
@freezed
class TaskChecklistModel with _$TaskChecklistModel {
  const factory TaskChecklistModel({
    required int id,
    @JsonKey(name: 'task') required int taskId,
    @JsonKey(name: 'template') int? templateId,
    @JsonKey(name: 'template_name') String? templateName,
    @Default([]) List<ChecklistItemModel> items,
    @Default([]) List<ChecklistResponseModel> responses,
    @Default([]) List<ChecklistPhotoModel> photos,
    @JsonKey(name: 'started_at') DateTime? startedAt,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @JsonKey(name: 'completed_by') int? completedBy,
  }) = _TaskChecklistModel;

  const TaskChecklistModel._();

  factory TaskChecklistModel.fromJson(Map<String, dynamic> json) =>
      _$TaskChecklistModelFromJson(json);

  /// Get response for a specific item
  ChecklistResponseModel? getResponseForItem(int itemId) {
    try {
      return responses.firstWhere((r) => r.itemId == itemId);
    } catch (_) {
      return null;
    }
  }

  /// Get photos for a specific response
  List<ChecklistPhotoModel> getPhotosForResponse(int responseId) {
    return photos.where((p) => p.checklistResponseId == responseId).toList();
  }

  /// Total number of items
  int get totalItems => items.length;

  /// Number of required items
  int get requiredItems => items.where((i) => i.isRequired).length;

  /// Number of completed items
  int get completedItems =>
      responses.where((r) => r.isCompleted).length;

  /// Number of completed required items
  int get completedRequiredItems {
    final requiredItemIds = items.where((i) => i.isRequired).map((i) => i.id);
    return responses
        .where((r) => r.isCompleted && requiredItemIds.contains(r.itemId))
        .length;
  }

  /// Completion percentage (0-100)
  double get completionPercentage {
    if (requiredItems == 0) return 100.0;
    return (completedRequiredItems / requiredItems) * 100;
  }

  /// Check if checklist is complete
  bool get isComplete => completedAt != null || completionPercentage >= 100;

  /// Check if there are any blocking items incomplete
  bool get hasIncompleteBlockingItems {
    final blockingItemIds = items
        .where((i) => i.itemType == ChecklistItemType.blocking)
        .map((i) => i.id);
    return blockingItemIds.any((id) {
      final response = getResponseForItem(id);
      return response == null || !response.isCompleted;
    });
  }

  /// Get items grouped by type for expandable sections
  Map<ChecklistItemType, List<ChecklistItemModel>> get itemsByType {
    final grouped = <ChecklistItemType, List<ChecklistItemModel>>{};
    for (final item in items) {
      grouped.putIfAbsent(item.itemType, () => []).add(item);
    }
    // Sort each group by order
    for (final list in grouped.values) {
      list.sort((a, b) => a.order.compareTo(b.order));
    }
    return grouped;
  }

  /// Get completion count for a specific type
  String getCompletionCountForType(ChecklistItemType type) {
    final typeItems = items.where((i) => i.itemType == type).toList();
    final typeItemIds = typeItems.map((i) => i.id).toSet();
    final completedCount = responses
        .where((r) => r.isCompleted && typeItemIds.contains(r.itemId))
        .length;
    return '$completedCount/${typeItems.length}';
  }
}

/// Checklist progress summary
///
/// Used for displaying progress in task lists without full checklist data.
@freezed
class ChecklistProgressModel with _$ChecklistProgressModel {
  const factory ChecklistProgressModel({
    @Default(0) int completed,
    @Default(0) int total,
    @Default(0.0) double percentage,
  }) = _ChecklistProgressModel;

  const ChecklistProgressModel._();

  factory ChecklistProgressModel.fromJson(Map<String, dynamic> json) =>
      _$ChecklistProgressModelFromJson(json);

  /// Display string for progress
  String get displayString => '$completed/$total';

  /// Check if complete
  bool get isComplete => total > 0 && completed >= total;
}
