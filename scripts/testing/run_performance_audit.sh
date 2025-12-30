#!/bin/bash

# Comprehensive Lighthouse Audit Script
# Handles Django server lifecycle and runs Lighthouse audits

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}======================================${NC}"
echo -e "${GREEN}Lighthouse Performance Audit${NC}"
echo -e "${GREEN}======================================${NC}"
echo ""

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname $(dirname "$SCRIPT_DIR"))"

# Activate virtual environment
echo -e "${YELLOW}🔧 Activating virtual environment...${NC}"
cd "$PROJECT_ROOT"
if [ -f ".venv/bin/activate" ]; then
    source .venv/bin/activate
else
    echo -e "${RED}❌ Virtual environment not found at .venv/${NC}"
    exit 1
fi

# Navigate to backend
cd cosmo_backend

# Start Django server
echo -e "${YELLOW}🚀 Starting Django server on port 8000...${NC}"
python manage.py runserver 8000 > /tmp/django-lighthouse.log 2>&1 &
SERVER_PID=$!

# Cleanup function
cleanup() {
    echo ""
    echo -e "${YELLOW}🛑 Stopping Django server (PID: $SERVER_PID)...${NC}"
    kill $SERVER_PID 2>/dev/null || true
    wait $SERVER_PID 2>/dev/null || true
    echo -e "${GREEN}✅ Cleanup complete${NC}"
}
trap cleanup EXIT INT TERM

# Wait for server to be ready
echo -e "${YELLOW}⏳ Waiting for server to start...${NC}"
MAX_WAIT=30
for i in $(seq 1 $MAX_WAIT); do
    if curl -s "http://localhost:8000/login/" > /dev/null 2>&1; then
        echo -e "${GREEN}✅ Server ready in ${i}s${NC}"
        break
    fi
    sleep 1
    if [ $i -eq $MAX_WAIT ]; then
        echo -e "${RED}❌ Server failed to start in ${MAX_WAIT}s${NC}"
        echo ""
        echo "Server log:"
        cat /tmp/django-lighthouse.log
        exit 1
    fi
done

echo ""
echo -e "${GREEN}🔍 Running Lighthouse audits...${NC}"
echo ""

# Create report directory
REPORT_DIR="../docs/reports/lighthouse"
mkdir -p "$REPORT_DIR"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Audit login page
echo -e "${YELLOW}📊 Auditing: Login Page${NC}"
lighthouse "http://localhost:8000/login/" \
    --output json \
    --output html \
    --output-path="${REPORT_DIR}/login_${TIMESTAMP}" \
    --chrome-flags="--headless --disable-gpu --no-sandbox" \
    --emulated-form-factor=desktop \
    --throttling-method=provided \
    2>&1 | grep -v "Waiting for DevTools" | grep -v "Evaluating" || true

echo ""
sleep 2

# Audit API documentation (Swagger UI)
echo -e "${YELLOW}📊 Auditing: API Documentation${NC}"
lighthouse "http://localhost:8000/docs/" \
    --output json \
    --output html \
    --output-path="${REPORT_DIR}/api_docs_${TIMESTAMP}" \
    --chrome-flags="--headless --disable-gpu --no-sandbox" \
    --emulated-form-factor=desktop \
    --throttling-method=provided \
    2>&1 | grep -v "Waiting for DevTools" | grep -v "Evaluating" || true

echo ""
echo -e "${GREEN}✅ Audits complete!${NC}"
echo ""
echo -e "${YELLOW}📁 Reports saved to: ${REPORT_DIR}/${NC}"
echo ""

# Parse results using Python
cd "$PROJECT_ROOT"
echo -e "${GREEN}📊 Parsing results...${NC}"
echo ""
python3 scripts/testing/parse_lighthouse_results.py
