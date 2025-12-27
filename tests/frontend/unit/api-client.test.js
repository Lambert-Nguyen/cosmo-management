/**
 * Unit Tests: API Client
 * Tests the APIClient utility for HTTP requests
 */

import { jest, describe, test, beforeEach, afterEach, expect } from '@jest/globals';
import { APIClient } from '../../../cosmo_backend/static/js/core/api-client.js';
import { CSRFManager } from '../../../cosmo_backend/static/js/core/csrf.js';

describe('APIClient', () => {
  let csrfSpy;
  
  beforeEach(() => {
    global.fetch = jest.fn();
    csrfSpy = jest.spyOn(CSRFManager, 'getFetchHeaders').mockReturnValue({ 'X-CSRFToken': 'test-csrf-token' });
  });

  afterEach(() => {
    jest.restoreAllMocks();
  });

  describe('request()', () => {
    test('makes GET request without CSRF token', async () => {
      global.fetch.mockResolvedValue({
        ok: true,
        json: async () => ({ data: 'success' })
      });

      const result = await APIClient.request('/api/test/', { method: 'GET' });

      expect(fetch).toHaveBeenCalledWith('/api/test/', {
        method: 'GET',
        headers: {},
        credentials: 'same-origin'
      });
      expect(result).toEqual({ data: 'success' });
    });

    test('adds CSRF token for POST requests', async () => {
      global.fetch.mockResolvedValue({
        ok: true,
        json: async () => ({ success: true })
      });

      await APIClient.request('/api/test/', {
        method: 'POST',
        body: JSON.stringify({ key: 'value' })
      });

      expect(fetch).toHaveBeenCalledWith('/api/test/', {
        method: 'POST',
        headers: {
          'X-CSRFToken': 'test-csrf-token',
          'Content-Type': 'application/json'
        },
        credentials: 'same-origin',
        body: JSON.stringify({ key: 'value' })
      });
    });

    test('does not add Content-Type for FormData', async () => {
      global.fetch.mockResolvedValue({
        ok: true,
        json: async () => ({ success: true })
      });

      const formData = new FormData();
      formData.append('file', 'test');

      await APIClient.request('/api/upload/', {
        method: 'POST',
        body: formData
      });

      expect(fetch).toHaveBeenCalledWith('/api/upload/', {
        method: 'POST',
        headers: { 'X-CSRFToken': 'test-csrf-token' },
        credentials: 'same-origin',
        body: formData
      });
    });

    test('throws error on failed request', async () => {
      global.fetch.mockResolvedValue({
        ok: false,
        status: 404,
        json: async () => ({ error: 'Not found' })
      });

      await expect(APIClient.request('/api/missing/')).rejects.toThrow('Not found');
    });

    test('handles network errors', async () => {
      global.fetch.mockRejectedValue(new Error('Network error'));

      await expect(APIClient.request('/api/test/')).rejects.toThrow('Network request failed');
    });
    
    test('handles 204 No Content response', async () => {
      global.fetch.mockResolvedValue({
        ok: true,
        status: 204
      });

      const result = await APIClient.request('/api/delete/', { method: 'DELETE' });
      expect(result).toEqual({ success: true });
    });
    
    test('handles JSON parse error in error response', async () => {
      global.fetch.mockResolvedValue({
        ok: false,
        status: 500,
        statusText: 'Internal Server Error',
        json: async () => {
          throw new Error('Invalid JSON');
        }
      });

      await expect(APIClient.request('/api/test/')).rejects.toThrow('Internal Server Error');
    });
    
    test('handles response without statusText', async () => {
      global.fetch.mockResolvedValue({
        ok: false,
        status: 500,
        statusText: '',
        json: async () => {
          throw new Error('Invalid JSON');
        }
      });

      await expect(APIClient.request('/api/test/')).rejects.toThrow('HTTP 500');
    });
  });

  describe('post()', () => {
    test('makes POST request with JSON body', async () => {
      global.fetch.mockResolvedValue({
        ok: true,
        json: async () => ({ id: 123 })
      });

      const result = await APIClient.post('/api/create/', { name: 'Test' });

      expect(fetch).toHaveBeenCalledWith('/api/create/', {
        method: 'POST',
        headers: {
          'X-CSRFToken': 'test-csrf-token',
          'Content-Type': 'application/json'
        },
        credentials: 'same-origin',
        body: JSON.stringify({ name: 'Test' })
      });
      expect(result).toEqual({ id: 123 });
    });
  });

  describe('upload()', () => {
    test('makes POST request with FormData', async () => {
      global.fetch.mockResolvedValue({
        ok: true,
        json: async () => ({ uploaded: true })
      });

      const formData = new FormData();
      formData.append('image', 'photo.jpg');

      const result = await APIClient.upload('/api/upload/', formData);

      expect(fetch).toHaveBeenCalledWith('/api/upload/', {
        method: 'POST',
        headers: { 'X-CSRFToken': 'test-csrf-token' },
        credentials: 'same-origin',
        body: formData
      });
      expect(result).toEqual({ uploaded: true });
    });
    
    test('throws error when not passed FormData', async () => {
      await expect(APIClient.upload('/api/upload/', { file: 'test' }))
        .rejects.toThrow('upload() requires FormData instance');
    });
  });
  
  describe('HTTP method shortcuts', () => {
    test('get() makes GET request', async () => {
      global.fetch.mockResolvedValue({
        ok: true,
        json: async () => ({ data: 'test' })
      });

      await APIClient.get('/api/data/', { page: 1 });

      expect(fetch).toHaveBeenCalledWith('/api/data/?page=1', expect.objectContaining({
        method: 'GET'
      }));
    });
    
    test('put() makes PUT request', async () => {
      global.fetch.mockResolvedValue({
        ok: true,
        json: async () => ({ updated: true })
      });

      await APIClient.put('/api/update/', { name: 'Updated' });

      expect(fetch).toHaveBeenCalledWith('/api/update/', expect.objectContaining({
        method: 'PUT'
      }));
    });
    
    test('patch() makes PATCH request', async () => {
      global.fetch.mockResolvedValue({
        ok: true,
        json: async () => ({ patched: true })
      });

      await APIClient.patch('/api/patch/', { field: 'value' });

      expect(fetch).toHaveBeenCalledWith('/api/patch/', expect.objectContaining({
        method: 'PATCH'
      }));
    });
    
    test('delete() makes DELETE request', async () => {
      global.fetch.mockResolvedValue({
        ok: true,
        json: async () => ({ deleted: true })
      });

      await APIClient.delete('/api/delete/');

      expect(fetch).toHaveBeenCalledWith('/api/delete/', expect.objectContaining({
        method: 'DELETE'
      }));
    });
  });
});
