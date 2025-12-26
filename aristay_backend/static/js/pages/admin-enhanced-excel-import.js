function qs(root, selector) {
  return root.querySelector(selector);
}

function setHidden(element, hidden) {
  if (!element) return;
  element.classList.toggle('is-hidden', hidden);
}

function initEnhancedExcelImport() {
  const uploadArea = document.getElementById('uploadArea');
  const fileInput = document.getElementById('excel_file');
  const fileName = document.getElementById('fileName');
  const form = document.getElementById('importForm');
  const submitBtn = document.getElementById('submitBtn');
  const progressContainer = document.getElementById('progressContainer');
  const resultContainer = document.getElementById('resultContainer');

  if (!uploadArea || !fileInput || !fileName || !form || !submitBtn || !progressContainer || !resultContainer) {
    return;
  }

  const progressFill = document.getElementById('progressFill');

  function showFileName(name) {
    fileName.textContent = `Selected: ${name}`;
    setHidden(fileName, false);
  }

  // Data-action handlers
  document.addEventListener('click', (e) => {
    const target = e.target;
    if (!(target instanceof Element)) return;

    const actionEl = target.closest('[data-action]');
    if (!actionEl) return;

    const action = actionEl.getAttribute('data-action');
    if (action === 'aeei-choose-file') {
      e.preventDefault();
      fileInput.click();
    }

    if (action === 'aeei-reload') {
      e.preventDefault();
      window.location.reload();
    }
  });

  // Drag and drop functionality
  uploadArea.addEventListener('dragover', (e) => {
    e.preventDefault();
    uploadArea.classList.add('dragover');
  });

  uploadArea.addEventListener('dragleave', () => {
    uploadArea.classList.remove('dragover');
  });

  uploadArea.addEventListener('drop', (e) => {
    e.preventDefault();
    uploadArea.classList.remove('dragover');

    const dt = e.dataTransfer;
    if (!dt) return;

    const files = dt.files;
    if (files.length > 0) {
      fileInput.files = files;
      showFileName(files[0].name);
    }
  });

  // File input change handler
  fileInput.addEventListener('change', (e) => {
    const input = e.target;
    if (!(input instanceof HTMLInputElement)) return;
    if (input.files && input.files.length > 0) {
      showFileName(input.files[0].name);
    }
  });

  function renderSuccessWithConflicts(result) {
    resultContainer.className = 'result-container result-warning';

    const conflictUrl = result.conflict_review_url || '#';
    const conflictsDetected = result.conflicts_detected || 0;
    const successfulImports = result.successful_imports || 0;
    const autoUpdated = result.auto_updated || 0;

    return `
      <h4>⚠️ Import Completed with Conflicts</h4>
      <div class="alert alert-warning aeei-callout aeei-callout-warning">
        <div class="aeei-callout-header">
          <span class="aeei-callout-icon">⚠️</span>
          <div>
            <strong class="aeei-callout-title">Manual Review Required</strong>
            <p class="aeei-callout-subtitle aeei-callout-subtitle-warning">Some bookings need your attention to avoid data conflicts.</p>
          </div>
        </div>
      </div>
      <div class="aeei-stat-grid">
        <div class="stat-box aeei-stat-box aeei-stat-success">
          <div class="aeei-stat-number">${successfulImports}</div>
          <div class="aeei-stat-label">✅ Successfully Imported</div>
        </div>
        <div class="stat-box aeei-stat-box aeei-stat-info">
          <div class="aeei-stat-number">${autoUpdated}</div>
          <div class="aeei-stat-label">🔄 Auto-Updated</div>
        </div>
        <div class="stat-box aeei-stat-box aeei-stat-warning">
          <div class="aeei-stat-number">${conflictsDetected}</div>
          <div class="aeei-stat-label">⚠️ Need Review</div>
        </div>
      </div>
      <div class="aeei-next-steps">
        <h5 class="aeei-next-steps-title">📋 Next Steps:</h5>
        <ol class="aeei-next-steps-list">
          <li>Review the conflicts below to understand what needs attention</li>
          <li>Use the conflict resolution interface to make decisions</li>
          <li>Choose to keep existing data, update with new data, or create new bookings</li>
          <li>Complete the import process once all conflicts are resolved</li>
        </ol>
      </div>
      <div class="aeei-actions">
        <a href="${conflictUrl}" class="btn btn-primary aeei-btn-cta aeei-btn-cta-primary">
          🔍 Review and Resolve Conflicts
          <span class="aeei-conflict-count">${conflictsDetected}</span>
        </a>
      </div>
      <div class="aeei-actions-secondary">
        <details>
          <summary>View Import Details</summary>
          <pre class="aeei-details-pre">${JSON.stringify(result, null, 2)}</pre>
        </details>
      </div>
    `;
  }

  function renderSuccessNoConflicts(result) {
    resultContainer.className = 'result-container result-success';

    const successfulImports = result.successful_imports || 0;
    const autoUpdated = result.auto_updated || 0;

    return `
      <h4>✅ Import Completed Successfully</h4>
      <div class="alert alert-success aeei-callout aeei-callout-success">
        <div class="aeei-callout-header">
          <span class="aeei-callout-icon">🎉</span>
          <div>
            <strong class="aeei-callout-title">Perfect Import!</strong>
            <p class="aeei-callout-subtitle aeei-callout-subtitle-success">All data processed successfully with no conflicts detected.</p>
          </div>
        </div>
      </div>
      <div class="aeei-stat-grid">
        <div class="stat-box aeei-stat-box aeei-stat-success">
          <div class="aeei-stat-number">${successfulImports}</div>
          <div class="aeei-stat-label">📥 New Bookings</div>
        </div>
        <div class="stat-box aeei-stat-box aeei-stat-info">
          <div class="aeei-stat-number">${autoUpdated}</div>
          <div class="aeei-stat-label">🔄 Updated Bookings</div>
        </div>
      </div>
      <div class="aeei-next-steps">
        <p>
          <strong>📊 Import Summary:</strong> Your Excel file has been processed completely.
          All booking data has been integrated into the system successfully.
        </p>
      </div>
      <div class="aeei-actions">
        <a href="/admin/api/booking/" class="btn btn-primary aeei-btn-cta aeei-btn-cta-success">📋 View Imported Bookings</a>
        <a href="/api/enhanced-excel-import/" class="btn btn-secondary aeei-btn-secondary-cta">🔄 Import More Files</a>
      </div>
    `;
  }

  function renderError(result) {
    resultContainer.className = 'result-container result-error';

    const errorMessage = result.error || 'Unknown error';
    const errors = Array.isArray(result.errors) ? result.errors : null;

    const rowErrorsHtml = errors
      ? `
        <div class="aeei-error-box">
          <h5 class="aeei-error-box-title">📝 Row-Level Errors:</h5>
          <ul class="aeei-errors-list">
            ${errors.slice(0, 10).map((err) => `<li class="aeei-errors-item">${err}</li>`).join('')}
          </ul>
          ${errors.length > 10 ? `<p class="aeei-errors-more"><em>... and ${errors.length - 10} more errors</em></p>` : ''}
        </div>
      `
      : '';

    return `
      <h4>❌ Import Failed</h4>
      <div class="alert alert-error aeei-callout aeei-callout-error">
        <div class="aeei-callout-header">
          <span class="aeei-callout-icon">🚫</span>
          <div>
            <strong class="aeei-callout-title">Import Error</strong>
            <p class="aeei-callout-subtitle">The import process encountered an error and could not complete.</p>
          </div>
        </div>
      </div>
      <div class="aeei-error-box">
        <h5 class="aeei-error-box-title">🔍 Error Details:</h5>
        <p class="aeei-error-message"><strong>${errorMessage}</strong></p>
      </div>
      ${rowErrorsHtml}
      <div class="aeei-troubleshooting">
        <h5 class="aeei-troubleshooting-title">💡 Troubleshooting Tips:</h5>
        <ul class="aeei-troubleshooting-list">
          <li>Check that your Excel file format is correct (.xlsx or .xls)</li>
          <li>Ensure all required columns are present and properly formatted</li>
          <li>Verify that dates are in the correct format (YYYY-MM-DD)</li>
          <li>Check for special characters that might cause parsing issues</li>
          <li>Try uploading a smaller file to test if it's a size issue</li>
        </ul>
      </div>
      <div class="aeei-actions">
        <button type="button" data-action="aeei-reload" class="btn btn-primary aeei-btn-cta aeei-btn-cta-primary aeei-try-again-btn">🔄 Try Again</button>
        <a href="/api/enhanced-excel-import/" class="btn btn-secondary aeei-btn-secondary-cta">📁 Start Over</a>
      </div>
    `;
  }

  function showResult(result) {
    setHidden(progressContainer, true);
    setHidden(resultContainer, false);

    const resultContent = qs(resultContainer, '#resultContent');
    if (!resultContent) return;

    if (result.success) {
      const hasConflicts = Boolean(result.requires_review) && (result.conflicts_detected || 0) > 0;
      resultContent.innerHTML = hasConflicts ? renderSuccessWithConflicts(result) : renderSuccessNoConflicts(result);
      return;
    }

    resultContent.innerHTML = renderError(result);
  }

  // Form submission with AJAX
  form.addEventListener('submit', async (e) => {
    e.preventDefault();

    const formData = new FormData(form);

    // Show progress
    submitBtn.disabled = true;
    submitBtn.textContent = 'Processing...';
    setHidden(progressContainer, false);
    setHidden(resultContainer, true);

    // Simulate progress animation
    let progress = 0;
    const progressInterval = window.setInterval(() => {
      progress += Math.random() * 15;
      if (progress > 85) progress = 85;
      if (progressFill) progressFill.style.width = `${progress}%`;
    }, 500);

    try {
      const response = await fetch('/api/enhanced-excel-import/api/', {
        method: 'POST',
        body: formData,
      });

      const result = await response.json();

      // Complete progress
      window.clearInterval(progressInterval);
      if (progressFill) progressFill.style.width = '100%';

      window.setTimeout(() => {
        showResult(result);
      }, 500);
    } catch (error) {
      window.clearInterval(progressInterval);
      const err = error instanceof Error ? error : new Error('Network error');
      showResult({
        success: false,
        error: `Network error: ${err.message}`,
      });
    }

    // Reset form
    submitBtn.disabled = false;
    submitBtn.textContent = '🚀 Start Enhanced Import';
  });

  // Initial state: hidden containers
  setHidden(fileName, true);
  setHidden(progressContainer, true);
  setHidden(resultContainer, true);
}

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initEnhancedExcelImport);
} else {
  initEnhancedExcelImport();
}
