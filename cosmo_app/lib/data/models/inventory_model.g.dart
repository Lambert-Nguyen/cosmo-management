// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InventoryModelImpl _$$InventoryModelImplFromJson(Map<String, dynamic> json) =>
    _$InventoryModelImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      category:
          $enumDecodeNullable(_$InventoryCategoryEnumMap, json['category']) ??
              InventoryCategory.other,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      unitType: json['unit_type'] as String?,
      parLevel: (json['par_level'] as num?)?.toInt(),
      reorderPoint: (json['reorder_point'] as num?)?.toInt(),
      propertyId: (json['property_id'] as num?)?.toInt(),
      propertyName: json['property_name'] as String?,
      location: json['location'] as String?,
      sku: json['sku'] as String?,
      barcode: json['barcode'] as String?,
      unitCost: (json['unit_cost'] as num?)?.toDouble(),
      isActive: json['is_active'] as bool? ?? true,
      lastCountedAt: json['last_counted_at'] == null
          ? null
          : DateTime.parse(json['last_counted_at'] as String),
      lastCountedById: (json['last_counted_by'] as num?)?.toInt(),
      lastCountedByName: json['last_counted_by_name'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$InventoryModelImplToJson(
        _$InventoryModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'category': _$InventoryCategoryEnumMap[instance.category]!,
      'quantity': instance.quantity,
      'unit_type': instance.unitType,
      'par_level': instance.parLevel,
      'reorder_point': instance.reorderPoint,
      'property_id': instance.propertyId,
      'property_name': instance.propertyName,
      'location': instance.location,
      'sku': instance.sku,
      'barcode': instance.barcode,
      'unit_cost': instance.unitCost,
      'is_active': instance.isActive,
      'last_counted_at': instance.lastCountedAt?.toIso8601String(),
      'last_counted_by': instance.lastCountedById,
      'last_counted_by_name': instance.lastCountedByName,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'images': instance.images,
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

_$InventoryTransactionModelImpl _$$InventoryTransactionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$InventoryTransactionModelImpl(
      id: (json['id'] as num).toInt(),
      inventoryId: (json['inventory_id'] as num).toInt(),
      inventoryName: json['inventory_name'] as String?,
      type: $enumDecode(_$InventoryTransactionTypeEnumMap, json['type']),
      quantity: (json['quantity'] as num).toInt(),
      quantityBefore: (json['quantity_before'] as num?)?.toInt(),
      quantityAfter: (json['quantity_after'] as num?)?.toInt(),
      notes: json['notes'] as String?,
      propertyId: (json['property_id'] as num?)?.toInt(),
      propertyName: json['property_name'] as String?,
      taskId: (json['task_id'] as num?)?.toInt(),
      createdById: (json['created_by'] as num?)?.toInt(),
      createdByName: json['created_by_name'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$InventoryTransactionModelImplToJson(
        _$InventoryTransactionModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'inventory_id': instance.inventoryId,
      'inventory_name': instance.inventoryName,
      'type': _$InventoryTransactionTypeEnumMap[instance.type]!,
      'quantity': instance.quantity,
      'quantity_before': instance.quantityBefore,
      'quantity_after': instance.quantityAfter,
      'notes': instance.notes,
      'property_id': instance.propertyId,
      'property_name': instance.propertyName,
      'task_id': instance.taskId,
      'created_by': instance.createdById,
      'created_by_name': instance.createdByName,
      'created_at': instance.createdAt?.toIso8601String(),
    };

const _$InventoryTransactionTypeEnumMap = {
  InventoryTransactionType.stockIn: 'stock_in',
  InventoryTransactionType.stockOut: 'stock_out',
  InventoryTransactionType.adjustment: 'adjustment',
  InventoryTransactionType.damage: 'damage',
  InventoryTransactionType.transfer: 'transfer',
  InventoryTransactionType.shortage: 'shortage',
};

_$LowStockAlertModelImpl _$$LowStockAlertModelImplFromJson(
        Map<String, dynamic> json) =>
    _$LowStockAlertModelImpl(
      id: (json['id'] as num).toInt(),
      inventoryId: (json['inventory_id'] as num).toInt(),
      inventoryName: json['inventory_name'] as String,
      category: $enumDecode(_$InventoryCategoryEnumMap, json['category']),
      currentQuantity: (json['current_quantity'] as num).toInt(),
      parLevel: (json['par_level'] as num?)?.toInt(),
      reorderPoint: (json['reorder_point'] as num?)?.toInt(),
      propertyId: (json['property_id'] as num?)?.toInt(),
      propertyName: json['property_name'] as String?,
      shortageAmount: (json['shortage_amount'] as num?)?.toInt(),
      isCritical: json['is_critical'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$LowStockAlertModelImplToJson(
        _$LowStockAlertModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'inventory_id': instance.inventoryId,
      'inventory_name': instance.inventoryName,
      'category': _$InventoryCategoryEnumMap[instance.category]!,
      'current_quantity': instance.currentQuantity,
      'par_level': instance.parLevel,
      'reorder_point': instance.reorderPoint,
      'property_id': instance.propertyId,
      'property_name': instance.propertyName,
      'shortage_amount': instance.shortageAmount,
      'is_critical': instance.isCritical,
      'created_at': instance.createdAt?.toIso8601String(),
    };
