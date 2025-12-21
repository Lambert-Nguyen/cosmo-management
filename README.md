# 🏨 Aristay - Property Management System

**Aristay** is a comprehensive, enterprise-grade property management platform designed for modern hospitality operations. It features a robust Django REST API backend with JWT authentication, automated task management, real-time chat, and a Flutter mobile application.

## 🎯 Project Overview

### Core Features
- 🔐 **JWT Authentication** - Secure, token-based authentication system
- 📋 **Booking Management** - Comprehensive reservation and guest management
- 🤖 **Task Automation** - Automated cleaning and maintenance task creation
- 👥 **Role-Based Access Control** - Granular permission system with 38 custom permissions
- 💬 **Real-Time Chat** - WebSocket-based messaging system with Django Channels
- 📱 **Mobile Application** - Flutter-based mobile interface
- 📊 **Admin Dashboard** - Staff management and reporting interface
- 📸 **Photo Management** - Before/after photo tracking and approval workflow
- 📅 **Calendar System** - Property and task scheduling interface
- 🎨 **Modern UI/UX** - **100% refactored** with ES modules and design system ✨

### Technology Stack
- **Backend**: Django REST Framework with PostgreSQL
- **Real-Time**: Django Channels with Redis for WebSocket support
- **Frontend**: Flutter mobile application
- **Web UI**: Modern Django templates with ES module architecture
- **Design System**: Consistent tokens, components, and patterns
- **Authentication**: JWT with djangorestframework-simplejwt
- **CDN**: Cloudinary with 8x compression
- **Testing**: Comprehensive test suite with pytest
- **Deployment**: Production-ready with security hardening

## 🚀 Quick Start

### Prerequisites
- Python 3.13+ with virtual environment
- Node.js and Flutter SDK (for mobile app)
- PostgreSQL database
- Git

### Installation
```bash
# Clone the repository
git clone <repository-url>
cd aristay_app

# Set up backend environment
cd aristay_backend
python -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate
pip install -r requirements.txt

# Set up environment variables
cp ../env.production.example .env
# Edit .env with your configuration

# Run database migrations
python manage.py migrate --settings=backend.settings_local

# Create superuser
python manage.py createsuperuser --settings=backend.settings_local

# Collect static files
python manage.py collectstatic --noinput --settings=backend.settings_local

# Start development server
python manage.py runserver --settings=backend.settings_local
```

Visit `http://127.0.0.1:8000` to access the application.

### Flutter Mobile App Setup
```bash
# Navigate to Flutter directory
cd aristay_flutter_frontend

# Install dependencies
flutter pub get

# Run the app
flutter run
```

## 📚 Documentation

All project documentation is comprehensively organized in the [`docs/`](docs/) directory:

### 📋 Essential Documentation
- **[docs/README.md](docs/README.md)** - ⭐ Complete documentation hub (START HERE!)
- **[docs/DOCUMENTATION_INDEX.md](docs/DOCUMENTATION_INDEX.md)** - Full documentation catalog
- **[docs/CURRENT_DOCUMENTATION.md](docs/CURRENT_DOCUMENTATION.md)** - Quick reference guide
- **[docs/refactoring/STATUS_AND_REFACTOR_PLAN_2025-12-13.md](docs/refactoring/STATUS_AND_REFACTOR_PLAN_2025-12-13.md)** - ✅ **100% COMPLETE** UI refactoring status

### 🔗 Quick Links
- **Setup**: [Local Development](docs/development/LOCAL_DEVELOPMENT_SETUP.md) | [Deployment Guide](docs/deployment/DEPLOYMENT_GUIDE_2025-09-12.md)
- **Features**: [Chat System](docs/features/chat/CHAT_SYSTEM_QUICKSTART.md) | [Calendar](docs/features/calendar_user_guide.md) | [Photo Management](docs/features/BEFORE_AFTER_PHOTO_QUICK_REFERENCE.md)
- **Backend**: [API Endpoints](docs/backend/API_ENDPOINTS_2025-09-12.md) | [Environment Config](docs/backend/ENVIRONMENT_CONFIGURATION.md)
- **Security**: [JWT Authentication](docs/security/JWT_AUTHENTICATION_GUIDE.md) | [Security Implementation](docs/security/ENHANCED_SECURITY_IMPLEMENTATION.md)
- **Testing**: [Testing Manual](docs/TESTING_MANUAL.md) | [Test Organization](docs/testing/TEST_ORGANIZATION.md)

## 🧪 Testing

The project includes a comprehensive test suite organized by scope and purpose:

