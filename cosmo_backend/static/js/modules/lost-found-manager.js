/**
 * Lost & Found - page behavior (no inline JS)
 */

export class LostFoundManager {
  constructor() {
    this.modal = document.getElementById('photoModal');
    this.modalImg = document.getElementById('modalPhoto');

    this.bindEvents();
  }

  bindEvents() {
    document.addEventListener('click', (event) => {
      const thumb = event.target.closest('.lost-found-photo-thumb');
      if (thumb) {
        const url = thumb.getAttribute('data-photo-url');
        if (url) {
          this.openPhotoModal(url);
        }
        return;
      }

      const markClaimed = event.target.closest('.js-mark-claimed');
      if (markClaimed) {
        const itemId = markClaimed.getAttribute('data-item-id');
        if (itemId) {
          this.markAsClaimed(itemId);
        }
        return;
      }

      // Close the modal when clicking the backdrop
      if (this.modal && event.target === this.modal) {
        this.closePhotoModal();
      }
    });

    document.addEventListener('keydown', (event) => {
      if (event.key === 'Escape') {
        this.closePhotoModal();
      }
    });
  }

  openPhotoModal(src) {
    if (!this.modal || !this.modalImg) return;

    this.modalImg.src = src;
    this.modal.classList.add('is-open');
    this.modal.setAttribute('aria-hidden', 'false');
  }

  closePhotoModal() {
    if (!this.modal) return;

    this.modal.classList.remove('is-open');
    this.modal.setAttribute('aria-hidden', 'true');

    if (this.modalImg) {
      this.modalImg.removeAttribute('src');
    }
  }

  markAsClaimed(itemId) {
    if (!window.confirm('Mark this item as claimed? This action cannot be undone.')) {
      return;
    }

    window.location.href = `/admin/api/lostfounditem/${itemId}/change/`;
  }
}
