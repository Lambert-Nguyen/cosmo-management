/// Inventory detail screen for Cosmo Management
///
/// Shows full inventory item details with transaction history.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/inventory_model.dart';
import '../providers/inventory_providers.dart';
import '../widgets/transaction_form.dart';

/// Format a date for display
String _formatDateTime(DateTime date) {
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

/// Inventory detail screen
///
/// Shows inventory item details, stock levels, and transaction history.
class InventoryDetailScreen extends ConsumerStatefulWidget {
  const InventoryDetailScreen({
    super.key,
    required this.inventoryId,
  });

  final int inventoryId;

  @override
  ConsumerState<InventoryDetailScreen> createState() =>
      _InventoryDetailScreenState();
}

class _InventoryDetailScreenState
    extends ConsumerState<InventoryDetailScreen> {
  @override
  Widget build(BuildContext context) {
    // Use dedicated provider for individual item fetch
    final inventoryAsync = ref.watch(inventoryDetailProvider(widget.inventoryId));

    return inventoryAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(
          title: const Text('Inventory Details'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(
          title: const Text('Inventory Details'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Failed to load inventory item'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => ref.invalidate(inventoryDetailProvider(widget.inventoryId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      data: (item) => _buildDetailView(context, item),
    );
  }

  Widget _buildDetailView(BuildContext context, InventoryModel item) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Edit inventory item via web portal'),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(inventoryDetailProvider(widget.inventoryId));
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              _InventoryHeaderCard(item: item),
              const SizedBox(height: AppSpacing.md),

              // Stock Information Card
              _StockInformationCard(item: item),
              const SizedBox(height: AppSpacing.md),

              // Details Card
              _DetailsCard(item: item),
              const SizedBox(height: AppSpacing.md),

              // Quick Actions
              _QuickActionsCard(
                item: item,
                onTransaction: () => _showTransactionForm(item),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTransactionForm(InventoryModel item) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
          child: TransactionFormDialog(
            item: item,
            initialType: item.isLowStock
                ? InventoryTransactionType.stockIn
                : null,
          ),
        ),
      ),
    ).then((_) {
      // Refresh inventory detail and list
      ref.invalidate(inventoryDetailProvider(widget.inventoryId));
      ref.read(inventoryListProvider.notifier).loadInventory(refresh: true);
    });
  }
}

/// Header card showing item name and category
class _InventoryHeaderCard extends StatelessWidget {
  const _InventoryHeaderCard({required this.item});

  final InventoryModel item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _getCategoryIcon(item.category),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    item.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            if (item.sku != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                'SKU: ${item.sku}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
            if (item.description != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                item.description!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _getCategoryIcon(InventoryCategory category) {
    IconData icon;
    Color color;

    switch (category) {
      case InventoryCategory.cleaningSupplies:
        icon = Icons.cleaning_services;
        color = Colors.blue;
        break;
      case InventoryCategory.maintenance:
        icon = Icons.build;
        color = Colors.orange;
        break;
      case InventoryCategory.linens:
        icon = Icons.bedroom_parent;
        color = Colors.purple;
        break;
      case InventoryCategory.toiletries:
        icon = Icons.wash;
        color = Colors.teal;
        break;
      case InventoryCategory.kitchen:
        icon = Icons.kitchen;
        color = Colors.red;
        break;
      case InventoryCategory.outdoor:
        icon = Icons.yard;
        color = Colors.green;
        break;
      case InventoryCategory.electronics:
        icon = Icons.devices;
        color = Colors.indigo;
        break;
      case InventoryCategory.furniture:
        icon = Icons.chair;
        color = Colors.brown;
        break;
      case InventoryCategory.other:
        icon = Icons.inventory_2;
        color = Colors.grey;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 32),
    );
  }
}

/// Stock information card
class _StockInformationCard extends StatelessWidget {
  const _StockInformationCard({required this.item});

  final InventoryModel item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Stock Information',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: _StockMetric(
                    label: 'Current Stock',
                    value: item.quantityDisplay,
                    color: _getStockColor(),
                  ),
                ),
                if (item.parLevel != null)
                  Expanded(
                    child: _StockMetric(
                      label: 'Par Level',
                      value: '${item.parLevel} ${item.unitType ?? ''}',
                      color: Colors.grey[600]!,
                    ),
                  ),
                if (item.reorderPoint != null)
                  Expanded(
                    child: _StockMetric(
                      label: 'Reorder Point',
                      value: '${item.reorderPoint} ${item.unitType ?? ''}',
                      color: Colors.grey[600]!,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            // Stock status badge
            _buildStatusBadge(),
          ],
        ),
      ),
    );
  }

  Color _getStockColor() {
    if (item.isOutOfStock) return AppColors.error;
    if (item.isCriticallyLow) return Colors.orange;
    if (item.isLowStock) return Colors.amber;
    return AppColors.success;
  }

  Widget _buildStatusBadge() {
    Color bgColor;
    Color textColor;
    String label;

    if (item.isOutOfStock) {
      bgColor = AppColors.error;
      textColor = Colors.white;
      label = 'OUT OF STOCK';
    } else if (item.isCriticallyLow) {
      bgColor = Colors.orange;
      textColor = Colors.white;
      label = 'CRITICAL';
    } else if (item.isLowStock) {
      bgColor = Colors.amber;
      textColor = Colors.black;
      label = 'LOW STOCK';
    } else {
      bgColor = AppColors.success;
      textColor = Colors.white;
      label = 'IN STOCK';
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

/// Stock metric display
class _StockMetric extends StatelessWidget {
  const _StockMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
      ],
    );
  }
}

/// Details card showing additional information
class _DetailsCard extends StatelessWidget {
  const _DetailsCard({required this.item});

  final InventoryModel item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Details',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppSpacing.md),
            _DetailRow(
              label: 'Category',
              value: item.category.displayName,
            ),
            if (item.propertyName != null)
              _DetailRow(
                label: 'Property',
                value: item.propertyName!,
              ),
            if (item.location != null)
              _DetailRow(
                label: 'Location',
                value: item.location!,
              ),
            if (item.barcode != null)
              _DetailRow(
                label: 'Barcode',
                value: item.barcode!,
              ),
            if (item.unitCost != null)
              _DetailRow(
                label: 'Unit Cost',
                value: '\$${item.unitCost!.toStringAsFixed(2)}',
              ),
            if (item.lastCountedAt != null)
              _DetailRow(
                label: 'Last Counted',
                value:
                    '${_formatDateTime(item.lastCountedAt!)}${item.lastCountedByName != null ? ' by ${item.lastCountedByName}' : ''}',
              ),
          ],
        ),
      ),
    );
  }
}

/// Detail row widget
class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Quick actions card
class _QuickActionsCard extends StatelessWidget {
  const _QuickActionsCard({
    required this.item,
    required this.onTransaction,
  });

  final InventoryModel item;
  final VoidCallback onTransaction;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                ElevatedButton.icon(
                  onPressed: onTransaction,
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('Log Transaction'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
                if (item.isLowStock)
                  OutlinedButton.icon(
                    onPressed: onTransaction,
                    icon: const Icon(Icons.inventory),
                    label: const Text('Restock'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
