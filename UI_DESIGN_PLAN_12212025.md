# AriStay UI Redesign Plan: Django Templates → Flutter Web

**Document Version:** 1.1
**Created:** 2025-12-21
**Last Updated:** 2025-12-22
**Status:** Planning Phase

---

## Executive Summary

This plan outlines the complete redesign of the AriStay property management system's user interface from Django templates to Flutter for web. Django will be retained exclusively for admin/superuser operations.

### Current State
- **90+ Django HTML templates** with 100% refactored modern CSS/JS
- **150+ API endpoints** (REST + Django views)
- **38 database models** with comprehensive relationships
- **Flutter mobile app** already exists with Firebase integration
- **PostgreSQL database** with soft-delete, audit trails, and history tracking

### Target State
- **Flutter Web** for all user-facing interfaces (Portal, Staff, Manager, Public)
- **Django Admin** for superuser/admin operations only
- **Unified Flutter codebase** for mobile + web (extend existing `aristay_flutter_frontend/`)

---

## Key Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| **Flutter Base** | Extend existing `aristay_flutter_frontend/` | Leverage existing Firebase setup and mobile infrastructure |
| **Manager Module** | Move to Flutter Web | Unified experience for managers alongside Portal/Staff |
| **Chat Implementation** | HTTP Polling first | Simpler implementation, add WebSocket later |
| **Phase Priority** | All modules equally important | Balanced development across Staff, Portal, Chat |

---

## Architecture Overview

### Current Architecture
```
┌─────────────────────────────────────────────────────────────┐
│                         Users                                │
├──────────────┬───────────────┬──────────────┬───────────────┤
│  Public      │  Portal       │  Staff       │  Admin        │
│  (Login)     │  (Owners)     │  (Workers)   │  (System)     │
├──────────────┴───────────────┴──────────────┴───────────────┤
│            Django Templates (90+ HTML files)                 │
├─────────────────────────────────────────────────────────────┤
│            Django REST API (150+ endpoints)                  │
├─────────────────────────────────────────────────────────────┤
│                    PostgreSQL (38 models)                    │
└─────────────────────────────────────────────────────────────┘
```

### Target Architecture
```
┌─────────────────────────────────────────────────────────────┐
│                         Users                                │
├──────────────┬───────────────┬──────────────┬───────────────┤
│  Public      │  Portal       │  Staff       │  Admin        │
│  (Login)     │  (Owners)     │  (Workers)   │  (System)     │
├──────────────┴───────────────┴──────────────┼───────────────┤
│         Flutter Web/Mobile (Unified)        │ Django Admin  │
├─────────────────────────────────────────────┴───────────────┤
│            Django REST API (Enhanced for Flutter)            │
├─────────────────────────────────────────────────────────────┤
│                    PostgreSQL (38 models)                    │
└─────────────────────────────────────────────────────────────┘
```

---

## Complete Feature Inventory

### Backend Models (38 Total)

| Category | Models | Flutter Coverage |
|----------|--------|------------------|
| **Core Domain** | Property, Booking, Task, TaskImage, PropertyOwnership | Full |
| **User & Auth** | User, Profile, Device, CustomPermission, RolePermission, UserPermissionOverride | Full |
| **Notifications** | Notification | Full |
| **Checklist System** | ChecklistTemplate, ChecklistItem, TaskChecklist, ChecklistResponse, ChecklistPhoto | Full |
| **Inventory** | InventoryCategory, InventoryItem, PropertyInventory, InventoryTransaction | Full |
| **Lost & Found** | LostFoundItem, LostFoundPhoto | Full |
| **Scheduling** | ScheduleTemplate, GeneratedTask, AutoTaskTemplate, TaskTemplateTracking | Admin Only |
| **Booking Import** | BookingImportTemplate, BookingImportLog | Admin Only |
| **Chat** | ChatRoom, ChatParticipant, ChatMessage, ChatTypingIndicator | Full |
| **Audit & Security** | AuditEvent, PasswordResetLog, UserSession, SecurityEvent, SuspiciousActivity | Admin Only |
| **Invite System** | InviteCode | Manager + Admin |

---

## Complete API Endpoint Mapping

### 1. Authentication & Registration (Flutter)

| Endpoint | Method | Purpose | Flutter Screen |
|----------|--------|---------|----------------|
| `/api/token/` | POST | JWT login | `LoginScreen` |
| `/api/token/refresh/` | POST | Refresh token | Background service |
| `/api/token/verify/` | POST | Verify token | Background service |
| `/api/token/revoke/` | POST | Logout (single) | Logout action |
| `/api/token/revoke-all/` | POST | Logout all devices | `SettingsScreen` |
| `/api/register/` | POST | User registration | `RegisterScreen` |
| `/api/validate-invite/` | POST | Validate invite code | `RegisterScreen` |
| `/api/auth/password_reset/` | POST | Request reset | `PasswordResetScreen` |
| `/api/auth/reset/{uid}/{token}/` | POST | Confirm reset | `PasswordResetConfirmScreen` |
| `/api/users/me/` | GET | Current user profile | `ProfileScreen` |

### 2. Task Management (Flutter - Staff/Portal)

