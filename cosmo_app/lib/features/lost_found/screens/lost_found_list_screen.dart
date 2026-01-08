/// Lost & Found list screen for Cosmo Management
///
/// Main screen displaying lost and found items with filtering.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/loading/empty_state.dart';
import '../../../core/widgets/loading/loading_indicator.dart';
import '../../../data/models/lost_found_model.dart';
import '../providers/lost_found_list_notifier.dart';
import '../providers/lost_found_providers.dart';
import '../widgets/lost_found_list_item.dart';

/// Lost & Found list screen
class LostFoundListScreen extends ConsumerStatefulWidget {
  const LostFoundListScreen({super.key});

  @override
  ConsumerState<LostFoundListScreen> createState() => _LostFoundListScreenState();
}

class _LostFoundListScreenState extends ConsumerState<LostFoundListScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Load items on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(lostFoundListProvider.notifier).loadItems();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = ref.read(lostFoundListProvider);
      if (state is LostFoundListLoaded && state.hasMore) {
        ref.read(lostFoundListProvider.notifier).loadMore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(lostFoundListProvider);
    final stats = ref.watch(lostFoundStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lost & Found'),
        actions: [
          // Stats badge
          stats.when(
            data: (data) => data.totalActive > 0
                ? Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: Chip(
                      label: Text('${data.totalActive} active'),
                      backgroundColor: theme.colorScheme.primaryContainer,
                      labelStyle: theme.textTheme.labelSmall,
                    ),
                  )
                : const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter',
            onPressed: _showFilterSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search items...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(lostFoundListProvider.notifier).setSearch(null);
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                ),
              ),
              onSubmitted: (value) {
                ref.read(lostFoundListProvider.notifier).setSearch(value);
              },
            ),
          ),

          // Filter chips
          _buildFilterChips(),

          // Item list
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await ref.read(lostFoundListProvider.notifier).loadItems(refresh: true);
              },
              child: _buildContent(state),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToForm(context),
        icon: const Icon(Icons.add),
        label: const Text('Report Item'),
      ),
    );
  }

  Widget _buildFilterChips() {
    final filter = ref.watch(lostFoundFilterProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          // Status filter chips
          _buildStatusChip(null, 'All', filter.status),
          const SizedBox(width: AppSpacing.xs),
          _buildStatusChip(LostFoundStatus.found, 'Found', filter.status),
          const SizedBox(width: AppSpacing.xs),
          _buildStatusChip(LostFoundStatus.lost, 'Lost', filter.status),
          const SizedBox(width: AppSpacing.xs),
          _buildStatusChip(LostFoundStatus.claimed, 'Claimed', filter.status),

          // Needs attention toggle
          const SizedBox(width: AppSpacing.md),
          FilterChip(
            label: const Text('Needs Attention'),
            selected: filter.needsAttentionOnly,
            onSelected: (_) {
              ref.read(lostFoundListProvider.notifier).toggleNeedsAttentionOnly();
            },
            avatar: filter.needsAttentionOnly
                ? const Icon(Icons.check, size: 18)
                : const Icon(Icons.warning_amber, size: 18),
          ),

          // Category filter
          if (filter.category != null) ...[
            const SizedBox(width: AppSpacing.sm),
            Chip(
              label: Text(filter.category!.displayName),
              onDeleted: () {
                ref.read(lostFoundListProvider.notifier).setCategoryFilter(null);
              },
            ),
          ],

          // Clear all
          if (filter.hasActiveFilters) ...[
            const SizedBox(width: AppSpacing.sm),
            TextButton(
              onPressed: () {
                ref.read(lostFoundListProvider.notifier).clearFilters();
              },
              child: const Text('Clear All'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusChip(
    LostFoundStatus? status,
    String label,
    LostFoundStatus? currentStatus,
  ) {
    final isSelected = status == currentStatus;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        ref.read(lostFoundListProvider.notifier).setStatusFilter(status);
      },
    );
  }

  Widget _buildContent(LostFoundListState state) {
    return switch (state) {
      LostFoundListInitial() => const Center(child: LoadingIndicator()),
      LostFoundListLoading(isLoadingMore: false) => const Center(child: LoadingIndicator()),
      LostFoundListLoading(existingItems: final items, isLoadingMore: true) =>
        _buildItemList(items, isLoadingMore: true),
      LostFoundListLoaded(items: final items, isOffline: final offline) =>
        items.isEmpty
            ? EmptyState(
                icon: Icons.search_off,
                title: 'No Items Found',
                message: 'Report a lost or found item to get started',
                actionLabel: 'Report Item',
                onAction: () => _navigateToForm(context),
              )
            : _buildItemList(items, isOffline: offline),
      LostFoundListError(message: final msg, cachedItems: final items) =>
        items.isNotEmpty
            ? _buildItemList(items, errorMessage: msg)
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: AppColors.error),
                    const SizedBox(height: AppSpacing.md),
                    Text(msg),
                    const SizedBox(height: AppSpacing.md),
                    ElevatedButton(
                      onPressed: () {
                        ref.read(lostFoundListProvider.notifier).loadItems(refresh: true);
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
    };
  }

  Widget _buildItemList(
    List<LostFoundModel> items, {
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
        return LostFoundListItem(
          item: item,
          onTap: () => _navigateToDetail(context, item),
          onClaim: item.status.canBeClaimed ? () => _showClaimDialog(item) : null,
        );
      },
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _FilterSheet(
        onCategorySelected: (category) {
          ref.read(lostFoundListProvider.notifier).setCategoryFilter(category);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _navigateToForm(BuildContext context, {LostFoundModel? item}) {
    // TODO: Navigate to form screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(item != null ? 'Edit: ${item.title}' : 'Create new item'),
      ),
    );
  }

  void _navigateToDetail(BuildContext context, LostFoundModel item) {
    // TODO: Navigate to detail/form screen
    _navigateToForm(context, item: item);
  }

  void _showClaimDialog(LostFoundModel item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Claim Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Claim "${item.title}"?'),
            const SizedBox(height: AppSpacing.md),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Contact Information',
                hintText: 'Phone or email',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement claim
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Item claimed successfully')),
              );
            },
            child: const Text('Claim'),
          ),
        ],
      ),
    );
  }
}

/// Filter bottom sheet for categories
class _FilterSheet extends StatelessWidget {
  final void Function(LostFoundCategory?) onCategorySelected;

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
              ...LostFoundCategory.values.map(
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
