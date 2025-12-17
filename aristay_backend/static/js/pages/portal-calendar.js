let calendar;
let currentFilters = {};
let currentEvent = null;

document.addEventListener('DOMContentLoaded', () => {
    wireActions();
    wireModalBackdropClose();
    initializeCalendar();
    loadFilterOptions();
});

function wireActions() {
    document.addEventListener('click', (event) => {
        const target = event.target.closest('[data-action]');
        if (!target) return;

        switch (target.dataset.action) {
            case 'calendar-refresh':
                event.preventDefault();
                refreshCalendar();
                break;
            case 'calendar-export':
                event.preventDefault();
                exportCalendar();
                break;
            case 'calendar-apply-filters':
                event.preventDefault();
                applyFilters();
                break;
            case 'calendar-clear-filters':
                event.preventDefault();
                clearFilters();
                break;
            case 'calendar-close-modal':
                event.preventDefault();
                closeEventModal();
                break;
            case 'calendar-view-details':
                event.preventDefault();
                viewEventDetails();
                break;
            default:
                break;
        }
    });
}

function wireModalBackdropClose() {
    const modal = document.getElementById('eventModal');
    if (!modal) return;

    modal.addEventListener('click', (event) => {
        if (event.target === modal) {
            closeEventModal();
        }
    });
}

function initializeCalendar() {
    const calendarEl = document.getElementById('calendar');

    calendar = new FullCalendar.Calendar(calendarEl, {
        initialView: 'dayGridMonth',
        headerToolbar: {
            left: 'prev,next today',
            center: 'title',
            right: 'dayGridMonth,timeGridWeek,timeGridDay,listWeek',
        },
        height: 'auto',
        aspectRatio: 1.8,
        slotMinTime: '06:00:00',
        slotMaxTime: '22:00:00',
        slotDuration: '01:00:00',
        slotLabelInterval: '01:00:00',
        allDaySlot: true,
        dayMaxEvents: 4,
        moreLinkClick: 'popover',
        expandRows: true,
        events: (info, successCallback, failureCallback) => {
            loadCalendarEvents(info.start, info.end, successCallback, failureCallback);
        },
        eventClick: (info) => {
            info.jsEvent.preventDefault();
            if (info.jsEvent.stopPropagation) {
                info.jsEvent.stopPropagation();
            }
            showEventDetails(info.event);
        },
        dateClick: (info) => {
            showDayEvents(info.dateStr);
        },
        eventDidMount: (info) => {
            if (info.event.extendedProps.type === 'task') {
                info.el.classList.add('event-task');
            } else if (info.event.extendedProps.type === 'booking') {
                info.el.classList.add('event-booking');
            }
        },
    });

    calendar.render();
}

function showLoading() {
    const el = document.getElementById('loadingIndicator');
    if (el) {
        el.style.display = 'flex';
        el.querySelector('span').textContent = 'Loading calendar...';
    }
}

function hideLoading() {
    const el = document.getElementById('loadingIndicator');
    if (el) el.style.display = 'none';
}

function showError(message) {
    console.error(message);
    const el = document.getElementById('errorDisplay');
    if (el) {
        el.querySelector('span').textContent = message || 'Error loading calendar data';
        el.style.display = 'flex';
    }
}

function loadCalendarEvents(start, end, successCallback, failureCallback) {
        const params = new URLSearchParams({
            start_date: start.toISOString().split('T')[0],
            end_date: end.toISOString().split('T')[0],
            ...currentFilters
        });

        // Get CSRF token from meta tag
        const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

        showLoading();
        fetch(`/api/calendar/events/?${params}`, {
            method: 'GET',
            headers: {
                'X-CSRFToken': csrfToken,
                'Content-Type': 'application/json',
            },
            credentials: 'include'
        })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Failed to load events');
                }
                return response.json();
            })
            .then(events => {
                const processedEvents = events.map(event => {
                    const { url, ...eventWithoutUrl } = event;
                    return {
                        ...eventWithoutUrl,
                        extendedProps: {
                            ...eventWithoutUrl,
                            url: url
                        }
                    };
                });
                console.log('FullCalendar events loaded:', processedEvents.length, 'events');
                hideLoading();
                successCallback(processedEvents);
            })
            .catch(error => {
                showError('Error loading events');
                hideLoading();
                failureCallback(error);
            });
}

function loadFilterOptions() {
        // Get CSRF token from meta tag
        const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
        
        // Load properties
        fetch('/api/calendar/properties/', {
            method: 'GET',
            headers: {
                'X-CSRFToken': csrfToken,
                'Content-Type': 'application/json',
            },
            credentials: 'include'
        })
            .then(response => response.json())
            .then(data => {
                const propertySelect = document.getElementById('propertyFilter');
                const properties = Array.isArray(data) ? data : (data.results || data);
                if (properties && properties.forEach) {
                    properties.forEach(property => {
                        const option = document.createElement('option');
                        option.value = property.id;
                        option.textContent = property.name;
                        propertySelect.appendChild(option);
                    });
                }
            })
            .catch(error => console.error('Error loading properties:', error));

        // Load users
        fetch('/api/calendar/users/', {
            method: 'GET',
            headers: {
                'X-CSRFToken': csrfToken,
                'Content-Type': 'application/json',
            },
            credentials: 'include'
        })
            .then(response => response.json())
            .then(data => {
                const userSelect = document.getElementById('assignedToFilter');
                const users = Array.isArray(data) ? data : (data.results || data);
                if (users && users.forEach) {
                    users.forEach(user => {
                        const option = document.createElement('option');
                        option.value = user.id;
                        option.textContent = user.username;
                        userSelect.appendChild(option);
                    });
                }
            })
            .catch(error => console.error('Error loading users:', error));
}

