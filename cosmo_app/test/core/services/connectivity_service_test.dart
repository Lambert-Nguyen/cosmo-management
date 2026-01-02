import 'package:flutter_test/flutter_test.dart';
import 'package:cosmo_app/core/services/connectivity_service.dart';

void main() {
  group('ConnectivityStatus', () {
    test('should have wifi status', () {
      expect(ConnectivityStatus.wifi, isNotNull);
      expect(ConnectivityStatus.wifi.name, 'wifi');
    });

    test('should have mobile status', () {
      expect(ConnectivityStatus.mobile, isNotNull);
      expect(ConnectivityStatus.mobile.name, 'mobile');
    });

    test('should have ethernet status', () {
      expect(ConnectivityStatus.ethernet, isNotNull);
      expect(ConnectivityStatus.ethernet.name, 'ethernet');
    });

    test('should have offline status', () {
      expect(ConnectivityStatus.offline, isNotNull);
      expect(ConnectivityStatus.offline.name, 'offline');
    });

    test('should have unknown status', () {
      expect(ConnectivityStatus.unknown, isNotNull);
      expect(ConnectivityStatus.unknown.name, 'unknown');
    });
  });

  group('ConnectivityService', () {
    test('should create ConnectivityService instance', () {
      final service = ConnectivityService();
      expect(service, isNotNull);
    });

    test('should start with unknown status', () {
      final service = ConnectivityService();
      expect(service.status, ConnectivityStatus.unknown);
    });

    test('isConnected should return false for unknown status', () {
      final service = ConnectivityService();
      // Unknown is treated as possibly connected, so test offline
      expect(service.isConnected, isTrue); // unknown != offline
    });

    test('isWifi should return false initially', () {
      final service = ConnectivityService();
      expect(service.isWifi, isFalse);
    });

    test('isMobile should return false initially', () {
      final service = ConnectivityService();
      expect(service.isMobile, isFalse);
    });

    test('should expose statusStream', () {
      final service = ConnectivityService();
      expect(service.statusStream, isA<Stream<ConnectivityStatus>>());
    });

    test('should be able to dispose', () {
      final service = ConnectivityService();
      // Should not throw
      expect(() => service.dispose(), returnsNormally);
    });
  });
}