| Endpoint | Method | Purpose | Flutter Screen |
|----------|--------|---------|----------------|
| `/api/tasks/` | GET | List tasks | `MyTasksScreen` |
| `/api/tasks/` | POST | Create task | `TaskFormScreen` |
| `/api/tasks/{id}/` | GET | Task detail | `TaskDetailScreen` |
| `/api/tasks/{id}/` | PATCH | Update task | `TaskFormScreen` |
| `/api/tasks/{id}/` | DELETE | Delete task | `TaskDetailScreen` |
| `/api/tasks/{id}/set_status/` | POST | Update status | `TaskDetailScreen` |
| `/api/tasks/{id}/mute/` | POST | Mute notifications | `TaskDetailScreen` |
| `/api/tasks/{id}/unmute/` | POST | Unmute notifications | `TaskDetailScreen` |
| `/api/tasks/{id}/assign_to_me/` | POST | Self-assign | `TaskDetailScreen` |
| `/api/tasks/count_by_status/` | GET | Task counts | `StaffDashboardScreen` |
| `/api/staff/tasks/{id}/duplicate/` | POST | Duplicate task | `TaskDetailScreen` |
| `/api/staff/tasks/{id}/progress/` | GET | Task progress % | `TaskDetailScreen` |
| `/api/staff/task-counts/` | GET | Task statistics | `StaffDashboardScreen` |

### 3. Task Images (Flutter)

| Endpoint | Method | Purpose | Flutter Screen |
|----------|--------|---------|----------------|
| `/api/tasks/{task_pk}/images/` | GET | List images | `TaskDetailScreen` |
| `/api/tasks/{task_pk}/images/create/` | POST | Upload image | `PhotoUploadScreen` |
| `/api/tasks/{task_pk}/images/{id}/` | GET | Image detail | `PhotoDetailScreen` |
| `/api/tasks/{task_pk}/images/{id}/` | PATCH | Update (approve/reject) | `PhotoManagementScreen` |
| `/api/tasks/{task_pk}/images/{id}/` | DELETE | Delete image | `PhotoManagementScreen` |

### 4. Checklist System (Flutter)

| Endpoint | Method | Purpose | Flutter Screen |
|----------|--------|---------|----------------|
| `/api/checklists/` | GET | List templates | `ChecklistTemplatesScreen` |
| `/api/checklists/create/` | POST | Create template | Admin only |
| `/api/checklists/assign/{task_id}/` | POST | Assign to task | `TaskDetailScreen` |
| `/api/checklists/quick-assign/` | POST | Batch assign | Admin only |
| `/api/staff/checklist/{item_id}/update/` | POST | Update item | `TaskDetailScreen` |
| `/api/staff/checklist-response/{id}/update/` | POST | Update response | `TaskDetailScreen` |
| `/api/staff/checklist/photo/upload/` | POST | Upload photo | `TaskDetailScreen` |
| `/api/staff/checklist/photo/remove/` | POST | Remove photo | `TaskDetailScreen` |

**Checklist Item Types:**
- `check` - Simple checkbox
- `photo_required` - Must upload photo
- `photo_optional` - Optional photo
- `text_input` - Text response
- `number_input` - Numeric response
- `blocking` - Must complete before proceeding

### 5. Property & Booking Management (Flutter)

| Endpoint | Method | Purpose | Flutter Screen |
|----------|--------|---------|----------------|
| `/api/properties/` | GET | List properties | `PropertyListScreen` |
| `/api/properties/` | POST | Create property | Admin only |
| `/api/properties/{id}/` | GET | Property detail | `PropertyDetailScreen` |
| `/api/properties/{id}/` | PATCH | Update property | Admin only |
| `/api/properties/search/` | GET | Autocomplete search | `PropertySearchWidget` |
| `/api/bookings/` | GET | List bookings | `BookingListScreen` |
| `/api/bookings/{id}/` | GET | Booking detail | `BookingDetailScreen` |
| `/api/ownerships/` | GET | Ownership list | `PropertyDetailScreen` |

### 6. Inventory Management (Flutter - Staff)

| Endpoint | Method | Purpose | Flutter Screen |
|----------|--------|---------|----------------|
| `/api/staff/inventory/` | GET | Inventory lookup | `InventoryLookupScreen` |
| `/api/staff/inventory/transaction/` | POST | Log transaction | `InventoryTransactionScreen` |
| `/api/staff/inventory/low-stock/` | GET | Low stock alerts | `InventoryAlertsScreen` |
| `/api/staff/inventory/shortage/` | POST | Report shortage (auto-creates task) | `InventoryTransactionScreen` |

**Transaction Types:**
- `stock_in` - Add inventory (receiving supplies)
- `stock_out` - Remove inventory (consuming supplies)
- `adjustment` - Adjust count (corrections)
- `damage` - Report damaged items
- `transfer` - Transfer between properties
- `shortage` - Report shortage (auto-creates restocking task)

**Inventory Features:**
- Property-specific inventory profiles with par levels (min/max thresholds)
- Low-stock alerts when below minimum
- Automatic task creation when shortage reported
- Photo documentation of restocked items
- Complete transaction history with user attribution
- Supply categorization (consumables, linens, chemicals, maintenance)

### 7. Lost & Found (Flutter - Staff)

| Endpoint | Method | Purpose | Flutter Screen |
|----------|--------|---------|----------------|
| `/api/staff/lost-found/` | GET | List items | `LostFoundScreen` |
| `/api/staff/lost-found/` | POST | Create item | `LostFoundFormScreen` |
| `/api/staff/lost-found/{id}/` | GET | Item detail | `LostFoundDetailScreen` |
| `/api/staff/lost-found/{id}/` | PATCH | Update item | `LostFoundFormScreen` |
| `/api/staff/lost-found/{id}/status/` | POST | Update status | `LostFoundDetailScreen` |

