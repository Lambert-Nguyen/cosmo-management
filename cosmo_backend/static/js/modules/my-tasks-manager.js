/**
 * My Tasks Manager Module
 * Handles task list page functionality including filtering, bulk actions, and task management
 */

import { APIClient } from '../core/api-client.js';
import { CSRFManager } from '../core/csrf.js';

export class MyTasksManager {
  constructor() {
    this.selectedTasks = new Set();
    this.currentFilters = {};
    this.updateInterval = null;
    this.lastTaskCount = 0;
    
    this.init();
  }

  init() {
    console.log('✓ MyTasksManager initialized');
    this.setupEventListeners();
    this.initializeTooltips();
    this.setupKeyboardShortcuts();
    this.loadFilterState();
    this.loadSavedFilters();
    this.startRealTimeUpdates();
    this.initializeTaskCount();
  }

  setupEventListeners() {
    // Filter form submission
    const filterForm = document.querySelector('.filters-form');
    if (filterForm) {
      filterForm.addEventListener('submit', (e) => this.handleFilterSubmit(e));
    }

    // Search input with debounce
    const searchInput = document.getElementById('search');
    if (searchInput) {
      let searchTimeout;
      searchInput.addEventListener('input', () => {
        clearTimeout(searchTimeout);
        searchTimeout = setTimeout(() => this.autoSubmitFilters(), 500);
      });
    }

    // Real-time filter updates
    document.querySelectorAll('.filter-select').forEach(select => {
      select.addEventListener('change', (e) => this.handleFilterChange(e));
    });

    // Task selection - use event delegation
    document.addEventListener('change', (e) => {
      if (e.target.classList.contains('task-checkbox')) {
        this.updateTaskSelection(e.target);
      }
    });

    // Event delegation for all button actions
    document.addEventListener('click', (e) => {
      // Bulk actions toggle
      const bulkActionsBtn = e.target.closest('[data-action="toggle-bulk-actions"]');
      if (bulkActionsBtn) {
        e.preventDefault();
        this.toggleBulkActions();
        return;
      }

      // Export tasks
      const exportBtn = e.target.closest('[data-action="export-tasks"]');
      if (exportBtn) {
        e.preventDefault();
        this.exportTasks();
        return;
      }

      // Advanced filters toggle
      const advancedBtn = e.target.closest('[data-action="toggle-advanced-filters"]');
      if (advancedBtn) {
        e.preventDefault();
        this.toggleAdvancedFilters(e.target);
        return;
      }

      // Bulk status update
      const bulkStatusBtn = e.target.closest('[data-action="bulk-update-status"]');
      if (bulkStatusBtn) {
        e.preventDefault();
        const status = bulkStatusBtn.dataset.status;
        this.bulkUpdateStatus(status);
        return;
      }

      // Clear selection
      const clearBtn = e.target.closest('[data-action="clear-selection"]');
      if (clearBtn) {
        e.preventDefault();
        this.clearSelection();
        return;
      }

      // Quick actions
      const quickActionBtn = e.target.closest('[data-action="quick-action"]');
      if (quickActionBtn) {
        e.preventDefault();
        const taskId = quickActionBtn.dataset.taskId;
        const action = quickActionBtn.dataset.quickAction;
        this.quickAction(taskId, action);
        return;
      }

      // Duplicate task
      const duplicateBtn = e.target.closest('[data-action="duplicate-task"]');
      if (duplicateBtn) {
        e.preventDefault();
        const taskId = duplicateBtn.dataset.taskId;
        this.duplicateTask(taskId);
        return;
      }

      // Delete task
      const deleteBtn = e.target.closest('[data-action="delete-task"]');
      if (deleteBtn) {
        e.preventDefault();
        const taskId = deleteBtn.dataset.taskId;
        const taskTitle = deleteBtn.dataset.taskTitle;
        this.deleteTask(taskId, taskTitle);
        return;
      }

      // Request new tasks
      const requestBtn = e.target.closest('[data-action="request-tasks"]');
      if (requestBtn) {
        e.preventDefault();
        this.requestNewTasks();
        return;
      }

      // Close notification (inline handler replacement)
      const closeNotificationBtn = e.target.closest('.notification-close');
      if (closeNotificationBtn) {
        e.preventDefault();
        closeNotificationBtn.closest('.notification')?.remove();
        return;
      }
    });
  }

  // Filter Management
  handleFilterSubmit(e) {
    e.preventDefault();
    const formData = new FormData(e.target);
    const filters = Object.fromEntries(formData.entries());

    // Remove empty filters
    Object.keys(filters).forEach(key => {
      if (!filters[key]) delete filters[key];
    });

    // Save filter state
    this.saveFilterState(filters);

    // Submit form
    e.target.submit();
  }