function applyFilters() {
        currentFilters = {
            property_id: document.getElementById('propertyFilter').value,
            status: document.getElementById('statusFilter').value,
            user_id: document.getElementById('assignedToFilter').value,
            event_type: document.getElementById('eventTypeFilter').value,
        };
        
        // Remove empty filters
        Object.keys(currentFilters).forEach(key => {
            if (!currentFilters[key]) {
                delete currentFilters[key];
            }
        });
        
        calendar.refetchEvents();
}

function clearFilters() {
        document.getElementById('propertyFilter').value = '';
        document.getElementById('statusFilter').value = '';
        document.getElementById('assignedToFilter').value = '';
        document.getElementById('eventTypeFilter').value = '';
        currentFilters = {};
        calendar.refetchEvents();
}

function refreshCalendar() {
    if (calendar) {
        calendar.refetchEvents();
    }
}

function exportCalendar() {
        if (!calendar) return;
        const events = calendar.getEvents();
        let csv = 'Title,Start,End,Type,Status\n';
        events.forEach(ev => {
            const p = ev.extendedProps || {};
            csv += `"${ev.title}","${ev.start?.toISOString()||''}","${ev.end?.toISOString()||''}","${p.type||''}","${p.status||''}"\n`;
        });
        const blob = new Blob([csv], { type: 'text/csv' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = `calendar-export-${new Date().toISOString().split('T')[0]}.csv`;
        a.click();
        URL.revokeObjectURL(url);
}

function showEventDetails(event) {
        currentEvent = event;
        const props = event.extendedProps;
        
        document.getElementById('eventModalTitle').textContent = event.title;
        
        let bodyContent = `
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-bottom: 1rem;">
                <div><strong>Type:</strong> ${props.type}</div>
                <div><strong>Status:</strong> <span class="status-badge status-${props.status.replace('_', '-')}">${props.status}</span></div>
            </div>
        `;
        
        if (props.property) {
            bodyContent += `<div style="margin-bottom: 0.5rem;"><strong>Property:</strong> ${props.property}</div>`;
        }
        
        if (props.guest_name) {
            bodyContent += `<div style="margin-bottom: 0.5rem;"><strong>Guest:</strong> ${props.guest_name}</div>`;
        }
        
        if (props.assigned_to && props.assigned_to.trim()) {
            bodyContent += `<div style="margin-bottom: 0.5rem;"><strong>Assigned To:</strong> ${props.assigned_to}</div>`;
        } else if (props.type === 'task') {
            bodyContent += `<div style="margin-bottom: 0.5rem;"><strong>Assigned To:</strong> <em>Not Assigned</em></div>`;
        }
        
        if (props.description) {
            bodyContent += `<div style="margin-bottom: 0.5rem;"><strong>Description:</strong><br>${props.description.replace(/\n/g, '<br>')}</div>`;
        }
        
        bodyContent += `
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                <div><strong>Start:</strong> ${event.start.toLocaleString()}</div>
                <div><strong>End:</strong> ${event.end ? event.end.toLocaleString() : 'All Day'}</div>
            </div>
        `;
        
    document.getElementById('eventModalBody').innerHTML = bodyContent;
    const modal = document.getElementById('eventModal');
    if (modal) {
        modal.style.display = 'flex';
    }
}

function closeEventModal() {
    const modal = document.getElementById('eventModal');
    if (modal) {
        modal.style.display = 'none';
    }
    currentEvent = null;
}

function viewEventDetails() {
    if (currentEvent && currentEvent.extendedProps.url) {
        window.open(currentEvent.extendedProps.url, '_blank');
    }
    closeEventModal();
}

function showDayEvents(dateStr) {
        // Get CSRF token from meta tag
        const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
        
        fetch(`/api/calendar/day_events/?date=${dateStr}`, {
            method: 'GET',
            headers: {
                'X-CSRFToken': csrfToken,
                'Content-Type': 'application/json',
            },
            credentials: 'include'
        })
            .then(response => response.json())
            .then(data => {
                let content = `<h6>Events for ${new Date(dateStr).toLocaleDateString()}</h6>`;
                
                if (data.length === 0) {
                    content += '<p>No events scheduled for this day.</p>';
                } else {
                    data.forEach(event => {
                        content += `
                            <div style="padding: 0.5rem; border-left: 3px solid ${event.color || '#007bff'}; margin-bottom: 0.5rem; background-color: #f8f9fa;">
                                <strong>${event.title}</strong><br>
                                <small>${event.start} - ${event.end || 'All Day'}</small>
                            </div>
                        `;
                    });
                }
                
                alert(content); // Simple alert for now, could be improved with a proper modal
            })
            .catch(error => console.error('Error loading day events:', error));
}
