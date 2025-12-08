/**
 * Unit Tests: API Client
 * Tests the APIClient utility for HTTP requests
 */

import { jest, describe, test, beforeEach, afterEach, expect } from '@jest/globals';
import { APIClient } from '../../../aristay_backend/static/js/core/api-client.js';
import { CSRFManager } from '../../../aristay_backend/static/js/core/csrf.js';

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
  });
});
