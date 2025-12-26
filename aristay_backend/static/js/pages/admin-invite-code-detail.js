/**
 * Admin Invite Code Detail Page
 * Handles form confirmations
 */

class InviteCodeDetail {
    constructor() {
        this.attachEventListeners();
    }

    attachEventListeners() {
        // Revoke confirmations
        const revokeForm = document.querySelector('[data-action="revoke"]');
        if (revokeForm) {
            revokeForm.addEventListener('submit', (e) => {
                if (!confirm('Are you sure you want to revoke this invite code?')) {
                    e.preventDefault();
                }
            });
        }

        // Reactivate confirmations
        const reactivateForm = document.querySelector('[data-action="reactivate"]');
        if (reactivateForm) {
            reactivateForm.addEventListener('submit', (e) => {
                if (!confirm('Are you sure you want to reactivate this invite code?')) {
                    e.preventDefault();
                }
            });
        }

        // Delete confirmations
        const deleteForm = document.querySelector('[data-action="delete"]');
        if (deleteForm) {
            deleteForm.addEventListener('submit', (e) => {
                if (!confirm('Are you sure you want to permanently delete this invite code? This action cannot be undone.')) {
                    e.preventDefault();
                }
            });
        }
    }
}

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
    new InviteCodeDetail();
});
