# Django UI Refactoring Guide - Phases 5C through 5E

## Overview
This guide provides the systematic approach to complete the remaining 17 files (out of 20 total) for Phases 5C, 5D, and 5E of the Django UI refactoring project.

## ✅ Completed - Phase 5B (3 files)
- ✅ photo_upload.html → photo-upload.css + photo-upload.js
- ✅ photo_management.html → photo-management.css + photo-management.js
- ✅ photo_comparison.html → photo-comparison.css + photo-comparison.js

All inline styles, onclick handlers, and scripts have been externalized. Design system tokens applied.

## 📋 Remaining Work

### Phase 5C - Invite Code System (7 files)
4. `cosmo_backend/api/templates/invite_codes/list.html` → `invite-codes-list.css` + `invite-codes-list.js`
5. `cosmo_backend/api/templates/invite_codes/create.html` → `invite-codes-create.css` + `invite-codes-create.js`
6. `cosmo_backend/api/templates/admin/invite_code_detail.html` → `admin-invite-code-detail.css` + `admin-invite-code-detail.js`
7. `cosmo_backend/api/templates/admin/invite_code_list.html` → `admin-invite-code-list.css` + `admin-invite-code-list.js`
8. `cosmo_backend/api/templates/admin/create_invite_code.html` → `admin-create-invite-code.css` + `admin-create-invite-code.js`
9. `cosmo_backend/api/templates/admin/edit_invite_code.html` → `admin-edit-invite-code.css` + `admin-edit-invite-code.js`
10. `cosmo_backend/api/templates/admin/invite_codes.html` → `admin-invite-codes.css` + `admin-invite-codes.js`

### Phase 5D - Admin Access Control (3 files)
11. `cosmo_backend/api/templates/admin/conflict_resolution.html` → `admin-conflict-resolution.css` + `admin-conflict-resolution.js`
12. `cosmo_backend/api/templates/admin/permission_management.html` → `admin-permission-management.css` + `admin-permission-management.js`
13. `cosmo_backend/api/templates/admin/property_approval.html` → `admin-property-approval.css` + `admin-property-approval.js`

### Phase 5E - Communication & Remaining (7 files)
14. `cosmo_backend/api/templates/chat/chatbox.html` → `chat-chatbox.css` + `chat-chatbox.js`
15. `cosmo_backend/api/templates/calendar/calendar_view.html` → `calendar-view.css` + `calendar-view.js`
16. `cosmo_backend/api/templates/manager_admin/base_site.html` → `manager-admin-base-site.css` + `manager-admin-base-site.js`
17. `cosmo_backend/api/templates/admin/excel_import.html` → `admin-excel-import.css` + `admin-excel-import.js`
18. `cosmo_backend/api/templates/auth/unified_login.html` → `auth-unified-login.css` (no JS)
19. `cosmo_backend/api/templates/admin/notification_management.html` → `admin-notification-management.css` (no JS)
20. `cosmo_backend/api/templates/admin/digest_management.html` → `admin-digest-management.css` (no JS)

## 🔧 Refactoring Steps for Each File

Follow these steps for EACH template file:

### Step 1: Read the Template
```bash
# Read the template to understand structure
cat cosmo_backend/api/templates/[path]/[filename].html
```

### Step 2: Create CSS File

**File Location:** `cosmo_backend/static/css/pages/[filename].css`

**Pattern:**
```css
/* [Page Name] Page Styles */

[data-visibility="hidden"] {
    display: none !important;
}

/* Extract all styles from <style> block */
/* Replace all inline style="" attributes with classes */

/* Convert all hardcoded values to design tokens: */
/* Colors: #6366f1 → var(--color-primary) */
/* Spacing: 20px → var(--space-5, 20px) */
/* Font sizes: 14px → var(--font-size-sm, 14px) */
/* Border radius: 8px → var(--radius-md, 8px) */

/* Add responsive breakpoints */
@media (max-width: 768px) {
    /* Mobile styles */
}
```

**Design System Tokens Reference:**

