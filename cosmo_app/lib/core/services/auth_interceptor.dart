/// Authentication interceptor for Dio HTTP client
///
/// Handles JWT token injection and automatic token refresh.
library;

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../config/api_config.dart';
import '../config/env_config.dart';

/// Interceptor that handles JWT authentication
///
/// - Automatically adds access token to requests
/// - Refreshes token on 401 responses
/// - Queues requests during token refresh
class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _secureStorage;
  final Dio _tokenDio;

  bool _isRefreshing = false;
  final List<Completer<String?>> _pendingRequests = [];

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  AuthInterceptor({
    FlutterSecureStorage? secureStorage,
  })  : _secureStorage = secureStorage ?? const FlutterSecureStorage(),
        _tokenDio = Dio(BaseOptions(
          baseUrl: EnvConfig.apiBaseUrl,
          connectTimeout: Duration(seconds: EnvConfig.connectTimeoutSeconds),
          receiveTimeout: Duration(seconds: EnvConfig.receiveTimeoutSeconds),
        ));

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth header for token endpoints
    if (_isTokenEndpoint(options.path)) {
      return handler.next(options);
    }

    final accessToken = await _secureStorage.read(key: _accessTokenKey);
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    handler.next(options);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    // Skip retry for token endpoints
    if (_isTokenEndpoint(err.requestOptions.path)) {
      return handler.next(err);
    }

    // Attempt token refresh
    final newToken = await _refreshToken();
    if (newToken == null) {
      return handler.next(err);
    }

    // Retry the failed request with new token
    try {
      final opts = err.requestOptions;
      opts.headers['Authorization'] = 'Bearer $newToken';

      final response = await _tokenDio.fetch(opts);
      return handler.resolve(response);
    } catch (e) {
      return handler.next(err);
    }
  }

  /// Refresh the access token using the refresh token
  ///
  /// Returns the new access token on success, null on failure.
  /// Queues concurrent requests to avoid multiple refresh calls.
  Future<String?> _refreshToken() async {
    if (_isRefreshing) {
      // Wait for the current refresh to complete
      final completer = Completer<String?>();
      _pendingRequests.add(completer);
      return completer.future;
    }

    _isRefreshing = true;

    try {
      final refreshToken = await _secureStorage.read(key: _refreshTokenKey);
      if (refreshToken == null) {
        _completePendingRequests(null);
        return null;
      }

      final response = await _tokenDio.post(
        ApiConfig.tokenRefresh,
        data: {'refresh': refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['access'] as String;
        await _secureStorage.write(
          key: _accessTokenKey,
          value: newAccessToken,
        );

        _completePendingRequests(newAccessToken);
        return newAccessToken;
      }

      _completePendingRequests(null);
      return null;
    } catch (e) {
      // Clear tokens on refresh failure
      await clearTokens();
      _completePendingRequests(null);
      return null;
    } finally {
      _isRefreshing = false;
    }
  }

  /// Complete all pending requests with the given token (or null on failure)
  void _completePendingRequests(String? token) {
    for (final completer in _pendingRequests) {
      if (!completer.isCompleted) {
        completer.complete(token);
      }
    }
    _pendingRequests.clear();
  }

  /// Check if the path is a token endpoint
  bool _isTokenEndpoint(String path) {
    return path.contains('/api/token/');
  }

  /// Save tokens to secure storage
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _secureStorage.write(key: _accessTokenKey, value: accessToken),
      _secureStorage.write(key: _refreshTokenKey, value: refreshToken),
    ]);
  }

  /// Clear tokens from secure storage
  Future<void> clearTokens() async {
    await Future.wait([
      _secureStorage.delete(key: _accessTokenKey),
      _secureStorage.delete(key: _refreshTokenKey),
    ]);
  }

  /// Get the current access token
  Future<String?> getAccessToken() async {
    return _secureStorage.read(key: _accessTokenKey);
  }

  /// Get the current refresh token
  Future<String?> getRefreshToken() async {
    return _secureStorage.read(key: _refreshTokenKey);
  }

  /// Check if tokens exist
  Future<bool> hasTokens() async {
    final accessToken = await _secureStorage.read(key: _accessTokenKey);
    return accessToken != null;
  }
}
