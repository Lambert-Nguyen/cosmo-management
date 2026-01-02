import 'package:flutter_test/flutter_test.dart';
import 'package:cosmo_app/core/services/api_exception.dart';

void main() {
  group('ApiException', () {
    test('should create ApiException with message', () {
      const exception = ApiException(message: 'Test error');

      expect(exception.message, 'Test error');
      expect(exception.statusCode, isNull);
    });

    test('should create ApiException with status code', () {
      const exception = ApiException(
        message: 'Server error',
        statusCode: 500,
      );

      expect(exception.message, 'Server error');
      expect(exception.statusCode, 500);
    });

    test('should create ApiException with data', () {
      const exception = ApiException(
        message: 'Validation error',
        data: {'field': 'email', 'error': 'Invalid format'},
      );

      expect(exception.data, isNotNull);
      expect(exception.data['field'], 'email');
    });

    test('isAuthError should return true for 401', () {
      const exception = ApiException(message: 'Auth error', statusCode: 401);
      expect(exception.isAuthError, isTrue);
    });

    test('isForbiddenError should return true for 403', () {
      const exception = ApiException(message: 'Forbidden', statusCode: 403);
      expect(exception.isForbiddenError, isTrue);
    });

    test('isNotFoundError should return true for 404', () {
      const exception = ApiException(message: 'Not found', statusCode: 404);
      expect(exception.isNotFoundError, isTrue);
    });

    test('isServerError should return true for 5xx', () {
      const exception500 = ApiException(message: 'Server error', statusCode: 500);
      const exception503 = ApiException(message: 'Unavailable', statusCode: 503);

      expect(exception500.isServerError, isTrue);
      expect(exception503.isServerError, isTrue);
    });

    test('isNetworkError should return true when statusCode is null', () {
      const exception = ApiException(message: 'Network error');
      expect(exception.isNetworkError, isTrue);
    });

    test('shouldRetry should return true for retryable errors', () {
      const networkError = ApiException(message: 'Network');
      const timeoutError = ApiException(message: 'Timeout', statusCode: 408);
      const tooManyRequests = ApiException(message: 'Rate limit', statusCode: 429);
      const serverError = ApiException(message: 'Server', statusCode: 500);

      expect(networkError.shouldRetry, isTrue);
      expect(timeoutError.shouldRetry, isTrue);
      expect(tooManyRequests.shouldRetry, isTrue);
      expect(serverError.shouldRetry, isTrue);
    });

    test('shouldRetry should return false for non-retryable errors', () {
      const badRequest = ApiException(message: 'Bad request', statusCode: 400);
      const notFound = ApiException(message: 'Not found', statusCode: 404);

      expect(badRequest.shouldRetry, isFalse);
      expect(notFound.shouldRetry, isFalse);
    });
  });

  group('NetworkException', () {
    test('should be subclass of ApiException', () {
      const exception = NetworkException(message: 'No network');

      expect(exception, isA<ApiException>());
      expect(exception.message, 'No network');
    });

    test('should have default message', () {
      const exception = NetworkException();
      expect(exception.message, 'No internet connection');
    });
  });

  group('UnauthorizedException', () {
    test('should be subclass of ApiException with 401 status', () {
      const exception = UnauthorizedException(message: 'Unauthorized');

      expect(exception, isA<ApiException>());
      expect(exception.message, 'Unauthorized');
      expect(exception.statusCode, 401);
    });

    test('should have default message', () {
      const exception = UnauthorizedException();
      expect(exception.message, 'Authentication required');
    });
  });

  group('ForbiddenException', () {
    test('should be subclass of ApiException with 403 status', () {
      const exception = ForbiddenException(message: 'Forbidden');

      expect(exception, isA<ApiException>());
      expect(exception.message, 'Forbidden');
      expect(exception.statusCode, 403);
    });

    test('should have default message', () {
      const exception = ForbiddenException();
      expect(exception.message, 'Access denied');
    });
  });

  group('NotFoundException', () {
    test('should be subclass of ApiException with 404 status', () {
      const exception = NotFoundException(message: 'Not found');

      expect(exception, isA<ApiException>());
      expect(exception.message, 'Not found');
      expect(exception.statusCode, 404);
    });

    test('should have default message', () {
      const exception = NotFoundException();
      expect(exception.message, 'Resource not found');
    });
  });

  group('ServerException', () {
    test('should be subclass of ApiException with 500 status', () {
      const exception = ServerException(message: 'Server error');

      expect(exception, isA<ApiException>());
      expect(exception.message, 'Server error');
      expect(exception.statusCode, 500);
    });

    test('should have default message', () {
      const exception = ServerException();
      expect(exception.message, 'Server error');
    });

    test('should accept custom status code', () {
      const exception = ServerException(statusCode: 503, message: 'Unavailable');
      expect(exception.statusCode, 503);
    });
  });

  group('ValidationException', () {
    test('should be subclass of ApiException with 400 status', () {
      const exception = ValidationException(message: 'Validation failed');

      expect(exception, isA<ApiException>());
      expect(exception.message, 'Validation failed');
      expect(exception.statusCode, 400);
    });

    test('should store field errors', () {
      const fieldErrors = {
        'email': ['Invalid email format'],
        'password': ['Too short', 'Missing number'],
      };
      const exception = ValidationException(
        message: 'Validation failed',
        fieldErrors: fieldErrors,
      );

      expect(exception.fieldErrors, fieldErrors);
    });

    test('getFieldError should return first error for field', () {
      const fieldErrors = {
        'email': ['Invalid email', 'Already exists'],
      };
      const exception = ValidationException(
        message: 'Validation failed',
        fieldErrors: fieldErrors,
      );

      expect(exception.getFieldError('email'), 'Invalid email');
      expect(exception.getFieldError('password'), isNull);
    });
  });

  group('TimeoutException', () {
    test('should be subclass of ApiException with 408 status', () {
      const exception = TimeoutException(message: 'Request timed out');

      expect(exception, isA<ApiException>());
      expect(exception.message, 'Request timed out');
      expect(exception.statusCode, 408);
    });

    test('should have default message', () {
      const exception = TimeoutException();
      expect(exception.message, 'Request timed out');
    });
  });
}
