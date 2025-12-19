# Django UI Refactor — Status & Plan (2025-12-18)

**Date**: December 18, 2025
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
**Completion Status: ~75%** (Staff & Portal: 100%, Admin/Manager: ~40%)

**Current Baseline (as of 2025-12-18):**
- ✅ **31 CSS page files created** in `static/css/pages/`
- ✅ **18 JS page modules created** in `static/js/pages/`
- ✅ **Design system established** with consistent tokens and components
- 📊 **Remaining work**: 67 inline event handlers, 202 inline style attributes, 35 inline `<style>` blocks

### 1.2 Quality gate confirmation
- Pytest ran successfully after the most recent refactor chunks (staff shell/pages/dashboards/checklists/components/task detail), using:
  - `pytest -q`
- Result: **100% pass** (warnings only).

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

**Total**: 36 + 24 + 11 = 71 inline styles, 5 + 1 = 6 handlers

| File | Inline Styles | Inline Handlers | Priority | Notes |
|------|--------------|-----------------|----------|--------|
| `admin/system_recovery.html` | 36 | 2 | HIGH | System recovery interface |
| `admin/system_metrics.html` | 24 | 1 | HIGH | Metrics dashboard |
| `admin/system_logs.html` | 11 | 5 | HIGH | Log viewer |

**Target Assets:**
- CSS: `static/css/pages/admin-system-recovery.css`, `admin-system-metrics.css`, `admin-system-logs.css`
- JS: `static/js/pages/admin-system-recovery.js`, `admin-system-metrics.js`, `admin-system-logs.js`

---

### 3.2 Remaining Work: Photo Management (Priority 2 - Critical Shared Feature)

**Total**: 12 + 6 = 18 inline styles, 10 + 3 + 2 = 15 handlers

| File | Inline Styles | Inline Handlers | Priority | Notes |
|------|--------------|-----------------|----------|--------|
| `photo_upload.html` | 12 | 10 | HIGH | Highest handler count remaining |
| `photo_management.html` | 6 | 3 | MEDIUM | Photo management UI |
| `photo_comparison.html` | 0 | 2 | MEDIUM | Photo comparison tool |

**Target Assets:**
- CSS: `static/css/pages/photo-upload.css`, `photo-management.css`, `photo-comparison.css`
- JS: `static/js/pages/photo-upload.js`, `photo-management.js`, `photo-comparison.js`

---

### 3.3 Remaining Work: Invite Code System (Priority 3)

**Total**: 22 + 16 + 8 = 46 inline styles, 4 + 1 + 3 = 8 handlers

| File | Inline Styles | Inline Handlers | Priority | Notes |
|------|--------------|-----------------|----------|--------|
| `invite_codes/list.html` | 22 | 4 | MEDIUM | Invite code listing |
| `invite_codes/create.html` | 16 | 1 | MEDIUM | Create new invite codes |
| `admin/invite_code_detail.html` | 8 | 3 | MEDIUM | Detail/edit view |
| `admin/invite_code_list.html` | 3 | 2 | LOW | Alternative list view |
| `admin/create_invite_code.html` | 0 | 3 | LOW | Admin create view |
| `admin/edit_invite_code.html` | 5 | 0 | LOW | Admin edit view |
| `admin/invite_codes.html` | 0 | 2 | LOW | Admin index |

**Target Assets:**
- CSS: `static/css/pages/invite-codes-list.css`, `invite-codes-create.css`, `admin-invite-code-detail.css`
- JS: `static/js/pages/invite-codes-list.js`, `invite-codes-create.js`, `admin-invite-code-detail.js`

---

### 3.4 Remaining Work: Admin Access Control (Priority 4)

**Total**: 5 inline styles, 7 + 4 + 3 = 14 handlers

| File | Inline Styles | Inline Handlers | Priority | Notes |
|------|--------------|-----------------|----------|--------|
| `admin/conflict_resolution.html` | 5 | 7 | MEDIUM | Data conflict resolution |
| `admin/permission_management.html` | 0 | 4 | MEDIUM | Permission editor |
| `admin/property_approval.html` | 0 | 3 | MEDIUM | Property approval workflow |

**Target Assets:**
- CSS: `static/css/pages/admin-conflict-resolution.css`, `admin-permission-management.css`, `admin-property-approval.css`
- JS: `static/js/pages/admin-conflict-resolution.js`, `admin-permission-management.js`, `admin-property-approval.js`

