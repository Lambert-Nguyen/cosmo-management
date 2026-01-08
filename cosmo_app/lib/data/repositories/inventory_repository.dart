/// Inventory repository for Cosmo Management
///
/// Handles inventory data operations with caching support.
library;

import '../../core/config/api_config.dart';
import '../models/inventory_model.dart';
import 'base_repository.dart';

/// Repository for inventory operations
class InventoryRepository extends BaseRepository {
  InventoryRepository({
    required super.apiService,
    required super.storageService,
  });

  // Cache keys
  static const String _inventoryListCacheKey = 'inventory_list';
  static const String _lowStockCacheKey = 'inventory_low_stock';
  static const String _transactionsCacheKey = 'inventory_transactions';
  String _inventoryCacheKey(int id) => 'inventory_$id';

  // ============================================
  // Inventory Items
  // ============================================

  /// Get paginated inventory list with optional filters
  Future<PaginatedInventory> getInventory({
    int page = 1,
    int pageSize = 20,
    String? search,
    InventoryCategory? category,
    int? propertyId,
    bool? lowStockOnly,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
    };
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }
    if (category != null) {
      queryParams['category'] = category.value;
    }
    if (propertyId != null) {
      queryParams['property_id'] = propertyId;
    }
    if (lowStockOnly == true) {
      queryParams['low_stock'] = true;
    }

    final response = await apiService.get(
      ApiConfig.staffInventory,
      queryParameters: queryParams,
    );

