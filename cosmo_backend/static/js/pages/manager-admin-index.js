function setHidden(element, hidden) {
  if (!element) return;
  element.classList.toggle('is-hidden', hidden);
}

function getManagerAdminConfig() {
  const el = document.getElementById('managerAdminConfig');
  return {
    authToken: el?.dataset?.authToken || '',
  };
}

function createSparkleEffect() {
  const sparkleCount = 20;
  for (let i = 0; i < sparkleCount; i++) {
    const sparkle = document.createElement('div');
    sparkle.className = 'ma-sparkle';
    sparkle.style.left = `${Math.random() * window.innerWidth}px`;
    sparkle.style.top = `${Math.random() * window.innerHeight}px`;

    document.body.appendChild(sparkle);

    window.setTimeout(() => {
      sparkle.remove();
    }, 2000);
  }
}

function initSecretMessageManager() {
  const message = document.getElementById(useId('cosmo-secret-message-manager'));
  const overlay = document.getElementById(useId('secret-message-overlay-manager'));
  const welcomeLogo = document.querySelector('.welcome-logo');

  function show() {
    if (!message || !overlay) return;

    setHidden(message, false);
    setHidden(overlay, false);

    // trigger transition
    requestAnimationFrame(() => {
      message.classList.add('is-visible');
      overlay.classList.add('is-visible');
      createSparkleEffect();
    });

    document.body.classList.add('ma-no-scroll');
  }

  function hide() {
    if (!message || !overlay) return;

    message.classList.remove('is-visible');
    overlay.classList.remove('is-visible');

    window.setTimeout(() => {
      setHidden(message, true);
      setHidden(overlay, true);
      document.body.classList.remove('ma-no-scroll');
    }, 400);
  }

  // public actions
  window.__managerAdminSecretShow = show;
  window.__managerAdminSecretHide = hide;

  if (welcomeLogo) {
    welcomeLogo.addEventListener('dblclick', (e) => {
      e.preventDefault();
      show();
    });
  }

  // keyboard sequence: "cosmo"
  const targetSequence = ['c', 'o', 's', 'm', 'o'];
  let seq = [];
  document.addEventListener('keydown', (e) => {
    seq.push(String(e.key || '').toLowerCase());
    if (seq.length > targetSequence.length) seq.shift();
    if (seq.join('') === targetSequence.join('')) {
      show();
      seq = [];
    }
  });

  // click outside closes
  overlay?.addEventListener('click', hide);

  return { show, hide };
}

function useId(id) {
  return id;
}

function initSideMenu() {
  const menuToggle = document.getElementById('menu-toggle');
  const sideMenu = document.getElementById('side-menu');
  const closeMenu = document.getElementById('close-menu');
  const overlay = document.getElementById('menu-overlay');

  if (!menuToggle || !sideMenu || !closeMenu || !overlay) {
    return;
  }

  function openMenu() {
    sideMenu.classList.add('is-open');
    overlay.classList.add('is-visible');
    document.body.classList.add('ma-no-scroll');
  }

  function closeMenuFn() {
    sideMenu.classList.remove('is-open');
    overlay.classList.remove('is-visible');
    document.body.classList.remove('ma-no-scroll');
  }

  menuToggle.addEventListener('click', openMenu);
  closeMenu.addEventListener('click', closeMenuFn);
  overlay.addEventListener('click', closeMenuFn);

  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') closeMenuFn();
  });

  return { openMenu, closeMenu: closeMenuFn };
}

async function fetchFileCleanupStats() {
  const { authToken } = getManagerAdminConfig();
  const headers = { 'Content-Type': 'application/json' };
  if (authToken) headers.Authorization = `Token ${authToken}`;

  const response = await fetch('/api/file-cleanup/api/', {
    method: 'GET',
    headers,
    credentials: 'same-origin',
  });

  return response.json();
}

async function postFileCleanupAction(action, days) {
  const { authToken } = getManagerAdminConfig();
  const headers = {};
  if (authToken) headers.Authorization = `Token ${authToken}`;

  const formData = new FormData();
  formData.append('action', action);
  formData.append('days', String(days));

  const response = await fetch('/api/file-cleanup/api/', {
    method: 'POST',
    headers,
    credentials: 'same-origin',
    body: formData,
  });

  return response.json();
}