---

### 3.5 Remaining Work: Communication Tools (Priority 5)

**Total**: 4 inline styles, 4 + 4 = 8 handlers

| File | Inline Styles | Inline Handlers | Priority | Notes |
|------|--------------|-----------------|----------|--------|
| `chat/chatbox.html` | 4 | 4 | MEDIUM | Chat interface |
| `calendar/calendar_view.html` | 0 | 4 | MEDIUM | Calendar view |

**Target Assets:**
- CSS: `static/css/pages/chat-chatbox.css`, `calendar-view.css`
- JS: `static/js/pages/chat-chatbox.js`, `calendar-view.js`

---

### 3.6 Remaining Work: Manager Admin & Other (Priority 6)

**Total**: 9 + 9 + 5 + 5 + 4 = 32 inline styles, 2 + 1 = 3 handlers

| File | Inline Styles | Inline Handlers | Priority | Notes |
|------|--------------|-----------------|----------|--------|
| `manager_admin/base_site.html` | 9 | 0 | MEDIUM | Manager base layout |
| `admin/excel_import.html` | 9 | 2 | LOW | Excel import tool |
| `auth/unified_login.html` | 5 | 0 | LOW | Login page |
| `admin/notification_management.html` | 5 | 0 | LOW | Notification settings |
| `admin/digest_management.html` | 4 | 0 | LOW | Digest settings |
| `admin/security_dashboard.html` | 0 | 1 | LOW | Security dashboard |

**Target Assets:**
- CSS: `static/css/pages/manager-admin-base-site.css`, `admin-excel-import.css`, etc.
- JS: `static/js/pages/manager-admin-base-site.js`, `admin-excel-import.js`, etc.

---

## 4) Actionable Refactor Plan (2025-12-18 Forward)

**Note**: Staff & Portal templates are 100% complete. Focus is now on Admin, Manager, and shared features.

### Phase 5A — Admin System Management (Week 1)
**Impact**: Highest inline style concentration (71 styles), critical admin tools
**Estimated Effort**: 3-4 days

#### 5A.1: System Recovery (Day 1)
**File**: `admin/system_recovery.html` (36 inline styles, 2 handlers)

**Tasks**:
1. Read template and identify inline style patterns
2. Extract to `static/css/pages/admin-system-recovery.css`:
   - Replace color values with design system tokens (e.g., `#f0f0f0` → `var(--color-gray-100)`)
   - Replace spacing with utility classes (e.g., `padding: 15px` → `p-4`)
   - Create semantic classes for recovery status indicators
3. Replace inline handlers with `data-action` delegation
4. Create `static/js/pages/admin-system-recovery.js` for behavior
5. Update template to reference external assets
6. Run `pytest -q` to verify

**Acceptance Criteria**:
- Zero inline styles, zero inline handlers
- Design system colors and spacing used throughout
- Tests pass

#### 5A.2: System Metrics (Day 2)
**File**: `admin/system_metrics.html` (24 inline styles, 1 handler)

**Tasks**:
1. Read template and identify chart/metric styling patterns
2. Extract to `static/css/pages/admin-system-metrics.css`:
   - Standardize metric card styles using `.card` component
   - Use design system status colors for metric indicators
   - Create reusable classes for metric layouts
3. Replace inline handler with `data-action` delegation
4. Create `static/js/pages/admin-system-metrics.js` for dynamic updates
5. Update template to reference external assets
6. Run `pytest -q` to verify

**Acceptance Criteria**:
- Zero inline styles, zero inline handlers
- Consistent metric card appearance
- Tests pass

#### 5A.3: System Logs (Days 3-4)
**File**: `admin/system_logs.html` (11 inline styles, 5 handlers)

**Tasks**:
1. Read template and identify log viewer patterns
2. Extract to `static/css/pages/admin-system-logs.css`:
   - Standardize log entry styles
   - Use design system for log level colors (info/warning/error)
   - Create filter panel styling
3. Replace 5 inline handlers with event delegation pattern
4. Create `static/js/pages/admin-system-logs.js`:
   - Log filtering logic
   - Log level toggling
   - Export functionality
5. Update template to reference external assets
6. Run `pytest -q` to verify

**Acceptance Criteria**:
- Zero inline styles, zero inline handlers
- Consistent log viewer appearance
- All filtering/export functionality works
- Tests pass

---

