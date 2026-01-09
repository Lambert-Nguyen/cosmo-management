/// Inventory providers for Cosmo Management
///
/// Riverpod providers for inventory module state management.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/service_providers.dart';
import '../../../data/models/inventory_model.dart';
import '../../../data/repositories/inventory_repository.dart';
import 'inventory_list_notifier.dart';

export 'inventory_list_notifier.dart';

// ============================================
// Repository Provider
// ============================================

/// Inventory repository provider
final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  return InventoryRepository(
    apiService: ref.watch(apiServiceProvider),
    storageService: ref.watch(storageServiceProvider),
  );
});

// ============================================
// Inventory List Providers
// ============================================

/// Inventory list notifier provider
final inventoryListProvider =
    StateNotifierProvider<InventoryListNotifier, InventoryListState>((ref) {
  return InventoryListNotifier(
    inventoryRepository: ref.watch(inventoryRepositoryProvider),
    connectivityService: ref.watch(connectivityServiceProvider),
    storageService: ref.watch(storageServiceProvider),
  );
});

/// Current inventory filter provider (convenience)
final inventoryFilterProvider = Provider<InventoryFilter>((ref) {
  final notifier = ref.watch(inventoryListProvider.notifier);
  return notifier.currentFilter;
});

// ============================================
// Low Stock Providers
// ============================================

/// Low stock alerts provider
final lowStockAlertsProvider =
    FutureProvider<List<LowStockAlertModel>>((ref) async {
  final repository = ref.watch(inventoryRepositoryProvider);
  return repository.getLowStockAlerts();
});

/// Low stock count provider (for badges)
final lowStockCountProvider = Provider<int>((ref) {
  final alertsAsync = ref.watch(lowStockAlertsProvider);
  return alertsAsync.maybeWhen(
    data: (alerts) => alerts.length,
    orElse: () => 0,
  );
});

/// Critical low stock count
final criticalLowStockCountProvider = Provider<int>((ref) {
  final alertsAsync = ref.watch(lowStockAlertsProvider);
  return alertsAsync.maybeWhen(
    data: (alerts) => alerts.where((a) => a.isCritical).length,
    orElse: () => 0,
  );
});

// ============================================
// Transaction Providers
// ============================================

/// Recent transactions provider
final recentTransactionsProvider =
    FutureProvider<List<InventoryTransactionModel>>((ref) async {
  final repository = ref.watch(inventoryRepositoryProvider);
  final response = await repository.getTransactions(pageSize: 10);
  return response.results;
});

// ============================================
// Category Providers
// ============================================

/// Inventory categories provider
final inventoryCategoriesProvider =
    Provider<List<InventoryCategory>>((ref) {
  return InventoryCategory.values;
});

// ============================================
// Detail Provider
// ============================================

/// Inventory detail provider (family by ID)
final inventoryDetailProvider =
    FutureProvider.family<InventoryModel, int>((ref, id) async {
  final repository = ref.watch(inventoryRepositoryProvider);
  return repository.getInventoryById(id);
});
