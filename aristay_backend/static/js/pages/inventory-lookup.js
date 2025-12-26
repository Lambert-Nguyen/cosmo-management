/**
 * Inventory Lookup - Page Entry Point
 */

import { InventoryLookupManager } from '../modules/inventory-lookup-manager.js';

function init() {
  // eslint-disable-next-line no-new
  new InventoryLookupManager();
}

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', init);
} else {
  init();
}
