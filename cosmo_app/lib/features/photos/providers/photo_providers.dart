/// Photo providers for Cosmo Management
///
/// Riverpod providers for photo upload and comparison state management.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/service_providers.dart';
import '../../../data/models/photo_model.dart';
import '../../../data/repositories/photo_repository.dart';
import 'photo_upload_notifier.dart';

/// Photo repository provider
final photoRepositoryProvider = Provider<PhotoRepository>((ref) {
  return PhotoRepository(
    apiService: ref.watch(apiServiceProvider),
    storageService: ref.watch(storageServiceProvider),
  );
});

/// Photo upload notifier provider
final photoUploadProvider =
    StateNotifierProvider<PhotoUploadNotifier, PhotoUploadState>((ref) {
  return PhotoUploadNotifier(ref.watch(photoRepositoryProvider));
});

/// Photo comparison provider (by task ID)
final photoComparisonProvider =
    FutureProvider.family<List<PhotoComparisonModel>, int>((ref, taskId) async {
  final repository = ref.watch(photoRepositoryProvider);
  return repository.getPhotoComparisons(taskId);
});

/// Task photos provider (by task ID)
final taskPhotosProvider =
    FutureProvider.family<List<PhotoModel>, int>((ref, taskId) async {
  final repository = ref.watch(photoRepositoryProvider);
  return repository.getPhotosByTask(taskId);
});

/// Pending uploads count provider
final pendingUploadsCountProvider = Provider<int>((ref) {
  final state = ref.watch(photoUploadProvider);
  if (state is PhotoUploadInProgress) {
    return state.items.where((item) => !item.isComplete).length;
  }
  return 0;
});

/// Is uploading provider
final isUploadingProvider = Provider<bool>((ref) {
  final state = ref.watch(photoUploadProvider);
  return state is PhotoUploadInProgress && state.isUploading;
});
