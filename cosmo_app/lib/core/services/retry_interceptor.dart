/// Retry interceptor for Dio HTTP client
///
/// Implements exponential backoff retry logic for transient failures.
library;

import 'dart:async';
import 'dart:math' as math;

import 'package:dio/dio.dart';

import '../config/env_config.dart';

/// Interceptor that handles automatic retries with exponential backoff
///
/// Retries on:
/// - Network errors (no connection)
/// - Timeout errors
/// - 408 Request Timeout
/// - 429 Too Many Requests
/// - 5xx Server Errors
class RetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration initialDelay;
  final double backoffMultiplier;
  final Dio? _retryDio;

  /// Creates a retry interceptor
  ///
  /// [retryDio] - Optional Dio instance for retries. If provided, retries will
  /// use this instance (which should have auth interceptors). If not provided,
  /// a basic Dio will be created (no auth on retries).
  RetryInterceptor({
    int? maxRetries,
    this.initialDelay = const Duration(milliseconds: 500),
    this.backoffMultiplier = 2.0,
    Dio? retryDio,
  })  : maxRetries = maxRetries ?? EnvConfig.maxRetryAttempts,
        _retryDio = retryDio;

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final retryCount = err.requestOptions.extra['retryCount'] as int? ?? 0;

    if (!_shouldRetry(err) || retryCount >= maxRetries) {
      return handler.next(err);
    }

    // Calculate delay with proper exponential backoff: delay * 2^retryCount
    // First retry: 500ms * 2^0 = 500ms
    // Second retry: 500ms * 2^1 = 1000ms
    // Third retry: 500ms * 2^2 = 2000ms
    final multiplier = math.pow(backoffMultiplier, retryCount).toDouble();
    final delay = initialDelay * multiplier;

    if (EnvConfig.enableLogging) {
      debugLog(
        'RetryInterceptor: Retrying request (${retryCount + 1}/$maxRetries) '
        'after ${delay.inMilliseconds}ms - ${err.requestOptions.path}',
      );
    }

    // Wait before retrying
    await Future.delayed(delay);

    // Update retry count
    final requestOptions = err.requestOptions;
    requestOptions.extra['retryCount'] = retryCount + 1;

    // Use provided Dio or create minimal one
    // Note: If _retryDio is null, retries won't have auth headers
    final dio = _retryDio ??
        Dio(BaseOptions(
          baseUrl: requestOptions.baseUrl,
          connectTimeout: requestOptions.connectTimeout,
          receiveTimeout: requestOptions.receiveTimeout,
        ));

    try {
      final response = await dio.fetch(requestOptions);
      return handler.resolve(response);
    } on DioException catch (e) {
      // Recursively retry or fail
      return handler.next(e);
    } catch (e) {
      // Handle non-Dio exceptions (SocketException, etc.)
      return handler.next(DioException(
        requestOptions: requestOptions,
        error: e,
        type: DioExceptionType.unknown,
        message: e.toString(),
      ));
    }
  }

  /// Determine if the error should trigger a retry
  bool _shouldRetry(DioException err) {
    // Retry on connection errors
    if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      return true;
    }

    // Check status code for retryable errors
    final statusCode = err.response?.statusCode;
    if (statusCode == null) return true; // Network error

    return statusCode == 408 || // Request Timeout
        statusCode == 429 || // Too Many Requests
        statusCode >= 500; // Server errors
  }

  /// Debug logging helper
  void debugLog(String message) {
    // ignore: avoid_print
    print(message);
  }
}
