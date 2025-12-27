function applyProgressWidths() {
  document.querySelectorAll('.progress-fill[data-progress]').forEach((el) => {
    const raw = el.getAttribute('data-progress');
    const value = Number.parseFloat(raw ?? '0');
    const progress = Number.isFinite(value) ? Math.max(0, Math.min(100, value)) : 0;
    el.style.width = `${progress}%`;
  });
}

window.addEventListener('DOMContentLoaded', () => {
  applyProgressWidths();
});
