/// Service providers for Cosmo Management
///
/// Riverpod providers for core services.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/notification_repository.dart';
import '../../data/repositories/property_repository.dart';
import '../../data/repositories/task_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../services/connectivity_service.dart';
import '../services/storage_service.dart';
import 'auth_notifier.dart';

/// Storage service provider
///
/// Note: Must be overridden in ProviderScope with initialized instance.
final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError(
    'storageServiceProvider must be overridden with an initialized StorageService',
  );
});

/// Connectivity service provider
///
/// Note: Must be overridden in ProviderScope with initialized instance.
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  throw UnimplementedError(
    'connectivityServiceProvider must be overridden with an initialized ConnectivityService',
  );
});

/// Auth service provider
///
/// Note: Must be overridden in ProviderScope with initialized instance.
final authServiceProvider = Provider<AuthService>((ref) {
  throw UnimplementedError(
    'authServiceProvider must be overridden with an initialized AuthService',
  );
});

/// API service provider
final apiServiceProvider = Provider<ApiService>((ref) {
  final authService = ref.watch(authServiceProvider);
  return ApiService(authInterceptor: authService.authInterceptor);
});

/// Auth notifier provider for login/logout actions
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthNotifierState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});

/// Auth state provider (stream)
final authStateProvider = StreamProvider<AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

/// Current auth state provider (synchronous)
final currentAuthStateProvider = Provider<AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.currentState;
});

/// Current user provider
final currentUserProvider = Provider<AuthUser?>((ref) {
  final authNotifier = ref.watch(authNotifierProvider);
  if (authNotifier is AuthAuthenticated) {
    return authNotifier.user;
  }
  return null;
});

/// Connectivity status provider
final connectivityStatusProvider = StreamProvider<ConnectivityStatus>((ref) {
  final connectivity = ref.watch(connectivityServiceProvider);
  return connectivity.statusStream;
});

/// Is connected provider
final isConnectedProvider = Provider<bool>((ref) {
  final connectivity = ref.watch(connectivityServiceProvider);
  return connectivity.isConnected;
});

/// Is authenticated provider
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState is AuthAuthenticated;
});

/// Is loading auth provider
final isAuthLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState is AuthLoading;
});

// ============================================
// Repository Providers
// ============================================

/// Auth repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    apiService: ref.watch(apiServiceProvider),
    storageService: ref.watch(storageServiceProvider),
    authService: ref.watch(authServiceProvider),
  );
});

/// User repository provider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(
    apiService: ref.watch(apiServiceProvider),
    storageService: ref.watch(storageServiceProvider),
  );
});

/// Property repository provider
final propertyRepositoryProvider = Provider<PropertyRepository>((ref) {
  return PropertyRepository(
    apiService: ref.watch(apiServiceProvider),
    storageService: ref.watch(storageServiceProvider),
  );
});

/// Task repository provider
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository(
    apiService: ref.watch(apiServiceProvider),
    storageService: ref.watch(storageServiceProvider),
  );
});

/// Notification repository provider
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository(
    apiService: ref.watch(apiServiceProvider),
    storageService: ref.watch(storageServiceProvider),
  );
});
