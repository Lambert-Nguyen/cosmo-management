/**
 * Admin Invite Codes Page
 */

/**
 * Copy invite code to clipboard
 * @param {string} code - The invite code to copy
 */
function copyCode(code) {
    navigator.clipboard.writeText(code).then(function() {
        // Show success feedback
        const button = event.target;
        const originalText = button.textContent;
        button.textContent = '✅ Copied!';
        button.classList.add('copied');

        setTimeout(() => {
            button.textContent = originalText;
            button.classList.remove('copied');
        }, 2000);
    }).catch(function(err) {
        console.error('Could not copy text: ', err);
        alert('Failed to copy code. Please copy manually: ' + code);
    });
}

/**
 * Initialize page on load
 */
document.addEventListener('DOMContentLoaded', function() {
    // Event delegation for copy buttons
    document.addEventListener('click', (e) => {
        const copyBtn = e.target.closest('[data-action="copy-code"]');
        if (copyBtn) {
            const code = copyBtn.dataset.code;
            copyCode(code);
        }

        // Handle revoke confirmation
        const revokeBtn = e.target.closest('[data-confirm]');
        if (revokeBtn && !confirm(revokeBtn.dataset.confirm)) {
            e.preventDefault();
        }
    });
});
