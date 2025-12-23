# AriStay UI Redesign Plan: Django Templates → Flutter Web

**Document Version:** 1.3
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
| **Multi-Tenancy** | Build as SaaS template | Serve multiple businesses with same codebase |
| **Tenant Isolation** | Logical isolation (tenant_id) | Shared database with row-level isolation |
| **Billing Integration** | Stripe | Industry standard, comprehensive API |
| **Feature Flags** | Per-tenant configuration | Allow feature customization per business |

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

## Multi-Tenant SaaS Architecture

### Vision
Transform this platform into a **white-label SaaS template** that can serve multiple businesses with similar property/task management needs, not just AriStay.

### Multi-Tenant Target Architecture
```
┌─────────────────────────────────────────────────────────────────────┐
│                      SaaS Platform Layer                            │
├─────────────────────────────────────────────────────────────────────┤
│  Super-Admin Panel │ Billing Dashboard │ Tenant Management         │
├─────────────────────────────────────────────────────────────────────┤
│                      Tenant Isolation Layer                         │
├──────────────┬──────────────┬──────────────┬───────────────────────┤
│   Tenant A   │   Tenant B   │   Tenant C   │   Tenant N...         │
│ (AriStay)    │ (Hotel Corp) │ (Cleaning Co)│                       │
├──────────────┴──────────────┴──────────────┴───────────────────────┤
│           Flutter Web/Mobile (Tenant-Aware, White-Label)            │
├─────────────────────────────────────────────────────────────────────┤
│       Django REST API (Multi-Tenant with Feature Flags)             │
├─────────────────────────────────────────────────────────────────────┤
│     PostgreSQL (Logical Isolation via tenant_id on all models)      │
├─────────────────────────────────────────────────────────────────────┤
│ Stripe Billing │ Firebase │ Cloudinary │ SendGrid │ Redis Cache    │
└─────────────────────────────────────────────────────────────────────┘
```

### New Models Required for Multi-Tenancy

#### 1. Tenant Model (NEW)
```python
class Tenant(models.Model):
    """Organization/workspace/business"""
    id = models.UUIDField(primary_key=True, default=uuid.uuid4)
    name = models.CharField(max_length=255)
    slug = models.SlugField(unique=True)  # For subdomain routing

    # Branding (White-Label)
    logo = models.ImageField(upload_to='tenant_logos/', null=True)
    primary_color = models.CharField(max_length=7, default='#3B82F6')
    secondary_color = models.CharField(max_length=7, default='#1E40AF')
    favicon = models.ImageField(upload_to='tenant_favicons/', null=True)
    custom_domain = models.CharField(max_length=255, null=True, unique=True)

    # Settings
    timezone = models.CharField(max_length=32, default='UTC')
    language = models.CharField(max_length=5, default='en')
    date_format = models.CharField(max_length=20, default='YYYY-MM-DD')

    # Status
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
```

#### 2. TenantSettings Model (NEW)
```python
class TenantSettings(models.Model):
    """Per-tenant feature configuration"""
    tenant = models.OneToOneField(Tenant, on_delete=models.CASCADE)

    # Feature Toggles
    enable_chat = models.BooleanField(default=True)
    enable_photos = models.BooleanField(default=True)
    enable_inventory = models.BooleanField(default=False)
    enable_lost_found = models.BooleanField(default=False)
    enable_calendar = models.BooleanField(default=True)
    enable_checklists = models.BooleanField(default=True)
    enable_email_digest = models.BooleanField(default=True)

    # Customization
    custom_task_types = models.JSONField(default=list)  # Override default types
    custom_booking_statuses = models.JSONField(default=list)
    photo_approval_required = models.BooleanField(default=True)

    # Limits
    max_users = models.IntegerField(default=10)
    max_properties = models.IntegerField(default=50)
    max_storage_gb = models.IntegerField(default=10)
```

