/// Portal providers for Cosmo Management
///
/// Riverpod providers for portal module state management.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/service_providers.dart';
import '../../../data/models/booking_model.dart';
import '../../../data/models/calendar_model.dart';
import '../../../data/models/photo_model.dart';
import '../../../data/models/property_model.dart';
import '../../../data/models/task_model.dart';
import '../../../data/repositories/portal_repository.dart';

// ============================================
// Portal Dashboard Providers
// ============================================

/// Portal dashboard state
sealed class PortalDashboardState {
  const PortalDashboardState();
}

class PortalDashboardInitial extends PortalDashboardState {
  const PortalDashboardInitial();
}

class PortalDashboardLoading extends PortalDashboardState {
  const PortalDashboardLoading();
}

class PortalDashboardLoaded extends PortalDashboardState {
  final PortalDashboardStats stats;
  final List<BookingModel> upcomingBookings;
  final List<TaskModel> recentTasks;

  const PortalDashboardLoaded({
    required this.stats,
    required this.upcomingBookings,
    required this.recentTasks,
  });
}

class PortalDashboardError extends PortalDashboardState {
  final String message;
  const PortalDashboardError(this.message);
}

/// Portal dashboard notifier
class PortalDashboardNotifier extends StateNotifier<PortalDashboardState> {
  final Ref _ref;

  PortalDashboardNotifier({
    required Ref ref,
  })  : _ref = ref,
        super(const PortalDashboardInitial()) {
    load();
  }

  Future<void> load() async {
    state = const PortalDashboardLoading();
    try {
      final portalRepository = _ref.read(portalRepositoryProvider);
      final bookingRepository = _ref.read(bookingRepositoryProvider);

      // Load dashboard stats and upcoming bookings in parallel
      final results = await Future.wait([
        portalRepository.getDashboardStats(),
        bookingRepository.getUpcomingBookings(limit: 5),
      ]);

      final stats = results[0] as PortalDashboardStats;
      final upcomingBookings = results[1] as List<BookingModel>;

      state = PortalDashboardLoaded(
        stats: stats,
        upcomingBookings: upcomingBookings,
        recentTasks: [],
      );
    } catch (e) {
      state = PortalDashboardError(e.toString());
    }
  }

  Future<void> refresh() async {
    await load();
  }
}

/// Portal dashboard provider
final portalDashboardProvider =
    StateNotifierProvider<PortalDashboardNotifier, PortalDashboardState>((ref) {
  return PortalDashboardNotifier(ref: ref);
});

// ============================================
// Property List Providers
// ============================================

/// Property list state
sealed class PropertyListState {
  const PropertyListState();
}

class PropertyListInitial extends PropertyListState {
  const PropertyListInitial();
}

class PropertyListLoading extends PropertyListState {
  const PropertyListLoading();
}

class PropertyListLoaded extends PropertyListState {
  final List<PropertyModel> properties;
  final int totalCount;
  final bool hasMore;
  final String? searchQuery;

  const PropertyListLoaded({
    required this.properties,
    required this.totalCount,
    required this.hasMore,
    this.searchQuery,
  });
}

class PropertyListError extends PropertyListState {
  final String message;
  const PropertyListError(this.message);
}

/// Property list notifier
class PropertyListNotifier extends StateNotifier<PropertyListState> {
  final PortalRepository _portalRepository;
  int _currentPage = 1;
  bool _isLoadingMore = false;
  String? _searchQuery;

  PropertyListNotifier({
    required PortalRepository portalRepository,
  })  : _portalRepository = portalRepository,
        super(const PropertyListInitial()) {
    load();
  }

  Future<void> load() async {
    state = const PropertyListLoading();
    _currentPage = 1;
    try {
      final response = await _portalRepository.getProperties(
        page: _currentPage,
        search: _searchQuery,
      );

      state = PropertyListLoaded(
        properties: response.results,
        totalCount: response.count,
        hasMore: response.hasMore,
        searchQuery: _searchQuery,
      );
    } catch (e) {
      state = PropertyListError(e.toString());
    }
  }

