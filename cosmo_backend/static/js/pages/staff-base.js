function getCsrfToken() {
  const el = document.querySelector('meta[name="csrf-token"]');
  return el ? el.getAttribute('content') : null;
}

function initTableContainers() {
  const tables = document.querySelectorAll('table');
  tables.forEach((table) => {
    if (table.parentElement) {
      table.parentElement.classList.add('table-container');
    }
  });
}

function initMobileNav() {
  const navLinks = document.getElementById('navLinks');
  const overlay = document.getElementById('mobileOverlay');
  const quickActionBar = document.getElementById('quickActionBar');
  const toggle = document.getElementById('mobileNavToggle');

  if (!navLinks || !overlay || !quickActionBar || !toggle) return;

  function setQuickActionBarOpen(isOpen) {
    if (isOpen) {
      quickActionBar.style.display = 'flex';
      window.setTimeout(() => {
        quickActionBar.style.opacity = '1';
        quickActionBar.style.transform = 'translateY(0)';
      }, 10);
    } else {
      quickActionBar.style.opacity = '0';
      quickActionBar.style.transform = 'translateY(-100%)';
      window.setTimeout(() => {
        quickActionBar.style.display = 'none';
      }, 300);
    }
  }

  function openMobileNav() {
    navLinks.classList.add('active');
    overlay.classList.add('active');
    quickActionBar.classList.add('active');
    setQuickActionBarOpen(true);
  }

  function closeMobileNav() {
    navLinks.classList.remove('active');
    overlay.classList.remove('active');
    quickActionBar.classList.remove('active');
    setQuickActionBarOpen(false);
  }

  function toggleMobileNav() {
    const willOpen = !navLinks.classList.contains('active');
    if (willOpen) openMobileNav();
    else closeMobileNav();
  }

  toggle.addEventListener('click', toggleMobileNav);
  overlay.addEventListener('click', closeMobileNav);

  // Close mobile nav when clicking outside
  document.addEventListener('click', (event) => {
    if (navLinks.contains(event.target) || toggle.contains(event.target)) return;
    closeMobileNav();
  });

  // Handle window resize
  window.addEventListener('resize', () => {
    if (window.innerWidth >= 768) {
      closeMobileNav();
    }
  });

  // Auto-hide quick action bar on scroll
  let lastScrollTop = 0;
  window.addEventListener('scroll', () => {
    const currentScrollTop = window.pageYOffset || document.documentElement.scrollTop;

    if (currentScrollTop > lastScrollTop && currentScrollTop > 100) {
      quickActionBar.style.transform = 'translateY(-100%)';
    } else {
      quickActionBar.style.transform = 'translateY(0)';
    }

    lastScrollTop = currentScrollTop;
  });

  return { toggleMobileNav, closeMobileNav, isOpen: () => navLinks.classList.contains('active') };
}

