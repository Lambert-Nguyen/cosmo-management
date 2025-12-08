#!/bin/bash
# Fix APIClient mocking in all test files

set -e

echo "🔧 Fixing APIClient mocking across all test files..."

# Array of test files that need fixing
test_files=(
  "tests/frontend/unit/photo-manager.test.js"
  "tests/frontend/unit/checklist-manager.test.js"
  "tests/frontend/unit/task-actions.test.js"
  "tests/frontend/unit/navigation-manager.test.js"
  "tests/frontend/unit/photo-modal.test.js"
  "tests/frontend/unit/task-timer.test.js"
  "tests/frontend/integration/task-detail-integration.test.js"
)

for file in "${test_files[@]}"; do
  if [ -f "$file" ]; then
    echo "  → Fixing $file..."
    
    # Use requestSpy and uploadSpy instead of direct mocking calls
    sed -i '' 's/APIClient\.request\.mockResolvedValue/requestSpy.mockResolvedValue/g' "$file"
    sed -i '' 's/APIClient\.request\.mockRejectedValue/requestSpy.mockRejectedValue/g' "$file"
    sed -i '' 's/APIClient\.upload\.mockResolvedValue/uploadSpy.mockResolvedValue/g' "$file"
    sed -i '' 's/APIClient\.upload\.mockRejectedValue/uploadSpy.mockRejectedValue/g' "$file"
    
    echo "    ✓ Fixed $file"
  else
    echo "    ⚠️  $file not found, skipping"
  fi
done

echo ""
echo "✅ All test files fixed!"
echo ""
echo "Run 'npm test' to verify fixes"
