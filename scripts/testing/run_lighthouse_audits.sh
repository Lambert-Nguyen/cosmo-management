#!/usr/bin/env bash

# Lighthouse Performance Audit Script for Django UI
# Runs audits on key pages and generates comprehensive reports

set -e

# Require bash 4+ for associative arrays
if [ "${BASH_VERSINFO[0]}" -lt 4 ]; then
    echo "Error: This script requires bash 4 or higher"
    echo "Current bash version: ${BASH_VERSION}"
    echo "Install with: brew install bash"
    exit 1
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
BASE_URL="http://localhost:8000"
REPORT_DIR="docs/reports/lighthouse"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Pages to audit
declare -a PAGES=(
    "/api/staff/login/:Login Page"
    "/api/staff/dashboard/:Dashboard"
    "/api/staff/tasks/:Task List"
)

# Lighthouse CLI options
LIGHTHOUSE_OPTS=(
    "--chrome-flags=\"--headless --disable-gpu --no-sandbox\""
    "--output=json"
    "--output=html"
    "--quiet"
    "--emulated-form-factor=desktop"
)

echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}Lighthouse Performance Audit${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""

# Check if virtual environment is active
if [ -z "$VIRTUAL_ENV" ]; then
    echo -e "${YELLOW}⚠️  Virtual environment not active. Activating...${NC}"
    if [ -f "../.venv/bin/activate" ]; then
        source ../.venv/bin/activate
    elif [ -f ".venv/bin/activate" ]; then
        source .venv/bin/activate
    else
        echo -e "${RED}❌ Virtual environment not found!${NC}"
        exit 1
    fi
fi

# Navigate to Django project
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname $(dirname "$SCRIPT_DIR"))"
cd "$PROJECT_ROOT/aristay_backend"

echo -e "${YELLOW}📂 Working directory: $(pwd)${NC}"
echo ""

# Create report directory
mkdir -p "../$REPORT_DIR"

# Start Django server
echo -e "${YELLOW}🚀 Starting Django server...${NC}"
python manage.py runserver 8000 > /tmp/django-lighthouse-server.log 2>&1 &
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
echo -e "${YELLOW}⏳ Waiting for server to be ready...${NC}"
MAX_WAIT=30
COUNTER=0
until curl -s "$BASE_URL/api/staff/login/" > /dev/null 2>&1; do
    sleep 1
    COUNTER=$((COUNTER + 1))
    if [ $COUNTER -gt $MAX_WAIT ]; then
        echo -e "${RED}❌ Server failed to start after ${MAX_WAIT}s${NC}"
        exit 1
    fi
done
echo -e "${GREEN}✅ Server ready in ${COUNTER}s${NC}"
echo ""

# Initialize summary data
declare -A SCORES
TOTAL_PAGES=0
PASSED_PAGES=0

# Run Lighthouse audits
echo -e "${GREEN}🔍 Running Lighthouse audits...${NC}"
echo ""