#### 3. Subscription Model (NEW)
```python
class Subscription(models.Model):
    """Billing and subscription management"""
    tenant = models.OneToOneField(Tenant, on_delete=models.CASCADE)

    plan = models.CharField(choices=[
        ('free', 'Free'),
        ('starter', 'Starter - $29/mo'),
        ('professional', 'Professional - $99/mo'),
        ('enterprise', 'Enterprise - Custom')
    ], default='free')

    stripe_customer_id = models.CharField(max_length=100, null=True)
    stripe_subscription_id = models.CharField(max_length=100, null=True)

    status = models.CharField(choices=[
        ('active', 'Active'),
        ('trialing', 'Trialing'),
        ('past_due', 'Past Due'),
        ('canceled', 'Canceled'),
        ('suspended', 'Suspended')
    ], default='trialing')

    trial_ends_at = models.DateTimeField(null=True)
    current_period_start = models.DateTimeField(null=True)
    current_period_end = models.DateTimeField(null=True)

    billing_email = models.EmailField()
```

#### 4. Plan Model (NEW)
```python
class Plan(models.Model):
    """Subscription plans and pricing"""
    name = models.CharField(max_length=100)
    slug = models.SlugField(unique=True)
    stripe_price_id = models.CharField(max_length=100)

    # Limits
    max_users = models.IntegerField()
    max_properties = models.IntegerField()
    max_storage_gb = models.IntegerField()

    # Features included
    features = models.JSONField(default=list)
    # ['chat', 'photos', 'inventory', 'lost_found', 'api_access', 'priority_support']

    price_monthly = models.DecimalField(max_digits=10, decimal_places=2)
    price_yearly = models.DecimalField(max_digits=10, decimal_places=2)

    is_active = models.BooleanField(default=True)
```

### Feature Categorization

#### CORE Features (All tenants, always enabled)
| Feature | Description | Required |
|---------|-------------|----------|
| Task Management | Create, assign, track, complete tasks | Yes |
| Property Management | Property CRUD, ownership | Yes |
| User Management | Users, roles, permissions | Yes |
| Notifications | Push, email, in-app | Yes |
| Mobile Access | Flutter app access | Yes |
| Basic Reporting | Task completion stats | Yes |
| Audit Logging | Activity tracking | Yes |

#### OPTIONAL Features (Toggle per tenant)
| Feature | Description | Default | Plans |
|---------|-------------|---------|-------|
| Chat System | Real-time messaging | ON | All |
| Photo Management | Before/after photos | ON | All |
| Inventory System | Supply tracking | OFF | Pro+ |
| Lost & Found | Item tracking | OFF | Pro+ |
| Calendar System | Visual scheduling | ON | All |
| Checklists | Task checklists | ON | All |
| Email Digest | Summary emails | ON | All |
| Excel Import | Booking imports | OFF | Pro+ |
| API Access | Public API | OFF | Enterprise |
| Custom Domain | White-label URL | OFF | Enterprise |
| SSO Integration | SAML/OAuth login | OFF | Enterprise |

#### CUSTOMIZABLE Features (Per-tenant configuration)
| Feature | Customization Options |
|---------|----------------------|
| Task Types | Custom names, icons, colors |
| Booking Statuses | Custom status values |
| Photo Workflow | Approval required (yes/no), who approves |
| Notification Rules | When to notify, channels |
| Branding | Logo, colors, app name |
| Timezone | Business timezone |
| Language | Interface language |
| Date/Time Format | Localization |

### API Changes for Multi-Tenancy

#### Option 1: Header-Based Tenant (Recommended)
```
GET /api/tasks/
Headers:
  Authorization: Bearer <jwt_with_tenant_id>
  X-Tenant-ID: abc-123-def (optional override)
```

#### Option 2: Path-Based Tenant (Alternative)
```
GET /api/tenants/{tenant_id}/tasks/
```

#### JWT Token Structure (Enhanced)
```json
{
  "user_id": 123,
  "tenant_id": "abc-123-def",
  "tenant_slug": "aristay",
  "role": "manager",
  "permissions": ["task.create", "task.edit", ...],
  "features": ["chat", "photos", "inventory"],
  "exp": 1234567890
}
```

### Flutter Multi-Tenant Support

