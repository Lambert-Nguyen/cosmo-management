/// Staff dashboard screen for Cosmo Management
///
/// Main dashboard showing task counts and today's tasks.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../router/route_names.dart';
import '../providers/staff_providers.dart';
import '../widgets/stat_card.dart';
import '../widgets/sync_indicator.dart';
import '../widgets/task_list_item.dart';
import 'staff_shell.dart';

/// Staff dashboard screen
///
/// Shows task counts by status and today's tasks list.
class StaffDashboardScreen extends ConsumerWidget {
  const StaffDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(staffDashboardProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: const [
          SyncIndicatorButton(),
          SizedBox(width: 8),
        ],
      ),
      body: switch (dashboardState) {
        StaffDashboardInitial() ||
        StaffDashboardLoading() =>
          const StaffLoadingState(message: 'Loading dashboard...'),
        StaffDashboardError(message: final msg) => StaffErrorState(
            message: msg,
            onRetry: () =>
                ref.read(staffDashboardProvider.notifier).refresh(),
          ),
        StaffDashboardLoaded(
          taskCounts: final taskCounts,
          todaysTasks: final todaysTasks,
        ) =>
          RefreshIndicator(
            onRefresh: () =>
                ref.read(staffDashboardProvider.notifier).refresh(),
            child: CustomScrollView(
              slivers: [
                // Stat cards
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.md),
                    child: StatCardsRow(
                      stats: StatCardData.dashboardStats(
                        pending: taskCounts.pending,
                        inProgress: taskCounts.inProgress,
                        completed: taskCounts.completed,
                        overdue: taskCounts.overdue,
                      ),
                      onStatTap: (index) => _onStatTap(context, index),
                    ),
                  ),
                ),

                // Today's tasks header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      children: [
                        Text(
                          "Today's Tasks",
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () =>
                              context.push(RouteNames.staffTaskList),
                          child: const Text('View All'),
                        ),
                      ],
                    ),
                  ),
                ),

                // Today's tasks list
                if (todaysTasks.isEmpty)
                  const SliverFillRemaining(
                    child: StaffEmptyState(
                      icon: Icons.check_circle_outline,
                      title: 'No tasks for today',
                      subtitle: 'Enjoy your day off or check pending tasks.',
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final task = todaysTasks[index];
                        return TaskListItem(
                          task: task,
                          onTap: () => context.push(
                            RouteNames.staffTaskDetail(task.id),
                          ),
                        );
                      },
                      childCount: todaysTasks.length,
                    ),
                  ),

                // Bottom padding
                const SliverToBoxAdapter(
                  child: SizedBox(height: 80),
                ),
              ],
            ),
          ),
      },
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(RouteNames.staffTaskCreate),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _onStatTap(BuildContext context, int index) {
    // Navigate to task list with pre-applied filter
    final filter = switch (index) {
      0 => 'pending',
      1 => 'in_progress',
      2 => 'completed',
      3 => 'overdue',
      _ => null,
    };

    if (filter != null) {
      context.push('${RouteNames.staffTaskList}?status=$filter');
    }
  }
}
