/**
 * Invite Codes Create Page
 * Handles role description updates
 */

class InviteCodesCreate {
    constructor() {
        this.roleSelect = document.getElementById('role');
        this.descriptionDiv = document.getElementById('role-description');

        this.roleDescriptions = {
            'staff': 'Basic user with limited permissions. Can view and update assigned tasks.',
            'manager': 'Can view all tasks, manage team members, and access reporting features.',
            'superuser': 'Full system access including user management, system settings, and all features.',
            'viewer': 'Read-only access to view information without making changes.'
        };

        this.attachEventListeners();
        this.updateRoleDescription();
    }

    attachEventListeners() {
        if (this.roleSelect) {
            this.roleSelect.addEventListener('change', () => this.updateRoleDescription());
        }
    }

    updateRoleDescription() {
        if (!this.roleSelect || !this.descriptionDiv) return;

        const role = this.roleSelect.value;

        if (role && this.roleDescriptions[role]) {
            this.descriptionDiv.textContent = this.roleDescriptions[role];
            this.descriptionDiv.classList.add('visible');
        } else {
            this.descriptionDiv.classList.remove('visible');
        }
    }
}

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
    new InviteCodesCreate();
});
