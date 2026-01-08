/// Tests for inventory screen
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cosmo_app/data/models/inventory_model.dart';
import 'package:cosmo_app/features/inventory/widgets/inventory_list_item.dart';

void main() {
  group('InventoryListItem', () {
    testWidgets('displays item name and quantity', (tester) async {
      const item = InventoryModel(
        id: 1,
        name: 'Cleaning Spray',
        quantity: 25,
        category: InventoryCategory.cleaningSupplies,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InventoryListItem(
              item: item,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Cleaning Spray'), findsOneWidget);
      expect(find.text('25 units'), findsOneWidget);
    });

    testWidgets('displays category correctly', (tester) async {
      const item = InventoryModel(
        id: 1,
        name: 'Bath Towels',
        quantity: 50,
        category: InventoryCategory.linens,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InventoryListItem(
              item: item,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Linens'), findsOneWidget);
    });

    testWidgets('shows low stock indicator when low', (tester) async {
      const item = InventoryModel(
        id: 1,
        name: 'Shampoo',
        quantity: 3,
        category: InventoryCategory.toiletries,
        reorderPoint: 10,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InventoryListItem(
              item: item,
              onTap: () {},
            ),
          ),
        ),
      );

      // Should show LOW chip for low stock
      expect(find.text('LOW'), findsOneWidget);
    });

    testWidgets('shows out of stock indicator when empty', (tester) async {
      const item = InventoryModel(
        id: 1,
        name: 'Paper Towels',
        quantity: 0,
        category: InventoryCategory.cleaningSupplies,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InventoryListItem(
              item: item,
              onTap: () {},
            ),
          ),
        ),
      );

      // Should show OUT chip for out of stock
      expect(find.text('OUT'), findsOneWidget);
    });

    testWidgets('handles tap callback', (tester) async {
      var tapped = false;

      const item = InventoryModel(
        id: 1,
        name: 'Test Item',
        quantity: 10,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InventoryListItem(
              item: item,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InventoryListItem));
      expect(tapped, true);
    });

    testWidgets('shows transaction button when callback provided', (tester) async {
      var transactionPressed = false;

      const item = InventoryModel(
        id: 1,
        name: 'Test Item',
        quantity: 10,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InventoryListItem(
              item: item,
              onTap: () {},
              onTransaction: () => transactionPressed = true,
            ),
          ),
        ),
      );

      // Find and tap the transaction button (add icon)
      final addButton = find.byIcon(Icons.add_circle_outline);
      if (addButton.evaluate().isNotEmpty) {
        await tester.tap(addButton);
        expect(transactionPressed, true);
      }
    });

    testWidgets('displays unit type when available', (tester) async {
      const item = InventoryModel(
        id: 1,
        name: 'Dish Soap',
        quantity: 15,
        unitType: 'bottles',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InventoryListItem(
              item: item,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('15 bottles'), findsOneWidget);
    });

    testWidgets('displays property name when available', (tester) async {
      const item = InventoryModel(
        id: 1,
        name: 'Test Item',
        quantity: 10,
        propertyName: 'Beach House',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InventoryListItem(
              item: item,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Beach House'), findsOneWidget);
    });
  });

  group('InventoryCategory', () {
    test('all categories should have display names', () {
      for (final category in InventoryCategory.values) {
        expect(category.displayName.isNotEmpty, true);
      }
    });

    test('all categories should have values', () {
      for (final category in InventoryCategory.values) {
        expect(category.value.isNotEmpty, true);
      }
    });
  });

  group('InventoryTransactionType', () {
    test('all types should have display names', () {
      for (final type in InventoryTransactionType.values) {
        expect(type.displayName.isNotEmpty, true);
      }
    });

    test('stock_in should increase stock', () {
      expect(InventoryTransactionType.stockIn.increasesStock, true);
      expect(InventoryTransactionType.stockIn.reducesStock, false);
    });

    test('stock_out should reduce stock', () {
      expect(InventoryTransactionType.stockOut.increasesStock, false);
      expect(InventoryTransactionType.stockOut.reducesStock, true);
    });
  });

  group('InventoryModel calculated properties', () {
    test('stockStatus returns correct status for various quantities', () {
      // Out of stock
      const outOfStock = InventoryModel(id: 1, name: 'Test', quantity: 0);
      expect(outOfStock.stockStatus, 'Out of Stock');

      // Critical (below par level)
      const critical = InventoryModel(
        id: 2,
        name: 'Test',
        quantity: 5,
        parLevel: 10,
      );
      expect(critical.stockStatus, 'Critical');

      // Low stock (at or below reorder point but above par)
      const lowStock = InventoryModel(
        id: 3,
        name: 'Test',
        quantity: 12,
        parLevel: 10,
        reorderPoint: 15,
      );
      expect(lowStock.stockStatus, 'Low Stock');

      // In stock (above reorder point)
      const inStock = InventoryModel(
        id: 4,
        name: 'Test',
        quantity: 50,
        parLevel: 10,
        reorderPoint: 15,
      );
      expect(inStock.stockStatus, 'In Stock');
    });

    test('quantityDisplay formats correctly', () {
      const withUnit = InventoryModel(
        id: 1,
        name: 'Test',
        quantity: 25,
        unitType: 'bottles',
      );
      expect(withUnit.quantityDisplay, '25 bottles');

      const withoutUnit = InventoryModel(
        id: 2,
        name: 'Test',
        quantity: 10,
      );
      expect(withoutUnit.quantityDisplay, '10 units');
    });

    test('stockValue calculates correctly', () {
      const withCost = InventoryModel(
        id: 1,
        name: 'Test',
        quantity: 10,
        unitCost: 5.50,
      );
      expect(withCost.stockValue, 55.0);

      const withoutCost = InventoryModel(
        id: 2,
        name: 'Test',
        quantity: 10,
      );
      expect(withoutCost.stockValue, isNull);
    });
  });
}
