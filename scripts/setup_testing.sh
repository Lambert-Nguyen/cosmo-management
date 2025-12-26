#!/bin/bash

# Phase 4 Testing Setup Script
# Sets up the testing environment and runs baseline tests

set -e

echo "🚀 Phase 4: Testing Infrastructure Setup"
echo "========================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Step 1: Check Node.js installation
echo "📦 Step 1: Checking Node.js installation..."
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js is not installed. Please install Node.js 18+ first.${NC}"
    exit 1
fi
NODE_VERSION=$(node --version)
echo -e "${GREEN}✅ Node.js ${NODE_VERSION} detected${NC}"
echo ""

# Step 2: Install npm dependencies
echo "📦 Step 2: Installing npm dependencies..."
npm install
echo -e "${GREEN}✅ Dependencies installed${NC}"
echo ""

# Step 3: Install Playwright browsers
echo "🌐 Step 3: Installing Playwright browsers..."
echo "   This may take a few minutes..."
npx playwright install chromium firefox webkit
echo -e "${GREEN}✅ Browsers installed${NC}"
echo ""

# Step 4: Verify Django is running or start it
echo "🐍 Step 4: Checking Django server..."
if curl -s http://127.0.0.1:8000 > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Django server is running on port 8000${NC}"
else
    echo -e "${YELLOW}⚠️  Django server is not running${NC}"
    echo "   Please start it in another terminal:"
    echo "   cd aristay_backend && python manage.py runserver 8000"
    echo ""
fi

# Step 5: Run ESLint check
echo "🔍 Step 5: Running ESLint check..."
npm run lint || echo -e "${YELLOW}⚠️  Some linting issues found (non-blocking)${NC}"
echo ""

# Step 6: Run unit tests
echo "🧪 Step 6: Running unit tests..."
npm run test -- --passWithNoTests || echo -e "${YELLOW}⚠️  Some unit tests failed${NC}"
echo ""

# Step 7: Display next steps
echo ""
echo "✨ Setup Complete!"
echo "=================="
echo ""
echo "Next steps:"
echo "1. Start Django if not running: cd aristay_backend && python manage.py runserver"
echo "2. Run E2E tests: npm run test:e2e"
echo "3. Run E2E tests with UI: npm run test:e2e:ui"
echo "4. Run all tests: npm run test:all"
echo ""
echo "📚 Documentation:"
echo "   - Test guide: docs/testing/TESTING_GUIDE.md"
echo "   - Phase 4 progress: docs/reports/PHASE_4_PROGRESS.md"
echo ""
