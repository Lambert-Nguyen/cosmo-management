/// Tests for lost and found screen
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cosmo_app/data/models/lost_found_model.dart';
import 'package:cosmo_app/features/lost_found/widgets/lost_found_list_item.dart';
import 'package:cosmo_app/features/lost_found/widgets/lost_found_status_badge.dart';

void main() {
  group('LostFoundListItem', () {
    testWidgets('displays item title and description', (tester) async {
      final item = LostFoundModel(
        id: 1,
        title: 'Lost Wallet',
        description: 'Black leather wallet',
        status: LostFoundStatus.lost,
        dateFound: DateTime(2024, 12, 15),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LostFoundListItem(
              item: item,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Lost Wallet'), findsOneWidget);
      expect(find.text('Black leather wallet'), findsOneWidget);
    });

    testWidgets('displays category correctly', (tester) async {
      const item = LostFoundModel(
        id: 1,
        title: 'Found Keys',
        category: LostFoundCategory.keys,
        status: LostFoundStatus.found,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LostFoundListItem(
              item: item,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Keys'), findsOneWidget);
    });

    testWidgets('shows property name when available', (tester) async {
      const item = LostFoundModel(
        id: 1,
        title: 'Found Phone',
        propertyName: 'Beach House',
        status: LostFoundStatus.found,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LostFoundListItem(
              item: item,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Beach House'), findsOneWidget);
    });

    testWidgets('handles tap callback', (tester) async {
      var tapped = false;

      const item = LostFoundModel(
        id: 1,
        title: 'Test Item',
        status: LostFoundStatus.found,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LostFoundListItem(
              item: item,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(LostFoundListItem));
      expect(tapped, true);
    });

    testWidgets('shows claim button for found items', (tester) async {
      var claimed = false;

      const item = LostFoundModel(
        id: 1,
        title: 'Found Watch',
        status: LostFoundStatus.found,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LostFoundListItem(
              item: item,
              onTap: () {},
              onClaim: () => claimed = true,
            ),
          ),
        ),
      );

      // Look for claim icon button
      final claimButton = find.byIcon(Icons.check_circle_outline);
      expect(claimButton, findsOneWidget);
      await tester.tap(claimButton);
      expect(claimed, true);
    });

    testWidgets('shows valuable indicator for valuable items', (tester) async {
      const item = LostFoundModel(
        id: 1,
        title: 'Diamond Ring',
        category: LostFoundCategory.jewelry,
        status: LostFoundStatus.found,
        isValuable: true,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LostFoundListItem(
              item: item,
              onTap: () {},
            ),
          ),
        ),
      );

      // Should show valuable indicator with diamond icon and text
      expect(find.byIcon(Icons.diamond_outlined), findsOneWidget);
      expect(find.text('Valuable'), findsOneWidget);
    });
  });

  group('LostFoundStatusBadge', () {
    testWidgets('displays found status correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LostFoundStatusBadge(status: LostFoundStatus.found),
          ),
        ),
      );

      expect(find.text('FOUND'), findsOneWidget);
    });

    testWidgets('displays lost status correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LostFoundStatusBadge(status: LostFoundStatus.lost),
          ),
        ),
      );

      expect(find.text('LOST'), findsOneWidget);
    });

    testWidgets('displays claimed status correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LostFoundStatusBadge(status: LostFoundStatus.claimed),
          ),
        ),
      );

      expect(find.text('CLAIMED'), findsOneWidget);
    });

    testWidgets('displays archived status correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LostFoundStatusBadge(status: LostFoundStatus.archived),
          ),
        ),
      );

      expect(find.text('ARCHIVED'), findsOneWidget);
    });

    testWidgets('displays expired status correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LostFoundStatusBadge(status: LostFoundStatus.expired),
          ),
        ),
      );

      expect(find.text('EXPIRED'), findsOneWidget);
    });
  });

  group('LostFoundStatus', () {
    test('all statuses should have display names', () {
      for (final status in LostFoundStatus.values) {
        expect(status.displayName.isNotEmpty, true);
      }
    });

    test('isActive returns correct value', () {
      expect(LostFoundStatus.lost.isActive, true);
      expect(LostFoundStatus.found.isActive, true);
      expect(LostFoundStatus.claimed.isActive, false);
      expect(LostFoundStatus.archived.isActive, false);
      expect(LostFoundStatus.expired.isActive, false);
    });

    test('isResolved returns correct value', () {
      expect(LostFoundStatus.lost.isResolved, false);
      expect(LostFoundStatus.found.isResolved, false);
      expect(LostFoundStatus.claimed.isResolved, true);
      expect(LostFoundStatus.archived.isResolved, true);
      expect(LostFoundStatus.expired.isResolved, true);
    });

    test('canBeClaimed returns correct value', () {
      expect(LostFoundStatus.found.canBeClaimed, true);
      expect(LostFoundStatus.lost.canBeClaimed, false);
      expect(LostFoundStatus.claimed.canBeClaimed, false);
    });
  });

  group('LostFoundCategory', () {
    test('all categories should have display names', () {
      for (final category in LostFoundCategory.values) {
        expect(category.displayName.isNotEmpty, true);
      }
    });

    test('isHighValue returns correct value', () {
      expect(LostFoundCategory.electronics.isHighValue, true);
      expect(LostFoundCategory.jewelry.isHighValue, true);
      expect(LostFoundCategory.valuables.isHighValue, true);
      expect(LostFoundCategory.keys.isHighValue, false);
      expect(LostFoundCategory.clothing.isHighValue, false);
      expect(LostFoundCategory.other.isHighValue, false);
    });
  });

  group('LostFoundModel computed properties', () {
    test('daysSinceReported calculates correctly', () {
      final item = LostFoundModel(
        id: 1,
        title: 'Test',
        dateFound: DateTime.now().subtract(const Duration(days: 5)),
      );
      expect(item.daysSinceReported, 5);
    });

    test('displayDate prefers dateFound', () {
      final foundDate = DateTime(2024, 12, 15);
      final createdAt = DateTime(2024, 12, 10);

      final item = LostFoundModel(
        id: 1,
        title: 'Test',
        dateFound: foundDate,
        createdAt: createdAt,
      );
      expect(item.displayDate, foundDate);
    });

    test('statusMessage returns appropriate message', () {
      const foundItem = LostFoundModel(
        id: 1,
        title: 'Test',
        status: LostFoundStatus.found,
      );
      expect(foundItem.statusMessage, contains('Found'));

      const lostItem = LostFoundModel(
        id: 2,
        title: 'Test',
        status: LostFoundStatus.lost,
      );
      expect(lostItem.statusMessage, contains('lost'));

      const claimedItem = LostFoundModel(
        id: 3,
        title: 'Test',
        status: LostFoundStatus.claimed,
        claimedByName: 'John Doe',
      );
      expect(claimedItem.statusMessage, contains('Claimed'));
    });

    test('hasPhotos returns correct value', () {
      const withPhotos = LostFoundModel(
        id: 1,
        title: 'Test',
        images: ['photo1.jpg'],
      );
      expect(withPhotos.hasPhotos, true);

      const noPhotos = LostFoundModel(
        id: 2,
        title: 'Test',
      );
      expect(noPhotos.hasPhotos, false);
    });

    test('isExpiringSoon detects items within 7 days of expiry', () {
      final expiringSoon = LostFoundModel(
        id: 1,
        title: 'Test',
        expiresAt: DateTime.now().add(const Duration(days: 5)),
      );
      expect(expiringSoon.isExpiringSoon, true);

      final notExpiringSoon = LostFoundModel(
        id: 2,
        title: 'Test',
        expiresAt: DateTime.now().add(const Duration(days: 30)),
      );
      expect(notExpiringSoon.isExpiringSoon, false);
    });

    test('hasExpired detects past expiry dates', () {
      final expired = LostFoundModel(
        id: 1,
        title: 'Test',
        expiresAt: DateTime.now().subtract(const Duration(days: 1)),
      );
      expect(expired.hasExpired, true);

      final notExpired = LostFoundModel(
        id: 2,
        title: 'Test',
        expiresAt: DateTime.now().add(const Duration(days: 30)),
      );
      expect(notExpired.hasExpired, false);
    });

    test('needsAttention identifies items requiring attention', () {
      // Expiring soon should need attention
      final expiring = LostFoundModel(
        id: 1,
        title: 'Test',
        status: LostFoundStatus.found,
        expiresAt: DateTime.now().add(const Duration(days: 3)),
      );
      expect(expiring.needsAttention, true);

      // Valuable unclaimed item after 7 days needs attention
      final valuableOld = LostFoundModel(
        id: 2,
        title: 'Test',
        status: LostFoundStatus.found,
        isValuable: true,
        dateFound: DateTime.now().subtract(const Duration(days: 10)),
      );
      expect(valuableOld.needsAttention, true);

      // Claimed items don't need attention
      final claimed = LostFoundModel(
        id: 3,
        title: 'Test',
        status: LostFoundStatus.claimed,
        expiresAt: DateTime.now().add(const Duration(days: 3)),
      );
      expect(claimed.needsAttention, false);
    });
  });

  group('LostFoundStatsModel', () {
    test('totalActive sums lost and found', () {
      const stats = LostFoundStatsModel(
        totalLost: 5,
        totalFound: 10,
      );
      expect(stats.totalActive, 15);
    });

    test('claimRate calculates percentage correctly', () {
      const stats = LostFoundStatsModel(
        totalLost: 5,
        totalFound: 10,
        totalClaimed: 5,
      );
      expect(stats.claimRate, 25.0);
    });

    test('claimRate returns 0 for empty stats', () {
      const stats = LostFoundStatsModel();
      expect(stats.claimRate, 0.0);
    });
  });
}
