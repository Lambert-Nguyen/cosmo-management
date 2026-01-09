/// Lost & Found repository for Cosmo Management
///
/// Handles lost and found item data operations with caching support.
library;

import '../../core/config/api_config.dart';
import '../models/lost_found_model.dart';
import 'base_repository.dart';

/// Repository for lost & found operations
class LostFoundRepository extends BaseRepository {
  LostFoundRepository({
    required super.apiService,
    required super.storageService,
  });

  // Cache keys
  static const String _listCacheKey = 'lost_found_list';
  static const String _statsCacheKey = 'lost_found_stats';
  String _itemCacheKey(int id) => 'lost_found_$id';

  // ============================================
  // Lost & Found Items
  // ============================================

  /// Get paginated lost & found items with optional filters
  Future<PaginatedLostFound> getLostFoundItems({
    int page = 1,
    int pageSize = 20,
    String? search,
    LostFoundStatus? status,
    LostFoundCategory? category,
    int? propertyId,
    bool? expiringSoon,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
    };
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }
    if (status != null) {
      queryParams['status'] = status.value;
    }
    if (category != null) {
      queryParams['category'] = category.value;
    }
    if (propertyId != null) {
      queryParams['property_id'] = propertyId;
    }
    if (expiringSoon == true) {
      queryParams['expiring_soon'] = true;
    }

    final response = await apiService.get(
      ApiConfig.staffLostFound,
      queryParameters: queryParams,
    );

    return PaginatedLostFound.fromJson(response);
  }

  /// Get lost & found item by ID
  Future<LostFoundModel> getLostFoundById(int id) async {
    return getCachedOrFetch<LostFoundModel>(
      cacheKey: _itemCacheKey(id),
      fetchFunction: () async {
        final response = await apiService.get(ApiConfig.staffLostFoundDetail(id));
        return LostFoundModel.fromJson(response);
      },
      fromJson: (json) => LostFoundModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Report a new lost or found item
  Future<LostFoundModel> createLostFoundItem({
    required String title,
    required LostFoundStatus status,
    String? description,
    LostFoundCategory? category,
    String? locationFound,
    String? locationDescription,
    int? propertyId,
    DateTime? dateFound,
    DateTime? dateLost,
    String? storageLocation,
    bool isValuable = false,
    double? estimatedValue,
    List<String>? images,
    String? notes,
  }) async {
    final data = <String, dynamic>{
      'title': title,
      'status': status.value,
    };
    if (description != null) data['description'] = description;
    if (category != null) data['category'] = category.value;
    if (locationFound != null) data['location_found'] = locationFound;
    if (locationDescription != null) {
      data['location_description'] = locationDescription;
    }
    if (propertyId != null) data['property_id'] = propertyId;
    if (dateFound != null) data['date_found'] = dateFound.toIso8601String();
    if (dateLost != null) data['date_lost'] = dateLost.toIso8601String();
    if (storageLocation != null) data['storage_location'] = storageLocation;
    data['is_valuable'] = isValuable;
    if (estimatedValue != null) data['estimated_value'] = estimatedValue;
    if (images != null && images.isNotEmpty) data['images'] = images;
    if (notes != null) data['notes'] = notes;

    final response = await apiService.post(
      ApiConfig.staffLostFound,
      data: data,
    );

    // Invalidate list cache
    await invalidateCache(_listCacheKey);
    await invalidateCache(_statsCacheKey);

    return LostFoundModel.fromJson(response);
  }

  /// Update lost & found item
  Future<LostFoundModel> updateLostFoundItem(
    int id, {
    String? title,
    String? description,
    LostFoundStatus? status,
    LostFoundCategory? category,
    String? locationFound,
    String? locationDescription,
    int? propertyId,
    DateTime? dateFound,
    DateTime? dateLost,
    String? storageLocation,
    bool? isValuable,
    double? estimatedValue,
    List<String>? images,
    String? notes,
  }) async {
    final data = <String, dynamic>{};
    if (title != null) data['title'] = title;
    if (description != null) data['description'] = description;
    if (status != null) data['status'] = status.value;
    if (category != null) data['category'] = category.value;
    if (locationFound != null) data['location_found'] = locationFound;
    if (locationDescription != null) {
      data['location_description'] = locationDescription;
    }
    if (propertyId != null) data['property_id'] = propertyId;
    if (dateFound != null) data['date_found'] = dateFound.toIso8601String();
    if (dateLost != null) data['date_lost'] = dateLost.toIso8601String();
    if (storageLocation != null) data['storage_location'] = storageLocation;
    if (isValuable != null) data['is_valuable'] = isValuable;
    if (estimatedValue != null) data['estimated_value'] = estimatedValue;
    if (images != null) data['images'] = images;
    if (notes != null) data['notes'] = notes;

    final response = await apiService.patch(
      ApiConfig.staffLostFoundDetail(id),
      data: data,
    );

    await invalidateCache(_itemCacheKey(id));
    await invalidateCache(_listCacheKey);
    await invalidateCache(_statsCacheKey);

    return LostFoundModel.fromJson(response);
  }

  /// Delete lost & found item
  Future<void> deleteLostFoundItem(int id) async {
    await apiService.delete(ApiConfig.staffLostFoundDetail(id));
    await invalidateCache(_itemCacheKey(id));
    await invalidateCache(_listCacheKey);
    await invalidateCache(_statsCacheKey);
  }

  // ============================================
  // Item Actions
  // ============================================

  /// Claim a found item
  Future<LostFoundModel> claimItem(
    int id, {
    required String claimantContact,
    String? identificationProvided,
    String? verificationNotes,
  }) async {
    final data = <String, dynamic>{
      'claimant_contact': claimantContact,
    };
    if (identificationProvided != null) {
      data['identification_provided'] = identificationProvided;
    }
    if (verificationNotes != null) {
      data['verification_notes'] = verificationNotes;
    }

    final response = await apiService.post(
      ApiConfig.staffLostFoundClaim(id),
      data: data,
    );

    await invalidateCache(_itemCacheKey(id));
    await invalidateCache(_listCacheKey);
    await invalidateCache(_statsCacheKey);

    return LostFoundModel.fromJson(response);
  }

  /// Archive a lost & found item
  Future<LostFoundModel> archiveItem(int id, {String? reason}) async {
    final data = <String, dynamic>{};
    if (reason != null) data['reason'] = reason;

    final response = await apiService.post(
      ApiConfig.staffLostFoundArchive(id),
      data: data,
    );

    await invalidateCache(_itemCacheKey(id));
    await invalidateCache(_listCacheKey);
    await invalidateCache(_statsCacheKey);

    return LostFoundModel.fromJson(response);
  }

  // ============================================
  // Statistics
  // ============================================

  /// Get lost & found statistics
  Future<LostFoundStatsModel> getStats() async {
    final response = await apiService.get(ApiConfig.staffLostFoundStats);
    return LostFoundStatsModel.fromJson(response);
  }

  /// Get counts by status for dashboard
  Future<Map<LostFoundStatus, int>> getCountsByStatus() async {
    final stats = await getStats();
    return {
      LostFoundStatus.lost: stats.totalLost,
      LostFoundStatus.found: stats.totalFound,
      LostFoundStatus.claimed: stats.totalClaimed,
    };
  }

  // ============================================
  // Cache Management
  // ============================================

  /// Clear all lost & found caches
  Future<void> clearAllCaches() async {
    await invalidateCache(_listCacheKey);
    await invalidateCache(_statsCacheKey);
  }
}
