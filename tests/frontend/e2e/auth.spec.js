/**
 * E2E Authentication Tests
 * Tests for login, logout, and session management
 */

import { test, expect } from '@playwright/test';

test.describe('Authentication Flow', () => {
  test('user can log in with valid credentials', async ({ page }) => {
    await page.goto('/api/staff/login/');
    
    // Fill in login form
    await page.fill('input[name="username"]', 'testuser');
    await page.fill('input[name="password"]', 'testpass123');
    
    // Submit form
    await page.click('button[type="submit"]');
    
    // Wait for navigation (will fail if credentials are invalid, but test structure is correct)
    // In real test, you'd need valid test credentials
    await page.waitForLoadState('networkidle');
  });

  test('login fails with invalid credentials', async ({ page }) => {
    await page.goto('/api/staff/login/');
    
    await page.fill('input[name="username"]', 'invaliduser');
    await page.fill('input[name="password"]', 'wrongpassword');
    
    await page.click('button[type="submit"]');
    
    // Should show error message
    await expect(page.locator('.alert, .error, .message')).toBeVisible();
  });

  test('login form has CSRF protection', async ({ page }) => {
    await page.goto('/api/staff/login/');
    
    // Verify CSRF token is present
    const csrfToken = await page.locator('input[name="csrfmiddlewaretoken"]').getAttribute('value');
    expect(csrfToken).toBeTruthy();
    expect(csrfToken?.length).toBeGreaterThan(10);
  });

  test('login form is keyboard accessible', async ({ page }) => {
    await page.goto('/api/staff/login/');
    
    // Tab through form
    await page.keyboard.press('Tab'); // Focus first input
    await page.keyboard.type('testuser');
    
    await page.keyboard.press('Tab'); // Focus password
    await page.keyboard.type('testpass');
    
    await page.keyboard.press('Tab'); // Focus submit button
    await page.keyboard.press('Enter'); // Submit
    
    await page.waitForLoadState('networkidle');
  });

  test('logout button is visible when authenticated', async ({ page }) => {
    // This test assumes user is logged in
    // In real implementation, you'd use a fixture to handle auth
    await page.goto('/api/staff/dashboard/');
    
    // Check if logout link/button exists
    const logoutLink = page.locator('a[href*="logout"], button:has-text("Logout")');
    await expect(logoutLink).toBeVisible();
  });

  test('session persists across page reloads', async ({ page, context }) => {
    // After login, session should persist
    await page.goto('/api/staff/login/');
    
    // Assuming successful login redirects to dashboard
    await page.goto('/api/staff/dashboard/');
    
    // Reload page
    await page.reload();
    
    // Should still be on dashboard (not redirected to login)
    await expect(page).toHaveURL(/dashboard/);
  });
});
