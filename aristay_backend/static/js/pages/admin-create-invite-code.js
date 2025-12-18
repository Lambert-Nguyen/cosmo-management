/**
 * Admin Create Invite Code Page
 */

/**
 * Select usage option (single or multiple use)
 * @param {string} type - 'single' or 'multiple'
 */
function selectUsageOption(type) {
    const singleOption = document.querySelector('.usage-option:first-child');
    const multipleOption = document.querySelector('.usage-option:last-child');
    const maxUsesGroup = document.getElementById('max-uses-group');
    const singleRadio = document.getElementById('single-use');
    const multipleRadio = document.getElementById('multiple-use');

    if (type === 'single') {
        singleOption.classList.add('selected');
        multipleOption.classList.remove('selected');
        singleRadio.checked = true;
        multipleRadio.checked = false;
        maxUsesGroup.style.display = 'none';
    } else {
        singleOption.classList.remove('selected');
        multipleOption.classList.add('selected');
        singleRadio.checked = false;
        multipleRadio.checked = true;
        maxUsesGroup.style.display = 'block';
    }
}

/**
 * Update role description based on selected role
 */
function updateRoleDescription() {
    const roleSelect = document.getElementById('role');
    const descriptionDiv = document.getElementById('role-description');
    const role = roleSelect.value;

    const descriptions = {
        'staff': 'Basic user with limited permissions. Can view and update assigned tasks.',
        'manager': 'Can view all tasks, manage team members, and access reporting features.',
        'superuser': 'Full system access including user management, system settings, and all features.',
        'viewer': 'Read-only access to view information without making changes.'
    };

    if (role && descriptions[role]) {
        descriptionDiv.textContent = descriptions[role];
        descriptionDiv.style.display = 'block';
    } else {
        descriptionDiv.style.display = 'none';
    }
}

/**
 * Initialize page on load
 */
document.addEventListener('DOMContentLoaded', function() {
    // Initialize role description on page load
    updateRoleDescription();

    // Event delegation for usage option clicks
    document.addEventListener('click', (e) => {
        const usageOption = e.target.closest('.usage-option');
        if (usageOption) {
            const isFirstOption = usageOption === document.querySelector('.usage-option:first-child');
            selectUsageOption(isFirstOption ? 'single' : 'multiple');
        }
    });

    // Event listener for role select change
    const roleSelect = document.getElementById('role');
    if (roleSelect) {
        roleSelect.addEventListener('change', updateRoleDescription);
    }
});
