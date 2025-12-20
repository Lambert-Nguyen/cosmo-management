/**
 * Admin Permission Management Page
 */

let currentUserPermissions = {};
let availablePermissions = [];
let allUsers = [];

const usersContainer = document.getElementById('users-container');
const userSearch = document.getElementById('user-search');
const roleButtons = document.querySelectorAll('.role-btn');
const messagesDiv = document.getElementById('messages');

// Initialize the page
document.addEventListener('DOMContentLoaded', function() {
    loadInitialData();
    setupEventListeners();
});

function setupEventListeners() {
    // Search functionality
    if (userSearch) {
        userSearch.addEventListener('input', filterUsers);
    }
    
    // Role filter buttons
    if (roleButtons) {
        roleButtons.forEach(btn => {
            btn.addEventListener('click', function() {
                roleButtons.forEach(b => b.classList.remove('active'));
                this.classList.add('active');
                filterUsers();
            });
        });
    }

    // Event delegation for permission actions
    if (usersContainer) {
        usersContainer.addEventListener('click', function(e) {
            const btn = e.target.closest('button');
            if (!btn) return;

            const action = btn.dataset.action;
            const userId = btn.dataset.userId;
            const permission = btn.dataset.permission;

            if (!action || !userId || !permission) return;

            if (action === 'revoke') {
                revokePermission(userId, permission);
            } else if (action === 'grant') {
                grantPermission(userId, permission);
            } else if (action === 'reset') {
                removeOverride(userId, permission);
            }
        });
    }
}

async function loadInitialData() {
    try {
        // Load user permissions, available permissions, and manageable users
        const [userPerms, availablePerms, manageableUsers] = await Promise.all([
            fetch('/api/permissions/user/').then(r => r.json()),
            fetch('/api/permissions/available/').then(r => r.json()),
            fetch('/api/permissions/manageable-users/').then(r => r.json())
        ]);

        currentUserPermissions = userPerms;
        availablePermissions = availablePerms.permissions || [];
        allUsers = manageableUsers.users || [];

        updateStats();
        renderUsers();
        renderPermissionsReference();
        
    } catch (error) {
        showMessage('Error loading data: ' + error.message, 'error');
    }
}

function updateStats() {
    const totalUsersEl = document.getElementById('total-users');
    const totalPermsEl = document.getElementById('total-permissions');
    const delegatablePermsEl = document.getElementById('delegatable-permissions');
    const activeOverridesEl = document.getElementById('active-overrides');

    if (totalUsersEl) totalUsersEl.textContent = allUsers.length;
    if (totalPermsEl) totalPermsEl.textContent = availablePermissions.length;
    if (delegatablePermsEl) delegatablePermsEl.textContent = (currentUserPermissions.delegatable_permissions || []).length;
    
    // Count active overrides (this would need additional API endpoint)
    if (activeOverridesEl) activeOverridesEl.textContent = '0';
}

function renderUsers() {
    const activeRoleBtn = document.querySelector('.role-btn.active');
    const activeRole = activeRoleBtn ? activeRoleBtn.dataset.role : 'all';
    const searchTerm = userSearch ? userSearch.value.toLowerCase() : '';
    
    let filteredUsers = allUsers.filter(user => {
        const matchesRole = activeRole === 'all' || user.role === activeRole;
        const matchesSearch = searchTerm === '' || 
            user.username.toLowerCase().includes(searchTerm) ||
            user.email.toLowerCase().includes(searchTerm) ||
            (user.first_name + ' ' + user.last_name).toLowerCase().includes(searchTerm);
        
        return matchesRole && matchesSearch;
    });

    if (!usersContainer) return;

    if (filteredUsers.length === 0) {
        usersContainer.innerHTML = '<div class="loading">No users found matching your criteria.</div>';
        return;
    }

    const html = filteredUsers.map(user => createUserCard(user)).join('');
    usersContainer.innerHTML = html;
    
    // Add click handlers for user cards (expand/collapse)
    document.querySelectorAll('.user-header').forEach(header => {
        header.addEventListener('click', function() {
            const permissions = this.nextElementSibling;
            permissions.classList.toggle('active');
        });
    });
}

function createUserCard(user) {
    const roleDisplay = {
        'superuser': 'Superuser',
        'manager': 'Manager', 
        'staff': 'Staff/Crew',
        'viewer': 'Viewer'
    }[user.role] || user.role;

    const permissionCategories = groupPermissionsByCategory(user.permissions);
    
    return `
        <div class="user-card">
            <div class="user-header">
                <div class="user-info">
                    <div class="user-name">${user.first_name} ${user.last_name} (${user.username})</div>
                    <div class="user-role">${roleDisplay} • ${user.email}</div>
                </div>
                <div>▼</div>
            </div>
            <div class="user-permissions">
                <div class="permission-grid">
                    ${Object.entries(permissionCategories).map(([category, perms]) => 
                        createPermissionCategory(category, perms, user)
                    ).join('')}
                </div>
            </div>
        </div>
    `;
}

