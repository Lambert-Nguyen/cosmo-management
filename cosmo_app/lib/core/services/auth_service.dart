/// Authentication service for Cosmo Management
///
/// Handles JWT-based authentication with the Django backend.
library;

import 'dart:async';

import 'package:dio/dio.dart';

import '../config/api_config.dart';
import '../config/env_config.dart';
import 'api_exception.dart';
import 'auth_interceptor.dart';

/// Authentication state
enum AuthState {
  /// Initial state, not yet checked
  unknown,

  /// User is authenticated
  authenticated,

  /// User is not authenticated
  unauthenticated,
}

/// User data from authentication
class AuthUser {
  final int id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? role;

  const AuthUser({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.role,
  });

  String get displayName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    }
    if (firstName != null) return firstName!;
    return email;
  }

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] as int,
      email: json['email'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      role: json['role'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'role': role,
    };
  }
}

/// Service for handling user authentication
///
/// Features:
/// - JWT token-based authentication
/// - Automatic token persistence
/// - Auth state streaming
/// - User profile fetching
class AuthService {
  final AuthInterceptor _authInterceptor;
  final Dio _dio;

  final _authStateController = StreamController<AuthState>.broadcast();
  AuthState _currentState = AuthState.unknown;
  AuthUser? _currentUser;

  AuthService({AuthInterceptor? authInterceptor})
      : _authInterceptor = authInterceptor ?? AuthInterceptor(),
        _dio = Dio(BaseOptions(
          baseUrl: EnvConfig.apiBaseUrl,
          connectTimeout: Duration(seconds: EnvConfig.connectTimeoutSeconds),
          receiveTimeout: Duration(seconds: EnvConfig.receiveTimeoutSeconds),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ));

  /// Stream of authentication state changes
  Stream<AuthState> get authStateChanges => _authStateController.stream;

  /// Current authentication state
  AuthState get currentState => _currentState;

  /// Currently authenticated user (null if not authenticated)
  AuthUser? get currentUser => _currentUser;

  /// Whether the user is currently authenticated
  bool get isAuthenticated => _currentState == AuthState.authenticated;

  /// Get the auth interceptor for use with ApiService
  AuthInterceptor get authInterceptor => _authInterceptor;

  /// Initialize auth service and check existing tokens
  Future<void> init() async {
    final hasTokens = await _authInterceptor.hasTokens();

    if (hasTokens) {
      // Verify token is still valid
      final isValid = await _verifyToken();
      if (isValid) {
        await _fetchCurrentUser();
        _updateState(AuthState.authenticated);
      } else {
        // Try to refresh
        final refreshToken = await _authInterceptor.getRefreshToken();
        if (refreshToken != null) {
          final refreshed = await _refreshToken(refreshToken);
          if (refreshed) {
            await _fetchCurrentUser();
            _updateState(AuthState.authenticated);
            return;
          }
        }
        await _authInterceptor.clearTokens();
        _updateState(AuthState.unauthenticated);
      }
    } else {
      _updateState(AuthState.unauthenticated);
    }
  }

  /// Log in with email and password
  Future<AuthUser> login(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiConfig.tokenObtain,
        data: {
          'email': email,
          'password': password,
        },
      );

      final accessToken = response.data['access'] as String;
      final refreshToken = response.data['refresh'] as String;

      await _authInterceptor.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      await _fetchCurrentUser();
      _updateState(AuthState.authenticated);

      return _currentUser!;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const UnauthorizedException(
          message: 'Invalid email or password',
        );
      }
      rethrow;
    }
  }

  /// Log out the current user
  Future<void> logout() async {
    try {
      final refreshToken = await _authInterceptor.getRefreshToken();
      if (refreshToken != null) {
        final accessToken = await _authInterceptor.getAccessToken();
        await _dio.post(
          ApiConfig.tokenRevoke,
          data: {'refresh': refreshToken},
          options: Options(
            headers: {'Authorization': 'Bearer $accessToken'},
          ),
        );
      }
    } catch (e) {
      // Ignore errors during logout - we'll clear tokens anyway
    } finally {
      await _authInterceptor.clearTokens();
      _currentUser = null;
      _updateState(AuthState.unauthenticated);
    }
  }

  /// Log out from all devices
  Future<void> logoutAll() async {
    try {
      final accessToken = await _authInterceptor.getAccessToken();
      if (accessToken != null) {
        await _dio.post(
          ApiConfig.tokenRevokeAll,
          options: Options(
            headers: {'Authorization': 'Bearer $accessToken'},
          ),
        );
      }
    } catch (e) {
      // Ignore errors during logout
    } finally {
      await _authInterceptor.clearTokens();
      _currentUser = null;
      _updateState(AuthState.unauthenticated);
    }
  }

  /// Verify the current token is valid
  Future<bool> _verifyToken() async {
    try {
      final accessToken = await _authInterceptor.getAccessToken();
      if (accessToken == null) return false;

      await _dio.post(
        ApiConfig.tokenVerify,
        data: {'token': accessToken},
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Refresh the access token
  Future<bool> _refreshToken(String refreshToken) async {
    try {
      final response = await _dio.post(
        ApiConfig.tokenRefresh,
        data: {'refresh': refreshToken},
      );

      final newAccessToken = response.data['access'] as String;
      await _authInterceptor.saveTokens(
        accessToken: newAccessToken,
        refreshToken: refreshToken,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Fetch the current user's profile
  Future<void> _fetchCurrentUser() async {
    try {
      final accessToken = await _authInterceptor.getAccessToken();
      if (accessToken == null) return;

      final response = await _dio.get(
        ApiConfig.userMe,
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );

      _currentUser = AuthUser.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      // User fetch failed, but we might still have valid auth
      _currentUser = null;
    }
  }

  /// Update authentication state and notify listeners
  void _updateState(AuthState state) {
    _currentState = state;
    _authStateController.add(state);
  }

  /// Dispose resources
  void dispose() {
    _authStateController.close();
  }
}
