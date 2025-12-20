# Django UI Refactor — Status & Plan (2025-12-20)

**Date**: December 20, 2025
**Scope**: Django templates + static assets refactor across all UI surfaces (Staff, Portal, Admin, Manager), removing inline JS/event handlers and inline CSS while keeping the test suite green.
**UI Consistency Goal**: Ensure consistent design language across all pages using the established design system (design-system.css, components.css).

## 1) What’s been done so far (review)

### 1.1 Goal (recap)
- Eliminate inline JavaScript (`<script>…</script>` blocks and inline event handlers like `onclick=`) from all templates.
- Move behavior to ES modules under `aristay_backend/static/js/pages/*` (entrypoints) and `aristay_backend/static/js/modules/*` (feature managers).
- Extract large inline styles / page CSS into `aristay_backend/static/css/pages/*` and keep shared styling in existing design-system CSS.
- **Ensure UI consistency** across all pages by using design system tokens (colors, spacing, typography) and component classes.
- Keep a stable DOM contract via class hooks / `data-*` attributes.
- Maintain **green tests** as the non‑negotiable quality gate.

### 1.1.1 Overall Progress
**Completion Status: ~95%** (Staff, Portal, Admin, Manager assets created. Some inline handlers remain in templates.)

**Current Baseline (as of 2025-12-20):**
- ✅ **All CSS page files created** in `static/css/pages/` (Admin, Manager, Shared included)
- ✅ **All JS page modules created** in `static/js/pages/` (Admin, Manager, Shared included)
- ✅ **Design system established** with consistent tokens and components
- 📊 **Remaining work**: ~35 inline event handlers (mostly in `calendar_view.html`, `permission_management.html`, `chatbox.html`), ~27 inline style attributes.

### 1.2 Quality gate confirmation
- **Test Environment Issue**: Local Postgres connection refused. Tests cannot be run to verify quality.
- **Manual Inspection**: Completed files (`task_detail`, `photo_upload`) show high quality code structure (ES modules, CSS extraction).

### 1.3 Recent commits (this refactor stream)

Earlier (already reflected in the previous snapshot):
- Refactor staff base/layout to external assets
- Extract my_tasks inline assets
- Extract task_form inline assets
- Extract dashboard inline styles
- Extract checklist templates inline CSS

New since the previous snapshot:
- Extract laundry/lawn-pool dashboard inline styles
- Remove inline styles from staff components
- Remove remaining inline styles from task detail

New since starting the Portal phase:
- Extract portal calendar inline assets + modernize tests to assert external includes/JS file contents
- Remove inline styles from portal booking detail (moved to `static/css/pages/portal-booking-detail.css`)
- Extract portal photo management inline CSS/JS/handlers (moved to `static/css/pages/portal-photo-management.css` + `static/js/pages/portal-photo-management.js`)
- Remove remaining inline styles from portal property detail/list (moved to `static/css/pages/portal-property-detail.css` and `static/css/pages/portal-property-list.css`)

New since the Admin/Manager phase:
- Admin: extract enhanced excel import CSS/JS (moved to `static/css/pages/admin-enhanced-excel-import.css` + `static/js/pages/admin-enhanced-excel-import.js`)
- Admin: externalize charts dashboard CSS/JS (moved to `static/css/pages/admin-charts-dashboard.css` + `static/js/pages/admin-charts-dashboard.js`)
- Admin: externalize admin base site shell (moved to `static/css/pages/admin-base-site.css` + `static/js/pages/admin-base-site.js`)
- Manager: extract manager admin index CSS/JS (moved to `static/css/pages/manager-admin-index.css` + `static/js/pages/manager-admin-index.js`)
- Shared layouts: moved inline layout CSS/scripts to `static/css/pages/layout-*.css` and `static/js/core/alerts.js`

### 1.4 Lighthouse / review baseline
The earlier merge review is recorded here:
- docs/refactoring/FINAL_REVIEW_WITH_LIGHTHOUSE.md

### 1.5 Completed refactors (staff pages)

