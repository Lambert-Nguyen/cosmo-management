function parseJsonScript(id) {
  const el = document.getElementById(id);
  if (!el) return null;
  try {
    return JSON.parse(el.textContent || 'null');
  } catch {
    return null;
  }
}

function setHidden(element, hidden) {
  if (!element) return;
  element.classList.toggle('is-hidden', hidden);
}

function initAdminChartsDashboard() {
  // Chart.js configuration
  if (window.Chart) {
    window.Chart.defaults.font.family = "'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif";
    window.Chart.defaults.font.size = 13;
    window.Chart.defaults.color = '#374151';
  }

  const statusChartData = parseJsonScript('adminStatusChartData');
  const taskTypeChartData = parseJsonScript('adminTaskTypeChartData');
  const propertyChartData = parseJsonScript('adminPropertyChartData');
  const userPerformanceChartData = parseJsonScript('adminUserPerformanceChartData');
  const userActivityChartData = parseJsonScript('adminUserActivityChartData');

  // Build charts only if Chart.js is present
  if (window.Chart) {
    const statusCanvas = document.getElementById('statusChart');
    if (statusCanvas && statusChartData) {
      const ctx = statusCanvas.getContext('2d');
      new window.Chart(ctx, {
        type: 'doughnut',
        data: {
          labels: statusChartData.labels,
          datasets: [
            {
              data: statusChartData.data,
              backgroundColor: [
                'rgba(245, 158, 11, 0.8)',
                'rgba(14, 75, 143, 0.8)',
                'rgba(16, 185, 129, 0.8)',
                'rgba(239, 68, 68, 0.8)',
              ],
              borderColor: ['#f59e0b', '#0E4B8F', '#10b981', '#ef4444'],
              borderWidth: 3,
              hoverOffset: 15,
            },
          ],
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: {
            legend: {
              position: 'bottom',
              labels: {
                padding: 25,
                font: { size: 14, weight: '600' },
                usePointStyle: true,
                pointStyle: 'circle',
              },
            },
            tooltip: {
              backgroundColor: 'rgba(0, 0, 0, 0.8)',
              titleColor: 'white',
              bodyColor: 'white',
              borderColor: 'rgba(255, 255, 255, 0.2)',
              borderWidth: 1,
              cornerRadius: 8,
              callbacks: {
                label: function (context) {
                  const label = context.label || '';
                  const value = context.parsed;
                  const total = context.dataset.data.reduce((a, b) => a + b, 0);
                  const percentage = total > 0 ? ((value / total) * 100).toFixed(1) : '0.0';
                  return `${label}: ${value} tasks (${percentage}%)`;
                },
              },
            },
          },
          cutout: '60%',
        },
      });
    }

    const taskTypeCanvas = document.getElementById('taskTypeChart');
    if (taskTypeCanvas && taskTypeChartData) {
      const ctx = taskTypeCanvas.getContext('2d');
      new window.Chart(ctx, {
        type: 'doughnut',
        data: {
          labels: taskTypeChartData.labels,
          datasets: [
            {
              data: taskTypeChartData.data,
              backgroundColor: [
                'rgba(239, 68, 68, 0.8)',
                'rgba(245, 158, 11, 0.8)',
                'rgba(139, 92, 246, 0.8)',
                'rgba(31, 41, 55, 0.8)',
              ],
              borderColor: ['#ef4444', '#f59e0b', '#8b5cf6', '#1f2937'],
              borderWidth: 3,
              hoverOffset: 15,
            },
          ],
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: {
            legend: {
              position: 'bottom',
              labels: {
                padding: 25,
                font: { size: 14, weight: '600' },
                usePointStyle: true,
                pointStyle: 'circle',
              },
            },
            tooltip: {
              backgroundColor: 'rgba(0, 0, 0, 0.8)',
              titleColor: 'white',
              bodyColor: 'white',
              borderColor: 'rgba(255, 255, 255, 0.2)',
              borderWidth: 1,
              cornerRadius: 8,
              callbacks: {
                label: function (context) {
                  const label = context.label || '';
                  const value = context.parsed;
                  const total = context.dataset.data.reduce((a, b) => a + b, 0);
                  const percentage = total > 0 ? ((value / total) * 100).toFixed(1) : '0.0';
                  return `${label}: ${value} tasks (${percentage}%)`;
                },
              },
            },
          },
          cutout: '60%',
        },
      });
    }

    const propertyCanvas = document.getElementById('propertyChart');
    if (propertyCanvas && propertyChartData) {
      const ctx = propertyCanvas.getContext('2d');
      new window.Chart(ctx, {
        type: 'bar',
        data: {
          labels: propertyChartData.labels,
          datasets: [
            {
              label: 'Tasks',
              data: propertyChartData.data,
              backgroundColor: 'rgba(37, 99, 235, 0.8)',
              borderColor: '#2563eb',
              borderWidth: 2,
              borderRadius: 8,
              borderSkipped: false,
            },
          ],
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: {
            legend: { display: false },
            tooltip: {
              backgroundColor: 'rgba(0, 0, 0, 0.8)',
              titleColor: 'white',
              bodyColor: 'white',
              borderColor: 'rgba(255, 255, 255, 0.2)',
              borderWidth: 1,
              cornerRadius: 8,
              callbacks: {
                title: function (context) {
                  return context[0].label;
                },
                label: function (context) {
                  return `${context.parsed.y} tasks`;
                },
              },
            },
          },
          scales: {
            y: {
              beginAtZero: true,
              ticks: { stepSize: 1, font: { weight: '600' } },
              title: { display: true, text: 'Number of Tasks', font: { weight: '700', size: 14 } },
              grid: { color: 'rgba(0, 0, 0, 0.05)' },
            },
            x: {
              title: { display: true, text: 'Properties', font: { weight: '700', size: 14 } },
              grid: { display: false },
            },
          },
        },
      });
    }

    const userPerformanceCanvas = document.getElementById('userPerformanceChart');
    if (userPerformanceCanvas && userPerformanceChartData) {
      const ctx = userPerformanceCanvas.getContext('2d');
      new window.Chart(ctx, {
        type: 'bar',
        data: {
          labels: userPerformanceChartData.labels,
          datasets: [
            {
              label: 'Completed Tasks',
              data: userPerformanceChartData.completed,
              backgroundColor: 'rgba(16, 185, 129, 0.8)',
              borderColor: '#10b981',
              borderWidth: 2,
              borderRadius: 6,
            },
            {
              label: 'Total Tasks',
              data: userPerformanceChartData.total,
              backgroundColor: 'rgba(14, 75, 143, 0.6)',
              borderColor: '#0E4B8F',
              borderWidth: 2,
              borderRadius: 6,
            },
          ],
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: {
            legend: {
              position: 'top',
              labels: {
                padding: 20,
                font: { size: 14, weight: '600' },
                usePointStyle: true,
              },
            },
            tooltip: {
              backgroundColor: 'rgba(0, 0, 0, 0.8)',
              titleColor: 'white',
              bodyColor: 'white',
              borderColor: 'rgba(255, 255, 255, 0.2)',
              borderWidth: 1,
              cornerRadius: 8,
              callbacks: {
                afterLabel: function (context) {
                  if (context.datasetIndex === 0) {
                    const total = context.chart.data.datasets[1].data[context.dataIndex];
                    const completed = context.parsed.y;
                    const percentage = total > 0 ? ((completed / total) * 100).toFixed(1) : '0.0';
                    return `Completion Rate: ${percentage}%`;
                  }
                  return '';
                },
              },
            },
          },
          scales: {
            y: {
              beginAtZero: true,
              ticks: { stepSize: 1, font: { weight: '600' } },
              title: { display: true, text: 'Number of Tasks', font: { weight: '700', size: 14 } },
              grid: { color: 'rgba(0, 0, 0, 0.05)' },
            },
            x: {
              title: { display: true, text: 'Team Members', font: { weight: '700', size: 14 } },
              grid: { display: false },
            },
          },
        },
      });
    }

    const userActivityCanvas = document.getElementById('userActivityChart');
    if (userActivityCanvas && userActivityChartData) {
      const ctx = userActivityCanvas.getContext('2d');
      new window.Chart(ctx, {
        type: 'doughnut',
        data: {
          labels: userActivityChartData.labels,
          datasets: [
            {
              data: userActivityChartData.data,
              backgroundColor: [
                'rgba(239, 68, 68, 0.8)',
                'rgba(14, 75, 143, 0.8)',
                'rgba(245, 158, 11, 0.8)',
                'rgba(16, 185, 129, 0.8)',
                'rgba(139, 92, 246, 0.8)',
                'rgba(245, 101, 101, 0.8)',
                'rgba(156, 163, 175, 0.8)',
                'rgba(14, 75, 143, 0.8)',
              ],
              borderColor: ['#ef4444', '#0E4B8F', '#f59e0b', '#10b981', '#8b5cf6', '#f56565', '#9ca3af', '#0E4B8F'],
              borderWidth: 3,
              hoverOffset: 12,
            },
          ],
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          plugins: {
            legend: {
              position: 'bottom',
              labels: {
                padding: 20,
                font: { size: 12, weight: '600' },
                usePointStyle: true,
                pointStyle: 'circle',
              },
            },
            tooltip: {
              backgroundColor: 'rgba(0, 0, 0, 0.8)',
              titleColor: 'white',
              bodyColor: 'white',
              borderColor: 'rgba(255, 255, 255, 0.2)',
              borderWidth: 1,
              cornerRadius: 8,
              callbacks: {
                label: function (context) {
                  const label = context.label || '';
                  const value = context.parsed;
                  return `${label}: ${value} updates`;
                },
              },
            },
          },
          cutout: '50%',
        },
      });
    }
  }

  // Admin file cleanup modal
  const modal = document.getElementById('adminFileCleanupModal');
  const content = document.getElementById('adminFileCleanupContent');

  if (modal && content) {
    function openModal() {
      setHidden(modal, false);
    }

    function closeModal() {
      setHidden(modal, true);
    }

    function getCsrfToken() {
      const tokenInput = document.querySelector('[name=csrfmiddlewaretoken]');
      if (tokenInput instanceof HTMLInputElement) return tokenInput.value;
      return '';
    }

    async function showFileStatsAdmin() {
      content.innerHTML = '<p>Loading storage statistics...</p>';
      openModal();

      try {
        const response = await fetch('/api/file-cleanup/api/', {
          method: 'GET',
          headers: {
            'Content-Type': 'application/json',
            'X-CSRFToken': getCsrfToken(),
          },
          credentials: 'same-origin',
        });

        const data = await response.json();

        if (data.success) {
          const stats = data.stats;
          content.innerHTML = `
            <div style="background: linear-gradient(135deg, #0E4B8F 0%, #0B3D75 100%); color: white; padding: 20px; border-radius: 8px; margin-bottom: 20px;">
              <h3 style="margin: 0 0 15px 0;">📊 File Storage Overview</h3>
              <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                <div>
                  <div style="font-size: 2em; font-weight: bold;">${stats.total_files}</div>
                  <div style="opacity: 0.9;">Import Files</div>
                </div>
                <div>
                  <div style="font-size: 2em; font-weight: bold;">${stats.total_size_mb} MB</div>
                  <div style="opacity: 0.9;">Storage Used</div>
                </div>
              </div>
            </div>

            <div style="background: #f8f9fa; padding: 15px; border-radius: 5px; margin: 10px 0;">
              <p><strong>📅 Date Range:</strong> ${stats.oldest_file || 'N/A'} to ${stats.newest_file || 'N/A'}</p>
              <p><strong>⏱️ Age Span:</strong> ${stats.age_span_days} days</p>
              <p><strong>💾 Total Size:</strong> ${stats.total_size_gb} GB</p>
            </div>

            <div style="text-align: center; margin-top: 20px;">
              <button type="button" data-action="admin-show-cleanup-options" class="admin-button" style="background: #28a745; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; margin: 5px;">🧹 Cleanup Options</button>
              <button type="button" data-action="admin-get-suggestions" class="admin-button" style="background: #17a2b8; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; margin: 5px;">💡 Smart Suggestions</button>
            </div>
          `;
        } else {
          content.innerHTML = `<div style="color: red; padding: 20px; text-align: center;">❌ Error: ${data.error || 'Unable to load statistics'}</div>`;
        }
      } catch (error) {
        const err = error instanceof Error ? error : new Error('Network error');
        content.innerHTML = `<div style="color: red; padding: 20px; text-align: center;">❌ Network Error: ${err.message}</div>`;
      }
    }

    async function showCleanupOptionsAdmin() {
      content.innerHTML = `
        <div style="background: linear-gradient(135deg, #28a745 0%, #20c997 100%); color: white; padding: 20px; border-radius: 8px; margin-bottom: 20px;">
          <h3 style="margin: 0;">🧹 File Cleanup Options</h3>
          <p style="margin: 10px 0 0 0; opacity: 0.9;">Choose your cleanup strategy</p>
        </div>

        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin: 20px 0;">
          <div style="background: #e3f2fd; padding: 15px; border-radius: 8px; border-left: 4px solid #2196f3;">
            <h4 style="color: #1976d2; margin: 0 0 10px 0;">🔍 Preview Mode</h4>
            <p style="margin: 0 0 15px 0; color: #666;">See what would be deleted without making changes</p>
            <button type="button" data-action="admin-perform-cleanup" data-days="30" data-dry-run="true" style="width: 100%; margin: 5px 0; padding: 8px; border: none; border-radius: 4px; background: #2196f3; color: white; cursor: pointer;">Preview: Keep 30 days</button>
            <button type="button" data-action="admin-perform-cleanup" data-days="7" data-dry-run="true" style="width: 100%; margin: 5px 0; padding: 8px; border: none; border-radius: 4px; background: #2196f3; color: white; cursor: pointer;">Preview: Keep 7 days</button>
          </div>

          <div style="background: #ffebee; padding: 15px; border-radius: 8px; border-left: 4px solid #f44336;">
            <h4 style="color: #d32f2f; margin: 0 0 10px 0;">🗑️ Delete Mode</h4>
            <p style="margin: 0 0 15px 0; color: #666;">Permanently delete old files</p>
            <button type="button" data-action="admin-confirm-delete" data-days="30" style="width: 100%; margin: 5px 0; padding: 8px; border: none; border-radius: 4px; background: #f44336; color: white; cursor: pointer;">Delete files older than 30 days</button>
            <button type="button" data-action="admin-confirm-delete" data-days="7" style="width: 100%; margin: 5px 0; padding: 8px; border: none; border-radius: 4px; background: #f44336; color: white; cursor: pointer;">Delete files older than 7 days</button>
          </div>
        </div>

        <div style="text-align: center; margin-top: 20px;">
          <button type="button" data-action="admin-show-file-stats" style="background: #6c757d; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer;">📊 Back to Stats</button>
        </div>
      `;
    }

    async function getSuggestionsAdmin() {
      content.innerHTML = '<p>Getting smart cleanup suggestions...</p>';

      try {
        const formData = new FormData();
        formData.append('action', 'suggest');
        formData.append('target_mb', '100');

        const response = await fetch('/api/file-cleanup/api/', {
          method: 'POST',
          headers: {
            'X-CSRFToken': getCsrfToken(),
          },
          credentials: 'same-origin',
          body: formData,
        });

        const data = await response.json();

        if (data.success) {
          const suggestion = data.suggestion;
          let suggestionHtml = `
            <div style="background: linear-gradient(135deg, #17a2b8 0%, #138496 100%); color: white; padding: 20px; border-radius: 8px; margin-bottom: 20px;">
              <h3 style="margin: 0;">💡 Smart Cleanup Suggestions</h3>
              <p style="margin: 10px 0 0 0; opacity: 0.9;">AI-powered storage optimization</p>
            </div>

            <div style="background: #f8f9fa; padding: 20px; border-radius: 8px; margin: 15px 0;">
              <p><strong>Current Size:</strong> ${suggestion.current_size_mb} MB</p>
              <p><strong>Target Size:</strong> ${suggestion.target_size_mb} MB</p>
              <p><strong>Status:</strong> ${suggestion.message}</p>
          `;

          if (suggestion.action_needed && suggestion.recommended_days_to_keep) {
            suggestionHtml += `
              <div style="background: #d4edda; border: 1px solid #c3e6cb; padding: 15px; border-radius: 5px; margin: 15px 0;">
                <h4 style="color: #155724; margin: 0 0 10px 0;">✅ Recommended Action</h4>
                <p style="color: #155724; margin: 0;">Keep files from last <strong>${suggestion.recommended_days_to_keep} days</strong></p>
                <p style="color: #155724; margin: 5px 0 0 0;">This will delete ${suggestion.files_to_delete} files and free ${suggestion.space_to_free_mb} MB</p>
                <button type="button" data-action="admin-perform-cleanup" data-days="${suggestion.recommended_days_to_keep}" data-dry-run="false" style="background: #28a745; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; margin-top: 10px;">🚀 Apply Recommendation</button>
              </div>
            `;
          } else {
            suggestionHtml += `
              <div style="background: #d1ecf1; border: 1px solid #bee5eb; padding: 15px; border-radius: 5px; margin: 15px 0;">
                <p style="color: #0c5460; margin: 0;">✅ No action needed at this time.</p>
              </div>
            `;
          }

          suggestionHtml += `
            </div>
            <div style="text-align: center; margin-top: 20px;">
              <button type="button" data-action="admin-show-file-stats" style="background: #6c757d; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer;">📊 Back to Stats</button>
            </div>
          `;

          content.innerHTML = suggestionHtml;
        } else {
          content.innerHTML = `<div style="color: red; padding: 20px; text-align: center;">❌ Error: ${data.error || 'Unable to get suggestions'}</div>`;
        }
      } catch (error) {
        const err = error instanceof Error ? error : new Error('Network error');
        content.innerHTML = `<div style="color: red; padding: 20px; text-align: center;">❌ Network Error: ${err.message}</div>`;
      }
    }

    function confirmDeleteAdmin(days) {
      if (window.confirm(`⚠️ Are you sure you want to delete all files older than ${days} days? This action cannot be undone.`)) {
        performCleanupAdmin(days, false);
      }
    }

    async function performCleanupAdmin(days, dryRun) {
      const action = dryRun ? 'dry_run' : 'cleanup';
      const actionText = dryRun ? 'Previewing' : 'Performing';

      content.innerHTML = `<div style="text-align: center; padding: 40px;"><p>${actionText} cleanup for files older than ${days} days...</p><div style="border: 4px solid #f3f3f3; border-top: 4px solid #3498db; border-radius: 50%; width: 40px; height: 40px; animation: spin 2s linear infinite; margin: 20px auto;"></div></div>`;

      try {
        const formData = new FormData();
        formData.append('action', action);
        formData.append('days', String(days));

        const response = await fetch('/api/file-cleanup/api/', {
          method: 'POST',
          headers: {
            'X-CSRFToken': getCsrfToken(),
          },
          credentials: 'same-origin',
          body: formData,
        });

        const data = await response.json();

        if (data.success) {
          const result = data.result;
          const bgColor = dryRun ? '#e3f2fd' : '#e8f5e8';
          const borderColor = dryRun ? '#2196f3' : '#28a745';
          const titleColor = dryRun ? '#1976d2' : '#155724';

          content.innerHTML = `
            <div style="background: ${bgColor}; border-left: 4px solid ${borderColor}; padding: 20px; border-radius: 8px; margin-bottom: 20px;">
              <h3 style="color: ${titleColor}; margin: 0 0 15px 0;">${dryRun ? '🔍 Cleanup Preview' : '✅ Cleanup Complete'}</h3>
              <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                <div>
                  <div style="font-size: 1.5em; font-weight: bold; color: ${titleColor};">${result.files_deleted || result.files_found || 0}</div>
                  <div style="color: #666;">Files ${dryRun ? 'to delete' : 'deleted'}</div>
                </div>
                <div>
                  <div style="font-size: 1.5em; font-weight: bold; color: ${titleColor};">${result.space_freed_mb || result.total_size_mb || 0} MB</div>
                  <div style="color: #666;">Space ${dryRun ? 'to free' : 'freed'}</div>
                </div>
              </div>
            </div>

            <div style="background: #f8f9fa; padding: 15px; border-radius: 5px; margin: 10px 0;">
              <p><strong>📅 Cutoff Date:</strong> ${result.cutoff_date}</p>
              <p><strong>⏱️ Days Kept:</strong> Last ${days} days</p>
              ${result.errors && result.errors.length > 0 ? `<p style="color: red;"><strong>❌ Errors:</strong> ${result.errors.length} files could not be deleted</p>` : ''}
            </div>

            <div style="text-align: center; margin-top: 20px;">
              <button type="button" data-action="admin-show-cleanup-options" style="background: #28a745; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; margin: 5px;">🔙 Back to Options</button>
              <button type="button" data-action="admin-show-file-stats" style="background: #17a2b8; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; margin: 5px;">📊 Show Stats</button>
            </div>
          `;
        } else {
          content.innerHTML = `<div style="color: red; padding: 20px; text-align: center;">❌ Error: ${data.error || 'Cleanup failed'}</div>`;
        }
      } catch (error) {
        const err = error instanceof Error ? error : new Error('Network error');
        content.innerHTML = `<div style="color: red; padding: 20px; text-align: center;">❌ Network Error: ${err.message}</div>`;
      }
    }

    // Global actions in static HTML
    document.addEventListener('click', (e) => {
      const target = e.target;
      if (!(target instanceof Element)) return;

      const actionEl = target.closest('[data-action]');
      if (!actionEl) return;

      const action = actionEl.getAttribute('data-action');

      if (action === 'admin-show-file-stats') {
        e.preventDefault();
        void showFileStatsAdmin();
      }

      if (action === 'admin-close-modal') {
        e.preventDefault();
        closeModal();
      }

      if (action === 'admin-show-cleanup-options') {
        e.preventDefault();
        void showCleanupOptionsAdmin();
      }

      if (action === 'admin-get-suggestions') {
        e.preventDefault();
        void getSuggestionsAdmin();
      }

      if (action === 'admin-confirm-delete') {
        e.preventDefault();
        const days = Number(actionEl.getAttribute('data-days') || '0');
        if (Number.isFinite(days) && days > 0) {
          confirmDeleteAdmin(days);
        }
      }

      if (action === 'admin-perform-cleanup') {
        e.preventDefault();
        const days = Number(actionEl.getAttribute('data-days') || '0');
        const dryRun = (actionEl.getAttribute('data-dry-run') || 'false') === 'true';
        if (Number.isFinite(days) && days > 0) {
          void performCleanupAdmin(days, dryRun);
        }
      }
    });

    // Close modal when clicking outside
    window.addEventListener('click', (event) => {
      if (event.target === modal) {
        closeModal();
      }
    });

    // Default modal state
    setHidden(modal, true);

    console.log('🔧 Django Admin Analytics Dashboard loaded successfully!');
  }
}

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initAdminChartsDashboard);
} else {
  initAdminChartsDashboard();
}
