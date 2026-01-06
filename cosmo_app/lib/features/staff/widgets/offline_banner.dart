/// Offline banner widget for Cosmo Management
///
/// Shows a banner when offline with pending changes count.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../providers/staff_providers.dart';

/// Offline banner
///
/// Shows a banner at the top of the screen when offline.
class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOffline = ref.watch(isOfflineProvider);
    final pendingCount = ref.watch(pendingCountProvider);

    if (!isOffline) return const SizedBox.shrink();

    return MaterialBanner(
      padding: const EdgeInsets.all(AppSpacing.sm),
      content: Row(
        children: [
          const Icon(Icons.cloud_off, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              pendingCount > 0
                  ? 'You\'re offline. $pendingCount change${pendingCount == 1 ? '' : 's'} will sync when back online.'
                  : 'You\'re offline. Changes will sync when back online.',
            ),
          ),
        ],
      ),
      backgroundColor: Colors.orange.shade100,
      actions: const [SizedBox.shrink()],
    );
  }
}

/// Compact offline indicator
///
/// Shows a small indicator at the bottom of the screen.
class OfflineIndicator extends ConsumerWidget {
  const OfflineIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOffline = ref.watch(isOfflineProvider);
    final syncState = ref.watch(offlineSyncProvider);
    final pendingCount = ref.watch(pendingCountProvider);

    if (!isOffline && syncState is! OfflineSyncInProgress) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      color: isOffline ? Colors.orange : Colors.blue,
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (syncState is OfflineSyncInProgress) ...[
              const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Syncing ${syncState.completed}/${syncState.total}...',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ] else if (isOffline) ...[
              const Icon(
                Icons.cloud_off,
                size: 14,
                color: Colors.white,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                pendingCount > 0
                    ? 'Offline - $pendingCount pending'
                    : 'Offline',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Sync progress indicator
///
/// Shows sync progress as a linear indicator.
class SyncProgressIndicator extends ConsumerWidget {
  const SyncProgressIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(offlineSyncProvider);

    if (syncState is! OfflineSyncInProgress) {
      return const SizedBox.shrink();
    }

    return LinearProgressIndicator(
      value: syncState.progress,
      backgroundColor: Colors.grey[300],
      valueColor: const AlwaysStoppedAnimation(Colors.blue),
    );
  }
}