#### Tenant Selection Flow
```
1. User visits: app.saas.com OR tenant.saas.com
2. If subdomain → auto-detect tenant
3. If main domain → show tenant selector OR login with tenant code
4. Store tenant context in local storage
5. Include tenant in all API calls
```

#### Dynamic Theming
```dart
class TenantThemeProvider {
  final String primaryColor;
  final String secondaryColor;
  final String? logoUrl;
  final String appName;

  ThemeData buildTheme() {
    return ThemeData(
      primaryColor: Color(int.parse(primaryColor.replaceFirst('#', '0xFF'))),
      // ... dynamic theme based on tenant settings
    );
  }
}
```

#### Feature Flag Checking
```dart
class FeatureService {
  bool isEnabled(String feature) {
    return currentTenant.enabledFeatures.contains(feature);
  }

  Widget buildIfEnabled(String feature, Widget child) {
    return isEnabled(feature) ? child : SizedBox.shrink();
  }
}
```

### Super-Admin Panel (NEW)

#### Screens to Build
| Screen | Purpose |
|--------|---------|
| `SuperAdminDashboardScreen` | Platform overview, metrics |
| `TenantListScreen` | List all tenants |
| `TenantDetailScreen` | View/edit tenant |
| `TenantCreateScreen` | Onboard new tenant |
| `SubscriptionListScreen` | All subscriptions |
| `BillingDashboardScreen` | Revenue, payments |
| `PlanManagementScreen` | Manage pricing plans |
| `UsageMonitoringScreen` | Resource usage per tenant |
| `SystemHealthScreen` | Platform health |

#### Super-Admin API Endpoints (NEW)
| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/superadmin/tenants/` | GET/POST | List/create tenants |
| `/api/superadmin/tenants/{id}/` | GET/PATCH/DELETE | Manage tenant |
| `/api/superadmin/tenants/{id}/suspend/` | POST | Suspend tenant |
| `/api/superadmin/tenants/{id}/impersonate/` | POST | Login as tenant admin |
| `/api/superadmin/subscriptions/` | GET | List all subscriptions |
| `/api/superadmin/subscriptions/{id}/` | PATCH | Adjust subscription |
| `/api/superadmin/plans/` | GET/POST | Manage plans |
| `/api/superadmin/usage/` | GET | Platform usage stats |
| `/api/superadmin/revenue/` | GET | Revenue analytics |

### Tenant Onboarding Flow (NEW)

```
┌─────────────────────────────────────────────────────────────────┐
│                    New Business Signup                          │
├─────────────────────────────────────────────────────────────────┤
│ Step 1: Business Info                                           │
│   - Business name                                               │
│   - Industry type (property mgmt, cleaning, hospitality)        │
│   - Expected users, properties                                  │
├─────────────────────────────────────────────────────────────────┤
│ Step 2: Admin Account                                           │
│   - Admin name, email, password                                 │
│   - Email verification                                          │
├─────────────────────────────────────────────────────────────────┤
│ Step 3: Plan Selection                                          │
│   - Free trial (14 days)                                        │
│   - Starter / Professional / Enterprise                         │
│   - Payment info (Stripe)                                       │
├─────────────────────────────────────────────────────────────────┤
│ Step 4: Initial Setup Wizard                                    │
│   - Upload logo, set colors                                     │
│   - Enable/disable features                                     │
│   - Configure task types                                        │
│   - Set timezone, language                                      │
├─────────────────────────────────────────────────────────────────┤
│ Step 5: Team Invitation                                         │
│   - Invite first team members                                   │
│   - Assign roles                                                │
├─────────────────────────────────────────────────────────────────┤
│ Step 6: Data Import (Optional)                                  │
│   - Import properties from CSV                                  │
│   - Import existing bookings                                    │
│   - Import team members                                         │
├─────────────────────────────────────────────────────────────────┤
│                     → Redirect to Tenant Dashboard              │
└─────────────────────────────────────────────────────────────────┘
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
| `/api/tasks/{id}/lock/` | POST | Lock task from auto-updates | `TaskDetailScreen` |
| `/api/tasks/{id}/unlock/` | POST | Unlock task | `TaskDetailScreen` |
| `/api/tasks/{id}/dependencies/` | GET | Get task dependencies | `TaskDetailScreen` |
| `/api/staff/tasks/{id}/duplicate/` | POST | Duplicate task | `TaskDetailScreen` |
| `/api/staff/tasks/{id}/progress/` | GET | Task progress % | `TaskDetailScreen` |
| `/api/staff/task-counts/` | GET | Task statistics | `StaffDashboardScreen` |

