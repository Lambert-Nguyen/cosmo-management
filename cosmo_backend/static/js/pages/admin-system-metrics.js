/**
 * System Metrics Dashboard
 * Handles auto-refresh, manual refresh, and dynamic metrics updates
 */

// Auto-refresh state
let refreshInterval = null;
let isRefreshing = false;

/**
 * Start auto-refresh interval
 */
function startAutoRefresh() {
    const interval = window.metricsRefreshInterval || 30;
    const mode = window.metricsRefreshMode || 'normal';

    if (interval > 0) {
        refreshInterval = setInterval(refreshMetrics, interval * 1000);
        const statusEl = document.getElementById('refresh-status');
        if (statusEl) {
            statusEl.textContent = `🔄 Auto-refresh: ${mode.charAt(0).toUpperCase() + mode.slice(1)} (${interval}s)`;
        }
    } else {
        const statusEl = document.getElementById('refresh-status');
        if (statusEl) {
            statusEl.textContent = '⏸️ Auto-refresh: Manual Only';
        }
    }
}

/**
 * Stop auto-refresh interval
 */
function stopAutoRefresh() {
    if (refreshInterval) {
        clearInterval(refreshInterval);
        refreshInterval = null;
    }
    const statusEl = document.getElementById('refresh-status');
    if (statusEl) {
        statusEl.textContent = '⏸️ Auto-refresh: OFF';
    }
}

/**
 * Refresh metrics via AJAX
 */
function refreshMetrics() {
    if (isRefreshing) return;

    isRefreshing = true;
    document.body.classList.add('refreshing');

    const apiUrl = window.metricsApiUrl || '/api/admin/metrics-api/';

    fetch(apiUrl)
        .then(response => response.json())
        .then(data => {
            if (data.error) {
                console.error('Metrics refresh error:', data.error);
                return;
            }

            // Update timestamp
            const timestampEl = document.getElementById('last-update');
            if (timestampEl && data.timestamp) {
                const timestamp = new Date(data.timestamp);
                timestampEl.textContent = timestamp.toLocaleString();
            }

            // Update CPU usage
            updateProgressBar('cpu', data.performance?.cpu?.usage_percent);

            // Update Memory usage
            updateProgressBar('memory', data.performance?.memory?.used_percent);

            // Update Disk usage
            updateProgressBar('disk', data.performance?.disk?.used_percent);

            console.log('Metrics refreshed successfully');
        })
        .catch(error => {
            console.error('Metrics refresh failed:', error);
        })
        .finally(() => {
            isRefreshing = false;
            document.body.classList.remove('refreshing');
        });
}

/**
 * Update progress bar dynamically
 */
function updateProgressBar(type, value) {
    const progressBar = document.querySelector(`[data-metric="${type}"] .progress-fill`);
    if (progressBar && value !== undefined) {
        progressBar.style.width = value + '%';

        // Update color classes
        progressBar.className = 'progress-fill';
        if (value > 85) {
            progressBar.classList.add('danger');
        } else if (value > 70) {
            progressBar.classList.add('warning');
        }
    }
}

/**
 * Manual refresh
 */
function manualRefresh() {
    location.reload();
}

/**
 * Handle page visibility changes
 */
function handleVisibilityChange() {
    if (document.hidden) {
        stopAutoRefresh();
    } else {
        startAutoRefresh();
    }
}

/**
 * Initialize metrics dashboard
 */
function initMetricsDashboard() {
    // Event delegation for action buttons
    document.addEventListener('click', (e) => {
        const target = e.target;

        // Retry button
        if (target.dataset.action === 'retry') {
            e.preventDefault();
            location.reload();
        }

        // Manual refresh button
        if (target.dataset.action === 'manual-refresh') {
            e.preventDefault();
            manualRefresh();
        }
    });

    // Start auto-refresh
    startAutoRefresh();

    // Add manual refresh button to header
    const header = document.querySelector('.metrics-header');
    if (header) {
        const refreshButton = document.createElement('button');
        refreshButton.innerHTML = '🔄 Refresh Now';
        refreshButton.className = 'manual-refresh-button';
        refreshButton.style.cssText = 'position: absolute; top: 1rem; left: 1rem; background: rgba(255,255,255,0.2); color: white; border: none; padding: 0.5rem 1rem; border-radius: 6px; cursor: pointer; backdrop-filter: blur(10px); font-weight: 500; transition: background 0.15s;';
        refreshButton.dataset.action = 'manual-refresh';
        header.appendChild(refreshButton);

        // Add hover effect
        refreshButton.addEventListener('mouseenter', () => {
            refreshButton.style.background = 'rgba(255,255,255,0.3)';
        });
        refreshButton.addEventListener('mouseleave', () => {
            refreshButton.style.background = 'rgba(255,255,255,0.2)';
        });
    }

    // Pause auto-refresh when page is not visible
    document.addEventListener('visibilitychange', handleVisibilityChange);

    console.log('🚀 AriStay System Metrics Dashboard loaded successfully!');
}

// Cleanup on page unload
window.addEventListener('beforeunload', () => {
    stopAutoRefresh();
});

// Initialize when DOM is ready
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initMetricsDashboard);
} else {
    initMetricsDashboard();
}