```bash
# Run all tests using the comprehensive test runner
python tests/run_tests_comprehensive.py

# Run specific test suites
python tests/run_tests_comprehensive.py --ui          # UI tests
python tests/run_tests_comprehensive.py --api         # API tests
python tests/run_tests_comprehensive.py --security    # Security tests
python tests/run_tests_comprehensive.py --integration # Integration tests

# Verify refactoring quality
./verify_refactoring.sh
```

### Test Categories
- **Unit Tests**: Component-specific validation
- **Integration Tests**: Multi-component workflows
- **Security Tests**: Authentication and authorization
- **Production Tests**: Production readiness validation
- **API Tests**: Endpoint functionality testing
- **UI Tests**: Template and interface testing
- **Booking Tests**: Reservation system validation
- **Cloudinary Tests**: CDN integration testing

## 🎨 UI/UX Refactoring - 100% COMPLETE ✅

**Major achievement**: Complete modernization of Django template architecture

### Refactoring Results
- ✅ **100% inline event handlers removed** (67 → 0)
- ✅ **100% inline styles eliminated** (202 → 0)
- ✅ **All templates refactored** (Staff, Portal, Admin, Manager, Layouts)
- ✅ **31 CSS page files created** with design system
- ✅ **18 JavaScript ES modules** implemented
- ✅ **Design system established** with consistent tokens
- ✅ **Event delegation** throughout
- ✅ **CSRF-safe API client** for all requests
- ✅ **All tests passing** - Zero regressions

### What Changed
- **Before**: Inline onclick handlers, scattered styles, hard to maintain
- **After**: Modern ES modules, external CSS, design system, easy to maintain

**For details**: See [docs/refactoring/STATUS_AND_REFACTOR_PLAN_2025-12-13.md](docs/refactoring/STATUS_AND_REFACTOR_PLAN_2025-12-13.md)

## 🔐 Security Features

Aristay implements enterprise-grade security:

- **JWT Authentication** with refresh tokens and secure headers
- **Rate Limiting** with redis-based throttling
- **Role-Based Permissions** with 38 custom permissions
- **API Security** with CORS, CSRF protection, and input validation
- **Production Hardening** with security headers and monitoring
- **Audit System** - Transaction-safe logging with universal JSON serialization

For detailed security information, see the [Security Documentation](docs/security/).

## 🏗️ Project Structure

```
aristay_app/
├── README.md                          # This file
├── verify_refactoring.sh              # Refactoring verification script
├── conftest.py                        # Global pytest configuration
├── pytest.ini                         # Test configuration
├── requirements.txt                   # Python dependencies
├── aristay_backend/                   # Django REST API
│   ├── api/                           # API application
│   │   ├── models_chat.py            # Chat models
│   │   ├── views_chat.py             # Chat views
│   │   ├── consumers.py              # WebSocket consumers
│   │   ├── templates/                # Django templates (100% refactored!)
│   │   └── management/commands/      # Custom Django commands
│   ├── static/                        # Static assets (NEW!)
│   │   ├── css/                      # Organized CSS
│   │   │   ├── design-system.css     # Design tokens
│   │   │   ├── components.css        # Reusable components
│   │   │   └── pages/                # Page-specific CSS (31 files)
│   │   └── js/                       # Organized JavaScript
│   │       ├── core/                 # Core utilities (API client, CSRF)
│   │       ├── pages/                # Page entrypoints (18 files)
│   │       └── modules/              # Feature managers (8 files)
│   ├── backend/                       # Django settings
│   │   ├── settings_base.py          # Base settings
│   │   ├── settings_local.py         # Local development
│   │   ├── settings_production.py    # Production settings
│   │   └── settings_test.py          # Test settings
│   └── manage.py                      # Django management
├── aristay_flutter_frontend/          # Flutter mobile app
├── tests/                             # Comprehensive test suite
│   ├── run_tests_comprehensive.py    # Main test runner
│   ├── api/                          # API tests
│   ├── chat/                         # Chat system tests
│   ├── ui/                           # UI tests
│   ├── backend/                      # Backend tests
│   ├── security/                     # Security tests
│   ├── booking/                      # Booking tests
│   └── utils/                        # Test utilities
├── docs/                              # Complete documentation
│   ├── README.md                     # Documentation hub (START HERE!)
│   ├── DOCUMENTATION_INDEX.md        # Complete catalog
│   ├── CURRENT_DOCUMENTATION.md      # Quick reference
│   ├── refactoring/                  # UI refactoring docs (100% complete!)
│   ├── features/                     # Feature documentation
│   ├── backend/                      # Backend documentation
│   ├── testing/                      # Testing guides
│   ├── security/                     # Security documentation
│   ├── development/                  # Development guides
│   ├── deployment/                   # Deployment guides
│   └── archive/                      # Historical documentation
└── scripts/                           # Development & admin scripts
    ├── testing/                      # Test scripts
    └── admin/                        # Administrative scripts
```

