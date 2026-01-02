/// Property repository for Cosmo Management
///
/// Handles property-related data operations.
library;

import '../../core/config/api_config.dart';
import '../models/property_model.dart';
import 'base_repository.dart';

/// Property repository
///
/// Handles CRUD operations for properties/units.
class PropertyRepository extends BaseRepository {
  PropertyRepository({
    required super.apiService,
    required super.storageService,
  });

  /// Get paginated list of properties
  Future<PaginatedProperties> getProperties({
    int page = 1,
    int pageSize = 20,
    String? search,
    PropertyStatus? status,
    String? propertyType,
    int? managerId,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
    };
    if (search != null) queryParams['search'] = search;
    if (status != null) queryParams['status'] = status.value;
    if (propertyType != null) queryParams['property_type'] = propertyType;
    if (managerId != null) queryParams['manager_id'] = managerId;

    final response = await apiService.get(
      ApiConfig.properties,
      queryParameters: queryParams,
    );

    return PaginatedProperties.fromJson(response);
  }

  /// Get property by ID
  Future<PropertyModel> getPropertyById(int id) async {
    return getCachedOrFetch<PropertyModel>(
      cacheKey: _propertyCacheKey(id),
      fetchFunction: () async {
        final response = await apiService.get(ApiConfig.propertyDetail(id));
        return PropertyModel.fromJson(response);
      },
      fromJson: (json) => PropertyModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Create new property
  Future<PropertyModel> createProperty({
    required String name,
    String? description,
    String? propertyType,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    String? unitNumber,
    int? floorNumber,
    double? squareFeet,
    int? bedrooms,
    int? bathrooms,
    int? maxOccupancy,
    int? managerId,
  }) async {
    final response = await apiService.post(
      ApiConfig.properties,
      data: {
        'name': name,
        if (description != null) 'description': description,
        if (propertyType != null) 'property_type': propertyType,
        if (address != null) 'address': address,
        if (city != null) 'city': city,
        if (state != null) 'state': state,
        if (zipCode != null) 'zip_code': zipCode,
        if (country != null) 'country': country,
        if (unitNumber != null) 'unit_number': unitNumber,
        if (floorNumber != null) 'floor_number': floorNumber,
        if (squareFeet != null) 'square_feet': squareFeet,
        if (bedrooms != null) 'bedrooms': bedrooms,
        if (bathrooms != null) 'bathrooms': bathrooms,
        if (maxOccupancy != null) 'max_occupancy': maxOccupancy,
        if (managerId != null) 'manager_id': managerId,
      },
    );
    return PropertyModel.fromJson(response);
  }

  /// Update property
  Future<PropertyModel> updateProperty(
    int id, {
    String? name,
    String? description,
    String? propertyType,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    String? unitNumber,
    int? floorNumber,
    double? squareFeet,
    int? bedrooms,
    int? bathrooms,
    int? maxOccupancy,
    PropertyStatus? status,
    bool? isActive,
    int? managerId,
  }) async {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (description != null) data['description'] = description;
    if (propertyType != null) data['property_type'] = propertyType;
    if (address != null) data['address'] = address;
    if (city != null) data['city'] = city;
    if (state != null) data['state'] = state;
    if (zipCode != null) data['zip_code'] = zipCode;
    if (country != null) data['country'] = country;
    if (unitNumber != null) data['unit_number'] = unitNumber;
    if (floorNumber != null) data['floor_number'] = floorNumber;
    if (squareFeet != null) data['square_feet'] = squareFeet;
    if (bedrooms != null) data['bedrooms'] = bedrooms;
    if (bathrooms != null) data['bathrooms'] = bathrooms;
    if (maxOccupancy != null) data['max_occupancy'] = maxOccupancy;
    if (status != null) data['status'] = status.value;
    if (isActive != null) data['is_active'] = isActive;
    if (managerId != null) data['manager_id'] = managerId;

    final response = await apiService.patch(
      ApiConfig.propertyDetail(id),
      data: data,
    );
    await invalidateCache(_propertyCacheKey(id));
    return PropertyModel.fromJson(response);
  }

  /// Delete property (soft delete)
  Future<void> deleteProperty(int id) async {
    await apiService.delete(ApiConfig.propertyDetail(id));
    await invalidateCache(_propertyCacheKey(id));
  }

  /// Get available properties
  Future<List<PropertyModel>> getAvailableProperties() async {
    final response = await getProperties(
      status: PropertyStatus.available,
      pageSize: 100,
    );
    return response.results;
  }

  /// Update property status
  Future<PropertyModel> updatePropertyStatus(int id, PropertyStatus status) async {
    return updateProperty(id, status: status);
  }

  String _propertyCacheKey(int id) => 'property_$id';
}

/// Paginated properties response
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
