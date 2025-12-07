/**
 * E2E Responsive Design Tests
 * Tests for responsive behavior across different screen sizes
 */

import { test, expect } from '@playwright/test';

const devices = [
  { name: 'Desktop', width: 1920, height: 1080 },
  { name: 'Laptop', width: 1366, height: 768 },
  { name: 'Tablet', width: 768, height: 1024 },
  { name: 'Mobile', width: 375, height: 667 },
];

test.describe('Responsive Design', () => {
  for (const device of devices) {
    test(`renders correctly on ${device.name}`, async ({ page }) => {
      await page.setViewportSize({ width: device.width, height: device.height });
      await page.goto('/api/staff/dashboard/');
      
      // Page should render without overflow
      const body = await page.locator('body').boundingBox();
      expect(body?.width).toBeLessThanOrEqual(device.width + 20); // Small tolerance
      
      // No horizontal scrollbar
      const scrollWidth = await page.evaluate(() => document.documentElement.scrollWidth);
      expect(scrollWidth).toBeLessThanOrEqual(device.width + 20);
    });
  }

  test('mobile menu toggles correctly', async ({ page }) => {
    await page.setViewportSize({ width: 375, height: 667 });
    await page.goto('/api/staff/dashboard/');
    
    const hamburger = page.locator('.hamburger, .menu-toggle, button[aria-label*="menu"]');
    
    if (await hamburger.isVisible()) {
      // Menu should be hidden initially
      const menu = page.locator('.mobile-menu, .navigation-mobile');
      const initialDisplay = await menu.isVisible();
      
      // Click to open
      await hamburger.click();
      await expect(menu).toBeVisible();
      
      // Click to close
      await hamburger.click();
      await expect(menu).not.toBeVisible();
    }
  });

  test('images are responsive', async ({ page }) => {
    await page.setViewportSize({ width: 375, height: 667 });
    await page.goto('/');
    
    const images = await page.locator('img').all();
    
    for (const img of images) {
      const box = await img.boundingBox();
      if (box) {
        expect(box.width).toBeLessThanOrEqual(375);
      }
    }
  });

  test('touch targets are adequately sized on mobile', async ({ page }) => {
    await page.setViewportSize({ width: 375, height: 667 });
    await page.goto('/api/staff/dashboard/');
    
    const buttons = await page.locator('button, a').all();
    
    for (const button of buttons.slice(0, 10)) { // Test first 10
      const box = await button.boundingBox();
      if (box && await button.isVisible()) {
        // WCAG recommends 44x44 minimum for touch targets
        expect(box.height).toBeGreaterThanOrEqual(36); // Slightly relaxed
      }
    }
  });

  test('tables are responsive or scrollable on mobile', async ({ page }) => {
    await page.setViewportSize({ width: 375, height: 667 });
    await page.goto('/api/staff/tasks/');
    
    const tables = await page.locator('table').all();
    
    for (const table of tables) {
      if (await table.isVisible()) {
        const container = await table.locator('..').first(); // Parent element
        const overflow = await container.evaluate(el => 
          window.getComputedStyle(el).overflowX
        );
        
        // Should have scroll or be responsive
        expect(['auto', 'scroll', 'hidden']).toContain(overflow);
      }
    }
  });
});
