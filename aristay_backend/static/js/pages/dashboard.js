/**
 * Staff Dashboard - Page Entry Point
 */

import { DashboardManager } from '../modules/dashboard-manager.js';

function init() {
  // eslint-disable-next-line no-new
  new DashboardManager();
}

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', init);
} else {
  init();
}
