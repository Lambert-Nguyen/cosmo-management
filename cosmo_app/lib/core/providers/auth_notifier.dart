/// Auth notifier for Cosmo Management
///
/// Riverpod state notifier for authentication state management.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/api_exception.dart';
import '../services/auth_service.dart';

/// Auth state for the notifier
sealed class AuthNotifierState {
  const AuthNotifierState();
}

/// Initial/unknown state
class AuthInitial extends AuthNotifierState {
  const AuthInitial();
}

/// Loading state during auth operations
class AuthLoading extends AuthNotifierState {
  final String? message;
  const AuthLoading([this.message]);
}

/// Authenticated state with user data
class AuthAuthenticated extends AuthNotifierState {
  final AuthUser user;
  const AuthAuthenticated(this.user);
}

/// Unauthenticated state
class AuthUnauthenticated extends AuthNotifierState {
  const AuthUnauthenticated();
}

/// Error state with message and optional field errors
class AuthError extends AuthNotifierState {
  final String message;
  final Map<String, List<String>> fieldErrors;
  const AuthError(this.message, {this.fieldErrors = const {}});
}

/// Password reset email sent successfully
class PasswordResetSent extends AuthNotifierState {
  final String email;
  const PasswordResetSent(this.email);
}

/// Password reset completed successfully
class PasswordResetComplete extends AuthNotifierState {
  const PasswordResetComplete();
}

/// Invite code validated successfully
class InviteValidated extends AuthNotifierState {
  final InviteValidation validation;
  const InviteValidated(this.validation);
}

/// Auth state notifier
///
/// Manages authentication state and provides login/logout functionality.
class AuthNotifier extends StateNotifier<AuthNotifierState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AuthInitial()) {
    _init();
  }

  /// Initialize and check existing auth state
  Future<void> _init() async {
    _authService.authStateChanges.listen((authState) {
      switch (authState) {
        case AuthState.authenticated:
          final user = _authService.currentUser;
          if (user != null) {
            state = AuthAuthenticated(user);
          } else {
            state = const AuthUnauthenticated();
          }
        case AuthState.unauthenticated:
          state = const AuthUnauthenticated();
        case AuthState.unknown:
          state = const AuthInitial();
      }
    });

    // Check current state
    if (_authService.currentState == AuthState.authenticated) {
      final user = _authService.currentUser;
      if (user != null) {
        state = AuthAuthenticated(user);
      }
    } else if (_authService.currentState == AuthState.unauthenticated) {
      state = const AuthUnauthenticated();
    }
  }

  /// Login with email and password
  Future<void> login(String email, String password) async {
    state = const AuthLoading('Signing in...');

    try {
      final user = await _authService.login(email, password);
      state = AuthAuthenticated(user);
    } catch (e) {
      _handleError(e);
    }
  }

  /// Register a new user with invite code
  Future<void> register({
    required String email,
    required String password,
    required String inviteCode,
    String? firstName,
    String? lastName,
  }) async {
    state = const AuthLoading('Creating account...');

    try {
      final user = await _authService.register(
        email: email,
        password: password,
        inviteCode: inviteCode,
        firstName: firstName,
        lastName: lastName,
      );
      state = AuthAuthenticated(user);
    } catch (e) {
      _handleError(e);
    }
  }

  /// Validate an invite code
  Future<void> validateInviteCode(String code) async {
    state = const AuthLoading('Validating invite code...');

    try {
      final validation = await _authService.validateInviteCode(code);
      state = InviteValidated(validation);
    } catch (e) {
      _handleError(e);
    }
  }

  /// Request password reset email
  Future<void> requestPasswordReset(String email) async {
    state = const AuthLoading('Sending reset email...');

    try {
      await _authService.requestPasswordReset(email);
      state = PasswordResetSent(email);
    } catch (e) {
      _handleError(e);
    }
  }

  /// Confirm password reset with token
  Future<void> confirmPasswordReset({
    required String token,
    required String uid,
    required String newPassword,
  }) async {
    state = const AuthLoading('Resetting password...');

    try {
      await _authService.confirmPasswordReset(
        token: token,
        uid: uid,
        newPassword: newPassword,
      );
      state = const PasswordResetComplete();
    } catch (e) {
      _handleError(e);
    }
  }

  /// Reset state to unauthenticated (for clearing errors)
  void resetToUnauthenticated() {
    state = const AuthUnauthenticated();
  }

  /// Logout current user
  Future<void> logout() async {
    state = const AuthLoading('Signing out...');

    try {
      await _authService.logout();
      state = const AuthUnauthenticated();
    } catch (e) {
      // Still logout locally even if server call fails
      state = const AuthUnauthenticated();
    }
  }

  /// Logout from all devices
  Future<void> logoutAll() async {
    state = const AuthLoading('Signing out from all devices...');

    try {
      await _authService.logoutAll();
      state = const AuthUnauthenticated();
    } catch (e) {
      state = const AuthUnauthenticated();
    }
  }

  /// Handle errors and update state
  void _handleError(Object error) {
    if (error is ValidationException) {
      state = AuthError(error.message, fieldErrors: error.fieldErrors ?? const {});
    } else {
      state = AuthError(error.toString());
    }
    // Auto-reset to unauthenticated after showing error
    _scheduleErrorReset();
  }

  /// Schedule automatic reset from error state
  void _scheduleErrorReset() {
    Future.delayed(const Duration(seconds: 5), () {
      if (state is AuthError) {
        state = const AuthUnauthenticated();
      }
    });
  }

  /// Get current user if authenticated
  AuthUser? get currentUser {
    final currentState = state;
    if (currentState is AuthAuthenticated) {
      return currentState.user;
    }
    return null;
  }

  /// Check if user is authenticated
  bool get isAuthenticated => state is AuthAuthenticated;
}
