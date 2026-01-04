/// Storage service for Cosmo Management
///
/// Provides encrypted local storage using Hive for offline-first caching.
library;

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../config/env_config.dart';

/// Service for local data storage and caching
///
/// Uses Hive for fast NoSQL storage with:
/// - AES-256 encryption for sensitive data
/// - Automatic cache expiration
/// - Type-safe data retrieval
/// - Offline data persistence
class StorageService {
  static const String _cacheBoxName = 'cache_encrypted';
  static const String _metadataBoxName = 'cache_metadata';
  static const String _encryptionKeyName = 'hive_encryption_key';

  final FlutterSecureStorage _secureStorage;

  Box<String>? _cacheBox;
  Box<int>? _metadataBox;

  bool _isInitialized = false;

  StorageService({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(),
              iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
            );

  /// Initialize the storage service with encryption
  Future<void> init() async {
    if (_isInitialized) return;

    await Hive.initFlutter();

    // Get or generate encryption key
    final encryptionKey = await _getOrCreateEncryptionKey();
    final cipher = HiveAesCipher(encryptionKey);

    // Open encrypted cache box
    _cacheBox = await Hive.openBox<String>(
      _cacheBoxName,
      encryptionCipher: cipher,
    );

    // Metadata box doesn't need encryption (just timestamps)
    _metadataBox = await Hive.openBox<int>(_metadataBoxName);

    _isInitialized = true;
  }

  /// Get or create the encryption key
  Future<Uint8List> _getOrCreateEncryptionKey() async {
    // Try to get existing key
    final existingKey = await _secureStorage.read(key: _encryptionKeyName);

    if (existingKey != null) {
      // Decode existing key from base64
      return base64Decode(existingKey);
    }

    // Generate new 256-bit key (32 bytes)
    final newKey = Hive.generateSecureKey();
    final keyBytes = Uint8List.fromList(newKey);

    // Store key securely
    await _secureStorage.write(
      key: _encryptionKeyName,
      value: base64Encode(keyBytes),
    );

    return keyBytes;
  }

  /// Ensure the service is initialized
  void _ensureInitialized() {
    if (!_isInitialized) {
      throw StateError('StorageService not initialized. Call init() first.');
    }
  }

  /// Cache data with automatic JSON serialization (encrypted)
  Future<void> cacheData<T>(String key, T data) async {
    _ensureInitialized();

    final jsonString = jsonEncode(data);
    await _cacheBox!.put(key, jsonString);

    // Store timestamp for cache expiration
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    await _metadataBox!.put(key, timestamp);
  }

  /// Get cached data with automatic JSON deserialization
  Future<T?> getCachedData<T>(
    String key, {
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    _ensureInitialized();

    // Check if cache has expired
    if (_isCacheExpired(key)) {
      await _removeCache(key);
      return null;
    }

    final jsonString = _cacheBox!.get(key);
    if (jsonString == null) return null;

    try {
      final decoded = jsonDecode(jsonString);

      if (fromJson != null && decoded is Map<String, dynamic>) {
        return fromJson(decoded);
      }

      return decoded as T;
    } catch (e) {
      // Invalid cache data, remove it
      await _removeCache(key);
      return null;
    }
  }

  /// Get cached list data with automatic JSON deserialization
  Future<List<T>?> getCachedList<T>(
    String key, {
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    _ensureInitialized();

    // Check if cache has expired
    if (_isCacheExpired(key)) {
      await _removeCache(key);
      return null;
    }

    final jsonString = _cacheBox!.get(key);
    if (jsonString == null) return null;

    try {
      final decoded = jsonDecode(jsonString) as List<dynamic>;
      return decoded
          .map((item) => fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Invalid cache data, remove it
      await _removeCache(key);
      return null;
    }
  }

  /// Check if data exists in cache and is not expired
  bool hasValidCache(String key) {
    _ensureInitialized();

    if (!_cacheBox!.containsKey(key)) return false;
    return !_isCacheExpired(key);
  }

  /// Remove specific cached data
  Future<void> removeCache(String key) async {
    _ensureInitialized();
    await _removeCache(key);
  }

  /// Clear all cached data
  Future<void> clearCache() async {
    _ensureInitialized();
    await _cacheBox!.clear();
    await _metadataBox!.clear();
  }

  /// Clear expired cache entries
  Future<void> clearExpiredCache() async {
    _ensureInitialized();

    final keysToRemove = <String>[];

    for (final key in _cacheBox!.keys) {
      if (_isCacheExpired(key as String)) {
        keysToRemove.add(key);
      }
    }

    for (final key in keysToRemove) {
      await _removeCache(key);
    }
  }

  /// Get all cache keys
  List<String> getCacheKeys() {
    _ensureInitialized();
    return _cacheBox!.keys.cast<String>().toList();
  }

  /// Get cache size in bytes (approximate)
  int getCacheSize() {
    _ensureInitialized();

    int size = 0;
    for (final key in _cacheBox!.keys) {
      final value = _cacheBox!.get(key);
      if (value != null) {
        size += value.length;
      }
    }
    return size;
  }

  /// Check if encryption is enabled (always true after init)
  bool get isEncrypted => _isInitialized;

  /// Check if cache has expired based on EnvConfig.cacheExpiryHours
  bool _isCacheExpired(String key) {
    final timestamp = _metadataBox!.get(key);
    if (timestamp == null) return true;

    final cachedAt = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final expiryDuration = Duration(hours: EnvConfig.cacheExpiryHours);
    final expiryTime = cachedAt.add(expiryDuration);

    return DateTime.now().isAfter(expiryTime);
  }

  /// Remove cache entry and its metadata
  Future<void> _removeCache(String key) async {
    await _cacheBox!.delete(key);
    await _metadataBox!.delete(key);
  }

  /// Close the storage service
  Future<void> close() async {
    if (_isInitialized) {
      await _cacheBox?.close();
      await _metadataBox?.close();
      _isInitialized = false;
    }
  }

  /// Delete all data including encryption key (for logout/reset)
  Future<void> deleteAll() async {
    await close();

    // Delete encryption key
    await _secureStorage.delete(key: _encryptionKeyName);

    // Delete Hive boxes
    await Hive.deleteBoxFromDisk(_cacheBoxName);
    await Hive.deleteBoxFromDisk(_metadataBoxName);
  }
}