**Item Status:**
- `found` - Item found (initial state)
- `claimed` - Item claimed by owner
- `disposed` - Item disposed after retention period
- `donated` - Item donated to charity

**Lost & Found Features:**
- Photo documentation with multiple images
- Condition logging (new, used, damaged)
- Location tracking (property, room, area)
- Guest/owner notification integration
- Retention period tracking
- Status history with timestamps
- Search by description, location, date

### 8. Chat System (Flutter)

| Endpoint | Method | Purpose | Flutter Screen |
|----------|--------|---------|----------------|
| `/api/chat/rooms/` | GET | List rooms | `ChatRoomListScreen` |
| `/api/chat/rooms/` | POST | Create room | `NewChatScreen` |
| `/api/chat/rooms/{id}/` | PATCH | Update room | `ChatSettingsScreen` |
| `/api/chat/rooms/{id}/archive/` | POST | Archive room | `ChatSettingsScreen` |
| `/api/chat/rooms/{id}/mark_read/` | POST | Mark as read | Background |
| `/api/chat/messages/` | GET | List messages | `ChatScreen` |
| `/api/chat/messages/` | POST | Send message | `ChatScreen` |
| `/api/chat/messages/{id}/` | PATCH | Edit message | `ChatScreen` |
| `/api/chat/messages/{id}/` | DELETE | Delete message | `ChatScreen` |
| `/api/chat/messages/search/` | GET | Search messages | `MessageSearchScreen` |
| `/api/chat/participants/` | GET | List participants | `ChatParticipantsScreen` |
| `/api/chat/participants/` | POST | Add participant | `ChatParticipantsScreen` |
| `/api/chat/participants/{id}/` | DELETE | Remove participant | `ChatParticipantsScreen` |
| `/api/chat/typing/` | POST | Typing indicator | `ChatScreen` |

**Chat Room Types:**
- `direct` - 1:1 messaging
- `group` - Group chat
- `task` - Task-specific chat
- `property` - Property-specific chat

### 9. Notifications (Flutter)

| Endpoint | Method | Purpose | Flutter Screen |
|----------|--------|---------|----------------|
| `/api/notifications/` | GET | List notifications | `NotificationListScreen` |
| `/api/notifications/unread-count/` | GET | Badge count | App header |
| `/api/notifications/{id}/read/` | POST | Mark as read | `NotificationListScreen` |
| `/api/notifications/mark-all-read/` | POST | Mark all read | `NotificationListScreen` |
| `/api/notifications/settings/` | GET | User preferences | `NotificationSettingsScreen` |
| `/api/notifications/settings/` | POST | Update preferences | `NotificationSettingsScreen` |
| `/api/notifications/stats/` | GET | Notification statistics | `NotificationListScreen` |
| `/api/devices/` | POST | Register device | Background (Firebase) |
| `/api/devices/` | DELETE | Unregister device | Logout action |

**Notification Types (10+):**
1. `task_assigned` - Task assignment notification
2. `task_status_change` - Task status update
3. `task_due_soon` - Due in 24h/2h reminder
4. `task_overdue` - Overdue alert
5. `low_stock` - Inventory below minimum
6. `shortage_reported` - Inventory shortage
7. `chat_message` - New chat message
8. `permission_change` - Permission granted/revoked
9. `photo_approval` - Photo approved/rejected
10. `booking_change` - Booking modified
11. `system_alert` - System notifications

### 10. Calendar System (Flutter)

| Endpoint | Method | Purpose | Flutter Screen |
|----------|--------|---------|----------------|
| `/api/calendar/events/` | GET | All events | `CalendarScreen` |
| `/api/calendar/tasks/` | GET | Tasks only | `CalendarScreen` |
| `/api/calendar/bookings/` | GET | Bookings only | `CalendarScreen` |
| `/api/calendar/day_events/` | GET | Day view | `CalendarScreen` |
| `/api/calendar/stats/` | GET | Statistics | `CalendarScreen` |
| `/api/calendar/properties/` | GET | Property filter | `CalendarScreen` |
| `/api/calendar/users/` | GET | User filter | `CalendarScreen` |

### 11. Manager Module (Flutter)

| Endpoint | Method | Purpose | Flutter Screen |
|----------|--------|---------|----------------|
| `/api/manager/overview/` | GET | Dashboard data | `ManagerDashboardScreen` |
| `/api/manager/dashboard/` | GET | Dashboard (alias) | `ManagerDashboardScreen` |
| `/api/manager/users/` | GET | Team members | `ManagerUserListScreen` |
| `/api/manager/users/{id}/` | GET | User detail | `ManagerUserDetailScreen` |
| `/api/manager/users/{id}/` | PATCH | Update user | `ManagerUserDetailScreen` |
| `/api/manager/users/{id}/reset-password/` | POST | Reset user password | `ManagerUserDetailScreen` |
| `/api/manager/invite-codes/` | GET | List invites | `ManagerInviteCodesScreen` |
| `/api/manager/create-invite-code/` | POST | Create invite | `InviteCodeFormScreen` |
| `/api/manager/invite-codes/{id}/` | GET | Invite detail | `InviteCodeDetailScreen` |
| `/api/manager/invite-codes/{id}/edit/` | PUT | Edit invite | `InviteCodeFormScreen` |
| `/api/manager/invite-codes/{id}/revoke/` | POST | Revoke invite | `ManagerInviteCodesScreen` |
| `/api/manager/invite-codes/{id}/reactivate/` | POST | Reactivate | `ManagerInviteCodesScreen` |
| `/api/manager/invite-codes/{id}/delete/` | DELETE | Delete invite | `ManagerInviteCodesScreen` |