## 📊 Project Status

### ✅ Production Ready - All Features Complete

✅ **Core System** - Enterprise-ready with comprehensive testing
✅ **Security Hardened** - JWT authentication, rate limiting, audit logging
✅ **Well Documented** - 210+ active documentation files
✅ **Fully Tested** - Comprehensive test coverage across 8 test suites
✅ **Modern UI/UX** - **100% refactored** with ES modules and design system (Dec 21, 2025)
✅ **Chat System** - Real-time messaging with WebSocket support
✅ **Photo Management** - Before/after workflow with approval system
✅ **CDN Integration** - Cloudinary delivering 8x compression
✅ **Clean Codebase** - Professional project organization
✅ **Mobile Ready** - Flutter application for iOS/Android

### Recent Updates (December 2025)

#### 🎉 UI Refactoring COMPLETE (Dec 21, 2025)
- ✅ **100% inline handlers removed** - All 67 converted to event delegation
- ✅ **100% inline styles eliminated** - All 202 moved to external CSS
- ✅ **Modern ES modules** - 18 page modules + 8 feature modules created
- ✅ **Design system** - 31 CSS files with consistent tokens
- ✅ **All tests passing** - Zero regressions, quality gate passed
- ✅ **Production ready** - Browser tested, mobile responsive, accessible

#### 📚 Documentation Cleanup (Dec 21, 2025)
- ✅ Removed 15+ duplicate documents
- ✅ Archived 35+ completed fixes and implementations
- ✅ Created organized archive structure
- ✅ Updated all documentation indexes
- ✅ Result: 210 active + 35 archived files (40% reduction)

### Previous Updates (November 2025)
- ✨ Fixed chat UI authentication and error handling
- 🗂️ Major project reorganization (60 files)
- 📚 Improved documentation structure

## 🔧 Development Workflow

### For New Features
1. Review [Development Setup](docs/development/LOCAL_DEVELOPMENT_SETUP.md)
2. Follow established patterns from [Refactoring Guide](docs/refactoring/STATUS_AND_REFACTOR_PLAN_2025-12-13.md)
3. Use design system tokens and components
4. Add comprehensive tests
5. Update documentation
6. Run full test suite

### For UI Changes
1. Use external CSS files in `static/css/pages/`
2. Use ES modules in `static/js/pages/` or `static/js/modules/`
3. Implement event delegation with `data-action` attributes
4. Use design system tokens from `design-system.css`
5. Follow established patterns (see refactoring docs)

### For Bug Fixes
1. Reproduce issue with test case
2. Implement fix following established patterns
3. Verify fix with all relevant tests
4. Update documentation if needed

## 📈 Performance & Scalability

- **Database Optimization**: Efficient queries with proper indexing
- **API Performance**: Optimized endpoints with caching
- **Mobile Performance**: Efficient Flutter implementation
- **CDN Integration**: Cloudinary with 8x image compression
- **Static Assets**: Browser-cacheable external CSS/JS
- **Scalable Architecture**: Modular design for growth

## 🆘 Support & Troubleshooting

### Common Issues
- **Environment Setup**: See [Local Development Setup](docs/development/LOCAL_DEVELOPMENT_SETUP.md)
- **Test Failures**: See [Testing Manual](docs/TESTING_MANUAL.md)
- **Deployment Issues**: See [Deployment Guide](docs/deployment/DEPLOYMENT_GUIDE_2025-09-12.md)
- **UI Questions**: See [Refactoring Status](docs/refactoring/STATUS_AND_REFACTOR_PLAN_2025-12-13.md)

### Getting Help
1. Check the [Documentation Hub](docs/README.md)
2. Review relevant troubleshooting guides
3. Check test output for specific error messages
4. Consult refactoring docs for UI patterns
5. Review archived documentation for historical context

## 📝 License

Copyright (c) 2025 Nguyen, Phuong Duy Lam. All rights reserved.

## 🏆 Acknowledgments

- **Django REST Framework** for robust API development
- **Flutter** for cross-platform mobile development
- **JWT Authentication** for secure token-based auth
- **pytest** for comprehensive testing framework
- **Cloudinary** for global CDN and image optimization
- **Django Channels** for WebSocket support

---

**Aristay Property Management System**
*Professional • Secure • Scalable • Modern*

✨ **UI Refactoring 100% Complete** - December 21, 2025 ✨
*Enterprise-grade, production-ready property management platform*

**Last Updated**: December 21, 2025
