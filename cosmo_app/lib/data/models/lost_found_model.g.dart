// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lost_found_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LostFoundModelImpl _$$LostFoundModelImplFromJson(Map<String, dynamic> json) =>
    _$LostFoundModelImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String?,
      status: $enumDecodeNullable(_$LostFoundStatusEnumMap, json['status']) ??
          LostFoundStatus.found,
      category:
          $enumDecodeNullable(_$LostFoundCategoryEnumMap, json['category']) ??
              LostFoundCategory.other,
      locationFound: json['location_found'] as String?,
      locationDescription: json['location_description'] as String?,
      propertyId: (json['property_id'] as num?)?.toInt(),
      propertyName: json['property_name'] as String?,
      dateFound: json['date_found'] == null
          ? null
          : DateTime.parse(json['date_found'] as String),
      dateLost: json['date_lost'] == null
          ? null
          : DateTime.parse(json['date_lost'] as String),
      reportedById: (json['reported_by'] as num?)?.toInt(),
      reportedByName: json['reported_by_name'] as String?,
      claimedById: (json['claimed_by'] as num?)?.toInt(),
      claimedByName: json['claimed_by_name'] as String?,
      claimedAt: json['claimed_at'] == null
          ? null
          : DateTime.parse(json['claimed_at'] as String),
      claimantContact: json['claimant_contact'] as String?,
      storageLocation: json['storage_location'] as String?,
      isValuable: json['is_valuable'] as bool? ?? false,
      estimatedValue: (json['estimated_value'] as num?)?.toDouble(),
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      notes: json['notes'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
    );

Map<String, dynamic> _$$LostFoundModelImplToJson(
        _$LostFoundModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'status': _$LostFoundStatusEnumMap[instance.status]!,
      'category': _$LostFoundCategoryEnumMap[instance.category]!,
      'location_found': instance.locationFound,
      'location_description': instance.locationDescription,
      'property_id': instance.propertyId,
      'property_name': instance.propertyName,
      'date_found': instance.dateFound?.toIso8601String(),
      'date_lost': instance.dateLost?.toIso8601String(),
      'reported_by': instance.reportedById,
      'reported_by_name': instance.reportedByName,
      'claimed_by': instance.claimedById,
      'claimed_by_name': instance.claimedByName,
      'claimed_at': instance.claimedAt?.toIso8601String(),
      'claimant_contact': instance.claimantContact,
      'storage_location': instance.storageLocation,
      'is_valuable': instance.isValuable,
      'estimated_value': instance.estimatedValue,
      'images': instance.images,
      'notes': instance.notes,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'expires_at': instance.expiresAt?.toIso8601String(),
    };

const _$LostFoundStatusEnumMap = {
  LostFoundStatus.lost: 'lost',
  LostFoundStatus.found: 'found',
  LostFoundStatus.claimed: 'claimed',
  LostFoundStatus.archived: 'archived',
  LostFoundStatus.expired: 'expired',
};

const _$LostFoundCategoryEnumMap = {
  LostFoundCategory.keys: 'keys',
  LostFoundCategory.documents: 'documents',
  LostFoundCategory.electronics: 'electronics',
  LostFoundCategory.clothing: 'clothing',
  LostFoundCategory.jewelry: 'jewelry',
  LostFoundCategory.bags: 'bags',
  LostFoundCategory.personal: 'personal',
  LostFoundCategory.valuables: 'valuables',
  LostFoundCategory.other: 'other',
};

_$LostFoundClaimModelImpl _$$LostFoundClaimModelImplFromJson(
        Map<String, dynamic> json) =>
    _$LostFoundClaimModelImpl(
      id: (json['id'] as num).toInt(),
      lostFoundId: (json['lost_found_id'] as num).toInt(),
      claimedById: (json['claimed_by'] as num).toInt(),
      claimedByName: json['claimed_by_name'] as String?,
      claimantContact: json['claimant_contact'] as String?,
      identificationProvided: json['identification_provided'] as String?,
      verificationNotes: json['verification_notes'] as String?,
      isVerified: json['is_verified'] as bool? ?? false,
      claimedAt: json['claimed_at'] == null
          ? null
          : DateTime.parse(json['claimed_at'] as String),
      processedById: (json['processed_by'] as num?)?.toInt(),
      processedByName: json['processed_by_name'] as String?,
    );

Map<String, dynamic> _$$LostFoundClaimModelImplToJson(
        _$LostFoundClaimModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'lost_found_id': instance.lostFoundId,
      'claimed_by': instance.claimedById,
      'claimed_by_name': instance.claimedByName,
      'claimant_contact': instance.claimantContact,
      'identification_provided': instance.identificationProvided,
      'verification_notes': instance.verificationNotes,
      'is_verified': instance.isVerified,
      'claimed_at': instance.claimedAt?.toIso8601String(),
      'processed_by': instance.processedById,
      'processed_by_name': instance.processedByName,
    };

_$LostFoundStatsModelImpl _$$LostFoundStatsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$LostFoundStatsModelImpl(
      totalLost: (json['total_lost'] as num?)?.toInt() ?? 0,
      totalFound: (json['total_found'] as num?)?.toInt() ?? 0,
      totalClaimed: (json['total_claimed'] as num?)?.toInt() ?? 0,
      pendingClaims: (json['pending_claims'] as num?)?.toInt() ?? 0,
      expiringSoon: (json['expiring_soon'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$LostFoundStatsModelImplToJson(
        _$LostFoundStatsModelImpl instance) =>
    <String, dynamic>{
      'total_lost': instance.totalLost,
      'total_found': instance.totalFound,
      'total_claimed': instance.totalClaimed,
      'pending_claims': instance.pendingClaims,
      'expiring_soon': instance.expiringSoon,
    };