  Future<void> loadMore() async {
    if (_isLoadingMore) return;
    final currentState = state;
    if (currentState is! PropertyListLoaded || !currentState.hasMore) return;

    _isLoadingMore = true;
    _currentPage++;
    try {
      final response = await _portalRepository.getProperties(
        page: _currentPage,
        search: _searchQuery,
      );

      state = PropertyListLoaded(
        properties: [...currentState.properties, ...response.results],
        totalCount: response.count,
        hasMore: response.hasMore,
        searchQuery: _searchQuery,
      );
    } catch (e) {
      _currentPage--;
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> search(String query) async {
    _searchQuery = query.isEmpty ? null : query;
    await load();
  }

  Future<void> refresh() async {
    await load();
  }
}

/// Property list provider
final propertyListProvider =
    StateNotifierProvider<PropertyListNotifier, PropertyListState>((ref) {
  return PropertyListNotifier(
    portalRepository: ref.watch(portalRepositoryProvider),
  );
});

// ============================================
// Booking List Providers
// ============================================

/// Booking list state
sealed class BookingListState {
  const BookingListState();
}

class BookingListInitial extends BookingListState {
  const BookingListInitial();
}

class BookingListLoading extends BookingListState {
  const BookingListLoading();
}

class BookingListLoaded extends BookingListState {
  final List<BookingModel> bookings;
  final int totalCount;
  final bool hasMore;
  final BookingStatus? statusFilter;
  final int? propertyFilter;

  const BookingListLoaded({
    required this.bookings,
    required this.totalCount,
    required this.hasMore,
    this.statusFilter,
    this.propertyFilter,
  });
}

class BookingListError extends BookingListState {
  final String message;
  const BookingListError(this.message);
}

/// Booking list notifier
class BookingListNotifier extends StateNotifier<BookingListState> {
  final Ref _ref;
  int _currentPage = 1;
  bool _isLoadingMore = false;
  BookingStatus? _statusFilter;
  int? _propertyFilter;

  BookingListNotifier({
    required Ref ref,
  })  : _ref = ref,
        super(const BookingListInitial()) {
    load();
  }

  Future<void> load() async {
    state = const BookingListLoading();
    _currentPage = 1;
    try {
      final bookingRepository = _ref.read(bookingRepositoryProvider);
      final response = await bookingRepository.getBookings(
        page: _currentPage,
        status: _statusFilter,
        propertyId: _propertyFilter,
      );

      state = BookingListLoaded(
        bookings: response.results,
        totalCount: response.count,
        hasMore: response.next != null,
        statusFilter: _statusFilter,
        propertyFilter: _propertyFilter,
      );
    } catch (e) {
      state = BookingListError(e.toString());
    }
  }

  Future<void> loadMore() async {
    if (_isLoadingMore) return;
    final currentState = state;
    if (currentState is! BookingListLoaded || !currentState.hasMore) return;

    _isLoadingMore = true;
    _currentPage++;
    try {
      final bookingRepository = _ref.read(bookingRepositoryProvider);
      final response = await bookingRepository.getBookings(
        page: _currentPage,
        status: _statusFilter,
        propertyId: _propertyFilter,
      );

      state = BookingListLoaded(
        bookings: [...currentState.bookings, ...response.results],
        totalCount: response.count,
        hasMore: response.next != null,
        statusFilter: _statusFilter,
        propertyFilter: _propertyFilter,
      );
    } catch (e) {
      _currentPage--;
    } finally {
      _isLoadingMore = false;
    }
  }

  void setStatusFilter(BookingStatus? status) {
    _statusFilter = status;
    load();
  }

  void setPropertyFilter(int? propertyId) {
    _propertyFilter = propertyId;
    load();
  }

  Future<void> refresh() async {
    await load();
  }
}

/// Booking list provider
final bookingListProvider =
    StateNotifierProvider<BookingListNotifier, BookingListState>((ref) {
  return BookingListNotifier(ref: ref);
});

// ============================================
// Calendar Providers
// ============================================

/// Calendar state
sealed class CalendarState {
  const CalendarState();
}

class CalendarInitial extends CalendarState {
  const CalendarInitial();
}

class CalendarLoading extends CalendarState {
  const CalendarLoading();
}

class CalendarLoaded extends CalendarState {
  final List<CalendarEventModel> events;
  final DateTime selectedDate;
  final CalendarViewMode viewMode;
  final int? propertyFilter;

  const CalendarLoaded({
    required this.events,
    required this.selectedDate,
    required this.viewMode,
    this.propertyFilter,
  });

  /// Get events for a specific date
  List<CalendarEventModel> eventsForDate(DateTime date) {
    return events.where((e) => e.isOnDate(date)).toList();
  }
}

class CalendarError extends CalendarState {
  final String message;
  const CalendarError(this.message);
}

/// Calendar notifier
class CalendarNotifier extends StateNotifier<CalendarState> {
  final PortalRepository _portalRepository;
  DateTime _selectedDate = DateTime.now();
  CalendarViewMode _viewMode = CalendarViewMode.month;
  int? _propertyFilter;

  CalendarNotifier({
    required PortalRepository portalRepository,
  })  : _portalRepository = portalRepository,
        super(const CalendarInitial()) {
    load();
  }

  Future<void> load() async {
    state = const CalendarLoading();
    try {
      final range = _getDateRange();
      final events = await _portalRepository.getCalendarEvents(
        startDate: range.start,
        endDate: range.end,
        propertyId: _propertyFilter,
      );

      state = CalendarLoaded(
        events: events,
        selectedDate: _selectedDate,
        viewMode: _viewMode,
        propertyFilter: _propertyFilter,
      );
    } catch (e) {
      state = CalendarError(e.toString());
    }
  }

  CalendarDateRange _getDateRange() {
    return switch (_viewMode) {
      CalendarViewMode.month => CalendarDateRange.forMonth(_selectedDate),
      CalendarViewMode.week => CalendarDateRange.forWeek(_selectedDate),
      CalendarViewMode.day => CalendarDateRange.forDay(_selectedDate),
    };
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    load();
  }

  void setViewMode(CalendarViewMode mode) {
    _viewMode = mode;
    load();
  }

  void setPropertyFilter(int? propertyId) {
    _propertyFilter = propertyId;
    load();
  }

  void goToToday() {
    setSelectedDate(DateTime.now());
  }

  void goToPrevious() {
    final newDate = switch (_viewMode) {
      CalendarViewMode.month =>
        DateTime(_selectedDate.year, _selectedDate.month - 1, 1),
      CalendarViewMode.week => _selectedDate.subtract(const Duration(days: 7)),
      CalendarViewMode.day => _selectedDate.subtract(const Duration(days: 1)),
    };
    setSelectedDate(newDate);
  }

  void goToNext() {
    final newDate = switch (_viewMode) {
      CalendarViewMode.month =>
        DateTime(_selectedDate.year, _selectedDate.month + 1, 1),
      CalendarViewMode.week => _selectedDate.add(const Duration(days: 7)),
      CalendarViewMode.day => _selectedDate.add(const Duration(days: 1)),
    };
    setSelectedDate(newDate);
  }

  Future<void> refresh() async {
    await load();
  }
}

/// Calendar provider
final calendarProvider =
    StateNotifierProvider<CalendarNotifier, CalendarState>((ref) {
  return CalendarNotifier(
    portalRepository: ref.watch(portalRepositoryProvider),
  );
});

// ============================================
// Photo Gallery Providers
// ============================================

/// Photo gallery state
sealed class PhotoGalleryState {
  const PhotoGalleryState();
}

class PhotoGalleryInitial extends PhotoGalleryState {
  const PhotoGalleryInitial();
}

class PhotoGalleryLoading extends PhotoGalleryState {
  const PhotoGalleryLoading();
}

class PhotoGalleryLoaded extends PhotoGalleryState {
  final List<PhotoModel> photos;
  final int totalCount;
  final bool hasMore;

  const PhotoGalleryLoaded({
    required this.photos,
    required this.totalCount,
    required this.hasMore,
  });
}

class PhotoGalleryError extends PhotoGalleryState {
  final String message;
  const PhotoGalleryError(this.message);
}

/// Photo gallery notifier
class PhotoGalleryNotifier extends StateNotifier<PhotoGalleryState> {
  final PortalRepository _portalRepository;
  int _currentPage = 1;
  bool _isLoadingMore = false;

  PhotoGalleryNotifier({
    required PortalRepository portalRepository,
  })  : _portalRepository = portalRepository,
        super(const PhotoGalleryInitial()) {
    load();
  }

  Future<void> load() async {
    state = const PhotoGalleryLoading();
    _currentPage = 1;
    try {
      final response = await _portalRepository.getPhotosPendingApproval(
        page: _currentPage,
      );

      state = PhotoGalleryLoaded(
        photos: response.results,
        totalCount: response.count,
        hasMore: response.hasMore,
      );
    } catch (e) {
      state = PhotoGalleryError(e.toString());
    }
  }

  Future<void> loadMore() async {
    if (_isLoadingMore) return;
    final currentState = state;
    if (currentState is! PhotoGalleryLoaded || !currentState.hasMore) return;

    _isLoadingMore = true;
    _currentPage++;
    try {
      final response = await _portalRepository.getPhotosPendingApproval(
        page: _currentPage,
      );

      state = PhotoGalleryLoaded(
        photos: [...currentState.photos, ...response.results],
        totalCount: response.count,
        hasMore: response.hasMore,
      );
    } catch (e) {
      _currentPage--;
    } finally {
      _isLoadingMore = false;
    }
  }

  /// Returns true if successful, false otherwise
  Future<bool> approvePhoto(int photoId) async {
    try {
      await _portalRepository.approvePhoto(photoId);
      _removePhotoFromList(photoId);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Returns true if successful, false otherwise
  Future<bool> rejectPhoto(int photoId, {String? reason}) async {
    try {
      await _portalRepository.rejectPhoto(photoId, reason: reason);
      _removePhotoFromList(photoId);
      return true;
    } catch (e) {
      return false;
    }
  }

  void _removePhotoFromList(int photoId) {
    final currentState = state;
    if (currentState is! PhotoGalleryLoaded) return;

    state = PhotoGalleryLoaded(
      photos: currentState.photos.where((p) => p.id != photoId).toList(),
      totalCount: currentState.totalCount - 1,
      hasMore: currentState.hasMore,
    );
  }

  Future<void> refresh() async {
    await load();
  }
}

/// Photo gallery provider
final photoGalleryProvider =
    StateNotifierProvider<PhotoGalleryNotifier, PhotoGalleryState>((ref) {
  return PhotoGalleryNotifier(
    portalRepository: ref.watch(portalRepositoryProvider),
  );
});

// ============================================
// Property Detail Provider
// ============================================

/// Property detail provider (family by property ID)
final propertyDetailProvider =
    FutureProvider.family<PropertyModel, int>((ref, propertyId) async {
  final portalRepository = ref.watch(portalRepositoryProvider);
  return portalRepository.getPropertyById(propertyId);
});

// ============================================
// Booking Detail Provider
// ============================================

/// Booking detail provider (family by booking ID)
final bookingDetailProvider =
    FutureProvider.family<BookingModel, int>((ref, bookingId) async {
  final bookingRepository = ref.watch(bookingRepositoryProvider);
  return bookingRepository.getBookingById(bookingId);
});
