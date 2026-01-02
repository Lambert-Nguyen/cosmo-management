/// Environment configuration for Cosmo Management
///
/// Provides environment-specific settings for API URLs and app configuration.
/// Supports development, staging, and production environments.
library;

enum Environment {
  development,
  staging,
  production,
}

class EnvConfig {
  static Environment _environment = Environment.development;

  /// Current environment
  static Environment get environment => _environment;

  /// Initialize the environment configuration
  static void init(Environment env) {
    _environment = env;
  }

  /// API base URL based on current environment
  static String get apiBaseUrl {
    switch (_environment) {
      case Environment.development:
        return const String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: 'http://localhost:8000',
        );
      case Environment.staging:
        return const String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: 'https://staging-api.cosmomgmt.com',
        );
      case Environment.production:
        return const String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: 'https://api.cosmomgmt.com',
        );
    }
  }

  /// Whether to enable debug logging
  static bool get enableLogging {
    return _environment == Environment.development;
  }

  /// Whether to use secure storage (HTTPS)
  static bool get useSecureConnection {
    return _environment != Environment.development;
  }

  /// Connection timeout in seconds
  static int get connectTimeoutSeconds => 30;

  /// Receive timeout in seconds
  static int get receiveTimeoutSeconds => 30;

  /// Maximum retry attempts for failed requests
  static int get maxRetryAttempts => 3;

  /// Whether offline mode is enabled
  static bool get offlineModeEnabled => true;

  /// Cache expiry duration in hours
  static int get cacheExpiryHours => 24;
}
