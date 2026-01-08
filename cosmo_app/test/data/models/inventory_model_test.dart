/// Tests for inventory model
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:cosmo_app/data/models/inventory_model.dart';

void main() {
  group('InventoryModel', () {
    test('should create inventory with required fields', () {
      const inventory = InventoryModel(
        id: 1,
        name: 'Test Item',
      );

      expect(inventory.id, 1);
      expect(inventory.name, 'Test Item');
      expect(inventory.category, InventoryCategory.other); // default
      expect(inventory.quantity, 0); // default
      expect(inventory.isActive, true); // default
    });

    test('should create inventory with all fields', () {
      final inventory = InventoryModel(
        id: 1,
        name: 'Cleaning Spray',
        description: 'All-purpose cleaner',
        category: InventoryCategory.cleaningSupplies,
        quantity: 50,
        unitType: 'bottles',
        parLevel: 20,
        reorderPoint: 10,
        propertyId: 5,
        propertyName: 'Beach House',
        location: 'Storage Room A',
        sku: 'CLN-001',
        barcode: '1234567890',
        unitCost: 5.99,
        isActive: true,
        lastCountedAt: DateTime(2024, 12, 1),
      );

      expect(inventory.description, 'All-purpose cleaner');
      expect(inventory.category, InventoryCategory.cleaningSupplies);
      expect(inventory.quantity, 50);
      expect(inventory.unitType, 'bottles');
      expect(inventory.parLevel, 20);
      expect(inventory.reorderPoint, 10);
      expect(inventory.propertyId, 5);
      expect(inventory.sku, 'CLN-001');
      expect(inventory.unitCost, 5.99);
    });

    group('isLowStock', () {
      test('should return true when quantity is at reorder point', () {
        const inventory = InventoryModel(
          id: 1,
          name: 'Test',
          quantity: 10,
          reorderPoint: 10,
        );
        expect(inventory.isLowStock, isTrue);
      });

      test('should return true when quantity is below reorder point', () {
        const inventory = InventoryModel(
          id: 1,
          name: 'Test',
          quantity: 5,
          reorderPoint: 10,
        );
        expect(inventory.isLowStock, isTrue);
      });

      test('should return false when quantity is above reorder point', () {
        const inventory = InventoryModel(
          id: 1,
          name: 'Test',
          quantity: 15,
          reorderPoint: 10,
        );
        expect(inventory.isLowStock, isFalse);
      });

      test('should use default threshold of 5 when no reorder point', () {
        const lowInventory = InventoryModel(
          id: 1,
          name: 'Test',
          quantity: 5,
        );
        expect(lowInventory.isLowStock, isTrue);

        const normalInventory = InventoryModel(
          id: 2,
          name: 'Test',
          quantity: 10,
        );
        expect(normalInventory.isLowStock, isFalse);
      });
    });

    group('isCriticallyLow', () {
      test('should return true when quantity is below par level', () {
        const inventory = InventoryModel(
          id: 1,
          name: 'Test',
          quantity: 5,
          parLevel: 10,
        );
        expect(inventory.isCriticallyLow, isTrue);
      });

      test('should return false when quantity is at or above par level', () {
        const inventory = InventoryModel(
          id: 1,
          name: 'Test',
          quantity: 10,
          parLevel: 10,
        );
        expect(inventory.isCriticallyLow, isFalse);
      });

      test('should return true when quantity is 0 and no par level', () {
        const inventory = InventoryModel(
          id: 1,
          name: 'Test',
          quantity: 0,
        );
        expect(inventory.isCriticallyLow, isTrue);
      });
    });

    group('isOutOfStock', () {
      test('should return true when quantity is 0', () {
        const inventory = InventoryModel(
          id: 1,
          name: 'Test',
          quantity: 0,
        );
        expect(inventory.isOutOfStock, isTrue);
      });

      test('should return true when quantity is negative', () {
        const inventory = InventoryModel(
          id: 1,
          name: 'Test',
          quantity: -1,
        );
        expect(inventory.isOutOfStock, isTrue);
      });

      test('should return false when quantity is positive', () {
        const inventory = InventoryModel(
          id: 1,
          name: 'Test',
          quantity: 1,
        );
        expect(inventory.isOutOfStock, isFalse);
      });
    });

    group('stockStatus', () {
      test('should return "Out of Stock" when quantity is 0', () {
        const inventory = InventoryModel(
          id: 1,
          name: 'Test',
          quantity: 0,
        );
        expect(inventory.stockStatus, 'Out of Stock');
      });

      test('should return "Critical" when critically low', () {
        const inventory = InventoryModel(
          id: 1,
          name: 'Test',
          quantity: 5,
          parLevel: 10,
        );
        expect(inventory.stockStatus, 'Critical');
      });

      test('should return "Low Stock" when low but not critical', () {
        const inventory = InventoryModel(
          id: 1,
          name: 'Test',
          quantity: 8,
          parLevel: 5,
          reorderPoint: 10,
        );
        expect(inventory.stockStatus, 'Low Stock');
      });

      test('should return "In Stock" when quantity is adequate', () {
        const inventory = InventoryModel(
          id: 1,
          name: 'Test',
          quantity: 50,
          parLevel: 10,
          reorderPoint: 20,
        );
        expect(inventory.stockStatus, 'In Stock');
      });
    });

    group('quantityDisplay', () {
      test('should format with unit type', () {
        const inventory = InventoryModel(
          id: 1,
          name: 'Test',
          quantity: 50,
          unitType: 'bottles',
        );
        expect(inventory.quantityDisplay, '50 bottles');
      });

      test('should use "units" as default', () {
        const inventory = InventoryModel(
          id: 1,
          name: 'Test',
          quantity: 50,
        );
        expect(inventory.quantityDisplay, '50 units');
      });
    });

    group('stockValue', () {
      test('should calculate stock value', () {
        const inventory = InventoryModel(
          id: 1,
          name: 'Test',
          quantity: 10,
          unitCost: 5.50,
        );
        expect(inventory.stockValue, 55.0);
      });

      test('should return null when no unit cost', () {
        const inventory = InventoryModel(
          id: 1,
          name: 'Test',
          quantity: 10,
        );
        expect(inventory.stockValue, isNull);
      });
    });

    group('JSON serialization', () {
      test('should serialize to JSON', () {
        const inventory = InventoryModel(
          id: 1,
          name: 'Test Item',
          category: InventoryCategory.linens,
          quantity: 25,
        );

        final json = inventory.toJson();

        expect(json['id'], 1);
        expect(json['name'], 'Test Item');
        expect(json['category'], 'linens');
        expect(json['quantity'], 25);
      });

      test('should deserialize from JSON', () {
        final json = {
          'id': 1,
          'name': 'Test Item',
          'category': 'cleaning_supplies',
          'quantity': 30,
          'property_id': 5,
          'par_level': 10,
          'reorder_point': 15,
        };

        final inventory = InventoryModel.fromJson(json);

        expect(inventory.id, 1);
        expect(inventory.name, 'Test Item');
        expect(inventory.category, InventoryCategory.cleaningSupplies);
        expect(inventory.quantity, 30);
        expect(inventory.propertyId, 5);
        expect(inventory.parLevel, 10);
        expect(inventory.reorderPoint, 15);
      });
    });
  });

  group('InventoryTransactionType', () {
    test('should have correct values', () {
      expect(InventoryTransactionType.stockIn.value, 'stock_in');
      expect(InventoryTransactionType.stockOut.value, 'stock_out');
      expect(InventoryTransactionType.adjustment.value, 'adjustment');
      expect(InventoryTransactionType.damage.value, 'damage');
      expect(InventoryTransactionType.transfer.value, 'transfer');
      expect(InventoryTransactionType.shortage.value, 'shortage');
    });

    test('should have display names', () {
      expect(InventoryTransactionType.stockIn.displayName, 'Stock In');
      expect(InventoryTransactionType.stockOut.displayName, 'Stock Out');
      expect(InventoryTransactionType.damage.displayName, 'Damage');
    });

    test('reducesStock should be correct', () {
      expect(InventoryTransactionType.stockIn.reducesStock, isFalse);
      expect(InventoryTransactionType.stockOut.reducesStock, isTrue);
      expect(InventoryTransactionType.damage.reducesStock, isTrue);
      expect(InventoryTransactionType.shortage.reducesStock, isTrue);
      expect(InventoryTransactionType.transfer.reducesStock, isTrue);
      expect(InventoryTransactionType.adjustment.reducesStock, isFalse);
    });

    test('increasesStock should be correct', () {
      expect(InventoryTransactionType.stockIn.increasesStock, isTrue);
      expect(InventoryTransactionType.stockOut.increasesStock, isFalse);
      expect(InventoryTransactionType.adjustment.increasesStock, isFalse);
    });
  });

  group('InventoryCategory', () {
    test('should have correct values', () {
      expect(InventoryCategory.cleaningSupplies.value, 'cleaning_supplies');
      expect(InventoryCategory.linens.value, 'linens');
      expect(InventoryCategory.toiletries.value, 'toiletries');
      expect(InventoryCategory.kitchen.value, 'kitchen');
      expect(InventoryCategory.other.value, 'other');
    });

    test('should have display names', () {
      expect(InventoryCategory.cleaningSupplies.displayName, 'Cleaning Supplies');
      expect(InventoryCategory.linens.displayName, 'Linens');
      expect(InventoryCategory.electronics.displayName, 'Electronics');
    });
  });

  group('InventoryTransactionModel', () {
    test('should create transaction with required fields', () {
      const transaction = InventoryTransactionModel(
        id: 1,
        inventoryId: 10,
        type: InventoryTransactionType.stockIn,
        quantity: 50,
      );

      expect(transaction.id, 1);
      expect(transaction.inventoryId, 10);
      expect(transaction.type, InventoryTransactionType.stockIn);
      expect(transaction.quantity, 50);
    });

    group('quantityChangeDisplay', () {
      test('should show positive sign for stock in', () {
        const transaction = InventoryTransactionModel(
          id: 1,
          inventoryId: 10,
          type: InventoryTransactionType.stockIn,
          quantity: 25,
        );
        expect(transaction.quantityChangeDisplay, '+25');
      });

      test('should show negative sign for stock out', () {
        const transaction = InventoryTransactionModel(
          id: 1,
          inventoryId: 10,
          type: InventoryTransactionType.stockOut,
          quantity: 10,
        );
        expect(transaction.quantityChangeDisplay, '-10');
      });

      test('should show negative sign for damage', () {
        const transaction = InventoryTransactionModel(
          id: 1,
          inventoryId: 10,
          type: InventoryTransactionType.damage,
          quantity: 5,
        );
        expect(transaction.quantityChangeDisplay, '-5');
      });
    });

    group('isIncrease and isDecrease', () {
      test('stock in should be increase', () {
        const transaction = InventoryTransactionModel(
          id: 1,
          inventoryId: 10,
          type: InventoryTransactionType.stockIn,
          quantity: 10,
        );
        expect(transaction.isIncrease, isTrue);
        expect(transaction.isDecrease, isFalse);
      });

      test('stock out should be decrease', () {
        const transaction = InventoryTransactionModel(
          id: 1,
          inventoryId: 10,
          type: InventoryTransactionType.stockOut,
          quantity: 10,
        );
        expect(transaction.isIncrease, isFalse);
        expect(transaction.isDecrease, isTrue);
      });
    });

    group('JSON serialization', () {
      test('should serialize to JSON', () {
        const transaction = InventoryTransactionModel(
          id: 1,
          inventoryId: 10,
          type: InventoryTransactionType.stockIn,
          quantity: 25,
        );

        final json = transaction.toJson();

        expect(json['id'], 1);
        expect(json['inventory_id'], 10);
        expect(json['type'], 'stock_in');
        expect(json['quantity'], 25);
      });

      test('should deserialize from JSON', () {
        final json = {
          'id': 1,
          'inventory_id': 10,
          'type': 'stock_out',
          'quantity': 15,
          'notes': 'Used for cleaning',
        };

        final transaction = InventoryTransactionModel.fromJson(json);

        expect(transaction.id, 1);
        expect(transaction.inventoryId, 10);
        expect(transaction.type, InventoryTransactionType.stockOut);
        expect(transaction.quantity, 15);
        expect(transaction.notes, 'Used for cleaning');
      });
    });
  });

  group('LowStockAlertModel', () {
    test('should create alert with required fields', () {
      const alert = LowStockAlertModel(
        id: 1,
        inventoryId: 10,
        inventoryName: 'Test Item',
        category: InventoryCategory.cleaningSupplies,
        currentQuantity: 5,
      );

      expect(alert.id, 1);
      expect(alert.inventoryId, 10);
      expect(alert.inventoryName, 'Test Item');
      expect(alert.currentQuantity, 5);
      expect(alert.isCritical, false); // default
    });

    group('unitsNeeded', () {
      test('should calculate units needed to reach par level', () {
        const alert = LowStockAlertModel(
          id: 1,
          inventoryId: 10,
          inventoryName: 'Test',
          category: InventoryCategory.cleaningSupplies,
          currentQuantity: 5,
          parLevel: 20,
        );
        expect(alert.unitsNeeded, 15);
      });

      test('should return 0 when already at par level', () {
        const alert = LowStockAlertModel(
          id: 1,
          inventoryId: 10,
          inventoryName: 'Test',
          category: InventoryCategory.cleaningSupplies,
          currentQuantity: 25,
          parLevel: 20,
        );
        expect(alert.unitsNeeded, 0);
      });

      test('should return 0 when no par level set', () {
        const alert = LowStockAlertModel(
          id: 1,
          inventoryId: 10,
          inventoryName: 'Test',
          category: InventoryCategory.cleaningSupplies,
          currentQuantity: 5,
        );
        expect(alert.unitsNeeded, 0);
      });
    });

    group('urgencyLevel', () {
      test('should return 3 for out of stock', () {
        const alert = LowStockAlertModel(
          id: 1,
          inventoryId: 10,
          inventoryName: 'Test',
          category: InventoryCategory.cleaningSupplies,
          currentQuantity: 0,
        );
        expect(alert.urgencyLevel, 3);
      });

      test('should return 2 for critical', () {
        const alert = LowStockAlertModel(
          id: 1,
          inventoryId: 10,
          inventoryName: 'Test',
          category: InventoryCategory.cleaningSupplies,
          currentQuantity: 5,
          isCritical: true,
        );
        expect(alert.urgencyLevel, 2);
      });

      test('should return 1 for normal low stock', () {
        const alert = LowStockAlertModel(
          id: 1,
          inventoryId: 10,
          inventoryName: 'Test',
          category: InventoryCategory.cleaningSupplies,
          currentQuantity: 10,
        );
        expect(alert.urgencyLevel, 1);
      });
    });
  });

  group('PaginatedInventory', () {
    test('should create from JSON', () {
      final json = {
        'count': 25,
        'next': 'http://api/inventory?page=2',
        'previous': null,
        'results': [
          {'id': 1, 'name': 'Item 1'},
          {'id': 2, 'name': 'Item 2'},
        ],
      };

      final paginated = PaginatedInventory.fromJson(json);

      expect(paginated.count, 25);
      expect(paginated.next, 'http://api/inventory?page=2');
      expect(paginated.previous, isNull);
      expect(paginated.results.length, 2);
      expect(paginated.hasMore, isTrue);
    });

    test('hasMore should be false when no next page', () {
      final json = {
        'count': 2,
        'next': null,
        'previous': null,
        'results': [],
      };

      final paginated = PaginatedInventory.fromJson(json);
      expect(paginated.hasMore, isFalse);
    });
  });
}
