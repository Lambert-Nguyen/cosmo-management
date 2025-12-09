/**
 * Simple E2E smoke tests
 * Tests that don't require authentication
 */

import { test, expect } from '@playwright/test';

test.describe('Public Pages - Smoke Tests', () => {
  test('login page loads and has no console errors', async ({ page }) => {
    const consoleErrors = [];
    page.on('console', msg => {
      if (msg.type() === 'error') {
        consoleErrors.push(msg.text());
      }
    });
    
    await page.goto('/api/staff/login/');
    
    // Check for login form elements
    await expect(page.locator('input[name="username"]')).toBeVisible();
    await expect(page.locator('input[name="password"]')).toBeVisible();
    await expect(page.locator('button[type="submit"]')).toBeVisible();
    
    await page.waitForLoadState('networkidle');
    
    // Verify no console errors
    expect(consoleErrors).toHaveLength(0);
  });

  test('login form has CSRF token', async ({ page }) => {
    await page.goto('/api/staff/login/');
    
    // Check for CSRF token in hidden input or meta tag
    const csrfInput = page.locator('input[name="csrfmiddlewaretoken"]');
    const csrfMeta = page.locator('meta[name="csrf-token"]');
    
    const inputCount = await csrfInput.count();
    const metaCount = await csrfMeta.count();
    
    expect(inputCount + metaCount).toBeGreaterThan(0);
  });

  test('login form is keyboard accessible', async ({ page }) => {
    await page.goto('/api/staff/login/');
    
    // Tab to username field
    await page.keyboard.press('Tab');
    await page.keyboard.type('testuser');
    
    // Tab to password field
    await page.keyboard.press('Tab');
    await page.keyboard.type('testpass');
    
    // Should be able to reach submit button via tab
    await page.keyboard.press('Tab');
    
    // Verify focus is on submit button
    const focused = await page.evaluate(() => document.activeElement?.tagName);
    expect(focused).toBe('BUTTON');
  });

  test('page has valid HTML structure', async ({ page }) => {
    await page.goto('/api/staff/login/');
    
    // Check basic HTML structure
    await expect(page.locator('html')).toBeVisible();
    await expect(page.locator('head')).toBeAttached();
    await expect(page.locator('body')).toBeVisible();
    
    // Should have a title
    const title = await page.title();
    expect(title).toBeTruthy();
    expect(title.length).toBeGreaterThan(0);
  });

  test('page has no accessibility violations', async ({ page }) => {
    await page.goto('/api/staff/login/');
    
    // Check for basic accessibility
    // All images should have alt text (if any images exist)
    const images = await page.locator('img').count();
    if (images > 0) {
      const imagesWithAlt = await page.locator('img[alt]').count();
      expect(imagesWithAlt).toBe(images);
    }
    
    // All inputs should have labels or aria-labels
    const inputs = page.locator('input[type="text"], input[type="password"], input[type="email"]');
    const inputCount = await inputs.count();
    
    for (let i = 0; i < inputCount; i++) {
      const input = inputs.nth(i);
      const id = await input.getAttribute('id');
      const ariaLabel = await input.getAttribute('aria-label');
      
      if (id) {
        // Should have corresponding label
        const label = page.locator(`label[for="${id}"]`);
        const hasLabel = await label.count() > 0;
        const hasAriaLabel = ariaLabel && ariaLabel.length > 0;
        
        expect(hasLabel || hasAriaLabel).toBe(true);
      }
    }
  });

  test('responsive design - mobile viewport', async ({ page }) => {
    // Set mobile viewport
    await page.setViewportSize({ width: 375, height: 667 });
    await page.goto('/api/staff/login/');
    
    // Form should still be visible and usable
    await expect(page.locator('input[name="username"]')).toBeVisible();
    await expect(page.locator('input[name="password"]')).toBeVisible();
    await expect(page.locator('button[type="submit"]')).toBeVisible();
  });

  test('responsive design - tablet viewport', async ({ page }) => {
    // Set tablet viewport
    await page.setViewportSize({ width: 768, height: 1024 });
    await page.goto('/api/staff/login/');
    
    // Form should still be visible and usable
    await expect(page.locator('input[name="username"]')).toBeVisible();
    await expect(page.locator('input[name="password"]')).toBeVisible();
    await expect(page.locator('button[type="submit"]')).toBeVisible();
  });
});

test.describe('Static Assets', () => {
  test('CSS files load successfully', async ({ page }) => {
    await page.goto('/api/staff/login/');
    
    // Check if stylesheets loaded
    const stylesheets = await page.locator('link[rel="stylesheet"]').count();
    expect(stylesheets).toBeGreaterThan(0);
    
    // Check if any stylesheet failed to load
    const failedResources = [];
    page.on('response', response => {
      if (response.url().endsWith('.css') && !response.ok()) {
        failedResources.push(response.url());
      }
    });
    
    await page.waitForLoadState('networkidle');
    expect(failedResources).toHaveLength(0);
  });

  test('JavaScript files load successfully', async ({ page }) => {
    const failedResources = [];
    page.on('response', response => {
      if (response.url().endsWith('.js') && !response.ok()) {
        failedResources.push(response.url());
      }
    });
    
    await page.goto('/api/staff/login/');
    await page.waitForLoadState('networkidle');
    
    expect(failedResources).toHaveLength(0);
  });

  test('page loads in under 3 seconds', async ({ page }) => {
    const startTime = Date.now();
    
    await page.goto('/api/staff/login/');
    await page.waitForLoadState('networkidle');
    
    const loadTime = Date.now() - startTime;
    expect(loadTime).toBeLessThan(3000);
  });
});
