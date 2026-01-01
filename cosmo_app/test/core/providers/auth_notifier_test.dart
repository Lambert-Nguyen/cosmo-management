import 'package:flutter_test/flutter_test.dart';
import 'package:cosmo_app/core/providers/auth_notifier.dart';
import 'package:cosmo_app/core/services/auth_service.dart';

void main() {
  group('AuthNotifierState', () {
    test('AuthInitial should be a valid state', () {
      const state = AuthInitial();
      expect(state, isA<AuthNotifierState>());
    });

    test('AuthLoading should store optional message', () {
      const stateWithoutMessage = AuthLoading();
      expect(stateWithoutMessage.message, isNull);

      const stateWithMessage = AuthLoading('Loading...');
      expect(stateWithMessage.message, 'Loading...');
    });

    test('AuthAuthenticated should store user', () {
      const user = AuthUser(
        id: 1,
        email: 'test@example.com',
        firstName: 'John',
        lastName: 'Doe',
        role: 'manager',
      );
      final state = AuthAuthenticated(user);

      expect(state.user, user);
      expect(state.user.id, 1);
      expect(state.user.email, 'test@example.com');
    });

    test('AuthUnauthenticated should be a valid state', () {
      const state = AuthUnauthenticated();
      expect(state, isA<AuthNotifierState>());
    });

    test('AuthError should store message and optional fieldErrors', () {
      const errorWithoutFieldErrors = AuthError('Something went wrong');
      expect(errorWithoutFieldErrors.message, 'Something went wrong');
      expect(errorWithoutFieldErrors.fieldErrors, isEmpty);

      const errorWithFieldErrors = AuthError(
        'Validation failed',
        fieldErrors: {
          'email': ['Invalid email format'],
          'password': ['Password too short'],
        },
      );
      expect(errorWithFieldErrors.message, 'Validation failed');
      expect(errorWithFieldErrors.fieldErrors, hasLength(2));
      expect(errorWithFieldErrors.fieldErrors['email'], contains('Invalid email format'));
      expect(errorWithFieldErrors.fieldErrors['password'], contains('Password too short'));
    });

    test('PasswordResetSent should store email', () {
      const state = PasswordResetSent('user@example.com');
      expect(state.email, 'user@example.com');
    });

    test('PasswordResetComplete should be a valid state', () {
      const state = PasswordResetComplete();
      expect(state, isA<AuthNotifierState>());
    });

    test('InviteValidated should store validation', () {
      const validation = InviteValidation(
        isValid: true,
        role: 'staff',
        email: 'staff@example.com',
      );
      final state = InviteValidated(validation);

      expect(state.validation, validation);
      expect(state.validation.isValid, isTrue);
      expect(state.validation.role, 'staff');
    });
  });

  group('AuthNotifierState pattern matching', () {
    test('should be able to pattern match on states', () {
      final states = <AuthNotifierState>[
        const AuthInitial(),
        const AuthLoading('Testing'),
        const AuthAuthenticated(AuthUser(id: 1, email: 'test@example.com')),
        const AuthUnauthenticated(),
        const AuthError('Error'),
        const PasswordResetSent('test@example.com'),
        const PasswordResetComplete(),
        const InviteValidated(InviteValidation(isValid: true)),
      ];

      for (final state in states) {
        final result = switch (state) {
          AuthInitial() => 'initial',
          AuthLoading() => 'loading',
          AuthAuthenticated() => 'authenticated',
          AuthUnauthenticated() => 'unauthenticated',
          AuthError() => 'error',
          PasswordResetSent() => 'reset_sent',
          PasswordResetComplete() => 'reset_complete',
          InviteValidated() => 'invite_validated',
        };
        expect(result, isNotEmpty);
      }
    });
  });

  group('AuthNotifierState equality', () {
    test('AuthInitial instances should be equal', () {
      const state1 = AuthInitial();
      const state2 = AuthInitial();
      // They are the same const instance
      expect(identical(state1, state2), isTrue);
    });

    test('AuthLoading with same message should be equal', () {
      const state1 = AuthLoading('Loading');
      const state2 = AuthLoading('Loading');
      expect(identical(state1, state2), isTrue);
    });

    test('AuthUnauthenticated instances should be equal', () {
      const state1 = AuthUnauthenticated();
      const state2 = AuthUnauthenticated();
      expect(identical(state1, state2), isTrue);
    });

    test('AuthError with same message should be equal', () {
      const state1 = AuthError('Error');
      const state2 = AuthError('Error');
      expect(identical(state1, state2), isTrue);
    });

    test('PasswordResetSent with same email should be equal', () {
      const state1 = PasswordResetSent('test@example.com');
      const state2 = PasswordResetSent('test@example.com');
      expect(identical(state1, state2), isTrue);
    });

    test('PasswordResetComplete instances should be equal', () {
      const state1 = PasswordResetComplete();
      const state2 = PasswordResetComplete();
      expect(identical(state1, state2), isTrue);
    });
  });

  group('AuthNotifierState type checks', () {
    test('should correctly identify AuthInitial', () {
      const AuthNotifierState state = AuthInitial();
      expect(state is AuthInitial, isTrue);
      expect(state is AuthLoading, isFalse);
      expect(state is AuthAuthenticated, isFalse);
    });

    test('should correctly identify AuthLoading', () {
      const AuthNotifierState state = AuthLoading();
      expect(state is AuthInitial, isFalse);
      expect(state is AuthLoading, isTrue);
      expect(state is AuthAuthenticated, isFalse);
    });

    test('should correctly identify AuthAuthenticated', () {
      const AuthNotifierState state = AuthAuthenticated(
        AuthUser(id: 1, email: 'test@example.com'),
      );
      expect(state is AuthInitial, isFalse);
      expect(state is AuthLoading, isFalse);
      expect(state is AuthAuthenticated, isTrue);
    });

    test('should correctly identify AuthUnauthenticated', () {
      const AuthNotifierState state = AuthUnauthenticated();
      expect(state is AuthAuthenticated, isFalse);
      expect(state is AuthUnauthenticated, isTrue);
    });

    test('should correctly identify AuthError', () {
      const AuthNotifierState state = AuthError('Error');
      expect(state is AuthAuthenticated, isFalse);
      expect(state is AuthError, isTrue);
    });

    test('should correctly identify PasswordResetSent', () {
      const AuthNotifierState state = PasswordResetSent('test@example.com');
      expect(state is AuthError, isFalse);
      expect(state is PasswordResetSent, isTrue);
    });

    test('should correctly identify PasswordResetComplete', () {
      const AuthNotifierState state = PasswordResetComplete();
      expect(state is PasswordResetSent, isFalse);
      expect(state is PasswordResetComplete, isTrue);
    });

    test('should correctly identify InviteValidated', () {
      const AuthNotifierState state = InviteValidated(
        InviteValidation(isValid: true),
      );
      expect(state is AuthError, isFalse);
      expect(state is InviteValidated, isTrue);
    });
  });

  group('AuthError fieldErrors', () {
    test('should handle empty fieldErrors', () {
      const error = AuthError('Error');
      expect(error.fieldErrors, isA<Map<String, List<String>>>());
      expect(error.fieldErrors, isEmpty);
    });

    test('should handle single field error', () {
      const error = AuthError(
        'Validation failed',
        fieldErrors: {
          'email': ['Invalid email'],
        },
      );
      expect(error.fieldErrors, hasLength(1));
      expect(error.fieldErrors['email'], hasLength(1));
      expect(error.fieldErrors['email']!.first, 'Invalid email');
    });

    test('should handle multiple errors per field', () {
      const error = AuthError(
        'Validation failed',
        fieldErrors: {
          'password': [
            'Password too short',
            'Password must contain a number',
            'Password must contain uppercase',
          ],
        },
      );
      expect(error.fieldErrors['password'], hasLength(3));
    });

    test('should handle multiple fields with multiple errors', () {
      const error = AuthError(
        'Validation failed',
        fieldErrors: {
          'email': ['Invalid email', 'Email already exists'],
          'password': ['Too short', 'No number'],
          'first_name': ['Required'],
        },
      );
      expect(error.fieldErrors, hasLength(3));
      expect(error.fieldErrors['email'], hasLength(2));
      expect(error.fieldErrors['password'], hasLength(2));
      expect(error.fieldErrors['first_name'], hasLength(1));
    });
  });
}
