/// Auth repository for Cosmo Management
///
/// Handles authentication-related data operations.
library;

import '../../core/config/api_config.dart';
import '../../core/services/auth_service.dart';
import '../models/user_model.dart';
import 'base_repository.dart';

/// Authentication repository
///
/// Handles login, logout, token management, and user profile operations.
class AuthRepository extends BaseRepository {
  final AuthService authService;

  AuthRepository({
    required super.apiService,
    required super.storageService,
    required this.authService,
  });

  /// Login with email and password
  Future<AuthUser> login(String email, String password) async {
    return authService.login(email, password);
  }

  /// Logout current user
  Future<void> logout() async {
    await authService.logout();
    await invalidateCache(_currentUserCacheKey);
  }

  /// Get current authenticated user
  AuthUser? get currentUser => authService.currentUser;

  /// Check if user is authenticated
  bool get isAuthenticated => authService.isAuthenticated;

  /// Get current user profile from API
  Future<UserModel> getCurrentUserProfile() async {
    return getCachedOrFetch<UserModel>(
      cacheKey: _currentUserCacheKey,
      fetchFunction: () async {
        final response = await apiService.get(ApiConfig.userMe);
        return UserModel.fromJson(response);
      },
      fromJson: (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Update current user profile
  Future<UserModel> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
  }) async {
    final data = <String, dynamic>{};
    if (firstName != null) data['first_name'] = firstName;
    if (lastName != null) data['last_name'] = lastName;
    if (phoneNumber != null) data['phone_number'] = phoneNumber;

    final response = await apiService.patch(ApiConfig.userMe, data: data);
    await invalidateCache(_currentUserCacheKey);
    return UserModel.fromJson(response);
  }

  /// Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await apiService.post(
      ApiConfig.changePassword,
      data: {
        'current_password': currentPassword,
        'new_password': newPassword,
      },
    );
  }

  /// Request password reset
  Future<void> requestPasswordReset(String email) async {
    await apiService.post(
      ApiConfig.passwordReset,
      data: {'email': email},
    );
  }

  /// Confirm password reset
  Future<void> confirmPasswordReset({
    required String token,
    required String newPassword,
  }) async {
    await apiService.post(
      ApiConfig.passwordResetConfirm,
      data: {
        'token': token,
        'new_password': newPassword,
      },
    );
  }

  static const _currentUserCacheKey = 'current_user_profile';
}
