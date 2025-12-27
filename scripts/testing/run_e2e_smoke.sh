#!/bin/bash
# Comprehensive E2E test runner with server management

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
BACKEND_DIR="$PROJECT_ROOT/cosmo_backend"

echo "🚀 E2E Test Suite"
echo "=================="
echo "Project root: $PROJECT_ROOT"
echo ""

# Check virtual environment
if [ ! -d "$PROJECT_ROOT/.venv" ]; then
    echo "❌ Virtual environment not found at $PROJECT_ROOT/.venv"
    exit 1
fi

# Activate virtual environment
echo "🔧 Activating virtual environment..."
source "$PROJECT_ROOT/.venv/bin/activate"

# Verify Django is available
if ! python -c "import django" 2>/dev/null; then
    echo "❌ Django not found in virtual environment"
    exit 1
fi

echo "✅ Virtual environment activated"
echo ""

# Start Django server
echo "🌐 Starting Django server on port 8000..."
cd "$BACKEND_DIR"
python manage.py runserver 8000 > /tmp/django-e2e-server.log 2>&1 &
SERVER_PID=$!

echo "   Server PID: $SERVER_PID"

# Function to cleanup on exit
cleanup() {
    echo ""
    echo "🛑 Stopping Django server (PID: $SERVER_PID)..."
    kill $SERVER_PID 2>/dev/null || true
    wait $SERVER_PID 2>/dev/null || true
    echo "✅ Server stopped"
}

trap cleanup EXIT INT TERM

# Wait for server to start
echo "⏳ Waiting for server to be ready..."
MAX_WAIT=15
COUNTER=0

while [ $COUNTER -lt $MAX_WAIT ]; do
    if curl -s http://127.0.0.1:8000/api/staff/login/ > /dev/null 2>&1; then
        echo "✅ Server is ready (took ${COUNTER}s)"
        break
    fi
    sleep 1
    COUNTER=$((COUNTER + 1))
    echo "   Waiting... ${COUNTER}s"
done

if [ $COUNTER -eq $MAX_WAIT ]; then
    echo "❌ Server failed to start within ${MAX_WAIT}s"
    echo "   Check logs: tail /tmp/django-e2e-server.log"
    exit 1
fi

echo ""

# Run Playwright tests
cd "$PROJECT_ROOT"
echo "🎭 Running Playwright E2E tests..."
echo ""

npx playwright test tests/frontend/e2e/smoke.spec.js --reporter=list

EXIT_CODE=$?

echo ""
if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ All E2E tests passed!"
else
    echo "❌ Some E2E tests failed (exit code: $EXIT_CODE)"
fi

exit $EXIT_CODE
