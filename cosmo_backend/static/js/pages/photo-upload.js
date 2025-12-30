/**
 * Photo Upload Page
 * Handles photo upload, preview, and management for tasks
 */

function getCsrfToken() {
    const el = document.querySelector('[name=csrfmiddlewaretoken]');
    return el ? el.value : (window.CSRF_TOKEN || '');
}

class PhotoUploader {
    constructor() {
        this.selectedFiles = [];
        this.selectedTask = null;
        this.initializeElements();
        this.attachEventListeners();
        this.initializeSelectedTask();
    }

    initializeElements() {
        this.uploadArea = document.getElementById('upload-area');
        this.uploadZone = document.getElementById('upload-zone');
        this.fileInput = document.getElementById('file-input');
        this.previewGrid = document.getElementById('photo-preview-grid');
        this.uploadActions = document.getElementById('upload-actions');
        this.uploadBtn = document.getElementById('upload-btn');
        this.clearBtn = document.getElementById('clear-btn');
        this.progressBar = document.getElementById('progress-bar');
        this.progressFill = document.getElementById('progress-fill');
        this.statusMessage = document.getElementById('status-message');
    }

    initializeSelectedTask() {
        // Get task ID from URL parameter
        const urlParams = new URLSearchParams(window.location.search);
        this.selectedTask = urlParams.get('task');
        if (this.selectedTask) {
            this.updateUploadState();
            // Load existing photos for this task
            this.loadAndDisplayTaskPhotos();
        }
    }

    attachEventListeners() {
        // File input
        this.fileInput.addEventListener('change', (e) => {
            this.handleFiles(e.target.files);
        });

        // Drag and drop
        this.uploadZone.addEventListener('click', () => {
            this.fileInput.click();
        });

        this.uploadZone.addEventListener('dragover', (e) => {
            e.preventDefault();
            this.uploadArea.classList.add('dragover');
        });

        this.uploadZone.addEventListener('dragleave', () => {
            this.uploadArea.classList.remove('dragover');
        });

        this.uploadZone.addEventListener('drop', (e) => {
            e.preventDefault();
            this.uploadArea.classList.remove('dragover');
            this.handleFiles(e.dataTransfer.files);
        });

        // Upload actions
        this.uploadBtn.addEventListener('click', () => {
            this.uploadPhotos();
        });

        this.clearBtn.addEventListener('click', () => {
            this.clearAll();
        });
    }

    handleFiles(files) {
        if (!this.selectedTask) {
            this.showStatus('Please select a task first', 'error');
            return;
        }

        const imageFiles = Array.from(files).filter(file => file.type.startsWith('image/'));

        if (imageFiles.length === 0) {
            this.showStatus('Please select valid image files', 'error');
            return;
        }

        imageFiles.forEach(file => {
            if (file.size > 25 * 1024 * 1024) { // 25MB limit
                this.showStatus(`File ${file.name} is too large (max 25MB)`, 'error');
                return;
            }

            this.selectedFiles.push({
                file: file,
                photoType: 'general',
                description: '',
                sequenceNumber: this.getNextSequenceNumber('general')
            });
        });

        this.renderPreviews();
        this.updateUploadState();
    }

    getNextSequenceNumber(photoType) {
        return this.selectedFiles.filter(f => f.photoType === photoType).length + 1;
    }

    renderPreviews() {
        this.previewGrid.innerHTML = '';

        this.selectedFiles.forEach((fileData, index) => {
            const preview = this.createPhotoPreview(fileData, index);
            this.previewGrid.appendChild(preview);
        });
    }

    createPhotoPreview(fileData, index) {
        const card = document.createElement('div');
        card.className = 'photo-preview-card';
        card.innerHTML = `
            <img src="${URL.createObjectURL(fileData.file)}" class="photo-preview" alt="Preview">
            <button class="remove-photo" data-action="remove" data-index="${index}">&times;</button>
            <div class="photo-controls">
                <select class="photo-type-select" data-action="update-type" data-index="${index}">
                    <option value="before" ${fileData.photoType === 'before' ? 'selected' : ''}>Before</option>
                    <option value="after" ${fileData.photoType === 'after' ? 'selected' : ''}>After</option>
                    <option value="during" ${fileData.photoType === 'during' ? 'selected' : ''}>During</option>
                    <option value="reference" ${fileData.photoType === 'reference' ? 'selected' : ''}>Reference</option>
                    <option value="damage" ${fileData.photoType === 'damage' ? 'selected' : ''}>Damage</option>
                    <option value="general" ${fileData.photoType === 'general' ? 'selected' : ''}>General</option>
                </select>
                <textarea class="photo-description" placeholder="Description..." data-action="update-description" data-index="${index}">${fileData.description}</textarea>
            </div>
        `;

        // Add event listeners
        const removeBtn = card.querySelector('[data-action="remove"]');
        removeBtn.addEventListener('click', () => this.removePhoto(index));

        const typeSelect = card.querySelector('[data-action="update-type"]');
        typeSelect.addEventListener('change', (e) => this.updatePhotoType(index, e.target.value));

        const descriptionTextarea = card.querySelector('[data-action="update-description"]');
        descriptionTextarea.addEventListener('change', (e) => this.updateDescription(index, e.target.value));

        return card;
    }

