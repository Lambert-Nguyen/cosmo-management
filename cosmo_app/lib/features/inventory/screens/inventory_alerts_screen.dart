/// Inventory alerts screen for Cosmo Management
///
/// Displays low stock alerts with filtering and action capabilities.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/service_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/loading/empty_state.dart';
import '../../../core/widgets/loading/loading_indicator.dart';
import '../../../data/models/inventory_model.dart';
import '../providers/inventory_alerts_notifier.dart';
import '../providers/inventory_providers.dart';

/// Inventory alerts screen
class InventoryAlertsScreen extends ConsumerStatefulWidget {
  const InventoryAlertsScreen({super.key});

  @override
  ConsumerState<InventoryAlertsScreen> createState() =>
      _InventoryAlertsScreenState();
}

class _InventoryAlertsScreenState extends ConsumerState<InventoryAlertsScreen> {
  @override
  void initState() {
    super.initState();
    // Load alerts on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(inventoryAlertsProvider.notifier).loadAlerts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final alertsState = ref.watch(inventoryAlertsProvider);
    final criticalCount = ref.watch(criticalLowStockCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Low Stock Alerts'),
        actions: [
          if (criticalCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: Chip(
                label: Text('$criticalCount critical'),
                backgroundColor: AppColors.error.withOpacity(0.1),
                labelStyle: theme.textTheme.labelSmall?.copyWith(
                  color: AppColors.error,
                ),
                avatar: Icon(
                  Icons.warning_rounded,
                  size: 16,
                  color: AppColors.error,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          _buildFilterChips(),

          // Alert list
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await ref
                    .read(inventoryAlertsProvider.notifier)
                    .loadAlerts(refresh: true);
              },
              child: _buildContent(alertsState),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final alertsState = ref.watch(inventoryAlertsProvider);
    final criticalOnly =
        alertsState is InventoryAlertsLoaded && alertsState.criticalOnly;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          // Critical only filter
          FilterChip(
            label: const Text('Critical Only'),
            selected: criticalOnly,
            onSelected: (_) {
              ref.read(inventoryAlertsProvider.notifier).toggleCriticalOnly();
            },
            avatar: criticalOnly
                ? const Icon(Icons.check, size: 18)
                : const Icon(Icons.warning_amber, size: 18),
          ),
          const SizedBox(width: AppSpacing.sm),

          // Clear filters button
          if (criticalOnly)
            TextButton(
              onPressed: () {
                ref.read(inventoryAlertsProvider.notifier).clearFilters();
              },
              child: const Text('Clear Filters'),
            ),
        ],
      ),
    );
  }

  Widget _buildContent(InventoryAlertsState state) {
    return switch (state) {
      InventoryAlertsInitial() => const Center(child: LoadingIndicator()),
      InventoryAlertsLoading(existingAlerts: final alerts) =>
        alerts.isEmpty
            ? const Center(child: LoadingIndicator())
            : _buildAlertList(alerts, isLoading: true),
      InventoryAlertsLoaded(alerts: final alerts, isOffline: final offline) =>
        alerts.isEmpty
            ? const EmptyState(
                icon: Icons.check_circle_outline,
                title: 'No Low Stock Alerts',
                description: 'All inventory items are well-stocked!',
              )
            : _buildAlertList(alerts, isOffline: offline),
      InventoryAlertsError(message: final msg, cachedAlerts: final alerts) =>
        alerts.isNotEmpty
            ? _buildAlertList(alerts, errorMessage: msg)
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
                            .read(inventoryAlertsProvider.notifier)
                            .loadAlerts(refresh: true);
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
    };
  }

  Widget _buildAlertList(
    List<LowStockAlertModel> alerts, {
    bool isLoading = false,
    bool isOffline = false,
    String? errorMessage,
  }) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      itemCount: alerts.length,
      itemBuilder: (context, index) {
        final alert = alerts[index];
        return _buildAlertCard(alert);
      },
    );
  }

  Widget _buildAlertCard(LowStockAlertModel alert) {
    final theme = Theme.of(context);
    final urgencyColor = _getUrgencyColor(alert);

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        onTap: () => _navigateToInventoryDetail(alert.inventoryId),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  // Urgency indicator
                  Container(
                    width: 4,
                    height: 40,
                    decoration: BoxDecoration(
                      color: urgencyColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),

                  // Item info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          alert.inventoryName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.category_outlined,
                              size: 14,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              alert.category.displayName,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            if (alert.propertyName != null) ...[
                              const SizedBox(width: AppSpacing.sm),
                              Icon(
                                Icons.home_outlined,
                                size: 14,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  alert.propertyName!,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: urgencyColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getUrgencyLabel(alert),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: urgencyColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Stock info
              Row(
                children: [
                  // Current quantity
                  Expanded(
                    child: _buildInfoChip(
                      icon: Icons.inventory_2_outlined,
                      label: 'Current',
                      value: '${alert.currentQuantity}',
                      theme: theme,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),

                  // Par level
                  if (alert.parLevel != null)
                    Expanded(
                      child: _buildInfoChip(
                        icon: Icons.trending_up,
                        label: 'Par Level',
                        value: '${alert.parLevel}',
                        theme: theme,
                      ),
                    ),
                  const SizedBox(width: AppSpacing.sm),

                  // Units needed
                  Expanded(
                    child: _buildInfoChip(
                      icon: Icons.add_circle_outline,
                      label: 'Needed',
                      value: '${alert.unitsNeeded}',
                      theme: theme,
                      valueColor: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () => _reportShortage(alert),
                    icon: const Icon(Icons.report_problem_outlined, size: 18),
                    label: const Text('Report Shortage'),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  FilledButton.icon(
                    onPressed: () => _logRestock(alert),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Restock'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required String value,
    required ThemeData theme,
    Color? valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Color _getUrgencyColor(LowStockAlertModel alert) {
    if (alert.currentQuantity == 0) return AppColors.error;
    if (alert.isCritical) return Colors.orange;
    return Colors.amber;
  }

  String _getUrgencyLabel(LowStockAlertModel alert) {
    if (alert.currentQuantity == 0) return 'OUT OF STOCK';
    if (alert.isCritical) return 'CRITICAL';
    return 'LOW STOCK';
  }

  void _navigateToInventoryDetail(int inventoryId) {
    // TODO: Navigate to inventory detail screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('View inventory item #$inventoryId')),
    );
  }

  void _reportShortage(LowStockAlertModel alert) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Shortage'),
        content: Text(
          'Report shortage for "${alert.inventoryName}"? This will create a restocking task.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Report'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final repository = ref.read(inventoryRepositoryProvider);
        await repository.reportShortage(
          alert.inventoryId,
          requestedQuantity: alert.unitsNeeded,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Shortage reported successfully')),
          );
          ref.read(inventoryAlertsProvider.notifier).loadAlerts(refresh: true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error reporting shortage: $e')),
          );
        }
      }
    }
  }

  void _logRestock(LowStockAlertModel alert) {
    // TODO: Open transaction dialog with stock-in pre-selected
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Log restock for ${alert.inventoryName}'),
        action: SnackBarAction(
          label: 'Open',
          onPressed: () {
            // Navigate to transaction form
          },
        ),
      ),
    );
  }
}

/// Provider for inventory alerts
final inventoryAlertsProvider =
    StateNotifierProvider<InventoryAlertsNotifier, InventoryAlertsState>(
        (ref) {
  return InventoryAlertsNotifier(
    inventoryRepository: ref.watch(inventoryRepositoryProvider),
    connectivityService: ref.watch(connectivityServiceProvider),
    storageService: ref.watch(storageServiceProvider),
  );
});
