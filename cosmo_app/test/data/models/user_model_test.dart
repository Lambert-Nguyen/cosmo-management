import 'package:flutter_test/flutter_test.dart';
import 'package:cosmo_app/data/models/user_model.dart';

void main() {
  group('UserModel', () {
    test('should create user with required fields', () {
      const user = UserModel(
        id: 1,
        email: 'test@example.com',
      );

      expect(user.id, 1);
      expect(user.email, 'test@example.com');
    });

    test('should create user with all fields', () {
      final user = UserModel(
        id: 1,
        email: 'test@example.com',
        firstName: 'John',
        lastName: 'Doe',
        role: 'manager',
        phoneNumber: '+1234567890',
        isActive: true,
        dateJoined: DateTime(2024, 1, 1),
      );

      expect(user.firstName, 'John');
      expect(user.lastName, 'Doe');
      expect(user.role, 'manager');
      expect(user.phoneNumber, '+1234567890');
      expect(user.isActive, isTrue);
    });

    group('fullName', () {
      test('should return full name when both names present', () {
        const user = UserModel(
          id: 1,
          email: 'test@example.com',
          firstName: 'John',
          lastName: 'Doe',
        );

        expect(user.fullName, 'John Doe');
      });

      test('should return first name only when last name is null', () {
        const user = UserModel(
          id: 1,
          email: 'test@example.com',
          firstName: 'John',
        );

        expect(user.fullName, 'John');
      });

      test('should return email prefix when no names', () {
        const user = UserModel(
          id: 1,
          email: 'test@example.com',
        );

        expect(user.fullName, 'test');
      });
    });

    group('initials', () {
      test('should return initials from both names', () {
        const user = UserModel(
          id: 1,
          email: 'test@example.com',
          firstName: 'John',
          lastName: 'Doe',
        );

        expect(user.initials, 'JD');
      });

      test('should return first initial when only first name', () {
        const user = UserModel(
          id: 1,
          email: 'test@example.com',
          firstName: 'John',
        );

        expect(user.initials, 'J');
      });

      test('should return email initial when no names', () {
        const user = UserModel(
          id: 1,
          email: 'test@example.com',
        );

        expect(user.initials, 'T');
      });
    });

    group('role checks', () {
      test('isManager should return true for manager role', () {
        const user = UserModel(
          id: 1,
          email: 'test@example.com',
          role: 'manager',
        );

        expect(user.isManager, isTrue);
        expect(user.isStaff, isFalse);
        expect(user.isAdmin, isFalse);
      });

      test('isStaff should return true for staff role', () {
        const user = UserModel(
          id: 1,
          email: 'test@example.com',
          role: 'staff',
        );

        expect(user.isStaff, isTrue);
        expect(user.isManager, isFalse);
      });

      test('isAdmin should return true for admin role', () {
        const user = UserModel(
          id: 1,
          email: 'test@example.com',
          role: 'admin',
        );

        expect(user.isAdmin, isTrue);
      });

      test('hasRole should be case insensitive', () {
        const user = UserModel(
          id: 1,
          email: 'test@example.com',
          role: 'MANAGER',
        );

        expect(user.hasRole('manager'), isTrue);
        expect(user.hasRole('Manager'), isTrue);
        expect(user.hasRole('MANAGER'), isTrue);
      });
    });

    group('JSON serialization', () {
      test('should serialize to JSON', () {
        const user = UserModel(
          id: 1,
          email: 'test@example.com',
          firstName: 'John',
          lastName: 'Doe',
        );

        final json = user.toJson();

        expect(json['id'], 1);
        expect(json['email'], 'test@example.com');
        expect(json['first_name'], 'John');
        expect(json['last_name'], 'Doe');
      });

      test('should deserialize from JSON', () {
        final json = {
          'id': 1,
          'email': 'test@example.com',
          'first_name': 'John',
          'last_name': 'Doe',
          'role': 'staff',
          'is_active': true,
        };

        final user = UserModel.fromJson(json);

        expect(user.id, 1);
        expect(user.email, 'test@example.com');
        expect(user.firstName, 'John');
        expect(user.lastName, 'Doe');
        expect(user.role, 'staff');
        expect(user.isActive, isTrue);
      });
    });

    group('copyWith', () {
      test('should create copy with updated fields', () {
        const original = UserModel(
          id: 1,
          email: 'test@example.com',
          firstName: 'John',
        );

        final updated = original.copyWith(firstName: 'Jane');

        expect(original.firstName, 'John');
        expect(updated.firstName, 'Jane');
        expect(updated.id, original.id);
        expect(updated.email, original.email);
      });
    });

    group('equality', () {
      test('should be equal when all fields match', () {
        const user1 = UserModel(id: 1, email: 'test@example.com');
        const user2 = UserModel(id: 1, email: 'test@example.com');

        expect(user1, equals(user2));
      });

      test('should not be equal when fields differ', () {
        const user1 = UserModel(id: 1, email: 'test@example.com');
        const user2 = UserModel(id: 2, email: 'test@example.com');

        expect(user1, isNot(equals(user2)));
      });
    });
  });
}
