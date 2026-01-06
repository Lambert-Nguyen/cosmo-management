# Cosmo Management

**Cosmo Management** is a comprehensive property and operations management platform built with a Flutter-first, offline-first architecture. It features a Django REST API backend with JWT authentication, automated task management, and native mobile applications for iOS and Android.

## Project Status

| Component | Status | Description |
|-----------|--------|-------------|
| **Backend API** | Production Ready | Django REST + PostgreSQL + JWT |
| **Flutter App** | Phase 4 Complete | Staff Module 100% implemented |
| **Offline Sync** | Implemented | Idempotency-based deduplication |
| **Stage** | Stage 1 Alpha | Architecture validation |

### What's Working
- JWT Authentication (login, register, password reset)
- Staff Task Management (list, detail, create, edit, complete)
- Offline-First Architecture (queue mutations, sync on reconnect)
- Idempotency System (prevents duplicate mutations on replay)
- Photo Management (upload, queue offline, sync)
- Conflict Resolution UI (resolve server vs local conflicts)

---

## Quick Start Guide

### Prerequisites

| Requirement | Version | Purpose |
|-------------|---------|---------|
| Python | 3.11+ | Django backend |
| PostgreSQL | 12+ | Database (required) |
| Flutter SDK | 3.19+ | Mobile app |
| Xcode | 15+ | iOS development (macOS only) |
| Android Studio | Latest | Android development |

---

## Step 1: Install PostgreSQL

### macOS
```bash
brew install postgresql@15
brew services start postgresql@15
```

### Ubuntu/Debian
```bash
sudo apt update
sudo apt install -y postgresql postgresql-contrib
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

### Create Database
```bash
# Create database and user
sudo -u postgres psql -c "CREATE DATABASE cosmo_db;"
sudo -u postgres psql -c "CREATE USER postgres WITH PASSWORD 'postgres';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE cosmo_db TO postgres;"
sudo -u postgres psql -c "ALTER DATABASE cosmo_db OWNER TO postgres;"

# For PostgreSQL 15+ grant schema access
sudo -u postgres psql -d cosmo_db -c "GRANT ALL ON SCHEMA public TO postgres;"
```

---

## Step 2: Set Up Django Backend

```bash
# 1. Navigate to backend directory
cd cosmo-management/cosmo_backend

# 2. Create and activate virtual environment
python -m venv .venv
source .venv/bin/activate  # Windows: .venv\Scripts\activate

# 3. Install dependencies
pip install -r requirements.txt

# 4. Create logs directory
mkdir -p logs

# 5. Run database migrations
python manage.py migrate

# 6. Create admin superuser
python manage.py createsuperuser

# 7. Collect static files
python manage.py collectstatic --noinput

# 8. Start development server
python manage.py runserver
```

**Backend running at:** http://127.0.0.1:8000

### Verify Backend Setup
| URL | Purpose |
|-----|---------|
| http://127.0.0.1:8000/admin/ | Admin panel |
| http://127.0.0.1:8000/api/schema/swagger-ui/ | API documentation |
| http://127.0.0.1:8000/api/health/ | Health check |

---

## Step 3: Set Up Flutter App

```bash
# 1. Navigate to Flutter app directory
cd cosmo-management/cosmo_app

# 2. Get dependencies
flutter pub get

# 3. Generate Freezed models (required after model changes)
dart run build_runner build --delete-conflicting-outputs

# 4. Run on connected device or emulator
flutter run
```

### Configure API URL

Edit `lib/core/config/env_config.dart`:

```dart
class EnvConfig {
  // Choose the appropriate URL for your setup:

  // Android Emulator (default)
  static const String apiBaseUrl = 'http://10.0.2.2:8000/api';

  // iOS Simulator
  // static const String apiBaseUrl = 'http://localhost:8000/api';

  // Physical device (use your computer's IP)
  // static const String apiBaseUrl = 'http://192.168.x.x:8000/api';
}
```

### Run on Specific Platform
```bash
# List available devices
flutter devices

# iOS Simulator (macOS only)
flutter run -d ios

# Android Emulator
flutter run -d android

# Chrome (Web)
flutter run -d chrome
```

---

## Step 4: Create Test User

### Option A: Via Admin Panel
1. Go to http://127.0.0.1:8000/admin/
2. Login with superuser credentials
3. Navigate to **API > Invite Codes > Add**
4. Create invite code (e.g., `STAFF001`, role: `staff`, task_group: `cleaning`)
5. Open Flutter app and register using the invite code

### Option B: Via Django Shell
```bash
cd cosmo_backend
source .venv/bin/activate
python manage.py shell
```

```python
from django.contrib.auth.models import User
from api.models import InviteCode

