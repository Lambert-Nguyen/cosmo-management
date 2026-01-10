/// Booking repository for Cosmo Management
///
/// Handles booking-related data operations.
library;

import '../../core/config/api_config.dart';
import '../models/booking_model.dart';
import 'base_repository.dart';

/// Booking repository
///
/// Handles CRUD operations for bookings/reservations.
class BookingRepository extends BaseRepository {
  BookingRepository({
    required super.apiService,
    required super.storageService,
  });

  /// Get paginated list of bookings
  Future<PaginatedBookings> getBookings({
    int page = 1,
    int pageSize = 20,
    int? propertyId,
    BookingStatus? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
    };
    if (propertyId != null) queryParams['property_id'] = propertyId;
    if (status != null) queryParams['status'] = status.value;
    if (startDate != null) queryParams['start_date'] = startDate.toIso8601String();
    if (endDate != null) queryParams['end_date'] = endDate.toIso8601String();

    final response = await apiService.get(
      ApiConfig.bookings,
      queryParameters: queryParams,
    );

    return PaginatedBookings.fromJson(response);
  }

  /// Get booking by ID
  Future<BookingModel> getBookingById(int id) async {
    return getCachedOrFetch<BookingModel>(
      cacheKey: _bookingCacheKey(id),
      fetchFunction: () async {
        final response = await apiService.get(ApiConfig.bookingDetail(id));
        return BookingModel.fromJson(response);
      },
      fromJson: (json) => BookingModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Get bookings by property
  Future<List<BookingModel>> getBookingsByProperty(int propertyId) async {
    final response = await apiService.get(
      ApiConfig.bookingsByProperty(propertyId),
    );

    final List<dynamic> results = response['results'] ?? response;
    return results
        .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Get upcoming bookings
  Future<List<BookingModel>> getUpcomingBookings({int limit = 10}) async {
    final response = await apiService.get(
      ApiConfig.bookingsUpcoming,
      queryParameters: {'limit': limit},
    );

    final List<dynamic> results = response['results'] ?? response;
    return results
        .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Get today's check-ins
  Future<List<BookingModel>> getCheckInsToday() async {
    final response = await apiService.get(ApiConfig.bookingsCheckInsToday);

    final List<dynamic> results = response['results'] ?? response;
    return results
        .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Get today's check-outs
  Future<List<BookingModel>> getCheckOutsToday() async {
    final response = await apiService.get(ApiConfig.bookingsCheckOutsToday);

    final List<dynamic> results = response['results'] ?? response;
    return results
        .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Invalidate booking cache
  Future<void> invalidateBookingCache(int id) async {
    await invalidateCache(_bookingCacheKey(id));
  }

  String _bookingCacheKey(int id) => 'booking_$id';
}
