# Flutter JWT Integration Guide

## Cosmo Management - Phase 1 Documentation

**Created:** 2025-12-30
**For:** Flutter Web/Mobile Development (Phase 2+)

---

## Overview

This guide documents how to integrate JWT authentication in the Flutter app with the Cosmo Management backend.

## Backend Endpoints

### Authentication Endpoints

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/token/` | POST | Login - get access & refresh tokens |
| `/api/token/refresh/` | POST | Refresh expired access token |
| `/api/token/verify/` | POST | Verify if token is valid |
| `/api/token/revoke/` | POST | Logout - revoke refresh token |
| `/api/token/revoke-all/` | POST | Logout all devices |
| `/api/users/me/` | GET | Get current user profile |

---

## JWT Token Lifecycle

```
┌─────────────────────────────────────────────────────────────────┐
│                      JWT Token Flow                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  1. LOGIN                                                        │
│     POST /api/token/                                             │
│     Body: {"username": "...", "password": "..."}                 │
│     Response: {access, refresh, user}                            │
│                                                                  │
│  2. API REQUESTS                                                 │
│     Header: Authorization: Bearer <access_token>                 │
│                                                                  │
│  3. TOKEN REFRESH (when access expires)                          │
│     POST /api/token/refresh/                                     │
│     Body: {"refresh": "<refresh_token>"}                         │
│     Response: {access, refresh}                                  │
│                                                                  │
│  4. LOGOUT                                                       │
│     POST /api/token/revoke/                                      │
│     Header: Authorization: Bearer <access_token>                 │
│     Body: {"refresh": "<refresh_token>"}                         │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Token Configuration

| Setting | Value |
|---------|-------|
| Access Token Lifetime | 1 hour |
| Refresh Token Lifetime | 7 days |
| Token Rotation | Enabled (new refresh token on each refresh) |
| Token Blacklist | Enabled (old tokens blacklisted) |
| Algorithm | HS256 |

---

## Response Formats

### Login Response (`POST /api/token/`)

```json
{
  "refresh": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
  "access": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
  "user": {
    "id": 8,
    "username": "testadmin",
    "email": "test@example.com",
    "role": "superuser",
    "is_superuser": true
  }
}
```

### Refresh Response (`POST /api/token/refresh/`)

```json
{
  "access": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
  "refresh": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..."
}
```

### User Profile (`GET /api/users/me/`)

```json
{
  "id": 8,
  "username": "testadmin",
  "email": "test@example.com",
  "first_name": "",
  "last_name": "",
  "is_superuser": true,
  "is_active": true,
  "role": "superuser",
  "task_group": "none",
  "timezone": "America/New_York",
  "system_timezone": "America/New_York"
}
```

---

## Flutter Implementation

### Dependencies (pubspec.yaml)

```yaml
dependencies:
  dio: ^5.4.0
  flutter_secure_storage: ^9.0.0
  jwt_decoder: ^2.0.1
```

### Token Storage Service

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _storage = FlutterSecureStorage();
  static const _accessKey = 'jwt_access_token';
  static const _refreshKey = 'jwt_refresh_token';

  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _accessKey, value: accessToken);
    await _storage.write(key: _refreshKey, value: refreshToken);
  }

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessKey);
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshKey);
  }

  static Future<void> clearTokens() async {
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
  }

  static Future<bool> hasTokens() async {
    final access = await getAccessToken();
    return access != null && access.isNotEmpty;
  }
}
```

### Auth Service

```dart
import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  final Dio _dio;
  static const baseUrl = 'http://localhost:8000';

  AuthService(this._dio);

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await _dio.post(
      '$baseUrl/api/token/',
      data: {'username': username, 'password': password},
    );

    final data = response.data;
    await TokenStorage.saveTokens(
      accessToken: data['access'],
      refreshToken: data['refresh'],
    );

    return data['user'];
  }

  Future<void> logout() async {
    try {
      final refreshToken = await TokenStorage.getRefreshToken();
      if (refreshToken != null) {
        await _dio.post(
          '$baseUrl/api/token/revoke/',
          data: {'refresh': refreshToken},
        );
      }
    } finally {
      await TokenStorage.clearTokens();
    }
  }

  Future<bool> refreshToken() async {
    final refreshToken = await TokenStorage.getRefreshToken();
    if (refreshToken == null) return false;

    try {
      final response = await _dio.post(
        '$baseUrl/api/token/refresh/',
        data: {'refresh': refreshToken},
      );

      await TokenStorage.saveTokens(
        accessToken: response.data['access'],
        refreshToken: response.data['refresh'],
      );
      return true;
    } catch (e) {
      await TokenStorage.clearTokens();
      return false;
    }
  }

  bool isTokenExpired(String token) {
    return JwtDecoder.isExpired(token);
  }
}
```

### Dio Interceptor for Auto-Refresh

```dart
class AuthInterceptor extends Interceptor {
  final AuthService _authService;

  AuthInterceptor(this._authService);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth for public endpoints
    if (_isPublicEndpoint(options.path)) {
      return handler.next(options);
    }

    final accessToken = await TokenStorage.getAccessToken();
    if (accessToken != null) {
      // Check if token is about to expire (within 5 minutes)
      if (_authService.isTokenExpired(accessToken)) {
        final refreshed = await _authService.refreshToken();
        if (!refreshed) {
          return handler.reject(
            DioException(
              requestOptions: options,
              error: 'Session expired. Please login again.',
            ),
          );
        }
        // Get new token after refresh
        final newToken = await TokenStorage.getAccessToken();
        options.headers['Authorization'] = 'Bearer $newToken';
      } else {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Try to refresh token
      final refreshed = await _authService.refreshToken();
      if (refreshed) {
        // Retry the request
        final newToken = await TokenStorage.getAccessToken();
        err.requestOptions.headers['Authorization'] = 'Bearer $newToken';

        try {
          final response = await Dio().fetch(err.requestOptions);
          return handler.resolve(response);
        } catch (e) {
          return handler.next(err);
        }
      }
    }
    return handler.next(err);
  }

