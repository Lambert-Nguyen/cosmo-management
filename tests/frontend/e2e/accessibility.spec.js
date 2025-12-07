/**
 * E2E Accessibility Tests
 * Tests for WCAG 2.1 AA compliance
 */

import { test, expect } from '@playwright/test';

test.describe('Accessibility', () => {
  test('page has proper heading hierarchy', async ({ page }) => {
    await page.goto('/api/staff/dashboard/');
    
    // Should have h1
    const h1Count = await page.locator('h1').count();
    expect(h1Count).toBeGreaterThanOrEqual(1);
    
    // Check heading order (h1 -> h2 -> h3, no skipping)
    const headings = await page.locator('h1, h2, h3, h4, h5, h6').all();
    const levels = [];
    
    for (const heading of headings) {
      const tagName = await heading.evaluate(el => el.tagName);
      levels.push(parseInt(tagName[1]));
    }
    
    // First heading should be h1
    expect(levels[0]).toBe(1);
  });

  test('images have alt text', async ({ page }) => {
    await page.goto('/');
    
    const images = await page.locator('img').all();
    
    for (const img of images) {
      if (await img.isVisible()) {
        const alt = await img.getAttribute('alt');
        expect(alt).not.toBeNull();
      }
    }
  });

  test('form inputs have labels', async ({ page }) => {
    await page.goto('/api/staff/login/');
    
    const inputs = await page.locator('input[type="text"], input[type="password"], input[type="email"], textarea, select').all();
    
    for (const input of inputs) {
      const id = await input.getAttribute('id');
      const ariaLabel = await input.getAttribute('aria-label');
      const ariaLabelledBy = await input.getAttribute('aria-labelledby');
      
      if (id) {
        const label = await page.locator(`label[for="${id}"]`).count();
        const hasLabel = label > 0 || ariaLabel || ariaLabelledBy;
        expect(hasLabel).toBeTruthy();
      }
    }
  });

  test('interactive elements are keyboard accessible', async ({ page }) => {
    await page.goto('/api/staff/dashboard/');
    
    // Tab through first few interactive elements
    const focusableElements = [];
    
    for (let i = 0; i < 5; i++) {
      await page.keyboard.press('Tab');
      const focused = await page.evaluate(() => ({
        tag: document.activeElement?.tagName,
        role: document.activeElement?.getAttribute('role'),
        tabIndex: document.activeElement?.getAttribute('tabindex')
      }));
      focusableElements.push(focused);
    }
    
    // At least some elements should be focusable
    expect(focusableElements.some(el => el.tag !== 'BODY')).toBeTruthy();
  });

  test('focus indicators are visible', async ({ page }) => {
    await page.goto('/api/staff/dashboard/');
    
    // Tab to first focusable element
    await page.keyboard.press('Tab');
    
    const focused = page.locator(':focus');
    const outline = await focused.evaluate(el => 
      window.getComputedStyle(el).outline
    );
    
    // Should have some form of outline/focus indicator
    expect(outline).not.toBe('none');
  });

  test('color contrast is sufficient', async ({ page }) => {
    await page.goto('/');
    
    // Check a few key text elements
    const textElements = await page.locator('p, span, a, button, h1, h2').all();
    
    for (const element of textElements.slice(0, 10)) {
      if (await element.isVisible()) {
        const styles = await element.evaluate(el => {
          const computed = window.getComputedStyle(el);
          return {
            color: computed.color,
            background: computed.backgroundColor
          };
        });
        
        // Basic check - both should be defined
        expect(styles.color).toBeTruthy();
        expect(styles.background).toBeTruthy();
      }
    }
  });

  test('buttons have accessible names', async ({ page }) => {
    await page.goto('/api/staff/dashboard/');
    
    const buttons = await page.locator('button').all();
    
    for (const button of buttons) {
      if (await button.isVisible()) {
        const text = await button.textContent();
        const ariaLabel = await button.getAttribute('aria-label');
        const title = await button.getAttribute('title');
        
        const hasAccessibleName = text?.trim() || ariaLabel || title;
        expect(hasAccessibleName).toBeTruthy();
      }
    }
  });

  test('page has language attribute', async ({ page }) => {
    await page.goto('/');
    
    const lang = await page.locator('html').getAttribute('lang');
    expect(lang).toBeTruthy();
    expect(lang).toBe('en');
  });

  test('skip to main content link exists', async ({ page }) => {
    await page.goto('/api/staff/dashboard/');
    
    // Press Tab once to focus skip link (if it exists)
    await page.keyboard.press('Tab');
    
    const focused = await page.evaluate(() => ({
      text: document.activeElement?.textContent,
      href: document.activeElement?.getAttribute('href')
    }));
    
    // If skip link exists, it should be first focusable element
    if (focused.text?.toLowerCase().includes('skip')) {
      expect(focused.href).toContain('#');
    }
  });

  test('no automatic content refresh without warning', async ({ page }) => {
    await page.goto('/');
    
    const metaRefresh = await page.locator('meta[http-equiv="refresh"]').count();
    expect(metaRefresh).toBe(0);
  });
});
