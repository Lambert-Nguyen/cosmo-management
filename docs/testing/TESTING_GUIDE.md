# Testing Guide

**Aristay Property Management - Frontend Testing**

This guide covers all aspects of testing the refactored Django UI, including unit tests, integration tests, and end-to-end tests.

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [Setup](#setup)
3. [Running Tests](#running-tests)
4. [Writing Tests](#writing-tests)
5. [Test Structure](#test-structure)
6. [Best Practices](#best-practices)
7. [Troubleshooting](#troubleshooting)

---

## Overview

### Testing Pyramid

```
        E2E Tests (47 tests)
       /                    \
     /                        \
   Integration Tests (TBD)
  /                                \
Unit Tests (35 tests)
```

### Test Categories

| Category | Tool | Purpose | Location |
|----------|------|---------|----------|
| Unit Tests | Jest | Test individual JS modules | `tests/frontend/unit/` |
| Integration Tests | Jest | Test API interactions | `tests/frontend/integration/` |
| E2E Tests | Playwright | Test user workflows | `tests/frontend/e2e/` |

### Coverage Goals

- **Unit Tests**: 85%+ coverage
- **Integration Tests**: 75%+ coverage
- **E2E Tests**: All critical user paths

---

## Setup

### Prerequisites

- Node.js 18+ installed
- Django development server running
- Virtual environment activated

### Initial Setup

```bash
# Run the automated setup script
chmod +x scripts/setup_testing.sh
./scripts/setup_testing.sh
```

Or manually:

```bash
# Install dependencies
npm install

# Install Playwright browsers
npx playwright install

# Start Django server (in separate terminal)
cd aristay_backend
python manage.py runserver 8000
```

---

## Running Tests

### Unit Tests (Jest)

```bash
# Run all unit tests
npm run test

# Run with coverage report
npm run test:coverage

# Run in watch mode (auto-rerun on file changes)
npm run test:watch

# Run specific test file
npm test -- csrf.test.js
```

### E2E Tests (Playwright)

```bash
# Run all E2E tests
npm run test:e2e

# Run with interactive UI
npm run test:e2e:ui

# Run in debug mode
npm run test:e2e:debug

# Run specific test file
npx playwright test baseline.spec.js

# Run specific browser
npx playwright test --project=chromium
npx playwright test --project=firefox
npx playwright test --project=webkit
```

### All Tests

```bash
# Run unit tests + E2E tests
npm run test:all
```

### Linting

```bash
# Check code quality
npm run lint

# Auto-fix linting issues
npm run lint -- --fix
```

---

## Writing Tests

### Unit Test Template

```javascript
/**
 * Unit Tests: Module Name
 * Description of what is being tested
 */

import { ModuleToTest } from '../../../path/to/module.js';

describe('ModuleName', () => {
  beforeEach(() => {
    // Setup before each test
  });

  afterEach(() => {
    // Cleanup after each test
  });

  describe('methodName()', () => {
    test('does something specific', () => {
      // Arrange
      const input = 'test';
      
      // Act
      const result = ModuleToTest.methodName(input);
      
      // Assert
      expect(result).toBe('expected');
    });

    test('handles edge cases', () => {
      expect(() => ModuleToTest.methodName(null)).toThrow();
    });
  });
});
```

### E2E Test Template

```javascript
/**
 * E2E Tests: Feature Name
 * Description of workflow being tested
 */

import { test, expect } from '@playwright/test';

test.describe('Feature Name', () => {
  test('user can complete workflow', async ({ page }) => {
    // Navigate to page
    await page.goto('/api/staff/feature/');
    
    // Interact with elements
    await page.fill('input[name="field"]', 'value');
    await page.click('button[type="submit"]');
    
    // Verify results
    await expect(page.locator('.success-message')).toBeVisible();
    await expect(page).toHaveURL(/success/);
  });

  test('handles error cases', async ({ page }) => {
    await page.goto('/api/staff/feature/');
    
    // Trigger error
    await page.click('button[type="submit"]');
    
    // Verify error handling
    await expect(page.locator('.error-message')).toBeVisible();
  });
});
```

---

## Test Structure

### Unit Tests (`tests/frontend/unit/`)

```
tests/frontend/unit/
├── csrf.test.js           # CSRF token management (10 tests)
├── api-client.test.js     # API client abstraction (15 tests)
└── storage.test.js        # localStorage wrapper (10 tests)
```

### E2E Tests (`tests/frontend/e2e/`)

```
tests/frontend/e2e/
├── baseline.spec.js       # Smoke tests (8 tests)
├── auth.spec.js          # Authentication (6 tests)
├── navigation.spec.js    # Navigation/routing (7 tests)
├── responsive.spec.js    # Responsive design (6 tests)
├── accessibility.spec.js # WCAG compliance (10 tests)
└── performance.spec.js   # Performance metrics (10 tests)
```

### Test Fixtures

Create reusable test data and helpers:

```javascript
// tests/fixtures/auth.js
export async function loginAsStaff(page) {
  await page.goto('/api/staff/login/');
  await page.fill('input[name="username"]', 'teststaff');
  await page.fill('input[name="password"]', 'testpass123');
  await page.click('button[type="submit"]');
  await page.waitForURL(/dashboard/);
}

export async function loginAsManager(page) {
  await page.goto('/api/staff/login/');
  await page.fill('input[name="username"]', 'testmanager');
  await page.fill('input[name="password"]', 'testpass123');
  await page.click('button[type="submit"]');
  await page.waitForURL(/dashboard/);
}
```

---

## Best Practices

### Unit Testing

✅ **DO:**
- Test one thing per test
- Use descriptive test names
- Mock external dependencies
- Test edge cases and errors
- Aim for 85%+ coverage

❌ **DON'T:**
- Test implementation details
- Make tests dependent on each other
- Use real API calls
- Hard-code test data

### E2E Testing

✅ **DO:**
- Test complete user workflows
- Use data attributes for selectors
- Wait for elements properly
- Test on multiple browsers
- Screenshot failures

❌ **DON'T:**
- Test every possible scenario
- Use brittle CSS selectors
- Make tests too long
- Test implementation details
- Skip error handling

### Selector Best Practices

```javascript
// ✅ GOOD - Use data attributes
await page.locator('[data-testid="submit-button"]').click();

// ✅ GOOD - Use semantic HTML
await page.locator('button[type="submit"]').click();

// ❌ BAD - Brittle CSS classes
await page.locator('.btn.btn-primary.mt-4').click();

// ❌ BAD - Position-based
await page.locator('div > div > button:nth-child(3)').click();
```

### Waiting Strategies

```javascript
// ✅ GOOD - Wait for specific condition
await page.waitForSelector('.success-message');
await page.waitForURL(/dashboard/);
await page.waitForLoadState('networkidle');

// ❌ BAD - Arbitrary timeout
await page.waitForTimeout(5000);
```

---

## Troubleshooting

### Common Issues

#### 1. "Django server not found"

**Problem**: Playwright can't connect to Django

**Solution**:
```bash
# Start Django in separate terminal
cd aristay_backend
python manage.py runserver 8000

# Verify it's running
curl http://127.0.0.1:8000
```

#### 2. "Element not found"

**Problem**: Selector is incorrect or page hasn't loaded

**Solution**:
```javascript
// Add proper waits
await page.waitForSelector('[data-testid="element"]');
await page.waitForLoadState('networkidle');

// Use more specific selectors
await page.locator('button:has-text("Submit")').click();
```

#### 3. "CSRF token not found"

**Problem**: Template doesn't have CSRF token

**Solution**:
- Check base template has `<meta name="csrf-token">` or hidden input
- Verify CSRF middleware is enabled
- Check CSRFManager implementation

#### 4. "Tests timeout"

**Problem**: Page takes too long to load

**Solution**:
```javascript
// Increase timeout for slow pages
test('slow page', async ({ page }) => {
  test.setTimeout(60000); // 60 seconds
  await page.goto('/slow-page/');
});
```

#### 5. "Module not found"

**Problem**: Import path is incorrect

**Solution**:
```javascript
// Use relative paths from test file
import { Module } from '../../../aristay_backend/static/js/module.js';

// Or configure Jest moduleNameMapper in package.json
```

### Debugging Tests

#### Debug E2E Tests

```bash
# Run with Playwright Inspector
npx playwright test --debug

# Run with headed browser
npx playwright test --headed

# Pause execution
await page.pause();
```

#### Debug Unit Tests

```bash
# Run with Node debugger
node --inspect-brk node_modules/.bin/jest --runInBand

# Add debugger statement
test('my test', () => {
  debugger; // Execution will pause here
  expect(result).toBe(value);
});
```

#### View Test Reports

```bash
# Open Playwright HTML report
npx playwright show-report

# View Jest coverage report
open coverage/lcov-report/index.html
```

---

## CI/CD Integration

### GitHub Actions Example

```yaml
name: Frontend Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: 18
      
      - name: Install dependencies
        run: npm install
      
      - name: Run unit tests
        run: npm run test:coverage
      
      - name: Setup Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.12'
      
      - name: Start Django server
        run: |
          cd aristay_backend
          python manage.py migrate
          python manage.py runserver &
          sleep 5
      
      - name: Install Playwright browsers
        run: npx playwright install --with-deps
      
      - name: Run E2E tests
        run: npm run test:e2e
      
      - name: Upload test results
        if: always()
        uses: actions/upload-artifact@v3
        with:
          name: test-results
          path: |
            coverage/
            playwright-report/
```

---

## Test Data Management

### Creating Test Users

```bash
# Django management command
cd aristay_backend
python manage.py shell

from django.contrib.auth.models import User
User.objects.create_user('teststaff', 'test@example.com', 'testpass123')
User.objects.create_user('testmanager', 'manager@example.com', 'testpass123')
```

### Test Database

```python
# Use separate test database in settings.py
if 'test' in sys.argv:
    DATABASES['default'] = {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': ':memory:',
    }
```

---

## Performance Testing

### Lighthouse CI

```bash
# Install Lighthouse CI
npm install -g @lhci/cli

# Run Lighthouse
lhci autorun --config=lighthouserc.js
```

### Load Testing

```javascript
// tests/performance/load-test.js
import { test } from '@playwright/test';

test('handle concurrent users', async ({ browser }) => {
  const contexts = await Promise.all([
    browser.newContext(),
    browser.newContext(),
    browser.newContext(),
  ]);
  
  const pages = await Promise.all(
    contexts.map(context => context.newPage())
  );
  
  await Promise.all(
    pages.map(page => page.goto('/api/staff/dashboard/'))
  );
});
```

---

## Resources

- **Playwright Docs**: https://playwright.dev/
- **Jest Docs**: https://jestjs.io/
- **Testing Best Practices**: https://kentcdodds.com/blog/common-mistakes-with-react-testing-library
- **WCAG Guidelines**: https://www.w3.org/WAI/WCAG21/quickref/

---

**Last Updated**: December 6, 2025  
**Maintained By**: Development Team