for PAGE_INFO in "${PAGES[@]}"; do
    IFS=':' read -r PAGE_PATH PAGE_NAME <<< "$PAGE_INFO"
    FULL_URL="${BASE_URL}${PAGE_PATH}"
    SAFE_NAME=$(echo "$PAGE_NAME" | tr ' ' '_' | tr '[:upper:]' '[:lower:]')
    REPORT_PATH="../${REPORT_DIR}/${SAFE_NAME}_${TIMESTAMP}"
    
    echo -e "${YELLOW}📊 Auditing: ${PAGE_NAME}${NC}"
    echo -e "   URL: ${FULL_URL}"
    
    # Run Lighthouse
    lighthouse "$FULL_URL" \
        --output json \
        --output html \
        --output-path "$REPORT_PATH" \
        --chrome-flags="--headless --disable-gpu --no-sandbox" \
        --quiet \
        --emulated-form-factor=desktop \
        --throttling-method=provided \
        2>&1 | grep -v "Waiting for DevTools" || true
    
    # Parse scores from JSON report
    JSON_REPORT="${REPORT_PATH}.report.json"
    if [ -f "$JSON_REPORT" ]; then
        PERF=$(jq -r '.categories.performance.score // 0' "$JSON_REPORT")
        PERF_PCT=$(echo "$PERF * 100" | bc | cut -d. -f1)
        
        ACCESS=$(jq -r '.categories.accessibility.score // 0' "$JSON_REPORT")
        ACCESS_PCT=$(echo "$ACCESS * 100" | bc | cut -d. -f1)
        
        BP=$(jq -r '.categories["best-practices"].score // 0' "$JSON_REPORT")
        BP_PCT=$(echo "$BP * 100" | bc | cut -d. -f1)
        
        SEO=$(jq -r '.categories.seo.score // 0' "$JSON_REPORT")
        SEO_PCT=$(echo "$SEO * 100" | bc | cut -d. -f1)
        
        # Store scores
        SCORES["${SAFE_NAME}_perf"]=$PERF_PCT
        SCORES["${SAFE_NAME}_access"]=$ACCESS_PCT
        SCORES["${SAFE_NAME}_bp"]=$BP_PCT
        SCORES["${SAFE_NAME}_seo"]=$SEO_PCT
        
        # Display scores with color coding
        echo ""
        echo "   📈 Results:"
        
        # Performance
        if [ "$PERF_PCT" -ge 90 ]; then
            echo -e "      Performance:    ${GREEN}${PERF_PCT}${NC} ✅"
        elif [ "$PERF_PCT" -ge 50 ]; then
            echo -e "      Performance:    ${YELLOW}${PERF_PCT}${NC} ⚠️"
        else
            echo -e "      Performance:    ${RED}${PERF_PCT}${NC} ❌"
        fi
        
        # Accessibility
        if [ "$ACCESS_PCT" -ge 95 ]; then
            echo -e "      Accessibility:  ${GREEN}${ACCESS_PCT}${NC} ✅"
        elif [ "$ACCESS_PCT" -ge 80 ]; then
            echo -e "      Accessibility:  ${YELLOW}${ACCESS_PCT}${NC} ⚠️"
        else
            echo -e "      Accessibility:  ${RED}${ACCESS_PCT}${NC} ❌"
        fi
        
        # Best Practices
        if [ "$BP_PCT" -ge 90 ]; then
            echo -e "      Best Practices: ${GREEN}${BP_PCT}${NC} ✅"
        elif [ "$BP_PCT" -ge 80 ]; then
            echo -e "      Best Practices: ${YELLOW}${BP_PCT}${NC} ⚠️"
        else
            echo -e "      Best Practices: ${RED}${BP_PCT}${NC} ❌"
        fi
        
        # SEO
        if [ "$SEO_PCT" -ge 90 ]; then
            echo -e "      SEO:            ${GREEN}${SEO_PCT}${NC} ✅"
        elif [ "$SEO_PCT" -ge 80 ]; then
            echo -e "      SEO:            ${YELLOW}${SEO_PCT}${NC} ⚠️"
        else
            echo -e "      SEO:            ${RED}${SEO_PCT}${NC} ❌"
        fi
        
        echo ""
        echo -e "   📄 HTML Report: ${REPORT_PATH}.report.html"
        echo ""
        
        TOTAL_PAGES=$((TOTAL_PAGES + 1))
        
        # Check if page meets targets (Perf >= 90, Access >= 95)
        if [ "$PERF_PCT" -ge 90 ] && [ "$ACCESS_PCT" -ge 95 ]; then
            PASSED_PAGES=$((PASSED_PAGES + 1))
        fi
    else
        echo -e "   ${RED}❌ Failed to generate report${NC}"
        echo ""
    fi
    
    sleep 2  # Brief pause between audits
done

# Generate summary report
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}Audit Summary${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo -e "📊 Pages Audited: ${TOTAL_PAGES}"
echo -e "✅ Pages Meeting Targets: ${PASSED_PAGES}/${TOTAL_PAGES}"
echo ""

# Calculate averages
if [ $TOTAL_PAGES -gt 0 ]; then
    TOTAL_PERF=0
    TOTAL_ACCESS=0
    TOTAL_BP=0
    TOTAL_SEO=0
    
    for PAGE_INFO in "${PAGES[@]}"; do
        IFS=':' read -r PAGE_PATH PAGE_NAME <<< "$PAGE_INFO"
        SAFE_NAME=$(echo "$PAGE_NAME" | tr ' ' '_' | tr '[:upper:]' '[:lower:]')
        
        TOTAL_PERF=$((TOTAL_PERF + ${SCORES["${SAFE_NAME}_perf"]}))
        TOTAL_ACCESS=$((TOTAL_ACCESS + ${SCORES["${SAFE_NAME}_access"]}))
        TOTAL_BP=$((TOTAL_BP + ${SCORES["${SAFE_NAME}_bp"]}))
        TOTAL_SEO=$((TOTAL_SEO + ${SCORES["${SAFE_NAME}_seo"]}))
    done
    
    AVG_PERF=$((TOTAL_PERF / TOTAL_PAGES))
    AVG_ACCESS=$((TOTAL_ACCESS / TOTAL_PAGES))
    AVG_BP=$((TOTAL_BP / TOTAL_PAGES))
    AVG_SEO=$((TOTAL_SEO / TOTAL_PAGES))
    
    echo -e "📈 Average Scores:"
    
    if [ "$AVG_PERF" -ge 90 ]; then
        echo -e "   Performance:    ${GREEN}${AVG_PERF}${NC} ✅ (Target: ≥90)"
    else
        echo -e "   Performance:    ${YELLOW}${AVG_PERF}${NC} ⚠️  (Target: ≥90)"
    fi
    
    if [ "$AVG_ACCESS" -ge 95 ]; then
        echo -e "   Accessibility:  ${GREEN}${AVG_ACCESS}${NC} ✅ (Target: ≥95)"
    else
        echo -e "   Accessibility:  ${YELLOW}${AVG_ACCESS}${NC} ⚠️  (Target: ≥95)"
    fi
    
    echo -e "   Best Practices: ${AVG_BP}"
    echo -e "   SEO:            ${AVG_SEO}"
    echo ""
fi

echo -e "📁 Reports saved to: ${REPORT_DIR}/"
echo ""

# Final status
if [ "$PASSED_PAGES" -eq "$TOTAL_PAGES" ]; then
    echo -e "${GREEN}✅ All pages meet performance and accessibility targets!${NC}"
    exit 0
else
    echo -e "${YELLOW}⚠️  Some pages need optimization${NC}"
    exit 1
fi
