/// Inventory model for Cosmo Management
///
/// Freezed model for inventory data with JSON serialization.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_model.freezed.dart';
part 'inventory_model.g.dart';

/// Inventory transaction types
@JsonEnum(valueField: 'value')
enum InventoryTransactionType {
  @JsonValue('stock_in')
  stockIn('stock_in', 'Stock In'),
  @JsonValue('stock_out')
  stockOut('stock_out', 'Stock Out'),
  @JsonValue('adjustment')
  adjustment('adjustment', 'Adjustment'),
  @JsonValue('damage')
  damage('damage', 'Damage'),
  @JsonValue('transfer')
  transfer('transfer', 'Transfer'),
  @JsonValue('shortage')
  shortage('shortage', 'Shortage');

  final String value;
  final String displayName;

  const InventoryTransactionType(this.value, this.displayName);

  /// Check if this transaction reduces inventory
  bool get reducesStock =>
      this == stockOut ||
      this == damage ||
      this == shortage ||
      this == transfer;

  /// Check if this transaction increases inventory
  bool get increasesStock => this == stockIn;
}

/// Inventory category for organizing items
@JsonEnum(valueField: 'value')
enum InventoryCategory {
  @JsonValue('cleaning_supplies')
  cleaningSupplies('cleaning_supplies', 'Cleaning Supplies'),
  @JsonValue('maintenance')
  maintenance('maintenance', 'Maintenance'),
  @JsonValue('linens')
  linens('linens', 'Linens'),
  @JsonValue('toiletries')
  toiletries('toiletries', 'Toiletries'),
  @JsonValue('kitchen')
  kitchen('kitchen', 'Kitchen'),
  @JsonValue('outdoor')
  outdoor('outdoor', 'Outdoor'),
  @JsonValue('electronics')
  electronics('electronics', 'Electronics'),
  @JsonValue('furniture')
  furniture('furniture', 'Furniture'),
  @JsonValue('other')
  other('other', 'Other');

  final String value;
  final String displayName;

  const InventoryCategory(this.value, this.displayName);
}

/// Inventory item model
///
/// Represents an inventory item in the system.
@freezed
class InventoryModel with _$InventoryModel {
  const factory InventoryModel({
    required int id,
    required String name,
    String? description,
    @Default(InventoryCategory.other) InventoryCategory category,
    @Default(0) int quantity,
    @JsonKey(name: 'unit_type') String? unitType,
    @JsonKey(name: 'par_level') int? parLevel,
    @JsonKey(name: 'reorder_point') int? reorderPoint,
    @JsonKey(name: 'property_id') int? propertyId,
    @JsonKey(name: 'property_name') String? propertyName,
    @JsonKey(name: 'location') String? location,
    @JsonKey(name: 'sku') String? sku,
    @JsonKey(name: 'barcode') String? barcode,
    @JsonKey(name: 'unit_cost') double? unitCost,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'last_counted_at') DateTime? lastCountedAt,
    @JsonKey(name: 'last_counted_by') int? lastCountedById,
    @JsonKey(name: 'last_counted_by_name') String? lastCountedByName,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @Default([]) List<String> images,
  }) = _InventoryModel;

  const InventoryModel._();

  factory InventoryModel.fromJson(Map<String, dynamic> json) =>
      _$InventoryModelFromJson(json);

  /// Check if item is at or below reorder point
  bool get isLowStock {
    if (reorderPoint == null) return quantity <= 5;
    return quantity <= reorderPoint!;
  }

  /// Check if item is critically low (below par level)
  bool get isCriticallyLow {
    if (parLevel == null) return quantity == 0;
    return quantity < parLevel!;
  }

  /// Check if item is out of stock
  bool get isOutOfStock => quantity <= 0;

  /// Get stock status for display
  String get stockStatus {
    if (isOutOfStock) return 'Out of Stock';
    if (isCriticallyLow) return 'Critical';
    if (isLowStock) return 'Low Stock';
    return 'In Stock';
  }

  /// Get quantity with unit
  String get quantityDisplay {
    final unit = unitType ?? 'units';
    return '$quantity $unit';
  }

  /// Calculate value of current stock
  double? get stockValue {
    if (unitCost == null) return null;
    return quantity * unitCost!;
  }
}