```css
/* Colors */
--color-primary: #6366f1
--color-success: #10b981
--color-danger: #ef4444
--color-warning: #f59e0b
--color-gray-50: #f9fafb
--color-gray-100: #f3f4f6
--color-gray-200: #e5e7eb
--color-gray-300: #d1d5db
--color-gray-500: #6b7280
--color-gray-600: #4b5563
--color-gray-700: #374151
--color-gray-900: #1f2937

/* Spacing */
--space-1: 0.25rem  /* 4px */
--space-2: 0.5rem   /* 8px */
--space-3: 0.75rem  /* 12px */
--space-4: 1rem     /* 16px */
--space-5: 1.25rem  /* 20px */
--space-6: 1.5rem   /* 24px */
--space-8: 2rem     /* 32px */

/* Typography */
--font-size-xs: 0.75rem   /* 12px */
--font-size-sm: 0.875rem  /* 14px */
--font-size-base: 1rem    /* 16px */
--font-size-lg: 1.125rem  /* 18px */
--font-size-xl: 1.25rem   /* 20px */
--font-size-2xl: 1.5rem   /* 24px */

/* Border Radius */
--radius-sm: 4px
--radius-md: 8px
--radius-lg: 12px

/* Shadows */
box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
```

### Step 3: Create JS File (if needed)

**File Location:** `cosmo_backend/static/js/pages/[filename].js`

**Pattern:**
```javascript
/**
 * [Page Name] Page
 * [Brief description of functionality]
 */

// Extract all <script> content
// Convert all global functions to scoped functions
// Replace onclick handlers with event listeners

class [PageName] {
    constructor() {
        this.initializeElements();
        this.attachEventListeners();
    }

    initializeElements() {
        // Query all needed DOM elements
        this.element = document.getElementById('element-id');
    }

    attachEventListeners() {
        // Replace onclick with event listeners
        this.element.addEventListener('click', () => {
            this.handleClick();
        });

        // Use event delegation for dynamic content
        document.addEventListener('click', (e) => {
            if (e.target.matches('[data-action="action-name"]')) {
                this.handleAction(e.target);
            }
        });
    }

    handleClick() {
        // Action logic
    }
}

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
    new [PageName]();
});
```

### Step 4: Update Template

**Find and Replace:**

1. **Style Block:**
```html
<!-- OLD -->
{% block extra_css %}
<style>
    .class-name { ... }
</style>
{% endblock %}

<!-- NEW -->
{% block extra_css %}
<link rel="stylesheet" href="{% static 'css/pages/[filename].css' %}">
{% endblock %}
```

2. **Inline Styles:**
```html
<!-- OLD -->
<div style="display: flex; gap: 20px;">

<!-- NEW -->
<div class="flex-container">
```

Add to CSS:
```css
.flex-container {
    display: flex;
    gap: var(--space-5, 20px);
}
```

3. **Inline Handlers:**
```html
<!-- OLD -->
<button onclick="handleClick()">Click</button>

<!-- NEW -->
<button data-action="handle-click">Click</button>
```

In JS:
```javascript
document.querySelectorAll('[data-action="handle-click"]').forEach(btn => {
    btn.addEventListener('click', handleClick);
});
```

4. **Display Control:**
```html
<!-- OLD -->
<div id="modal" style="display: none;">

<!-- NEW -->
<div id="modal" data-visibility="hidden">
```

In JS:
```javascript
// Show
element.removeAttribute('data-visibility');
element.style.display = 'block';

// Hide
element.setAttribute('data-visibility', 'hidden');
element.style.display = 'none';
```

5. **Script Block:**
```html
<!-- OLD -->
<script>
function handleClick() { ... }
// ... rest of script
</script>
{% endblock %}

<!-- NEW -->
<script>
// Only keep template variables
const TEMPLATE_DATA = {{ data|safe }};
</script>
<script src="{% static 'js/pages/[filename].js' %}"></script>
{% endblock %}
```

### Step 5: Verification

For each completed file:

```bash
# 1. Count inline styles (should be 0 or only dynamic ones like width:50%)
grep -n 'style="' cosmo_backend/api/templates/[path]/[filename].html

# 2. Count inline handlers (should be 0)
grep -nP '\son[a-zA-Z]+=' cosmo_backend/api/templates/[path]/[filename].html

# 3. Verify CSS file exists
ls -lh cosmo_backend/static/css/pages/[filename].css

# 4. Verify JS file exists (if applicable)
ls -lh cosmo_backend/static/js/pages/[filename].js

# 5. Check template loads CSS
grep "{% static 'css/pages/" cosmo_backend/api/templates/[path]/[filename].html

# 6. Check template loads JS (if applicable)
grep "{% static 'js/pages/" cosmo_backend/api/templates/[path]/[filename].html
```

## 📝 Common Patterns

