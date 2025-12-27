function initProgressBars() {
  document.querySelectorAll('[data-progress]')
    .forEach((bar) => {
      const raw = bar.getAttribute('data-progress') || '0';
      const value = Math.max(0, Math.min(100, Number(raw)));
      if (Number.isFinite(value)) {
        bar.style.width = `${value}%`;
      }
    });
}

function openPhotoModal(src) {
  const modal = document.getElementById('photoModal');
  const modalPhoto = document.getElementById('modalPhoto');
  if (!modal || !modalPhoto) return;

  modalPhoto.src = src;
  modal.classList.remove('hidden');
}

function closePhotoModal() {
  const modal = document.getElementById('photoModal');
  if (!modal) return;
  modal.classList.add('hidden');
}

document.addEventListener('DOMContentLoaded', () => {
  initProgressBars();

  document.addEventListener('click', (e) => {
    const target = e.target;
    if (!(target instanceof Element)) return;

    const openBtn = target.closest('[data-action="portal-open-photo"]');
    if (openBtn) {
      const src = openBtn.getAttribute('data-photo-src') || '';
      if (src) openPhotoModal(src);
      return;
    }

    const closeBtn = target.closest('[data-action="portal-close-photo"]');
    if (closeBtn) {
      closePhotoModal();
    }
  });

  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') closePhotoModal();
  });
});
