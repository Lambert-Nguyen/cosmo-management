import { PropertyAutocomplete } from '../modules/property-autocomplete.js';

function initializeForm() {
  const dueDateField = document.getElementById('id_due_date');
  if (dueDateField && !dueDateField.value && window.location.pathname.includes('/create/')) {
    const tomorrow = new Date();
    tomorrow.setDate(tomorrow.getDate() + 1);
    tomorrow.setHours(9, 0, 0, 0);

    const localDateTime = tomorrow.toISOString().slice(0, 16);
    dueDateField.value = localDateTime;
  }

  initializeTooltips();
}

function initializeTooltips() {
  const helpTexts = document.querySelectorAll('.form-help');
  helpTexts.forEach((help) => {
    help.setAttribute('title', help.textContent ?? '');
  });
}

function clearFieldError(fieldOrEvent) {
  const field = fieldOrEvent?.target ?? fieldOrEvent;
  if (!field || !field.parentNode) return;

  const errorElement = field.parentNode.querySelector('.error');
  if (errorElement) errorElement.remove();
  field.classList.remove('error');
}

function showFieldError(field, message) {
  clearFieldError(field);

  const errorElement = document.createElement('span');
  errorElement.className = 'error';
  errorElement.textContent = message;

  field.parentNode.appendChild(errorElement);
  field.classList.add('error');
}

function clearAllErrors() {
  document.querySelectorAll('.error').forEach((error) => error.remove());
  document
    .querySelectorAll('.form-group input, .form-group select, .form-group textarea')
    .forEach((field) => {
      field.classList.remove('error');
    });
}

function validateField(e) {
  const field = e.target;
  const label = document.querySelector(`label[for="${field.id}"]`);

  if (label && label.classList.contains('required') && !field.value.trim()) {
    showFieldError(field, 'This field is required');
  } else {
    clearFieldError(field);
  }
}

function validateForm() {
  let isValid = true;
  const form = document.querySelector('.task-form');
  if (!form) return true;

  clearAllErrors();

  const requiredFields = form.querySelectorAll('.form-label.required');
  requiredFields.forEach((label) => {
    const field = form.querySelector(`#${label.getAttribute('for')}`);
    if (field && !field.value.trim()) {
      showFieldError(field, 'This field is required');
      isValid = false;
    }
  });

  const dueDateField = document.getElementById('id_due_date');
  if (dueDateField && dueDateField.value) {
    const dueDate = new Date(dueDateField.value);
    const now = new Date();

    if (dueDate < now) {
      showFieldError(dueDateField, 'Due date cannot be in the past');
      isValid = false;
    }
  }

  return isValid;
}

function showLoadingState() {
  const submitButton = document.querySelector('button[type="submit"]');
  if (submitButton) {
    submitButton.disabled = true;
    submitButton.innerHTML = '⏳ Saving...';
  }

  document.querySelectorAll('.form-group').forEach((group) => {
    group.classList.add('loading');
  });
}

function setupFormValidation() {
  const form = document.querySelector('.task-form');
  if (!form) return;

  form.addEventListener('submit', (e) => {
    if (!validateForm()) {
      e.preventDefault();
      return;
    }

    showLoadingState();
  });

  const requiredFields = form.querySelectorAll('.form-label.required');
  requiredFields.forEach((label) => {
    const field = form.querySelector(`#${label.getAttribute('for')}`);
    if (!field) return;

    field.addEventListener('blur', validateField);
    field.addEventListener('input', clearFieldError);
  });
}

function setupAutoSave() {
  const form = document.querySelector('.task-form');
  if (!form) return;

  const formData = {};

  const savedData = localStorage.getItem('taskFormData');
  if (savedData) {
    try {
      const parsed = JSON.parse(savedData);
      Object.keys(parsed).forEach((key) => {
        const field = form.querySelector(`[name="${key}"]`);
        if (field && !field.value) {
          field.value = parsed[key];
        }
      });
    } catch (e) {
      console.error('Error loading saved form data:', e);
    }
  }

  form.addEventListener('input', (e) => {
    if (e.target?.name) {
      formData[e.target.name] = e.target.value;
      localStorage.setItem('taskFormData', JSON.stringify(formData));
    }
  });

  form.addEventListener('submit', () => {
    localStorage.removeItem('taskFormData');
  });
}

function setupConfirmations() {
  document.addEventListener('click', (e) => {
    const trigger = e.target.closest('[data-confirm]');
    if (!trigger) return;

    const message = trigger.getAttribute('data-confirm');
    if (message && !window.confirm(message)) {
      e.preventDefault();
      e.stopPropagation();
    }
  });

  document.querySelectorAll('form[data-confirm]').forEach((form) => {
    form.addEventListener('submit', (e) => {
      const message = form.getAttribute('data-confirm');
      if (message && !window.confirm(message)) {
        e.preventDefault();
        e.stopPropagation();
      }
    });
  });
}

function setupKeyboardShortcuts() {
  document.addEventListener('keydown', (e) => {
    if ((e.ctrlKey || e.metaKey) && e.key === 's') {
      e.preventDefault();
      const form = document.querySelector('.task-form');
      if (form) form.submit();
    }

    if (e.key === 'Escape') {
      window.location.href = '/api/staff/tasks/';
    }
  });
}

function setupPropertyAutocomplete() {
  const propertySelect = document.querySelector('#id_property_ref');
  if (!propertySelect) return;

  propertySelect.setAttribute('data-property-autocomplete', '');

  new PropertyAutocomplete(propertySelect, {
    searchUrl: '/api/properties/search/',
    minChars: 0,
    debounceMs: 300,
    pageSize: 20,
  });
}

window.addEventListener('DOMContentLoaded', () => {
  initializeForm();
  setupConfirmations();
  setupFormValidation();
  setupAutoSave();
  setupKeyboardShortcuts();
  setupPropertyAutocomplete();
});
