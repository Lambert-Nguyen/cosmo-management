/// API service for Cosmo Management
///
/// Provides HTTP client with JWT authentication, retry logic, and error handling.
library;

import 'package:dio/dio.dart';

import '../config/env_config.dart';
import 'api_exception.dart';
import 'auth_interceptor.dart';
import 'logging_interceptor.dart';
import 'retry_interceptor.dart';

/// Main API service for making HTTP requests
///
/// Features:
/// - JWT authentication with automatic token refresh
/// - Exponential backoff retry for transient failures
/// - Detailed logging in development mode
/// - Structured error handling
class ApiService {
  late final Dio _dio;
  late final AuthInterceptor _authInterceptor;

  ApiService({AuthInterceptor? authInterceptor}) {
    _authInterceptor = authInterceptor ?? AuthInterceptor();

    _dio = Dio(BaseOptions(
      baseUrl: EnvConfig.apiBaseUrl,
      connectTimeout: Duration(seconds: EnvConfig.connectTimeoutSeconds),
      receiveTimeout: Duration(seconds: EnvConfig.receiveTimeoutSeconds),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.addAll([
      _authInterceptor,
      RetryInterceptor(),
      LoggingInterceptor(),
    ]);
  }

  /// Get the auth interceptor for token management
  AuthInterceptor get authInterceptor => _authInterceptor;

  /// Make a GET request
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Make a POST request
  Future<T> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Make a PUT request
  Future<T> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Make a PATCH request
  Future<T> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Make a DELETE request
  Future<T> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Upload a file with multipart form data
  Future<T> uploadFile<T>(
    String path, {
    required String filePath,
    required String fieldName,
    Map<String, dynamic>? additionalData,
    void Function(int, int)? onSendProgress,
  }) async {
    try {
      final formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(filePath),
        if (additionalData != null) ...additionalData,
      });

      final response = await _dio.post<T>(
        path,
        data: formData,
        onSendProgress: onSendProgress,
        options: Options(contentType: 'multipart/form-data'),
      );
      return response.data as T;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Convert DioException to ApiException
  ApiException _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
        return const NetworkException();

      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();

      case DioExceptionType.badResponse:
        return _handleResponseError(e.response);

      case DioExceptionType.cancel:
        return const ApiException(message: 'Request cancelled');

      default:
        return ApiException(
          message: e.message ?? 'Unknown error occurred',
        );
    }
  }

  /// Handle HTTP response errors
  ApiException _handleResponseError(Response? response) {
    if (response == null) {
      return const ApiException(message: 'No response from server');
    }

    final statusCode = response.statusCode ?? 500;
    final data = response.data;

    // Extract error message from response
    String message = 'An error occurred';
    if (data is Map<String, dynamic>) {
      message = data['detail'] as String? ??
          data['message'] as String? ??
          data['error'] as String? ??
          message;
    }

    switch (statusCode) {
      case 400:
        // Handle validation errors
        if (data is Map<String, dynamic>) {
          final fieldErrors = <String, List<String>>{};
          data.forEach((key, value) {
            if (value is List) {
              fieldErrors[key] = value.cast<String>();
            } else if (value is String) {
              fieldErrors[key] = [value];
            }
          });
          if (fieldErrors.isNotEmpty) {
            return ValidationException(
              message: message,
              fieldErrors: fieldErrors,
            );
          }
        }
        return ApiException(statusCode: 400, message: message);

      case 401:
        return UnauthorizedException(message: message);

      case 403:
        return ForbiddenException(message: message);

      case 404:
        return NotFoundException(message: message);

      default:
        if (statusCode >= 500) {
          return ServerException(statusCode: statusCode, message: message);
        }
        return ApiException(statusCode: statusCode, message: message);
    }
  }
}
