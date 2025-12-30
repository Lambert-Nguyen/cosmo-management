/// Property model for Cosmo Management
///
/// Freezed model for property data with JSON serialization.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'property_model.freezed.dart';
part 'property_model.g.dart';

/// Property model
///
/// Represents a property/unit in the system.
@freezed
class PropertyModel with _$PropertyModel {
  const factory PropertyModel({
    required int id,
    required String name,
    String? description,
    @JsonKey(name: 'property_type') String? propertyType,
    String? address,
    String? city,
    String? state,
    @JsonKey(name: 'zip_code') String? zipCode,
    String? country,
    @JsonKey(name: 'unit_number') String? unitNumber,
    @JsonKey(name: 'floor_number') int? floorNumber,
    @JsonKey(name: 'square_feet') double? squareFeet,
    int? bedrooms,
    int? bathrooms,
    @JsonKey(name: 'max_occupancy') int? maxOccupancy,
    @Default(PropertyStatus.available) PropertyStatus status,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'primary_image') String? primaryImage,
    @Default([]) List<String> images,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'manager_id') int? managerId,
    @JsonKey(name: 'manager_name') String? managerName,
  }) = _PropertyModel;

  const PropertyModel._();

  factory PropertyModel.fromJson(Map<String, dynamic> json) =>
      _$PropertyModelFromJson(json);

  /// Full address string
  String get fullAddress {
    final parts = <String>[];
    if (address != null) parts.add(address!);
    if (unitNumber != null) parts.add('Unit $unitNumber');
    if (city != null) parts.add(city!);
    if (state != null && zipCode != null) {
      parts.add('$state $zipCode');
    } else if (state != null) {
      parts.add(state!);
    } else if (zipCode != null) {
      parts.add(zipCode!);
    }
    return parts.join(', ');
  }

  /// Short address (street only)
  String get shortAddress {
    if (address != null && unitNumber != null) {
      return '$address, Unit $unitNumber';
    }
    return address ?? name;
  }

  /// Bedroom/bathroom summary
  String get bedBathSummary {
    final parts = <String>[];
    if (bedrooms != null) parts.add('$bedrooms bed');
    if (bathrooms != null) parts.add('$bathrooms bath');
    return parts.join(' / ');
  }

  /// Check if property is available
  bool get isAvailable => status == PropertyStatus.available;

  /// Check if property is occupied
  bool get isOccupied => status == PropertyStatus.occupied;
}

/// Property status enum
@JsonEnum(valueField: 'value')
enum PropertyStatus {
  @JsonValue('available')
  available('available', 'Available'),
  @JsonValue('occupied')
  occupied('occupied', 'Occupied'),
  @JsonValue('maintenance')
  maintenance('maintenance', 'Under Maintenance'),
  @JsonValue('reserved')
  reserved('reserved', 'Reserved'),
  @JsonValue('inactive')
  inactive('inactive', 'Inactive');

  final String value;
  final String displayName;

  const PropertyStatus(this.value, this.displayName);
}
