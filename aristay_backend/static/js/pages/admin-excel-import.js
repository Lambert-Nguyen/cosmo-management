/**
 * Admin Excel Import Page JavaScript
 */

// Mobile-Optimized File Handling
function handleFileSelect(event) {
    const file = event.target.files[0];
    if (file) {
        const fileInfo = document.getElementById('fileInfo');
        const importForm = document.getElementById('importForm');

        fileInfo.innerHTML = `
            <strong>Selected File:</strong> ${file.name}<br>
            <strong>Size:</strong> ${(file.size / 1024 / 1024).toFixed(2)} MB<br>
            <strong>Type:</strong> ${file.type}
        `;
        fileInfo.classList.add('show');
        importForm.style.display = 'block';
    }
}

// Mobile-Optimized Form Submission
document.addEventListener('DOMContentLoaded', function() {
    const importFormEl = document.getElementById('importForm');
    if (importFormEl) {
        importFormEl.addEventListener('submit', function(e) {
            e.preventDefault();

            const submitBtn = document.getElementById('submitBtn');
            const progressBar = document.getElementById('progressBar');
            const progressFill = document.getElementById('progressFill');

            submitBtn.disabled = true;
            submitBtn.textContent = '⏳ Importing...';
            progressBar.style.display = 'block';

            // Simulate progress (in real implementation, this would be AJAX)
            let progress = 0;
            const interval = setInterval(() => {
                progress += 10;
                progressFill.style.width = progress + '%';
                if (progress >= 100) {
                    clearInterval(interval);
                    submitBtn.textContent = '✅ Import Complete!';
                    setTimeout(() => {
                        location.reload();
                    }, 1000);
                }
            }, 200);

            // Submit the form
            this.submit();
        });
    }
});

// Mobile-Optimized Import Log Toggle
function toggleImportLog() {
    const importLog = document.getElementById('importLog');
    const isVisible = importLog.style.display !== 'none';
    importLog.style.display = isVisible ? 'none' : 'block';
}

// Mobile Drag and Drop Support
const uploadSection = document.getElementById('uploadSection');
if (uploadSection) {
    uploadSection.addEventListener('dragover', function(e) {
        e.preventDefault();
        this.classList.add('dragover');
    });

    uploadSection.addEventListener('dragleave', function(e) {
        e.preventDefault();
        this.classList.remove('dragover');
    });

    uploadSection.addEventListener('drop', function(e) {
        e.preventDefault();
        this.classList.remove('dragover');

        const files = e.dataTransfer.files;
        if (files.length > 0) {
            const fileInput = document.getElementById('excelFile');
            fileInput.files = files;
            handleFileSelect({ target: { files: files } });
        }
    });
}

// Mobile Touch Enhancements
if ('ontouchstart' in window) {
    document.body.classList.add('touch-device');
}

// Mobile-Friendly Table Scrolling
document.addEventListener('DOMContentLoaded', function() {
    const tables = document.querySelectorAll('table');
    tables.forEach(function(table) {
        if (table.parentElement) {
            table.parentElement.classList.add('scroll-container');
        }
    });
});
