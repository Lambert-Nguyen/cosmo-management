/**
 * Unit Tests for Photo Modal Module
 */

import { jest, describe, test, beforeEach, expect } from '@jest/globals';
import { PhotoModal } from '../../../aristay_backend/static/js/modules/photo-modal.js';
import { APIClient } from '../../../aristay_backend/static/js/core/api-client.js';

describe('PhotoModal', () => {
  let requestSpy;
  let uploadSpy;
  let photoModal;
  const mockTaskId = '123';

  beforeEach(() => {
    // Reset DOM
    document.body.innerHTML = `
      <div id="taskDetailContainer" data-task-id="${mockTaskId}"></div>
      <div id="photoModal" style="display: none;">
        <img id="modalPhoto" src="" alt="">
        <button class="close-modal">×</button>
        <button class="btn-approve" data-photo-id="">Approve</button>
        <button class="btn-reject" data-photo-id="">Reject</button>
      </div>
    `;

    // Mock window methods
    global.confirm = jest.fn(() => true);
    global.alert = jest.fn();
    global.prompt = jest.fn();
    
    // Mock location
    delete window.location;
    window.location = { href: '', reload: jest.fn() };

    // Mock document.readyState
    Object.defineProperty(document, 'readyState', {
      writable: true,
      value: 'complete'
    });

    // Spy on APIClient methods
    requestSpy = jest.spyOn(APIClient, 'request').mockResolvedValue({ success: true });
    uploadSpy = jest.spyOn(APIClient, 'upload').mockResolvedValue({ success: true });

    photoModal = new PhotoModal();
  });

  afterEach(() => {
    jest.restoreAllMocks();
  });

  describe('Constructor and Initialization', () => {
    test('finds modal element', () => {
      expect(photoModal.modal).toBeTruthy();
      expect(photoModal.modal.id).toBe('photoModal');
    });

    test('gets task ID from container', () => {
      expect(photoModal.taskId).toBe(mockTaskId);
    });

    test('initializes with null photo state', () => {
      expect(photoModal.currentPhotoId).toBeNull();
      expect(photoModal.currentPhotoUrl).toBeNull();
    });

    test('handles missing modal gracefully', () => {
      document.body.innerHTML = '';
      const consoleWarn = jest.spyOn(console, 'warn').mockImplementation();
      
      const newModal = new PhotoModal();
      
      expect(consoleWarn).toHaveBeenCalledWith('Photo modal not found in DOM');
      consoleWarn.mockRestore();
    });
    
    test('waits for DOMContentLoaded when document is loading', () => {
      document.body.innerHTML = `
        <div id="taskDetailContainer" data-task-id="${mockTaskId}"></div>
        <div id="photoModal" style="display: none;">
          <img id="modalPhoto" src="" alt="">
        </div>
      `;
      
      Object.defineProperty(document, 'readyState', {
        writable: true,
        value: 'loading'
      });
      
      const addEventListenerSpy = jest.spyOn(document, 'addEventListener');
      
      const newModal = new PhotoModal();
      
      expect(addEventListenerSpy).toHaveBeenCalledWith('DOMContentLoaded', expect.any(Function));
      
      addEventListenerSpy.mockRestore();
      Object.defineProperty(document, 'readyState', {
        writable: true,
        value: 'complete'
      });
    });
    
    test('gets task ID from alternate selector when main container not found', () => {
      document.body.innerHTML = `
        <div data-task-id="999"></div>
        <div id="photoModal" style="display: none;">
          <img id="modalPhoto" src="" alt="">
        </div>
      `;
      
      const newModal = new PhotoModal();
      expect(newModal.taskId).toBe('999');
    });
  });

  describe('open', () => {
    test('displays modal with photo', () => {
      const photoUrl = 'https://example.com/photo.jpg';
      const photoId = '456';

      photoModal.open(photoUrl, photoId);

      expect(photoModal.modal.style.display).toBe('block');
      expect(photoModal.currentPhotoUrl).toBe(photoUrl);
      expect(photoModal.currentPhotoId).toBe(photoId);
    });

    test('sets photo src', () => {
      const photoUrl = 'https://example.com/photo.jpg';
      const photoId = '456';

      photoModal.open(photoUrl, photoId);

      const modalPhoto = document.getElementById('modalPhoto');
      expect(modalPhoto.src).toBe(photoUrl);
    });

    test('updates button data attributes', () => {
      const photoId = '456';

      photoModal.open('https://example.com/photo.jpg', photoId);

      const approveBtn = document.querySelector('.btn-approve');
      const rejectBtn = document.querySelector('.btn-reject');

      expect(approveBtn.dataset.photoId).toBe(photoId);
      expect(rejectBtn.dataset.photoId).toBe(photoId);
    });

    test('prevents background scroll', () => {
      photoModal.open('https://example.com/photo.jpg', '456');

      expect(document.body.style.overflow).toBe('hidden');
    });

    test('handles missing modal gracefully', () => {
      photoModal.modal = null;
      const consoleError = jest.spyOn(console, 'error').mockImplementation();

      photoModal.open('https://example.com/photo.jpg', '456');

      expect(consoleError).toHaveBeenCalledWith('Modal not initialized');
      consoleError.mockRestore();
    });
  });

  describe('close', () => {
    test('hides modal', () => {
      photoModal.open('https://example.com/photo.jpg', '456');
      photoModal.close();

      expect(photoModal.modal.style.display).toBe('none');
    });

    test('restores background scroll', () => {
      photoModal.open('https://example.com/photo.jpg', '456');
      photoModal.close();

      expect(document.body.style.overflow).toBe('');
    });

    test('clears photo state', () => {
      photoModal.open('https://example.com/photo.jpg', '456');
      photoModal.close();

      expect(photoModal.currentPhotoUrl).toBeNull();
      expect(photoModal.currentPhotoId).toBeNull();
    });
  });

  describe('isOpen', () => {
    test('returns true when modal is open', () => {
      photoModal.open('https://example.com/photo.jpg', '456');
      expect(photoModal.isOpen()).toBe(true);
    });

    test('returns false when modal is closed', () => {
      expect(photoModal.isOpen()).toBe(false);
    });
  });

  describe('Event Listeners', () => {
    test('closes on background click', () => {
      photoModal.open('https://example.com/photo.jpg', '456');

      const modal = document.getElementById('photoModal');
      modal.click();

      expect(photoModal.modal.style.display).toBe('none');
    });

    test('closes on close button click', () => {
      photoModal.open('https://example.com/photo.jpg', '456');

      const closeBtn = document.querySelector('.close-modal');
      closeBtn.click();

      expect(photoModal.modal.style.display).toBe('none');
    });

    test('closes on Escape key', () => {
      photoModal.open('https://example.com/photo.jpg', '456');

      const escapeEvent = new KeyboardEvent('keydown', { key: 'Escape' });
      document.dispatchEvent(escapeEvent);

      expect(photoModal.modal.style.display).toBe('none');
    });

    test('does not close on other keys', () => {
      photoModal.open('https://example.com/photo.jpg', '456');

      const enterEvent = new KeyboardEvent('keydown', { key: 'Enter' });
      document.dispatchEvent(enterEvent);

      expect(photoModal.modal.style.display).toBe('block');
    });
  });

  describe('Button Event Delegation', () => {
    test('clicking approve button calls approvePhoto', async () => {
      photoModal.open('https://example.com/photo.jpg', '456');
      jest.spyOn(photoModal, 'approvePhoto').mockResolvedValue();

      const approveBtn = document.querySelector('.btn-approve');
      approveBtn.click();

      // Wait for async event handler
      await new Promise(resolve => setTimeout(resolve, 0));

      expect(photoModal.approvePhoto).toHaveBeenCalledWith('456');
    });

    test('clicking reject button calls rejectPhoto', async () => {
      photoModal.open('https://example.com/photo.jpg', '456');
      jest.spyOn(photoModal, 'rejectPhoto').mockResolvedValue();

      const rejectBtn = document.querySelector('.btn-reject');
      rejectBtn.click();

      // Wait for async event handler
      await new Promise(resolve => setTimeout(resolve, 0));

      expect(photoModal.rejectPhoto).toHaveBeenCalledWith('456');
    });
  });

  describe('approvePhoto', () => {
    test('approves photo via API when confirmed', async () => {
      requestSpy.mockResolvedValue({ success: true });
      photoModal.open('https://example.com/photo.jpg', '456');

      await photoModal.approvePhoto('456');

      expect(global.confirm).toHaveBeenCalledWith('Approve this photo?');
      expect(APIClient.request).toHaveBeenCalledWith(
        `/api/tasks/${mockTaskId}/images/456/`,
        {
          method: 'PATCH',
          body: JSON.stringify({ photo_status: 'approved' })
        }
      );
      expect(global.alert).toHaveBeenCalledWith('Photo approved successfully!');
      expect(window.location.reload).toHaveBeenCalled();
    });

    test('does not approve when cancelled', async () => {
      global.confirm.mockReturnValue(false);

      await photoModal.approvePhoto('456');

      expect(APIClient.request).not.toHaveBeenCalled();
    });

    test('handles API errors gracefully', async () => {
      const errorMessage = 'Network error';
      requestSpy.mockRejectedValue(new Error(errorMessage));
      photoModal.open('https://example.com/photo.jpg', '456');

      await photoModal.approvePhoto('456');

      expect(global.alert).toHaveBeenCalledWith(`Failed to approve photo: ${errorMessage}`);
    });
  });

  describe('rejectPhoto', () => {
    test('rejects photo with reason via API', async () => {
      const reason = 'Photo is blurry';
      global.prompt.mockReturnValue(reason);
      requestSpy.mockResolvedValue({ success: true });
      photoModal.open('https://example.com/photo.jpg', '456');

      await photoModal.rejectPhoto('456');

      expect(global.prompt).toHaveBeenCalledWith('Why are you rejecting this photo?');
      expect(APIClient.request).toHaveBeenCalledWith(
        `/api/tasks/${mockTaskId}/images/456/`,
        {
          method: 'PATCH',
          body: JSON.stringify({ 
            photo_status: 'rejected',
            rejection_reason: reason
          })
        }
      );
      expect(global.alert).toHaveBeenCalledWith('Photo rejected successfully!');
      expect(window.location.reload).toHaveBeenCalled();
    });

    test('does not reject without reason', async () => {
      global.prompt.mockReturnValue(null);

      await photoModal.rejectPhoto('456');

      expect(APIClient.request).not.toHaveBeenCalled();
    });

    test('does not reject with empty reason', async () => {
      global.prompt.mockReturnValue('   ');

      await photoModal.rejectPhoto('456');

      expect(APIClient.request).not.toHaveBeenCalled();
    });

    test('handles API errors gracefully', async () => {
      const errorMessage = 'Network error';
      global.prompt.mockReturnValue('Too dark');
      requestSpy.mockRejectedValue(new Error(errorMessage));
      photoModal.open('https://example.com/photo.jpg', '456');

      await photoModal.rejectPhoto('456');

      expect(global.alert).toHaveBeenCalledWith(`Failed to reject photo: ${errorMessage}`);
    });
  });

  describe('Global Bridge Functions', () => {
    test('exposes global openPhotoModal function', () => {
      expect(typeof window.openPhotoModal).toBe('function');
    });

    test('global function opens modal', () => {
      const photoUrl = 'https://example.com/photo.jpg';
      const photoId = '456';

      window.openPhotoModal(photoUrl, photoId);

      const modal = document.getElementById('photoModal');
      expect(modal.style.display).toBe('block');
      expect(window._photoModalInstance.currentPhotoId).toBe(photoId);
    });

    test('exposes test function', () => {
      expect(typeof window.testPhotoModal).toBe('function');
    });

    test('test function opens modal with placeholder', () => {
      // Ensure instance is set before calling test function
      window._photoModalInstance = photoModal;
      window.testPhotoModal();

      const modal = document.getElementById('photoModal');
      expect(modal.style.display).toBe('block');
    });
  });
});
