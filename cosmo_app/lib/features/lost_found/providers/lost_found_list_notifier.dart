/// Lost & Found list notifier for Cosmo Management
///
/// StateNotifier for managing lost & found list state with pagination and filtering.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/models/lost_found_model.dart';
import '../../../data/repositories/lost_found_repository.dart';

part 'lost_found_list_notifier.freezed.dart';

/// Lost & Found filter model
@freezed
class LostFoundFilter with _$LostFoundFilter {
  const factory LostFoundFilter({
    String? search,
    LostFoundStatus? status,
    LostFoundCategory? category,
    int? propertyId,
    String? propertyName,
    @Default(false) bool needsAttentionOnly,
  }) = _LostFoundFilter;

  const LostFoundFilter._();

  /// Check if any filter is active
  bool get hasActiveFilters =>
      search != null ||
      status != null ||
      category != null ||
      propertyId != null ||
      needsAttentionOnly;

  /// Get active filter count
  int get activeFilterCount {
    int count = 0;
    if (status != null) count++;
    if (category != null) count++;
    if (propertyId != null) count++;
    if (needsAttentionOnly) count++;
    return count;
  }
}

/// Lost & Found list state
sealed class LostFoundListState {
  const LostFoundListState();
}

/// Initial state
class LostFoundListInitial extends LostFoundListState {
  const LostFoundListInitial();
}

/// Loading state
class LostFoundListLoading extends LostFoundListState {
  final List<LostFoundModel> existingItems;
  final bool isLoadingMore;

  const LostFoundListLoading({
    this.existingItems = const [],
    this.isLoadingMore = false,
  });
}

/// Loaded state
class LostFoundListLoaded extends LostFoundListState {
  final List<LostFoundModel> items;
  final LostFoundFilter filter;
  final int currentPage;
  final bool hasMore;
  final bool isOffline;

  const LostFoundListLoaded({
    required this.items,
    this.filter = const LostFoundFilter(),
    this.currentPage = 1,
    this.hasMore = false,
    this.isOffline = false,
  });

  LostFoundListLoaded copyWith({
    List<LostFoundModel>? items,
    LostFoundFilter? filter,
    int? currentPage,
    bool? hasMore,
    bool? isOffline,
  }) {
    return LostFoundListLoaded(
      items: items ?? this.items,
      filter: filter ?? this.filter,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isOffline: isOffline ?? this.isOffline,
    );
  }
}

/// Error state
class LostFoundListError extends LostFoundListState {
  final String message;
  final List<LostFoundModel> cachedItems;

  const LostFoundListError({
    required this.message,
    this.cachedItems = const [],
  });
}

/// Lost & Found list notifier
class LostFoundListNotifier extends StateNotifier<LostFoundListState> {
  final LostFoundRepository _repository;
  LostFoundFilter _currentFilter = const LostFoundFilter();
  static const int _pageSize = 20;

  LostFoundListNotifier(this._repository) : super(const LostFoundListInitial());

  /// Load lost & found items
  Future<void> loadItems({bool refresh = false}) async {
    final currentState = state;

    if (refresh || currentState is LostFoundListInitial) {
      state = LostFoundListLoading(
        existingItems: currentState is LostFoundListLoaded ? currentState.items : [],
      );
    }

    try {
      final result = await _repository.getLostFoundItems(
        page: 1,
        pageSize: _pageSize,
        search: _currentFilter.search,
        status: _currentFilter.status,
        category: _currentFilter.category,
        propertyId: _currentFilter.propertyId,
      );

      var items = result.results;

      // Apply client-side filter for needs attention
      if (_currentFilter.needsAttentionOnly) {
        items = items.where((item) => item.needsAttention).toList();
      }

      state = LostFoundListLoaded(
        items: items,
        filter: _currentFilter,
        currentPage: 1,
        hasMore: result.hasMore,
      );
    } catch (e) {
      final cachedItems = currentState is LostFoundListLoaded ? currentState.items : <LostFoundModel>[];
      state = LostFoundListError(
        message: e.toString(),
        cachedItems: cachedItems,
      );
    }
  }

  /// Load more items (pagination)
  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! LostFoundListLoaded || !currentState.hasMore) return;

    state = LostFoundListLoading(
      existingItems: currentState.items,
      isLoadingMore: true,
    );

    try {
      final nextPage = currentState.currentPage + 1;
      final result = await _repository.getLostFoundItems(
        page: nextPage,
        pageSize: _pageSize,
        search: _currentFilter.search,
        status: _currentFilter.status,
        category: _currentFilter.category,
        propertyId: _currentFilter.propertyId,
      );

      var newItems = result.results;

      // Apply client-side filter for needs attention
      if (_currentFilter.needsAttentionOnly) {
        newItems = newItems.where((item) => item.needsAttention).toList();
      }

      state = LostFoundListLoaded(
        items: [...currentState.items, ...newItems],
        filter: _currentFilter,
        currentPage: nextPage,
        hasMore: result.hasMore,
      );
    } catch (e) {
      // Restore previous state on error
      state = currentState;
    }
  }

  /// Set search query
  void setSearch(String? query) {
    _currentFilter = _currentFilter.copyWith(
      search: query?.isNotEmpty == true ? query : null,
    );
    loadItems(refresh: true);
  }

  /// Set status filter
  void setStatusFilter(LostFoundStatus? status) {
    _currentFilter = _currentFilter.copyWith(status: status);
    loadItems(refresh: true);
  }

  /// Set category filter
  void setCategoryFilter(LostFoundCategory? category) {
    _currentFilter = _currentFilter.copyWith(category: category);
    loadItems(refresh: true);
  }

  /// Set property filter
  void setPropertyFilter(int? propertyId, String? propertyName) {
    _currentFilter = _currentFilter.copyWith(
      propertyId: propertyId,
      propertyName: propertyName,
    );
    loadItems(refresh: true);
  }

  /// Toggle needs attention filter
  void toggleNeedsAttentionOnly() {
    _currentFilter = _currentFilter.copyWith(
      needsAttentionOnly: !_currentFilter.needsAttentionOnly,
    );
    loadItems(refresh: true);
  }

  /// Clear all filters
  void clearFilters() {
    _currentFilter = const LostFoundFilter();
    loadItems(refresh: true);
  }

  /// Update item in list (after edit)
  void updateItem(LostFoundModel updatedItem) {
    final currentState = state;
    if (currentState is LostFoundListLoaded) {
      final updatedItems = currentState.items.map((item) {
        return item.id == updatedItem.id ? updatedItem : item;
      }).toList();
      state = currentState.copyWith(items: updatedItems);
    }
  }

  /// Remove item from list (after delete/archive)
  void removeItem(int itemId) {
    final currentState = state;
    if (currentState is LostFoundListLoaded) {
      final updatedItems = currentState.items.where((item) => item.id != itemId).toList();
      state = currentState.copyWith(items: updatedItems);
    }
  }

  /// Add new item to list
  void addItem(LostFoundModel newItem) {
    final currentState = state;
    if (currentState is LostFoundListLoaded) {
      state = currentState.copyWith(items: [newItem, ...currentState.items]);
    }
  }
}
