/// Logging interceptor for Dio HTTP client
///
/// Provides detailed request/response logging for development.
/// Automatically masks sensitive data like passwords and tokens.
library;

import 'dart:convert';

import 'package:dio/dio.dart';

import '../config/env_config.dart';

/// Interceptor that logs HTTP requests and responses
///
/// Only active in development environment for debugging purposes.
/// Sensitive data is automatically masked for security.
class LoggingInterceptor extends Interceptor {
  final bool enabled;

  /// Fields that should be masked in logs
  static const _sensitiveFields = {
    // Auth fields
    'password',
    'old_password',
    'new_password',
    'confirm_password',
    'secret',
    'token',
    'access',
    'refresh',
    'access_token',
    'refresh_token',
    'api_key',
    'apikey',
    'api_secret',
    // Personal data
    'ssn',
    'social_security',
    'credit_card',
    'card_number',
    'cvv',
    'pin',
  };

  LoggingInterceptor({
    bool? enabled,
  }) : enabled = enabled ?? EnvConfig.enableLogging;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    if (enabled) {
      _logRequest(options);
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    if (enabled) {
      _logResponse(response);
    }
    handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    if (enabled) {
      _logError(err);
    }
    handler.next(err);
  }

  void _logRequest(RequestOptions options) {
    final buffer = StringBuffer();
    buffer.writeln('╔══════════════════════════════════════════════════════════');
    buffer.writeln('║ REQUEST');
    buffer.writeln('╟──────────────────────────────────────────────────────────');
    buffer.writeln('║ ${options.method} ${options.uri}');
    buffer.writeln('╟──────────────────────────────────────────────────────────');
    buffer.writeln('║ Headers:');
    options.headers.forEach((key, value) {
      // Mask authorization header
      if (key.toLowerCase() == 'authorization') {
        buffer.writeln('║   $key: [REDACTED]');
      } else {
        buffer.writeln('║   $key: $value');
      }
    });
    if (options.data != null) {
      buffer.writeln('╟──────────────────────────────────────────────────────────');
      buffer.writeln('║ Body:');
      buffer.writeln('║   ${_formatJson(_maskSensitiveData(options.data))}');
    }
    buffer.writeln('╚══════════════════════════════════════════════════════════');
    // ignore: avoid_print
    print(buffer.toString());
  }

  void _logResponse(Response response) {
    final buffer = StringBuffer();
    buffer.writeln('╔══════════════════════════════════════════════════════════');
    buffer.writeln('║ RESPONSE');
    buffer.writeln('╟──────────────────────────────────────────────────────────');
    buffer.writeln('║ ${response.statusCode} ${response.requestOptions.uri}');
    buffer.writeln('╟──────────────────────────────────────────────────────────');
    buffer.writeln('║ Body:');
    buffer.writeln('║   ${_formatJson(_maskSensitiveData(response.data))}');
    buffer.writeln('╚══════════════════════════════════════════════════════════');
    // ignore: avoid_print
    print(buffer.toString());
  }

  void _logError(DioException err) {
    final buffer = StringBuffer();
    buffer.writeln('╔══════════════════════════════════════════════════════════');
    buffer.writeln('║ ERROR');
    buffer.writeln('╟──────────────────────────────────────────────────────────');
    buffer.writeln('║ ${err.type} ${err.requestOptions.uri}');
    buffer.writeln('║ Message: ${err.message}');
    if (err.response != null) {
      buffer.writeln('║ Status: ${err.response?.statusCode}');
      buffer.writeln('║ Body: ${_formatJson(_maskSensitiveData(err.response?.data))}');
    }
    buffer.writeln('╚══════════════════════════════════════════════════════════');
    // ignore: avoid_print
    print(buffer.toString());
  }

  /// Mask sensitive fields in data
  dynamic _maskSensitiveData(dynamic data) {
    if (data == null) return null;

    if (data is Map<String, dynamic>) {
      return _maskMap(data);
    }

    if (data is List) {
      return data.map(_maskSensitiveData).toList();
    }

    return data;
  }

  /// Mask sensitive fields in a map
  Map<String, dynamic> _maskMap(Map<String, dynamic> map) {
    final masked = <String, dynamic>{};

    for (final entry in map.entries) {
      final key = entry.key;
      final value = entry.value;

      if (_isSensitiveField(key)) {
        // Mask the value but show type/length hint
        if (value is String) {
          masked[key] = '[REDACTED:${value.length} chars]';
        } else {
          masked[key] = '[REDACTED]';
        }
      } else if (value is Map<String, dynamic>) {
        masked[key] = _maskMap(value);
      } else if (value is List) {
        masked[key] = value.map(_maskSensitiveData).toList();
      } else {
        masked[key] = value;
      }
    }

    return masked;
  }

  /// Check if a field name is sensitive
  bool _isSensitiveField(String fieldName) {
    final lower = fieldName.toLowerCase();
    return _sensitiveFields.any((sensitive) => lower.contains(sensitive));
  }

  String _formatJson(dynamic data) {
    if (data == null) return 'null';
    try {
      if (data is String) {
        return data.length > 500 ? '${data.substring(0, 500)}...' : data;
      }
      final encoder = JsonEncoder.withIndent('  ');
      final formatted = encoder.convert(data);
      return formatted.length > 500
          ? '${formatted.substring(0, 500)}...'
          : formatted;
    } catch (e) {
      return data.toString();
    }
  }
}
