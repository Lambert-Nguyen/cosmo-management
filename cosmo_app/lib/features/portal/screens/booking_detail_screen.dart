/// Booking detail screen for Cosmo Management Portal
///
/// Displays detailed booking information.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/booking_model.dart';
import '../providers/portal_providers.dart';
import 'portal_shell.dart';

/// Booking detail screen
///
/// Shows complete booking details for portal users.
class BookingDetailScreen extends ConsumerWidget {
  const BookingDetailScreen({
    super.key,
    required this.bookingId,
  });

  final int bookingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingAsync = ref.watch(bookingDetailProvider(bookingId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
      ),
      body: bookingAsync.when(
        loading: () => const PortalLoadingState(message: 'Loading booking...'),
        error: (error, _) => PortalErrorState(
          message: error.toString(),
          onRetry: () => ref.invalidate(bookingDetailProvider(bookingId)),
        ),
        data: (booking) => _BookingDetailContent(booking: booking),
      ),
    );
  }
}

class _BookingDetailContent extends StatelessWidget {
  const _BookingDetailContent({required this.booking});

  final BookingModel booking;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status card
          _StatusCard(booking: booking),

          const SizedBox(height: AppSpacing.md),

          // Guest info
          _SectionCard(
            title: 'Guest Information',
            icon: Icons.person,
            children: [
              if (booking.guestName != null)
                _InfoRow(label: 'Name', value: booking.guestName!),
              if (booking.guestEmail != null)
                _InfoRow(label: 'Email', value: booking.guestEmail!),
              if (booking.guestPhone != null)
                _InfoRow(label: 'Phone', value: booking.guestPhone!),
              if (booking.numGuests != null)
                _InfoRow(
                  label: 'Guests',
                  value: '${booking.numGuests} guest${booking.numGuests! > 1 ? 's' : ''}',
                ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Stay details
          _SectionCard(
            title: 'Stay Details',
            icon: Icons.calendar_today,
            children: [
              _InfoRow(
                label: 'Check-in',
                value: _formatDateTime(booking.checkIn),
              ),
              _InfoRow(
                label: 'Check-out',
                value: _formatDateTime(booking.checkOut),
              ),
              _InfoRow(
                label: 'Duration',
                value: '${booking.nights} night${booking.nights > 1 ? 's' : ''}',
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Booking info
          _SectionCard(
            title: 'Booking Information',
            icon: Icons.book,
            children: [
              if (booking.confirmationCode != null)
                _InfoRow(
                  label: 'Confirmation',
                  value: booking.confirmationCode!,
                ),
              if (booking.bookingSource != null)
                _InfoRow(label: 'Source', value: booking.bookingSource!),
              if (booking.totalAmount != null)
                _InfoRow(
                  label: 'Total',
                  value: '\$${booking.totalAmount!.toStringAsFixed(2)}',
                ),
            ],
          ),

          if (booking.specialRequests != null) ...[
            const SizedBox(height: AppSpacing.md),
            _SectionCard(
              title: 'Special Requests',
              icon: Icons.note,
              children: [
                Text(
                  booking.specialRequests!,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ],

          if (booking.notes != null) ...[
            const SizedBox(height: AppSpacing.md),
            _SectionCard(
              title: 'Notes',
              icon: Icons.notes,
              children: [
                Text(
                  booking.notes!,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ],

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime date) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.booking});

  final BookingModel booking;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (statusColor, statusBg) = _getStatusColors(booking.status);

    return Card(
      color: statusBg,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getStatusIcon(booking.status),
                color: statusColor,
                size: 32,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.status.displayName,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                  Text(
                    booking.statusDisplay,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: statusColor.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  (Color, Color) _getStatusColors(BookingStatus status) {
    return switch (status) {
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
  }

  IconData _getStatusIcon(BookingStatus status) {
    return switch (status) {
      BookingStatus.pending => Icons.schedule,
      BookingStatus.confirmed => Icons.check_circle,
      BookingStatus.checkedIn => Icons.login,
      BookingStatus.checkedOut => Icons.logout,
      BookingStatus.completed => Icons.done_all,
      BookingStatus.cancelled => Icons.cancel,
      BookingStatus.noShow => Icons.person_off,
    };
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
