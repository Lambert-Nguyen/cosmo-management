/**
 * System Recovery Dashboard
 * Handles diagnostics download and auto-refresh functionality
 */

// Auto-refresh interval (30 seconds)
let refreshInterval = null;

/**
 * Download diagnostics data as JSON file
 */
function downloadDiagnostics() {
    // Get diagnostic data from the page
    const recoveryInfo = window.recoveryInfo || {};

    const diagnosticData = {
        timestamp: new Date().toISOString(),
        system_status: recoveryInfo.system_status || 'unknown',
        recent_errors_count: recoveryInfo.recent_errors_count || 0,
        diagnostic_info: recoveryInfo.diagnostic_info || {},
        recovery_suggestions_count: recoveryInfo.recovery_suggestions_count || 0,
        url: window.location.href,
        user_agent: navigator.userAgent,
    };

    const blob = new Blob([JSON.stringify(diagnosticData, null, 2)], { type: 'application/json' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `cosmo-diagnostics-${new Date().toISOString().slice(0, 19)}.json`;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
}

/**
 * Start auto-refresh interval
 */
function startAutoRefresh() {
    // Clear any existing interval
    if (refreshInterval) {
        clearInterval(refreshInterval);
    }

    // Set up 30-second auto-refresh
    refreshInterval = setInterval(() => {
        location.reload();
    }, 30000);
}

/**
 * Stop auto-refresh interval
 */
function stopAutoRefresh() {
    if (refreshInterval) {
        clearInterval(refreshInterval);
        refreshInterval = null;
    }
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
 * Initialize recovery dashboard
 */
function initRecoveryDashboard() {
    // Event delegation for action buttons
    document.addEventListener('click', (e) => {
        const target = e.target;

        // Refresh button
        if (target.dataset.action === 'refresh') {
            e.preventDefault();
            location.reload();
        }

        // Download diagnostics button
        if (target.dataset.action === 'download-diagnostics') {
            e.preventDefault();
            downloadDiagnostics();
        }
    });

    // Set up auto-refresh
    startAutoRefresh();

    // Stop refresh when page is hidden
    document.addEventListener('visibilitychange', handleVisibilityChange);

    console.log('🚨 Cosmo System Crash Recovery loaded successfully!');
}

// Initialize when DOM is ready
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initRecoveryDashboard);
} else {
    initRecoveryDashboard();
}
