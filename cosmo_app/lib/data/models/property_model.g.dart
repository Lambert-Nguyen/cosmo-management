// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PropertyModelImpl _$$PropertyModelImplFromJson(Map<String, dynamic> json) =>
    _$PropertyModelImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      propertyType: json['property_type'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      zipCode: json['zip_code'] as String?,
      country: json['country'] as String?,
      unitNumber: json['unit_number'] as String?,
      floorNumber: (json['floor_number'] as num?)?.toInt(),
      squareFeet: (json['square_feet'] as num?)?.toDouble(),
      bedrooms: (json['bedrooms'] as num?)?.toInt(),
      bathrooms: (json['bathrooms'] as num?)?.toInt(),
      maxOccupancy: (json['max_occupancy'] as num?)?.toInt(),
      status: $enumDecodeNullable(_$PropertyStatusEnumMap, json['status']) ??
          PropertyStatus.available,
      isActive: json['is_active'] as bool? ?? true,
      primaryImage: json['primary_image'] as String?,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      managerId: (json['manager_id'] as num?)?.toInt(),
      managerName: json['manager_name'] as String?,
    );

Map<String, dynamic> _$$PropertyModelImplToJson(_$PropertyModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'property_type': instance.propertyType,
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
      'zip_code': instance.zipCode,
      'country': instance.country,
      'unit_number': instance.unitNumber,
      'floor_number': instance.floorNumber,
      'square_feet': instance.squareFeet,
      'bedrooms': instance.bedrooms,
      'bathrooms': instance.bathrooms,
      'max_occupancy': instance.maxOccupancy,
      'status': _$PropertyStatusEnumMap[instance.status]!,
      'is_active': instance.isActive,
      'primary_image': instance.primaryImage,
      'images': instance.images,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'manager_id': instance.managerId,
      'manager_name': instance.managerName,
    };

const _$PropertyStatusEnumMap = {
  PropertyStatus.available: 'available',
  PropertyStatus.occupied: 'occupied',
  PropertyStatus.maintenance: 'maintenance',
  PropertyStatus.reserved: 'reserved',
  PropertyStatus.inactive: 'inactive',
};
