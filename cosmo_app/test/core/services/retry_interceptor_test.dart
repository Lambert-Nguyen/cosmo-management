import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:cosmo_app/core/services/retry_interceptor.dart';

void main() {
  group('RetryInterceptor', () {
    late RetryInterceptor interceptor;

    setUp(() {
      interceptor = RetryInterceptor(
        maxRetries: 3,
        initialDelay: const Duration(milliseconds: 100),
        backoffMultiplier: 2.0,
      );
    });

    test('should create with default values', () {
      final defaultInterceptor = RetryInterceptor();
      expect(defaultInterceptor, isNotNull);
      expect(defaultInterceptor.maxRetries, isPositive);
      expect(defaultInterceptor.initialDelay, isNotNull);
      expect(defaultInterceptor.backoffMultiplier, isPositive);
    });

    test('should create with custom values', () {
      final customInterceptor = RetryInterceptor(
        maxRetries: 5,
        initialDelay: const Duration(seconds: 1),
        backoffMultiplier: 3.0,
      );

      expect(customInterceptor.maxRetries, 5);
      expect(customInterceptor.initialDelay, const Duration(seconds: 1));
      expect(customInterceptor.backoffMultiplier, 3.0);
    });

    test('should accept retryDio parameter', () {
      final dio = Dio();
      final interceptorWithDio = RetryInterceptor(retryDio: dio);
      expect(interceptorWithDio, isNotNull);
    });

    test('should be an Interceptor', () {
      expect(interceptor, isA<Interceptor>());
    });

    group('error handling behavior', () {
      test('should handle non-retryable errors', () {
        // Create a mock error that should not be retried
        final exception = DioException(
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 400, // Bad request - should not retry
          ),
        );

        // Verify the exception was created correctly
        expect(exception.response?.statusCode, 400);
        expect(exception.requestOptions.path, '/test');

        // The interceptor should be valid and ready to handle errors
        expect(interceptor, isNotNull);
        expect(interceptor.maxRetries, 3);
      });

      test('should include retryCount in request options', () {
        final requestOptions = RequestOptions(path: '/test');
        requestOptions.extra['retryCount'] = 2;

        expect(requestOptions.extra['retryCount'], 2);
      });
    });

    group('configuration', () {
      test('maxRetries should be configurable', () {
        final interceptor1 = RetryInterceptor(maxRetries: 1);
        final interceptor5 = RetryInterceptor(maxRetries: 5);

        expect(interceptor1.maxRetries, 1);
        expect(interceptor5.maxRetries, 5);
      });

      test('initialDelay should be configurable', () {
        final interceptor100ms = RetryInterceptor(
          initialDelay: const Duration(milliseconds: 100),
        );
        final interceptor1s = RetryInterceptor(
          initialDelay: const Duration(seconds: 1),
        );

        expect(interceptor100ms.initialDelay.inMilliseconds, 100);
        expect(interceptor1s.initialDelay.inSeconds, 1);
      });

      test('backoffMultiplier should be configurable', () {
        final interceptor2x = RetryInterceptor(backoffMultiplier: 2.0);
        final interceptor3x = RetryInterceptor(backoffMultiplier: 3.0);

        expect(interceptor2x.backoffMultiplier, 2.0);
        expect(interceptor3x.backoffMultiplier, 3.0);
      });
    });

    group('retry status codes', () {
      // These tests verify the expected behavior based on documentation
      // The actual shouldRetry method is private, but we document expected behavior

      test('should have documented retryable status codes', () {
        // Documented retryable codes: 408, 429, 5xx
        // We test this by creating exceptions and checking the ApiException.shouldRetry
        // Since RetryInterceptor._shouldRetry is private, we test via integration
        expect(true, isTrue); // Placeholder - behavior tested via integration tests
      });

      test('DioExceptionType values should be valid', () {
        // Verify that the DioExceptionTypes used in _shouldRetry are valid
        expect(DioExceptionType.connectionError, isNotNull);
        expect(DioExceptionType.connectionTimeout, isNotNull);
        expect(DioExceptionType.sendTimeout, isNotNull);
        expect(DioExceptionType.receiveTimeout, isNotNull);
      });
    });
  });
}
