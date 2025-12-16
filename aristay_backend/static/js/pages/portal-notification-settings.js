async function parseJsonSafe(response) {
    const text = await response.text();
    try {
        return text ? JSON.parse(text) : {};
    } catch {
        return {};
    }
}

function getCsrfToken() {
    const el = document.querySelector('meta[name="csrf-token"]');
    return el ? el.getAttribute('content') : null;
}

function showMessage(message, type) {
    const container = document.getElementById('messageContainer');
    const content = document.getElementById('messageContent');
    if (!container || !content) return;

    content.textContent = message;
    content.classList.toggle('is-success', type === 'success');
    content.classList.toggle('is-error', type !== 'success');

    container.classList.remove('hidden');

    window.setTimeout(() => {
        container.classList.add('hidden');
    }, 4000);
}

async function markAsRead(notificationId) {
    try {
        const response = await fetch(`/api/notifications/${notificationId}/read/`, {
            method: 'PATCH',
            headers: {
                'X-CSRFToken': getCsrfToken(),
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ read: true }),
        });

        const data = await parseJsonSafe(response);
        const ok = response.ok || data.success;

        if (!ok) {
            showMessage('Failed to mark notification as read', 'error');
            return;
        }

        const notificationElement = document.querySelector(`[data-id="${notificationId}"]`);
        if (notificationElement) {
            notificationElement.classList.remove('notification-item--unread');
            notificationElement.classList.add('notification-item--read');

            const unreadDot = notificationElement.querySelector('.notification-unread-dot');
            if (unreadDot) unreadDot.remove();

            const markReadBtn = notificationElement.querySelector('[data-action="notif-mark-read"]');
            if (markReadBtn) markReadBtn.remove();
        }

        showMessage('Notification marked as read', 'success');

        window.setTimeout(() => {
            window.location.reload();
        }, 1000);
    } catch {
        showMessage('Network error occurred', 'error');
    }
}

async function markAllRead() {
    try {
        const response = await fetch('/api/notifications/mark-all-read/', {
            method: 'POST',
            headers: {
                'X-CSRFToken': getCsrfToken(),
                'Content-Type': 'application/json',
            },
        });

        const data = await parseJsonSafe(response);
        const ok = response.ok || data.success;

        if (!ok) {
            showMessage('Failed to mark all notifications as read', 'error');
            return;
        }

        showMessage('All notifications marked as read', 'success');
        window.setTimeout(() => {
            window.location.reload();
        }, 1000);
    } catch {
        showMessage('Network error occurred', 'error');
    }
}

function initNotificationSettingsPage() {
    const messageContainer = document.getElementById('messageContainer');
    if (messageContainer) {
        messageContainer.classList.add('hidden');
    }

    document.addEventListener('click', (event) => {
        const markReadBtn = event.target.closest('[data-action="notif-mark-read"]');
        if (markReadBtn) {
            const notificationId = markReadBtn.getAttribute('data-notification-id');
            if (notificationId) {
                event.preventDefault();
                markAsRead(notificationId);
            }
            return;
        }

        const markAllBtn = event.target.closest('[data-action="notif-mark-all-read"]');
        if (markAllBtn) {
            event.preventDefault();
            markAllRead();
        }
    });
}

initNotificationSettingsPage();