# Create invite code
code = InviteCode.objects.create(
    code='STAFF001',
    created_by=User.objects.first(),
    task_group='cleaning',
    role='staff',
    max_uses=10
)
print(f"Created invite code: {code.code}")
```

---

## Step 5: Test Offline Sync

1. **Login** to the Flutter app
2. **Load tasks** while online
3. **Enable airplane mode** (go offline)
4. **Make changes** (update task status, complete checklist items)
5. **Observe** sync indicator showing pending changes
6. **Disable airplane mode** (go online)
7. **Watch** automatic sync - changes upload without duplicates

### Verify Idempotency Works
```bash
cd cosmo_backend
source .venv/bin/activate
python manage.py shell -c "from api.models import IdempotencyKey; print(f'Stored keys: {IdempotencyKey.objects.count()}')"
```

---

## Project Structure

```
cosmo-management/
├── cosmo_backend/                  # Django REST API
│   ├── api/
│   │   ├── models.py              # 38 database models
│   │   ├── views.py               # API endpoints
│   │   ├── serializers.py         # DRF serializers
│   │   ├── idempotency_middleware.py  # Offline sync dedupe
│   │   └── migrations/
│   ├── backend/
│   │   ├── settings.py            # Default settings
│   │   ├── settings_base.py       # Base configuration
│   │   └── settings_local.py      # Local development
│   └── manage.py
│
├── cosmo_app/                      # Flutter mobile app
│   ├── lib/
│   │   ├── main.dart              # App entry point
│   │   ├── core/
│   │   │   ├── config/            # Environment config
│   │   │   ├── services/          # API, Auth, Connectivity
│   │   │   └── router/            # GoRouter configuration
│   │   ├── data/
│   │   │   ├── models/            # Freezed models
│   │   │   └── repositories/      # Data repositories
│   │   └── features/
│   │       ├── auth/              # Login, Register, Password Reset
│   │       └── staff/             # Task list, detail, forms
│   └── test/
│
├── tests/                          # Backend test suite
├── docs/                           # Documentation
├── STAGE_1_EVIDENCE_CHECKLIST.md   # Stage 1 gate criteria
└── UI_DESIGN_PLAN_12212025.md      # Architecture plan
```

---

## Technology Stack

### Backend
| Component | Technology |
|-----------|------------|
| Framework | Django 5.x + Django REST Framework |
| Database | PostgreSQL 15+ |
| Authentication | JWT (djangorestframework-simplejwt) |
| File Storage | Cloudinary CDN |
| Real-time | Django Channels (WebSocket) |

### Flutter App
| Component | Technology |
|-----------|------------|
| State Management | Riverpod 2.x |
| HTTP Client | Dio with interceptors |
| Routing | GoRouter |
| Local Storage | Hive (AES-256 encrypted) |
| Secure Storage | flutter_secure_storage |
| Models | Freezed + json_serializable |

---

## Offline-First Architecture

```
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐
│   Flutter App   │────▶│   Hive Queue     │────▶│  Django API     │
│                 │     │  (UUID + Data)   │     │  (Idempotency)  │
└─────────────────┘     └──────────────────┘     └─────────────────┘
        │                        │                        │
        │   1. User makes        │   3. On reconnect,    │
        │      changes offline   │      replay queue     │
        │                        │                        │
        │   2. Store mutation    │   4. Server checks    │
        │      with UUID         │      X-Idempotency-Key│
        │                        │                        │
        │                        │   5. Dedupe or execute│
        └────────────────────────┴────────────────────────┘
```

### How It Works
1. **Mutation Queueing**: Changes made offline stored in Hive with UUIDs
2. **Idempotency Keys**: Each mutation has unique key in `X-Idempotency-Key` header
3. **Automatic Sync**: Connectivity restored triggers replay of queued mutations
4. **Deduplication**: Backend middleware returns cached response for duplicate keys
5. **Conflict Resolution**: UI allows user to choose server or local version

---

## Running Tests

### Backend Tests
```bash
cd cosmo_backend
source .venv/bin/activate

# Run all tests
python -m pytest

# Run with coverage
python -m pytest --cov=api --cov-report=html

# Run specific test file
python -m pytest tests/api/test_tasks.py -v
```

### Flutter Tests
```bash
cd cosmo_app

# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Generate HTML coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html  # macOS
```

---

## API Endpoints

### Authentication
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/token/` | Get JWT tokens (login) |
| POST | `/api/token/refresh/` | Refresh access token |
| POST | `/api/auth/register/` | Register with invite code |
| POST | `/api/auth/password-reset/` | Request password reset |

### Tasks
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/tasks/` | List tasks (paginated) |
| POST | `/api/tasks/` | Create task |
| GET | `/api/tasks/{id}/` | Get task detail |
| PATCH | `/api/tasks/{id}/` | Update task |
| POST | `/api/tasks/{id}/set-status/` | Change task status |
| POST | `/api/tasks/{id}/assign-to-me/` | Self-assign task |

**Full API docs:** http://127.0.0.1:8000/api/schema/swagger-ui/

---

## Troubleshooting

### PostgreSQL not running
```bash
# macOS
brew services start postgresql@15

# Linux
sudo systemctl start postgresql
```

### Database doesn't exist
```bash
sudo -u postgres psql -c "CREATE DATABASE cosmo_db;"
```

### Flutter build errors
```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### API connection refused (Android emulator)
Use `10.0.2.2` instead of `localhost` in `env_config.dart`

### Offline sync not creating keys
Check middleware is registered in `settings_base.py`:
```python
MIDDLEWARE = [
    ...
    'api.idempotency_middleware.IdempotencyMiddleware',
    ...
]
```

---

## Documentation

| Document | Description |
|----------|-------------|
| [UI_DESIGN_PLAN_12212025.md](UI_DESIGN_PLAN_12212025.md) | Full architecture and implementation plan |
| [STAGE_1_EVIDENCE_CHECKLIST.md](STAGE_1_EVIDENCE_CHECKLIST.md) | Stage 1 exit criteria checklist |
| [docs/README.md](docs/README.md) | Documentation hub |
| [docs/backend/API_ENDPOINTS_2025-09-12.md](docs/backend/API_ENDPOINTS_2025-09-12.md) | Complete API reference |

---

## License

Copyright (c) 2025-2026 Nguyen, Phuong Duy Lam. All rights reserved.

---

**Cosmo Management** - Professional Property Operations Platform

*Flutter-First | Offline-First | Production-Ready*

*Last Updated: January 5, 2026*
