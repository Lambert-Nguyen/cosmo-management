function getTheme() {
  const key = 'aristay-theme';
  const saved = localStorage.getItem(key);
  if (saved === 'dark' || saved === 'light') return saved;
  return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
}

function setTheme(theme) {
  const key = 'aristay-theme';
  document.documentElement.setAttribute('data-theme', theme);
  localStorage.setItem(key, theme);

  const btn = document.getElementById('theme-toggle');
  if (btn) {
    btn.classList.toggle('dark', theme === 'dark');
    btn.setAttribute('aria-pressed', theme === 'dark');
    btn.setAttribute('aria-label', theme === 'dark' ? 'Switch to light mode' : 'Switch to dark mode');
  }

  document.dispatchEvent(new CustomEvent('themeChanged', { detail: { theme } }));
}

function syncThemeSwitch(theme) {
  const input = document.getElementById('theme-toggle-switch');
  const thumb = document.getElementById('theme-toggle-thumb');
  if (!input || !thumb) return;

  const isDark = theme === 'dark';
  input.checked = isDark;
  input.style.background = isDark ? 'rgba(99,102,241,0.85)' : 'rgba(255,255,255,0.35)';
  thumb.style.transform = isDark ? 'translateX(20px)' : 'translateX(0)';
}

function initMenu() {
  const menuToggle = document.getElementById('menu-toggle');
  const sideMenu = document.getElementById('side-menu');
  const closeMenu = document.getElementById('close-menu');
  const overlay = document.getElementById('menu-overlay');

  if (!menuToggle || !sideMenu || !closeMenu || !overlay) return;

  const open = () => {
    sideMenu.classList.add('is-open');
    overlay.classList.add('is-visible');
    document.body.style.overflow = 'hidden';
  };

  const close = () => {
    sideMenu.classList.remove('is-open');
    overlay.classList.remove('is-visible');
    document.body.style.overflow = 'auto';
  };

  menuToggle.addEventListener('click', open);
  closeMenu.addEventListener('click', close);
  overlay.addEventListener('click', close);
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') close();
  });
}

function initSecretMessage() {
  const message = document.getElementById('aristay-secret-message');
  const overlay = document.getElementById('secret-message-overlay');
  const closeBtn = document.querySelector('[data-action="admin-secret-close"]');
  const logo = document.getElementById('adminHeaderLogo');

  if (!message || !overlay || !logo) return;

  let clickCount = 0;
  let clickTimeout;

  const show = () => {
    message.classList.remove('is-hidden');
    overlay.classList.remove('is-hidden');

    requestAnimationFrame(() => {
      message.classList.add('is-active');
      overlay.classList.add('is-visible');
    });

    document.body.style.overflow = 'hidden';
  };

  const hide = () => {
    message.classList.remove('is-active');
    overlay.classList.remove('is-visible');

    window.setTimeout(() => {
      message.classList.add('is-hidden');
      overlay.classList.add('is-hidden');
      document.body.style.overflow = 'auto';
    }, 300);
  };

  logo.addEventListener('click', (e) => {
    e.preventDefault();

    clickCount += 1;
    window.clearTimeout(clickTimeout);

    if (clickCount >= 7) {
      show();
      clickCount = 0;
    } else {
      clickTimeout = window.setTimeout(() => {
        clickCount = 0;
      }, 2000);
    }
  });

  if (closeBtn) closeBtn.addEventListener('click', hide);
  overlay.addEventListener('click', hide);

  // Konami code
  const konamiSequence = [38, 38, 40, 40, 37, 39, 37, 39, 66, 65];
  const buffer = [];

  document.addEventListener('keydown', (e) => {
    buffer.push(e.keyCode);
    if (buffer.length > konamiSequence.length) buffer.shift();

    if (buffer.join(',') === konamiSequence.join(',')) {
      show();
      buffer.length = 0;
    }
  });
}

function initThemeSwitch() {
  const input = document.getElementById('theme-toggle-switch');
  if (!input) return;

  const apply = (theme) => {
    setTheme(theme);
    syncThemeSwitch(theme);
  };

  const current = getTheme();
  apply(current);

  input.addEventListener('change', () => {
    apply(input.checked ? 'dark' : 'light');
  });

  document.addEventListener('themeChanged', (e) => {
    const theme = e?.detail?.theme;
    if (theme === 'dark' || theme === 'light') {
      syncThemeSwitch(theme);
    }
  });
}

document.addEventListener('DOMContentLoaded', () => {
  initMenu();
  initThemeSwitch();
  initSecretMessage();
});
