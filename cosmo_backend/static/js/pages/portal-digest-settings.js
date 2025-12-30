function getCsrfToken() {
  return document.querySelector('[name="csrfmiddlewaretoken"]')?.value || '';
}

function showMessage(message, type) {
  const container = document.getElementById('messageContainer');
  const content = document.getElementById('messageContent');
  if (!container || !content) return;

  content.textContent = message;
  content.classList.remove('is-success', 'is-error');
  if (type === 'success') content.classList.add('is-success');
  if (type === 'error') content.classList.add('is-error');

  container.classList.remove('hidden');
  window.setTimeout(() => container.classList.add('hidden'), 4000);
}

function updateStatusDisplay() {
  window.setTimeout(() => {
    window.location.reload();
  }, 1500);
}

document.addEventListener('DOMContentLoaded', () => {
  const form = document.getElementById('digestSettingsForm');
  if (!form) return;

  const submitButton = form.querySelector('button[type="submit"]');

  form.addEventListener('submit', async (e) => {
    e.preventDefault();

    const csrfToken = getCsrfToken();
    const formData = new FormData(form);

    if (submitButton) submitButton.disabled = true;

    try {
      const response = await fetch('/api/digest/settings/', {
        method: 'POST',
        headers: {
          'X-CSRFToken': csrfToken,
        },
        body: formData,
      });

      const data = await response.json().catch(() => ({}));
      if (data.success) {
        showMessage(data.message || 'Settings updated successfully', 'success');
        updateStatusDisplay();
      } else {
        showMessage(data.error || 'Failed to update settings', 'error');
      }
    } catch (error) {
      showMessage('Network error occurred', 'error');
    } finally {
      if (submitButton) submitButton.disabled = false;
    }
  });
});
