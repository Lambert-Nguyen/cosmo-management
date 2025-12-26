/**
 * Conflict Resolution - JavaScript
 * Handles booking conflict resolution with AJAX
 * Note: importSessionId must be defined in template as a global variable
 */

let resolvedCount = 0;
let totalConflicts = 0;

document.addEventListener('DOMContentLoaded', function() {
    // Get total conflicts from data attribute or count containers
    const conflictContainers = document.querySelectorAll('.conflict-container');
    totalConflicts = conflictContainers.length;

    // Event delegation for resolution buttons
    document.addEventListener('click', function(e) {
        const target = e.target.closest('[data-action]');
        if (!target) return;

        const action = target.dataset.action;
        const conflictIndex = parseInt(target.dataset.conflictIndex);

        if (action === 'resolve-update') {
            resolveConflict(conflictIndex, 'update_existing');
        } else if (action === 'resolve-create') {
            resolveConflict(conflictIndex, 'create_new');
        } else if (action === 'resolve-skip') {
            resolveConflict(conflictIndex, 'skip');
        } else if (action === 'preview') {
            previewResolution(conflictIndex);
        } else if (action === 'bulk-update') {
            resolveAllConflicts('update_existing');
        } else if (action === 'bulk-create') {
            resolveAllConflicts('create_new');
        } else if (action === 'bulk-skip') {
            resolveAllConflicts('skip');
        }
    });
});

function showLoading() {
    const overlay = document.getElementById('loadingOverlay');
    if (overlay) {
        overlay.style.display = 'flex';
    }
}

function hideLoading() {
    const overlay = document.getElementById('loadingOverlay');
    if (overlay) {
        overlay.style.display = 'none';
    }
}

function updateProgress() {
    const progressPercent = (resolvedCount / totalConflicts) * 100;
    const progressFill = document.getElementById('progressFill');
    const progressText = document.getElementById('progressText');

    if (progressFill) {
        progressFill.style.width = progressPercent + '%';
    }
    if (progressText) {
        progressText.textContent = `${resolvedCount} of ${totalConflicts} resolved`;
    }
}

function resolveConflict(conflictIndex, action) {
    showLoading();

    const resolutions = [{
        conflict_index: conflictIndex,
        action: action,
        apply_changes: ['guest_name', 'dates', 'status'] // Apply all changes for updates
    }];

    // importSessionId must be defined in template
    const sessionId = window.importSessionId || '';

    fetch(`/api/resolve-conflicts/${sessionId}/`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRFToken': getCsrfToken()
        },
        body: JSON.stringify({ resolutions: resolutions })
    })
    .then(async response => {
        let data;
        try {
            data = await response.json();
        } catch (e) {
            data = {};
        }
        if (!response.ok) {
            const errorMsg = data && data.error
                ? data.error
                : `HTTP ${response.status}: ${response.statusText}`;
            throw new Error(errorMsg);
        }
        return data;
    })
    .then(data => {
        hideLoading();

        if (data.success) {
            // Show success status
            const statusDiv = document.getElementById(`status-${conflictIndex}`);
            if (statusDiv) {
                statusDiv.style.display = 'block';
                statusDiv.innerHTML = `
                    <div class="alert alert-success" role="alert">
                        <i class="fas fa-check-circle"></i>
                        <strong>✓ Resolved:</strong> ${getActionDescription(action)}
                        ${data.results ? `<br><small class="text-muted">Results: ${JSON.stringify(data.results)}</small>` : ''}
                    </div>
                `;
            }

            // Disable buttons for this conflict
            const conflictContainer = document.querySelector(`[data-conflict-index="${conflictIndex}"]`);
            if (conflictContainer) {
                const buttons = conflictContainer.querySelectorAll('.btn');
                buttons.forEach(btn => {
                    btn.disabled = true;
                    btn.classList.add('disabled');
                });
            }

            resolvedCount++;
            updateProgress();

            // Check if all conflicts are resolved
            if (resolvedCount === totalConflicts) {
                showCompletionMessage();
            }
        } else {
            throw new Error(data.error || 'Unknown error occurred');
        }
    })
    .catch(error => {
        hideLoading();
        console.error('Error:', error);

        const statusDiv = document.getElementById(`status-${conflictIndex}`);
        if (statusDiv) {
            statusDiv.style.display = 'block';
            statusDiv.innerHTML = `
                <div class="alert alert-danger" role="alert">
                    <i class="fas fa-exclamation-triangle"></i>
                    <strong>Error:</strong> Failed to resolve conflict. ${error.message}
                    <br><small class="text-muted">Please try again or contact support if the problem persists.</small>
                </div>
            `;
        } else {
            alert(`Failed to resolve conflict: ${error.message}`);
        }
    });
}

