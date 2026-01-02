/// Connectivity service for Cosmo Management
///
/// Monitors network connectivity status for offline-first support.
library;

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Service for monitoring network connectivity
///
/// Provides:
/// - Current connectivity status
/// - Stream of connectivity changes
/// - Utility methods for checking connection type
class ConnectivityService {
  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  final _connectivityController =
      StreamController<ConnectivityStatus>.broadcast();

  ConnectivityStatus _currentStatus = ConnectivityStatus.unknown;

  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  /// Initialize the connectivity service
  Future<void> init() async {
    // Get initial status
    final results = await _connectivity.checkConnectivity();
    _currentStatus = _mapConnectivityResult(results);

    // Listen for changes
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      _currentStatus = _mapConnectivityResult(results);
      _connectivityController.add(_currentStatus);
    });
  }

  /// Current connectivity status
  ConnectivityStatus get status => _currentStatus;

  /// Stream of connectivity changes
  Stream<ConnectivityStatus> get statusStream => _connectivityController.stream;

  /// Whether the device has any network connection
  bool get isConnected => _currentStatus != ConnectivityStatus.offline;

  /// Whether the device is connected via WiFi
  bool get isWifi => _currentStatus == ConnectivityStatus.wifi;

  /// Whether the device is connected via mobile data
  bool get isMobile => _currentStatus == ConnectivityStatus.mobile;

  /// Check connectivity and return current status
  Future<ConnectivityStatus> checkConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    _currentStatus = _mapConnectivityResult(results);
    return _currentStatus;
  }

  /// Map connectivity results to our status enum
  ConnectivityStatus _mapConnectivityResult(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.wifi)) {
      return ConnectivityStatus.wifi;
    }
    if (results.contains(ConnectivityResult.mobile)) {
      return ConnectivityStatus.mobile;
    }
    if (results.contains(ConnectivityResult.ethernet)) {
      return ConnectivityStatus.ethernet;
    }
    if (results.contains(ConnectivityResult.none)) {
      return ConnectivityStatus.offline;
    }
    return ConnectivityStatus.unknown;
  }

  /// Dispose resources
  void dispose() {
    _subscription?.cancel();
    _connectivityController.close();
  }
}

/// Simplified connectivity status
enum ConnectivityStatus {
  /// Connected via WiFi
  wifi,

  /// Connected via mobile data
  mobile,

  /// Connected via ethernet
  ethernet,

  /// No network connection
  offline,

  /// Unknown status
  unknown,
}
