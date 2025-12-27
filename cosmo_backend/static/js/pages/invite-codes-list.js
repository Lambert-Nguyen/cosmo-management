/**
 * Invite Codes List Page
 * Handles CSV export and form confirmations
 */

class InviteCodesList {
    constructor() {
        this.attachEventListeners();
    }

    attachEventListeners() {
        // CSV Export
        const exportBtn = document.querySelector('[data-action="export-csv"]');
        if (exportBtn) {
            exportBtn.addEventListener('click', () => this.exportToCSV());
        }

        // Revoke confirmations
        document.querySelectorAll('[data-action="revoke"]').forEach(form => {
            form.addEventListener('submit', (e) => {
                if (!confirm('Are you sure you want to revoke this invite code?')) {
                    e.preventDefault();
                }
            });
        });

        // Reactivate confirmations
        document.querySelectorAll('[data-action="reactivate"]').forEach(form => {
            form.addEventListener('submit', (e) => {
                if (!confirm('Are you sure you want to reactivate this invite code?')) {
                    e.preventDefault();
                }
            });
        });

        // Delete confirmations
        document.querySelectorAll('[data-action="delete"]').forEach(form => {
            form.addEventListener('submit', (e) => {
                if (!confirm('Are you sure you want to permanently delete this invite code? This action cannot be undone.')) {
                    e.preventDefault();
                }
            });
        });
    }

    exportToCSV() {
        const table = document.querySelector('.table');
        if (!table) return;

        const rows = Array.from(table.querySelectorAll('tr'));

        const csvContent = rows.map(row => {
            const cells = Array.from(row.querySelectorAll('th, td'));
            return cells.map(cell => {
                // Clean up cell content for CSV
                let text = cell.textContent.trim();
                // Remove emoji and clean up text
                text = text.replace(/[🎫👁️✏️🚫✅🗑️📊🔄🔍]/g, '');
                // Escape quotes
                text = text.replace(/"/g, '""');
                return `"${text}"`;
            }).join(',');
        }).join('\n');

        const blob = new Blob([csvContent], { type: 'text/csv' });
        const url = window.URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = 'invite_codes.csv';
        a.click();
        window.URL.revokeObjectURL(url);
    }
}

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
    new InviteCodesList();
});