function resolveAllConflicts(action) {
    if (!confirm(`Are you sure you want to ${getActionDescription(action)} for all conflicts? This action cannot be undone.`)) {
        return;
    }

    showLoading();

    const resolutions = [];
    for (let i = 0; i < totalConflicts; i++) {
        resolutions.push({
            conflict_index: i,
            action: action,
            apply_changes: ['guest_name', 'dates', 'status']
        });
    }

    const sessionId = window.importSessionId || '';

    fetch(`/api/resolve-conflicts/${sessionId}/`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRFToken': getCsrfToken()
        },
        body: JSON.stringify({ resolutions: resolutions })
    })
    .then(response => {
        if (!response.ok) {
            throw new Error(`HTTP ${response.status}: ${response.statusText}`);
        }
        return response.json();
    })
    .then(data => {
        hideLoading();

        if (data.success) {
            const summary = document.createElement('div');
            summary.className = 'alert alert-success mt-4';
            summary.setAttribute('role', 'alert');
            summary.innerHTML = `
                <i class="fas fa-check-circle"></i>
                <strong>Success!</strong> All conflicts resolved successfully!
                ${data.results ? `<br><small class="text-muted">Results: ${JSON.stringify(data.results)}</small>` : ''}
                <br><a href="/admin/api/bookingimportlog/" class="btn btn-sm btn-outline-success mt-2">Return to Import Logs</a>
            `;

            const bulkActions = document.querySelector('.bulk-actions');
            if (bulkActions) {
                bulkActions.innerHTML = '';
                bulkActions.appendChild(summary);
            }

            // Disable all individual conflict buttons
            document.querySelectorAll('.conflict-container .btn').forEach(btn => {
                btn.disabled = true;
                btn.classList.add('disabled');
            });
        } else {
            throw new Error(data.error || 'Unknown error occurred');
        }
    })
    .catch(error => {
        hideLoading();
        console.error('Error:', error);

        const bulkActions = document.querySelector('.bulk-actions');
        if (bulkActions) {
            const errorDiv = document.createElement('div');
            errorDiv.className = 'alert alert-danger mt-3';
            errorDiv.setAttribute('role', 'alert');
            errorDiv.innerHTML = `
                <i class="fas fa-exclamation-triangle"></i>
                <strong>Error:</strong> Failed to resolve all conflicts. ${error.message}
                <br><small class="text-muted">Please try resolving conflicts individually or contact support.</small>
            `;
            bulkActions.appendChild(errorDiv);
        } else {
            alert(`Failed to resolve conflicts: ${error.message}`);
        }
    });
}

function previewResolution(conflictIndex) {
    const sessionId = window.importSessionId || '';

    fetch(`/api/preview-conflict/${sessionId}/${conflictIndex}/`)
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            showPreviewModal(data.preview);
        } else {
            alert('Error previewing resolution: ' + data.error);
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('Failed to preview resolution.');
    });
}

function showPreviewModal(preview) {
    const changes = preview.changes_summary;
    let message = 'Preview of changes:\n\n';

    for (const [field, change] of Object.entries(changes)) {
        message += `${field.toUpperCase()}:\n`;
        message += `  Current: ${JSON.stringify(change.current)}\n`;
        message += `  New: ${JSON.stringify(change.excel)}\n\n`;
    }

    alert(message);
}

function getActionDescription(action) {
    switch (action) {
        case 'update_existing':
            return 'update existing booking with Excel data';
        case 'create_new':
            return 'create new booking from Excel data';
        case 'skip':
            return 'skip this conflict (no changes)';
        default:
            return action;
    }
}

function showCompletionMessage() {
    const summary = document.createElement('div');
    summary.className = 'resolution-summary';
    summary.innerHTML = `
        <h3>🎉 All Conflicts Resolved!</h3>
        <p>All ${totalConflicts} conflicts have been successfully resolved.</p>
        <a href="/admin/api/bookingimportlog/" class="btn btn-primary">
            Back to Import Logs
        </a>
    `;

    const bulkActions = document.querySelector('.bulk-actions');
    if (bulkActions) {
        bulkActions.appendChild(summary);
    }
}

function getCsrfToken() {
    const csrfInput = document.querySelector('[name=csrfmiddlewaretoken]');
    return csrfInput ? csrfInput.value : '';
}
