# Django UI Refactor — Status & Plan (2025-12-13)

**Date**: December 13, 2025  
**Scope**: Django templates + static assets refactor (primary focus: Staff UI), removing inline JS/event handlers and inline CSS while keeping the test suite green.

## 1) What’s been done so far (review)

### 1.1 Goal (recap)
- Eliminate inline JavaScript (`<script>…</script>` blocks and inline event handlers like `onclick=`) from staff templates.
- Move behavior to ES modules under `aristay_backend/static/js/pages/*` (entrypoints) and `aristay_backend/static/js/modules/*` (feature managers).
- Extract large inline styles / page CSS into `aristay_backend/static/css/pages/*` and keep shared styling in existing design-system CSS.
- Keep a stable DOM contract via class hooks / `data-*` attributes.
- Maintain **green tests** as the non‑negotiable quality gate.

### 1.2 Quality gate confirmation
- Pytest ran successfully after the most recent template fix (inventory lookup), using:
  - `python -m pytest -q`
- Result: **100% pass** (warnings only).

### 1.3 Lighthouse / review baseline
The earlier merge review is recorded here:
- docs/refactoring/FINAL_REVIEW_WITH_LIGHTHOUSE.md

### 1.4 Completed refactors (staff pages)

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

### 3.1 Staff templates (highest priority)

**Inline event handlers (onclick)**
- aristay_backend/api/templates/staff/base.html (3)
- aristay_backend/api/templates/staff/task_form.html (1)

**Inline script blocks (non-module)**
- aristay_backend/api/templates/staff/base.html (2)
- aristay_backend/api/templates/staff/task_form.html (1)

**Inline style blocks (`<style>…`)**
- aristay_backend/api/templates/staff/my_tasks.html (2)
- aristay_backend/api/templates/staff/task_form.html (1)
- aristay_backend/api/templates/staff/maintenance_dashboard.html (1)
- aristay_backend/api/templates/staff/cleaning_dashboard.html (1)
- aristay_backend/api/templates/staff/checklist_templates.html (1)
- aristay_backend/api/templates/staff/base.html (1)

**Inline `style="..."` attributes (top offenders)**
- aristay_backend/api/templates/staff/maintenance_dashboard.html (25)
- aristay_backend/api/templates/staff/cleaning_dashboard.html (15)
- aristay_backend/api/templates/staff/base.html (10)
- aristay_backend/api/templates/staff/task_detail.html (5)
- aristay_backend/api/templates/staff/laundry_dashboard.html (5)
- aristay_backend/api/templates/staff/components/task_progress.html (5)
- aristay_backend/api/templates/staff/task_form.html (4)
- aristay_backend/api/templates/staff/lawn_pool_dashboard.html (4)
- aristay_backend/api/templates/staff/components/task_timer.html (2)
- aristay_backend/api/templates/staff/components/task_checklist.html (2)
- aristay_backend/api/templates/staff/my_tasks.html (1)
- aristay_backend/api/templates/staff/components/task_header.html (1)

### 3.2 Layout templates (high leverage)
These affect many pages and should be addressed early.
- aristay_backend/api/templates/layouts/staff_layout.html (inline `<style>`/`<script>` detected)
- aristay_backend/api/templates/layouts/public_layout.html (inline `<style>`/`<script>` detected)
- aristay_backend/api/templates/layouts/portal_layout.html (inline `<style>`/`<script>` detected)
- aristay_backend/api/templates/layouts/admin_layout.html (inline `<style>`/`<script>` detected)

### 3.3 Portal templates (medium priority, user-facing)
**Inline `style="..."` is common**
- aristay_backend/api/templates/portal/home.html (59)
- aristay_backend/api/templates/portal/notification_settings.html (38)
- aristay_backend/api/templates/portal/digest_settings.html (37)
- aristay_backend/api/templates/portal/task_detail.html (35)
- aristay_backend/api/templates/portal/base.html (12)
- aristay_backend/api/templates/portal/calendar.html (11)
- aristay_backend/api/templates/portal/booking_detail.html (9)
- aristay_backend/api/templates/portal/photo_management.html (8)
- aristay_backend/api/templates/portal/property_detail.html (7)
- aristay_backend/api/templates/portal/property_list.html (5)

**Inline onclick handlers**
- aristay_backend/api/templates/portal/calendar.html (7)
- aristay_backend/api/templates/portal/base.html (3)
- aristay_backend/api/templates/portal/photo_management.html (3)
- aristay_backend/api/templates/portal/task_detail.html (2)
- aristay_backend/api/templates/portal/notification_settings.html (1)

### 3.4 Admin / manager templates (lower priority unless actively used)
These are the largest sources of `onclick=` and inline `style=`.

