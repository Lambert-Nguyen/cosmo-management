/// Inventory list notifier for Cosmo Management
///
/// Manages inventory list state with filtering, pagination, and offline support.
library;

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/services/connectivity_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../data/models/inventory_model.dart';
import '../../../data/repositories/inventory_repository.dart';

part 'inventory_list_notifier.freezed.dart';
part 'inventory_list_notifier.g.dart';

// ============================================
// Filter Model
// ============================================

@freezed
class InventoryFilter with _$InventoryFilter {
  const factory InventoryFilter({
    InventoryCategory? category,
    int? propertyId,
    String? propertyName,
    String? search,
    @Default(false) bool lowStockOnly,
    @Default('name') String sortBy,
    @Default(true) bool ascending,
  }) = _InventoryFilter;

  factory InventoryFilter.fromJson(Map<String, dynamic> json) =>
      _$InventoryFilterFromJson(json);
}

// ============================================
// State Classes
// ============================================

/// Sealed state class for inventory list
sealed class InventoryListState {
  const InventoryListState();
}

/// Initial state
class InventoryListInitial extends InventoryListState {
  const InventoryListInitial();
}

/// Loading state
class InventoryListLoading extends InventoryListState {
  final List<InventoryModel> existingItems;
  final bool isLoadingMore;

  const InventoryListLoading({
    this.existingItems = const [],
    this.isLoadingMore = false,
  });
}

/// Loaded state
class InventoryListLoaded extends InventoryListState {
  final List<InventoryModel> items;
  final bool hasMore;
  final int totalCount;
  final InventoryFilter filter;
  final bool isOffline;

  const InventoryListLoaded({
    required this.items,
    required this.hasMore,
    required this.totalCount,
    required this.filter,
    this.isOffline = false,
  });

  InventoryListLoaded copyWith({
    List<InventoryModel>? items,
    bool? hasMore,
    int? totalCount,
    InventoryFilter? filter,
    bool? isOffline,
  }) {
    return InventoryListLoaded(
      items: items ?? this.items,
      hasMore: hasMore ?? this.hasMore,
      totalCount: totalCount ?? this.totalCount,
      filter: filter ?? this.filter,
      isOffline: isOffline ?? this.isOffline,
    );
  }
}

/// Error state
class InventoryListError extends InventoryListState {
  final String message;
  final List<InventoryModel> cachedItems;

  const InventoryListError(this.message, [this.cachedItems = const []]);
}

// ============================================
// Notifier
// ============================================

/// Inventory list state notifier
class InventoryListNotifier extends StateNotifier<InventoryListState> {
  final InventoryRepository _inventoryRepository;
  final ConnectivityService _connectivityService;
  final StorageService _storageService;

  int _currentPage = 1;
  static const int _pageSize = 20;
  InventoryFilter _currentFilter = const InventoryFilter();

  StreamSubscription? _connectivitySubscription;

  InventoryListNotifier({
    required InventoryRepository inventoryRepository,
    required ConnectivityService connectivityService,
    required StorageService storageService,
  })  : _inventoryRepository = inventoryRepository,
        _connectivityService = connectivityService,
        _storageService = storageService,
        super(const InventoryListInitial()) {
    _init();
  }

  void _init() {
    // Auto-refresh when connectivity changes
    _connectivitySubscription = _connectivityService.statusStream.listen(
      (status) {
        if (status != ConnectivityStatus.offline) {
          loadInventory(refresh: true);
        } else {
          final current = state;
          if (current is InventoryListLoaded) {
            state = current.copyWith(isOffline: true);
          }
        }
      },
    );
  }

  /// Get current filter
  InventoryFilter get currentFilter => _currentFilter;

