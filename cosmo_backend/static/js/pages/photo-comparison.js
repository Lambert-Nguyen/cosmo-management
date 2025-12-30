/**
 * Photo Comparison Page
 * Handles before/after photo comparison for tasks
 */

class PhotoComparison {
    constructor(taskId) {
        this.taskId = taskId;
        this.allPhotos = [];
        this.filteredPhotos = [];
        this.initializeElements();
        this.attachEventListeners();
        this.loadPhotos();
    }

    initializeElements() {
        this.statusFilter = document.getElementById('status-filter');
        this.typeFilter = document.getElementById('type-filter');
        this.beforePhotos = document.getElementById('before-photos');
        this.afterPhotos = document.getElementById('after-photos');
        this.otherPhotos = document.getElementById('other-photos');
        this.beforeCount = document.getElementById('before-count');
        this.afterCount = document.getElementById('after-count');
        this.otherCount = document.getElementById('other-count');
        this.modal = document.getElementById('photo-modal');
        this.modalImage = document.getElementById('modal-image');
        this.modalTitle = document.getElementById('modal-title');
        this.modalMeta = document.getElementById('modal-meta');
        this.modalDescription = document.getElementById('modal-description');
    }

    attachEventListeners() {
        this.statusFilter.addEventListener('change', () => this.applyFilters());
        this.typeFilter.addEventListener('change', () => this.applyFilters());

        // Close modal when clicking outside
        this.modal.addEventListener('click', (e) => {
            if (e.target === this.modal) {
                this.closeModal();
            }
        });
    }

    async loadPhotos() {
        try {
            const response = await fetch(`/api/tasks/${this.taskId}/images/`);
            const data = await response.json();
            console.log('API Response:', data);

            // Handle different response structures
            if (Array.isArray(data)) {
                this.allPhotos = data;
            } else if (data.results && Array.isArray(data.results)) {
                this.allPhotos = data.results;
            } else if (data.data && Array.isArray(data.data)) {
                this.allPhotos = data.data;
            } else {
                console.error('Unexpected API response structure:', data);
                this.allPhotos = [];
            }

            console.log('Processed photos:', this.allPhotos);
            this.applyFilters();
        } catch (error) {
            console.error('Error loading photos:', error);
            this.allPhotos = [];
        }
    }

    applyFilters() {
        // Safety check
        if (!Array.isArray(this.allPhotos)) {
            console.error('allPhotos is not an array:', this.allPhotos);
            this.allPhotos = [];
            return;
        }

        const statusFilter = this.statusFilter.value;
        const typeFilter = this.typeFilter.value;

        this.filteredPhotos = this.allPhotos.filter(photo => {
            const statusMatch = !statusFilter || photo.photo_status === statusFilter;
            const typeMatch = !typeFilter || photo.photo_type === typeFilter;
            return statusMatch && typeMatch;
        });

        this.renderPhotos();
    }

    renderPhotos() {
        const beforePhotos = this.filteredPhotos.filter(p => p.photo_type === 'before');
        const afterPhotos = this.filteredPhotos.filter(p => p.photo_type === 'after');
        const otherPhotos = this.filteredPhotos.filter(p => !['before', 'after'].includes(p.photo_type));

        this.renderPhotoSection(this.beforePhotos, beforePhotos);
        this.renderPhotoSection(this.afterPhotos, afterPhotos);
        this.renderPhotoSection(this.otherPhotos, otherPhotos);

        this.beforeCount.textContent = beforePhotos.length;
        this.afterCount.textContent = afterPhotos.length;
        this.otherCount.textContent = otherPhotos.length;
    }

    renderPhotoSection(container, photos) {
        container.innerHTML = '';

        if (photos.length === 0) {
            container.innerHTML = `
                <div class="no-photos">
                    <div class="no-photos-icon">📷</div>
                    <div>No photos found</div>
                </div>
            `;
            return;
        }

        photos.forEach(photo => {
            const photoCard = this.createPhotoCard(photo);
            container.appendChild(photoCard);
        });
    }

    createPhotoCard(photo) {
        const card = document.createElement('div');
        card.className = `photo-card ${photo.is_primary ? 'primary' : ''}`;

        const statusClass = `status-${photo.photo_status}`;
        const uploadedDate = new Date(photo.uploaded_at).toLocaleDateString();

        card.innerHTML = `
            <img src="${photo.image}" class="photo-image" alt="${photo.description || 'Photo'}">
            <div class="photo-overlay">
                <div class="photo-status ${statusClass}">${photo.photo_status}</div>
                <div class="photo-actions">
                    <button class="photo-action-btn" data-action="view-photo" title="View Full Size">🔍</button>
                </div>
            </div>
            <div class="photo-info">
                <div>${photo.photo_type_display} #${photo.sequence_number}</div>
                <div class="photo-description">${photo.description || 'No description'}</div>
            </div>
            ${photo.is_primary ? '<div class="primary-badge">Primary</div>' : ''}
        `;

        // Add event listener for view button
        const viewBtn = card.querySelector('[data-action="view-photo"]');
        viewBtn.addEventListener('click', (e) => {
            e.stopPropagation();
            this.openModal(photo.image, photo.photo_type_display, photo.uploaded_at, photo.description || '');
        });

        // Add event listener for card click
        card.addEventListener('click', () => {
            this.openModal(photo.image, photo.photo_type_display, photo.uploaded_at, photo.description || '');
        });

        return card;
    }

    openModal(imageSrc, title, uploadedAt, description) {
        this.modalImage.src = imageSrc;
        this.modalTitle.textContent = title;
        this.modalMeta.textContent = `Uploaded: ${new Date(uploadedAt).toLocaleString()}`;
        this.modalDescription.textContent = description || 'No description provided';
        this.modal.style.display = 'block';
        document.body.style.overflow = 'hidden';
    }

    closeModal() {
        this.modal.style.display = 'none';
        document.body.style.overflow = 'auto';
    }
}

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
    // Get task ID from template context
    if (typeof TASK_ID !== 'undefined') {
        window.photoComparison = new PhotoComparison(TASK_ID);
    }
});

// Global function for modal close (for onclick attribute if needed)
function closeModal() {
    if (window.photoComparison) {
        window.photoComparison.closeModal();
    }
}
