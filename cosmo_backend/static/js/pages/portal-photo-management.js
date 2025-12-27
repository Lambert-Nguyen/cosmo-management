function readCanApprove() {
  const el = document.getElementById('photoManagementConfig');
  return (el?.dataset?.canApprove || 'false') === 'true';
}

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
  const validTransitions = {
    pending: ['approved', 'rejected'],
    approved: ['archived', 'rejected'],
    rejected: ['pending', 'archived', 'approved'],
    archived: ['pending', 'approved', 'rejected'],
  };

  return validTransitions[currentStatus] || [];
}

function getCsrfToken() {
  return (
    document.querySelector('[name=csrfmiddlewaretoken]')?.value ||
    document.querySelector('meta[name="csrf-token"]')?.getAttribute('content') ||
    ''
  );
}

function showLoading() {
  const grid = document.getElementById('photosGrid');
  if (!grid) return;
  grid.innerHTML = `
    <div class="loading-state">
      <div class="loading-spinner"></div>
      <p>Loading photos...</p>
    </div>
  `;
}

function updateStats(photos) {
  const total = photos.length;
  const pending = photos.filter((p) => p.photo_status === 'pending').length;
  const approved = photos.filter((p) => p.photo_status === 'approved').length;
  const rejected = photos.filter((p) => p.photo_status === 'rejected').length;

  const totalEl = document.getElementById('totalPhotos');
  const pendingEl = document.getElementById('pendingPhotos');
  const approvedEl = document.getElementById('approvedPhotos');
  const rejectedEl = document.getElementById('rejectedPhotos');

  if (totalEl) totalEl.textContent = String(total);
  if (pendingEl) pendingEl.textContent = String(pending);
  if (approvedEl) approvedEl.textContent = String(approved);
  if (rejectedEl) rejectedEl.textContent = String(rejected);
}

function showEmptyState(message) {
  const grid = document.getElementById('photosGrid');
  if (!grid) return;
  grid.innerHTML = `
    <div class="loading-state">
      <div class="portal-photo-management-state-icon">📷</div>
      <p>${message}</p>
    </div>
  `;
  updateStats([]);
}

function showErrorState(message) {
  const grid = document.getElementById('photosGrid');
  if (!grid) return;
  grid.innerHTML = `
    <div class="loading-state">
      <div class="portal-photo-management-state-icon">⚠️</div>
      <p>${message}</p>
    </div>
  `;
  updateStats([]);
}

function openPhotoModal(imageSrc, photo) {
  const modal = document.getElementById('photoModal');
  const modalPhoto = document.getElementById('modalPhoto');
  const modalTitle = document.getElementById('modalPhotoTitle');

  if (!modal || !modalPhoto || !modalTitle) return;

  modalPhoto.src = imageSrc;
  modalTitle.textContent = `Photo #${photo.id} - ${photo.photo_type_display || photo.photo_type || 'Unknown'}`;

  modal.classList.remove('hidden');
  document.body.style.overflow = 'hidden';
}

function closePhotoModal() {
  const modal = document.getElementById('photoModal');
  if (!modal) return;
  modal.classList.add('hidden');
  document.body.style.overflow = 'auto';
}

