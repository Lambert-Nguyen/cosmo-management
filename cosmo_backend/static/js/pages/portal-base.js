function qs(selector, root = document) {
  return root.querySelector(selector);
}

function setHidden(el, hidden) {
  if (!el) return;
  el.classList.toggle('hidden', hidden);
}

function setVisible(el, visible) {
  if (!el) return;
  el.classList.toggle('is-visible', visible);
}

function initMobileNav() {
  const navMenu = qs('#navMenu');
  const overlay = qs('#mobileOverlay');
  const toggle = qs('.mobile-nav-toggle');

  if (!navMenu || !overlay || !toggle) return;

  const close = () => {
    navMenu.classList.remove('active');
    overlay.classList.remove('active');
    toggle.setAttribute('aria-expanded', 'false');
  };

  const toggleNav = () => {
    const nextActive = !navMenu.classList.contains('active');
    navMenu.classList.toggle('active', nextActive);
    overlay.classList.toggle('active', nextActive);
    toggle.setAttribute('aria-expanded', nextActive ? 'true' : 'false');
  };

  document.addEventListener('click', (event) => {
    const target = event.target;

    if (target instanceof Element) {
      const actionEl = target.closest('[data-action]');
      const action = actionEl?.getAttribute('data-action');

      if (action === 'portal-toggle-nav') {
        event.preventDefault();
        toggleNav();
        return;
      }

      if (action === 'portal-close-nav') {
        event.preventDefault();
        close();
        return;
      }
    }

    if (navMenu.contains(target) || toggle.contains(target)) return;
    close();
  });

  window.addEventListener('resize', () => {
    if (window.innerWidth >= 768) {
      close();
    }
  });

  if ('ontouchstart' in window) {
    document.body.classList.add('touch-device');
  }
}

function initPortalSecretMessage() {
  const message = qs('#aristay-secret-message-portal');
  const overlay = qs('#secret-message-overlay-portal');
  const brandLogo = qs('.portal-brand-logo');

  if (!message || !overlay || !brandLogo) return;

  let clickCount = 0;
  let clickTimeout;
  let keySequence = [];

  const isDarkMode = () => document.documentElement.getAttribute('data-theme') === 'dark';

  const createThemeParticles = () => {
    const particleCount = isDarkMode() ? 15 : 25;
    const particleColor = isDarkMode() ? '#64748b' : '#ffffff';

    for (let i = 0; i < particleCount; i += 1) {
      const particle = document.createElement('div');
      particle.style.position = 'fixed';
      particle.style.width = '3px';
      particle.style.height = '3px';
      particle.style.background = particleColor;
      particle.style.borderRadius = '50%';
      particle.style.pointerEvents = 'none';
      particle.style.zIndex = '10001';
      particle.style.left = `${Math.random() * window.innerWidth}px`;
      particle.style.top = `${Math.random() * window.innerHeight}px`;
      particle.style.animation = 'particleFloat 3s ease-out forwards';
      particle.style.opacity = '0';

      document.body.appendChild(particle);

      window.setTimeout(() => {
        particle.remove();
      }, 3000);
    }
  };

  const show = () => {
    setHidden(message, false);
    setHidden(overlay, false);

    window.requestAnimationFrame(() => {
      setVisible(message, true);
      setVisible(overlay, true);
      createThemeParticles();
    });

    document.body.style.overflow = 'hidden';
  };

  const hide = () => {
    setVisible(message, false);
    setVisible(overlay, false);

    window.setTimeout(() => {
      setHidden(message, true);
      setHidden(overlay, true);
      document.body.style.overflow = 'auto';
    }, 400);
  };

  document.addEventListener('click', (event) => {
    const target = event.target;
    if (!(target instanceof Element)) return;

    const actionEl = target.closest('[data-action]');
    const action = actionEl?.getAttribute('data-action');

    if (action === 'portal-secret-close') {
      event.preventDefault();
      hide();
    }
  });

  brandLogo.addEventListener('click', (e) => {
    clickCount += 1;
    window.clearTimeout(clickTimeout);

    if (clickCount >= 5) {
      show();
      clickCount = 0;
      return;
    }

    clickTimeout = window.setTimeout(() => {
      clickCount = 0;
    }, 2000);
  });

  document.addEventListener('keydown', (e) => {
    keySequence.push(e.key.toLowerCase());
    if (keySequence.length > 8) keySequence.shift();

    const targetSequence = ['a', 'r', 'i', 's', 't', 'a', 'y'];
    if (keySequence.join('') === targetSequence.join('')) {
      show();
      keySequence = [];
    }
  });
}

document.addEventListener('DOMContentLoaded', () => {
  initMobileNav();
  initPortalSecretMessage();
});