function initFileCleanupModal() {
  const modal = document.getElementById('fileCleanupModal');
  const content = document.getElementById('fileCleanupContent');

  function openModal() {
    setHidden(modal, false);
  }

  function closeModal() {
    setHidden(modal, true);
  }

  function renderError(message) {
    if (!content) return;
    content.innerHTML = `<p class="ma-filecleanup-error">Error: ${message}</p>`;
  }

  function renderStats(stats) {
    if (!content) return;
    content.innerHTML = `
      <h3>📊 Storage Statistics</h3>
      <div class="ma-filecleanup-box">
        <p><strong>Total Files:</strong> ${stats.total_files}</p>
        <p><strong>Total Size:</strong> ${stats.total_size_mb} MB (${stats.total_size_gb} GB)</p>
        <p><strong>Date Range:</strong> ${stats.oldest_file || 'N/A'} to ${stats.newest_file || 'N/A'}</p>
        <p><strong>Age Span:</strong> ${stats.age_span_days} days</p>
      </div>
      <button type="button" data-action="manager-file-cleanup-options" class="btn-small">🧹 Show Cleanup Options</button>
    `;
  }

  function renderOptions() {
    if (!content) return;
    content.innerHTML = `
      <h3>🧹 File Cleanup Options</h3>
      <div class="ma-filecleanup-box">
        <p><strong>Time-based Cleanup:</strong></p>
        <button type="button" data-action="manager-file-cleanup-run" data-days="30" data-dry-run="true" class="btn-small">🔍 Preview: Keep 30 days</button>
        <button type="button" data-action="manager-file-cleanup-run" data-days="7" data-dry-run="true" class="btn-small">🔍 Preview: Keep 7 days</button>
        <br><br>
        <button type="button" data-action="manager-file-cleanup-run" data-days="30" data-dry-run="false" class="btn-small btn-danger">🗑️ Delete files older than 30 days</button>
        <button type="button" data-action="manager-file-cleanup-run" data-days="7" data-dry-run="false" class="btn-small btn-danger">🗑️ Delete files older than 7 days</button>
      </div>
      <button type="button" data-action="manager-file-cleanup-stats" class="btn-small">📊 Back to Stats</button>
    `;
  }

  function renderResult(result, dryRun) {
    if (!content) return;
    const files = result.files_deleted || result.files_found || 0;
    const space = result.space_freed_mb || result.total_size_mb || 0;
    const errors = Array.isArray(result.errors) ? result.errors.length : 0;

    content.innerHTML = `
      <h3>${dryRun ? '🔍 Cleanup Preview' : '✅ Cleanup Complete'}</h3>
      <div class="ma-filecleanup-box">
        <p><strong>Files ${dryRun ? 'that would be ' : ''}deleted:</strong> ${files}</p>
        <p><strong>Space ${dryRun ? 'that would be ' : ''}freed:</strong> ${space} MB</p>
        <p><strong>Cutoff date:</strong> ${result.cutoff_date}</p>
        ${errors > 0 ? `<p class="ma-filecleanup-error"><strong>Errors:</strong> ${errors}</p>` : ''}
      </div>
      <button type="button" data-action="manager-file-cleanup-options" class="btn-small">🔙 Back to Options</button>
      <button type="button" data-action="manager-file-cleanup-stats" class="btn-small">📊 Show Stats</button>
    `;
  }

  async function showFileStats() {
    if (!content) return;
    openModal();
    content.innerHTML = '<p>Loading storage statistics...</p>';

    try {
      const data = await fetchFileCleanupStats();
      if (data.success) {
        renderStats(data.stats);
      } else {
        renderError(data.error || 'Unknown error');
      }
    } catch (error) {
      renderError(error?.message || 'Network error');
    }
  }

  async function performCleanup(days, dryRun) {
    if (!content) return;
    const action = dryRun ? 'dry_run' : 'cleanup';
    const actionText = dryRun ? 'Previewing' : 'Performing';

    content.innerHTML = `<p>${actionText} cleanup for files older than ${days} days...</p>`;

    try {
      const data = await postFileCleanupAction(action, days);
      if (data.success) {
        renderResult(data.result, dryRun);
      } else {
        renderError(data.error || 'Unknown error');
      }
    } catch (error) {
      renderError(error?.message || 'Network error');
    }
  }

  // close on click outside
  modal?.addEventListener('click', (e) => {
    if (e.target === modal) closeModal();
  });

  return { showFileStats, renderOptions, performCleanup, closeModal };
}

function initCurrentTimeTicker() {
  const el = document.getElementById('current-time');
  if (!el) return;

  const update = () => {
    const now = new Date();
    const options = {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
    };
    el.textContent = now.toLocaleDateString('en-US', options);
  };

  update();
  window.setInterval(update, 60000);
}

function initManagerAdminIndex() {
  const secret = initSecretMessageManager();
  initSideMenu();
  const fileCleanup = initFileCleanupModal();
  initCurrentTimeTicker();

  document.addEventListener('click', (e) => {
    const target = e.target;
    const actionEl = target instanceof Element ? target.closest('[data-action]') : null;
    if (!actionEl) return;

    const action = actionEl.getAttribute('data-action');

    if (action === 'manager-secret-close') {
      secret?.hide?.();
      return;
    }

    if (action === 'manager-file-cleanup-stats') {
      fileCleanup?.showFileStats?.();
      return;
    }

    if (action === 'manager-file-cleanup-options') {
      fileCleanup?.renderOptions?.();
      return;
    }

    if (action === 'manager-file-cleanup-run') {
      const days = Number(actionEl.getAttribute('data-days') || '0');
      const dryRun = (actionEl.getAttribute('data-dry-run') || '') === 'true';
      if (days > 0) fileCleanup?.performCleanup?.(days, dryRun);
      return;
    }

    if (action === 'manager-file-cleanup-close') {
      fileCleanup?.closeModal?.();
    }
  });
}

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initManagerAdminIndex);
} else {
  initManagerAdminIndex();
}