**Manager Features:**
- Permission delegation: Grant/revoke permissions to staff members
- Team analytics: Task completion rates, performance metrics
- Audit log viewing: Read-only access to team activity
- User profile management: Update staff details (limited fields)
- Invite code management with expiration and usage tracking

### 12. Email Digest (Flutter)

| Endpoint | Method | Purpose | Flutter Screen |
|----------|--------|---------|----------------|
| `/api/digest/settings/` | GET | Get preferences | `DigestSettingsScreen` |
| `/api/digest/settings/api/` | POST | Save preferences | `DigestSettingsScreen` |
| `/api/digest/opt-out/` | POST | Opt out | `DigestSettingsScreen` |

### 13. Mobile Optimization (Flutter)

| Endpoint | Method | Purpose | Flutter Screen |
|----------|--------|---------|----------------|
| `/api/mobile/dashboard/` | GET | Compact dashboard | `PortalHomeScreen` |
| `/api/mobile/offline-sync/` | POST | Sync offline changes | Background service |
| `/api/mobile/tasks/summary/` | GET | Quick task summary | Widget |

### 14. User Profile & Settings (Flutter)

| Endpoint | Method | Purpose | Flutter Screen |
|----------|--------|---------|----------------|
| `/api/users/me/` | GET | Current user | `ProfileScreen` |
| `/api/users/me/` | PATCH | Update profile | `ProfileScreen` |
| `/api/permissions/user/` | GET | My permissions | `ProfileScreen` |

### 15. Permission Management (Flutter - Manager)

| Endpoint | Method | Purpose | Flutter Screen |
|----------|--------|---------|----------------|
| `/api/permissions/available/` | GET | List available permissions | `ManagerPermissionsScreen` |
| `/api/permissions/grant/` | POST | Grant permission to user | `ManagerUserDetailScreen` |
| `/api/permissions/revoke/` | POST | Revoke permission | `ManagerUserDetailScreen` |
| `/api/permissions/remove-override/` | POST | Remove permission override | `ManagerUserDetailScreen` |

**Permission Features:**
- 38+ custom permissions for fine-grained access control
- Role-based permission assignments
- User-specific permission overrides with expiration dates
- Permission delegation from managers to staff

### 16. Audit Events (Flutter - Manager/Portal Read-Only)

| Endpoint | Method | Purpose | Flutter Screen |
|----------|--------|---------|----------------|
| `/api/audit-events/` | GET | List audit events | `AuditLogScreen` |

**Audit Event Types:**
- User login/logout events
- Task modifications (create, update, status change)
- Photo uploads and approvals
- Permission changes
- Inventory transactions
- Booking modifications

### 17. Photo Management Dashboard (Flutter)

| Endpoint | Method | Purpose | Flutter Screen |
|----------|--------|---------|----------------|
| `/api/staff/photos/management/` | GET | Staff photo dashboard | `StaffPhotoManagementScreen` |
| `/api/staff/photos/comparison/{id}/` | GET | Before/after comparison | `PhotoComparisonScreen` |
| `/api/portal/photos/` | GET | Portal photo gallery | `PortalPhotoGalleryScreen` |

**Photo System Details:**
- 7 photo types: `before`, `after`, `during`, `reference`, `damage`, `general`, `checklist`
- 4 status states: `pending`, `approved`, `rejected`, `archived`
- Photo approval workflow with role-based access
- Sequence numbering for organization
- Primary photo designation per task

### 18. Health & Monitoring (Background)

| Endpoint | Method | Purpose | Usage |
|----------|--------|---------|-------|
| `/api/health/` | GET | Basic health | Connectivity check |
| `/api/health/detailed/` | GET | Detailed health | Debug screen |
| `/api/log-client-error/` | POST | Log errors | Error handling |

---

## Admin-Only Features (Django Admin)

These features remain in Django Admin and are NOT migrated to Flutter:

### System Administration
- Charts Dashboard (`/api/admin/charts/`)
- System Metrics (`/api/admin/metrics/`)
- System Logs (`/api/admin/logs/`)
- System Recovery (`/api/admin/recovery/`)
- File Cleanup (`/api/admin/file-cleanup/`)

### Security Management
- Security Dashboard (`/api/admin/security/`)
- Security Events (`/api/admin/security/events/`)
- Active Sessions (`/api/admin/security/sessions/`)
- Session Termination

### Data Import
- Excel Import (`/excel-import/`)
- Enhanced Excel Import (`/enhanced-excel-import/`)
- Conflict Resolution (`/conflict-review/`)
- Property Approval (`/property-approval/`)

### Configuration
- Permission Management (`/api/admin/permissions/`)
- Digest Management (`/api/admin/digest-management/`)
- Notification Management (`/api/admin/notification-management/`)
- Invite Code Management (`/admin/invite-codes/`)