**Task Status Workflow:**
- `pending` → `in_progress` → `completed` / `canceled`
- `waiting_dependency` - Blocked until prerequisite tasks complete

**Task Features:**
- Task dependencies (depends_on field) - Block tasks until prerequisites complete
- Task locking - Prevent auto-updates from Excel imports on manually-edited tasks
- Task types: `cleaning`, `maintenance`, `laundry`, `lawn_pool`, `inspection`, `preparation`, `administration`, `other`

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

**Checklist Item Types (8 total):**
- `check` - Simple checkbox
- `photo_required` - Must upload photo
- `photo_optional` - Optional photo
- `text_input` - Text response
- `number_input` - Numeric response
- `date_input` - Date picker response
- `time_input` - Time picker response
- `blocking` - Must complete before proceeding (blocks task progress)

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
| `/api/bookings/{id}/conflicts/` | GET | Check booking conflicts | `BookingDetailScreen` |
| `/api/ownerships/` | GET | Ownership list | `PropertyDetailScreen` |

**Booking Status Workflow:**
- `booked` → `confirmed` → `currently_hosting` / `owner_staying` → `completed` / `cancelled`

**Booking Conflict Detection:**
- Same-day check-out/check-in conflicts (turnaround detection)
- Overlapping bookings on same property
- Cross-property staff conflicts (multiple properties same day)
- Conflict flags displayed in booking list and detail views

**Booking Provenance Tracking:**
- `created_via`: `manual` | `excel_import` | `api` | `system`
- `modified_via`: Same choices for tracking modifications
- Import history with raw Excel row data preserved

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
| `/api/chat/rooms/{id}/` | GET | Room detail | `ChatScreen` |
| `/api/chat/rooms/{id}/` | PATCH | Update room | `ChatSettingsScreen` |
| `/api/chat/rooms/{id}/archive/` | POST | Archive room | `ChatSettingsScreen` |
| `/api/chat/rooms/{id}/unarchive/` | POST | Unarchive room | `ChatSettingsScreen` |
| `/api/chat/rooms/{id}/mark_read/` | POST | Mark as read | Background |
| `/api/chat/rooms/{id}/mute/` | POST | Mute room notifications | `ChatSettingsScreen` |
| `/api/chat/rooms/{id}/unmute/` | POST | Unmute room | `ChatSettingsScreen` |
| `/api/chat/messages/` | GET | List messages | `ChatScreen` |
| `/api/chat/messages/` | POST | Send message | `ChatScreen` |
| `/api/chat/messages/{id}/` | GET | Message detail | `ChatScreen` |
| `/api/chat/messages/{id}/` | PATCH | Edit message | `ChatScreen` |
| `/api/chat/messages/{id}/` | DELETE | Delete message | `ChatScreen` |
| `/api/chat/messages/search/` | GET | Search messages | `MessageSearchScreen` |
| `/api/chat/participants/` | GET | List participants | `ChatParticipantsScreen` |
| `/api/chat/participants/` | POST | Add participant | `ChatParticipantsScreen` |
| `/api/chat/participants/{id}/` | DELETE | Remove participant | `ChatParticipantsScreen` |
| `/api/chat/typing/` | POST | Typing indicator | `ChatScreen` |
| `/api/chat/typing/` | GET | Get typing users | `ChatScreen` |

**Chat Room Types:**
- `direct` - 1:1 messaging
- `group` - Group chat
- `task` - Task-specific chat (linked to specific task)
- `property` - Property-specific chat (linked to property)

