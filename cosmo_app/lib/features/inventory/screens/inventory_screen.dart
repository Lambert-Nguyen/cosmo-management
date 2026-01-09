/// Inventory screen for Cosmo Management
///
/// Main inventory screen with tabbed view for lookup and transactions.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/loading/empty_state.dart';
import '../../../core/widgets/loading/loading_indicator.dart';
import '../../../data/models/inventory_model.dart';
import '../providers/inventory_providers.dart';
import '../widgets/inventory_list_item.dart';
import '../widgets/transaction_form.dart';
import 'inventory_alerts_screen.dart';

/// Inventory screen with tabbed interface
class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController.addListener(_onScroll);

    // Load inventory on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(inventoryListProvider.notifier).loadInventory();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = ref.read(inventoryListProvider);
      if (state is InventoryListLoaded && state.hasMore) {
        ref.read(inventoryListProvider.notifier).loadMore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final lowStockCount = ref.watch(lowStockCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        actions: [
          if (lowStockCount > 0)
            Badge(
              label: Text('$lowStockCount'),
              child: IconButton(
                icon: const Icon(Icons.warning_amber_rounded),
                tooltip: 'Low Stock Alerts',
                onPressed: () => _navigateToAlerts(context),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter',
            onPressed: _showFilterSheet,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Inventory', icon: Icon(Icons.inventory_2_outlined)),
            Tab(text: 'Transactions', icon: Icon(Icons.history)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildInventoryTab(),
          _buildTransactionsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showTransactionDialog,
        tooltip: 'Log Transaction',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildInventoryTab() {
    final inventoryState = ref.watch(inventoryListProvider);

    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search inventory...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        ref.read(inventoryListProvider.notifier).setSearch(null);
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.sm),
              ),
            ),
            onSubmitted: (value) {
              ref.read(inventoryListProvider.notifier).setSearch(value);
            },
          ),
        ),

        // Filter chips
        _buildFilterChips(),

        // Inventory list
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await ref.read(inventoryListProvider.notifier).loadInventory(
                    refresh: true,
                  );
            },
            child: _buildInventoryContent(inventoryState),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    final filter = ref.watch(inventoryFilterProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          // Low stock filter
          FilterChip(
            label: const Text('Low Stock'),
            selected: filter.lowStockOnly,
            onSelected: (_) {
              ref.read(inventoryListProvider.notifier).toggleLowStockOnly();
            },
            avatar: filter.lowStockOnly
                ? const Icon(Icons.check, size: 18)
                : const Icon(Icons.warning_amber, size: 18),
          ),
          const SizedBox(width: AppSpacing.sm),

          // Category filter
          if (filter.category != null)
            Chip(
              label: Text(filter.category!.displayName),
              onDeleted: () {
                ref.read(inventoryListProvider.notifier).setCategoryFilter(null);
              },
            ),

          // Property filter
          if (filter.propertyName != null)
            Padding(
              padding: const EdgeInsets.only(left: AppSpacing.sm),
              child: Chip(
                label: Text(filter.propertyName!),
                onDeleted: () {
                  ref
                      .read(inventoryListProvider.notifier)
                      .setPropertyFilter(null, null);
                },
              ),
            ),

          // Clear all button
          if (filter.category != null ||
              filter.propertyId != null ||
              filter.lowStockOnly)
            Padding(
              padding: const EdgeInsets.only(left: AppSpacing.sm),
              child: TextButton(
                onPressed: () {
                  ref.read(inventoryListProvider.notifier).clearFilters();
                },
                child: const Text('Clear All'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInventoryContent(InventoryListState state) {
    return switch (state) {
      InventoryListInitial() => const Center(
          child: LoadingIndicator(),
        ),
      InventoryListLoading(isLoadingMore: false) => const Center(
          child: LoadingIndicator(),
        ),
      InventoryListLoading(existingItems: final items, isLoadingMore: true) =>
        _buildInventoryList(items, isLoadingMore: true),
      InventoryListLoaded(items: final items, isOffline: final offline) =>
        items.isEmpty
            ? EmptyState(
                icon: Icons.inventory_2_outlined,
                title: 'No Inventory Items',
                description: 'Add items to track your inventory',
                actionLabel: 'Add Item',
                onAction: _showAddItemDialog,
              )
            : _buildInventoryList(items, isOffline: offline),
      InventoryListError(message: final msg, cachedItems: final items) =>
        items.isNotEmpty
            ? _buildInventoryList(items, errorMessage: msg)
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline,
                        size: 48, color: AppColors.error),
                    const SizedBox(height: AppSpacing.md),
                    Text(msg),
                    const SizedBox(height: AppSpacing.md),
                    ElevatedButton(
                      onPressed: () {
                        ref
                            .read(inventoryListProvider.notifier)
                            .loadInventory(refresh: true);
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
    };
  }

  Widget _buildInventoryList(
    List<InventoryModel> items, {
    bool isLoadingMore = false,
    bool isOffline = false,
    String? errorMessage,
  }) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 80), // FAB space
      itemCount: items.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == items.length) {
          return const Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final item = items[index];
        return InventoryListItem(
          item: item,
          onTap: () => _navigateToDetail(context, item),
          onTransaction: () => _showTransactionDialog(item: item),
        );
      },
    );
  }

  Widget _buildTransactionsTab() {
    final transactionsAsync = ref.watch(recentTransactionsProvider);

    return transactionsAsync.when(
      data: (transactions) {
        if (transactions.isEmpty) {
          return const EmptyState(
            icon: Icons.history,
            title: 'No Transactions',
            description: 'Transaction history will appear here',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.md),
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            return Card(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: transaction.type.reducesStock
                      ? AppColors.error.withOpacity(0.1)
                      : AppColors.success.withOpacity(0.1),
                  child: Icon(
                    transaction.type.reducesStock
                        ? Icons.remove
                        : Icons.add,
                    color: transaction.type.reducesStock
                        ? AppColors.error
                        : AppColors.success,
                  ),
                ),
                title: Text(transaction.inventoryName ?? 'Unknown Item'),
                subtitle: Text(
                  '${transaction.type.displayName} • ${transaction.quantityChangeDisplay}',
                ),
                trailing: Text(
                  transaction.createdAt != null
                      ? _formatDate(transaction.createdAt!)
                      : '',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: LoadingIndicator()),
      error: (error, _) => Center(
        child: Text('Error loading transactions: $error'),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return 'Today';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _FilterSheet(
        onCategorySelected: (category) {
          ref.read(inventoryListProvider.notifier).setCategoryFilter(category);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showTransactionDialog({InventoryModel? item}) {
    showDialog(
      context: context,
      builder: (context) => TransactionFormDialog(item: item),
    );
  }

  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Inventory Item'),
        content: const Text('Add item form coming soon...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _navigateToDetail(BuildContext context, InventoryModel item) {
    // TODO: Navigate to detail screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('View ${item.name}')),
    );
  }

  void _navigateToAlerts(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const InventoryAlertsScreen(),
      ),
    );
  }
}

/// Filter bottom sheet
class _FilterSheet extends StatelessWidget {
  final void Function(InventoryCategory?) onCategorySelected;

  const _FilterSheet({required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter by Category',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              ActionChip(
                label: const Text('All'),
                onPressed: () => onCategorySelected(null),
              ),
              ...InventoryCategory.values.map(
                (category) => ActionChip(
                  label: Text(category.displayName),
                  onPressed: () => onCategorySelected(category),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}
