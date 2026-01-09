/// Transaction form widget for Cosmo Management
///
/// Form dialog for logging inventory transactions.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../data/models/inventory_model.dart';
import '../providers/inventory_providers.dart';

/// Transaction form dialog
class TransactionFormDialog extends ConsumerStatefulWidget {
  final InventoryModel? item;
  final InventoryTransactionType? initialType;

  const TransactionFormDialog({
    super.key,
    this.item,
    this.initialType,
  });

  @override
  ConsumerState<TransactionFormDialog> createState() =>
      _TransactionFormDialogState();
}

class _TransactionFormDialogState extends ConsumerState<TransactionFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _notesController = TextEditingController();

  InventoryTransactionType _transactionType = InventoryTransactionType.stockIn;
  InventoryModel? _selectedItem;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.item;
    _transactionType = widget.initialType ?? InventoryTransactionType.stockIn;
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveTransaction() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedItem == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an inventory item')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final repository = ref.read(inventoryRepositoryProvider);
      final quantity = int.parse(_quantityController.text.trim());

      await repository.logTransaction(
        inventoryId: _selectedItem!.id,
        type: _transactionType,
        quantity: quantity,
        notes: _notesController.text.trim().isNotEmpty
            ? _notesController.text.trim()
            : null,
      );

      // Refresh inventory list
      ref.read(inventoryListProvider.notifier).loadInventory(refresh: true);

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction logged successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error logging transaction: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Log Transaction'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Item selector (if not pre-selected)
              if (widget.item == null) ...[
                Text(
                  'Inventory Item',
                  style: theme.textTheme.labelLarge,
                ),
                const SizedBox(height: AppSpacing.xs),
                _buildItemSelector(),
                const SizedBox(height: AppSpacing.md),
              ] else ...[
                // Show selected item
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedItem!.name,
                              style: theme.textTheme.titleSmall,
                            ),
                            Text(
                              'Current: ${_selectedItem!.quantityDisplay}',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],

              // Transaction type
              Text(
                'Transaction Type',
                style: theme.textTheme.labelLarge,
              ),
              const SizedBox(height: AppSpacing.xs),
              SegmentedButton<InventoryTransactionType>(
                segments: [
                  ButtonSegment(
                    value: InventoryTransactionType.stockIn,
                    label: const Text('Stock In'),
                    icon: const Icon(Icons.add, size: 18),
                  ),
                  ButtonSegment(
                    value: InventoryTransactionType.stockOut,
                    label: const Text('Stock Out'),
                    icon: const Icon(Icons.remove, size: 18),
                  ),
                ],
                selected: {_transactionType},
                onSelectionChanged: (selection) {
                  setState(() => _transactionType = selection.first);
                },
              ),
              const SizedBox(height: AppSpacing.xs),

              // More types in dropdown
              DropdownButtonFormField<InventoryTransactionType>(
                value: _transactionType,
                decoration: const InputDecoration(
                  labelText: 'Or select other type',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                items: InventoryTransactionType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Row(
                      children: [
                        Icon(
                          type.reducesStock
                              ? Icons.remove_circle_outline
                              : Icons.add_circle_outline,
                          size: 18,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(type.displayName),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _transactionType = value);
                  }
                },
              ),
              const SizedBox(height: AppSpacing.md),

              // Quantity
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(
                  labelText: 'Quantity *',
                  hintText: 'Enter quantity',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.numbers),
                  suffixText: _selectedItem?.unitType ?? 'units',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter quantity';
                  }
                  final qty = int.tryParse(value);
                  if (qty == null || qty <= 0) {
                    return 'Please enter a valid positive number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),

              // Notes
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (optional)',
                  hintText: 'Any additional notes...',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 2,
                textCapitalization: TextCapitalization.sentences,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _saveTransaction,
          child: _isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Log Transaction'),
        ),
      ],
    );
  }

  Widget _buildItemSelector() {
    return InkWell(
      onTap: () => _showItemPicker(),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              Icons.inventory_2_outlined,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                _selectedItem?.name ?? 'Select inventory item',
                style: _selectedItem != null
                    ? Theme.of(context).textTheme.bodyLarge
                    : Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  void _showItemPicker() {
    // TODO: Implement item picker dialog with search
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item picker coming soon')),
    );
  }
}
