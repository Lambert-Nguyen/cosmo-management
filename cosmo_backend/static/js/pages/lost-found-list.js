/**
 * Lost & Found List - Page Entry Point
 */

import { LostFoundManager } from '../modules/lost-found-manager.js';

function init() {
  // eslint-disable-next-line no-new
  new LostFoundManager();
}

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', init);
} else {
  init();
}
