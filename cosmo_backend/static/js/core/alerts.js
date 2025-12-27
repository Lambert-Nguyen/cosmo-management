function initAlerts() {
  // Auto-dismiss alerts after 5 seconds
  document.querySelectorAll('.alert').forEach((alert) => {
    window.setTimeout(() => {
      alert.classList.add('fade-out');
      window.setTimeout(() => alert.remove(), 300);
    }, 5000);
  });

  // Manual close
  document.querySelectorAll('.alert-close').forEach((btn) => {
    btn.addEventListener('click', () => {
      const alert = btn.closest('.alert');
      if (!alert) return;
      alert.classList.add('fade-out');
      window.setTimeout(() => alert.remove(), 300);
    });
  });
}

document.addEventListener('DOMContentLoaded', initAlerts);