**Typing Indicator Implementation:**
- ChatTypingIndicator model tracks active typing users per room
- `POST /api/chat/typing/` - Send typing status (is_typing: true/false)
- `GET /api/chat/typing/` - Poll for typing users in room
- Auto-expires after 5 seconds of inactivity
- Display "User is typing..." in chat UI

**Message Features:**
- Read receipts (track who has read messages)
- Message threading/replies (reply_to field)
- File/photo attachments (attachment_url field)
- Message editing with edit history
- Soft delete with "message deleted" placeholder

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
| `/api/permissions/user/{id}/` | GET | Get user's permissions | `ManagerUserDetailScreen` |

**Permission Features:**
- 38+ custom permissions for fine-grained access control
- Role-based permission assignments (RolePermission model)
- User-specific permission overrides (UserPermissionOverride model)
- Permission delegation from managers to staff

**Permission Override with Expiration:**
- Grant temporary permissions with expiration dates
- `expires_at` field on UserPermissionOverride
- Automatic permission revocation when expired
- UI displays expiration countdown
- Use cases: temporary access, vacation coverage, trial periods

**Permission Categories:**
- Task permissions (create, edit, delete, assign, complete)
- Property permissions (view, edit, manage inventory)
- Booking permissions (view, edit, import)
- User permissions (view, create, edit, manage permissions)
- Chat permissions (create rooms, manage participants)
- Report permissions (view, export)

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
- Charts Dashboard (`/api/admin/charts/`) - Chart.js analytics visualizations
- System Metrics (`/api/admin/metrics/`) - Performance monitoring
- System Logs (`/api/admin/logs/`) - Log viewer with filtering and download
- System Recovery (`/api/admin/recovery/`) - Crash recovery and diagnostics
- File Cleanup (`/api/admin/file-cleanup/`) - Media storage management

### Security Management
- Security Dashboard (`/api/admin/security/`) - Security overview
- Security Events (`/api/admin/security/events/`) - Event log viewer (login, token, password reset, suspicious activity)
- Active Sessions (`/api/admin/security/sessions/`) - Session management by device/IP/location
- Session Termination - Force logout users
- Suspicious Activity Detection - Pattern-based threat detection
- Account Lockout Management - Unlock accounts after failed attempts

### Data Import
- Excel Import (`/excel-import/`) - Basic Excel/CSV import
- Enhanced Excel Import (`/enhanced-excel-import/`) - Smart import with conflict detection
- Conflict Resolution (`/conflict-review/`) - Review and resolve import conflicts
- Conflict Preview (`/preview-conflict/`) - Preview conflict resolution before committing
- Quick Resolve (`/quick-resolve/`) - Batch conflict resolution
- Property Approval (`/property-approval/`) - Approve new properties from import

### Configuration
- Permission Management (`/api/admin/permissions/`) - 38+ custom permissions
- Digest Management (`/api/admin/digest-management/`) - Email digest configuration
- Notification Management (`/api/admin/notification-management/`) - Notification settings
- Invite Code Management (`/admin/invite-codes/`) - Full invite code CRUD

### Template Management (Backend Only)
**Schedule Templates:**
- ScheduleTemplate - Recurring task automation
- Frequency options: `daily`, `weekly`, `biweekly`, `monthly`
- Time-based triggers with property/task type assignments
- GeneratedTask - Track auto-generated tasks

**Auto-Task Templates:**
- AutoTaskTemplate - Booking-triggered task creation
- Trigger conditions: check-in, check-out, turnaround
- Task type and assignment rules

**Booking Import Templates:**
- BookingImportTemplate - Excel import configurations
- Field mapping customization
- Conflict detection rules
- BookingImportLog - Import audit trail

**Checklist Templates:**
- ChecklistTemplate - Reusable checklist definitions
- ChecklistItem - 8 item types with conditions and dependencies
- TaskTemplateTracking - Track template usage

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

### Phase 14: Multi-Tenancy Foundation
**Objective:** Transform to multi-tenant SaaS platform

#### Tasks:
1. **Database Schema Changes**
   - Create Tenant, TenantSettings, Subscription, Plan models
   - Add `tenant_id` foreign key to ALL existing models (40+ migrations)
   - Create tenant-aware indexes and constraints
   - Data migration for existing AriStay data as first tenant

