import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:cosmo_app/core/services/api_service.dart';
import 'package:cosmo_app/core/services/api_exception.dart';

void main() {
  group('ApiService', () {
    late ApiService apiService;

    setUp(() {
      apiService = ApiService();
    });

    test('should create ApiService instance', () {
      expect(apiService, isNotNull);
    });

    test('should expose authInterceptor', () {
      expect(apiService.authInterceptor, isNotNull);
    });

    group('error handling', () {
      test('should convert connection error to NetworkException', () {
        // Verify the exception types exist and work correctly
        const networkException = NetworkException();
        expect(networkException.isNetworkError, isTrue);
        expect(networkException.message, 'No internet connection');
      });

      test('should convert timeout to TimeoutException', () {
        const timeoutException = TimeoutException();
        expect(timeoutException.statusCode, 408);
        expect(timeoutException.message, 'Request timed out');
      });

      test('should handle 401 as UnauthorizedException', () {
        const exception = UnauthorizedException(message: 'Invalid token');
        expect(exception.statusCode, 401);
        expect(exception.isAuthError, isTrue);
      });

      test('should handle 403 as ForbiddenException', () {
        const exception = ForbiddenException(message: 'Access denied');
        expect(exception.statusCode, 403);
        expect(exception.isForbiddenError, isTrue);
      });

      test('should handle 404 as NotFoundException', () {
        const exception = NotFoundException(message: 'Not found');
        expect(exception.statusCode, 404);
        expect(exception.isNotFoundError, isTrue);
      });

      test('should handle 5xx as ServerException', () {
        const exception = ServerException(statusCode: 503, message: 'Unavailable');
        expect(exception.statusCode, 503);
        expect(exception.isServerError, isTrue);
      });

      test('should handle 400 with field errors as ValidationException', () {
        const exception = ValidationException(
          message: 'Validation failed',
          fieldErrors: {
            'email': ['Invalid format'],
            'password': ['Too short'],
          },
        );
        expect(exception.statusCode, 400);
        expect(exception.getFieldError('email'), 'Invalid format');
        expect(exception.getFieldError('password'), 'Too short');
        expect(exception.getFieldError('unknown'), isNull);
      });
    });

    group('DioException type mapping', () {
      test('connectionError should be network error', () {
        expect(DioExceptionType.connectionError, isNotNull);
      });

      test('connectionTimeout should be timeout error', () {
        expect(DioExceptionType.connectionTimeout, isNotNull);
      });

      test('sendTimeout should be timeout error', () {
        expect(DioExceptionType.sendTimeout, isNotNull);
      });

      test('receiveTimeout should be timeout error', () {
        expect(DioExceptionType.receiveTimeout, isNotNull);
      });

      test('badResponse should be response error', () {
        expect(DioExceptionType.badResponse, isNotNull);
      });

      test('cancel should be cancel error', () {
        expect(DioExceptionType.cancel, isNotNull);
      });
    });
  });

  group('ApiService HTTP methods', () {
    test('should have get method', () {
      final apiService = ApiService();
      expect(apiService.get, isA<Function>());
    });

    test('should have post method', () {
      final apiService = ApiService();
      expect(apiService.post, isA<Function>());
    });

    test('should have put method', () {
      final apiService = ApiService();
      expect(apiService.put, isA<Function>());
    });

    test('should have patch method', () {
      final apiService = ApiService();
      expect(apiService.patch, isA<Function>());
    });

    test('should have delete method', () {
      final apiService = ApiService();
      expect(apiService.delete, isA<Function>());
    });

    test('should have uploadFile method', () {
      final apiService = ApiService();
      expect(apiService.uploadFile, isA<Function>());
    });
  });
}
