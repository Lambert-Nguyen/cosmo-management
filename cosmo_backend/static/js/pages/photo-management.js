/**
 * Photo Management Page
 * Handles photo filtering, viewing, and approval for task photos
 */

// Global variables
let currentPhotos = [];

function statusBadgeStyles(status) {
    switch (status) {
        case 'approved':
            return 'approved';
        case 'pending':
            return 'pending';
        case 'rejected':
            return 'rejected';
        case 'archived':
            return 'archived';
        default:
            return 'archived';
    }
}

function getValidTransitions(currentStatus) {
    // Match the backend validation logic
    const validTransitions = {
        'pending': ['approved', 'rejected'],
        'approved': ['archived', 'rejected'],
        'rejected': ['pending', 'archived', 'approved'],
        'archived': ['pending', 'approved', 'rejected']
    };

    return validTransitions[currentStatus] || [];
}

async function fetchPhotos() {
    const taskId = document.getElementById('taskFilter').value;
    const url = taskId ? `/api/tasks/${taskId}/images/` : null;
    if (!url) {
        showEmptyState('Select a task to view photos.');
        return [];
    }

    showLoading();

    try {
        const res = await fetch(url, { credentials: 'same-origin' });
        if (!res.ok) {
            console.error('Failed to fetch photos:', res.status, res.statusText);
            showErrorState('Failed to load photos. Please try again.');
            return [];
        }
        const data = await res.json();
        const photos = data.results || data;
        currentPhotos = photos;
        updateStats(photos);
        return photos;
    } catch (error) {
        console.error('Error fetching photos:', error);
        showErrorState('Error loading photos. Please check your connection.');
        return [];
    }
}

function updateStats(photos) {
    const total = photos.length;
    const pending = photos.filter(p => p.photo_status === 'pending').length;
    const approved = photos.filter(p => p.photo_status === 'approved').length;
    const rejected = photos.filter(p => p.photo_status === 'rejected').length;

    document.getElementById('totalPhotos').textContent = total;
    document.getElementById('pendingPhotos').textContent = pending;
    document.getElementById('approvedPhotos').textContent = approved;
    document.getElementById('rejectedPhotos').textContent = rejected;
}

function showLoading() {
    const grid = document.getElementById('photosGrid');
    grid.innerHTML = `
    <div class="loading-state">
      <div class="loading-spinner"></div>
      <p>Loading photos...</p>
    </div>
  `;
}

function showEmptyState(message) {
    const grid = document.getElementById('photosGrid');
    grid.innerHTML = `
    <div class="loading-state">
      <div style="font-size: 3rem; margin-bottom: 1rem;">📷</div>
      <p>${message}</p>
    </div>
  `;
    updateStats([]);
}

function showErrorState(message) {
    const grid = document.getElementById('photosGrid');
    grid.innerHTML = `
    <div class="loading-state">
      <div style="font-size: 3rem; margin-bottom: 1rem;">⚠️</div>
      <p>${message}</p>
    </div>
  `;
    updateStats([]);
}