  /// Load inventory items
  Future<void> loadInventory({bool refresh = false}) async {
    if (refresh) _currentPage = 1;

    final currentItems = switch (state) {
      InventoryListLoaded(items: final i) => i,
      InventoryListLoading(existingItems: final i) => i,
      _ => <InventoryModel>[],
    };

    state = InventoryListLoading(
      existingItems: refresh ? [] : currentItems,
      isLoadingMore: !refresh && currentItems.isNotEmpty,
    );

    try {
      final isOnline = _connectivityService.isConnected;

      if (isOnline) {
        final result = await _inventoryRepository.getInventory(
          page: _currentPage,
          pageSize: _pageSize,
          category: _currentFilter.category,
          propertyId: _currentFilter.propertyId,
          search: _currentFilter.search,
          lowStockOnly: _currentFilter.lowStockOnly,
        );

        final items = refresh
            ? result.results
            : [...currentItems, ...result.results];

        await _cacheInventoryList(items);

        state = InventoryListLoaded(
          items: items,
          hasMore: result.hasMore,
          totalCount: result.count,
          filter: _currentFilter,
          isOffline: false,
        );
      } else {
        await _loadFromCache();
      }
    } catch (e) {
      final cached = await _loadFromCache();
      if (!cached) {
        state = InventoryListError(e.toString(), currentItems);
      }
    }
  }

  /// Load more items (pagination)
  Future<void> loadMore() async {
    if (state is! InventoryListLoaded) return;
    final currentState = state as InventoryListLoaded;
    if (!currentState.hasMore) return;

    _currentPage++;
    try {
      await loadInventory();
    } catch (e) {
      _currentPage--;
      rethrow;
    }
  }

  /// Update filter and reload
  Future<void> updateFilter(InventoryFilter filter) async {
    _currentFilter = filter;
    await loadInventory(refresh: true);
  }

  /// Set category filter
  Future<void> setCategoryFilter(InventoryCategory? category) async {
    await updateFilter(_currentFilter.copyWith(category: category));
  }

  /// Set property filter
  Future<void> setPropertyFilter(int? propertyId, String? propertyName) async {
    await updateFilter(_currentFilter.copyWith(
      propertyId: propertyId,
      propertyName: propertyName,
    ));
  }

  /// Set search query
  Future<void> setSearch(String? search) async {
    await updateFilter(_currentFilter.copyWith(search: search));
  }

  /// Toggle low stock filter
  Future<void> toggleLowStockOnly() async {
    await updateFilter(
      _currentFilter.copyWith(lowStockOnly: !_currentFilter.lowStockOnly),
    );
  }

  /// Clear all filters
  Future<void> clearFilters() async {
    await updateFilter(const InventoryFilter());
  }

  /// Update item locally (optimistic update)
  void updateItemLocally(InventoryModel updatedItem) {
    final current = state;
    if (current is! InventoryListLoaded) return;

    final updatedItems = current.items.map((item) {
      return item.id == updatedItem.id ? updatedItem : item;
    }).toList();

    state = current.copyWith(items: updatedItems);
  }

  /// Remove item locally
  void removeItemLocally(int itemId) {
    final current = state;
    if (current is! InventoryListLoaded) return;

    final updatedItems = current.items.where((i) => i.id != itemId).toList();
    state = current.copyWith(
      items: updatedItems,
      totalCount: current.totalCount - 1,
    );
  }

  /// Cache inventory list
  Future<void> _cacheInventoryList(List<InventoryModel> items) async {
    final cacheKey = _getCacheKey();
    await _storageService.cacheData(
      cacheKey,
      items.map((i) => i.toJson()).toList(),
    );
  }

  /// Load from cache
  Future<bool> _loadFromCache() async {
    try {
      final cacheKey = _getCacheKey();
      final cached = await _storageService.getCachedData(cacheKey);
      if (cached != null && cached is List) {
        final items = cached
            .map((e) => InventoryModel.fromJson(e as Map<String, dynamic>))
            .toList();
        state = InventoryListLoaded(
          items: items,
          hasMore: false,
          totalCount: items.length,
          filter: _currentFilter,
          isOffline: true,
        );
        return true;
      }
    } catch (_) {}
    return false;
  }

  /// Generate cache key based on filter
  String _getCacheKey() {
    final category = _currentFilter.category?.value ?? 'all';
    final property = _currentFilter.propertyId?.toString() ?? 'all';
    return 'inventory_list_${category}_$property';
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}
