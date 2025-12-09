#!/bin/bash
# Run E2E tests with Django server

set -e

echo "🚀 Starting E2E Test Suite"
echo "=========================="

# Change to project root
cd "$(dirname "$0")/../.."

# Check if virtual environment is activated
if [ -z "$VIRTUAL_ENV" ]; then
    echo "❌ Virtual environment not activated"
    echo "   Run: source .venv/bin/activate"
    exit 1
fi

# Change to backend directory
cd aristay_backend

# Load test fixtures
echo "📦 Loading test fixtures..."
python manage.py loaddata fixtures/test_data.json

# Start Django server in background
echo "🌐 Starting Django server..."
python manage.py runserver 8000 &
SERVER_PID=$!

# Wait for server to be ready
echo "⏳ Waiting for server to be ready..."
sleep 3

# Check if server is running
if ! curl -s http://127.0.0.1:8000/api/staff/login/ > /dev/null; then
    echo "❌ Server failed to start"
    kill $SERVER_PID 2>/dev/null || true
    exit 1
fi

echo "✅ Server is ready"

# Go back to project root
cd ..

# Run Playwright tests
echo "🎭 Running Playwright E2E tests..."
npx playwright test

TEST_EXIT_CODE=$?

# Stop Django server
echo "🛑 Stopping Django server..."
kill $SERVER_PID 2>/dev/null || true

# Wait for server to stop
sleep 1

if [ $TEST_EXIT_CODE -eq 0 ]; then
    echo ""
    echo "✅ All E2E tests passed!"
else
    echo ""
    echo "❌ Some E2E tests failed"
fi

exit $TEST_EXIT_CODE
