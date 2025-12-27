#!/bin/bash

# Simplified Lighthouse Performance Audit Script
# Compatible with macOS default bash

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

BASE_URL="http://localhost:8000"
REPORT_DIR="docs/reports/lighthouse"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}Lighthouse Performance Audit${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""

# Activate virtual environment
if [ -z "$VIRTUAL_ENV" ]; then
    echo -e "${YELLOW}⚠️  Activating virtual environment...${NC}"
    if [ -f ".venv/bin/activate" ]; then
        source .venv/bin/activate
    else
        echo -e "${RED}❌ Virtual environment not found!${NC}"
        exit 1
    fi
fi

# Navigate to backend
cd cosmo_backend
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
    echo -e "${YELLOW}🛑 Stopping Django server...${NC}"
    kill $SERVER_PID 2>/dev/null || true
    wait $SERVER_PID 2>/dev/null || true
    echo -e "${GREEN}✅ Cleanup complete${NC}"
}
trap cleanup EXIT INT TERM

# Wait for server
echo -e "${YELLOW}⏳ Waiting for server...${NC}"
MAX_WAIT=30
for i in $(seq 1 $MAX_WAIT); do
    if curl -s "$BASE_URL/api/staff/login/" > /dev/null 2>&1; then
        echo -e "${GREEN}✅ Server ready in ${i}s${NC}"
        break
    fi
    sleep 1
    if [ $i -eq $MAX_WAIT ]; then
        echo -e "${RED}❌ Server timeout${NC}"
        exit 1
    fi
done
echo ""

# Function to audit a page
audit_page() {
    local url=$1
    local name=$2
    local safe_name=$(echo "$name" | tr ' ' '_' | tr '[:upper:]' '[:lower:]')
    local report_path="../${REPORT_DIR}/${safe_name}_${TIMESTAMP}"
    
    echo -e "${YELLOW}📊 Auditing: ${name}${NC}"
    echo "   URL: $url"
    
    # Run Lighthouse
    lighthouse "$url" \
        --output json \
        --output html \
        --output-path "$report_path" \
        --chrome-flags="--headless --disable-gpu --no-sandbox" \
        --quiet \
        --emulated-form-factor=desktop \
        2>&1 | grep -v "Waiting for DevTools" || true
    
    # Parse scores
    local json_file="${report_path}.report.json"
    if [ -f "$json_file" ]; then
        local perf=$(python3 -c "import json; print(int(json.load(open('$json_file'))['categories']['performance']['score'] * 100))")
        local access=$(python3 -c "import json; print(int(json.load(open('$json_file'))['categories']['accessibility']['score'] * 100))")
        local bp=$(python3 -c "import json; print(int(json.load(open('$json_file'))['categories']['best-practices']['score'] * 100))")
        local seo=$(python3 -c "import json; print(int(json.load(open('$json_file'))['categories']['seo']['score'] * 100))")
        
        echo ""
        echo "   📈 Results:"
        
        # Performance
        if [ "$perf" -ge 90 ]; then
            echo -e "      Performance:    ${GREEN}${perf}${NC} ✅"
        elif [ "$perf" -ge 50 ]; then
            echo -e "      Performance:    ${YELLOW}${perf}${NC} ⚠️"
        else
            echo -e "      Performance:    ${RED}${perf}${NC} ❌"
        fi
        
        # Accessibility
        if [ "$access" -ge 95 ]; then
            echo -e "      Accessibility:  ${GREEN}${access}${NC} ✅"
        elif [ "$access" -ge 80 ]; then
            echo -e "      Accessibility:  ${YELLOW}${access}${NC} ⚠️"
        else
            echo -e "      Accessibility:  ${RED}${access}${NC} ❌"
        fi
        
        # Best Practices
        if [ "$bp" -ge 90 ]; then
            echo -e "      Best Practices: ${GREEN}${bp}${NC} ✅"
        else
            echo -e "      Best Practices: ${YELLOW}${bp}${NC} ⚠️"
        fi
        
        # SEO
        if [ "$seo" -ge 90 ]; then
            echo -e "      SEO:            ${GREEN}${seo}${NC} ✅"
        else
            echo -e "      SEO:            ${YELLOW}${seo}${NC} ⚠️"
        fi
        
        echo ""
        echo -e "   📄 Report: ${report_path}.report.html"
        echo ""
        
        # Return scores for summary (space-separated)
        echo "$perf $access $bp $seo"
    else
        echo -e "   ${RED}❌ Failed to generate report${NC}"
        echo ""
        echo "0 0 0 0"
    fi
}

# Audit pages
echo -e "${GREEN}🔍 Running Lighthouse audits...${NC}"
echo ""

scores1=$(audit_page "${BASE_URL}/api/staff/login/" "Login Page")
sleep 2
scores2=$(audit_page "${BASE_URL}/api/staff/dashboard/" "Dashboard")
sleep 2
scores3=$(audit_page "${BASE_URL}/api/staff/tasks/" "Task List")

# Calculate averages
read perf1 access1 bp1 seo1 <<< "$scores1"
read perf2 access2 bp2 seo2 <<< "$scores2"
read perf3 access3 bp3 seo3 <<< "$scores3"

avg_perf=$(( (perf1 + perf2 + perf3) / 3 ))
avg_access=$(( (access1 + access2 + access3) / 3 ))
avg_bp=$(( (bp1 + bp2 + bp3) / 3 ))
avg_seo=$(( (seo1 + seo2 + seo3) / 3 ))

# Summary
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}Audit Summary${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo "📊 Pages Audited: 3"
echo ""
echo "📈 Average Scores:"

if [ "$avg_perf" -ge 90 ]; then
    echo -e "   Performance:    ${GREEN}${avg_perf}${NC} ✅ (Target: ≥90)"
else
    echo -e "   Performance:    ${YELLOW}${avg_perf}${NC} ⚠️  (Target: ≥90)"
fi

if [ "$avg_access" -ge 95 ]; then
    echo -e "   Accessibility:  ${GREEN}${avg_access}${NC} ✅ (Target: ≥95)"
else
    echo -e "   Accessibility:  ${YELLOW}${avg_access}${NC} ⚠️  (Target: ≥95)"
fi

echo -e "   Best Practices: ${avg_bp}"
echo -e "   SEO:            ${avg_seo}"
echo ""
echo -e "📁 Reports saved to: ${REPORT_DIR}/"
echo ""

# Final status
if [ "$avg_perf" -ge 90 ] && [ "$avg_access" -ge 95 ]; then
    echo -e "${GREEN}✅ Performance and accessibility targets met!${NC}"
    exit 0
else
    echo -e "${YELLOW}⚠️  Some optimizations needed${NC}"
    exit 1
fi
