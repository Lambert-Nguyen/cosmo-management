/// Lost & Found model for Cosmo Management
///
/// Freezed model for lost and found items with JSON serialization.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'lost_found_model.freezed.dart';
part 'lost_found_model.g.dart';

/// Lost & Found item status
@JsonEnum(valueField: 'value')
enum LostFoundStatus {
  @JsonValue('lost')
  lost('lost', 'Lost'),
  @JsonValue('found')
  found('found', 'Found'),
  @JsonValue('claimed')
  claimed('claimed', 'Claimed'),
  @JsonValue('archived')
  archived('archived', 'Archived'),
  @JsonValue('expired')
  expired('expired', 'Expired');

  final String value;
  final String displayName;

  const LostFoundStatus(this.value, this.displayName);

  /// Check if item is still active (not resolved)
  bool get isActive => this == lost || this == found;

  /// Check if item has been resolved
  bool get isResolved => this == claimed || this == archived || this == expired;

  /// Check if item can be claimed
  bool get canBeClaimed => this == found;
}

/// Lost & Found item category
@JsonEnum(valueField: 'value')
enum LostFoundCategory {
  @JsonValue('keys')
  keys('keys', 'Keys'),
  @JsonValue('documents')
  documents('documents', 'Documents'),
  @JsonValue('electronics')
  electronics('electronics', 'Electronics'),
  @JsonValue('clothing')
  clothing('clothing', 'Clothing'),
  @JsonValue('jewelry')
  jewelry('jewelry', 'Jewelry'),
  @JsonValue('bags')
  bags('bags', 'Bags & Luggage'),
  @JsonValue('personal')
  personal('personal', 'Personal Items'),
  @JsonValue('valuables')
  valuables('valuables', 'Valuables'),
  @JsonValue('other')
  other('other', 'Other');

  final String value;
  final String displayName;

  const LostFoundCategory(this.value, this.displayName);

  /// Check if this category typically contains high-value items
  bool get isHighValue =>
      this == electronics || this == jewelry || this == valuables;
}

/// Lost & Found item model
///
/// Represents a lost or found item reported in the system.
@freezed
class LostFoundModel with _$LostFoundModel {
  const factory LostFoundModel({
    required int id,
    required String title,
    String? description,
    @Default(LostFoundStatus.found) LostFoundStatus status,
    @Default(LostFoundCategory.other) LostFoundCategory category,
    @JsonKey(name: 'location_found') String? locationFound,
    @JsonKey(name: 'location_description') String? locationDescription,
    @JsonKey(name: 'property_id') int? propertyId,
    @JsonKey(name: 'property_name') String? propertyName,
    @JsonKey(name: 'date_found') DateTime? dateFound,
    @JsonKey(name: 'date_lost') DateTime? dateLost,
    @JsonKey(name: 'reported_by') int? reportedById,
    @JsonKey(name: 'reported_by_name') String? reportedByName,
    @JsonKey(name: 'claimed_by') int? claimedById,
    @JsonKey(name: 'claimed_by_name') String? claimedByName,
    @JsonKey(name: 'claimed_at') DateTime? claimedAt,
    @JsonKey(name: 'claimant_contact') String? claimantContact,
    @JsonKey(name: 'storage_location') String? storageLocation,
    @JsonKey(name: 'is_valuable') @Default(false) bool isValuable,
    @JsonKey(name: 'estimated_value') double? estimatedValue,
    @Default([]) List<String> images,
    String? notes,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'expires_at') DateTime? expiresAt,
  }) = _LostFoundModel;

  const LostFoundModel._();

  factory LostFoundModel.fromJson(Map<String, dynamic> json) =>
      _$LostFoundModelFromJson(json);

  /// Default expiry period in days for unclaimed items
  static const int defaultExpiryDays = 90;

  /// Check if item is a lost report (vs found)
  bool get isLostReport => status == LostFoundStatus.lost;

  /// Check if item is a found report
  bool get isFoundReport => status == LostFoundStatus.found;

  /// Check if item has been claimed
  bool get isClaimed => status == LostFoundStatus.claimed;

  /// Check if item is still active
  bool get isActive => status.isActive;

  /// Check if item has photos
  bool get hasPhotos => images.isNotEmpty;

  /// Days since item was found/reported
  int get daysSinceReported {
    final date = dateFound ?? dateLost ?? createdAt;
    if (date == null) return 0;
    return DateTime.now().difference(date).inDays;
  }

  /// Days until expiry (negative if expired)
  int? get daysUntilExpiry {
    if (expiresAt == null) return null;
    return expiresAt!.difference(DateTime.now()).inDays;
  }

  /// Check if item is about to expire (within 7 days)
  bool get isExpiringSoon {
    final days = daysUntilExpiry;
    return days != null && days <= 7 && days > 0;
  }

  /// Check if item has expired
  bool get hasExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  /// Get display date (found or lost date)
  DateTime? get displayDate => dateFound ?? dateLost ?? createdAt;

  /// Get status message for UI
  String get statusMessage {
    return switch (status) {
      LostFoundStatus.lost => 'Reported lost $daysSinceReported days ago',
      LostFoundStatus.found => 'Found $daysSinceReported days ago',
      LostFoundStatus.claimed => 'Claimed by $claimedByName',
      LostFoundStatus.archived => 'Archived',
      LostFoundStatus.expired => 'Expired - unclaimed',
    };
  }

  /// Check if item needs attention (about to expire, unclaimed valuable, etc.)
  bool get needsAttention {
    if (!isActive) return false;
    if (isExpiringSoon) return true;
    if (isValuable && daysSinceReported > 7) return true;
    return false;
  }
}

