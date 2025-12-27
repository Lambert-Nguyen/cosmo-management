/**
 * System Logs Viewer
 * Handles log downloads, scrolling, auto-refresh, and keyboard shortcuts
 */

// Auto-refresh state
let refreshInterval = null;

/**
 * Download logs with current filters
 */
function downloadLogs() {
    const currentFile = window.logsCurrentFile || '';
    const searchTerm = window.logsSearchTerm || '';
    const levelFilter = window.logsLevelFilter || '';

    // Build download URL with current filters
    let downloadUrl = '/api/admin/logs/download/?file=' + encodeURIComponent(currentFile);

    if (searchTerm) {
        downloadUrl += '&search=' + encodeURIComponent(searchTerm);
    }

    if (levelFilter) {
        downloadUrl += '&level=' + encodeURIComponent(levelFilter);
    }

    // Create a temporary link and trigger download
    const link = document.createElement('a');
    link.href = downloadUrl;
    link.download = '';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
}

/**
 * Scroll to bottom of logs container
 */
function scrollToBottom() {
    const container = document.getElementById('logs-container');
    if (container) {
        container.scrollTop = container.scrollHeight;
    }
}

/**
 * Scroll to top of logs container
 */
function scrollToTop() {
    const container = document.getElementById('logs-container');
    if (container) {
        container.scrollTop = 0;
    }
}

/**
 * Start auto-refresh
 */
function startAutoRefresh() {
    refreshInterval = setInterval(() => {
        location.reload();
    }, 10000); // Refresh every 10 seconds

    const statusEl = document.getElementById('auto-refresh-status');
    if (statusEl) {
        statusEl.textContent = '🔄 Auto-refresh: ON (10s)';
    }
}

/**
 * Stop auto-refresh
 */
function stopAutoRefresh() {
    if (refreshInterval) {
        clearInterval(refreshInterval);
        refreshInterval = null;
    }

    const statusEl = document.getElementById('auto-refresh-status');
    if (statusEl) {
        statusEl.textContent = '⏸️ Auto-refresh: OFF';
    }
}

/**
 * Toggle auto-refresh
 */
function toggleAutoRefresh() {
    if (refreshInterval) {
        stopAutoRefresh();
    } else {
        startAutoRefresh();
    }
}

/**
 * Handle visibility changes
 */
function handleVisibilityChange() {
    if (document.hidden) {
        stopAutoRefresh();
    }
}

/**
 * Initialize logs viewer
 */
function initLogsViewer() {
    // Event delegation for action buttons
    document.addEventListener('click', (e) => {
        const target = e.target;

        // Download button
        if (target.dataset.action === 'download-logs') {
            e.preventDefault();
            downloadLogs();
        }

        // Scroll to bottom
        if (target.dataset.action === 'scroll-bottom') {
            e.preventDefault();
            scrollToBottom();
        }

        // Scroll to top
        if (target.dataset.action === 'scroll-top') {
            e.preventDefault();
            scrollToTop();
        }

        // Refresh button
        if (target.dataset.action === 'refresh-logs') {
            e.preventDefault();
            location.reload();
        }

        // Auto-refresh toggle
        if (target.dataset.action === 'toggle-auto-refresh') {
            e.preventDefault();
            toggleAutoRefresh();
        }
    });

    // Auto-refresh toggle on click
    const autoRefreshStatus = document.getElementById('auto-refresh-status');
    if (autoRefreshStatus) {
        autoRefreshStatus.addEventListener('click', toggleAutoRefresh);
    }

    // Auto-submit form on file selection
    const fileSelect = document.getElementById('file');
    if (fileSelect) {
        fileSelect.addEventListener('change', () => {
            const form = document.getElementById('log-controls');
            if (form) {
                form.submit();
            }
        });
    }

    // Keyboard shortcuts
    document.addEventListener('keydown', (e) => {
        if (e.ctrlKey || e.metaKey) {
            switch (e.key) {
                case 'r':
                    e.preventDefault();
                    location.reload();
                    break;
                case 'f':
                    e.preventDefault();
                    const searchInput = document.getElementById('search');
                    if (searchInput) {
                        searchInput.focus();
                    }
                    break;
                case 'k':
                    e.preventDefault();
                    scrollToTop();
                    break;
                case 'j':
                    e.preventDefault();
                    scrollToBottom();
                    break;
            }
        }
    });

    // Scroll to bottom on page load
    scrollToBottom();

    // Pause refresh when page is not visible
    document.addEventListener('visibilitychange', handleVisibilityChange);

    console.log('📝 AriStay System Logs Viewer loaded successfully!');
    console.log('💡 Tips: Click auto-refresh to toggle, use Ctrl+F to search, Ctrl+K/J to scroll');
}

// Cleanup on page unload
window.addEventListener('beforeunload', () => {
    stopAutoRefresh();
});

// Initialize when DOM is ready
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initLogsViewer);
} else {
    initLogsViewer();
}
