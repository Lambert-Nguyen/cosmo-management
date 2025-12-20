/**
 * Calendar View Page
 */

let calendar;
let currentFilters = {};

document.addEventListener('DOMContentLoaded', function() {
    initializeCalendar();
    loadFilterOptions();
    setupEventListeners();
});

function setupEventListeners() {
    const refreshBtn = document.getElementById('refreshCalendarBtn');
    if (refreshBtn) {
        refreshBtn.addEventListener('click', refreshCalendar);
    }

    const exportBtn = document.getElementById('exportCalendarBtn');
    if (exportBtn) {
        exportBtn.addEventListener('click', exportCalendar);
    }

    const applyFiltersBtn = document.getElementById('applyFiltersBtn');
    if (applyFiltersBtn) {
        applyFiltersBtn.addEventListener('click', applyFilters);
    }

    const clearFiltersBtn = document.getElementById('clearFiltersBtn');
    if (clearFiltersBtn) {
        clearFiltersBtn.addEventListener('click', clearFilters);
    }
}

function initializeCalendar() {
    const calendarEl = document.getElementById('calendar');
    
    if (!calendarEl) return;

    calendar = new FullCalendar.Calendar(calendarEl, {
        initialView: 'dayGridMonth',
        headerToolbar: {
            left: 'prev,next today',
            center: 'title',
            right: 'dayGridMonth,timeGridWeek,timeGridDay,listWeek'
        },
        height: 'auto',
        events: function(info, successCallback, failureCallback) {
            loadCalendarEvents(info.start, info.end, successCallback, failureCallback);
        },
        eventClick: function(info) {
            info.jsEvent.preventDefault(); // Prevent default navigation
            showEventDetails(info.event);
        },
        dateClick: function(info) {
            showDayEvents(info.dateStr);
        },
        eventDidMount: function(info) {
            // Add custom styling based on event type
            if (info.event.extendedProps.type === 'task') {
                info.el.classList.add('event-task');
            } else if (info.event.extendedProps.type === 'booking') {
                info.el.classList.add('event-booking');
            }
        },
        eventContent: function(arg) {
            // Custom event content with status badge
            const status = arg.event.extendedProps.status;
            const statusClass = `status-${status.replace('_', '-')}`;
            
            return {
                html: `
                    <div class="event-details">
                        <div class="fw-bold">${arg.event.title}</div>
                        <span class="status-badge ${statusClass}">${status}</span>
                    </div>
                `
            };
        }
    });
    
    calendar.render();
}

function loadCalendarEvents(start, end, successCallback, failureCallback) {
    const params = new URLSearchParams({
        start_date: start.toISOString().split('T')[0],
        end_date: end.toISOString().split('T')[0],
        ...currentFilters
    });

    fetch(`/api/calendar/events/?${params}`)
        .then(response => {
            if (!response.ok) {
                throw new Error('Failed to load events');
            }
            return response.json();
        })
        .then(events => {
            // Remove url property from events to prevent automatic navigation
            const processedEvents = events.map(event => {
                const { url, ...eventWithoutUrl } = event;
                return {
                    ...eventWithoutUrl,
                    extendedProps: {
                        ...eventWithoutUrl,
                        url: url // Keep url in extendedProps for modal use
                    }
                };
            });
            successCallback(processedEvents);
        })
        .catch(error => {
            console.error('Error loading events:', error);
            failureCallback(error);
        });
}

