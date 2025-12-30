/// Auth notifier for Cosmo Management
///
/// Riverpod state notifier for authentication state management.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  const AuthLoading();
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

/// Error state with message
class AuthError extends AuthNotifierState {
  final String message;
  const AuthError(this.message);
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
    state = const AuthLoading();

    try {
      final user = await _authService.login(email, password);
      state = AuthAuthenticated(user);
    } catch (e) {
      state = AuthError(e.toString());
      // Reset to unauthenticated after showing error
      await Future.delayed(const Duration(seconds: 3));
      if (state is AuthError) {
        state = const AuthUnauthenticated();
      }
    }
  }

  /// Logout current user
  Future<void> logout() async {
    state = const AuthLoading();

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
    state = const AuthLoading();

    try {
      await _authService.logoutAll();
      state = const AuthUnauthenticated();
    } catch (e) {
      state = const AuthUnauthenticated();
    }
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
