/**
 * Unit tests for StorageManager
 */

import { jest, describe, test, beforeEach, afterEach, expect } from '@jest/globals';
import { StorageManager } from '../../../aristay_backend/static/js/core/storage.js';

describe('StorageManager', () => {
  beforeEach(() => {
    localStorage.clear();
  });
  
  afterEach(() => {
    localStorage.clear();
  });
  
  describe('set()', () => {
    test('stores string value', () => {
      const result = StorageManager.set('test_key', 'test_value');
      expect(result).toBe(true);
      expect(localStorage.getItem('test_key')).toBe('"test_value"');
    });
    
    test('stores object value', () => {
      const obj = { name: 'John', age: 30 };
      const result = StorageManager.set('user', obj);
      expect(result).toBe(true);
      
      const stored = JSON.parse(localStorage.getItem('user'));
      expect(stored).toEqual(obj);
    });
    
    test('stores array value', () => {
      const arr = [1, 2, 3, 4, 5];
      const result = StorageManager.set('numbers', arr);
      expect(result).toBe(true);
      
      const stored = JSON.parse(localStorage.getItem('numbers'));
      expect(stored).toEqual(arr);
    });
    
    test('stores boolean value', () => {
      StorageManager.set('is_active', true);
      const stored = JSON.parse(localStorage.getItem('is_active'));
      expect(stored).toBe(true);
    });
    
    test('stores null value', () => {
      StorageManager.set('nullable', null);
      const stored = JSON.parse(localStorage.getItem('nullable'));
      expect(stored).toBe(null);
    });
    
    test('handles circular reference error', () => {
      const obj = { name: 'Test' };
      obj.self = obj; // Create circular reference
      
      const result = StorageManager.set('circular', obj);
      expect(result).toBe(false);
    });
    
    test('handles storage quota exceeded error', () => {
      // Mock setItem to throw QuotaExceededError
      const originalSetItem = Storage.prototype.setItem;
      Storage.prototype.setItem = jest.fn(() => {
        const error = new Error('QuotaExceededError');
        error.name = 'QuotaExceededError';
        throw error;
      });
      
      const result = StorageManager.set('large_data', 'x'.repeat(10000));
      expect(result).toBe(false);
      
      // Restore original
      Storage.prototype.setItem = originalSetItem;
    });
  });
  
  describe('get()', () => {
    test('retrieves stored value', () => {
      localStorage.setItem('test_key', JSON.stringify('test_value'));
      const value = StorageManager.get('test_key');
      expect(value).toBe('test_value');
    });
    
    test('retrieves object', () => {
      const obj = { name: 'Jane', role: 'admin' };
      localStorage.setItem('user', JSON.stringify(obj));
      
      const retrieved = StorageManager.get('user');
      expect(retrieved).toEqual(obj);
    });
    
    test('returns default value for non-existent key', () => {
      const defaultValue = { theme: 'light' };
      const value = StorageManager.get('preferences', defaultValue);
      expect(value).toEqual(defaultValue);
    });
    
    test('returns null by default for non-existent key', () => {
      const value = StorageManager.get('nonexistent');
      expect(value).toBe(null);
    });
    
    test('handles invalid JSON and returns default', () => {
      localStorage.setItem('invalid_json', 'not valid json {]');
      const value = StorageManager.get('invalid_json', 'fallback');
      expect(value).toBe('fallback');
    });
    
    test('handles corrupted data gracefully', () => {
      localStorage.setItem('corrupted', 'undefined');
      const value = StorageManager.get('corrupted', null);
      // Should return default on parse error
      expect(value).toBe(null);
    });
  });
  
  describe('remove()', () => {
    test('removes stored value', () => {
      localStorage.setItem('test_key', '"test_value"');
      const result = StorageManager.remove('test_key');
      
      expect(result).toBe(true);
      expect(localStorage.getItem('test_key')).toBe(null);
    });
    
    test('returns true even if key does not exist', () => {
      const result = StorageManager.remove('nonexistent');
      expect(result).toBe(true);
    });
    
    test('handles removeItem error gracefully', () => {
      const originalRemoveItem = Storage.prototype.removeItem;
      Storage.prototype.removeItem = jest.fn(() => {
        throw new Error('Storage access denied');
      });
      
      const result = StorageManager.remove('test_key');
      expect(result).toBe(false);
      
      Storage.prototype.removeItem = originalRemoveItem;
    });
  });
  
  describe('clear()', () => {
    test('clears all storage', () => {
      StorageManager.set('key1', 'value1');
      StorageManager.set('key2', 'value2');
      StorageManager.set('key3', 'value3');
      
      const result = StorageManager.clear();
      expect(result).toBe(true);
      expect(localStorage.length).toBe(0);
    });
    
    test('handles clear error gracefully', () => {
      const originalClear = Storage.prototype.clear;
      Storage.prototype.clear = jest.fn(() => {
        throw new Error('Storage access denied');
      });
      
      const result = StorageManager.clear();
      expect(result).toBe(false);
      
      Storage.prototype.clear = originalClear;
    });
  });
  
  describe('has()', () => {
    test('returns true for existing key', () => {
      StorageManager.set('existing', 'value');
      expect(StorageManager.has('existing')).toBe(true);
    });
    
    test('returns false for non-existent key', () => {
      expect(StorageManager.has('nonexistent')).toBe(false);
    });
  });
  
  describe('keys()', () => {
    test('returns array of all keys', () => {
      StorageManager.set('key1', 'value1');
      StorageManager.set('key2', 'value2');
      StorageManager.set('key3', 'value3');
      
      const keys = StorageManager.keys();
      expect(keys).toEqual(['key1', 'key2', 'key3']);
    });
    
    test('returns empty array when storage is empty', () => {
      const keys = StorageManager.keys();
      expect(keys).toEqual([]);
    });
    
    test('handles error by throwing from localStorage access', () => {
      // Mock localStorage to throw error when accessed
      const originalLocalStorage = global.localStorage;
      Object.defineProperty(global, 'localStorage', {
        get: () => {
          throw new Error('Cannot access storage');
        },
        configurable: true
      });
      
      const keys = StorageManager.keys();
      expect(keys).toEqual([]);
      
      // Restore
      Object.defineProperty(global, 'localStorage', {
        value: originalLocalStorage,
        configurable: true,
        writable: true
      });
    });
  });
  
  describe('size()', () => {
    test('returns approximate storage size', () => {
      StorageManager.set('small', 'x');
      const size = StorageManager.size();
      expect(size).toBeGreaterThan(0);
    });
    
    test('returns 0 for empty storage', () => {
      const size = StorageManager.size();
      expect(size).toBe(0);
    });
    
    test('handles error by throwing from localStorage access', () => {
      const originalLocalStorage = global.localStorage;
      Object.defineProperty(global, 'localStorage', {
        get: () => {
          throw new Error('Cannot access storage');
        },
        configurable: true
      });
      
      const size = StorageManager.size();
      expect(size).toBe(0);
      
      // Restore
      Object.defineProperty(global, 'localStorage', {
        value: originalLocalStorage,
        configurable: true,
        writable: true
      });
    });
  });
});