**Inline onclick hotspots**
- aristay_backend/api/templates/admin/charts_dashboard.html (13)
- aristay_backend/api/templates/manager_admin/index.html (12)
- aristay_backend/api/templates/admin/file_cleanup.html (7)
- aristay_backend/api/templates/admin/conflict_resolution.html (7)
- aristay_backend/api/templates/photo_upload.html (8)

**Inline style hotspots**
- aristay_backend/api/templates/admin/enhanced_excel_import.html (62)
- aristay_backend/api/templates/admin/charts_dashboard.html (60)
- aristay_backend/api/templates/manager_admin/index.html (53)
- aristay_backend/api/templates/admin/base_site.html (41)
- aristay_backend/api/templates/admin/system_recovery.html (36)
- aristay_backend/api/templates/admin/system_metrics.html (24)

### 3.5 Misc pages
- aristay_backend/api/templates/chat/chatbox.html (onclick + style)
- aristay_backend/api/templates/calendar/calendar_view.html (onclick + style)
- aristay_backend/api/templates/photo_management.html (onclick + style)
- aristay_backend/api/templates/photo_comparison.html (onclick + style)

## 4) Refactor plan (prioritized)

### Phase 1 — Staff shell + base templates (highest leverage)
**Target**: remove inline JS/handlers from templates that wrap many staff pages.

1) Refactor `layouts/staff_layout.html`
- Move any inline navigation/sidebar scripts into `static/js/modules/staff-layout.js` (or similar) + a page-independent loader.
- Prefer event delegation and `data-action` hooks.

2) Refactor `staff/base.html`
- Replace `onclick` and inline scripts with an ES-module entrypoint (or load via staff layout module if it’s global).

**Acceptance criteria**
- No inline scripts or inline `on*=` handlers remain in these templates.
- Existing staff navigation behavior remains unchanged.
- `pytest -q` stays green.

### Phase 2 — Staff forms and lists
1) Refactor `staff/task_form.html`
- Replace confirm dialogs / submit handlers with delegated JS.
- Extract `<style>` block into `static/css/pages/task-form.css`.

2) Refactor `staff/my_tasks.html`
- Extract both `<style>` blocks into `static/css/pages/my-tasks.css`.
- Replace inline scripts with `static/js/pages/my-tasks.js` + a manager module.

**Acceptance criteria**
- No inline `<style>` or non-module `<script>` blocks.
- No inline `onclick=`.
- DOM hooks (`data-action`, `data-task-id`) documented in the JS module.

### Phase 3 — Staff role dashboards (maintenance/cleaning/laundry/lawn-pool)
- Primary work: remove large counts of `style="..."` attributes.
- Strategy:
  - Convert repeated inline styles into semantic classes.
  - Move block styles into `static/css/pages/<dashboard>.css`.
  - For dynamic styles (e.g. widths for progress), use data attributes + a tiny JS initializer to set widths.

**Acceptance criteria**
- Measurable reduction in `style="..."` usage.
- No UX changes; only implementation changes.
- `pytest -q` stays green.

### Phase 4 — Shared staff components cleanup
- Focus:
  - `staff/components/task_progress.html`
  - `staff/components/task_timer.html`
  - `staff/components/task_checklist.html`
- Remove remaining inline styles and enforce consistent DOM hooks.

### Phase 5 — Portal + Admin templates (optional / as needed)
- Apply the same pattern if we want consistency outside staff pages.
- Prioritize user-facing portal pages over admin tools.

## 5) How to track progress (recommended workflow)

### 5.1 Run a scan
Example commands (run from repo root):
- Find inline handlers: `rg -n -P -g'*.html' '\son[a-zA-Z]+=' aristay_backend/api/templates`
- Find inline scripts: `rg -n -P -g'*.html' '<script(?![^>]*\bsrc=)(?![^>]*\btype="module")(?![^>]*\btype="application/json")' aristay_backend/api/templates`
- Find inline styles: `rg -n -g'*.html' 'style="' aristay_backend/api/templates`

### 5.2 Validate
- `python -m pytest -q`

---

## Appendix A — Files added/introduced during this refactor stream (high level)

JS entrypoints (pages):
- aristay_backend/static/js/pages/task-detail.js
- aristay_backend/static/js/pages/dashboard.js
- aristay_backend/static/js/pages/lost-found-list.js
- aristay_backend/static/js/pages/inventory-lookup.js

JS modules (feature managers):
- aristay_backend/static/js/modules/dashboard-manager.js
- aristay_backend/static/js/modules/lost-found-manager.js
- aristay_backend/static/js/modules/inventory-lookup-manager.js

CSS pages:
- aristay_backend/static/css/pages/task-detail.css
- aristay_backend/static/css/pages/lost-found-list.css
- aristay_backend/static/css/pages/inventory-lookup.css
