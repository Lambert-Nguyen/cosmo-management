/// Sync indicator widget for Cosmo Management
///
/// Shows sync status in app bar.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/offline_mutation_model.dart';
import '../../../router/route_names.dart';
import '../providers/staff_providers.dart';

/// Sync indicator for app bar
///
/// Shows sync status: pending count, syncing spinner, or check.
class SyncIndicator extends ConsumerWidget {
  const SyncIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(offlineSyncProvider);
    final isOffline = ref.watch(isOfflineProvider);

    return switch (syncState) {
      OfflineSyncInProgress(completed: final done, total: final total) =>
        _buildSyncing(context, done, total),
      OfflineSyncIdle(status: final status) =>
        _buildIdle(context, status, isOffline),
      OfflineSyncComplete(result: final result) =>
        _buildComplete(context, result),
      OfflineSyncError(message: final msg) => _buildError(context, msg),
    };
  }

  Widget _buildSyncing(BuildContext context, int done, int total) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              value: total > 0 ? done / total : null,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '$done/$total',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdle(
    BuildContext context,
    SyncStatusModel status,
    bool isOffline,
  ) {
    if (isOffline) {
      return _buildOfflineIndicator(context, status.pendingCount);
    }

    if (status.hasPendingChanges) {
      return _buildPendingBadge(context, status.pendingCount);
    }

    if (status.hasErrors) {
      return IconButton(
        icon: const Icon(Icons.sync_problem),
        color: AppColors.error,
        tooltip: '${status.failedCount} failed to sync - tap to resolve',
        onPressed: () => context.push(RouteNames.syncConflicts),
      );
    }

    // All synced
    return const SizedBox.shrink();
  }

  Widget _buildComplete(BuildContext context, SyncResultModel result) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Icon(
        result.isSuccess ? Icons.cloud_done : Icons.cloud_off,
        color: result.isSuccess ? AppColors.success : AppColors.warning,
        size: 20,
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return IconButton(
      icon: const Icon(Icons.sync_problem),
      color: AppColors.error,
      tooltip: '$message - tap to resolve',
      onPressed: () => context.push(RouteNames.syncConflicts),
    );
  }

  Widget _buildOfflineIndicator(BuildContext context, int pendingCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.cloud_off,
            size: 18,
            color: Colors.orange,
          ),
          if (pendingCount > 0) ...[
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                pendingCount.toString(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPendingBadge(BuildContext context, int count) {
    return IconButton(
      icon: Badge(
        label: Text(count.toString()),
        child: const Icon(Icons.sync),
      ),
      tooltip: '$count pending changes',
      onPressed: () {
        // Could trigger manual sync
      },
    );
  }
}

/// Sync indicator for app bar action (icon button style)
class SyncIndicatorButton extends ConsumerWidget {
  const SyncIndicatorButton({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(offlineSyncProvider);
    final pendingCount = ref.watch(pendingCountProvider);
    final isOffline = ref.watch(isOfflineProvider);

    final isSyncing = syncState is OfflineSyncInProgress;

    if (isSyncing) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (isOffline) {
      return IconButton(
        icon: Badge(
          label: pendingCount > 0 ? Text(pendingCount.toString()) : null,
          isLabelVisible: pendingCount > 0,
          child: const Icon(Icons.cloud_off),
        ),
        tooltip: 'Offline${pendingCount > 0 ? ' - $pendingCount pending' : ''}',
        onPressed: null,
      );
    }

    if (pendingCount > 0) {
      return IconButton(
        icon: Badge(
          label: Text(pendingCount.toString()),
          child: const Icon(Icons.sync),
        ),
        tooltip: '$pendingCount pending changes - tap to sync',
        onPressed: onPressed ??
            () {
              ref.read(offlineSyncProvider.notifier).syncPendingMutations();
            },
      );
    }

    return const SizedBox.shrink();
  }
}