/// Lost & Found claim model
///
/// Represents a claim for a found item.
@freezed
class LostFoundClaimModel with _$LostFoundClaimModel {
  const factory LostFoundClaimModel({
    required int id,
    @JsonKey(name: 'lost_found_id') required int lostFoundId,
    @JsonKey(name: 'claimed_by') required int claimedById,
    @JsonKey(name: 'claimed_by_name') String? claimedByName,
    @JsonKey(name: 'claimant_contact') String? claimantContact,
    @JsonKey(name: 'identification_provided') String? identificationProvided,
    @JsonKey(name: 'verification_notes') String? verificationNotes,
    @JsonKey(name: 'is_verified') @Default(false) bool isVerified,
    @JsonKey(name: 'claimed_at') DateTime? claimedAt,
    @JsonKey(name: 'processed_by') int? processedById,
    @JsonKey(name: 'processed_by_name') String? processedByName,
  }) = _LostFoundClaimModel;

  const LostFoundClaimModel._();

  factory LostFoundClaimModel.fromJson(Map<String, dynamic> json) =>
      _$LostFoundClaimModelFromJson(json);
}

/// Paginated lost & found response
class PaginatedLostFound {
  final int count;
  final String? next;
  final String? previous;
  final List<LostFoundModel> results;

  PaginatedLostFound({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  bool get hasMore => next != null;

  factory PaginatedLostFound.fromJson(Map<String, dynamic> json) {
    return PaginatedLostFound(
      count: json['count'] as int? ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => LostFoundModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

/// Lost & Found statistics for dashboard
@freezed
class LostFoundStatsModel with _$LostFoundStatsModel {
  const factory LostFoundStatsModel({
    @JsonKey(name: 'total_lost') @Default(0) int totalLost,
    @JsonKey(name: 'total_found') @Default(0) int totalFound,
    @JsonKey(name: 'total_claimed') @Default(0) int totalClaimed,
    @JsonKey(name: 'pending_claims') @Default(0) int pendingClaims,
    @JsonKey(name: 'expiring_soon') @Default(0) int expiringSoon,
  }) = _LostFoundStatsModel;

  const LostFoundStatsModel._();

  factory LostFoundStatsModel.fromJson(Map<String, dynamic> json) =>
      _$LostFoundStatsModelFromJson(json);

  /// Total active items
  int get totalActive => totalLost + totalFound;

  /// Claim rate percentage
  double get claimRate {
    final total = totalLost + totalFound + totalClaimed;
    if (total == 0) return 0;
    return (totalClaimed / total) * 100;
  }
}