2. **Middleware & Authentication**
   - Implement TenantMiddleware for request context
   - Update JWT tokens to include tenant_id
   - Create TenantAwareManager for automatic filtering
   - Update all ViewSets for tenant isolation

3. **Feature Flag System**
   - Implement per-tenant feature toggles
   - Create feature checking utilities
   - Update views to check feature availability

4. **API Restructuring**
   - Add tenant context to all endpoints
   - Update serializers for tenant-awareness
   - Create tenant management endpoints

---

### Phase 15: Super-Admin Panel
**Objective:** Platform management for SaaS operators

#### Screens to Build (9):
| Screen | Purpose |
|--------|---------|
| `SuperAdminDashboardScreen` | Platform metrics, health |
| `TenantListScreen` | All tenants with search/filter |
| `TenantDetailScreen` | Tenant info, settings, usage |
| `TenantCreateScreen` | Onboard new business |
| `SubscriptionListScreen` | All subscriptions |
| `BillingDashboardScreen` | Revenue analytics |
| `PlanManagementScreen` | Pricing plans CRUD |
| `UsageMonitoringScreen` | Resource usage per tenant |
| `SystemHealthScreen` | Platform health monitoring |

#### Features:
- Tenant CRUD with suspend/reactivate
- Impersonate tenant admin for support
- Subscription management
- Usage limit enforcement
- Revenue tracking and analytics
- Platform health monitoring

---

### Phase 16: Billing & Subscription
**Objective:** Stripe integration for SaaS billing

#### Tasks:
1. **Stripe Integration**
   - Set up Stripe account and API keys
   - Implement Stripe Customer creation
   - Implement Stripe Subscription management
   - Handle Stripe webhooks (payment success, failure, cancellation)

2. **Plan Management**
   - Create pricing plans in Stripe
   - Sync plans with database
   - Plan feature mapping

3. **Billing UI**
   - Subscription selection during signup
   - Billing portal for plan changes
   - Payment method management
   - Invoice history

4. **Usage Enforcement**
   - Track user count per tenant
   - Track property count per tenant
   - Track storage usage per tenant
   - Enforce limits with graceful degradation

---

### Phase 17: Tenant Onboarding
**Objective:** Self-service tenant signup and setup

#### Screens to Build (6):
| Screen | Purpose |
|--------|---------|
| `TenantSignupScreen` | Business registration |
| `TenantSetupWizardScreen` | Multi-step initial setup |
| `BrandingSetupScreen` | Logo, colors, app name |
| `FeatureConfigScreen` | Enable/disable features |
| `TeamInviteScreen` | Invite first team members |
| `DataImportScreen` | Import existing data |

#### Features:
- 14-day free trial
- Email verification flow
- Setup wizard (5-6 steps)
- White-label branding configuration
- Feature selection based on plan
- Bulk team invitation
- CSV/Excel data import

---

### Phase 18: External Integrations (Future)
**Objective:** Third-party platform integrations

#### Planned Integrations:
| Integration | Purpose | Priority |
|-------------|---------|----------|
| **Airbnb API** | Two-way booking sync | High |
| **VRBO/Booking.com** | Booking import | High |
| **Google Calendar** | Staff scheduling sync | Medium |
| **Slack** | Team notifications | Medium |
| **QuickBooks** | Accounting integration | Medium |
| **Stripe Connect** | Payment processing | Medium |
| **Twilio** | SMS notifications | Low |
| **WhatsApp Business** | Guest communication | Low |
| **Zapier** | Custom automations | Low |

#### Integration Architecture:
- OAuth2 authentication for each platform
- Webhook receivers for real-time updates
- Background sync workers (Celery)
- Conflict resolution for two-way sync

---

### Phase 19: Advanced Features (Future)
**Objective:** Enhanced capabilities for enterprise customers

#### Features:
1. **Business Intelligence**
   - Advanced analytics dashboard
   - Predictive task scheduling (ML)
   - Staff performance insights
   - Property utilization reports
   - Revenue forecasting