    return PaginatedInventory.fromJson(response);
  }

  /// Get inventory item by ID
  Future<InventoryModel> getInventoryById(int id) async {
    return getCachedOrFetch<InventoryModel>(
      cacheKey: _inventoryCacheKey(id),
      fetchFunction: () async {
        final response = await apiService.get(ApiConfig.staffInventoryDetail(id));
        return InventoryModel.fromJson(response);
      },
      fromJson: (json) => InventoryModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Create new inventory item
  Future<InventoryModel> createInventory({
    required String name,
    String? description,
    InventoryCategory? category,
    int quantity = 0,
    String? unitType,
    int? parLevel,
    int? reorderPoint,
    int? propertyId,
    String? location,
    String? sku,
    double? unitCost,
  }) async {
    final data = <String, dynamic>{
      'name': name,
      'quantity': quantity,
    };
    if (description != null) data['description'] = description;
    if (category != null) data['category'] = category.value;
    if (unitType != null) data['unit_type'] = unitType;
    if (parLevel != null) data['par_level'] = parLevel;
    if (reorderPoint != null) data['reorder_point'] = reorderPoint;
    if (propertyId != null) data['property_id'] = propertyId;
    if (location != null) data['location'] = location;
    if (sku != null) data['sku'] = sku;
    if (unitCost != null) data['unit_cost'] = unitCost;

    final response = await apiService.post(
      ApiConfig.staffInventory,
      data: data,
    );

    return InventoryModel.fromJson(response);
  }

  /// Update inventory item
  Future<InventoryModel> updateInventory(
    int id, {
    String? name,
    String? description,
    InventoryCategory? category,
    String? unitType,
    int? parLevel,
    int? reorderPoint,
    int? propertyId,
    String? location,
    String? sku,
    double? unitCost,
    bool? isActive,
  }) async {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (description != null) data['description'] = description;
    if (category != null) data['category'] = category.value;
    if (unitType != null) data['unit_type'] = unitType;
    if (parLevel != null) data['par_level'] = parLevel;
    if (reorderPoint != null) data['reorder_point'] = reorderPoint;
    if (propertyId != null) data['property_id'] = propertyId;
    if (location != null) data['location'] = location;
    if (sku != null) data['sku'] = sku;
    if (unitCost != null) data['unit_cost'] = unitCost;
    if (isActive != null) data['is_active'] = isActive;

    final response = await apiService.patch(
      ApiConfig.staffInventoryDetail(id),
      data: data,
    );

    await invalidateCache(_inventoryCacheKey(id));
    return InventoryModel.fromJson(response);
  }

  /// Delete inventory item
  Future<void> deleteInventory(int id) async {
    await apiService.delete(ApiConfig.staffInventoryDetail(id));
    await invalidateCache(_inventoryCacheKey(id));
  }

  // ============================================
  // Inventory Transactions
  // ============================================

  /// Get inventory transactions
  Future<PaginatedInventoryTransactions> getTransactions({
    int page = 1,
    int pageSize = 20,
    int? inventoryId,
    int? propertyId,
    InventoryTransactionType? type,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
    };
    if (inventoryId != null) queryParams['inventory_id'] = inventoryId;
    if (propertyId != null) queryParams['property_id'] = propertyId;
    if (type != null) queryParams['type'] = type.value;
    if (fromDate != null) queryParams['from_date'] = fromDate.toIso8601String();
    if (toDate != null) queryParams['to_date'] = toDate.toIso8601String();

    final response = await apiService.get(
      ApiConfig.staffInventoryTransactions,
      queryParameters: queryParams,
    );

    return PaginatedInventoryTransactions.fromJson(response);
  }

  /// Log a new inventory transaction
  Future<InventoryTransactionModel> logTransaction({
    required int inventoryId,
    required InventoryTransactionType type,
    required int quantity,
    String? notes,
    int? propertyId,
    int? taskId,
  }) async {
    final data = <String, dynamic>{
      'inventory_id': inventoryId,
      'type': type.value,
      'quantity': quantity,
    };
    if (notes != null) data['notes'] = notes;
    if (propertyId != null) data['property_id'] = propertyId;
    if (taskId != null) data['task_id'] = taskId;

    final response = await apiService.post(
      ApiConfig.staffInventoryTransaction,
      data: data,
    );

    // Invalidate caches after transaction
    await invalidateCache(_inventoryCacheKey(inventoryId));
    await invalidateCache(_lowStockCacheKey);

    return InventoryTransactionModel.fromJson(response);
  }

  /// Report inventory shortage (creates restocking task)
  Future<void> reportShortage(
    int inventoryId, {
    String? notes,
    int? requestedQuantity,
  }) async {
    final data = <String, dynamic>{};
    if (notes != null) data['notes'] = notes;
    if (requestedQuantity != null) data['requested_quantity'] = requestedQuantity;

    await apiService.post(
      ApiConfig.staffInventoryShortage(inventoryId),
      data: data,
    );

    await invalidateCache(_inventoryCacheKey(inventoryId));
    await invalidateCache(_lowStockCacheKey);
  }

  // ============================================
  // Low Stock Alerts
  // ============================================

  /// Get low stock alerts
  Future<List<LowStockAlertModel>> getLowStockAlerts({
    int? propertyId,
    bool criticalOnly = false,
  }) async {
    final queryParams = <String, dynamic>{};
    if (propertyId != null) queryParams['property_id'] = propertyId;
    if (criticalOnly) queryParams['critical_only'] = true;

    final response = await apiService.get(
      ApiConfig.staffInventoryLowStock,
      queryParameters: queryParams,
    );

    final List<dynamic> results = response['results'] ?? response;
    return results
        .map((e) => LowStockAlertModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Get low stock count for dashboard
  Future<int> getLowStockCount() async {
    final alerts = await getLowStockAlerts();
    return alerts.length;
  }

  // ============================================
  // Categories
  // ============================================

  /// Get inventory categories (for filter dropdowns)
  Future<List<InventoryCategory>> getCategories() async {
    // Return all enum values since they're static
    return InventoryCategory.values;
  }

  // ============================================
  // Cache Management
  // ============================================

  /// Clear all inventory caches
  Future<void> clearAllCaches() async {
    await invalidateCache(_inventoryListCacheKey);
    await invalidateCache(_lowStockCacheKey);
    await invalidateCache(_transactionsCacheKey);
  }
}
