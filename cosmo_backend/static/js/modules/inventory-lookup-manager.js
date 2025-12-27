/**
 * Inventory Lookup - quick transaction behavior (no inline JS)
 */

import { APIClient, APIError } from '../core/api-client.js';

export class InventoryLookupManager {
  constructor() {
    this.bindEvents();
  }

  bindEvents() {
    document.addEventListener('click', (event) => {
      const button = event.target.closest('.log-transaction');
      if (!button) return;

      event.preventDefault();

      const container = button.closest('.inventory-item');
      if (!container) return;

      this.handleLogTransaction(container, button);
    });
  }

  async handleLogTransaction(container, button) {
    const inventoryId = container.getAttribute('data-inventory-id');
    const unit = container.getAttribute('data-unit') || '';

    const typeEl = container.querySelector('.transaction-type');
    const qtyEl = container.querySelector('.transaction-quantity');
    const notesEl = container.querySelector('.transaction-notes');

    const transactionType = typeEl ? typeEl.value : 'stock_out';
    const quantityRaw = qtyEl ? qtyEl.value : '';
    const notes = notesEl ? notesEl.value : '';

    const quantity = Number.parseFloat(quantityRaw);

    if (!inventoryId) {
      window.alert('Missing inventory id.');
      return;
    }

    if (!Number.isFinite(quantity) || quantity <= 0) {
      window.alert('Please enter a valid quantity');
      return;
    }

    const originalLabel = button.textContent;
    button.disabled = true;
    button.textContent = '…';

    try {
      const data = await APIClient.post('/api/staff/inventory/transaction/', {
        inventory_id: Number.parseInt(inventoryId, 10),
        transaction_type: transactionType,
        quantity,
        notes,
      });

      if (!data || !data.success) {
        window.alert(`Error: ${data?.error || 'Unknown error'}`);
        return;
      }

      const stockBadge = container.querySelector('.inventory-stock-badge') || container.querySelector('.status-badge');
      if (stockBadge) {
        const statusClass = `status-${String(data.status || '').replaceAll('_', '')}`;
        stockBadge.className = `status-badge ${statusClass} inventory-stock-badge`;
        stockBadge.textContent = `${data.new_stock} ${unit}`.trim();
      }

      if (qtyEl) qtyEl.value = '';
      if (notesEl) notesEl.value = '';

      window.alert('Transaction logged successfully!');
    } catch (error) {
      if (error instanceof APIError) {
        window.alert(`Error: ${error.message}`);
      } else {
        // eslint-disable-next-line no-console
        console.error('Error logging transaction:', error);
        window.alert('Error logging transaction. Please try again.');
      }
    } finally {
      button.disabled = false;
      button.textContent = originalLabel;
    }
  }
}