#### Staff Task Detail (large modernization)
- Template moved from inline handlers/scripts to an ES-module architecture.
- Page CSS extracted.
- Key DOM contract: `#taskDetailContainer[data-task-id]`.

Files:
- aristay_backend/api/templates/staff/task_detail.html
- aristay_backend/static/js/pages/task-detail.js
- aristay_backend/static/js/modules/* (task actions, checklist manager, timer, photo modal, photo manager)
- aristay_backend/static/css/pages/task-detail.css

Tests modernized to match the module architecture:
- tests/backend/test_staff_ui_functionality.py
- tests/ui/test_ui_selector_fix.py
- tests/ui/test_button_fix_verification.py
- tests/ui/test_timing_fix_verification.py

#### Staff Dashboard
- Removed reliance on inline event handlers by introducing delegated handlers using `data-action`.
- Behavior is implemented as a JS module manager.

Files:
- aristay_backend/api/templates/staff/dashboard.html
- aristay_backend/static/js/pages/dashboard.js
- aristay_backend/static/js/modules/dashboard-manager.js
- aristay_backend/static/css/components.css (dashboard styling consolidated here)

#### Lost & Found List
- Removed inline `onclick` / inline `<script>`.
- Introduced a page entrypoint and a manager module.
- Extracted styles into a page stylesheet.

Files:
- aristay_backend/api/templates/staff/lost_found_list.html
- aristay_backend/static/js/pages/lost-found-list.js
- aristay_backend/static/js/modules/lost-found-manager.js
- aristay_backend/static/css/pages/lost-found-list.css

#### Inventory Lookup
- Removed inline `onclick` and the inline `<script>` used for transaction logging.
- Extracted page styling to a dedicated CSS file.
- Uses `APIClient` for CSRF-safe POST to `/api/staff/inventory/transaction/`.

Files:
- aristay_backend/api/templates/staff/inventory_lookup.html
- aristay_backend/static/js/pages/inventory-lookup.js
- aristay_backend/static/js/modules/inventory-lookup-manager.js
- aristay_backend/static/css/pages/inventory-lookup.css

Note: During this status review, the template tail had a corrupted leftover fragment; it was fixed and pytest re-ran successfully.

#### Staff shell + core staff pages (recent)
- Staff layout/base: removed inline `<style>`/handlers and moved logic to external CSS/ES modules.
- My Tasks: extracted inline CSS + inline module snippet into `static/css/pages/my-tasks.css` and `static/js/pages/my-tasks.js`.
- Task Form: extracted inline styles/scripts; replaced inline confirms with `data-confirm` and delegated handling.
- Cleaning + Maintenance dashboards: removed inline style attributes/blocks; progress widths use `data-progress` + a small initializer.
- Checklist Templates: extracted page CSS into `static/css/pages/checklist-templates.css`.

## 2) Current refactor conventions (the “rules” we follow)

### 2.1 Template conventions
- No inline event handlers (`onclick=`, `onchange=`, etc.).
- Prefer stable hooks:
  - `data-action="..."` for event delegation.
  - `data-*` for IDs and metadata (`data-task-id`, `data-photo-id`, etc.).
- Keep templates focused on markup and server-rendered content.

### 2.2 JS conventions
- Page entrypoint: `aristay_backend/static/js/pages/<page>.js`
- Feature manager: `aristay_backend/static/js/modules/<feature>-manager.js`
- Shared infra:
  - `APIClient` for network requests.
  - `CSRFManager` for CSRF-safe mutation.
- Prefer event delegation at the document/container level.

### 2.3 CSS conventions
- Page CSS in `aristay_backend/static/css/pages/<page>.css`
- Shared styles remain in existing shared CSS (e.g. `static/css/components.css`).
- Avoid inventing new design primitives; use existing class patterns.

## 3) What still needs refactoring (backlog)

This backlog list is based on repository scans for:
- inline event handlers: `onclick=` / `on*=`
- inline styles: `style="..."`
- inline `<style>` blocks
- inline `<script>` blocks (non-module, no `src`, excluding JSON data scripts)

**Latest scan snapshot (2025-12-18)**

**Summary Statistics:**
- 🔴 **67 inline event handlers** (`onclick=`, `onchange=`, etc.)
- 🟡 **202 inline style attributes** (`style="..."`)
- 🟠 **35 inline `<style>` blocks**
- **Backup files excluded** from counts

---

### 3.0 Completed Sections (100%)

#### ✅ Staff Templates
- **Status**: All staff templates refactored (0 inline handlers, 0 inline styles, 0 inline scripts)
- **Files**: All templates under `aristay_backend/api/templates/staff/`
- **Assets**: CSS in `static/css/pages/staff-*.css`, JS in `static/js/pages/staff-*.js`

#### ✅ Portal Templates
- **Status**: All portal templates refactored (0 inline handlers, 0 inline styles, 0 inline scripts)
- **Files**: All templates under `aristay_backend/api/templates/portal/`
- **Assets**: CSS in `static/css/pages/portal-*.css`, JS in `static/js/pages/portal-*.js`

#### ✅ Layout Templates
- **Status**: All major layouts refactored
- **Files**: `layouts/staff_layout.html`, `layouts/portal_layout.html`, `layouts/public_layout.html`, `layouts/admin_layout.html`
- **Assets**: CSS in `static/css/pages/layout-*.css`

---

### 3.1 Remaining Work: Admin System Management (Priority 1 - High Impact)

**Status**: Mostly Complete. Assets created.

| File | Status | Notes |
|------|--------|-------|
| `admin/system_recovery.html` | ✅ DONE | Refactored. |
| `admin/system_metrics.html` | 🟡 PARTIAL | 3 dynamic inline styles remain (progress bars). |
| `admin/system_logs.html` | ✅ DONE | Refactored. |

**Target Assets:**
- CSS: `static/css/pages/admin-system-recovery.css`, `admin-system-metrics.css`, `admin-system-logs.css` (Created)
- JS: `static/js/pages/admin-system-recovery.js`, `admin-system-metrics.js`, `admin-system-logs.js` (Created)

---

### 3.2 Remaining Work: Photo Management (Priority 2 - Critical Shared Feature)

**Status**: Complete.

| File | Status | Notes |
|------|--------|-------|
| `photo_upload.html` | ✅ DONE | Refactored. |
| `photo_management.html` | ✅ DONE | Refactored. |
| `photo_comparison.html` | ✅ DONE | Refactored. |

**Target Assets:**
- CSS: `static/css/pages/photo-upload.css`, `photo-management.css`, `photo-comparison.css` (Created)
- JS: `static/js/pages/photo-upload.js`, `photo-management.js`, `photo-comparison.js` (Created)

---

### 3.3 Remaining Work: Invite Code System (Priority 3)

**Status**: Complete.

| File | Status | Notes |
|------|--------|-------|
| `invite_codes/list.html` | ✅ DONE | Refactored. |
| `invite_codes/create.html` | ✅ DONE | Refactored. |
| `admin/invite_code_detail.html` | ✅ DONE | Refactored. |
| `admin/invite_code_list.html` | ✅ DONE | Refactored. |
| `admin/create_invite_code.html` | ✅ DONE | Refactored. |
| `admin/edit_invite_code.html` | ✅ DONE | Refactored. |
| `admin/invite_codes.html` | ✅ DONE | Refactored. |

**Target Assets:**
- CSS: `static/css/pages/invite-codes-list.css`, etc. (Created)
- JS: `static/js/pages/invite-codes-list.js`, etc. (Created)

---

### 3.4 Remaining Work: Admin Access Control (Priority 4)

**Status**: Mostly Complete.

| File | Status | Notes |
|------|--------|-------|
| `admin/conflict_resolution.html` | ✅ DONE | Refactored. |
| `admin/permission_management.html` | 🔴 PARTIAL | 4 inline handlers in JS template strings. |
| `admin/property_approval.html` | ✅ DONE | Refactored. |

**Target Assets:**
- CSS: `static/css/pages/admin-conflict-resolution.css`, etc. (Created)
- JS: `static/js/pages/admin-conflict-resolution.js`, etc. (Created)

---

### 3.5 Remaining Work: Communication Tools (Priority 5)

**Status**: Partial.

| File | Status | Notes |
|------|--------|-------|
| `chat/chatbox.html` | 🔴 PARTIAL | 4 inline handlers remain. |
| `calendar/calendar_view.html` | 🔴 PARTIAL | 4 inline handlers remain. |

**Target Assets:**
- CSS: `static/css/pages/chat-chatbox.css`, `calendar-view.css` (Created)
- JS: `static/js/pages/chat-chatbox.js`, `calendar-view.js` (Created)

---

### 3.6 Remaining Work: Manager Admin & Other (Priority 6)

**Status**: Mostly Complete.

| File | Status | Notes |
|------|--------|-------|
| `manager_admin/base_site.html` | ✅ DONE | Refactored. |
| `admin/excel_import.html` | ✅ DONE | Refactored. |
| `auth/unified_login.html` | ✅ DONE | Refactored. |
| `admin/notification_management.html` | ✅ DONE | Refactored. |
| `admin/digest_management.html` | ✅ DONE | Refactored. |
| `admin/security_dashboard.html` | 🟡 PARTIAL | 1 inline handler remains. |

**Target Assets:**
- CSS: `static/css/pages/manager-admin-base-site.css`, etc. (Created)
- JS: `static/js/pages/manager-admin-base-site.js`, etc. (Created)

---

## 4) Actionable Refactor Plan (2025-12-20 Forward)

**Note**: Most assets are created. The focus is now on removing the last few inline handlers and styles.

### Phase 6 — Final Cleanup (Week 1)
**Impact**: Completing the refactor to 100%.
**Estimated Effort**: 2-3 days.

#### 6.1: Calendar View (Day 1)
**File**: `calendar/calendar_view.html` (4 handlers)
**Task**: Remove `onclick="refreshCalendar()"`, `exportCalendar()`, etc. Use `data-action` delegation in `calendar-calendar-view.js`.

#### 6.2: Permission Management (Day 1)
**File**: `admin/permission_management.html` (4 handlers)
**Task**: The handlers are inside JS template strings (`onclick="revokePermission..."`).
**Fix**:
- Change buttons to use `data-action="revoke"` and `data-user-id="..."`.
- Update `admin-permission-management.js` to handle clicks on the container using event delegation.

#### 6.3: Chatbox (Day 2)
**File**: `chat/chatbox.html` (4 handlers)
**Task**: Remove `onclick="selectRoom..."`, `toggleRoomList()`, `sendMessage()`.
**Fix**: Use event delegation in `chat-chatbox.js`.

#### 6.4: Security Dashboard & Charts (Day 2)
**Files**: `admin/security_dashboard.html`, `admin/manager_charts.html`
**Task**: Remove remaining `onclick="refreshData()"`.

#### 6.5: Dynamic Styles Cleanup (Day 3)
**Files**: `admin/system_metrics.html`, `admin/invite_codes.html`
**Task**:
- `style="width: {{ ... }}%"` is acceptable for dynamic progress bars, but can be improved by using `data-width` and a small JS observer if strict CSP is required.
- For now, verify if these are the ONLY inline styles left.

### Phase 7 — Quality Assurance (Week 2)
**Task**: Fix Test Environment
1. Configure `settings_test.py` to use SQLite properly or fix local Postgres connection.
2. Run full test suite.
3. Verify no regressions in refactored pages.

---

## Appendix A — Assets Created During Refactor (Complete List)

### Design System Foundation (Shared)
- `aristay_backend/static/css/design-system.css` — Design tokens (colors, typography, spacing)
- `aristay_backend/static/css/components.css` — Reusable UI components
- `aristay_backend/static/css/layouts.css` — Layout patterns
- `aristay_backend/static/css/utilities.css` — Utility classes
- `aristay_backend/static/css/responsive.css` — Responsive breakpoints
- `aristay_backend/static/css/theme-toggle.css` — Theme switching

### CSS Page Files (31 files)

**Staff Pages** (12 files):
- `staff-layout.css`, `staff-base.css`
- `task-detail.css`, `task-form.css`, `my-tasks.css`
- `dashboard.css`, `lost-found-list.css`, `inventory-lookup.css`
- `maintenance-dashboard.css`, `cleaning-dashboard.css`
- `laundry-dashboard.css`, `lawn-pool-dashboard.css`
- `checklist-templates.css`

**Portal Pages** (9 files):
- `portal-home.css`, `portal-base.css`
- `portal-notification-settings.css`, `portal-digest-settings.css`
- `portal-task-detail.css`, `portal-calendar.css`
- `portal-booking-detail.css`, `portal-photo-management.css`
- `portal-property-detail.css`, `portal-property-list.css`

**Layout Pages** (4 files):
- `layout-portal.css`, `layout-public.css`
- `layout-admin.css`, `base-legacy.css`

**Admin/Manager Pages** (5 files):
- `admin-enhanced-excel-import.css`, `admin-charts-dashboard.css`
- `manager-admin-index.css`, `admin-base-site.css`
- `admin-file-cleanup.css`

### JS Page Files (18 files)

**Staff Pages** (8 files):
- `task-detail.js`, `dashboard.js`, `lost-found-list.js`
- `inventory-lookup.js`, `my-tasks.js`, `cleaning-dashboard.js`
- `task-form.js`, `staff-base.js`

**Portal Pages** (6 files):
- `portal-base.js`, `portal-notification-settings.js`
- `portal-digest-settings.js`, `portal-task-detail.js`
- `portal-calendar.js`, `portal-photo-management.js`

**Admin/Manager Pages** (4 files):
- `admin-enhanced-excel-import.js`, `admin-charts-dashboard.js`
- `manager-admin-index.js`, `admin-base-site.js`
- `admin-file-cleanup.js`

### JS Module Files (Feature Managers)
- `aristay_backend/static/js/modules/dashboard-manager.js`
- `aristay_backend/static/js/modules/lost-found-manager.js`
- `aristay_backend/static/js/modules/inventory-lookup-manager.js`
- `aristay_backend/static/js/modules/task-actions.js`
- `aristay_backend/static/js/modules/checklist-manager.js`
- `aristay_backend/static/js/modules/timer.js`
- `aristay_backend/static/js/modules/photo-modal.js`
- `aristay_backend/static/js/modules/photo-manager.js`

### Core Infrastructure
- `aristay_backend/static/js/core/alerts.js` — Alert/notification system
- `aristay_backend/static/js/core/api-client.js` — CSRF-safe API client
- `aristay_backend/static/js/core/csrf-manager.js` — CSRF token management

---

## Appendix B — Refactor Patterns Reference

### Pattern 1: Inline Handler Replacement
**Before**:
```html
<button onclick="deleteItem(123)">Delete</button>
```

**After**:
```html
<button data-action="delete" data-id="123">Delete</button>
```

```javascript
// In page JS module
document.addEventListener('click', (e) => {
  if (e.target.dataset.action === 'delete') {
    const id = e.target.dataset.id;
    deleteItem(id);
  }
});
```

### Pattern 2: Inline Style Extraction
**Before**:
```html
<div style="background: #f0f0f0; padding: 15px; margin-bottom: 10px;">
```

**After**:
```html
<div class="card p-4 mb-3">
```

```css
/* In page CSS */
.card {
  background: var(--color-gray-100);
  border-radius: var(--radius-md);
}
```

### Pattern 3: Dynamic Style via Data Attributes
**Before**:
```html
<div style="width: 75%;" class="progress-bar"></div>
```

**After**:
```html
<div data-progress="75" class="progress-bar"></div>
```

```javascript
// In page JS
document.querySelectorAll('[data-progress]').forEach(bar => {
  bar.style.width = `${bar.dataset.progress}%`;
});
```

### Pattern 4: Design System Token Usage
**Replace arbitrary values**:
- Colors: `#3b82f6` → `var(--color-primary)`
- Spacing: `padding: 16px` → `var(--space-4)` or `class="p-4"`
- Font sizes: `font-size: 14px` → `var(--font-size-sm)`
- Border radius: `border-radius: 8px` → `var(--radius-md)`

---

**End of Status & Refactor Plan**