  handleFilterChange(e) {
    const filterName = e.target.name;
    const filterValue = e.target.value;

    this.currentFilters[filterName] = filterValue;

    // Auto-submit for instant feedback
    if (['status', 'type'].includes(filterName)) {
      this.autoSubmitFilters();
    }
  }

  autoSubmitFilters() {
    const form = document.querySelector('.filters-form');
    if (form) {
      // Add loading state
      form.classList.add('loading');

      // Submit after a short delay
      setTimeout(() => {
        form.submit();
      }, 300);
    }
  }

  toggleAdvancedFilters(button) {
    const advancedFilters = document.getElementById('advancedFilters');
    if (!advancedFilters) return;

    if (advancedFilters.style.display === 'none' || !advancedFilters.style.display) {
      advancedFilters.style.display = 'block';
      button.textContent = '⚙️ Hide Advanced';
    } else {
      advancedFilters.style.display = 'none';
      button.textContent = '⚙️ Advanced';
    }
  }

  // Task Selection and Bulk Actions
  updateTaskSelection(checkbox) {
    const taskId = checkbox.value;

    if (checkbox.checked) {
      this.selectedTasks.add(taskId);
      checkbox.closest('.task-card')?.classList.add('selected');
    } else {
      this.selectedTasks.delete(taskId);
      checkbox.closest('.task-card')?.classList.remove('selected');
    }

    this.updateBulkActionsVisibility();
    this.updateSelectedCount();
  }

  updateBulkActionsVisibility() {
    const bulkPanel = document.getElementById('bulkActionsPanel');
    if (!bulkPanel) return;

    if (this.selectedTasks.size > 0) {
      bulkPanel.style.display = 'block';
      setTimeout(() => {
        bulkPanel.style.opacity = '1';
        bulkPanel.style.transform = 'translateY(0)';
      }, 10);
    } else {
      bulkPanel.style.opacity = '0';
      bulkPanel.style.transform = 'translateY(-100%)';
      setTimeout(() => {
        bulkPanel.style.display = 'none';
      }, 300);
    }
  }

  updateSelectedCount() {
    const countElement = document.getElementById('selectedCount');
    if (countElement) {
      countElement.textContent = this.selectedTasks.size;
    }
  }

  toggleBulkActions() {
    const bulkPanel = document.getElementById('bulkActionsPanel');
    if (!bulkPanel) return;

    if (bulkPanel.style.display === 'none' || !bulkPanel.style.display) {
      bulkPanel.style.display = 'block';
      setTimeout(() => {
        bulkPanel.style.opacity = '1';
        bulkPanel.style.transform = 'translateY(0)';
      }, 10);
    } else {
      bulkPanel.style.opacity = '0';
      bulkPanel.style.transform = 'translateY(-100%)';
      setTimeout(() => {
        bulkPanel.style.display = 'none';
      }, 300);
    }
  }

  clearSelection() {
    this.selectedTasks.clear();
    document.querySelectorAll('.task-checkbox').forEach(checkbox => {
      checkbox.checked = false;
      checkbox.closest('.task-card')?.classList.remove('selected');
    });
    this.updateBulkActionsVisibility();
    this.updateSelectedCount();
  }

  async bulkUpdateStatus(status) {
    if (this.selectedTasks.size === 0) return;

    const confirmMessage = `Update ${this.selectedTasks.size} task${this.selectedTasks.size > 1 ? 's' : ''} to ${status.replace('-', ' ')}?`;
    if (!confirm(confirmMessage)) return;

    // Disable button during processing
    const button = event.target.closest('[data-action="bulk-update-status"]');
    if (button) {
      const originalText = button.textContent;
      button.textContent = '⏳ Updating...';
      button.disabled = true;

      try {
        const results = await Promise.allSettled(
          Array.from(this.selectedTasks).map(taskId => this.updateTaskStatus(taskId, status))
        );

        const successCount = results.filter(r => r.status === 'fulfilled' && r.value.success).length;
        const failCount = results.length - successCount;

        if (successCount > 0) {
          this.showNotification(`Successfully updated ${successCount} task${successCount > 1 ? 's' : ''}`, 'success');
        }

        if (failCount > 0) {
          this.showNotification(`Failed to update ${failCount} task${failCount > 1 ? 's' : ''}`, 'error');
        }

        // Clear selection and refresh
        this.clearSelection();
        setTimeout(() => location.reload(), 1500);

      } catch (error) {
        console.error('❌ Bulk update error:', error);
        this.showNotification('Bulk update failed', 'error');
      } finally {
        button.textContent = originalText;
        button.disabled = false;
      }
    }
  }

  // Quick Actions
  quickAction(taskId, action) {
    switch (action) {
      case 'start':
        if (confirm('Start this task?')) {
          this.updateTaskStatus(taskId, 'in-progress');
        }
        break;
      case 'complete':
        if (confirm('Mark this task as completed?')) {
          this.updateTaskStatus(taskId, 'completed');
        }
        break;
      case 'view':
        window.location.href = `/api/staff/tasks/${taskId}/`;
        break;
    }
  }