  bool _isPublicEndpoint(String path) {
    const publicPaths = [
      '/api/token/',
      '/api/token/refresh/',
      '/api/token/verify/',
      '/api/register/',
      '/api/validate-invite/',
      '/api/auth/password_reset/',
    ];
    return publicPaths.any((p) => path.startsWith(p));
  }
}
```

### Dio Setup

```dart
Dio createDio() {
  final dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:8000',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  final authService = AuthService(dio);
  dio.interceptors.add(AuthInterceptor(authService));
  dio.interceptors.add(LogInterceptor(responseBody: true));

  return dio;
}
```

---

## Error Handling

### Common Error Responses

| Status Code | Meaning | Action |
|-------------|---------|--------|
| 400 | Bad Request | Show validation error |
| 401 | Unauthorized | Refresh token or redirect to login |
| 403 | Forbidden | Show access denied message |
| 404 | Not Found | Show not found message |
| 429 | Rate Limited | Show "too many requests" message |
| 500 | Server Error | Show generic error |

### Rate Limits

| Endpoint | Limit |
|----------|-------|
| `/api/token/` | 5 requests/minute |
| `/api/token/refresh/` | 2 requests/minute |
| General API | 1000 requests/hour |

---

## CORS Configuration

For Flutter Web development, CORS is pre-configured for:

- `http://localhost:3000`
- `http://localhost:8080`
- `http://localhost:5000`
- `http://127.0.0.1:3000`
- `http://127.0.0.1:8080`

Flutter Web runs on port 3000 by default with `flutter run -d chrome`.

---

## Testing

### Test Login

```bash
curl -X POST http://localhost:8000/api/token/ \
  -H "Content-Type: application/json" \
  -d '{"username":"testadmin","password":"testpass123"}'
```

### Test Authenticated Request

```bash
curl http://localhost:8000/api/users/me/ \
  -H "Authorization: Bearer <access_token>"
```

### Test Token Refresh

```bash
curl -X POST http://localhost:8000/api/token/refresh/ \
  -H "Content-Type: application/json" \
  -d '{"refresh":"<refresh_token>"}'
```

---

## Mobile Development Setup

### Android Configuration (Already Done)

The following configurations have been applied to `cosmo_app/android/app/src/main/AndroidManifest.xml`:

```xml
<!-- Network permissions -->
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>

<!-- Allow HTTP for development -->
<application android:usesCleartextTraffic="true">
```

### iOS Configuration (Already Done)

The following is configured in `cosmo_app/ios/Runner/Info.plist`:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

### API Base URL by Platform

```dart
class ApiConfig {
  static String get baseUrl {
    if (kIsWeb) {
      // Flutter Web - same origin or localhost
      return 'http://localhost:8000';
    } else if (Platform.isAndroid) {
      // Android Emulator - special IP for host machine
      return 'http://10.0.2.2:8000';
    } else if (Platform.isIOS) {
      // iOS Simulator - localhost works
      return 'http://localhost:8000';
    } else {
      // Physical device - use your machine's local IP
      return 'http://192.168.1.XXX:8000'; // Replace with actual IP
    }
  }
}
```

### Testing on Physical Devices

For physical Android/iOS devices on the same WiFi network:

1. Find your machine's local IP: `ifconfig | grep "inet " | grep -v 127.0.0.1`
2. Update `ApiConfig.baseUrl` to use that IP (e.g., `http://192.168.1.100:8000`)
3. Ensure Django is running with `python manage.py runserver 0.0.0.0:8000`
4. Make sure your firewall allows port 8000

### Production Configuration

For production, remove development-only settings:

**Android:** Set `android:usesCleartextTraffic="false"` or remove it entirely

**iOS:** Remove `NSAllowsArbitraryLoads` or set to `false`, then add specific domain exceptions:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSExceptionDomains</key>
    <dict>
        <key>your-api-domain.com</key>
        <dict>
            <key>NSExceptionAllowsInsecureHTTPLoads</key>
            <false/>
            <key>NSExceptionRequiresForwardSecrecy</key>
            <true/>
        </dict>
    </dict>
</dict>
```

---

## Checklist for Flutter Integration

- [ ] Install dependencies (dio, flutter_secure_storage, jwt_decoder)
- [ ] Create TokenStorage service
- [ ] Create AuthService
- [ ] Create AuthInterceptor
- [ ] Configure Dio with interceptor
- [ ] Create login screen
- [ ] Handle token refresh
- [ ] Handle logout
- [ ] Test on Flutter Web (localhost:3000)
- [ ] Test on Android Emulator (10.0.2.2:8000)
- [ ] Test on iOS Simulator (localhost:8000)
- [ ] Test on physical device (local network IP)

---

## Security Notes

1. **Never store tokens in SharedPreferences** - Use flutter_secure_storage
2. **Always use HTTPS in production** - HTTP only for local development
3. **Handle token expiration gracefully** - Auto-refresh or redirect to login
4. **Clear tokens on logout** - Both access and refresh
5. **Rate limiting is enforced** - Handle 429 errors appropriately

---

**Document created by:** Claude Code
**Date:** 2025-12-30
