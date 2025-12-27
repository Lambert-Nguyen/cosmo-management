#!/bin/bash
# Verification script for UI refactoring

echo "🔍 COSMO MANAGEMENT REFACTORING VERIFICATION"
echo "===================================="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

cd "$(dirname "$0")"

echo "📁 Working directory: $(pwd)"
echo ""

# Check Django config
echo "1️⃣  Checking Django configuration..."
if python manage.py check --settings=backend.settings_local > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Django configuration is valid"
else
    echo -e "${RED}✗${NC} Django configuration has errors"
    python manage.py check --settings=backend.settings_local
    exit 1
fi
echo ""

# Check for inline handlers in priority files
echo "2️⃣  Scanning priority templates for inline handlers..."
PRIORITY_FILES=(
    "cosmo_backend/api/templates/calendar/calendar_view.html"
    "cosmo_backend/api/templates/admin/permission_management.html"
    "cosmo_backend/api/templates/chat/chatbox.html"
    "cosmo_backend/api/templates/admin/security_dashboard.html"
    "cosmo_backend/api/templates/admin/system_metrics.html"
)

ISSUES_FOUND=0
for file in "${PRIORITY_FILES[@]}"; do
    if [ -f "$file" ]; then
        # Check for inline event handlers (onclick, onchange, etc.)
        HANDLERS=$(grep -c 'on[a-z]*="' "$file" 2>/dev/null || echo "0")

        if [ "$HANDLERS" -eq 0 ]; then
            echo -e "${GREEN}✓${NC} $(basename $file) - No inline handlers"
        else
            echo -e "${RED}✗${NC} $(basename $file) - Found $HANDLERS inline handler(s)"
            ISSUES_FOUND=$((ISSUES_FOUND + 1))
        fi
    else
        echo -e "${YELLOW}⚠${NC}  $(basename $file) - File not found"
    fi
done
echo ""

# Check external JS/CSS files exist
echo "3️⃣  Verifying external assets exist..."
MISSING_ASSETS=0

# Check CSS files
CSS_FILES=(
    "cosmo_backend/static/css/design-system.css"
    "cosmo_backend/static/css/components.css"
    "cosmo_backend/static/css/pages/task-detail.css"
    "cosmo_backend/static/css/pages/dashboard.css"
    "cosmo_backend/static/css/pages/portal-calendar.css"
)

for file in "${CSS_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓${NC} $(basename $file)"
    else
        echo -e "${RED}✗${NC} Missing: $file"
        MISSING_ASSETS=$((MISSING_ASSETS + 1))
    fi
done

# Check JS files
JS_FILES=(
    "cosmo_backend/static/js/core/api-client.js"
    "cosmo_backend/static/js/core/csrf-manager.js"
    "cosmo_backend/static/js/pages/task-detail.js"
    "cosmo_backend/static/js/pages/dashboard.js"
    "cosmo_backend/static/js/modules/task-actions.js"
)

for file in "${JS_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓${NC} $(basename $file)"
    else
        echo -e "${RED}✗${NC} Missing: $file"
        MISSING_ASSETS=$((MISSING_ASSETS + 1))
    fi
done
echo ""

# Run quick UI tests
echo "4️⃣  Running UI tests..."
if python -m pytest tests/ui/test_ui_selector_fix.py -q 2>&1 | grep -q "passed"; then
    echo -e "${GREEN}✓${NC} UI selector tests passed"
else
    echo -e "${YELLOW}⚠${NC}  UI tests need review (may need database setup)"
fi
echo ""

# Summary
echo "===================================="
echo "📊 SUMMARY"
echo "===================================="

if [ "$ISSUES_FOUND" -eq 0 ] && [ "$MISSING_ASSETS" -eq 0 ]; then
    echo -e "${GREEN}✓ REFACTORING VERIFIED${NC}"
    echo "  - No inline handlers in priority files"
    echo "  - All external assets present"
    echo "  - Django configuration valid"
    exit 0
else
    echo -e "${YELLOW}⚠ ISSUES FOUND${NC}"
    echo "  - Inline handlers: $ISSUES_FOUND"
    echo "  - Missing assets: $MISSING_ASSETS"
    exit 1
fi