  duplicateTask(taskId) {
    if (confirm('Create a copy of this task?')) {
      window.location.href = `/api/staff/tasks/${taskId}/duplicate/`;
    }
  }

  deleteTask(taskId, taskTitle) {
    if (confirm(`Are you sure you want to delete "${taskTitle}"? This action cannot be undone.`)) {
      // Create a form to submit the delete request
      const form = document.createElement('form');
      form.method = 'POST';
      form.action = `/api/staff/tasks/${taskId}/delete/`;
      
      // Add CSRF token
      const csrfToken = CSRFManager.getToken();
      if (csrfToken) {
        const csrfInput = document.createElement('input');
        csrfInput.type = 'hidden';
        csrfInput.name = 'csrfmiddlewaretoken';
        csrfInput.value = csrfToken;
        form.appendChild(csrfInput);
      }
      
      document.body.appendChild(form);
      form.submit();
    }
  }

  async updateTaskStatus(taskId, status) {
    const taskCard = document.querySelector(`[data-task-id="${taskId}"]`);
    if (taskCard) {
      taskCard.classList.add('loading');
    }

    try {
      const response = await APIClient.post(`/api/staff/tasks/${taskId}/status/`, {
        status: status
      });

      if (response.success) {
        // Update UI immediately
        this.updateTaskCardStatus(taskId, status, response.status_display);

        // Show success feedback
        this.showNotification(`Task ${response.status_display}`, 'success');

        return { success: true, data: response };
      } else {
        throw new Error(response.error || 'Failed to update task');
      }
    } catch (error) {
      console.error('❌ Error updating task status:', error);
      this.showNotification(`Failed to update task: ${error.message}`, 'error');
      return { success: false, error };
    } finally {
      if (taskCard) {
        taskCard.classList.remove('loading');
      }
    }
  }

  updateTaskCardStatus(taskId, status, statusDisplay) {
    const taskCard = document.querySelector(`[data-task-id="${taskId}"]`);
    if (!taskCard) return;

    // Update status badge
    const statusBadge = taskCard.querySelector('.status-badge');
    if (statusBadge) {
      statusBadge.className = `status-badge status-${status.replace('-', '')}`;
      statusBadge.textContent = statusDisplay;
    }

    // Update action buttons based on new status
    const actionButtons = taskCard.querySelectorAll('.btn-action');
    actionButtons.forEach(button => {
      if (status === 'completed') {
        button.disabled = true;
        button.style.opacity = '0.5';
      } else {
        button.disabled = false;
        button.style.opacity = '1';
      }
    });
  }

  // Export Functionality
  exportTasks() {
    const form = document.querySelector('.filters-form');
    if (!form) return;

    // Create export URL with current filters
    const formData = new FormData(form);
    const params = new URLSearchParams(formData);
    params.set('export', 'csv');

    const exportUrl = `/api/staff/tasks/?${params.toString()}`;

    // Create temporary link and trigger download
    const link = document.createElement('a');
    link.href = exportUrl;
    link.download = `tasks_export_${new Date().toISOString().split('T')[0]}.csv`;
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);

