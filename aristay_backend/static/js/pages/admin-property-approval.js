/**
 * Property Approval - JavaScript
 * Handles checkbox selection for property approval
 */

document.addEventListener('DOMContentLoaded', function() {
    // Auto-select all by default
    selectAll();

    // Event delegation for select/deselect buttons
    document.addEventListener('click', function(e) {
        const target = e.target.closest('[data-action]');
        if (!target) return;

        const action = target.dataset.action;

        if (action === 'select-all') {
            e.preventDefault();
            selectAll();
        } else if (action === 'deselect-all') {
            e.preventDefault();
            deselectAll();
        }
    });
});

function selectAll() {
    document.querySelectorAll('input[name="approved_properties"]').forEach(checkbox => {
        checkbox.checked = true;
    });
}

function deselectAll() {
    document.querySelectorAll('input[name="approved_properties"]').forEach(checkbox => {
        checkbox.checked = false;
    });
}
