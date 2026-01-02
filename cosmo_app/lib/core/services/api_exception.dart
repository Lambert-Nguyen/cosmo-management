/// API exception classes for Cosmo Management
///
/// Provides structured error handling for API requests.
library;

/// Base exception for all API errors
class ApiException implements Exception {
  final int? statusCode;
  final String message;
  final String? errorCode;
  final dynamic data;

  const ApiException({
    this.statusCode,
    required this.message,
    this.errorCode,
    this.data,
  });

  @override
  String toString() => 'ApiException: $message (code: $statusCode)';

  /// Whether this error is due to authentication failure
  bool get isAuthError => statusCode == 401;

  /// Whether this error is due to forbidden access
  bool get isForbiddenError => statusCode == 403;

  /// Whether this error is due to resource not found
  bool get isNotFoundError => statusCode == 404;

  /// Whether this error is a server error
  bool get isServerError => statusCode != null && statusCode! >= 500;

  /// Whether this error is a network/connection error
  bool get isNetworkError => statusCode == null;

  /// Whether this error should trigger a retry
  bool get shouldRetry {
    if (statusCode == null) return true; // Network error
    if (statusCode == 408) return true; // Request timeout
    if (statusCode == 429) return true; // Too many requests
    if (statusCode! >= 500) return true; // Server error
    return false;
  }
}

/// Exception for network connectivity issues
class NetworkException extends ApiException {
  const NetworkException({
    String message = 'No internet connection',
  }) : super(message: message);
}

/// Exception for request timeout
class TimeoutException extends ApiException {
  const TimeoutException({
    String message = 'Request timed out',
  }) : super(statusCode: 408, message: message);
}

/// Exception for authentication failures
class UnauthorizedException extends ApiException {
  const UnauthorizedException({
    String message = 'Authentication required',
  }) : super(statusCode: 401, message: message);
}

/// Exception for forbidden access
class ForbiddenException extends ApiException {
  const ForbiddenException({
    String message = 'Access denied',
  }) : super(statusCode: 403, message: message);
}

/// Exception for resource not found
class NotFoundException extends ApiException {
  const NotFoundException({
    String message = 'Resource not found',
  }) : super(statusCode: 404, message: message);
}

/// Exception for validation errors
class ValidationException extends ApiException {
  final Map<String, List<String>>? fieldErrors;

  const ValidationException({
    String message = 'Validation failed',
    this.fieldErrors,
  }) : super(statusCode: 400, message: message);

  /// Get error message for a specific field
  String? getFieldError(String field) {
    return fieldErrors?[field]?.first;
  }
}

/// Exception for server errors
class ServerException extends ApiException {
  const ServerException({
    int statusCode = 500,
    String message = 'Server error',
  }) : super(statusCode: statusCode, message: message);
}
