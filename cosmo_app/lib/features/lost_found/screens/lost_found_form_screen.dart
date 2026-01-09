/// Lost & Found form screen for Cosmo Management
///
/// Screen for creating and editing lost/found items.
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/loading/loading_indicator.dart';
import '../../../data/models/lost_found_model.dart';
import '../providers/lost_found_providers.dart';

/// Lost & Found form screen
class LostFoundFormScreen extends ConsumerStatefulWidget {
  final int? itemId; // null for create, non-null for edit

  const LostFoundFormScreen({
    super.key,
    this.itemId,
  });

  @override
  ConsumerState<LostFoundFormScreen> createState() => _LostFoundFormScreenState();
}

class _LostFoundFormScreenState extends ConsumerState<LostFoundFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _storageController = TextEditingController();
  final _notesController = TextEditingController();

  LostFoundStatus _status = LostFoundStatus.found;
  LostFoundCategory _category = LostFoundCategory.other;
  DateTime? _dateFound;
  bool _isValuable = false;
  bool _isLoading = false;
  bool _isSaving = false;
  final List<XFile> _selectedPhotos = [];
  final _imagePicker = ImagePicker();

  bool get isEditing => widget.itemId != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _loadItem();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _storageController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadItem() async {
    setState(() => _isLoading = true);
    try {
      final item = await ref.read(lostFoundDetailProvider(widget.itemId!).future);
      _titleController.text = item.title;
      _descriptionController.text = item.description ?? '';
      _locationController.text = item.locationFound ?? item.locationDescription ?? '';
      _storageController.text = item.storageLocation ?? '';
      _notesController.text = item.notes ?? '';
      _status = item.status;
      _category = item.category;
      _dateFound = item.dateFound ?? item.dateLost;
      _isValuable = item.isValuable;
      setState(() {});
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading item: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveItem() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      final repository = ref.read(lostFoundRepositoryProvider);

      if (isEditing) {
        await repository.updateLostFoundItem(
          widget.itemId!,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim().isNotEmpty
              ? _descriptionController.text.trim()
              : null,
          status: _status,
          category: _category,
          locationFound: _locationController.text.trim().isNotEmpty
              ? _locationController.text.trim()
              : null,
          storageLocation: _storageController.text.trim().isNotEmpty
              ? _storageController.text.trim()
              : null,
          dateFound: _dateFound,
          isValuable: _isValuable,
          notes: _notesController.text.trim().isNotEmpty
              ? _notesController.text.trim()
              : null,
        );
      } else {
        await repository.createLostFoundItem(
          title: _titleController.text.trim(),
          status: _status,
          description: _descriptionController.text.trim().isNotEmpty
              ? _descriptionController.text.trim()
              : null,
          category: _category,
          locationFound: _locationController.text.trim().isNotEmpty
              ? _locationController.text.trim()
              : null,
          storageLocation: _storageController.text.trim().isNotEmpty
              ? _storageController.text.trim()
              : null,
          dateFound: _dateFound,
          isValuable: _isValuable,
          notes: _notesController.text.trim().isNotEmpty
              ? _notesController.text.trim()
              : null,
        );
      }

      // Refresh list
      ref.read(lostFoundListProvider.notifier).loadItems(refresh: true);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEditing ? 'Item updated' : 'Item created'),
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Item' : 'Report Item'),
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            TextButton(
              onPressed: _saveItem,
              child: const Text('Save'),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: LoadingIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.md),
                children: [
                  // Status toggle
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Item Status',
                            style: theme.textTheme.titleSmall,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          SegmentedButton<LostFoundStatus>(
                            segments: const [
                              ButtonSegment(
                                value: LostFoundStatus.found,
                                label: Text('Found'),
                                icon: Icon(Icons.find_in_page),
                              ),
                              ButtonSegment(
                                value: LostFoundStatus.lost,
                                label: Text('Lost'),
                                icon: Icon(Icons.search_off),
                              ),
                            ],
                            selected: {_status},
                            onSelectionChanged: (selection) {
                              setState(() => _status = selection.first);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Title
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title *',
                      hintText: 'Brief description of the item',
                      border: OutlineInputBorder(),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Category dropdown
                  DropdownButtonFormField<LostFoundCategory>(
                    value: _category,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: LostFoundCategory.values.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category.displayName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _category = value);
                      }
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Description
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText: 'Detailed description of the item',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Location
                  TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      labelText: _status == LostFoundStatus.found
                          ? 'Location Found'
                          : 'Last Known Location',
                      hintText: 'Where was it found/lost?',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.location_on_outlined),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Date picker
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.calendar_today),
                    title: Text(
                      _status == LostFoundStatus.found ? 'Date Found' : 'Date Lost',
                    ),
                    subtitle: Text(
                      _dateFound != null
                          ? '${_dateFound!.month}/${_dateFound!.day}/${_dateFound!.year}'
                          : 'Not specified',
                    ),
                    trailing: TextButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _dateFound ?? DateTime.now(),
                          firstDate: DateTime.now().subtract(const Duration(days: 365)),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          setState(() => _dateFound = date);
                        }
                      },
                      child: const Text('Select'),
                    ),
                  ),
                  const Divider(),

                  // Storage location (for found items)
                  if (_status == LostFoundStatus.found) ...[
                    TextFormField(
                      controller: _storageController,
                      decoration: const InputDecoration(
                        labelText: 'Storage Location',
                        hintText: 'Where is the item being kept?',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.inventory_2_outlined),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],

                  // Valuable toggle
                  SwitchListTile(
                    title: const Text('Valuable Item'),
                    subtitle: const Text('Mark as high-value for priority handling'),
                    value: _isValuable,
                    onChanged: (value) {
                      setState(() => _isValuable = value);
                    },
                    secondary: const Icon(Icons.diamond_outlined),
                  ),
                  const Divider(),

                  // Notes
                  TextFormField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      labelText: 'Notes',
                      hintText: 'Any additional notes...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Photo section
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.add_a_photo_outlined),
                          title: const Text('Add Photos'),
                          subtitle: Text(_selectedPhotos.isEmpty
                              ? 'Take or select photos of the item'
                              : '${_selectedPhotos.length} photo(s) selected'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: _showPhotoOptions,
                        ),
                        if (_selectedPhotos.isNotEmpty) ...[
                          const Divider(height: 1),
                          SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.all(AppSpacing.sm),
                              itemCount: _selectedPhotos.length,
                              itemBuilder: (context, index) {
                                final photo = _selectedPhotos[index];
                                return Padding(
                                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          File(photo.path),
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        top: 4,
                                        right: 4,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              _selectedPhotos.removeAt(index);
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: Colors.black54,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              size: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Save button
                  FilledButton.icon(
                    onPressed: _isSaving ? null : _saveItem,
                    icon: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.save),
                    label: Text(isEditing ? 'Update Item' : 'Report Item'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
    );
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            if (_selectedPhotos.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('Clear All Photos'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedPhotos.clear();
                  });
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      if (source == ImageSource.gallery) {
        // Allow multiple selection from gallery
        final List<XFile> images = await _imagePicker.pickMultiImage();
        if (images.isNotEmpty) {
          setState(() {
            _selectedPhotos.addAll(images);
          });
        }
      } else {
        // Single photo from camera
        final XFile? image = await _imagePicker.pickImage(source: source);
        if (image != null) {
          setState(() {
            _selectedPhotos.add(image);
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }
}
