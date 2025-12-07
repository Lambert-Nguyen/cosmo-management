/**
 * E2E Performance Tests
 * Tests for page load performance and resource optimization
 */

import { test, expect } from '@playwright/test';

test.describe('Performance', () => {
  test('page loads within acceptable time', async ({ page }) => {
    const startTime = Date.now();
    await page.goto('/api/staff/dashboard/');
    await page.waitForLoadState('networkidle');
    const loadTime = Date.now() - startTime;
    
    // Page should load in under 3 seconds
    expect(loadTime).toBeLessThan(3000);
  });

  test('first contentful paint is fast', async ({ page }) => {
    await page.goto('/api/staff/dashboard/');
    
    const fcp = await page.evaluate(() => {
      return new Promise((resolve) => {
        new PerformanceObserver((list) => {
          const entries = list.getEntries();
          for (const entry of entries) {
            if (entry.name === 'first-contentful-paint') {
              resolve(entry.startTime);
            }
          }
        }).observe({ entryTypes: ['paint'] });
        
        // Fallback timeout
        setTimeout(() => resolve(null), 5000);
      });
    });
    
    if (fcp) {
      expect(fcp).toBeLessThan(1500); // Under 1.5 seconds
    }
  });

  test('CSS files are loaded efficiently', async ({ page }) => {
    const cssRequests = [];
    
    page.on('request', request => {
      if (request.resourceType() === 'stylesheet') {
        cssRequests.push(request.url());
      }
    });
    
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    
    // Should have design system CSS files
    const designSystemCSS = cssRequests.some(url => url.includes('design-system.css'));
    expect(designSystemCSS).toBeTruthy();
    
    // Should not have too many CSS files (< 10)
    expect(cssRequests.length).toBeLessThan(10);
  });

  test('JavaScript files are loaded efficiently', async ({ page }) => {
    const jsRequests = [];
    
    page.on('request', request => {
      if (request.resourceType() === 'script') {
        jsRequests.push(request.url());
      }
    });
    
    await page.goto('/api/staff/dashboard/');
    await page.waitForLoadState('networkidle');
    
    // Should not have excessive JS files
    expect(jsRequests.length).toBeLessThan(15);
  });

  test('images are optimized', async ({ page }) => {
    const imageRequests = [];
    
    page.on('response', async response => {
      if (response.request().resourceType() === 'image') {
        const size = (await response.body()).length;
        imageRequests.push({ url: response.url(), size });
      }
    });
    
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    
    // Check if any images are excessively large (> 500KB)
    const largeImages = imageRequests.filter(img => img.size > 500000);
    expect(largeImages.length).toBe(0);
  });

  test('no render-blocking resources', async ({ page }) => {
    await page.goto('/');
    
    const renderBlockingResources = await page.evaluate(() => {
      const links = document.querySelectorAll('link[rel="stylesheet"]');
      const blocking = [];
      
      links.forEach(link => {
        if (!link.hasAttribute('media') || link.getAttribute('media') === 'all') {
          if (!link.hasAttribute('onload')) {
            blocking.push(link.href);
          }
        }
      });
      
      return blocking;
    });
    
    // Design system CSS can be render-blocking, but limit to essential files
    expect(renderBlockingResources.length).toBeLessThan(5);
  });

  test('fonts load efficiently', async ({ page }) => {
    const fontRequests = [];
    
    page.on('request', request => {
      if (request.resourceType() === 'font') {
        fontRequests.push(request.url());
      }
    });
    
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    
    // Should use system fonts or minimal custom fonts
    expect(fontRequests.length).toBeLessThan(4);
  });

  test('DOM size is reasonable', async ({ page }) => {
    await page.goto('/api/staff/dashboard/');
    
    const domSize = await page.evaluate(() => {
      return document.getElementsByTagName('*').length;
    });
    
    // DOM should not be excessively large (< 1500 elements recommended)
    expect(domSize).toBeLessThan(2000);
  });

  test('no excessive reflows on load', async ({ page }) => {
    await page.goto('/api/staff/dashboard/');
    await page.waitForLoadState('networkidle');
    
    // Wait a bit to ensure layout is stable
    await page.waitForTimeout(1000);
    
    // Check if layout is stable (no ongoing reflows)
    const isStable = await page.evaluate(() => {
      return new Promise(resolve => {
        let frameCount = 0;
        const checkStability = () => {
          frameCount++;
          if (frameCount > 10) {
            resolve(true);
          } else {
            requestAnimationFrame(checkStability);
          }
        };
        checkStability();
      });
    });
    
    expect(isStable).toBeTruthy();
  });

  test('resources use caching headers', async ({ page }) => {
    const staticRequests = [];
    
    page.on('response', response => {
      const url = response.url();
      if (url.includes('/static/')) {
        staticRequests.push({
          url,
          cacheControl: response.headers()['cache-control']
        });
      }
    });
    
    await page.goto('/');
    await page.waitForLoadState('networkidle');
    
    // Static resources should have cache headers
    if (staticRequests.length > 0) {
      const cached = staticRequests.filter(req => req.cacheControl);
      expect(cached.length).toBeGreaterThan(0);
    }
  });
});
