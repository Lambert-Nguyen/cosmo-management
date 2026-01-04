/// Sync conflicts screen for Cosmo Management
///
/// Displays and resolves offline sync conflicts.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/offline_mutation_model.dart';
import '../providers/staff_providers.dart';

/// Provider for conflict mutations
final conflictMutationsProvider =
    FutureProvider<List<OfflineMutationModel>>((ref) async {
  final syncNotifier = ref.watch(offlineSyncProvider.notifier);
  return syncNotifier.getConflicts();
});

/// Screen for displaying and resolving sync conflicts
class SyncConflictsScreen extends ConsumerWidget {
  const SyncConflictsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conflictsAsync = ref.watch(conflictMutationsProvider);
    final syncState = ref.watch(offlineSyncProvider);
    final isSyncing = syncState is OfflineSyncInProgress;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sync Conflicts'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (!isSyncing)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => ref.invalidate(conflictMutationsProvider),
              tooltip: 'Refresh',
            ),
        ],
      ),
      body: conflictsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _ErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(conflictMutationsProvider),
        ),
        data: (conflicts) {
          if (conflicts.isEmpty) {
            return const _EmptyConflictsView();
          }
          return _ConflictsList(conflicts: conflicts);
        },
      ),
      bottomNavigationBar: conflictsAsync.maybeWhen(
        data: (conflicts) => conflicts.isNotEmpty
            ? _BulkActionsBar(conflictCount: conflicts.length)
            : null,
        orElse: () => null,
      ),
    );
  }
}

/// Empty state when no conflicts
class _EmptyConflictsView extends StatelessWidget {
  const _EmptyConflictsView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 64,
              color: AppColors.success,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No Conflicts',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'All your offline changes have been synced successfully.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Error view with retry option
class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Error Loading Conflicts',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

/// List of conflicts
class _ConflictsList extends StatelessWidget {
  const _ConflictsList({required this.conflicts});

  final List<OfflineMutationModel> conflicts;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: conflicts.length + 1, // +1 for header
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Card(
              color: AppColors.warning.withValues(alpha: 0.1),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber, color: AppColors.warning),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        '${conflicts.length} conflict${conflicts.length == 1 ? '' : 's'} found. '
                        'These changes could not be synced because the data was modified on the server.',
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return _ConflictCard(mutation: conflicts[index - 1]);
      },
    );
  }
}

/// Individual conflict card
class _ConflictCard extends ConsumerStatefulWidget {
  const _ConflictCard({required this.mutation});

  final OfflineMutationModel mutation;

  @override
  ConsumerState<_ConflictCard> createState() => _ConflictCardState();
}

class _ConflictCardState extends ConsumerState<_ConflictCard> {
  bool _isLoading = false;

  Future<void> _keepLocal() async {
    setState(() => _isLoading = true);
    try {
      await ref
          .read(offlineSyncProvider.notifier)
          .resolveConflictKeepLocal(widget.mutation.id);
      ref.invalidate(conflictMutationsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Change queued for retry')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _discardLocal() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard Changes?'),
        content: const Text(
          'This will permanently discard your local changes. '
          'The server version will be kept. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Discard'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);
    try {
      await ref
          .read(offlineSyncProvider.notifier)
          .resolveConflictDiscard(widget.mutation.id);
      ref.invalidate(conflictMutationsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Local changes discarded')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mutation = widget.mutation;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                _MutationTypeChip(type: mutation.type),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    mutation.description,
                    style: theme.textTheme.titleSmall,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.sm),

            // Error message
            if (mutation.errorMessage != null)
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 16,
                      color: AppColors.error,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        mutation.errorMessage!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: AppSpacing.sm),

            // Timestamp
            Text(
              'Created: ${_formatDateTime(mutation.createdAt)}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Action buttons
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: _discardLocal,
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: const Text('Discard'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  FilledButton.icon(
                    onPressed: _keepLocal,
                    icon: const Icon(Icons.cloud_upload_outlined, size: 18),
                    label: const Text('Retry'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inDays > 0) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

/// Chip showing mutation type
class _MutationTypeChip extends StatelessWidget {
  const _MutationTypeChip({required this.type});

  final MutationType type;

  @override
  Widget build(BuildContext context) {
    final (color, icon) = switch (type) {
      MutationType.create => (AppColors.success, Icons.add),
      MutationType.update => (AppColors.primary, Icons.edit),
      MutationType.delete => (AppColors.error, Icons.delete),
      MutationType.statusChange => (AppColors.taskInProgress, Icons.sync),
      MutationType.checklistResponse => (AppColors.primary, Icons.checklist),
      MutationType.assign => (AppColors.info, Icons.person_add),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            type.displayName,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Bottom bar with bulk actions
class _BulkActionsBar extends ConsumerStatefulWidget {
  const _BulkActionsBar({required this.conflictCount});

  final int conflictCount;

  @override
  ConsumerState<_BulkActionsBar> createState() => _BulkActionsBarState();
}

class _BulkActionsBarState extends ConsumerState<_BulkActionsBar> {
  bool _isLoading = false;

  Future<void> _retryAll() async {
    setState(() => _isLoading = true);
    try {
      await ref
          .read(offlineSyncProvider.notifier)
          .resolveAllConflictsKeepLocal();
      ref.invalidate(conflictMutationsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All conflicts queued for retry')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _discardAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard All Changes?'),
        content: Text(
          'This will permanently discard all ${widget.conflictCount} '
          'conflicting changes. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Discard All'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);
    try {
      await ref
          .read(offlineSyncProvider.notifier)
          .resolveAllConflictsDiscard();
      ref.invalidate(conflictMutationsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All local changes discarded')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _discardAll,
                      icon: const Icon(Icons.delete_sweep),
                      label: const Text('Discard All'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _retryAll,
                      icon: const Icon(Icons.cloud_sync),
                      label: const Text('Retry All'),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