2. **Advanced Workflows**
   - Custom workflow builder
   - Multi-step approval processes
   - Automated escalation rules
   - SLA monitoring and alerts

3. **Guest Portal (Optional Module)**
   - Guest check-in portal
   - Service requests from guests
   - Review collection
   - Guest communication

4. **Compliance & Safety**
   - GDPR compliance tools
   - Data retention policies
   - Incident reporting
   - Safety audit checklists

5. **Single Sign-On (SSO)**
   - SAML 2.0 support
   - OAuth2/OIDC integration
   - Azure AD / Okta / Google Workspace

---

## Screen Count Summary

### Core Application Screens (Single-Tenant)
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
| **Subtotal** | **53** | |

### Multi-Tenant SaaS Screens (NEW)
| Module | Screens | Priority |
|--------|---------|----------|
| Super-Admin Panel | 9 | P2 - Medium |
| Tenant Onboarding | 6 | P2 - Medium |
| **Subtotal** | **15** | |

### **Grand Total: 68 Screens**

**Screen Breakdown by Version:**
- v1.0: 47 screens (initial plan)
- v1.1: +6 screens (missing features)
- v1.3: +15 screens (multi-tenant SaaS)

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
| 2025-12-22 | 1.1 | Added missing features after full codebase review |
| 2025-12-22 | 1.2 | Deep codebase review - added task/booking/chat/permission features |
| 2025-12-22 | 1.3 | **MAJOR** - Multi-tenant SaaS architecture for serving multiple businesses |

### Version 1.3 Additions (Multi-Tenant SaaS)

**New Architecture Section:**
- Complete multi-tenant SaaS architecture design
- Tenant isolation via logical database partitioning (tenant_id on all models)
- White-label branding support (logo, colors, custom domain)

**New Models (4):**
- `Tenant` - Organization/business entity
- `TenantSettings` - Per-tenant feature configuration
- `Subscription` - Billing and plan management
- `Plan` - Pricing tiers and feature limits

**Feature Categorization:**
- CORE features (always enabled): Task, Property, User, Notifications
- OPTIONAL features (toggle per tenant): Chat, Photos, Inventory, Lost & Found
- CUSTOMIZABLE features: Task types, booking statuses, branding, workflows

**New Phases (6):**
- Phase 14: Multi-Tenancy Foundation
- Phase 15: Super-Admin Panel (9 screens)
- Phase 16: Billing & Subscription (Stripe)
- Phase 17: Tenant Onboarding (6 screens)
- Phase 18: External Integrations (Airbnb, VRBO, Slack, etc.)
- Phase 19: Advanced Features (BI, Workflows, Guest Portal, SSO)

**New Endpoints:**
- Super-Admin API (9 endpoints for tenant/subscription management)
- Tenant configuration and branding endpoints
- Billing/subscription management endpoints

**Updated Screen Count:** 53 → 68 screens (+15 for SaaS)

---

### Version 1.2 Additions

**Task Management Enhancements:**
- Task dependencies (depends_on field) with `waiting_dependency` status
- Task locking mechanism to prevent auto-updates from imports
- Lock/unlock endpoints added to API mapping
- Task status workflow documented

**Booking Management Enhancements:**
- Booking conflict detection (same-day, overlapping, cross-property)
- Booking status workflow: `booked` → `confirmed` → `currently_hosting` → `completed`
- Provenance tracking (`created_via`, `modified_via` fields)
- Conflict check endpoint added

**Checklist System:**
- Added 2 missing item types: `date_input`, `time_input` (now 8 total)

**Chat System Enhancements:**
- Typing indicator implementation details (ChatTypingIndicator model)
- Room mute/unmute and archive/unarchive endpoints
- Message features: read receipts, threading, attachments, edit history

**Permission System Enhancements:**
- Permission override with expiration dates
- Permission categories documented
- Additional endpoint for getting user's permissions

**Admin-Only Features (Enhanced Documentation):**
- Security management: Suspicious activity detection, account lockout
- Data import: Conflict preview, quick resolve endpoints
- Template management: Full documentation of all 4 template types

---

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
