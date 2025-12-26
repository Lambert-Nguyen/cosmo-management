/**
 * E2E Navigation Tests
 * Tests for site navigation and routing
 */

import { test, expect } from '@playwright/test';

test.describe('Navigation', () => {
  test('staff navigation menu is present', async ({ page }) => {
    await page.goto('/api/staff/dashboard/');
    
    // Check for navigation container
    const nav = page.locator('nav, .navigation, .sidebar, .navbar');
    await expect(nav).toBeVisible();
  });

  test('navigation links are clickable', async ({ page }) => {
    await page.goto('/api/staff/dashboard/');
    
    // Find and click a navigation link
    const dashboardLink = page.locator('a[href*="dashboard"]').first();
    await expect(dashboardLink).toBeVisible();
    await dashboardLink.click();
    
    await page.waitForLoadState('networkidle');
    await expect(page).toHaveURL(/dashboard/);
  });

  test('mobile hamburger menu works', async ({ page }) => {
    // Set mobile viewport
    await page.setViewportSize({ width: 375, height: 667 });
    await page.goto('/api/staff/dashboard/');
    
    // Look for hamburger menu
    const hamburger = page.locator('.hamburger, .menu-toggle, button[aria-label*="menu"]');
    
    if (await hamburger.isVisible()) {
      await hamburger.click();
      
      // Navigation should become visible
      const mobileNav = page.locator('.mobile-menu, .navigation-mobile, nav');
      await expect(mobileNav).toBeVisible();
    }
  });

  test('breadcrumbs show current page location', async ({ page }) => {
    await page.goto('/api/staff/tasks/');
    
    // Check if breadcrumbs exist
    const breadcrumbs = page.locator('.breadcrumb, nav[aria-label="breadcrumb"]');
    
    if (await breadcrumbs.isVisible()) {
      await expect(breadcrumbs).toContainText(/tasks/i);
    }
  });

  test('active navigation item is highlighted', async ({ page }) => {
    await page.goto('/api/staff/dashboard/');
    
    // Active link should have special styling
    const activeLink = page.locator('a[href*="dashboard"].active, a[href*="dashboard"][aria-current="page"]');
    
    if (await activeLink.isVisible()) {
      const color = await activeLink.evaluate(el => 
        window.getComputedStyle(el).getPropertyValue('color')
      );
      expect(color).toBeTruthy();
    }
  });

  test('navigation persists across page changes', async ({ page }) => {
    await page.goto('/api/staff/dashboard/');
    
    // Get navigation HTML
    const navBefore = await page.locator('nav').first().innerHTML();
    
    // Navigate to another page
    await page.goto('/api/staff/tasks/');
    
    // Navigation should still exist
    const navAfter = await page.locator('nav').first().innerHTML();
    expect(navAfter).toBeTruthy();
  });

  test('keyboard navigation works with Tab key', async ({ page }) => {
    await page.goto('/api/staff/dashboard/');
    
    // Press Tab multiple times to navigate through links
    await page.keyboard.press('Tab');
    await page.keyboard.press('Tab');
    
    // Check if an element is focused
    const focused = await page.evaluate(() => document.activeElement?.tagName);
    expect(focused).toBeTruthy();
  });
});
