/// Inventory alerts notifier for Cosmo Management
///
/// Manages low stock alerts state with filtering and refresh capabilities.
library;

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/connectivity_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../data/models/inventory_model.dart';
import '../../../data/repositories/inventory_repository.dart';

// ============================================
// State Classes
// ============================================

/// Sealed state class for inventory alerts
sealed class InventoryAlertsState {
  const InventoryAlertsState();
}

/// Initial state
class InventoryAlertsInitial extends InventoryAlertsState {
  const InventoryAlertsInitial();
}

/// Loading state
class InventoryAlertsLoading extends InventoryAlertsState {
  final List<LowStockAlertModel> existingAlerts;

  const InventoryAlertsLoading({
    this.existingAlerts = const [],
  });
}

/// Loaded state
class InventoryAlertsLoaded extends InventoryAlertsState {
  final List<LowStockAlertModel> alerts;
  final int? propertyId;
  final bool criticalOnly;
  final bool isOffline;

  const InventoryAlertsLoaded({
    required this.alerts,
    this.propertyId,
    this.criticalOnly = false,
    this.isOffline = false,
  });

  InventoryAlertsLoaded copyWith({
    List<LowStockAlertModel>? alerts,
    int? propertyId,
    bool? criticalOnly,
    bool? isOffline,
  }) {
    return InventoryAlertsLoaded(
      alerts: alerts ?? this.alerts,
      propertyId: propertyId ?? this.propertyId,
      criticalOnly: criticalOnly ?? this.criticalOnly,
      isOffline: isOffline ?? this.isOffline,
    );
  }
}

/// Error state
class InventoryAlertsError extends InventoryAlertsState {
  final String message;
  final List<LowStockAlertModel> cachedAlerts;

  const InventoryAlertsError(this.message, [this.cachedAlerts = const []]);
}

// ============================================
// Notifier
// ============================================

/// Inventory alerts state notifier
class InventoryAlertsNotifier extends StateNotifier<InventoryAlertsState> {
  final InventoryRepository _inventoryRepository;
  final ConnectivityService _connectivityService;
  final StorageService _storageService;

  int? _currentPropertyId;
  bool _criticalOnly = false;

  StreamSubscription? _connectivitySubscription;

  InventoryAlertsNotifier({
    required InventoryRepository inventoryRepository,
    required ConnectivityService connectivityService,
    required StorageService storageService,
  })  : _inventoryRepository = inventoryRepository,
        _connectivityService = connectivityService,
        _storageService = storageService,
        super(const InventoryAlertsInitial()) {
    _init();
  }

  void _init() {
    // Auto-refresh when connectivity changes
    _connectivitySubscription = _connectivityService.statusStream.listen(
      (status) {
        if (status != ConnectivityStatus.offline) {
          loadAlerts(refresh: true);
        } else {
          final current = state;
          if (current is InventoryAlertsLoaded) {
            state = current.copyWith(isOffline: true);
          }
        }
      },
    );
  }

  /// Load low stock alerts
  Future<void> loadAlerts({bool refresh = false}) async {
    final currentAlerts = switch (state) {
      InventoryAlertsLoaded(alerts: final a) => a,
      InventoryAlertsLoading(existingAlerts: final a) => a,
      _ => <LowStockAlertModel>[],
    };

    state = InventoryAlertsLoading(
      existingAlerts: refresh ? [] : currentAlerts,
    );

    try {
      final isOnline = _connectivityService.isConnected;

      if (isOnline) {
        final alerts = await _inventoryRepository.getLowStockAlerts(
          propertyId: _currentPropertyId,
          criticalOnly: _criticalOnly,
        );

        // Sort alerts by urgency (highest first)
        alerts.sort((a, b) => b.urgencyLevel.compareTo(a.urgencyLevel));

        await _cacheAlerts(alerts);

        state = InventoryAlertsLoaded(
          alerts: alerts,
          propertyId: _currentPropertyId,
          criticalOnly: _criticalOnly,
          isOffline: false,
        );
      } else {
        await _loadFromCache();
      }
    } catch (e) {
      final cached = await _loadFromCache();
      if (!cached) {
        state = InventoryAlertsError(e.toString(), currentAlerts);
      }
    }
  }

  /// Set property filter
  Future<void> setPropertyFilter(int? propertyId) async {
    _currentPropertyId = propertyId;
    await loadAlerts(refresh: true);
  }

  /// Toggle critical only filter
  Future<void> toggleCriticalOnly() async {
    _criticalOnly = !_criticalOnly;
    await loadAlerts(refresh: true);
  }

  /// Clear all filters
  Future<void> clearFilters() async {
    _currentPropertyId = null;
    _criticalOnly = false;
    await loadAlerts(refresh: true);
  }

  /// Dismiss alert locally (after restocking)
  void dismissAlert(int inventoryId) {
    final current = state;
    if (current is! InventoryAlertsLoaded) return;

    final updatedAlerts = current.alerts
        .where((alert) => alert.inventoryId != inventoryId)
        .toList();

    state = current.copyWith(alerts: updatedAlerts);
  }

  /// Cache alerts
  Future<void> _cacheAlerts(List<LowStockAlertModel> alerts) async {
    const cacheKey = 'inventory_alerts';
    await _storageService.cacheData(
      cacheKey,
      alerts.map((a) => a.toJson()).toList(),
    );
  }

  /// Load from cache
  Future<bool> _loadFromCache() async {
    try {
      const cacheKey = 'inventory_alerts';
      final cached = await _storageService.getCachedData(cacheKey);
      if (cached != null && cached is List) {
        final alerts = cached
            .map((e) => LowStockAlertModel.fromJson(e as Map<String, dynamic>))
            .toList();
        state = InventoryAlertsLoaded(
          alerts: alerts,
          propertyId: _currentPropertyId,
          criticalOnly: _criticalOnly,
          isOffline: true,
        );
        return true;
      }
    } catch (_) {}
    return false;
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}
