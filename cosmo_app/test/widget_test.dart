/// Basic widget tests for Cosmo Management
///
/// Note: More comprehensive tests will be added in later phases.
library;

import 'package:flutter_test/flutter_test.dart';

import 'package:cosmo_app/core/config/env_config.dart';
import 'package:cosmo_app/core/services/storage_service.dart';

void main() {
  group('EnvConfig', () {
    test('should initialize with development environment', () {
      EnvConfig.init(Environment.development);
      expect(EnvConfig.environment, Environment.development);
    });

    test('should have correct API URL for development', () {
      EnvConfig.init(Environment.development);
      expect(EnvConfig.apiBaseUrl, 'http://localhost:8000');
    });

    test('should enable logging in development', () {
      EnvConfig.init(Environment.development);
      expect(EnvConfig.enableLogging, true);
    });

    test('should disable secure connection in development', () {
      EnvConfig.init(Environment.development);
      expect(EnvConfig.useSecureConnection, false);
    });
  });

  group('StorageService', () {
    test('should throw when not initialized', () {
      final storage = StorageService();
      expect(
        () => storage.hasValidCache('test'),
        throwsA(isA<StateError>()),
      );
    });
  });
}