/// Inventory transaction model
///
/// Represents a single inventory transaction (stock in/out, adjustment, etc.)
@freezed
class InventoryTransactionModel with _$InventoryTransactionModel {
  const factory InventoryTransactionModel({
    required int id,
    @JsonKey(name: 'inventory_id') required int inventoryId,
    @JsonKey(name: 'inventory_name') String? inventoryName,
    required InventoryTransactionType type,
    required int quantity,
    @JsonKey(name: 'quantity_before') int? quantityBefore,
    @JsonKey(name: 'quantity_after') int? quantityAfter,
    String? notes,
    @JsonKey(name: 'property_id') int? propertyId,
    @JsonKey(name: 'property_name') String? propertyName,
    @JsonKey(name: 'task_id') int? taskId,
    @JsonKey(name: 'created_by') int? createdById,
    @JsonKey(name: 'created_by_name') String? createdByName,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _InventoryTransactionModel;

  const InventoryTransactionModel._();

  factory InventoryTransactionModel.fromJson(Map<String, dynamic> json) =>
      _$InventoryTransactionModelFromJson(json);

  /// Get signed quantity change for display
  String get quantityChangeDisplay {
    final sign = type.reducesStock ? '-' : '+';
    return '$sign$quantity';
  }

  /// Check if this was an increase
  bool get isIncrease => type.increasesStock;

  /// Check if this was a decrease
  bool get isDecrease => type.reducesStock;
}

/// Low stock alert model
///
/// Represents an inventory item that needs restocking.
@freezed
class LowStockAlertModel with _$LowStockAlertModel {
  const factory LowStockAlertModel({
    required int id,
    @JsonKey(name: 'inventory_id') required int inventoryId,
    @JsonKey(name: 'inventory_name') required String inventoryName,
    required InventoryCategory category,
    @JsonKey(name: 'current_quantity') required int currentQuantity,
    @JsonKey(name: 'par_level') int? parLevel,
    @JsonKey(name: 'reorder_point') int? reorderPoint,
    @JsonKey(name: 'property_id') int? propertyId,
    @JsonKey(name: 'property_name') String? propertyName,
    @JsonKey(name: 'shortage_amount') int? shortageAmount,
    @JsonKey(name: 'is_critical') @Default(false) bool isCritical,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _LowStockAlertModel;

  const LowStockAlertModel._();

  factory LowStockAlertModel.fromJson(Map<String, dynamic> json) =>
      _$LowStockAlertModelFromJson(json);

  /// Calculate how many units needed to reach par level
  int get unitsNeeded {
    if (parLevel == null) return 0;
    final needed = parLevel! - currentQuantity;
    return needed > 0 ? needed : 0;
  }

  /// Get urgency level for sorting/display
  int get urgencyLevel {
    if (currentQuantity == 0) return 3; // Out of stock - highest
    if (isCritical) return 2;
    return 1; // Low stock
  }
}

/// Paginated inventory response
class PaginatedInventory {
  final int count;
  final String? next;
  final String? previous;
  final List<InventoryModel> results;

  PaginatedInventory({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  bool get hasMore => next != null;

  factory PaginatedInventory.fromJson(Map<String, dynamic> json) {
    return PaginatedInventory(
      count: json['count'] as int? ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => InventoryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

/// Paginated inventory transactions response
class PaginatedInventoryTransactions {
  final int count;
  final String? next;
  final String? previous;
  final List<InventoryTransactionModel> results;

  PaginatedInventoryTransactions({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  bool get hasMore => next != null;

  factory PaginatedInventoryTransactions.fromJson(Map<String, dynamic> json) {
    return PaginatedInventoryTransactions(
      count: json['count'] as int? ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>?)
              ?.map((e) =>
                  InventoryTransactionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
