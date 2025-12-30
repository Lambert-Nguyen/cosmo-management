/**
 * Dashboard Manager Module
 * Handles staff dashboard interactions: filtering, quick task actions,
 * real-time counts, notifications, and optional push notifications.
 */

import { APIClient } from '../core/api-client.js';

export class DashboardManager {
  constructor() {
    this.updateIntervalId = null;
    this.newTasksIntervalId = null;
    this.lastTaskCount = 0;

    this.init();
  }

  init() {
    this.setupEventListeners();
    this.ensureLiveIndicator();
    this.startRealTimeUpdates();
    this.startNewTaskChecks();
    this.maybeRequestNotificationPermission();

    // Expose instance for debugging only
    window.dashboardManagerInstance = this;
  }

  setupEventListeners() {
    document.addEventListener('click', (e) => {
      // Stat card filtering
      const filterCard = e.target.closest('[data-action="filter-tasks"]');
      if (filterCard) {
        e.preventDefault();
        const status = filterCard.dataset.status || 'all';
        this.filterTasks(status);
        return;
      }

      // Task actions (start/complete/view)
      const actionBtn = e.target.closest('[data-action]');
      if (actionBtn) {
        const action = actionBtn.dataset.action;
        const taskId = actionBtn.dataset.taskId;

        if (action === 'start-task') {
          e.preventDefault();
          if (!taskId) return;
          this.startTask(taskId, actionBtn);
          return;
        }

        if (action === 'complete-task') {
          e.preventDefault();
          if (!taskId) return;
          this.completeTask(taskId, actionBtn);
          return;
        }

        if (action === 'view-task') {
          e.preventDefault();
          if (!taskId) return;
          this.viewTask(taskId);
          return;
        }
      }

      // Notifications
      const closeNotificationBtn = e.target.closest('.notification-close');
      if (closeNotificationBtn) {
        e.preventDefault();
        closeNotificationBtn.closest('.notification')?.remove();
        return;
      }
    });

    // Basic keyboard accessibility for stat cards
    document.addEventListener('keydown', (e) => {
      if (e.key !== 'Enter' && e.key !== ' ') return;
      const focused = document.activeElement;
      if (focused && focused.matches('[data-action="filter-tasks"]')) {
        e.preventDefault();
        const status = focused.dataset.status || 'all';
        this.filterTasks(status);
      }
    });

    window.addEventListener('beforeunload', () => this.destroy());
  }

  filterTasks(status) {
    const baseUrl = '/api/staff/tasks/';
    const url = status === 'all' ? baseUrl : `${baseUrl}?status=${encodeURIComponent(status)}`;
    window.location.href = url;
  }

  async startTask(taskId, buttonEl) {
    if (!confirm('Start this task?')) return;
    await this.updateTaskStatus(taskId, 'in-progress', buttonEl, '▶️ Start');
  }

  async completeTask(taskId, buttonEl) {
    if (!confirm('Mark this task as completed?')) return;
    await this.updateTaskStatus(taskId, 'completed', buttonEl, '✅ Complete');
  }

  viewTask(taskId) {
    window.location.href = `/api/staff/tasks/${taskId}/`;
  }

  async updateTaskStatus(taskId, status, buttonEl, originalLabelFallback) {
    const originalHtml = buttonEl?.innerHTML ?? originalLabelFallback;

    if (buttonEl) {
      buttonEl.innerHTML = '⏳ Updating...';
      buttonEl.disabled = true;
    }

    try {
      const data = await APIClient.post(`/api/staff/tasks/${taskId}/status/`, { status });

      if (!data?.success) {
        throw new Error(data?.error || 'Failed to update task status');
      }

      this.showNotification('Task status updated successfully!', 'success');
      this.updateTaskCardUI(taskId, status, data.status_display);
      await this.updateTaskCounts();

    } catch (error) {
      console.error('[DashboardManager] Failed to update task status:', error);
      this.showNotification(`Failed to update task status: ${error.message}`, 'error');

      if (buttonEl) {
        buttonEl.innerHTML = originalHtml;
        buttonEl.disabled = false;
      }
    }
  }

  showNotification(message, type = 'info') {
    const notification = document.createElement('div');
    notification.className = `notification notification-${type}`;
    notification.innerHTML = `
      <div class="notification-content">
        <span class="notification-message"></span>
        <button class="notification-close" type="button" aria-label="Dismiss notification">×</button>
      </div>
    `;

    const messageEl = notification.querySelector('.notification-message');
    if (messageEl) messageEl.textContent = message;

    document.body.appendChild(notification);

    window.setTimeout(() => {
      notification.remove();
    }, 5000);
  }