### Scheduling (Backend Only)
- ScheduleTemplate - Recurring task automation
- AutoTaskTemplate - Booking-triggered tasks
- BookingImportTemplate - Import configurations

---

## Phase Breakdown

### Phase 1: Foundation & Core Setup
**Objective:** Set up Flutter web project structure and shared infrastructure

#### Tasks:
1. **Project Structure Setup**
   - Configure Flutter web build settings in existing `aristay_flutter_frontend/`
   - Set up shared codebase structure for mobile + web
   - Configure environment variables (dev/staging/prod)
   - Set up CI/CD for Flutter web deployment

2. **Design System & Theme**
   - Create unified design tokens (colors, typography, spacing)
   - Build reusable widget library
   - Implement responsive layout system (mobile/tablet/desktop)
   - Dark mode support

3. **Core Services**
   - API client service (HTTP + JWT handling)
   - Authentication service (token storage, refresh, logout)
   - Navigation service (GoRouter for web + mobile)
   - Local storage service (SharedPreferences/Hive)
   - Push notification service (Firebase)
   - Error logging service (client error reporting)

4. **State Management**
   - Set up Riverpod provider structure
   - Implement user session management
   - Implement connectivity monitoring

#### Files to Create:
```
lib/
├── core/
│   ├── constants/
│   │   ├── api_constants.dart
│   │   ├── app_constants.dart
│   │   └── route_constants.dart
│   ├── theme/
│   │   ├── app_theme.dart
│   │   ├── app_colors.dart
│   │   ├── app_typography.dart
│   │   └── app_spacing.dart
│   ├── services/
│   │   ├── api_service.dart
│   │   ├── auth_service.dart
│   │   ├── navigation_service.dart
│   │   ├── storage_service.dart
│   │   ├── notification_service.dart
│   │   └── error_logging_service.dart
│   ├── providers/
│   │   ├── auth_provider.dart
│   │   ├── user_provider.dart
│   │   └── connectivity_provider.dart
│   └── widgets/
│       ├── app_button.dart
│       ├── app_card.dart
│       ├── app_text_field.dart
│       ├── loading_indicator.dart
│       └── responsive_layout.dart
```

---

### Phase 2: Authentication Module
**Objective:** Complete authentication flow with JWT support

#### Screens to Build (5):
| Screen | Purpose | API Endpoints |
|--------|---------|---------------|
| `LoginScreen` | Email/password login | `POST /api/token/` |
| `RegisterScreen` | Registration with invite code | `POST /api/register/`, `POST /api/validate-invite/` |
| `PasswordResetScreen` | Request password reset | `POST /api/auth/password_reset/` |
| `PasswordResetConfirmScreen` | Set new password | `POST /api/auth/reset/{uid}/{token}/` |
| `AccountLockedScreen` | Display lockout message | N/A |

#### Features:
- JWT token management (access + refresh)
- Biometric authentication (mobile)
- Remember me functionality
- Session persistence
- Role-based navigation after login
- Revoke all sessions option
- Device registration for push notifications

---

### Phase 3: Portal Module (Property Owners)
**Objective:** Property management interface for owners

#### Screens to Build (11):
| Screen | Purpose | API Endpoints |
|--------|---------|---------------|
| `PortalHomeScreen` | Dashboard with quick access | `GET /api/mobile/dashboard/` |
| `PropertyListScreen` | Browse all properties | `GET /api/properties/` |
| `PropertyDetailScreen` | Property info, bookings, tasks | `GET /api/properties/{id}/` |
| `PropertySearchWidget` | Property autocomplete | `GET /api/properties/search/` |
| `BookingListScreen` | All bookings | `GET /api/bookings/` |
| `BookingDetailScreen` | Booking information | `GET /api/bookings/{id}/` |
| `CalendarScreen` | Unified calendar | `GET /api/calendar/*` |
| `PortalTaskDetailScreen` | Task details (read-only) | `GET /api/tasks/{id}/` |
| `PhotoManagementScreen` | Review/approve photos | `GET /api/tasks/{id}/images/` |
| `PortalPhotoGalleryScreen` | Browse all property photos | `GET /api/portal/photos/` |
| `PortalSettingsScreen` | Notification & digest prefs | `GET /api/notifications/settings/` |

#### Features:
- Property quick search with autocomplete
- Booking status tracking
- Task assignment visibility
- Photo approval workflow (approve/reject)
- Photo gallery with filtering by property, type, date
- Calendar with multiple views (month/week/day)
- Calendar filtering by property, user, event type
- Push notification preferences
- Email digest preferences

---

### Phase 4: Staff Module - Core Task Management
**Objective:** Primary task management for staff workers

#### Screens to Build (5):
| Screen | Purpose | API Endpoints |
|--------|---------|---------------|
| `StaffDashboardScreen` | Task counts and quick actions | `GET /api/staff/task-counts/` |
| `MyTasksScreen` | Filterable task list | `GET /api/tasks/` |
| `TaskDetailScreen` | Full task with checklist | `GET /api/tasks/{id}/`, `GET /api/staff/tasks/{id}/progress/` |
| `TaskFormScreen` | Create/edit tasks | `POST/PUT /api/tasks/` |
| `TaskDuplicateScreen` | Duplicate existing task | `POST /api/staff/tasks/{id}/duplicate/` |