### Modal Patterns
```html
<!-- Template -->
<div id="myModal" class="modal" data-visibility="hidden">
    <div class="modal-backdrop" data-action="close-modal"></div>
    <div class="modal-content">
        <button class="modal-close" data-action="close-modal">&times;</button>
        <!-- content -->
    </div>
</div>
```

```javascript
// JS
function openModal() {
    const modal = document.getElementById('myModal');
    modal.removeAttribute('data-visibility');
    modal.style.display = 'flex';
    document.body.style.overflow = 'hidden';
}

function closeModal() {
    const modal = document.getElementById('myModal');
    modal.setAttribute('data-visibility', 'hidden');
    modal.style.display = 'none';
    document.body.style.overflow = 'auto';
}

document.querySelectorAll('[data-action="close-modal"]').forEach(btn => {
    btn.addEventListener('click', closeModal);
});
```

### Form Submission Patterns
```html
<!-- Template -->
<form id="myForm" data-action="submit-form">
    <input type="text" name="field">
    <button type="submit" class="btn btn-primary">Submit</button>
</form>
```

```javascript
// JS
document.getElementById('myForm').addEventListener('submit', async function(e) {
    e.preventDefault();

    const formData = new FormData(this);
    const csrfToken = document.querySelector('[name=csrfmiddlewaretoken]')?.value;

    try {
        const response = await fetch(this.action, {
            method: 'POST',
            body: formData,
            headers: {
                'X-CSRFToken': csrfToken
            }
        });

        if (response.ok) {
            // Handle success
        }
    } catch (error) {
        console.error('Error:', error);
    }
});
```

### Dynamic Content Patterns
```html
<!-- Template -->
<div id="content-container">
    <!-- Dynamically loaded content -->
</div>
```

```javascript
// JS - Use event delegation
document.getElementById('content-container').addEventListener('click', function(e) {
    // Approve button
    if (e.target.matches('[data-action="approve"]')) {
        const id = e.target.dataset.id;
        handleApprove(id);
    }

    // Delete button
    if (e.target.matches('[data-action="delete"]')) {
        const id = e.target.dataset.id;
        handleDelete(id);
    }
});
```

## 🎯 Priority Order

Recommended completion order:

1. **Phase 5C (Days 1-2):** Invite Code templates (7 files) - Similar structure, can batch process
2. **Phase 5D (Day 3):** Admin Access Control (3 files) - Complex interactions
3. **Phase 5E (Days 4-5):** Remaining templates (7 files) - Mixed complexity

## ✅ Success Criteria

For the project to be complete:

- [ ] All 20 templates refactored
- [ ] 0 inline `style=""` attributes (except truly dynamic values)
- [ ] 0 inline `onclick`, `onchange`, etc. handlers
- [ ] All `<style>` blocks moved to external CSS files
- [ ] All `<script>` blocks moved to external JS files
- [ ] All CSS uses design system tokens
- [ ] All JS uses event delegation
- [ ] All files follow consistent naming convention
- [ ] All templates load with `{% static 'css/pages/[name].css' %}`
- [ ] All JS files initialize with DOMContentLoaded

## 📊 Progress Tracking

```
Phase 5B (Photo Management):     3/3  ✅ 100% Complete
Phase 5C (Invite Codes):         0/7  ⏳ Pending
Phase 5D (Admin Access):         0/3  ⏳ Pending
Phase 5E (Communication):        0/7  ⏳ Pending
----------------------------------------------
Total:                           3/20 ✅ 15% Complete
```

## 🚀 Quick Start Commands

```bash
# Navigate to project
cd /Users/duylam1407/Workspace/SJSU/cosmo_app

# Create CSS file
touch cosmo_backend/static/css/pages/[filename].css

# Create JS file
touch cosmo_backend/static/js/pages/[filename].js

# Edit template
code cosmo_backend/api/templates/[path]/[filename].html

# Verify no inline styles
grep -c 'style="' cosmo_backend/api/templates/[path]/[filename].html

# Verify no inline handlers
grep -cP '\son[a-zA-Z]+=' cosmo_backend/api/templates/[path]/[filename].html
```

## 📚 Reference Files

Use these completed files as reference:
- `cosmo_backend/static/css/pages/photo-upload.css`
- `cosmo_backend/static/js/pages/photo-upload.js`
- `cosmo_backend/api/templates/photo_upload.html`

These demonstrate the complete refactoring pattern.

---

**Last Updated:** December 18, 2024
**Phase 5B Status:** ✅ Complete (3/3 files)
**Overall Progress:** 15% (3/20 files)
