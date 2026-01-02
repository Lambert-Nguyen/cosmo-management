/// User model for Cosmo Management
///
/// Freezed model for user data with JSON serialization.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// User model
///
/// Represents a user in the system with role-based access.
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required int id,
    required String email,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    String? role,
    @JsonKey(name: 'phone_number') String? phoneNumber,
    @JsonKey(name: 'profile_image') String? profileImage,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'date_joined') DateTime? dateJoined,
    @JsonKey(name: 'last_login') DateTime? lastLogin,
  }) = _UserModel;

  const UserModel._();

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Full name combining first and last name
  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    }
    if (firstName != null) return firstName!;
    if (lastName != null) return lastName!;
    return email.split('@').first;
  }

  /// Display name (full name or email)
  String get displayName => fullName.isNotEmpty ? fullName : email;

  /// User initials for avatar
  String get initials {
    if (firstName != null && lastName != null) {
      return '${firstName![0]}${lastName![0]}'.toUpperCase();
    }
    if (firstName != null) return firstName![0].toUpperCase();
    return email[0].toUpperCase();
  }

  /// Check if user has a specific role
  bool hasRole(String roleName) => role?.toLowerCase() == roleName.toLowerCase();

  /// Check if user is a manager
  bool get isManager => hasRole('manager');

  /// Check if user is staff
  bool get isStaff => hasRole('staff');

  /// Check if user is admin
  bool get isAdmin => hasRole('admin');
}

/// User role enum
enum UserRole {
  @JsonValue('admin')
  admin,
  @JsonValue('manager')
  manager,
  @JsonValue('staff')
  staff,
  @JsonValue('guest')
  guest,
}
