/// Tests for lost and found model
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:cosmo_app/data/models/lost_found_model.dart';

void main() {
  group('LostFoundModel', () {
    test('should create item with required fields', () {
      const item = LostFoundModel(
        id: 1,
        title: 'Lost Wallet',
      );

      expect(item.id, 1);
      expect(item.title, 'Lost Wallet');
      expect(item.status, LostFoundStatus.found); // default
      expect(item.category, LostFoundCategory.other); // default
      expect(item.isValuable, false); // default
      expect(item.images, isEmpty); // default
    });

    test('should create item with all fields', () {
      final item = LostFoundModel(
        id: 1,
        title: 'iPhone 15 Pro',
        description: 'Black iPhone with cracked screen',
        status: LostFoundStatus.found,
        category: LostFoundCategory.electronics,
        locationFound: 'Lobby',
        locationDescription: 'Near the front desk',
        propertyId: 5,
        propertyName: 'Beach House',
        dateFound: DateTime(2024, 12, 15),
        reportedById: 10,
        reportedByName: 'John Doe',
        storageLocation: 'Lost & Found Box A',
        isValuable: true,
        estimatedValue: 999.99,
        images: ['image1.jpg', 'image2.jpg'],
        notes: 'Owner may be guest in Room 301',
        expiresAt: DateTime(2025, 3, 15),
      );

      expect(item.description, 'Black iPhone with cracked screen');
      expect(item.category, LostFoundCategory.electronics);
      expect(item.locationFound, 'Lobby');
      expect(item.propertyId, 5);
      expect(item.isValuable, isTrue);
      expect(item.estimatedValue, 999.99);
      expect(item.images.length, 2);
    });

    group('status checks', () {
      test('isLostReport should return true for lost status', () {
        const item = LostFoundModel(
          id: 1,
          title: 'Test',
          status: LostFoundStatus.lost,
        );
        expect(item.isLostReport, isTrue);
        expect(item.isFoundReport, isFalse);
      });

      test('isFoundReport should return true for found status', () {
        const item = LostFoundModel(
          id: 1,
          title: 'Test',
          status: LostFoundStatus.found,
        );
        expect(item.isFoundReport, isTrue);
        expect(item.isLostReport, isFalse);
      });

      test('isClaimed should return true for claimed status', () {
        const item = LostFoundModel(
          id: 1,
          title: 'Test',
          status: LostFoundStatus.claimed,
        );
        expect(item.isClaimed, isTrue);
      });

      test('isActive should return true for lost and found statuses', () {
        const lostItem = LostFoundModel(
          id: 1,
          title: 'Test',
          status: LostFoundStatus.lost,
        );
        expect(lostItem.isActive, isTrue);

        const foundItem = LostFoundModel(
          id: 2,
          title: 'Test',
          status: LostFoundStatus.found,
        );
        expect(foundItem.isActive, isTrue);

        const claimedItem = LostFoundModel(
          id: 3,
          title: 'Test',
          status: LostFoundStatus.claimed,
        );
        expect(claimedItem.isActive, isFalse);
      });
    });

    group('hasPhotos', () {
      test('should return true when images exist', () {
        const item = LostFoundModel(
          id: 1,
          title: 'Test',
          images: ['photo1.jpg'],
        );
        expect(item.hasPhotos, isTrue);
      });

      test('should return false when no images', () {
        const item = LostFoundModel(
          id: 1,
          title: 'Test',
        );
        expect(item.hasPhotos, isFalse);
      });
    });

    group('daysSinceReported', () {
      test('should calculate days since date found', () {
        final item = LostFoundModel(
          id: 1,
          title: 'Test',
          dateFound: DateTime.now().subtract(const Duration(days: 5)),
        );
        expect(item.daysSinceReported, 5);
      });

      test('should calculate days since date lost', () {
        final item = LostFoundModel(
          id: 1,
          title: 'Test',
          status: LostFoundStatus.lost,
          dateLost: DateTime.now().subtract(const Duration(days: 3)),
        );
        expect(item.daysSinceReported, 3);
      });

      test('should return 0 when no date', () {
        const item = LostFoundModel(
          id: 1,
          title: 'Test',
        );
        expect(item.daysSinceReported, 0);
      });
    });

    group('daysUntilExpiry', () {
      test('should return days until expiry', () {
        final item = LostFoundModel(
          id: 1,
          title: 'Test',
          expiresAt: DateTime.now().add(const Duration(days: 10)),
        );
        expect(item.daysUntilExpiry, greaterThanOrEqualTo(9));
      });

      test('should return null when no expiry date', () {
        const item = LostFoundModel(
          id: 1,
          title: 'Test',
        );
        expect(item.daysUntilExpiry, isNull);
      });

      test('should return negative when expired', () {
        final item = LostFoundModel(
          id: 1,
          title: 'Test',
          expiresAt: DateTime.now().subtract(const Duration(days: 5)),
        );
        expect(item.daysUntilExpiry, lessThan(0));
      });
    });

    group('isExpiringSoon', () {
      test('should return true within 7 days', () {
        final item = LostFoundModel(
          id: 1,
          title: 'Test',
          expiresAt: DateTime.now().add(const Duration(days: 5)),
        );
        expect(item.isExpiringSoon, isTrue);
      });

      test('should return false if more than 7 days', () {
        final item = LostFoundModel(
          id: 1,
          title: 'Test',
          expiresAt: DateTime.now().add(const Duration(days: 30)),
        );
        expect(item.isExpiringSoon, isFalse);
      });

      test('should return false if already expired', () {
        final item = LostFoundModel(
          id: 1,
          title: 'Test',
          expiresAt: DateTime.now().subtract(const Duration(days: 1)),
        );
        expect(item.isExpiringSoon, isFalse);
      });
    });

    group('hasExpired', () {
      test('should return true when past expiry date', () {
        final item = LostFoundModel(
          id: 1,
          title: 'Test',
          expiresAt: DateTime.now().subtract(const Duration(days: 1)),
        );
        expect(item.hasExpired, isTrue);
      });

      test('should return false when not expired', () {
        final item = LostFoundModel(
          id: 1,
          title: 'Test',
          expiresAt: DateTime.now().add(const Duration(days: 30)),
        );
        expect(item.hasExpired, isFalse);
      });

      test('should return false when no expiry date', () {
        const item = LostFoundModel(
          id: 1,
          title: 'Test',
        );
        expect(item.hasExpired, isFalse);
      });
    });

    group('displayDate', () {
      test('should prefer dateFound', () {
        final foundDate = DateTime(2024, 12, 15);
        final item = LostFoundModel(
          id: 1,
          title: 'Test',
          dateFound: foundDate,
          createdAt: DateTime(2024, 12, 10),
        );
        expect(item.displayDate, foundDate);
      });

      test('should use dateLost when no dateFound', () {
        final lostDate = DateTime(2024, 12, 15);
        final item = LostFoundModel(
          id: 1,
          title: 'Test',
          dateLost: lostDate,
        );
        expect(item.displayDate, lostDate);
      });

      test('should fallback to createdAt', () {
        final createdAt = DateTime(2024, 12, 15);
        final item = LostFoundModel(
          id: 1,
          title: 'Test',
          createdAt: createdAt,
        );
        expect(item.displayDate, createdAt);
      });
    });

    group('needsAttention', () {
      test('should return false for resolved items', () {
        final item = LostFoundModel(
          id: 1,
          title: 'Test',
          status: LostFoundStatus.claimed,
          expiresAt: DateTime.now().add(const Duration(days: 3)),
        );
        expect(item.needsAttention, isFalse);
      });

      test('should return true when expiring soon', () {
        final item = LostFoundModel(
          id: 1,
          title: 'Test',
          status: LostFoundStatus.found,
          expiresAt: DateTime.now().add(const Duration(days: 5)),
        );
        expect(item.needsAttention, isTrue);
      });

      test('should return true for valuable unclaimed items after 7 days', () {
        final item = LostFoundModel(
          id: 1,
          title: 'Test',
          status: LostFoundStatus.found,
          isValuable: true,
          dateFound: DateTime.now().subtract(const Duration(days: 10)),
        );
        expect(item.needsAttention, isTrue);
      });
    });

    group('JSON serialization', () {
      test('should serialize to JSON', () {
        const item = LostFoundModel(
          id: 1,
          title: 'Lost Keys',
          status: LostFoundStatus.found,
          category: LostFoundCategory.keys,
          isValuable: true,
        );

        final json = item.toJson();

        expect(json['id'], 1);
        expect(json['title'], 'Lost Keys');
        expect(json['status'], 'found');
        expect(json['category'], 'keys');
        expect(json['is_valuable'], true);
      });

      test('should deserialize from JSON', () {
        final json = {
          'id': 1,
          'title': 'Found Phone',
          'status': 'found',
          'category': 'electronics',
          'location_found': 'Pool Area',
          'property_id': 5,
          'is_valuable': true,
          'estimated_value': 500.0,
        };

        final item = LostFoundModel.fromJson(json);

        expect(item.id, 1);
        expect(item.title, 'Found Phone');
        expect(item.status, LostFoundStatus.found);
        expect(item.category, LostFoundCategory.electronics);
        expect(item.locationFound, 'Pool Area');
        expect(item.propertyId, 5);
        expect(item.isValuable, isTrue);
        expect(item.estimatedValue, 500.0);
      });
    });
  });

  group('LostFoundStatus', () {
    test('should have correct values', () {
      expect(LostFoundStatus.lost.value, 'lost');
      expect(LostFoundStatus.found.value, 'found');
      expect(LostFoundStatus.claimed.value, 'claimed');
      expect(LostFoundStatus.archived.value, 'archived');
      expect(LostFoundStatus.expired.value, 'expired');
    });

    test('should have display names', () {
      expect(LostFoundStatus.lost.displayName, 'Lost');
      expect(LostFoundStatus.found.displayName, 'Found');
      expect(LostFoundStatus.claimed.displayName, 'Claimed');
    });

    test('isActive should be correct', () {
      expect(LostFoundStatus.lost.isActive, isTrue);
      expect(LostFoundStatus.found.isActive, isTrue);
      expect(LostFoundStatus.claimed.isActive, isFalse);
      expect(LostFoundStatus.archived.isActive, isFalse);
      expect(LostFoundStatus.expired.isActive, isFalse);
    });

    test('isResolved should be correct', () {
      expect(LostFoundStatus.lost.isResolved, isFalse);
      expect(LostFoundStatus.found.isResolved, isFalse);
      expect(LostFoundStatus.claimed.isResolved, isTrue);
      expect(LostFoundStatus.archived.isResolved, isTrue);
      expect(LostFoundStatus.expired.isResolved, isTrue);
    });

    test('canBeClaimed should be correct', () {
      expect(LostFoundStatus.found.canBeClaimed, isTrue);
      expect(LostFoundStatus.lost.canBeClaimed, isFalse);
      expect(LostFoundStatus.claimed.canBeClaimed, isFalse);
    });
  });

  group('LostFoundCategory', () {
    test('should have correct values', () {
      expect(LostFoundCategory.keys.value, 'keys');
      expect(LostFoundCategory.documents.value, 'documents');
      expect(LostFoundCategory.electronics.value, 'electronics');
      expect(LostFoundCategory.clothing.value, 'clothing');
      expect(LostFoundCategory.jewelry.value, 'jewelry');
    });

    test('should have display names', () {
      expect(LostFoundCategory.keys.displayName, 'Keys');
      expect(LostFoundCategory.bags.displayName, 'Bags & Luggage');
      expect(LostFoundCategory.personal.displayName, 'Personal Items');
    });

    test('isHighValue should be correct', () {
      expect(LostFoundCategory.electronics.isHighValue, isTrue);
      expect(LostFoundCategory.jewelry.isHighValue, isTrue);
      expect(LostFoundCategory.valuables.isHighValue, isTrue);
      expect(LostFoundCategory.keys.isHighValue, isFalse);
      expect(LostFoundCategory.clothing.isHighValue, isFalse);
    });
  });

  group('LostFoundClaimModel', () {
    test('should create claim with required fields', () {
      const claim = LostFoundClaimModel(
        id: 1,
        lostFoundId: 10,
        claimedById: 5,
      );

      expect(claim.id, 1);
      expect(claim.lostFoundId, 10);
      expect(claim.claimedById, 5);
      expect(claim.isVerified, false); // default
    });

    test('should serialize to JSON', () {
      const claim = LostFoundClaimModel(
        id: 1,
        lostFoundId: 10,
        claimedById: 5,
        claimedByName: 'Jane Doe',
        identificationProvided: 'Driver License',
        isVerified: true,
      );

      final json = claim.toJson();

      expect(json['id'], 1);
      expect(json['lost_found_id'], 10);
      expect(json['claimed_by'], 5);
      expect(json['claimed_by_name'], 'Jane Doe');
      expect(json['identification_provided'], 'Driver License');
      expect(json['is_verified'], true);
    });

    test('should deserialize from JSON', () {
      final json = {
        'id': 1,
        'lost_found_id': 10,
        'claimed_by': 5,
        'claimed_by_name': 'John Smith',
        'claimant_contact': 'john@email.com',
        'is_verified': false,
      };

      final claim = LostFoundClaimModel.fromJson(json);

      expect(claim.id, 1);
      expect(claim.lostFoundId, 10);
      expect(claim.claimedById, 5);
      expect(claim.claimedByName, 'John Smith');
      expect(claim.claimantContact, 'john@email.com');
      expect(claim.isVerified, isFalse);
    });
  });

  group('PaginatedLostFound', () {
    test('should create from JSON', () {
      final json = {
        'count': 15,
        'next': 'http://api/lost-found?page=2',
        'previous': null,
        'results': [
          {'id': 1, 'title': 'Item 1'},
          {'id': 2, 'title': 'Item 2'},
        ],
      };

      final paginated = PaginatedLostFound.fromJson(json);

      expect(paginated.count, 15);
      expect(paginated.next, 'http://api/lost-found?page=2');
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

      final paginated = PaginatedLostFound.fromJson(json);
      expect(paginated.hasMore, isFalse);
    });
  });

  group('LostFoundStatsModel', () {
    test('should create with defaults', () {
      const stats = LostFoundStatsModel();

      expect(stats.totalLost, 0);
      expect(stats.totalFound, 0);
      expect(stats.totalClaimed, 0);
      expect(stats.pendingClaims, 0);
      expect(stats.expiringSoon, 0);
    });

    test('totalActive should sum lost and found', () {
      const stats = LostFoundStatsModel(
        totalLost: 5,
        totalFound: 10,
        totalClaimed: 3,
      );
      expect(stats.totalActive, 15);
    });

    test('claimRate should calculate percentage', () {
      const stats = LostFoundStatsModel(
        totalLost: 5,
        totalFound: 10,
        totalClaimed: 5,
      );
      // 5 / (5 + 10 + 5) = 5/20 = 25%
      expect(stats.claimRate, 25.0);
    });

    test('claimRate should return 0 when no items', () {
      const stats = LostFoundStatsModel();
      expect(stats.claimRate, 0.0);
    });

    test('should deserialize from JSON', () {
      final json = {
        'total_lost': 10,
        'total_found': 25,
        'total_claimed': 15,
        'pending_claims': 3,
        'expiring_soon': 5,
      };

      final stats = LostFoundStatsModel.fromJson(json);

      expect(stats.totalLost, 10);
      expect(stats.totalFound, 25);
      expect(stats.totalClaimed, 15);
      expect(stats.pendingClaims, 3);
      expect(stats.expiringSoon, 5);
    });
  });
}