async function updateStatus(photo, newStatus) {
  const taskId = document.getElementById('taskFilter')?.value;
  if (!taskId) {
    alert('Please select a task first.');
    return;
  }

  if (!photo || !photo.id) {
    alert('Invalid photo data.');
    return;
  }

  const csrfToken = getCsrfToken();

  try {
    const res = await fetch(`/api/tasks/${taskId}/images/${photo.id}/`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        ...(csrfToken && { 'X-CSRFToken': csrfToken }),
      },
      credentials: 'same-origin',
      body: JSON.stringify({ photo_status: newStatus }),
    });

    if (res.ok) {
      await load();
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

let currentPhotos = [];

async function fetchPhotos() {
  const taskId = document.getElementById('taskFilter')?.value;
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

function renderGrid(items) {
  const grid = document.getElementById('photosGrid');
  const statusFilter = document.getElementById('statusFilter')?.value;
  const typeFilter = document.getElementById('typeFilter')?.value;

  if (!grid) return;

  if (!items || items.length === 0) {
    showEmptyState('No photos found for the selected task.');
    return;
  }

  const filtered = items.filter(
    (p) => (!statusFilter || p.photo_status === statusFilter) && (!typeFilter || p.photo_type === typeFilter),
  );

  if (filtered.length === 0) {
    showEmptyState('No photos match the current filters.');
    return;
  }

  const tpl = document.getElementById('photoCardTpl');
  if (!tpl) return;

  grid.innerHTML = '';

  const count = document.getElementById('photoCount');
  if (count) count.textContent = `(${filtered.length})`;

  const canApprove = readCanApprove();

  filtered.forEach((p) => {
    const node = tpl.content.cloneNode(true);
    const card = node.querySelector('.photo-card');
    const img = node.querySelector('[data-el="img"]');
    const type = node.querySelector('[data-el="type"]');
    const status = node.querySelector('[data-el="status"]');
    const meta = node.querySelector('[data-el="meta"]');
    const actions = node.querySelectorAll('[data-el="actions"]');

    if (!card || !img || !type || !status || !meta) return;

    card.setAttribute('data-photo-id', p.id);

    if (p.image) {
      img.src = p.image;
      img.alt = `Photo ${p.id}`;
      img.addEventListener('click', () => openPhotoModal(p.image, p));
    } else {
      img.src =
        'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjAwIiBoZWlnaHQ9IjE4MCIgdmlld0JveD0iMCAwIDIwMCAxODAiIGZpbGw9Im5vbmUiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CjxyZWN0IHdpZHRoPSIyMDAiIGhlaWdodD0iMTgwIiBmaWxsPSIjRjNGNEY2Ii8+CjxwYXRoIGQ9Ik04MCA2MEgxMjBWMTIwSDgwVjYwWiIgZmlsbD0iIzlDQTNBRiIvPgo8cGF0aCBkPSJNODAgODBIMTIwVjEwMEg4MFY4MFoiIGZpbGw9IiM5Q0EzQUYiLz4KPC9zdmc+';
      img.alt = 'Missing image';
      img.classList.add('photo-image-missing');
    }

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
      actions.forEach((actionContainer) => {
        const approveBtn = actionContainer.querySelector('[data-action="approve"]');
        const rejectBtn = actionContainer.querySelector('[data-action="reject"]');
        const archiveBtn = actionContainer.querySelector('[data-action="archive"]');

        const currentStatus = p.photo_status;
        const validTransitions = getValidTransitions(currentStatus);

        if (approveBtn) {
          if (validTransitions.includes('approved')) {
            approveBtn.classList.remove('hidden');
            approveBtn.addEventListener('click', () => updateStatus(p, 'approved'));
          } else {
            approveBtn.classList.add('hidden');
          }
        }

        if (rejectBtn) {
          if (validTransitions.includes('rejected')) {
            rejectBtn.classList.remove('hidden');
            rejectBtn.addEventListener('click', () => updateStatus(p, 'rejected'));
          } else {
            rejectBtn.classList.add('hidden');
          }
        }

        if (archiveBtn) {
          if (validTransitions.includes('archived')) {
            archiveBtn.classList.remove('hidden');
            archiveBtn.addEventListener('click', () => updateStatus(p, 'archived'));
          } else {
            archiveBtn.classList.add('hidden');
          }
        }
      });
    }

    grid.appendChild(node);
  });
}

async function load() {
  const items = await fetchPhotos();
  renderGrid(items);
}

function clearFilters() {
  const taskFilter = document.getElementById('taskFilter');
  const statusFilter = document.getElementById('statusFilter');
  const typeFilter = document.getElementById('typeFilter');

  if (taskFilter) taskFilter.value = '';
  if (statusFilter) statusFilter.value = '';
  if (typeFilter) typeFilter.value = '';

  load();
}

function wireModalActions() {
  document.addEventListener('click', (e) => {
    const target = e.target instanceof Element ? e.target : null;
    if (!target) return;

    const actionEl = target.closest('[data-action]');
    const action = actionEl?.getAttribute('data-action');

    if (action === 'portal-photo-close-modal') {
      e.preventDefault();
      closePhotoModal();
    }
  });

  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
      closePhotoModal();
    }
  });
}

function wireFilters() {
  document.getElementById('taskFilter')?.addEventListener('change', load);
  document.getElementById('statusFilter')?.addEventListener('change', load);
  document.getElementById('typeFilter')?.addEventListener('change', load);
  document.getElementById('refreshBtn')?.addEventListener('click', load);
  document.getElementById('clearFiltersBtn')?.addEventListener('click', clearFilters);
}

document.addEventListener('DOMContentLoaded', () => {
  wireFilters();
  wireModalActions();
  load();
});