function initSecretMessage() {
  const message = document.getElementById('cosmo-secret-message-staff');
  const overlay = document.getElementById('secret-message-overlay-staff');
  const closeBtn = document.querySelector('.js-secret-message-staff-close');
  const logo = document.querySelector('.logo');

  if (!message || !overlay || !logo) return;

  let clickCount = 0;
  let clickTimeout;
  let swipeCount = 0;
  let swipeResetTimeout;

  function show() {
    message.style.display = 'block';
    overlay.style.display = 'block';

    window.setTimeout(() => {
      message.classList.add('is-visible');
      overlay.classList.add('is-visible');

      if (navigator.vibrate) {
        navigator.vibrate([100, 50, 100]);
      }
    }, 50);

    message.setAttribute('aria-hidden', 'false');
    document.body.style.overflow = 'hidden';
  }

  function hide() {
    message.classList.remove('is-visible');
    overlay.classList.remove('is-visible');

    window.setTimeout(() => {
      message.style.display = 'none';
      overlay.style.display = 'none';
      message.setAttribute('aria-hidden', 'true');
      document.body.style.overflow = 'auto';
    }, 300);
  }

  closeBtn?.addEventListener('click', hide);

  // Close on overlay tap (mobile-friendly)
  overlay.addEventListener('click', hide);

  // Mobile activation - long press on logo
  let pressTimer;
  logo.addEventListener('touchstart', () => {
    pressTimer = window.setTimeout(show, 2000);
  });

  const clearPressTimer = () => {
    if (pressTimer) window.clearTimeout(pressTimer);
  };

  logo.addEventListener('touchend', clearPressTimer);
  logo.addEventListener('touchmove', clearPressTimer);

  // Desktop fallback - triple click
  logo.addEventListener('click', () => {
    clickCount += 1;
    window.clearTimeout(clickTimeout);

    if (clickCount >= 3) {
      show();
      clickCount = 0;
      return;
    }

    clickTimeout = window.setTimeout(() => {
      clickCount = 0;
    }, 1000);
  });

  // Handle orientation change
  window.addEventListener('orientationchange', () => {
    window.setTimeout(() => {
      if (message.style.display === 'block') {
        message.classList.add('is-visible');
      }
    }, 100);
  });

  return {
    handleTouchGesture: ({ startX, startY, endX, endY }) => {
      const diffX = endX - startX;
      const diffY = endY - startY;

      // Detect diagonal swipe (top-left to bottom-right)
      if (Math.abs(diffX) > 100 && Math.abs(diffY) > 100 && diffX > 0 && diffY > 0) {
        swipeCount += 1;
        if (swipeCount >= 3) {
          show();
          swipeCount = 0;
        }

        window.clearTimeout(swipeResetTimeout);
        swipeResetTimeout = window.setTimeout(() => {
          swipeCount = 0;
        }, 3000);
      }
    },
    hide,
  };
}

function initTouchDeviceClass() {
  if ('ontouchstart' in window) {
    document.body.classList.add('touch-device');
  }
}

function initProgressFills() {
  const fills = document.querySelectorAll('.progress-fill[data-progress]');
  fills.forEach((fill) => {
    const raw = fill.getAttribute('data-progress');
    const value = Number.parseFloat(raw);
    if (!Number.isFinite(value)) return;
    const clamped = Math.max(0, Math.min(100, value));
    fill.style.width = `${clamped}%`;
  });
}

function initStaffBase() {
  // Backwards-compatible global helper
  window.getCsrfToken = getCsrfToken;

  initTouchDeviceClass();
  initTableContainers();
  initProgressFills();

  const mobileNav = initMobileNav();
  const secret = initSecretMessage();

  // Unified swipe handling: menu open/close + secret gesture
  let touchStartX = 0;
  let touchStartY = 0;

  document.addEventListener(
    'touchstart',
    (e) => {
      touchStartX = e.touches[0].clientX;
      touchStartY = e.touches[0].clientY;
    },
    { passive: true }
  );

  document.addEventListener(
    'touchend',
    (e) => {
      const touchEndX = e.changedTouches[0].clientX;
      const touchEndY = e.changedTouches[0].clientY;
      const diffX = touchEndX - touchStartX;
      const diffY = touchEndY - touchStartY;

      // Swipe right to open menu (if on left edge)
      if (mobileNav && diffX > 50 && Math.abs(diffY) < 50 && touchStartX < 50) {
        mobileNav.toggleMobileNav();
      }

      // Swipe left to close menu (if menu is open)
      if (mobileNav && diffX < -50 && Math.abs(diffY) < 50 && mobileNav.isOpen()) {
        mobileNav.closeMobileNav();
      }

      secret?.handleTouchGesture({
        startX: touchStartX,
        startY: touchStartY,
        endX: touchEndX,
        endY: touchEndY,
      });
    },
    { passive: true }
  );
}

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initStaffBase);
} else {
  initStaffBase();
}
