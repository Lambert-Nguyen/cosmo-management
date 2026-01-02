import 'package:flutter_test/flutter_test.dart';
import 'package:cosmo_app/data/models/property_model.dart';

void main() {
  group('PropertyModel', () {
    test('should create property with required fields', () {
      const property = PropertyModel(
        id: 1,
        name: 'Test Property',
      );

      expect(property.id, 1);
      expect(property.name, 'Test Property');
      expect(property.status, PropertyStatus.available); // default
      expect(property.isActive, isTrue); // default
    });

    test('should create property with all fields', () {
      final property = PropertyModel(
        id: 1,
        name: 'Luxury Apartment',
        description: 'A beautiful apartment',
        propertyType: 'apartment',
        address: '123 Main St',
        city: 'New York',
        state: 'NY',
        zipCode: '10001',
        country: 'USA',
        unitNumber: '4A',
        floorNumber: 4,
        squareFeet: 1200.5,
        bedrooms: 2,
        bathrooms: 2,
        maxOccupancy: 4,
        status: PropertyStatus.occupied,
        isActive: true,
        managerId: 5,
        managerName: 'John Manager',
      );

      expect(property.description, 'A beautiful apartment');
      expect(property.propertyType, 'apartment');
      expect(property.city, 'New York');
      expect(property.squareFeet, 1200.5);
      expect(property.bedrooms, 2);
      expect(property.status, PropertyStatus.occupied);
    });

    group('fullAddress', () {
      test('should return full address with all parts', () {
        const property = PropertyModel(
          id: 1,
          name: 'Test',
          address: '123 Main St',
          unitNumber: '4A',
          city: 'New York',
          state: 'NY',
          zipCode: '10001',
        );

        expect(property.fullAddress, '123 Main St, Unit 4A, New York, NY 10001');
      });

      test('should handle missing parts', () {
        const property = PropertyModel(
          id: 1,
          name: 'Test',
          address: '123 Main St',
          city: 'New York',
        );

        expect(property.fullAddress, '123 Main St, New York');
      });

      test('should handle state only', () {
        const property = PropertyModel(
          id: 1,
          name: 'Test',
          state: 'NY',
        );

        expect(property.fullAddress, 'NY');
      });

      test('should handle zipCode only', () {
        const property = PropertyModel(
          id: 1,
          name: 'Test',
          zipCode: '10001',
        );

        expect(property.fullAddress, '10001');
      });
    });

    group('shortAddress', () {
      test('should return address with unit', () {
        const property = PropertyModel(
          id: 1,
          name: 'Test Property',
          address: '123 Main St',
          unitNumber: '4A',
        );

        expect(property.shortAddress, '123 Main St, Unit 4A');
      });

      test('should return address only when no unit', () {
        const property = PropertyModel(
          id: 1,
          name: 'Test Property',
          address: '123 Main St',
        );

        expect(property.shortAddress, '123 Main St');
      });

      test('should return name when no address', () {
        const property = PropertyModel(
          id: 1,
          name: 'Test Property',
        );

        expect(property.shortAddress, 'Test Property');
      });
    });

    group('bedBathSummary', () {
      test('should return bed and bath', () {
        const property = PropertyModel(
          id: 1,
          name: 'Test',
          bedrooms: 2,
          bathrooms: 1,
        );

        expect(property.bedBathSummary, '2 bed / 1 bath');
      });

      test('should return bed only', () {
        const property = PropertyModel(
          id: 1,
          name: 'Test',
          bedrooms: 3,
        );

        expect(property.bedBathSummary, '3 bed');
      });

      test('should return bath only', () {
        const property = PropertyModel(
          id: 1,
          name: 'Test',
          bathrooms: 2,
        );

        expect(property.bedBathSummary, '2 bath');
      });

      test('should return empty when no bed or bath', () {
        const property = PropertyModel(
          id: 1,
          name: 'Test',
        );

        expect(property.bedBathSummary, '');
      });
    });

    group('status checks', () {
      test('isAvailable should return true for available status', () {
        const property = PropertyModel(
          id: 1,
          name: 'Test',
          status: PropertyStatus.available,
        );

        expect(property.isAvailable, isTrue);
        expect(property.isOccupied, isFalse);
      });

      test('isOccupied should return true for occupied status', () {
        const property = PropertyModel(
          id: 1,
          name: 'Test',
          status: PropertyStatus.occupied,
        );

        expect(property.isOccupied, isTrue);
        expect(property.isAvailable, isFalse);
      });
    });

    group('JSON serialization', () {
      test('should serialize to JSON', () {
        const property = PropertyModel(
          id: 1,
          name: 'Test Property',
          status: PropertyStatus.occupied,
          bedrooms: 2,
        );

        final json = property.toJson();

        expect(json['id'], 1);
        expect(json['name'], 'Test Property');
        expect(json['status'], 'occupied');
        expect(json['bedrooms'], 2);
      });

      test('should deserialize from JSON', () {
        final json = {
          'id': 1,
          'name': 'Test Property',
          'property_type': 'apartment',
          'status': 'maintenance',
          'city': 'Boston',
          'is_active': true,
        };

        final property = PropertyModel.fromJson(json);

        expect(property.id, 1);
        expect(property.name, 'Test Property');
        expect(property.propertyType, 'apartment');
        expect(property.status, PropertyStatus.maintenance);
        expect(property.city, 'Boston');
        expect(property.isActive, isTrue);
      });
    });

    group('copyWith', () {
      test('should create copy with updated fields', () {
        const original = PropertyModel(
          id: 1,
          name: 'Original',
          status: PropertyStatus.available,
        );

        final updated = original.copyWith(
          name: 'Updated',
          status: PropertyStatus.occupied,
        );

        expect(original.name, 'Original');
        expect(original.status, PropertyStatus.available);
        expect(updated.name, 'Updated');
        expect(updated.status, PropertyStatus.occupied);
        expect(updated.id, original.id);
      });
    });

    group('equality', () {
      test('should be equal when all fields match', () {
        const property1 = PropertyModel(id: 1, name: 'Test');
        const property2 = PropertyModel(id: 1, name: 'Test');

        expect(property1, equals(property2));
      });

      test('should not be equal when fields differ', () {
        const property1 = PropertyModel(id: 1, name: 'Test');
        const property2 = PropertyModel(id: 2, name: 'Test');

        expect(property1, isNot(equals(property2)));
      });
    });
  });

  group('PropertyStatus', () {
    test('should have correct values', () {
      expect(PropertyStatus.available.value, 'available');
      expect(PropertyStatus.occupied.value, 'occupied');
      expect(PropertyStatus.maintenance.value, 'maintenance');
      expect(PropertyStatus.reserved.value, 'reserved');
      expect(PropertyStatus.inactive.value, 'inactive');
    });

    test('should have display names', () {
      expect(PropertyStatus.available.displayName, 'Available');
      expect(PropertyStatus.occupied.displayName, 'Occupied');
      expect(PropertyStatus.maintenance.displayName, 'Under Maintenance');
      expect(PropertyStatus.reserved.displayName, 'Reserved');
      expect(PropertyStatus.inactive.displayName, 'Inactive');
    });
  });
}