    this.showNotification('Export started. Download will begin shortly.', 'info');
  }

  // Real-time Updates
  startRealTimeUpdates() {
    this.updateInterval = setInterval(() => {
      this.updateTaskCounts();
      this.checkForNewTasks();
    }, 30000); // Update every 30 seconds
  }

  stopRealTimeUpdates() {
    if (this.updateInterval) {
      clearInterval(this.updateInterval);
    }
  }

  async updateTaskCounts() {
    try {
      const response = await APIClient.get('/api/staff/task-counts/');

      if (response.success) {
        this.updateStatsDisplay(response.counts);
      }
    } catch (error) {
      console.error('❌ Error updating task counts:', error);
    }
  }

  updateStatsDisplay(counts) {
    // Update statistics cards
    const statCards = document.querySelectorAll('.stat-card');

    statCards.forEach(card => {
      const label = card.querySelector('.stat-label');
      if (!label) return;

      let value = 0;
      if (label.textContent.includes('Total')) {
        value = counts.total || 0;
      } else if (label.textContent.includes('Pending')) {
        value = counts.pending || 0;
      } else if (label.textContent.includes('Progress')) {
        value = counts['in-progress'] || 0;
      } else if (label.textContent.includes('Completed')) {
        value = counts.completed || 0;
      }

      const numberElement = card.querySelector('.stat-number');
      if (numberElement && parseInt(numberElement.textContent) !== value) {
        numberElement.textContent = value;
        card.style.animation = 'pulse 0.5s ease';
        setTimeout(() => card.style.animation = '', 500);
      }
    });
  }

  async checkForNewTasks() {
    try {
      const response = await APIClient.get('/api/staff/task-counts/');

      if (response.success && response.counts.total > this.lastTaskCount && this.lastTaskCount > 0) {
        const newTasks = response.counts.total - this.lastTaskCount;
        this.showNotification(`${newTasks} new task${newTasks > 1 ? 's' : ''} available!`, 'info');

        // Add visual indicator
        this.addNewTasksIndicator(newTasks);
      }

      this.lastTaskCount = response.counts.total;
    } catch (error) {
      console.error('❌ Error checking for new tasks:', error);
    }
  }

  addNewTasksIndicator(count) {
    const indicator = document.createElement('div');
    indicator.className = 'new-tasks-indicator';
    indicator.innerHTML = `📬 ${count} new task${count > 1 ? 's' : ''}`;
    indicator.onclick = () => {
      indicator.remove();
      location.reload();
    };

    document.body.appendChild(indicator);

    setTimeout(() => {
      if (indicator.parentElement) {
        indicator.remove();
      }
    }, 10000);
  }

  // Filter State Management
  saveFilterState(filters) {
    try {
      localStorage.setItem('taskFilters', JSON.stringify(filters));
    } catch (error) {
      console.error('❌ Error saving filter state:', error);
    }
  }

  loadFilterState() {
    try {
      const saved = localStorage.getItem('taskFilters');
      if (saved) {
        this.currentFilters = JSON.parse(saved);
        // Apply saved filters to form
        Object.keys(this.currentFilters).forEach(key => {
          const element = document.querySelector(`[name="${key}"]`);
          if (element && this.currentFilters[key]) {
            element.value = this.currentFilters[key];
          }
        });
      }
    } catch (error) {
      console.error('❌ Error loading filter state:', error);
    }
  }

  loadSavedFilters() {
    // Load any URL parameters into current filters
    const urlParams = new URLSearchParams(window.location.search);
    urlParams.forEach((value, key) => {
      this.currentFilters[key] = value;
    });
  }

  // Keyboard Shortcuts
  setupKeyboardShortcuts() {
    document.addEventListener('keydown', (e) => this.handleKeyboardShortcuts(e));
  }

  handleKeyboardShortcuts(e) {
    // Ctrl/Cmd + A to select all tasks
    if ((e.ctrlKey || e.metaKey) && e.key === 'a') {
      e.preventDefault();
      this.selectAllTasks();
    }

    // Escape to clear selection
    if (e.key === 'Escape') {
      this.clearSelection();
    }

    // Ctrl/Cmd + F to focus search
    if ((e.ctrlKey || e.metaKey) && e.key === 'f') {
      e.preventDefault();
      const searchInput = document.getElementById('search');
      if (searchInput) {
        searchInput.focus();
        searchInput.select();
      }
    }
  }

  selectAllTasks() {
    const checkboxes = document.querySelectorAll('.task-checkbox:not(:checked)');
    checkboxes.forEach(checkbox => {
      checkbox.checked = true;
      this.updateTaskSelection(checkbox);
    });
  }

  // Utility Functions
  showNotification(message, type = 'info') {
    // Remove existing notifications
    document.querySelectorAll('.notification').forEach(n => n.remove());

    const notification = document.createElement('div');
    notification.className = `notification notification-${type}`;
    notification.innerHTML = `
      <div class="notification-content">
        <span class="notification-message">${message}</span>
        <button class="notification-close" aria-label="Close notification">×</button>
      </div>
    `;

    document.body.appendChild(notification);

    // Auto-remove after 5 seconds
    setTimeout(() => {
      if (notification.parentElement) {
        notification.remove();
      }
    }, 5000);
  }

  initializeTooltips() {
    // Add tooltips to action buttons
    document.querySelectorAll('.btn-action').forEach(button => {
      const title = button.getAttribute('title');
      if (title) {
        button.setAttribute('aria-label', title);
      }
    });
  }

  requestNewTasks() {
    this.showNotification('Task request feature coming soon!', 'info');
  }

  async initializeTaskCount() {
    // Set initial task count for new task detection
    try {
      await this.updateTaskCounts();
      const statNumber = document.querySelector('.stat-number');
      this.lastTaskCount = statNumber ? parseInt(statNumber.textContent) : 0;
    } catch (error) {
      console.error('❌ Error initializing task count:', error);
    }
  }

  // Cleanup
  destroy() {
    this.stopRealTimeUpdates();
  }
}

// Global bridge function for backward compatibility
let myTasksManager;

window.addEventListener('DOMContentLoaded', () => {
  myTasksManager = new MyTasksManager();
});

window.addEventListener('beforeunload', () => {
  if (myTasksManager) {
    myTasksManager.destroy();
  }
});

// Export for testing
export default MyTasksManager;
