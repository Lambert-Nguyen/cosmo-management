/// Base repository for Cosmo Management
///
/// Provides common functionality for all repositories.
library;

import '../../core/services/api_service.dart';
import '../../core/services/storage_service.dart';

/// Base repository class
///
/// Provides common methods for API calls and caching.
abstract class BaseRepository {
  final ApiService apiService;
  final StorageService storageService;

  BaseRepository({
    required this.apiService,
    required this.storageService,
  });

  /// Get cached data or fetch from API
  Future<T> getCachedOrFetch<T>({
    required String cacheKey,
    required Future<T> Function() fetchFunction,
    required T Function(dynamic json) fromJson,
  }) async {
    // Try to get from cache first
    final cached = await storageService.getCachedData(cacheKey);
    if (cached != null) {
      try {
        return fromJson(cached);
      } catch (_) {
        // Cache corrupted, fetch fresh data
      }
    }

    // Fetch from API
    final data = await fetchFunction();

    // Cache the result
    await storageService.cacheData(cacheKey, data);

    return data;
  }

  /// Invalidate cache for a key
  Future<void> invalidateCache(String cacheKey) async {
    await storageService.removeCache(cacheKey);
  }
}