#### Features:
- Task list with filtering (status, type, property, date, assigned)
- Bulk task actions (complete, reassign)
- Task status workflow: `pending` → `in-progress` → `completed` / `canceled`
- Task dependencies visualization (depends_on)
- Task muting/unmuting for notifications
- Self-assign functionality
- Task timer functionality
- Progress percentage display
- Checklist interaction with all item types
- Offline support with sync queue

#### Task Types (8):
1. `cleaning` - Cleaning tasks
2. `maintenance` - Maintenance tasks
3. `laundry` - Laundry tasks
4. `lawn_pool` - Outdoor maintenance
5. `inspection` - Property inspection
6. `preparation` - Property preparation
7. `administration` - Admin tasks
8. `other` - Miscellaneous

---

### Phase 5: Staff Module - Specialized Dashboards
**Objective:** Task-type specific dashboards

#### Screens to Build (4):
| Screen | Purpose | API Endpoints |
|--------|---------|---------------|
| `CleaningDashboardScreen` | Cleaning tasks | `GET /api/tasks/?task_type=cleaning` |
| `MaintenanceDashboardScreen` | Maintenance tasks | `GET /api/tasks/?task_type=maintenance` |
| `LaundryDashboardScreen` | Laundry tasks | `GET /api/tasks/?task_type=laundry` |
| `LawnPoolDashboardScreen` | Outdoor tasks | `GET /api/tasks/?task_type=lawn_pool` |

#### Features:
- Task type filtering
- Priority sorting
- Property grouping
- Quick status updates
- Task count by status
- Due date highlighting (overdue, due today, upcoming)

---

### Phase 6: Staff Module - Auxiliary Features
**Objective:** Supporting staff features

#### Screens to Build (10):
| Screen | Purpose | API Endpoints |
|--------|---------|---------------|
| `InventoryLookupScreen` | Property inventory search | `GET /api/staff/inventory/` |
| `InventoryTransactionScreen` | Log inventory changes | `POST /api/staff/inventory/transaction/` |
| `InventoryAlertsScreen` | Low stock alerts | `GET /api/staff/inventory/low-stock/` |
| `LostFoundScreen` | Lost & found list | `GET /api/staff/lost-found/` |
| `LostFoundFormScreen` | Create/edit lost items | `POST /api/staff/lost-found/` |
| `LostFoundDetailScreen` | Item detail with photos | `GET /api/staff/lost-found/{id}/` |
| `ChecklistTemplatesScreen` | View templates | `GET /api/checklists/` |
| `PhotoUploadScreen` | Batch photo upload | `POST /api/staff/checklist/photo/upload/` |
| `PhotoComparisonScreen` | Before/after slider | `GET /api/staff/photos/comparison/{id}/` |
| `StaffPhotoManagementScreen` | Photo dashboard | `GET /api/staff/photos/management/` |

#### Features:
- Inventory search by property with par levels
- Inventory transaction logging with all 6 transaction types
- Low stock alerts display with threshold indicators
- Shortage reporting with automatic task creation
- Lost item reporting with multiple photos
- Item status tracking (found → claimed/disposed/donated)
- Condition logging for lost items
- Checklist template viewing
- Multi-photo upload with progress indicator
- Before/after photo comparison slider
- Staff photo management dashboard

---

### Phase 7: Chat Module
**Objective:** Real-time team communication

#### Screens to Build (5):
| Screen | Purpose | API Endpoints |
|--------|---------|---------------|
| `ChatRoomListScreen` | List of conversations | `GET /api/chat/rooms/` |
| `ChatScreen` | Message thread view | `GET /api/chat/messages/` |
| `NewChatScreen` | Create new chat | `POST /api/chat/rooms/` |
| `ChatParticipantsScreen` | Manage participants | `GET/POST/DELETE /api/chat/participants/` |
| `MessageSearchScreen` | Search messages | `GET /api/chat/messages/search/` |

#### Features:
- HTTP Polling for messages (5-10 second intervals)
- Direct and group chats
- Task-specific and property-specific chats
- Message threading (replies)
- Read receipts
- Typing indicators
- File/photo attachments
- Message editing and deletion
- Message search across rooms
- Mute room notifications
- Room archiving

#### Implementation Approach:
- **Phase 7a:** HTTP Polling (immediate)
- **Phase 7b:** WebSocket upgrade (future enhancement)

---

### Phase 8: Manager Module
**Objective:** Team management interface

#### Screens to Build (8):
| Screen | Purpose | API Endpoints |
|--------|---------|---------------|
| `ManagerDashboardScreen` | Team overview | `GET /api/manager/overview/` |
| `ManagerUserListScreen` | Team members | `GET /api/manager/users/` |
| `ManagerUserDetailScreen` | User detail/edit | `GET /api/manager/users/{id}/` |
| `ManagerPermissionsScreen` | Permission management | `GET /api/permissions/available/` |
| `ManagerInviteCodesScreen` | Manage invites | `GET /api/manager/invite-codes/` |
| `InviteCodeFormScreen` | Create/edit invite | `POST /api/manager/create-invite-code/` |
| `InviteCodeDetailScreen` | Invite code detail | `GET /api/manager/invite-codes/{id}/` |
| `AuditLogScreen` | View team activity | `GET /api/audit-events/` |

#### Features:
- Team task overview with statistics and analytics
- User list with role filtering and search
- User detail view with editable fields (limited by role)
- Permission delegation (grant/revoke to staff)
- Permission override management with expiration
- Invite code creation with role and department assignment
- Invite code expiration and usage tracking
- Invite code revocation/reactivation/deletion
- Task assignment to team members
- Audit log viewing (read-only)
- Team performance metrics

