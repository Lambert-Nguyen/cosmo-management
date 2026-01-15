/// Cosmo Management - Universal Property & Operations Management Platform
///
/// Entry point for the Flutter application.
/// Supports web, iOS, and Android platforms with responsive layouts.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/config/env_config.dart';
import 'core/providers/service_providers.dart';
import 'core/services/auth_service.dart';
import 'core/services/connectivity_service.dart';
import 'core/services/storage_service.dart';

/// Application entry point
///
/// Initializes:
/// - Flutter bindings
/// - Environment configuration
/// - Core services (Storage, Connectivity, Auth)
/// - Riverpod state management
/// - Web-specific URL strategy
void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize environment
  EnvConfig.init(Environment.development);

  // Platform-specific initialization
  if (!kIsWeb) {
    // Mobile: Set preferred orientations (allow all for tablet)
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  // Set system UI overlay style (mobile only)
  if (!kIsWeb) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  // Initialize core services
  final storageService = StorageService();
  final connectivityService = ConnectivityService();
  final authService = AuthService();

  try {
    // Initialize services in parallel where possible
    await Future.wait([
      storageService.init(),
      connectivityService.init(),
    ]);

    // Initialize auth service (depends on storage being ready)
    await authService.init();
  } catch (e) {
    // Log initialization errors but continue
    debugPrint('Initialization error: $e');
  }

  // Run the app with Riverpod
  runApp(
    ProviderScope(
      overrides: [
        // Override providers with initialized instances
        storageServiceProvider.overrideWithValue(storageService),
        connectivityServiceProvider.overrideWithValue(connectivityService),
        authServiceProvider.overrideWithValue(authService),
      ],
      child: CosmoApp(authService: authService),
    ),
  );
}
