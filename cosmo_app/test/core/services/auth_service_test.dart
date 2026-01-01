import 'package:flutter_test/flutter_test.dart';
import 'package:cosmo_app/core/services/auth_service.dart';

void main() {
  group('AuthState', () {
    test('should have unknown state', () {
      expect(AuthState.unknown, isNotNull);
      expect(AuthState.unknown.name, 'unknown');
    });

    test('should have authenticated state', () {
      expect(AuthState.authenticated, isNotNull);
      expect(AuthState.authenticated.name, 'authenticated');
    });

    test('should have unauthenticated state', () {
      expect(AuthState.unauthenticated, isNotNull);
      expect(AuthState.unauthenticated.name, 'unauthenticated');
    });
  });

  group('AuthUser', () {
    test('should create AuthUser with required fields', () {
      const user = AuthUser(
        id: 1,
        email: 'test@example.com',
      );

      expect(user.id, 1);
      expect(user.email, 'test@example.com');
      expect(user.firstName, isNull);
      expect(user.lastName, isNull);
      expect(user.role, isNull);
    });

    test('should create AuthUser with all fields', () {
      const user = AuthUser(
        id: 1,
        email: 'test@example.com',
        firstName: 'John',
        lastName: 'Doe',
        role: 'manager',
      );

      expect(user.firstName, 'John');
      expect(user.lastName, 'Doe');
      expect(user.role, 'manager');
    });

    group('displayName', () {
      test('should return full name when both names present', () {
        const user = AuthUser(
          id: 1,
          email: 'test@example.com',
          firstName: 'John',
          lastName: 'Doe',
        );

        expect(user.displayName, 'John Doe');
      });

      test('should return first name only when last name is null', () {
        const user = AuthUser(
          id: 1,
          email: 'test@example.com',
          firstName: 'John',
        );

        expect(user.displayName, 'John');
      });

      test('should return email when no names', () {
        const user = AuthUser(
          id: 1,
          email: 'test@example.com',
        );

        expect(user.displayName, 'test@example.com');
      });
    });

    group('JSON serialization', () {
      test('should serialize to JSON', () {
        const user = AuthUser(
          id: 1,
          email: 'test@example.com',
          firstName: 'John',
          lastName: 'Doe',
          role: 'staff',
        );

        final json = user.toJson();

        expect(json['id'], 1);
        expect(json['email'], 'test@example.com');
        expect(json['first_name'], 'John');
        expect(json['last_name'], 'Doe');
        expect(json['role'], 'staff');
      });

      test('should deserialize from JSON', () {
        final json = {
          'id': 1,
          'email': 'test@example.com',
          'first_name': 'Jane',
          'last_name': 'Smith',
          'role': 'admin',
        };

        final user = AuthUser.fromJson(json);

        expect(user.id, 1);
        expect(user.email, 'test@example.com');
        expect(user.firstName, 'Jane');
        expect(user.lastName, 'Smith');
        expect(user.role, 'admin');
      });

      test('should handle null optional fields in JSON', () {
        final json = {
          'id': 1,
          'email': 'test@example.com',
        };

        final user = AuthUser.fromJson(json);

        expect(user.id, 1);
        expect(user.email, 'test@example.com');
        expect(user.firstName, isNull);
        expect(user.lastName, isNull);
        expect(user.role, isNull);
      });
    });
  });

  group('InviteValidation', () {
    test('should create InviteValidation with required fields', () {
      const validation = InviteValidation(isValid: true);

      expect(validation.isValid, isTrue);
      expect(validation.role, isNull);
      expect(validation.email, isNull);
      expect(validation.expiresAt, isNull);
      expect(validation.message, isNull);
    });

    test('should create InviteValidation with all fields', () {
      final expiresAt = DateTime(2025, 12, 31);
      final validation = InviteValidation(
        isValid: true,
        role: 'staff',
        email: 'test@example.com',
        expiresAt: expiresAt,
        message: 'Valid invite code',
      );

      expect(validation.isValid, isTrue);
      expect(validation.role, 'staff');
      expect(validation.email, 'test@example.com');
      expect(validation.expiresAt, expiresAt);
      expect(validation.message, 'Valid invite code');
    });

    group('JSON deserialization', () {
      test('should deserialize from JSON with "valid" key', () {
        final json = {
          'valid': true,
          'role': 'manager',
          'email': 'manager@example.com',
        };

        final validation = InviteValidation.fromJson(json);

        expect(validation.isValid, isTrue);
        expect(validation.role, 'manager');
        expect(validation.email, 'manager@example.com');
      });

      test('should deserialize from JSON with "is_valid" key', () {
        final json = {
          'is_valid': true,
          'role': 'staff',
        };

        final validation = InviteValidation.fromJson(json);

        expect(validation.isValid, isTrue);
        expect(validation.role, 'staff');
      });

      test('should default to true when no valid key present', () {
        final json = <String, dynamic>{
          'role': 'owner',
        };

        final validation = InviteValidation.fromJson(json);

        expect(validation.isValid, isTrue);
      });

      test('should parse expires_at date', () {
        final json = {
          'valid': true,
          'expires_at': '2025-12-31T23:59:59.000Z',
        };

        final validation = InviteValidation.fromJson(json);

        expect(validation.expiresAt, isNotNull);
        expect(validation.expiresAt!.year, 2025);
        expect(validation.expiresAt!.month, 12);
        expect(validation.expiresAt!.day, 31);
      });

      test('should handle invalid expires_at date gracefully', () {
        final json = {
          'valid': true,
          'expires_at': 'invalid-date',
        };

        final validation = InviteValidation.fromJson(json);

        expect(validation.expiresAt, isNull);
      });

      test('should handle null expires_at', () {
        final json = {
          'valid': true,
          'expires_at': null,
        };

        final validation = InviteValidation.fromJson(json);

        expect(validation.expiresAt, isNull);
      });

      test('should parse message field', () {
        final json = {
          'valid': true,
          'message': 'Invite valid for 24 hours',
        };

        final validation = InviteValidation.fromJson(json);

        expect(validation.message, 'Invite valid for 24 hours');
      });
    });
  });

  group('AuthService', () {
    late AuthService authService;

    setUp(() {
      authService = AuthService();
    });

    test('should create AuthService instance', () {
      expect(authService, isNotNull);
    });

    test('should start with unknown state', () {
      expect(authService.currentState, AuthState.unknown);
    });

    test('should not be authenticated initially', () {
      expect(authService.isAuthenticated, isFalse);
    });

    test('should not have current user initially', () {
      expect(authService.currentUser, isNull);
    });

    test('should expose authStateChanges stream', () {
      expect(authService.authStateChanges, isA<Stream<AuthState>>());
    });

    test('should expose authInterceptor', () {
      expect(authService.authInterceptor, isNotNull);
    });

    test('should be able to dispose', () {
      // Should not throw
      expect(() => authService.dispose(), returnsNormally);
    });
  });
}