---

### Phase 9: Notification System
**Objective:** Unified notification handling

#### Screens to Build (2):
| Screen | Purpose | API Endpoints |
|--------|---------|---------------|
| `NotificationListScreen` | All notifications | `GET /api/notifications/` |
| `NotificationSettingsScreen` | Preferences | `GET /api/notifications/settings/` |

#### Features:
- Push notification handling (Firebase)
- In-app notification list
- Unread count badge in header
- Mark as read (single/all)
- Notification preferences by type
- Deep linking from notifications to relevant screens
- Email digest preferences integration

---

### Phase 10: User Profile & Settings
**Objective:** User account management

#### Screens to Build (3):
| Screen | Purpose | API Endpoints |
|--------|---------|---------------|
| `ProfileScreen` | User profile | `GET /api/users/me/` |
| `SettingsScreen` | App settings | Various |
| `ActiveSessionsScreen` | Device sessions | Future endpoint |

#### Features:
- View/edit profile information
- Timezone selection
- Password change
- View permissions
- Logout from current device
- Logout from all devices
- Dark mode toggle
- Notification sound settings
- App version info

---

### Phase 11: Offline Support & Optimization
**Objective:** Robust offline experience

#### Features:
1. **Offline Data Storage**
   - Cache tasks, properties, bookings locally (Hive/SQLite)
   - Queue actions while offline
   - Conflict detection

2. **Sync Mechanism**
   - Background sync when online
   - Conflict resolution UI
   - Sync status indicators
   - `POST /api/mobile/offline-sync/` integration

3. **Performance Optimization**
   - Image caching with size limits
   - Lazy loading for lists
   - Pagination (20 items default)
   - Memory management
   - Code splitting for web

---

### Phase 12: Testing & Quality Assurance
**Objective:** Comprehensive testing

#### Tasks:
1. **Unit Tests**
   - Service tests
   - Provider tests
   - Utility tests
   - Model tests

2. **Widget Tests**
   - Screen tests
   - Component tests
   - Form validation tests

3. **Integration Tests**
   - User flow tests
   - API integration tests
   - Offline sync tests

4. **E2E Tests**
   - Critical path tests (login → task complete)
   - Cross-platform tests (mobile/web)
   - Accessibility tests

---

### Phase 13: Deployment & Migration
**Objective:** Production deployment and migration

#### Tasks:
1. **Backend Preparation**
   - CORS configuration for Flutter web domain
   - Optimize API endpoints for mobile payloads
   - Add any missing endpoints identified during development

2. **Flutter Web Deployment**
   - Configure hosting (Firebase Hosting recommended)
   - Set up CDN for static assets
   - SSL/HTTPS configuration
   - Service worker for PWA

3. **Migration Strategy**
   - Gradual rollout by user role (Staff first, then Portal, then Manager)
   - Feature flags for A/B testing
   - Rollback plan with Django templates as fallback
   - User communication plan

4. **Django Admin Preservation**
   - Keep all admin routes unchanged
   - Admin-only authentication path
   - Separate session handling

---

## Screen Count Summary

| Module | Screens | Priority |
|--------|---------|----------|
| Authentication | 5 | P0 - Critical |
| Portal | 11 | P1 - High |
| Staff Core | 5 | P0 - Critical |
| Staff Dashboards | 4 | P1 - High |
| Staff Auxiliary | 10 | P2 - Medium |
| Chat | 5 | P2 - Medium |
| Manager | 8 | P2 - Medium |
| Notifications | 2 | P1 - High |
| Profile/Settings | 3 | P3 - Low |
| **Total** | **53** | |

**Changes in v1.1:**
- Portal: +1 (PortalPhotoGalleryScreen)
- Staff Auxiliary: +2 (InventoryAlertsScreen, StaffPhotoManagementScreen)
- Manager: +3 (ManagerPermissionsScreen, InviteCodeDetailScreen, AuditLogScreen)

---

## Flutter Project Structure (Target)