    updatePhotoType(index, photoType) {
        this.selectedFiles[index].photoType = photoType;
        this.selectedFiles[index].sequenceNumber = this.getNextSequenceNumber(photoType);
    }

    updateDescription(index, description) {
        this.selectedFiles[index].description = description;
    }

    removePhoto(index) {
        this.selectedFiles.splice(index, 1);
        this.renderPreviews();
        this.updateUploadState();
    }

    updateUploadState() {
        if (this.selectedTask && this.selectedFiles.length > 0) {
            this.uploadActions.style.display = 'flex';
        } else {
            this.uploadActions.style.display = 'none';
        }
    }

    async uploadPhotos() {
        if (!this.selectedTask || this.selectedFiles.length === 0) {
            this.showStatus('Please select a task and photos', 'error');
            return;
        }

        this.uploadBtn.disabled = true;
        this.progressBar.style.display = 'block';
        this.showStatus('Uploading photos...', 'info');

        let successCount = 0;
        let errorCount = 0;

        for (let i = 0; i < this.selectedFiles.length; i++) {
            const fileData = this.selectedFiles[i];
            const progress = ((i + 1) / this.selectedFiles.length) * 100;
            this.progressFill.style.width = `${progress}%`;

            try {
                await this.uploadSinglePhoto(fileData);
                successCount++;
            } catch (error) {
                console.error('Upload error:', error);
                errorCount++;
            }
        }

        this.progressBar.style.display = 'none';
        this.uploadBtn.disabled = false;

        if (errorCount === 0) {
            this.showStatus(`Successfully uploaded ${successCount} photo${successCount > 1 ? 's' : ''}! Loading gallery...`, 'success');
            this.clearAll();
            // Show recently uploaded photos with a small delay to ensure server processing
            console.log('Upload successful, loading photos...');
            setTimeout(() => {
                this.loadAndDisplayTaskPhotos();
            }, 500);
        } else {
            this.showStatus(`Uploaded ${successCount} photos, ${errorCount} failed`, 'error');
        }
    }

    async uploadSinglePhoto(fileData) {
        const formData = new FormData();
        formData.append('image', fileData.file);
        formData.append('photo_type', fileData.photoType);
        formData.append('description', fileData.description);
        formData.append('sequence_number', fileData.sequenceNumber);
        formData.append('task', this.selectedTask);

        // Debug: Log what we're sending
        console.log('Uploading photo:', {
            taskId: this.selectedTask,
            photoType: fileData.photoType,
            description: fileData.description,
            sequenceNumber: fileData.sequenceNumber,
            fileName: fileData.file.name,
            fileSize: fileData.file.size
        });

        const response = await fetch(`/api/tasks/${this.selectedTask}/images/create/`, {
            method: 'POST',
            body: formData,
            headers: {
                'X-CSRFToken': getCsrfToken()
            }
        });

        if (!response.ok) {
            const errorText = await response.text();
            console.error('Upload error details:', errorText);
            throw new Error(`Upload failed: ${response.statusText} - ${errorText}`);
        }

        return response.json();
    }

    clearAll() {
        this.selectedFiles = [];
        this.renderPreviews();
        this.updateUploadState();
        this.fileInput.value = '';
        this.showStatus('', '');
    }

    showStatus(message, type) {
        this.statusMessage.textContent = message;
        this.statusMessage.className = `status-message status-${type}`;

        if (type === 'success') {
            // Keep success messages visible longer
            setTimeout(() => {
                this.statusMessage.textContent = '';
                this.statusMessage.className = '';
            }, 8000);
        }
    }

