/// Calendar screen for Cosmo Management Portal
///
/// Displays calendar with bookings and events.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/calendar_model.dart';
import '../providers/portal_providers.dart';
import 'portal_shell.dart';

/// Calendar screen
///
/// Shows calendar view with events and bookings.
class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarState = ref.watch(calendarProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: [
          // View mode toggle
          PopupMenuButton<CalendarViewMode>(
            icon: const Icon(Icons.view_agenda),
            onSelected: (mode) {
              ref.read(calendarProvider.notifier).setViewMode(mode);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: CalendarViewMode.month,
                child: Text('Month View'),
              ),
              const PopupMenuItem(
                value: CalendarViewMode.week,
                child: Text('Week View'),
              ),
              const PopupMenuItem(
                value: CalendarViewMode.day,
                child: Text('Day View'),
              ),
            ],
          ),
        ],
      ),
      body: switch (calendarState) {
        CalendarInitial() ||
        CalendarLoading() =>
          const PortalLoadingState(message: 'Loading calendar...'),
        CalendarError(message: final msg) => PortalErrorState(
            message: msg,
            onRetry: () => ref.read(calendarProvider.notifier).refresh(),
          ),
        CalendarLoaded(
          events: final events,
          selectedDate: final selectedDate,
          viewMode: final viewMode,
        ) =>
          Column(
            children: [
              // Navigation header
              _CalendarHeader(
                selectedDate: selectedDate,
                viewMode: viewMode,
                onPrevious: () =>
                    ref.read(calendarProvider.notifier).goToPrevious(),
                onNext: () => ref.read(calendarProvider.notifier).goToNext(),
                onToday: () => ref.read(calendarProvider.notifier).goToToday(),
              ),

              // Calendar view
              Expanded(
                child: switch (viewMode) {
                  CalendarViewMode.month => _MonthView(
                      selectedDate: selectedDate,
                      events: events,
                      onDateSelected: (date) {
                        ref.read(calendarProvider.notifier).setSelectedDate(date);
                      },
                    ),
                  CalendarViewMode.week => _WeekView(
                      selectedDate: selectedDate,
                      events: events,
                      onDateSelected: (date) {
                        ref.read(calendarProvider.notifier).setSelectedDate(date);
                      },
                    ),
                  CalendarViewMode.day => _DayView(
                      selectedDate: selectedDate,
                      events: events,
                    ),
                },
              ),
            ],
          ),
      },
    );
  }
}

/// Calendar header with navigation
class _CalendarHeader extends StatelessWidget {
  const _CalendarHeader({
    required this.selectedDate,
    required this.viewMode,
    required this.onPrevious,
    required this.onNext,
    required this.onToday,
  });

  final DateTime selectedDate;
  final CalendarViewMode viewMode;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onToday;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: onPrevious,
          ),
          Expanded(
            child: Text(
              _formatHeader(selectedDate, viewMode),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: onNext,
          ),
          TextButton(
            onPressed: onToday,
            child: const Text('Today'),
          ),
        ],
      ),
    );
  }

  String _formatHeader(DateTime date, CalendarViewMode mode) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

    return switch (mode) {
      CalendarViewMode.month => '${months[date.month - 1]} ${date.year}',
      CalendarViewMode.week => 'Week of ${months[date.month - 1]} ${date.day}',
      CalendarViewMode.day =>
        '${months[date.month - 1]} ${date.day}, ${date.year}',
    };
  }
}

/// Month view calendar
class _MonthView extends StatelessWidget {
  const _MonthView({
    required this.selectedDate,
    required this.events,
    required this.onDateSelected,
  });

  final DateTime selectedDate;
  final List<CalendarEventModel> events;
  final void Function(DateTime) onDateSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final firstDay = DateTime(selectedDate.year, selectedDate.month, 1);
    final lastDay = DateTime(selectedDate.year, selectedDate.month + 1, 0);
    final startWeekday = firstDay.weekday;
    final daysInMonth = lastDay.day;

