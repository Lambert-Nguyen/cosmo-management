/// User repository for Cosmo Management
///
/// Handles user-related data operations.
library;

import '../../core/config/api_config.dart';
import '../models/user_model.dart';
import 'base_repository.dart';

/// User repository
///
/// Handles CRUD operations for users (admin/manager functionality).
class UserRepository extends BaseRepository {
  UserRepository({
    required super.apiService,
    required super.storageService,
  });

  /// Get paginated list of users
  Future<PaginatedUsers> getUsers({
    int page = 1,
    int pageSize = 20,
    String? search,
    String? role,
    bool? isActive,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'page_size': pageSize,
    };
    if (search != null) queryParams['search'] = search;
    if (role != null) queryParams['role'] = role;
    if (isActive != null) queryParams['is_active'] = isActive;

    final response = await apiService.get(
      ApiConfig.users,
      queryParameters: queryParams,
    );

    return PaginatedUsers.fromJson(response);
  }

  /// Get user by ID
  Future<UserModel> getUserById(int id) async {
    return getCachedOrFetch<UserModel>(
      cacheKey: _userCacheKey(id),
      fetchFunction: () async {
        final response = await apiService.get(ApiConfig.userDetail(id));
        return UserModel.fromJson(response);
      },
      fromJson: (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Create new user
  Future<UserModel> createUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
    String? phoneNumber,
  }) async {
    final response = await apiService.post(
      ApiConfig.users,
      data: {
        'email': email,
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
        'role': role,
        if (phoneNumber != null) 'phone_number': phoneNumber,
      },
    );
    return UserModel.fromJson(response);
  }

  /// Update user
  Future<UserModel> updateUser(
    int id, {
    String? firstName,
    String? lastName,
    String? role,
    String? phoneNumber,
    bool? isActive,
  }) async {
    final data = <String, dynamic>{};
    if (firstName != null) data['first_name'] = firstName;
    if (lastName != null) data['last_name'] = lastName;
    if (role != null) data['role'] = role;
    if (phoneNumber != null) data['phone_number'] = phoneNumber;
    if (isActive != null) data['is_active'] = isActive;

    final response = await apiService.patch(
      ApiConfig.userDetail(id),
      data: data,
    );
    await invalidateCache(_userCacheKey(id));
    return UserModel.fromJson(response);
  }

  /// Delete user (soft delete)
  Future<void> deleteUser(int id) async {
    await apiService.delete(ApiConfig.userDetail(id));
    await invalidateCache(_userCacheKey(id));
  }

  /// Get staff members (for task assignment)
  Future<List<UserModel>> getStaffMembers() async {
    final response = await getUsers(role: 'staff', isActive: true, pageSize: 100);
    return response.results;
  }

  String _userCacheKey(int id) => 'user_$id';
}

/// Paginated users response
class PaginatedUsers {
  final int count;
  final String? next;
  final String? previous;
  final List<UserModel> results;

  PaginatedUsers({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory PaginatedUsers.fromJson(Map<String, dynamic> json) {
    return PaginatedUsers(
      count: json['count'] as int? ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => UserModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  bool get hasMore => next != null;
}