    async loadAndDisplayTaskPhotos() {
        if (!this.selectedTask) {
            console.log('No selected task, skipping photo load');
            return;
        }

        console.log('Loading photos for task:', this.selectedTask);

        // Show loading indicator
        const container = document.getElementById('uploaded-photos-container');
        if (container) {
            container.innerHTML = '<div class="loading-photos">Loading photos...</div>';
        }

        try {
            const response = await fetch(`/api/tasks/${this.selectedTask}/images/`);
            console.log('Photo API response status:', response.status);

            if (response.ok) {
                const data = await response.json();
                console.log('API response:', data);

                // Handle paginated response
                const photos = data.results || data;
                console.log('Loaded photos:', photos);
                this.displayTaskPhotos(photos);
            } else {
                console.error('Failed to load photos:', response.status, response.statusText);
                if (container) {
                    container.innerHTML = '<div class="error-photos">Failed to load photos</div>';
                }
            }
        } catch (error) {
            console.error('Error loading task photos:', error);
            if (container) {
                container.innerHTML = '<div class="error-photos">Error loading photos</div>';
            }
        }
    }

    displayTaskPhotos(photos) {
        console.log('Displaying photos:', photos);
        const container = document.getElementById('uploaded-photos-container');
        console.log('Container found:', !!container);

        if (!container) {
            console.error('Uploaded photos container not found!');
            return;
        }

        if (photos.length === 0) {
            console.log('No photos to display');
            container.innerHTML = '<p class="no-photos">No photos uploaded yet.</p>';
            return;
        }

        console.log('Rendering', photos.length, 'photos');

        const photosHtml = photos.map(photo => {
            if (!photo.image) {
                return `
                    <div class="uploaded-photo-item photo-error">
                        <div class="photo-placeholder">
                            <span class="placeholder-icon">⚠️</span>
                            <span class="placeholder-text">No Image File</span>
                        </div>
                        <div class="photo-info">
                            <div class="photo-header">
                                <span class="photo-type">${photo.photo_type_display}</span>
                                <span class="photo-status status-error">Error</span>
                            </div>
                            <span class="photo-date">${new Date(photo.uploaded_at).toLocaleString()}</span>
                            <p class="photo-description">This photo record has no associated file</p>
                            ${this.canApprovePhotos() ? `
                                <div class="photo-approval-controls">
                                    <button class="btn-danger" data-action="delete" data-photo-id="${photo.id}">
                                        Delete Record
                                    </button>
                                </div>
                            ` : ''}
                        </div>
                    </div>
                `;
            }

            return `
                <div class="uploaded-photo-item" data-photo-id="${photo.id}" data-photo-type="${photo.photo_type}">
                    <img src="${photo.image}"
                         alt="Task photo"
                         class="uploaded-photo-thumbnail"
                         data-action="open-modal"
                         data-image="${photo.image}"
                         data-photo-id="${photo.id}">
                    <div class="photo-info">
                        <div class="photo-header">
                            <span class="photo-type">${photo.photo_type_display}</span>
                            <span class="photo-status status-${photo.photo_status}">${photo.photo_status_display}</span>
                        </div>
                        <span class="photo-date">${new Date(photo.uploaded_at).toLocaleString()}</span>
                        ${photo.description ? `<p class="photo-description">${photo.description}</p>` : ''}
                        ${this.canApprovePhotos() ? this.renderApprovalControls(photo) : ''}
                    </div>
                </div>
            `;
        }).join('');

        container.innerHTML = `
            <div class="uploaded-photos-section">
                <h3>Recently Uploaded Photos (${photos.length})</h3>
                <div class="uploaded-photos-grid">
                    ${photosHtml}
                </div>
                <div class="photo-actions">
                    <a href="/api/staff/tasks/${this.selectedTask}/" class="btn btn-primary">
                        View Task Details
                    </a>
                    <button data-action="refresh" class="btn btn-secondary">
                        Refresh Photos
                    </button>
                </div>
            </div>
        `;

        // Add event listeners for approval controls
        this.attachPhotoActionListeners(container);
    }

