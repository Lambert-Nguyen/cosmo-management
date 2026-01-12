/// Portal repository for Cosmo Management
///
/// Handles portal-specific data operations including dashboard, calendar, and photos.
library;

import '../../core/config/api_config.dart';
import '../models/calendar_model.dart';
import '../models/photo_model.dart';
import '../models/property_model.dart';
import 'base_repository.dart';

/// Portal repository
///
/// Handles operations for the property owner portal.
class PortalRepository extends BaseRepository {
  PortalRepository({
    required super.apiService,
    required super.storageService,
  });

  // ============================================
  // Dashboard
  // ============================================

  /// Get portal dashboard stats
  Future<PortalDashboardStats> getDashboardStats() async {
    final response = await apiService.get(ApiConfig.portalDashboard);
    return PortalDashboardStats.fromJson(response);
  }

  // ============================================
  // Properties
  // ============================================

  /// Get owner's properties
  Future<PaginatedProperties> getProperties({
    int page = 1,
    int pageSize = 20,
    String? search,
    PropertyStatus? status,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
    };
    if (search != null) queryParams['search'] = search;
    if (status != null) queryParams['status'] = status.value;

    final response = await apiService.get(
      ApiConfig.portalProperties,
      queryParameters: queryParams,
    );

    return PaginatedProperties.fromJson(response);
  }

  /// Get property detail
  Future<PropertyModel> getPropertyById(int id) async {
    return getCachedOrFetch<PropertyModel>(
      cacheKey: _propertyCacheKey(id),
      fetchFunction: () async {
        final response = await apiService.get(ApiConfig.portalPropertyDetail(id));
        return PropertyModel.fromJson(response);
      },
      fromJson: (json) => PropertyModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Search properties
  Future<List<PropertyModel>> searchProperties(String query) async {
    final response = await apiService.get(
      ApiConfig.portalPropertySearch,
      queryParameters: {'q': query},
    );

    final List<dynamic> results = response['results'] ?? response;
    return results
        .map((e) => PropertyModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ============================================
  // Calendar
  // ============================================

  /// Get calendar events for date range
  Future<List<CalendarEventModel>> getCalendarEvents({
    required DateTime startDate,
    required DateTime endDate,
    int? propertyId,
  }) async {
    final queryParams = <String, dynamic>{
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
    };
    if (propertyId != null) queryParams['property_id'] = propertyId;

    final endpoint = propertyId != null
        ? ApiConfig.calendarEventsByProperty(propertyId)
        : ApiConfig.calendarEvents;

    final response = await apiService.get(
      endpoint,
      queryParameters: queryParams,
    );

    final List<dynamic> results = response['results'] ?? response;
    return results
        .map((e) => CalendarEventModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ============================================
  // Photos
  // ============================================

  /// Get photos pending approval
  Future<PaginatedPhotos> getPhotosPendingApproval({
    int page = 1,
    int pageSize = 20,
    int? propertyId,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
      'status': 'pending',
    };
    if (propertyId != null) queryParams['property_id'] = propertyId;

    final response = await apiService.get(
      ApiConfig.portalPhotos,
      queryParameters: queryParams,
    );

    return PaginatedPhotos.fromJson(response);
  }

  /// Approve a photo
  Future<void> approvePhoto(int photoId) async {
    await apiService.post(ApiConfig.portalPhotoApprove(photoId));
  }

  /// Reject a photo
  Future<void> rejectPhoto(int photoId, {String? reason}) async {
    await apiService.post(
      ApiConfig.portalPhotoReject(photoId),
      data: reason != null ? {'reason': reason} : null,
    );
  }

  String _propertyCacheKey(int id) => 'portal_property_$id';
}

/// Paginated properties response (for portal-specific use)
class PaginatedProperties {
  final int count;
  final String? next;
  final String? previous;
  final List<PropertyModel> results;

  PaginatedProperties({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory PaginatedProperties.fromJson(Map<String, dynamic> json) {
    return PaginatedProperties(
      count: json['count'] as int? ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => PropertyModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  bool get hasMore => next != null;
}

/// Paginated photos response
class PaginatedPhotos {
  final int count;
  final String? next;
  final String? previous;
  final List<PhotoModel> results;

  PaginatedPhotos({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory PaginatedPhotos.fromJson(Map<String, dynamic> json) {
    return PaginatedPhotos(
      count: json['count'] as int? ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => PhotoModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  bool get hasMore => next != null;
}
