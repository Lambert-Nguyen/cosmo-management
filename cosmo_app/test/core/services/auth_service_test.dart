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