  updateTaskCardUI(taskId, status, statusDisplay) {
    const taskCard = document.querySelector(`[data-task-id="${taskId}"]`);
    if (!taskCard) return;

    const statusBadge = taskCard.querySelector('.status-badge');
    if (statusBadge) {
      statusBadge.textContent = statusDisplay || status;
      statusBadge.className = `status-badge status-${status.replace('-', '')}`;
    }

    const startBtn = taskCard.querySelector('[data-action="start-task"]');
    const completeBtn = taskCard.querySelector('[data-action="complete-task"]');

    if (status === 'in-progress') {
      if (startBtn) {
        startBtn.disabled = true;
        startBtn.textContent = '▶️ Started';
      }
      if (completeBtn) {
        completeBtn.disabled = false;
      }
    } else if (status === 'completed') {
      if (startBtn) {
        startBtn.disabled = true;
      }
      if (completeBtn) {
        completeBtn.disabled = true;
        completeBtn.textContent = '✅ Completed';
      }
    }
  }

  startRealTimeUpdates() {
    // Update every 30 seconds
    this.updateIntervalId = window.setInterval(() => {
      this.updateTaskCounts();
    }, 30000);

    // Initial update
    this.updateTaskCounts();
  }

  async updateTaskCounts() {
    try {
      const data = await APIClient.get('/api/staff/task-counts/');
      if (!data?.success) return;
      this.updateDashboardCounts(data.counts);
    } catch (error) {
      console.error('[DashboardManager] Error updating task counts:', error);
    }
  }

  updateDashboardCounts(counts) {
    const mapping = {
      total: 'total',
      pending: 'pending',
      'in-progress': 'in-progress',
      completed: 'completed',
      overdue: 'overdue'
    };

    Object.keys(mapping).forEach((key) => {
      const statEl = document.querySelector(`[data-stat="${key}"]`);
      if (statEl) {
        statEl.textContent = counts?.[key] ?? 0;
      }
    });

    this.addUpdateIndicator();
  }

  addUpdateIndicator() {
    const statCards = document.querySelectorAll('.stat-card.clickable');
    statCards.forEach((card) => card.classList.add('updating'));

    window.setTimeout(() => {
      statCards.forEach((card) => card.classList.remove('updating'));
    }, 500);
  }

  startNewTaskChecks() {
    // Check for new tasks every 2 minutes
    this.newTasksIntervalId = window.setInterval(() => {
      this.checkForNewTasks();
    }, 120000);

    // Prime lastTaskCount on load
    this.checkForNewTasks({ primeOnly: true });
  }

  async checkForNewTasks({ primeOnly = false } = {}) {
    try {
      const data = await APIClient.get('/api/staff/task-counts/');
      if (!data?.success) return;

      const total = data?.counts?.total ?? 0;

      if (!primeOnly && this.lastTaskCount > 0 && total > this.lastTaskCount) {
        const newTasks = total - this.lastTaskCount;
        this.sendPushNotification(
          'New Tasks Available',
          `${newTasks} new task${newTasks > 1 ? 's' : ''} have been assigned to you.`
        );
        this.showNotification(`${newTasks} new task${newTasks > 1 ? 's' : ''} available!`, 'info');
      }

      this.lastTaskCount = total;

    } catch (error) {
      console.error('[DashboardManager] Error checking for new tasks:', error);
    }
  }

  maybeRequestNotificationPermission() {
    if (!('Notification' in window)) return;
    if (Notification.permission !== 'default') return;

    window.setTimeout(() => {
      Notification.requestPermission().then((permission) => {
        if (permission === 'granted') {
          this.showNotification('Push notifications enabled!', 'success');
          localStorage.setItem('notifications_enabled', 'true');
        }
      });
    }, 2000);
  }

  sendPushNotification(title, body, icon = '/static/images/cosmo_logo.jpg') {
    if (!('Notification' in window)) return;
    if (Notification.permission !== 'granted') return;

    try {
      new Notification(title, {
        body,
        icon,
        badge: '/static/images/cosmo_logo.jpg',
        tag: 'cosmo-notification'
      });
    } catch (error) {
      console.error('[DashboardManager] Failed to send push notification:', error);
    }
  }

  ensureLiveIndicator() {
    const existing = document.getElementById('liveIndicator');
    if (existing) return;

    const liveIndicator = document.createElement('div');
    liveIndicator.className = 'live-indicator';
    liveIndicator.id = 'liveIndicator';
    liveIndicator.textContent = '🔄 Live Updates Active';
    document.body.appendChild(liveIndicator);
  }

  destroy() {
    if (this.updateIntervalId) {
      window.clearInterval(this.updateIntervalId);
      this.updateIntervalId = null;
    }

    if (this.newTasksIntervalId) {
      window.clearInterval(this.newTasksIntervalId);
      this.newTasksIntervalId = null;
    }
  }
}