function groupPermissionsByCategory(userPermissions) {
    const categories = {
        'Properties': [],
        'Bookings': [],
        'Tasks': [],
        'Users': [],
        'Reports': [],
        'System': [],
        'Checklists': [],
        'Devices': []
    };

    availablePermissions.forEach(perm => {
        const hasPermission = userPermissions[perm.name] || false;
        const canDelegate = currentUserPermissions.delegatable_permissions?.includes(perm.name) || false;
        
        const permData = {
            ...perm,
            hasPermission,
            canDelegate
        };

        if (perm.name.includes('propert')) categories.Properties.push(permData);
        else if (perm.name.includes('booking')) categories.Bookings.push(permData);
        else if (perm.name.includes('task')) categories.Tasks.push(permData);
        else if (perm.name.includes('user')) categories.Users.push(permData);
        else if (perm.name.includes('report') || perm.name.includes('analytic') || perm.name.includes('export')) categories.Reports.push(permData);
        else if (perm.name.includes('admin') || perm.name.includes('system') || perm.name.includes('log')) categories.System.push(permData);
        else if (perm.name.includes('checklist')) categories.Checklists.push(permData);
        else if (perm.name.includes('device')) categories.Devices.push(permData);
        else categories.System.push(permData);
    });

    // Remove empty categories
    Object.keys(categories).forEach(key => {
        if (categories[key].length === 0) {
            delete categories[key];
        }
    });

    return categories;
}

function createPermissionCategory(categoryName, permissions, user) {
    return `
        <div class="permission-category">
            <div class="category-header">${categoryName}</div>
            <div class="permission-list">
                ${permissions.map(perm => createPermissionItem(perm, user)).join('')}
            </div>
        </div>
    `;
}

function createPermissionItem(permission, user) {
    const status = permission.hasPermission ? 'granted' : 'denied';
    const statusText = permission.hasPermission ? 'Granted' : 'Denied';
    
    let actions = '';
    if (permission.canDelegate) {
        if (permission.hasPermission) {
            actions = `
                <button class="btn-small btn-revoke" data-action="revoke" data-user-id="${user.id}" data-permission="${permission.name}">Revoke</button>
                <button class="btn-small btn-reset" data-action="reset" data-user-id="${user.id}" data-permission="${permission.name}">Reset</button>
            `;
        } else {
            actions = `
                <button class="btn-small btn-grant" data-action="grant" data-user-id="${user.id}" data-permission="${permission.name}">Grant</button>
                <button class="btn-small btn-reset" data-action="reset" data-user-id="${user.id}" data-permission="${permission.name}">Reset</button>
            `;
        }
    }

    return `
        <div class="permission-item">
            <div class="permission-name">${permission.display_name}</div>
            <div class="permission-status">
                <span class="status-badge status-${status}">${statusText}</span>
                <div class="permission-actions">${actions}</div>
            </div>
        </div>
    `;
}

function renderPermissionsReference() {
    const categories = groupPermissionsByCategory({});
    const html = Object.entries(categories).map(([category, perms]) => 
        createReferenceCategory(category, perms)
    ).join('');
    
    const refEl = document.getElementById('permissions-reference');
    if (refEl) {
        refEl.innerHTML = `
            <div class="permission-grid">${html}</div>
        `;
    }
}

function createReferenceCategory(categoryName, permissions) {
    return `
        <div class="permission-category">
            <div class="category-header">${categoryName}</div>
            <div class="permission-list">
                ${permissions.map(perm => `
                    <div class="permission-item">
                        <div class="permission-name">${perm.display_name}</div>
                        <div class="permission-status">
                            ${perm.canDelegate ? '<span class="status-badge status-granted">Can Delegate</span>' : ''}
                        </div>
                    </div>
                `).join('')}
            </div>
        </div>
    `;
}

function filterUsers() {
    renderUsers();
}

async function grantPermission(userId, permission) {
    if (!confirm(`Grant "${permission}" permission to this user?`)) return;
    
    try {
        const response = await fetch('/api/permissions/grant/', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRFToken': getCsrfToken()
            },
            body: JSON.stringify({
                user_id: userId,
                permission: permission,
                reason: 'Granted via permission management interface'
            })
        });

        const result = await response.json();
        if (result.success) {
            showMessage(result.message, 'success');
            await loadInitialData(); // Refresh data
        } else {
            showMessage(result.error, 'error');
        }
    } catch (error) {
        showMessage('Error granting permission: ' + error.message, 'error');
    }
}

async function revokePermission(userId, permission) {
    if (!confirm(`Revoke "${permission}" permission from this user?`)) return;
    
    try {
        const response = await fetch('/api/permissions/revoke/', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRFToken': getCsrfToken()
            },
            body: JSON.stringify({
                user_id: userId,
                permission: permission,
                reason: 'Revoked via permission management interface'
            })
        });

        const result = await response.json();
        if (result.success) {
            showMessage(result.message, 'success');
            await loadInitialData(); // Refresh data
        } else {
            showMessage(result.error, 'error');
        }
    } catch (error) {
        showMessage('Error revoking permission: ' + error.message, 'error');
    }
}

async function removeOverride(userId, permission) {
    if (!confirm(`Remove permission override for "${permission}"? User will revert to role-based permissions.`)) return;
    
    try {
        const response = await fetch('/api/permissions/remove-override/', {
            method: 'DELETE',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRFToken': getCsrfToken()
            },
            body: JSON.stringify({
                user_id: userId,
                permission: permission
            })
        });

        const result = await response.json();
        if (result.success) {
            showMessage(result.message, 'success');
            await loadInitialData(); // Refresh data
        } else {
            showMessage(result.error, 'error');
        }
    } catch (error) {
        showMessage('Error removing override: ' + error.message, 'error');
    }
}

function showMessage(message, type) {
    if (!messagesDiv) return;
    
    const alertClass = type === 'error' ? 'alert-error' : 'alert-success';
    messagesDiv.innerHTML = `<div class="alert ${alertClass}">${message}</div>`;
    
    // Auto-hide after 5 seconds
    setTimeout(() => {
        messagesDiv.innerHTML = '';
    }, 5000);
}

function getCsrfToken() {
    return document.querySelector('[name=csrfmiddlewaretoken]')?.value || 
           document.cookie.split('; ').find(row => row.startsWith('csrftoken='))?.split('=')[1];
}
