function initStaffLayoutSidebar() {
  const sidebar = document.getElementById('sidebar');
  const overlay = document.getElementById('sidebarOverlay');
  const toggle = document.getElementById('mobileNavToggle');
  const close = document.getElementById('sidebarClose');

  if (!sidebar) return;

  function openSidebar() {
    sidebar.classList.add('active');
    document.body.style.overflow = 'hidden';
  }

  function closeSidebar() {
    sidebar.classList.remove('active');
    document.body.style.overflow = '';
  }

  toggle?.addEventListener('click', openSidebar);
  close?.addEventListener('click', closeSidebar);
  overlay?.addEventListener('click', closeSidebar);

  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape' && sidebar.classList.contains('active')) {
      closeSidebar();
    }
  });
}

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initStaffLayoutSidebar);
} else {
  initStaffLayoutSidebar();
}
