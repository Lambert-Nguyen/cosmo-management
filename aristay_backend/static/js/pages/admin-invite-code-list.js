/**
 * Admin Invite Code List Page JavaScript
 * Handles filter auto-submission and interactive behaviors
 */

// Auto-submit form on filter change
document.addEventListener('DOMContentLoaded', function() {
    const filterSelects = document.querySelectorAll('select[name="role"], select[name="task_group"], select[name="status"]');
    filterSelects.forEach(select => {
        select.addEventListener('change', function() {
            this.form.submit();
        });
    });

    // Confirmation handlers using event delegation
    document.addEventListener('click', function(e) {
        const confirmBtn = e.target.closest('[data-confirm]');
        if (confirmBtn) {
            const message = confirmBtn.dataset.confirm;
            if (!confirm(message)) {
                e.preventDefault();
                return false;
            }
        }
    });
});
