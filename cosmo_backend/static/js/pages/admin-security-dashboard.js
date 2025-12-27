/**
 * Security Dashboard Page
 */

let refreshInterval;

document.addEventListener('DOMContentLoaded', function() {
    const dashboard = document.querySelector('.security-dashboard');
    if (!dashboard) return;

    // Get refresh interval from data attribute
    const intervalSeconds = parseInt(dashboard.dataset.refreshInterval) || 30;
    
    // Set up auto-refresh
    refreshInterval = setInterval(refreshData, intervalSeconds * 1000);

    // Set up refresh button
    const refreshBtn = document.querySelector('.refresh-btn');
    if (refreshBtn) {
        refreshBtn.addEventListener('click', refreshData);
    }
});

// Clear interval when leaving the page
window.addEventListener('beforeunload', function() {
    if (refreshInterval) {
        clearInterval(refreshInterval);
    }
});

function refreshData() {
    const dashboard = document.querySelector('.security-dashboard');
    if (!dashboard) return;
    
    dashboard.classList.add('loading');
    
    // Use current URL for refresh
    fetch(window.location.href, {
        headers: {
            'Accept': 'application/json',
            'X-Requested-With': 'XMLHttpRequest'
        }
    })
    .then(response => response.json())
    .then(data => {
        updateStats(data);
        updateEvents(data.recent_events);
        dashboard.classList.remove('loading');
    })
    .catch(error => {
        console.error('Failed to refresh data:', error);
        dashboard.classList.remove('loading');
    });
}

function updateStats(data) {
    const setContent = (id, value) => {
        const el = document.getElementById(id);
        if (el) el.textContent = value;
    };

    setContent('successful-logins', data.login_stats.successful_logins_24h);
    setContent('failed-logins', data.login_stats.failed_logins_24h);
    setContent('active-sessions', data.session_stats.active_sessions);
    setContent('unique-users', data.session_stats.unique_users_24h);
    setContent('suspicious-ips', data.threat_stats.suspicious_ips);
    setContent('blocked-ips', data.threat_stats.blocked_ips);
    setContent('high-severity', data.threat_stats.high_severity_events);
}

function updateEvents(events) {
    const tbody = document.getElementById('events-tbody');
    if (!tbody) return;
    
    tbody.innerHTML = '';
    
    if (!events || events.length === 0) {
        tbody.innerHTML = '<tr class="empty-state-row"><td colspan="6">No recent security events</td></tr>';
        return;
    }
    
    events.forEach(event => {
        const row = document.createElement('tr');
        const timestamp = new Date(event.created_at).toLocaleDateString('en-US', {
            month: 'short',
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit',
            second: '2-digit'
        });
        
        let details = '';
        if (event.details && typeof event.details === 'object') {
            for (const [key, value] of Object.entries(event.details)) {
                details += `<strong>${key}:</strong> ${value}<br>`;
            }
        }
        
        row.innerHTML = `
            <td>${timestamp}</td>
            <td><span class="event-type">${event.event_type}</span></td>
            <td><span class="severity ${event.severity}">${event.severity}</span></td>
            <td>${event.user || 'Anonymous'}</td>
            <td>${event.ip_address}</td>
            <td>${details}</td>
        `;
        
        tbody.appendChild(row);
    });
}