    attachPhotoActionListeners(container) {
        // Delete buttons
        container.querySelectorAll('[data-action="delete"]').forEach(btn => {
            btn.addEventListener('click', (e) => {
                const photoId = e.currentTarget.dataset.photoId;
                this.deletePhoto(photoId);
            });
        });

        // Approval buttons
        container.querySelectorAll('[data-action="approve"]').forEach(btn => {
            btn.addEventListener('click', (e) => {
                const photoId = e.currentTarget.dataset.photoId;
                this.approvePhoto(photoId);
            });
        });

        // Reject buttons
        container.querySelectorAll('[data-action="reject"]').forEach(btn => {
            btn.addEventListener('click', (e) => {
                const photoId = e.currentTarget.dataset.photoId;
                this.rejectPhoto(photoId);
            });
        });

        // Archive buttons
        container.querySelectorAll('[data-action="archive"]').forEach(btn => {
            btn.addEventListener('click', (e) => {
                const photoId = e.currentTarget.dataset.photoId;
                this.archivePhoto(photoId);
            });
        });

        // Image click to open modal
        container.querySelectorAll('[data-action="open-modal"]').forEach(img => {
            img.addEventListener('click', (e) => {
                const imageSrc = e.currentTarget.dataset.image;
                const photoId = e.currentTarget.dataset.photoId;
                this.openPhotoModal(imageSrc, photoId);
            });
        });

        // Refresh button
        const refreshBtn = container.querySelector('[data-action="refresh"]');
        if (refreshBtn) {
            refreshBtn.addEventListener('click', () => {
                this.loadAndDisplayTaskPhotos();
            });
        }
    }

    canApprovePhotos() {
        // Check if current user can approve photos
        // This should match the backend permission logic
        return window.userCanApprovePhotos || false;
    }

    renderApprovalControls(photo) {
        if (photo.photo_status === 'pending') {
            return `
                <div class="photo-approval-controls">
                    <button class="btn-approve" data-action="approve" data-photo-id="${photo.id}">
                        Approve
                    </button>
                    <button class="btn-reject" data-action="reject" data-photo-id="${photo.id}">
                        Reject
                    </button>
                </div>
            `;
        } else if (photo.photo_status === 'approved') {
            return `
                <div class="photo-approval-controls">
                    <span class="status-approved">Approved</span>
                    <button class="btn-archive" data-action="archive" data-photo-id="${photo.id}">
                        Archive
                    </button>
                </div>
            `;
        } else if (photo.photo_status === 'rejected') {
            return `
                <div class="photo-approval-controls">
                    <span class="status-rejected">Rejected</span>
                    <button class="btn-approve" data-action="approve" data-photo-id="${photo.id}">
                        Approve
                    </button>
                </div>
            `;
        }
        return '';
    }

    async approvePhoto(photoId) {
        await this.updatePhotoStatus(photoId, 'approved');
    }

    async rejectPhoto(photoId) {
        await this.updatePhotoStatus(photoId, 'rejected');
    }

    async archivePhoto(photoId) {
        await this.updatePhotoStatus(photoId, 'archived');
    }

    async updatePhotoStatus(photoId, status) {
        try {
            const response = await fetch(`/api/tasks/${this.selectedTask}/images/${photoId}/`, {
                method: 'PATCH',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRFToken': getCsrfToken()
                },
                body: JSON.stringify({ photo_status: status })
            });

            if (response.ok) {
                this.showStatus(`Photo ${status} successfully!`, 'success');
                // Reload photos to show updated status
                this.loadAndDisplayTaskPhotos();
            } else {
                const error = await response.json();
                this.showStatus(`Failed to ${status} photo: ${error.detail || 'Unknown error'}`, 'error');
            }
        } catch (error) {
            console.error('Error updating photo status:', error);
            this.showStatus(`Error updating photo status: ${error.message}`, 'error');
        }
    }

    async deletePhoto(photoId) {
        if (!confirm('Are you sure you want to delete this photo record? This action cannot be undone.')) {
            return;
        }

        try {
            const response = await fetch(`/api/tasks/${this.selectedTask}/images/${photoId}/`, {
                method: 'DELETE',
                headers: {
                    'X-CSRFToken': getCsrfToken()
                }
            });

            if (response.ok) {
                this.showStatus('Photo record deleted successfully!', 'success');
                // Reload photos to show updated status
                this.loadAndDisplayTaskPhotos();
            } else {
                const error = await response.json();
                this.showStatus(`Failed to delete photo: ${error.detail || 'Unknown error'}`, 'error');
            }
        } catch (error) {
            console.error('Error deleting photo:', error);
            this.showStatus(`Error deleting photo: ${error.message}`, 'error');
        }
    }

    openPhotoModal(photoUrl, photoId) {
        // Use the same photo modal functionality as task detail page
        if (typeof window.openPhotoModal === 'function') {
            window.openPhotoModal(photoUrl, photoId);
        } else {
            // Fallback: open in new tab
            window.open(photoUrl, '_blank');
        }
    }
}

// Initialize the photo uploader when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
    window.photoUploader = new PhotoUploader();
});
