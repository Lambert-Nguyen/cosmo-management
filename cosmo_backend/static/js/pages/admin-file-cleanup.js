function callGlobal(name, ...args) {
  const fn = window[name];
  if (typeof fn !== 'function') {
    console.warn(`[admin-file-cleanup] Missing function: ${name}`);
    return;
  }
  return fn(...args);
}

function onClick(actionHandlers) {
  document.addEventListener('click', (e) => {
    const target = e.target instanceof Element ? e.target.closest('[data-action]') : null;
    if (!target) return;

    const action = target.getAttribute('data-action');
    const handler = action ? actionHandlers[action] : undefined;
    if (!handler) return;

    e.preventDefault();
    handler(target);
  });
}

document.addEventListener('DOMContentLoaded', () => {
  onClick({
    'file-cleanup-stats': () => callGlobal('getStorageStats'),
    'file-cleanup-suggestions': () => callGlobal('getSuggestions'),
    'file-cleanup-dry-run': () => callGlobal('runDryRun'),
    'file-cleanup-confirm': () => callGlobal('confirmCleanup'),
    'file-cleanup-hide-results': () => callGlobal('hideResults'),
    'file-cleanup-hide-confirmation': () => callGlobal('hideConfirmation'),
    'file-cleanup-perform': () => callGlobal('performCleanup'),
  });
});