```
aristay_flutter_frontend/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── routes.dart
│   │
│   ├── core/
│   │   ├── constants/
│   │   │   ├── api_constants.dart
│   │   │   ├── app_constants.dart
│   │   │   └── route_constants.dart
│   │   ├── extensions/
│   │   ├── theme/
│   │   │   ├── app_theme.dart
│   │   │   ├── app_colors.dart
│   │   │   └── app_typography.dart
│   │   ├── utils/
│   │   │   ├── date_utils.dart
│   │   │   ├── validators.dart
│   │   │   └── formatters.dart
│   │   └── widgets/
│   │       ├── buttons/
│   │       ├── cards/
│   │       ├── inputs/
│   │       └── layouts/
│   │
│   ├── data/
│   │   ├── models/
│   │   │   ├── user.dart
│   │   │   ├── task.dart
│   │   │   ├── property.dart
│   │   │   ├── booking.dart
│   │   │   ├── notification.dart
│   │   │   ├── chat_room.dart
│   │   │   ├── chat_message.dart
│   │   │   ├── checklist.dart
│   │   │   ├── inventory.dart
│   │   │   └── lost_found.dart
│   │   ├── repositories/
│   │   │   ├── auth_repository.dart
│   │   │   ├── task_repository.dart
│   │   │   ├── property_repository.dart
│   │   │   ├── booking_repository.dart
│   │   │   ├── chat_repository.dart
│   │   │   └── notification_repository.dart
│   │   └── services/
│   │       ├── api_service.dart
│   │       ├── auth_service.dart
│   │       ├── storage_service.dart
│   │       ├── notification_service.dart
│   │       └── sync_service.dart
│   │
│   ├── features/
│   │   ├── auth/
│   │   │   ├── screens/
│   │   │   ├── widgets/
│   │   │   └── providers/
│   │   │
│   │   ├── portal/
│   │   │   ├── screens/
│   │   │   ├── widgets/
│   │   │   └── providers/
│   │   │
│   │   ├── staff/
│   │   │   ├── screens/
│   │   │   ├── widgets/
│   │   │   └── providers/
│   │   │
│   │   ├── chat/
│   │   │   ├── screens/
│   │   │   ├── widgets/
│   │   │   └── providers/
│   │   │
│   │   ├── manager/
│   │   │   ├── screens/
│   │   │   ├── widgets/
│   │   │   └── providers/
│   │   │
│   │   ├── notifications/
│   │   │   ├── screens/
│   │   │   ├── widgets/
│   │   │   └── providers/
│   │   │
│   │   └── profile/
│   │       ├── screens/
│   │       ├── widgets/
│   │       └── providers/
│   │
│   └── shared/
│       ├── widgets/
│       └── providers/
│
├── web/
│   ├── index.html
│   ├── manifest.json
│   └── icons/
│
├── test/
│   ├── unit/
│   ├── widget/
│   └── integration/
│
├── integration_test/
└── pubspec.yaml
```

---

## Backend Files to Modify

### API Enhancements Needed

| File | Changes Needed |
|------|----------------|
| `api/urls.py` | Add any missing mobile-optimized endpoints |
| `api/views.py` | Optimize response payloads for mobile |
| `api/serializers.py` | Add compact serializers for list views |
| `api/mobile_views.py` | Enhance offline sync, add missing endpoints |
| `backend/settings_base.py` | Add Flutter web domain to CORS |

### Django Admin to Keep Unchanged

- `api/templates/admin/` - All admin templates
- `api/admin.py` - Admin site configuration
- `api/templates/manager_admin/` - Manager admin templates (reference only)
- `api/managersite.py` - Manager site configuration (reference only)

---

## Risk Assessment

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| WebSocket complexity | High | Medium | Use polling first, WebSocket later |
| Offline sync conflicts | Medium | Medium | Implement robust conflict resolution UI |
| Web performance | Medium | Low | Code splitting, lazy loading, CDN |
| Cross-platform consistency | Medium | Medium | Extensive testing, shared widgets |
| Migration disruption | High | Low | Gradual rollout, feature flags, rollback plan |
| Admin feature loss | Low | Very Low | Keep Django Admin completely separate |
| API rate limiting | Medium | Low | Implement request queuing, caching |

---

## Success Criteria

1. ✅ All 53 user-facing screens functional in Flutter
2. ✅ Performance parity or better than Django templates
3. ✅ Offline support for critical workflows (task completion, photos)
4. ✅ Consistent UX across mobile and web
5. ✅ Zero disruption to admin operations
6. ✅ All existing API tests pass
7. ✅ New Flutter tests achieve 80%+ coverage
8. ✅ Successful migration of 100% users within rollout period

---

## Dependencies & Prerequisites

### Required Before Phase 1:
- Flutter SDK 3.x installed
- Dart 3.x installed
- Firebase project configured (existing)
- CORS configured for local development

### Required Before Phase 13:
- Staging environment setup
- Production hosting configured
- SSL certificates
- CDN setup

---

## Change Log

| Date | Version | Changes |
|------|---------|---------|
| 2025-12-21 | 1.0 | Initial plan created with comprehensive feature mapping |
| 2025-12-22 | 1.1 | Added missing features after full codebase review (see below) |

### Version 1.1 Additions

**New API Endpoint Sections:**
- Section 15: Permission Management (Flutter - Manager) - 4 endpoints
- Section 16: Audit Events (Flutter - Manager/Portal Read-Only) - 1 endpoint
- Section 17: Photo Management Dashboard (Flutter) - 3 endpoints

**Enhanced Existing Sections:**
- Section 6: Inventory Management - Added low-stock alerts, shortage reporting with auto-task creation
- Section 7: Lost & Found - Added detail/update endpoints, condition logging, retention tracking
- Section 9: Notifications - Added stats, device unregister, 11 notification types documented
- Section 11: Manager Module - Added password reset, user editing, invite detail/edit/delete endpoints

**New Screens Added (6 total):**
- `PortalPhotoGalleryScreen` - Browse all property photos
- `InventoryAlertsScreen` - Low stock alerts dashboard
- `StaffPhotoManagementScreen` - Staff photo management dashboard
- `ManagerPermissionsScreen` - Permission delegation interface
- `InviteCodeDetailScreen` - Invite code detail view
- `AuditLogScreen` - Team activity audit log

**Updated Screen Count:** 47 → 53 screens

---

## Next Steps

- [ ] Review and approve this plan
- [ ] Set up development environment
- [ ] Begin Phase 1: Foundation & Core Setup
- [ ] Weekly progress reviews
- [ ] Update this document as needed

---

*This is a living document. Update it as the project progresses.*