    return Column(
      children: [
        // Weekday headers
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                .map((day) => Expanded(
                      child: Text(
                        day,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),

        // Calendar grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(AppSpacing.xs),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
            ),
            itemCount: 42, // 6 weeks
            itemBuilder: (context, index) {
              final dayOffset = index - (startWeekday - 1);
              if (dayOffset < 1 || dayOffset > daysInMonth) {
                return const SizedBox();
              }

              final date = DateTime(selectedDate.year, selectedDate.month, dayOffset);
              final dayEvents = events.where((e) => e.isOnDate(date)).toList();
              final isToday = _isToday(date);
              final isSelected = _isSameDay(date, selectedDate);

              return _DayCell(
                date: date,
                events: dayEvents,
                isToday: isToday,
                isSelected: isSelected,
                onTap: () => onDateSelected(date),
              );
            },
          ),
        ),
      ],
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

/// Day cell in month view
class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.date,
    required this.events,
    required this.isToday,
    required this.isSelected,
    required this.onTap,
  });

  final DateTime date;
  final List<CalendarEventModel> events;
  final bool isToday;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary
              : isToday
                  ? theme.colorScheme.primaryContainer
                  : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${date.day}',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: isToday || isSelected ? FontWeight.bold : null,
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : isToday
                        ? theme.colorScheme.primary
                        : null,
              ),
            ),
            if (events.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: events
                    .take(3)
                    .map((e) => Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _getEventColor(e.eventType),
                          ),
                        ))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

  Color _getEventColor(CalendarEventType type) {
    return switch (type) {
      CalendarEventType.booking => AppColors.primary,
      CalendarEventType.checkin => AppColors.success,
      CalendarEventType.checkout => AppColors.info,
      CalendarEventType.task => AppColors.warning,
      CalendarEventType.maintenance => AppColors.error,
      CalendarEventType.blocked => AppColors.onSurfaceVariant,
    };
  }
}

/// Week view (simplified)
class _WeekView extends StatelessWidget {
  const _WeekView({
    required this.selectedDate,
    required this.events,
    required this.onDateSelected,
  });

  final DateTime selectedDate;
  final List<CalendarEventModel> events;
  final void Function(DateTime) onDateSelected;

  @override
  Widget build(BuildContext context) {
    final weekStart = selectedDate.subtract(
      Duration(days: selectedDate.weekday - 1),
    );

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: 7,
      itemBuilder: (context, index) {
        final date = weekStart.add(Duration(days: index));
        final dayEvents = events.where((e) => e.isOnDate(date)).toList();
        final isToday = _isToday(date);

        return _WeekDayRow(
          date: date,
          events: dayEvents,
          isToday: isToday,
          onTap: () => onDateSelected(date),
        );
      },
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}

class _WeekDayRow extends StatelessWidget {
  const _WeekDayRow({
    required this.date,
    required this.events,
    required this.isToday,
    required this.onTap,
  });

  final DateTime date;
  final List<CalendarEventModel> events;
  final bool isToday;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Card(
      color: isToday ? theme.colorScheme.primaryContainer : null,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              SizedBox(
                width: 50,
                child: Column(
                  children: [
                    Text(
                      weekdays[date.weekday - 1],
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '${date.day}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: events.isEmpty
                    ? Text(
                        'No events',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: events
                            .map((e) => Text(
                                  e.title,
                                  style: theme.textTheme.bodyMedium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ))
                            .toList(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Day view (simplified)
class _DayView extends StatelessWidget {
  const _DayView({
    required this.selectedDate,
    required this.events,
  });

  final DateTime selectedDate;
  final List<CalendarEventModel> events;

  @override
  Widget build(BuildContext context) {
    final dayEvents = events.where((e) => e.isOnDate(selectedDate)).toList();

    if (dayEvents.isEmpty) {
      return const PortalEmptyState(
        icon: Icons.event_available,
        title: 'No events',
        subtitle: 'No events scheduled for this day',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: dayEvents.length,
      itemBuilder: (context, index) {
        final event = dayEvents[index];
        return _EventCard(event: event);
      },
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event});

  final CalendarEventModel event;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getEventColor(event.eventType);

    return Card(
      child: ListTile(
        leading: Container(
          width: 4,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        title: Text(event.title),
        subtitle: Text(event.eventType.displayName),
        trailing: event.propertyName != null
            ? Chip(
                label: Text(
                  event.propertyName!,
                  style: theme.textTheme.labelSmall,
                ),
              )
            : null,
      ),
    );
  }

  Color _getEventColor(CalendarEventType type) {
    return switch (type) {
      CalendarEventType.booking => AppColors.primary,
      CalendarEventType.checkin => AppColors.success,
      CalendarEventType.checkout => AppColors.info,
      CalendarEventType.task => AppColors.warning,
      CalendarEventType.maintenance => AppColors.error,
      CalendarEventType.blocked => AppColors.onSurfaceVariant,
    };
  }
}