function loadFilterOptions() {
    // Load properties
    fetch('/api/calendar/properties/')
        .then(response => response.json())
        .then(data => {
            const propertySelect = document.getElementById('propertyFilter');
            if (!propertySelect) return;
            
            // Handle both array and paginated response formats
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
    fetch('/api/calendar/users/')
        .then(response => response.json())
        .then(data => {
            const userSelect = document.getElementById('assignedToFilter');
            if (!userSelect) return;

            // Handle both array and paginated response formats
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
        task_type: document.getElementById('taskTypeFilter').value,
        assigned_to: document.getElementById('assignedToFilter').value,
        include_tasks: document.getElementById('includeTasks').checked,
        include_bookings: document.getElementById('includeBookings').checked
    };

    // Remove empty filters
    Object.keys(currentFilters).forEach(key => {
        if (currentFilters[key] === '' || currentFilters[key] === false) {
            delete currentFilters[key];
        }
    });

    if (calendar) {
        calendar.refetchEvents();
    }
}

function clearFilters() {
    const propertyFilter = document.getElementById('propertyFilter');
    const statusFilter = document.getElementById('statusFilter');
    const taskTypeFilter = document.getElementById('taskTypeFilter');
    const assignedToFilter = document.getElementById('assignedToFilter');
    const includeTasks = document.getElementById('includeTasks');
    const includeBookings = document.getElementById('includeBookings');

    if (propertyFilter) propertyFilter.value = '';
    if (statusFilter) statusFilter.value = '';
    if (taskTypeFilter) taskTypeFilter.value = '';
    if (assignedToFilter) assignedToFilter.value = '';
    if (includeTasks) includeTasks.checked = true;
    if (includeBookings) includeBookings.checked = true;
    
    currentFilters = {};
    if (calendar) {
        calendar.refetchEvents();
    }
}

function refreshCalendar() {
    if (calendar) {
        calendar.refetchEvents();
    }
}

function showEventDetails(event) {
    const props = event.extendedProps;
    const modalEl = document.getElementById('eventModal');
    if (!modalEl) return;

    const modal = new bootstrap.Modal(modalEl);
    
    const titleEl = document.getElementById('eventModalTitle');
    if (titleEl) titleEl.textContent = event.title;
    
    let bodyContent = `
        <div class="row">
            <div class="col-6"><strong>Type:</strong> ${props.type}</div>
            <div class="col-6"><strong>Status:</strong> <span class="status-badge status-${props.status.replace('_', '-')}">${props.status}</span></div>
        </div>
    `;
    
    if (props.property_name) {
        bodyContent += `<div class="row mt-2"><div class="col-12"><strong>Property:</strong> ${props.property_name}</div></div>`;
    }
    
    if (props.guest_name) {
        bodyContent += `<div class="row mt-2"><div class="col-12"><strong>Guest:</strong> ${props.guest_name}</div></div>`;
    }
    
    if (props.assigned_to) {
        bodyContent += `<div class="row mt-2"><div class="col-12"><strong>Assigned To:</strong> ${props.assigned_to}</div></div>`;
    }
    
    if (props.description) {
        bodyContent += `<div class="row mt-2"><div class="col-12"><strong>Description:</strong><br>${props.description.replace(/\n/g, '<br>')}</div></div>`;
    }
    
    bodyContent += `
        <div class="row mt-2">
            <div class="col-6"><strong>Start:</strong> ${event.start.toLocaleString()}</div>
            <div class="col-6"><strong>End:</strong> ${event.end ? event.end.toLocaleString() : 'All Day'}</div>
        </div>
    `;
    
    const bodyEl = document.getElementById('eventModalBody');
    if (bodyEl) bodyEl.innerHTML = bodyContent;

    const actionBtn = document.getElementById('eventModalAction');
    if (actionBtn) {
        actionBtn.onclick = () => {
            window.open(props.url, '_blank');
        };
    }
    
    modal.show();
}

function showDayEvents(dateStr) {
    fetch(`/api/calendar/day_events/?date=${dateStr}`)
        .then(response => response.json())
        .then(data => {
            let content = `<h6>Events for ${dateStr}</h6>`;
            
            if (data.tasks.length > 0) {
                content += '<h6>Tasks:</h6><ul>';
                data.tasks.forEach(task => {
                    content += `<li>${task.title} - ${task.status_display}</li>`;
                });
                content += '</ul>';
            }
            
            if (data.bookings.length > 0) {
                content += '<h6>Bookings:</h6><ul>';
                data.bookings.forEach(booking => {
                    content += `<li>${booking.guest_name} - ${booking.property_name} (${booking.status_display})</li>`;
                });
                content += '</ul>';
            }
            
            if (data.total_events === 0) {
                content += '<p class="text-muted">No events for this day.</p>';
            }
            
            // Show in a simple alert for now - you could create a more sophisticated modal
            alert(content); // Consider replacing with a modal in future
        })
        .catch(error => {
            console.error('Error loading day events:', error);
            alert('Error loading events for this day.');
        });
}

function exportCalendar() {
    if (!calendar) return;

    // Simple CSV export functionality
    const events = calendar.getEvents();
    let csv = 'Title,Type,Start,End,Status,Property,Description\n';
    
    events.forEach(event => {
        const props = event.extendedProps;
        csv += `"${event.title}","${props.type}","${event.start.toISOString()}","${event.end ? event.end.toISOString() : ''}","${props.status}","${props.property_name || ''}","${props.description || ''}"\n`;
    });
    
    const blob = new Blob([csv], { type: 'text/csv' });
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `calendar-export-${new Date().toISOString().split('T')[0]}.csv`;
    a.click();
    window.URL.revokeObjectURL(url);
}
