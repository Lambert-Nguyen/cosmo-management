# Django UI Refactor — Status & Plan (2025-12-14)

**Date**: December 14, 2025  
**Scope**: Django templates + static assets refactor (primary focus: Staff UI), removing inline JS/event handlers and inline CSS while keeping the test suite green.

## 1) What’s been done so far (review)

### 1.1 Goal (recap)
- Eliminate inline JavaScript (`<script>…</script>` blocks and inline event handlers like `onclick=`) from staff templates.
- Move behavior to ES modules under `aristay_backend/static/js/pages/*` (entrypoints) and `aristay_backend/static/js/modules/*` (feature managers).
- Extract large inline styles / page CSS into `aristay_backend/static/css/pages/*` and keep shared styling in existing design-system CSS.
- Keep a stable DOM contract via class hooks / `data-*` attributes.
- Maintain **green tests** as the non‑negotiable quality gate.

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
- Extract portal base inline assets (moved to `static/css/pages/portal-base.css` + `static/js/pages/portal-base.js`)
- Extract portal home inline CSS (moved to `static/css/pages/portal-home.css`)
- Tests updated where necessary to assert extracted CSS via linked stylesheets (instead of brittle inline-style assertions)

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

### 3.1 Staff templates (highest priority)

Note: `<script src="...">` and `<script type="module" src="...">` includes are expected and not considered “inline JS”.

**Status (as of 2025-12-14)**
- Staff templates have been cleaned of inline `<style>` blocks, inline `style="..."` attributes, inline `<script>` blocks, and inline `on*=` event handlers.
- Progress widths now use `data-progress` + a JS initializer; modal visibility uses `.hidden` class toggling.

### 3.2 Layout templates (high leverage)
These affect many pages and should be addressed early.
- aristay_backend/api/templates/layouts/staff_layout.html (inline `<style>`/`<script>` detected)
- aristay_backend/api/templates/layouts/public_layout.html (inline `<style>`/`<script>` detected)
- aristay_backend/api/templates/layouts/portal_layout.html (inline `<style>`/`<script>` detected)
- aristay_backend/api/templates/layouts/admin_layout.html (inline `<style>`/`<script>` detected)

### 3.3 Portal templates (medium priority, user-facing)
**Inline `style="..."` is common**
- aristay_backend/api/templates/portal/home.html (59) ✅ completed (extracted to `static/css/pages/portal-home.css`)
- aristay_backend/api/templates/portal/notification_settings.html (38) ✅ completed (extracted to `static/css/pages/portal-notification-settings.css` + `static/js/pages/portal-notification-settings.js`)
- aristay_backend/api/templates/portal/digest_settings.html (37) ✅ completed (extracted to `static/css/pages/portal-digest-settings.css` + `static/js/pages/portal-digest-settings.js`)
- aristay_backend/api/templates/portal/task_detail.html (35)
- aristay_backend/api/templates/portal/base.html (12) ✅ completed (extracted to `static/css/pages/portal-base.css` + `static/js/pages/portal-base.js`)
- aristay_backend/api/templates/portal/calendar.html (11)
- aristay_backend/api/templates/portal/booking_detail.html (9)
- aristay_backend/api/templates/portal/photo_management.html (8)
- aristay_backend/api/templates/portal/property_detail.html (7)
- aristay_backend/api/templates/portal/property_list.html (5)

**Inline onclick handlers**
- aristay_backend/api/templates/portal/calendar.html (7)
- aristay_backend/api/templates/portal/base.html (3) ✅ completed
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

Next high-leverage Portal targets (in order):
1) `aristay_backend/api/templates/portal/task_detail.html`
2) `aristay_backend/api/templates/portal/calendar.html`

Recommended plan for the remaining files (grouped into clean, test-validated commits):

Portal (user-facing)
- portal/notification_settings.html ✅ completed (CSS: `static/css/pages/portal-notification-settings.css`, JS: `static/js/pages/portal-notification-settings.js`).
- portal/digest_settings.html ✅ completed (CSS: `static/css/pages/portal-digest-settings.css`, JS: `static/js/pages/portal-digest-settings.js`).
- portal/task_detail.html → mirror Staff Task Detail patterns where applicable; extract CSS + replace inline handlers with `data-action`; isolate behavior in a page module.
- portal/calendar.html → remove inline `onclick` (7) first; migrate dynamic styling to classes/data attributes + a page module.
- portal/booking_detail.html, portal/photo_management.html, portal/property_detail.html, portal/property_list.html → CSS extraction + handler delegation (as needed), one file per commit if large.

Layouts (high leverage)
- layouts/portal_layout.html → move any inline `<style>/<script>` to `static/css/pages/portal-layout.css` and `static/js/pages/portal-layout.js` (or a shared module if used cross-portal).
- layouts/public_layout.html → same pattern; keep DOM hooks stable.
- layouts/admin_layout.html → same pattern; be conservative (admin templates can be brittle).
- layouts/staff_layout.html → only if scans still show inline content; otherwise leave as-is.

Admin / manager templates (lower priority unless actively used)
- admin/enhanced_excel_import.html → CSS extraction first; if JS exists, move to a page module.
- admin/charts_dashboard.html + manager_admin/index.html → remove inline `onclick` (13/12) via `data-action` delegation; extract CSS blocks.
- admin/base_site.html, admin/system_recovery.html, admin/system_metrics.html, admin/file_cleanup.html, admin/conflict_resolution.html, photo_upload.html → CSS extraction + handler delegation, one-at-a-time.

Misc pages
- chat/chatbox.html, calendar/calendar_view.html, photo_management.html, photo_comparison.html → extract CSS and replace inline handlers.

Quality gate for every commit:
- Run `pytest -q` after each chunk; no behavior change; warnings OK.

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

Recent CSS page additions:
- aristay_backend/static/css/pages/laundry-dashboard.css
- aristay_backend/static/css/pages/lawn-pool-dashboard.css
- aristay_backend/static/css/pages/checklist-templates.css