### Phase 5B — Photo Management System (Week 2)
**Impact**: Critical shared feature, highest handler count (15 handlers)
**Estimated Effort**: 3-4 days

#### 5B.1: Photo Upload (Days 1-2)
**File**: `photo_upload.html` (12 inline styles, **10 handlers**)

**Tasks**:
1. Read template and identify upload flow patterns
2. Extract to `static/css/pages/photo-upload.css`:
   - Standardize upload dropzone styling
   - Use design system for progress indicators
   - Create preview card styles
3. Replace 10 inline handlers with unified event delegation
4. Create `static/js/pages/photo-upload.js`:
   - Drag-and-drop handler
   - File validation logic
   - Upload progress tracking
   - Preview generation
5. Update template to reference external assets
6. Run `pytest -q` to verify

**Acceptance Criteria**:
- Zero inline styles, zero inline handlers
- Drag-and-drop works correctly
- Upload progress displays consistently
- Tests pass

#### 5B.2: Photo Management (Day 3)
**File**: `photo_management.html` (6 inline styles, 3 handlers)

**Tasks**:
1. Read template and identify photo grid patterns
2. Extract to `static/css/pages/photo-management.css`:
   - Standardize photo grid layout
   - Use design system for action buttons
   - Create lightbox/modal styles
3. Replace 3 inline handlers with event delegation
4. Create `static/js/pages/photo-management.js`:
   - Photo selection logic
   - Bulk actions
   - Lightbox functionality
5. Update template to reference external assets
6. Run `pytest -q` to verify

**Acceptance Criteria**:
- Zero inline styles, zero inline handlers
- Photo grid displays consistently
- Lightbox works correctly
- Tests pass

#### 5B.3: Photo Comparison (Day 4)
**File**: `photo_comparison.html` (0 inline styles, 2 handlers)

**Tasks**:
1. Read template and identify comparison patterns
2. Extract to `static/css/pages/photo-comparison.css`:
   - Standardize side-by-side comparison layout
   - Use design system for comparison controls
3. Replace 2 inline handlers with event delegation
4. Create `static/js/pages/photo-comparison.js`:
   - Comparison slider logic
   - Zoom controls
5. Update template to reference external assets
6. Run `pytest -q` to verify

**Acceptance Criteria**:
- Zero inline styles, zero inline handlers
- Comparison view works correctly
- Tests pass

---

### Phase 5C — Invite Code System (Week 3)
**Impact**: Moderate (46 inline styles, 8 handlers), admin feature
**Estimated Effort**: 3-4 days

#### 5C.1: Invite Codes List (Day 1)
**File**: `invite_codes/list.html` (22 inline styles, 4 handlers)

**Tasks**:
1. Extract to `static/css/pages/invite-codes-list.css`
2. Replace 4 inline handlers with event delegation
3. Create `static/js/pages/invite-codes-list.js`
4. Run `pytest -q` to verify

#### 5C.2: Invite Codes Create (Day 2)
**File**: `invite_codes/create.html` (16 inline styles, 1 handler)

**Tasks**:
1. Extract to `static/css/pages/invite-codes-create.css`
2. Replace inline handler with event delegation
3. Create `static/js/pages/invite-codes-create.js`
4. Run `pytest -q` to verify

#### 5C.3: Admin Invite Code Pages (Days 3-4)
**Files**:
- `admin/invite_code_detail.html` (8 styles, 3 handlers)
- `admin/invite_code_list.html` (3 styles, 2 handlers)
- `admin/create_invite_code.html` (0 styles, 3 handlers)
- `admin/edit_invite_code.html` (5 styles, 0 handlers)
- `admin/invite_codes.html` (0 styles, 2 handlers)

**Tasks**:
1. Extract CSS for each page
2. Replace all handlers with event delegation
3. Create JS modules as needed
4. Run `pytest -q` after each file

---

### Phase 5D — Admin Access Control (Week 4)
**Impact**: Moderate (5 inline styles, 14 handlers), admin feature
**Estimated Effort**: 3 days

#### 5D.1: Conflict Resolution (Day 1)
**File**: `admin/conflict_resolution.html` (5 inline styles, 7 handlers)

**Tasks**:
1. Extract to `static/css/pages/admin-conflict-resolution.css`
2. Replace 7 inline handlers with event delegation
3. Create `static/js/pages/admin-conflict-resolution.js`
4. Run `pytest -q` to verify

