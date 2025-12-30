# Cosmo App

Flutter application for **Cosmo Management** - Universal Property & Operations Management Platform.

## Overview

This is the mobile/web frontend for Cosmo Management, built with Flutter. It connects to the Django REST API backend (`cosmo_backend/`).

## Technology Stack

| Category | Technology | Version |
|----------|-----------|---------|
| **State Management** | Riverpod 2.x | ^2.6.1 |
| **HTTP Client** | Dio | ^5.7.0 |
| **Routing** | GoRouter | ^17.0.0 |
| **Local Storage** | Hive | ^2.2.3 |
| **Immutable Models** | Freezed | ^2.5.7 |
| **Firebase** | firebase_core, firebase_messaging | ^4.3.0, ^16.1.0 |

## Getting Started

### Prerequisites

- Flutter SDK ^3.7.2
- Dart SDK ^3.7.2
- Android Studio / Xcode (for mobile development)

### Installation

```bash
# Get dependencies
flutter pub get

# Run code generation (for Freezed, Riverpod, Hive)
dart run build_runner build --delete-conflicting-outputs

# Run on device/emulator
flutter run

# Build for web
flutter build web
```

### Backend Connection

The app connects to the Django backend API. For local development:

1. Start the backend server:
   ```bash
   cd ../cosmo_backend
   python manage.py runserver --settings=backend.settings_local
   ```

2. The app is configured to connect to localhost by default. Update the API base URL in the app configuration for production.

## Project Structure

```
lib/
├── main.dart              # App entry point
├── firebase_options.dart  # Firebase configuration
├── core/                  # Core utilities, constants, themes
├── features/              # Feature modules (auth, tasks, etc.)
├── models/                # Data models (Freezed)
├── providers/             # Riverpod providers
├── services/              # API services, local storage
└── widgets/               # Reusable widgets
```

## Development Phases

- **Phase 0:** Project renaming & setup
- **Phase 1:** Backend preparation (JWT, CORS, API docs)
- **Phase 2:** Authentication + Staff Core (current)
- **Phase 3+:** Additional features

## Platform Support

| Platform | Status |
|----------|--------|
| Android | Configured |
| iOS | Configured |
| Web | Configured |
| macOS | Configured |
| Windows | Configured |

## Bundle Identifiers

- **Android:** `com.cosmomgmt.app`
- **iOS:** `com.cosmomgmt.app`

## License

Proprietary - Cosmo Management
