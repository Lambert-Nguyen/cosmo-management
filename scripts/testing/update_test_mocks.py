#!/usr/bin/env python3
"""
Update all test files to use proper Jest spying instead of jest.mock()
"""

import re
from pathlib import Path

# Test files to update
test_files = [
    "tests/frontend/unit/checklist-manager.test.js",
    "tests/frontend/unit/task-actions.test.js",
    "tests/frontend/unit/navigation-manager.test.js",
    "tests/frontend/unit/photo-modal.test.js",
    "tests/frontend/unit/task-timer.test.js",
    "tests/frontend/integration/task-detail-integration.test.js",
]

mock_pattern = re.compile(
    r"// Mock APIClient\s*\njest\.mock\([^)]+\),[^)]+\);\s*\nimport { APIClient } from",
    re.MULTILINE | re.DOTALL
)

replacement = "import { APIClient } from"

spy_setup = """  let requestSpy;
  let uploadSpy;

  beforeEach(() => {
    // ... existing beforeEach code ...
    
    // Spy on APIClient methods
    requestSpy = jest.spyOn(APIClient, 'request').mockResolvedValue({ success: true });
    uploadSpy = jest.spyOn(APIClient, 'upload').mockResolvedValue({ success: true });
"""

for test_file in test_files:
    file_path = Path(test_file)
    
    if not file_path.exists():
        print(f"⚠️  {test_file} not found, skipping")
        continue
    
    print(f"→ Updating {test_file}...")
    
    content = file_path.read_text()
    
    # Remove jest.mock() block
    content = mock_pattern.sub(replacement, content)
    
    # Add spy variables after describe block
    # Look for: describe('ModuleName', () => {
    #   let moduleInstance;
    describe_pattern = r"(describe\('[^']+',\s*\(\)\s*=>\s*\{)\s*(\n\s*let\s+\w+;)"
    
    def add_spies(match):
        return f"{match.group(1)}\n  let requestSpy;\n  let uploadSpy;{match.group(2)}"
    
    content = re.sub(describe_pattern, add_spies, content, count=1)
    
    # Add spy setup to beforeEach
    # Find afterEach and add spy setup before it
    beforeeach_pattern = r"(beforeEach\(\(\)\s*=>\s*\{[^}]*?)(\s*\}\);)"
    
    def add_spy_setup(match):
        existing = match.group(1)
        # Only add if not already present
        if 'requestSpy' not in existing:
            return f"{existing}\n\n    // Spy on APIClient methods\n    requestSpy = jest.spyOn(APIClient, 'request').mockResolvedValue({{ success: true }});\n    uploadSpy = jest.spyOn(APIClient, 'upload').mockResolvedValue({{ success: true }});{match.group(2)}"
        return match.group(0)
    
    content = re.sub(beforeeach_pattern, add_spy_setup, content, count=1, flags=re.DOTALL)
    
    # Update afterEach to use restoreAllMocks
    content = re.sub(
        r"jest\.clearAllMocks\(\);",
        "jest.restoreAllMocks();",
        content
    )
    
    file_path.write_text(content)
    print(f"  ✓ Updated {test_file}")

print("\n✅ All test files updated!")
print("Run 'npm test' to verify")
