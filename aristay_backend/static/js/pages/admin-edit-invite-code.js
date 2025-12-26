/**
 * Admin Edit Invite Code Page
 */

/**
 * Update role description based on selected role
 */
function updateRoleDescription() {
    const roleSelect = document.getElementById('role');
    const descriptionDiv = document.getElementById('role-description');

    const descriptions = {
        'staff': 'Staff members can view and manage tasks assigned to them. They have limited access to system features.',
        'manager': 'Managers can view all tasks, manage team members, and access management features. They have broader system access.',
        'admin': 'Admins have full system access including user management, system settings, and all administrative features.',
        'viewer': 'Viewers have read-only access to view tasks and system information without the ability to make changes.'
    };

    const selectedRole = roleSelect.value;
    if (selectedRole && descriptions[selectedRole]) {
        descriptionDiv.textContent = descriptions[selectedRole];
        descriptionDiv.classList.remove('hidden');
        descriptionDiv.style.display = 'block';
    } else {
        descriptionDiv.classList.add('hidden');
        descriptionDiv.style.display = 'none';
    }
}

/**
 * Initialize page on load
 */
document.addEventListener('DOMContentLoaded', function() {
    // Initialize role description on page load
    updateRoleDescription();

    // Event listener for role select change
    const roleSelect = document.getElementById('role');
    if (roleSelect) {
        roleSelect.addEventListener('change', updateRoleDescription);
    }
});
