// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_list_notifier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InventoryFilterImpl _$$InventoryFilterImplFromJson(
        Map<String, dynamic> json) =>
    _$InventoryFilterImpl(
      category:
          $enumDecodeNullable(_$InventoryCategoryEnumMap, json['category']),
      propertyId: (json['propertyId'] as num?)?.toInt(),
      propertyName: json['propertyName'] as String?,
      search: json['search'] as String?,
      lowStockOnly: json['lowStockOnly'] as bool? ?? false,
      sortBy: json['sortBy'] as String? ?? 'name',
      ascending: json['ascending'] as bool? ?? true,
    );

Map<String, dynamic> _$$InventoryFilterImplToJson(
        _$InventoryFilterImpl instance) =>
    <String, dynamic>{
      'category': _$InventoryCategoryEnumMap[instance.category],
      'propertyId': instance.propertyId,
      'propertyName': instance.propertyName,
      'search': instance.search,
      'lowStockOnly': instance.lowStockOnly,
      'sortBy': instance.sortBy,
      'ascending': instance.ascending,
    };

const _$InventoryCategoryEnumMap = {
  InventoryCategory.cleaningSupplies: 'cleaning_supplies',
  InventoryCategory.maintenance: 'maintenance',
  InventoryCategory.linens: 'linens',
  InventoryCategory.toiletries: 'toiletries',
  InventoryCategory.kitchen: 'kitchen',
  InventoryCategory.outdoor: 'outdoor',
  InventoryCategory.electronics: 'electronics',
  InventoryCategory.furniture: 'furniture',
  InventoryCategory.other: 'other',
};