#### 5D.2: Permission Management (Day 2)
**File**: `admin/permission_management.html` (0 inline styles, 4 handlers)

**Tasks**:
1. Extract to `static/css/pages/admin-permission-management.css`
2. Replace 4 inline handlers with event delegation
3. Create `static/js/pages/admin-permission-management.js`
4. Run `pytest -q` to verify

#### 5D.3: Property Approval (Day 3)
**File**: `admin/property_approval.html` (0 inline styles, 3 handlers)

**Tasks**:
1. Extract to `static/css/pages/admin-property-approval.css`
2. Replace 3 inline handlers with event delegation
3. Create `static/js/pages/admin-property-approval.js`
4. Run `pytest -q` to verify

---

### Phase 5E — Communication & Remaining (Week 5)
**Impact**: Low-medium, final cleanup
**Estimated Effort**: 3-5 days

#### 5E.1: Chat & Calendar (Days 1-2)
**Files**:
- `chat/chatbox.html` (4 inline styles, 4 handlers)
- `calendar/calendar_view.html` (0 inline styles, 4 handlers)

**Tasks**: Extract CSS/JS, replace handlers, verify tests

#### 5E.2: Manager & Misc (Days 3-5)
**Files**:
- `manager_admin/base_site.html` (9 styles)
- `admin/excel_import.html` (9 styles, 2 handlers)
- `auth/unified_login.html` (5 styles)
- `admin/notification_management.html` (5 styles)
- `admin/digest_management.html` (4 styles)
- Other low-priority files

**Tasks**: Extract CSS/JS, replace handlers, verify tests

---

### Quality Gates for Every Phase

After each file refactor:
1. ✅ Run `pytest -q` — must pass (warnings OK)
2. ✅ Verify zero inline handlers: `rg -n -P -g'*.html' '\son[a-zA-Z]+=' <file>`
3. ✅ Verify minimal inline styles: `rg -n -g'*.html' 'style="' <file>`
4. ✅ Verify design system usage: Check for design tokens in CSS
5. ✅ Manual smoke test: Load page in browser, verify functionality
6. ✅ Commit with clear message

---

### UI Consistency Checklist

For each refactored page, ensure:
- [ ] Colors use design system tokens (`var(--color-primary)`, etc.)
- [ ] Spacing uses design system scale (`var(--space-4)`, `.p-4`, etc.)
- [ ] Buttons use `.btn`, `.btn-primary`, `.btn-secondary` classes
- [ ] Forms use `.form-group`, `.form-input`, `.form-label` classes
- [ ] Cards use `.card`, `.card-header`, `.card-body` classes
- [ ] Status indicators use `.badge-success`, `.badge-warning`, `.badge-danger`
- [ ] Typography uses design system font sizes and weights
- [ ] No arbitrary inline colors (e.g., `#f0f0f0`, `red`, `blue`)
- [ ] No arbitrary inline spacing (e.g., `padding: 15px`, `margin: 10px`)

---

### Progress Tracking Commands

Run these to track remaining work:

```bash
# Count inline handlers
rg -n -P -g'*.html' '\son[a-zA-Z]+=' aristay_backend/api/templates | wc -l

# Count inline style attributes
rg -n -g'*.html' 'style="' aristay_backend/api/templates | wc -l

# Count inline <style> blocks
rg -n -g'*.html' '<style>' aristay_backend/api/templates | wc -l

# List top offenders
rg -n -P -g'*.html' '\son[a-zA-Z]+=' aristay_backend/api/templates | cut -d: -f1 | sort | uniq -c | sort -rn | head -10
```

## 5) Summary: What's Next?

**Current State (2025-12-18)**:
- ✅ Staff templates: 100% complete
- ✅ Portal templates: 100% complete
- ✅ Layout templates: 100% complete
- 🟡 Admin templates: ~40% complete
- 🟡 Manager templates: ~30% complete
- 📊 Overall: ~75% complete

**Next Priority**: Start Phase 5A — Admin System Management (Week 1)
- Begin with `admin/system_recovery.html` (highest inline style count: 36)
- Follow the detailed task breakdown in Section 4
- Use the UI Consistency Checklist to ensure design system compliance

**Key Success Factors**:
1. Follow established conventions (Section 2)
2. Use design system tokens consistently
3. Run `pytest -q` after every change
4. Commit frequently with clear messages
5. Track progress using the commands in Section 4

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