function renderGrid(items) {
    const grid = document.getElementById('photosGrid');
    const statusFilter = document.getElementById('statusFilter').value;
    const typeFilter = document.getElementById('typeFilter').value;

    if (!items || items.length === 0) {
        showEmptyState('No photos found for the selected task.');
        return;
    }

    const filtered = items.filter(p =>
        (!statusFilter || p.photo_status === statusFilter) &&
        (!typeFilter || p.photo_type === typeFilter)
    );

    if (filtered.length === 0) {
        showEmptyState('No photos match the current filters.');
        return;
    }

    const tpl = document.getElementById('photoCardTpl');
    grid.innerHTML = '';

    document.getElementById('photoCount').textContent = `(${filtered.length})`;

    filtered.forEach(p => {
        const node = tpl.content.cloneNode(true);
        const card = node.querySelector('.photo-card');
        const img = node.querySelector('[data-el="img"]');
        const type = node.querySelector('[data-el="type"]');
        const status = node.querySelector('[data-el="status"]');
        const meta = node.querySelector('[data-el="meta"]');
        const actions = node.querySelectorAll('[data-el="actions"]');

        card.setAttribute('data-photo-id', p.id);

        // Handle missing image gracefully
        if (p.image) {
            img.src = p.image;
            img.alt = `Photo ${p.id}`;
            img.addEventListener('click', () => openPhotoModal(p.image, p));
        } else {
            img.src = 'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjAwIiBoZWlnaHQ9IjE4MCIgdmlld0JveD0iMCAwIDIwMCAxODAiIGZpbGw9Im5vbmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjxyZWN0IHdpZHRoPSIyMDAiIGhlaWdodD0iMTgwIiBmaWxsPSIjRjNGNEY2Ii8+CjxwYXRoIGQ9Ik04MCA2MEgxMjBWMTIwSDgwVjYwWiIgZmlsbD0iIzlDQTNBRiIvPgo8cGF0aCBkPSJNODAgODBIMTIwVjEwMEg4MFY4MFoiIGZpbGw9IiM5Q0EzQUYiLz4KPC9zdmc+';
            img.alt = 'Missing image';
            img.style.cursor = 'default';
        }

        // Add click handler for view button in overlay
        const viewBtn = card.querySelector('.view-btn');
        if (viewBtn && p.image) {
            viewBtn.addEventListener('click', (e) => {
                e.stopPropagation();
                openPhotoModal(p.image, p);
            });
        }

        type.textContent = (p.photo_type_display || p.photo_type || 'Unknown').toString();
        status.textContent = (p.photo_status_display || p.photo_status || 'Unknown').toString();
        status.className = `photo-status-badge ${statusBadgeStyles(p.photo_status)}`;
        meta.textContent = `ID #${p.id || 'N/A'} · seq ${p.sequence_number || 'N/A'} · ${p.created_at || 'Unknown date'}`;

        if (canApprove && actions.length > 0) {
            actions.forEach(actionContainer => {
                const approveBtn = actionContainer.querySelector('[data-action="approve"]');
                const rejectBtn = actionContainer.querySelector('[data-action="reject"]');
                const archiveBtn = actionContainer.querySelector('[data-action="archive"]');

                // Show/hide buttons based on valid transitions
                const currentStatus = p.photo_status;
                const validTransitions = getValidTransitions(currentStatus);

                if (approveBtn) {
                    if (validTransitions.includes('approved')) {
                        approveBtn.style.display = 'inline-block';
                        approveBtn.addEventListener('click', () => updateStatus(p, 'approved'));
                    } else {
                        approveBtn.style.display = 'none';
                    }
                }

                if (rejectBtn) {
                    if (validTransitions.includes('rejected')) {
                        rejectBtn.style.display = 'inline-block';
                        rejectBtn.addEventListener('click', () => updateStatus(p, 'rejected'));
                    } else {
                        rejectBtn.style.display = 'none';
                    }
                }

                if (archiveBtn) {
                    if (validTransitions.includes('archived')) {
                        archiveBtn.style.display = 'inline-block';
                        archiveBtn.addEventListener('click', () => updateStatus(p, 'archived'));
                    } else {
                        archiveBtn.style.display = 'none';
                    }
                }
            });
        }

        grid.appendChild(node);
    });
}

function openPhotoModal(imageSrc, photo) {
    const modal = document.getElementById('photoModal');
    const modalPhoto = document.getElementById('modalPhoto');
    const modalTitle = document.getElementById('modalPhotoTitle');

    modalPhoto.src = imageSrc;
    modalTitle.textContent = `Photo #${photo.id} - ${photo.photo_type_display || photo.photo_type || 'Unknown'}`;
    modal.removeAttribute('data-visibility');
    modal.style.display = 'flex';
    document.body.style.overflow = 'hidden';
}

function closePhotoModal() {
    const modal = document.getElementById('photoModal');
    modal.setAttribute('data-visibility', 'hidden');
    modal.style.display = 'none';
    document.body.style.overflow = 'auto';
}

async function updateStatus(photo, newStatus) {
    const taskId = document.getElementById('taskFilter').value;
    if (!taskId) {
        alert('Please select a task first.');
        return;
    }

    if (!photo || !photo.id) {
        alert('Invalid photo data.');
        return;
    }

    // Get CSRF token
    const csrfToken = document.querySelector('[name=csrfmiddlewaretoken]')?.value ||
        document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');

    try {
        const res = await fetch(`/api/tasks/${taskId}/images/${photo.id}/`, {
            method: 'PATCH',
            headers: {
                'Content-Type': 'application/json',
                ...(csrfToken && { 'X-CSRFToken': csrfToken })
            },
            credentials: 'same-origin',
            body: JSON.stringify({ photo_status: newStatus })
        });

        if (res.ok) {
            // Photo status updated successfully
            load(); // Refresh the grid
        } else {
            const text = await res.text();
            console.error('Update failed:', res.status, text);
            alert(`Failed to update photo status: ${res.status} ${res.statusText}`);
        }
    } catch (error) {
        console.error('Error updating photo status:', error);
        alert('Network error. Please check your connection and try again.');
    }
}

async function load() {
    const items = await fetchPhotos();
    renderGrid(items);
}

function clearFilters() {
    document.getElementById('taskFilter').value = '';
    document.getElementById('statusFilter').value = '';
    document.getElementById('typeFilter').value = '';
    load();
}

// Event Listeners
document.addEventListener('DOMContentLoaded', function() {
    document.getElementById('taskFilter').addEventListener('change', load);
    document.getElementById('statusFilter').addEventListener('change', load);
    document.getElementById('typeFilter').addEventListener('change', load);
    document.getElementById('refreshBtn').addEventListener('click', load);
    document.getElementById('clearFiltersBtn').addEventListener('click', clearFilters);

    // Modal close buttons
    document.querySelectorAll('[data-action="close-modal"]').forEach(btn => {
        btn.addEventListener('click', closePhotoModal);
    });

    // Close modal on escape key
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            closePhotoModal();
        }
    });

    // Initial load
    load();
});
