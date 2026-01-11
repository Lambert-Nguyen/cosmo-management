/// Booking list screen for Cosmo Management Portal
///
/// Displays list of bookings for portal users.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/booking_model.dart';
import '../../../router/route_names.dart';
import '../providers/portal_providers.dart';
import 'portal_shell.dart';

/// Booking list screen
///
/// Shows all bookings with filtering options.
class BookingListScreen extends ConsumerStatefulWidget {
  const BookingListScreen({super.key});

  @override
  ConsumerState<BookingListScreen> createState() => _BookingListScreenState();
}

class _BookingListScreenState extends ConsumerState<BookingListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController.addListener(_onScroll);
    // Load bookings on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bookingListProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(bookingListProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookings'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Active'),
            Tab(text: 'Past'),
          ],
          onTap: (index) {
            final status = switch (index) {
              0 => BookingStatus.confirmed,
              1 => BookingStatus.checkedIn,
              2 => BookingStatus.completed,
              _ => null,
            };
            ref.read(bookingListProvider.notifier).setStatusFilter(status);
          },
        ),
      ),
      body: switch (bookingState) {
        BookingListInitial() ||
        BookingListLoading() =>
          const PortalLoadingState(message: 'Loading bookings...'),
        BookingListError(message: final msg) => PortalErrorState(
            message: msg,
            onRetry: () => ref.read(bookingListProvider.notifier).refresh(),
          ),
        BookingListLoaded(
          bookings: final bookings,
          hasMore: final hasMore,
        ) =>
          bookings.isEmpty
              ? const PortalEmptyState(
                  icon: Icons.book_outlined,
                  title: 'No bookings found',
                  subtitle: 'Bookings will appear here once created',
                )
              : RefreshIndicator(
                  onRefresh: () =>
                      ref.read(bookingListProvider.notifier).refresh(),
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: bookings.length + (hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == bookings.length) {
                        return const Padding(
                          padding: EdgeInsets.all(AppSpacing.md),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final booking = bookings[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: _BookingCard(
                          booking: booking,
                          onTap: () => context.push(
                            RouteNames.portalBookingDetail(booking.id),
                          ),
                        ),
                      );
                    },
                  ),
                ),
      },
    );
  }
}

/// Booking card widget
class _BookingCard extends StatelessWidget {
  const _BookingCard({
    required this.booking,
    this.onTap,
  });

  final BookingModel booking;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.propertyName ?? 'Property #${booking.propertyId}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (booking.guestName != null)
                          Text(
                            booking.guestName!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                  _StatusChip(status: booking.status),
                ],
              ),

              const SizedBox(height: AppSpacing.sm),
              const Divider(height: 1),
              const SizedBox(height: AppSpacing.sm),

              // Dates row
              Row(
                children: [
                  Expanded(
                    child: _DateInfo(
                      icon: Icons.login,
                      label: 'Check-in',
                      date: booking.checkIn,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                    child: Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Expanded(
                    child: _DateInfo(
                      icon: Icons.logout,
                      label: 'Check-out',
                      date: booking.checkOut,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.sm),

              // Footer row
              Row(
                children: [
                  Icon(
                    Icons.nights_stay_outlined,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSpacing.xxs),
                  Text(
                    '${booking.nights} night${booking.nights > 1 ? 's' : ''}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (booking.numGuests != null) ...[
                    const SizedBox(width: AppSpacing.md),
                    Icon(
                      Icons.people_outline,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: AppSpacing.xxs),
                    Text(
                      '${booking.numGuests} guest${booking.numGuests! > 1 ? 's' : ''}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  const Spacer(),
                  Text(
                    booking.statusDisplay,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: _getStatusColor(booking.status),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(BookingStatus status) {
    return switch (status) {
      BookingStatus.pending => AppColors.warning,
      BookingStatus.confirmed => AppColors.info,
      BookingStatus.checkedIn => AppColors.success,
      BookingStatus.checkedOut || BookingStatus.completed => AppColors.primary,
      BookingStatus.cancelled || BookingStatus.noShow => AppColors.error,
    };
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final BookingStatus status;

  @override
  Widget build(BuildContext context) {
    final (color, bgColor) = switch (status) {
      BookingStatus.pending => (AppColors.warning, AppColors.warningContainer),
      BookingStatus.confirmed => (AppColors.info, AppColors.infoContainer),
      BookingStatus.checkedIn => (AppColors.success, AppColors.successContainer),
      BookingStatus.checkedOut ||
      BookingStatus.completed =>
        (AppColors.primary, AppColors.primaryContainer),
      BookingStatus.cancelled ||
      BookingStatus.noShow =>
        (AppColors.error, AppColors.errorContainer),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.displayName,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _DateInfo extends StatelessWidget {
  const _DateInfo({
    required this.icon,
    required this.label,
    required this.date,
  });

  final IconData icon;
  final String label;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: AppSpacing.xs),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              _formatDate(date),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}';
  }
}
