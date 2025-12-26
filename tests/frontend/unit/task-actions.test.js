/**
 * Unit Tests for Task Actions Module
 */

import { jest, describe, test, beforeEach, expect } from '@jest/globals';
import { TaskActions } from '../../../aristay_backend/static/js/modules/task-actions.js';
import { APIClient } from '../../../aristay_backend/static/js/core/api-client.js';

describe('TaskActions', () => {
  let postSpy;
  let requestSpy;
  let uploadSpy;
  let taskActions;
  const mockTaskId = '123';

  beforeEach(() => {
    // Reset DOM
    document.body.innerHTML = `
      <div class="task-title">Test Task</div>
      <div class="status-badge status-pending">Pending</div>
      <button class="btn-action start-task" data-task-id="${mockTaskId}">Start</button>
      <button class="btn-action complete-task" data-task-id="${mockTaskId}">Complete</button>
      <button class="btn-action add-note" data-task-id="${mockTaskId}">Add Note</button>
      <button class="btn-action share-task" data-task-id="${mockTaskId}">Share</button>
      <button class="btn-action report-lost-found" data-task-id="${mockTaskId}">Report</button>
      <button class="btn-action duplicate-task">Duplicate</button>
      <button class="btn-action delete-task">Delete</button>
    `;

    // Mock window methods
    global.confirm = jest.fn(() => true);
    global.alert = jest.fn();
    global.prompt = jest.fn();
    
    // Mock location
    delete window.location;
    window.location = { href: '', reload: jest.fn() };
    
    // Mock document.execCommand for older browsers
    if (!document.execCommand) {
      document.execCommand = jest.fn(() => true);
    }

    // Spy on APIClient methods
    postSpy = jest.spyOn(APIClient, 'post').mockResolvedValue({ success: true });
    requestSpy = jest.spyOn(APIClient, 'request').mockResolvedValue({ success: true });
    uploadSpy = jest.spyOn(APIClient, 'upload').mockResolvedValue({ success: true });

    taskActions = new TaskActions(mockTaskId);
  });

  afterEach(() => {
    jest.restoreAllMocks();
  });

  describe('Constructor and Initialization', () => {
    test('stores task ID', () => {
      expect(taskActions.taskId).toBe(mockTaskId);
    });

    test('initializes event listeners', () => {
      const startBtn = document.querySelector('.btn-action.start-task');
      expect(startBtn).toBeTruthy();
    });
  });

  describe('startTask', () => {
    test('calls API to start task when confirmed', async () => {
      APIClient.post.mockResolvedValue({ success: true });

      await taskActions.startTask();

      expect(global.confirm).toHaveBeenCalledWith('Start this task now?');
      expect(APIClient.post).toHaveBeenCalledWith(
        `/api/staff/tasks/${mockTaskId}/start/`,
        {}
      );
      expect(window.location.reload).toHaveBeenCalled();
    });

    test('does not call API when cancelled', async () => {
      global.confirm.mockReturnValue(false);

      await taskActions.startTask();

      expect(APIClient.post).not.toHaveBeenCalled();
    });

    test('handles API errors gracefully', async () => {
      const errorMessage = 'Network error';
      APIClient.post.mockRejectedValue(new Error(errorMessage));

      await taskActions.startTask();

      expect(global.alert).toHaveBeenCalledWith(`Failed to start task: ${errorMessage}`);
    });
  });

  describe('completeTask', () => {
    test('calls API to complete task when confirmed', async () => {
      APIClient.post.mockResolvedValue({ success: true });

      await taskActions.completeTask();

      expect(global.confirm).toHaveBeenCalledWith('Mark this task as complete?');
      expect(APIClient.post).toHaveBeenCalledWith(
        `/api/staff/tasks/${mockTaskId}/complete/`,
        {}
      );
      expect(window.location.reload).toHaveBeenCalled();
    });

    test('does not call API when cancelled', async () => {
      global.confirm.mockReturnValue(false);

      await taskActions.completeTask();

      expect(APIClient.post).not.toHaveBeenCalled();
    });
    
    test('handles API errors gracefully', async () => {
      const errorMessage = 'Task cannot be completed';
      APIClient.post.mockRejectedValue(new Error(errorMessage));

      await taskActions.completeTask();

      expect(global.alert).toHaveBeenCalledWith(`Failed to complete task: ${errorMessage}`);
    });
  });

  describe('addNote', () => {
    test('adds note when valid input provided', async () => {
      const noteContent = 'This is a test note';
      global.prompt.mockReturnValue(noteContent);
      APIClient.post.mockResolvedValue({ success: true });

      await taskActions.addNote();

      expect(global.prompt).toHaveBeenCalledWith('Add a note to this task:');
      expect(APIClient.post).toHaveBeenCalledWith(
        `/api/staff/tasks/${mockTaskId}/notes/`,
        { content: noteContent }
      );
      expect(window.location.reload).toHaveBeenCalled();
    });

    test('does not add note when cancelled', async () => {
      global.prompt.mockReturnValue(null);

      await taskActions.addNote();

      expect(APIClient.post).not.toHaveBeenCalled();
    });

    test('does not add empty note', async () => {
      global.prompt.mockReturnValue('   ');

      await taskActions.addNote();

      expect(APIClient.post).not.toHaveBeenCalled();
    });
    
    test('handles API errors gracefully', async () => {
      global.prompt.mockReturnValue('Test note');
      const errorMessage = 'Failed to save note';
      APIClient.post.mockRejectedValue(new Error(errorMessage));

      await taskActions.addNote();

      expect(global.alert).toHaveBeenCalledWith(`Failed to add note: ${errorMessage}`);
    });
  });

  describe('shareTask', () => {
    test('uses Web Share API when available', async () => {
      global.navigator.share = jest.fn().mockResolvedValue();

      await taskActions.shareTask();

      expect(navigator.share).toHaveBeenCalledWith({
        title: expect.any(String),
        url: expect.any(String)
      });
    });

    test('falls back to clipboard when Web Share API not available', async () => {
      global.navigator.share = undefined;
      global.navigator.clipboard = {
        writeText: jest.fn().mockResolvedValue()
      };

      await taskActions.shareTask();

      expect(navigator.clipboard.writeText).toHaveBeenCalled();
      expect(global.alert).toHaveBeenCalledWith('Task link copied to clipboard!');
    });
    
    test('handles Web Share API errors and falls back to clipboard', async () => {
      global.navigator.share = jest.fn().mockRejectedValue(new Error('Share cancelled'));
      global.navigator.clipboard = {
        writeText: jest.fn().mockResolvedValue()
      };

      await taskActions.shareTask();

      expect(navigator.clipboard.writeText).toHaveBeenCalled();
    });
    
    test('uses fallback copy when clipboard API fails', async () => {
      global.navigator.share = undefined;
      const writeTextMock = jest.fn().mockRejectedValue(new Error('Clipboard denied'));
      global.navigator.clipboard = {
        writeText: writeTextMock
      };

      await taskActions.shareTask();
      
      // Wait for promise rejection to be handled
      await new Promise(resolve => setTimeout(resolve, 0));

      // Verify writeText was attempted
      expect(writeTextMock).toHaveBeenCalled();
      // Verify fallback alert was triggered
      expect(global.alert).toHaveBeenCalled();
    });
    
    test('uses textarea fallback when clipboard API not available', async () => {
      global.navigator.share = undefined;
      delete global.navigator.clipboard;
      
      if (!document.execCommand) {
        document.execCommand = jest.fn(() => true);
      } else {
        jest.spyOn(document, 'execCommand').mockReturnValue(true);
      }

      await taskActions.shareTask();

      expect(global.alert).toHaveBeenCalledWith('Task link copied to clipboard!');
    });
    
    test('handles execCommand throwing error', async () => {
      global.navigator.share = undefined;
      delete global.navigator.clipboard;
      
      if (!document.execCommand) {
        document.execCommand = jest.fn(() => {
          throw new Error('execCommand failed');
        });
      } else {
        jest.spyOn(document, 'execCommand').mockImplementation(() => {
          throw new Error('execCommand failed');
        });
      }

      await taskActions.shareTask();

      expect(global.alert).toHaveBeenCalledWith(expect.stringContaining('Failed to copy link'));
    });
  });

  describe('reportLostFound', () => {
    test('submits lost & found report', async () => {
      const description = 'Found a wallet';
      global.prompt.mockReturnValue(description);
      global.confirm.mockReturnValueOnce(true).mockReturnValueOnce(true); // First for found, second implicit
      APIClient.post.mockResolvedValue({ success: true });

      await taskActions.reportLostFound();

      expect(global.prompt).toHaveBeenCalledWith('Describe the lost or found item:');
      expect(APIClient.post).toHaveBeenCalledWith(
        `/api/staff/tasks/${mockTaskId}/lost-found/`,
        { description, found: true }
      );
    });
    
    test('does not submit when cancelled', async () => {
      global.prompt.mockReturnValue(null);

      await taskActions.reportLostFound();

      expect(APIClient.post).not.toHaveBeenCalled();
    });
    
    test('does not submit empty description', async () => {
      global.prompt.mockReturnValue('   ');

      await taskActions.reportLostFound();

      expect(APIClient.post).not.toHaveBeenCalled();
    });
    
    test('handles API errors gracefully', async () => {
      global.prompt.mockReturnValue('Lost keys');
      const errorMessage = 'Failed to submit report';
      APIClient.post.mockRejectedValue(new Error(errorMessage));

      await taskActions.reportLostFound();

      expect(global.alert).toHaveBeenCalledWith(`Failed to submit report: ${errorMessage}`);
    });
  });

  describe('duplicateTask', () => {
    test('duplicates task and navigates to new task', async () => {
      const newTaskId = '456';
      APIClient.post.mockResolvedValue({ success: true, new_task_id: newTaskId });

      await taskActions.duplicateTask();

      expect(global.confirm).toHaveBeenCalledWith('Create a duplicate of this task?');
      expect(APIClient.post).toHaveBeenCalledWith(
        `/api/staff/tasks/${mockTaskId}/duplicate/`,
        {}
      );
      expect(window.location.href).toBe(`/api/staff/tasks/${newTaskId}/`);
    });
    
    test('does not duplicate when cancelled', async () => {
      global.confirm.mockReturnValue(false);

      await taskActions.duplicateTask();

      expect(APIClient.post).not.toHaveBeenCalled();
    });
    
    test('handles API errors gracefully', async () => {
      const errorMessage = 'Duplication failed';
      APIClient.post.mockRejectedValue(new Error(errorMessage));

      await taskActions.duplicateTask();

      expect(global.alert).toHaveBeenCalledWith(`Failed to duplicate task: ${errorMessage}`);
    });
  });

  describe('deleteTask', () => {
    test('deletes task and navigates to task list', async () => {
      const taskTitle = 'Test Task';
      requestSpy.mockResolvedValue({ success: true });

      await taskActions.deleteTask(taskTitle);

      expect(global.confirm).toHaveBeenCalledWith(
        `Are you sure you want to delete "${taskTitle}"? This cannot be undone.`
      );
      expect(APIClient.request).toHaveBeenCalledWith(
        `/api/staff/tasks/${mockTaskId}/`,
        { method: 'DELETE' }
      );
      expect(window.location.href).toBe('/api/staff/tasks/');
    });

    test('does not delete when cancelled', async () => {
      global.confirm.mockReturnValue(false);

      await taskActions.deleteTask('Test Task');

      expect(APIClient.request).not.toHaveBeenCalled();
    });
    
    test('delete button click triggers deleteTask with task title', async () => {
      jest.spyOn(taskActions, 'deleteTask').mockResolvedValue();
      
      const deleteBtn = document.querySelector('.btn-action.delete-task');
      deleteBtn.click();
      
      expect(taskActions.deleteTask).toHaveBeenCalledWith('Test Task');
    });
    
    test('handles API errors gracefully', async () => {
      const errorMessage = 'Delete failed';
      requestSpy.mockRejectedValue(new Error(errorMessage));

      await taskActions.deleteTask('Test Task');

      expect(global.alert).toHaveBeenCalledWith(`Failed to delete task: ${errorMessage}`);
    });
  });

  describe('updateTaskStatus', () => {
    test('updates status badge correctly', () => {
      taskActions.updateTaskStatus('in-progress');

      const statusBadge = document.querySelector('.status-badge');
      expect(statusBadge.className).toBe('status-badge status-inprogress');
      expect(statusBadge.textContent).toBe('IN PROGRESS');
    });

    test('updates button states when status changes', () => {
      const startBtn = document.querySelector('.btn-action.start-task');
      const completeBtn = document.querySelector('.btn-action.complete-task');

      taskActions.updateTaskStatus('in-progress');

      expect(startBtn.disabled).toBe(true);
      expect(completeBtn.disabled).toBe(false);

      taskActions.updateTaskStatus('completed');

      expect(startBtn.disabled).toBe(true);
      expect(completeBtn.disabled).toBe(true);
    });
  });

  describe('Global Bridge Functions', () => {
    test('exposes global window functions', () => {
      expect(typeof window.startTask).toBe('function');
      expect(typeof window.completeTask).toBe('function');
      expect(typeof window.addNote).toBe('function');
      expect(typeof window.shareTask).toBe('function');
      expect(typeof window.reportLostFound).toBe('function');
      expect(typeof window.duplicateTask).toBe('function');
      expect(typeof window.deleteTask).toBe('function');
    });

    test('global startTask calls instance method', async () => {
      window.taskActionsInstance = taskActions;
      jest.spyOn(taskActions, 'startTask');

      window.startTask(mockTaskId);

      expect(taskActions.startTask).toHaveBeenCalled();
    });
    
    test('global completeTask calls instance method', async () => {
      window.taskActionsInstance = taskActions;
      jest.spyOn(taskActions, 'completeTask');

      window.completeTask(mockTaskId);

      expect(taskActions.completeTask).toHaveBeenCalled();
    });
    
    test('global addNote calls instance method', async () => {
      window.taskActionsInstance = taskActions;
      jest.spyOn(taskActions, 'addNote');

      window.addNote();

      expect(taskActions.addNote).toHaveBeenCalled();
    });
    
    test('global shareTask calls instance method', async () => {
      window.taskActionsInstance = taskActions;
      jest.spyOn(taskActions, 'shareTask');

      window.shareTask();

      expect(taskActions.shareTask).toHaveBeenCalled();
    });
    
    test('global reportLostFound calls instance method', async () => {
      window.taskActionsInstance = taskActions;
      jest.spyOn(taskActions, 'reportLostFound');

      window.reportLostFound();

      expect(taskActions.reportLostFound).toHaveBeenCalled();
    });
    
    test('global duplicateTask calls instance method', async () => {
      window.taskActionsInstance = taskActions;
      jest.spyOn(taskActions, 'duplicateTask');

      window.duplicateTask(mockTaskId);

      expect(taskActions.duplicateTask).toHaveBeenCalled();
    });
    
    test('global deleteTask calls instance method', async () => {
      window.taskActionsInstance = taskActions;
      jest.spyOn(taskActions, 'deleteTask');

      window.deleteTask(mockTaskId, 'Test Task');

      expect(taskActions.deleteTask).toHaveBeenCalledWith('Test Task');
    });
  });
});
