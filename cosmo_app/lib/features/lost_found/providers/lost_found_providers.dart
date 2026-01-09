/// Lost & Found providers for Cosmo Management
///
/// Riverpod providers for lost & found state management.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/service_providers.dart';
import '../../../data/models/lost_found_model.dart';
import '../../../data/repositories/lost_found_repository.dart';
import 'lost_found_list_notifier.dart';

/// Lost & Found repository provider
final lostFoundRepositoryProvider = Provider<LostFoundRepository>((ref) {
  return LostFoundRepository(
    apiService: ref.watch(apiServiceProvider),
    storageService: ref.watch(storageServiceProvider),
  );
});

/// Lost & Found list provider
final lostFoundListProvider =
    StateNotifierProvider<LostFoundListNotifier, LostFoundListState>((ref) {
  return LostFoundListNotifier(ref.watch(lostFoundRepositoryProvider));
});

/// Lost & Found filter state provider
final lostFoundFilterProvider = Provider<LostFoundFilter>((ref) {
  final state = ref.watch(lostFoundListProvider);
  return switch (state) {
    LostFoundListLoaded(filter: final filter) => filter,
    _ => const LostFoundFilter(),
  };
});

/// Lost & Found detail provider (by ID)
final lostFoundDetailProvider =
    FutureProvider.family<LostFoundModel, int>((ref, id) async {
  final repository = ref.watch(lostFoundRepositoryProvider);
  return repository.getLostFoundById(id);
});

/// Lost & Found stats provider
final lostFoundStatsProvider = FutureProvider<LostFoundStatsModel>((ref) async {
  final repository = ref.watch(lostFoundRepositoryProvider);
  return repository.getStats();
});

/// Active items count provider
final activeLostFoundCountProvider = Provider<int>((ref) {
  final stats = ref.watch(lostFoundStatsProvider);
  return stats.maybeWhen(
    data: (data) => data.totalActive,
    orElse: () => 0,
  );
});

/// Items needing attention provider
final lostFoundNeedsAttentionProvider = FutureProvider<List<LostFoundModel>>((ref) async {
  final repository = ref.watch(lostFoundRepositoryProvider);
  final items = await repository.getLostFoundItems();
  return items.results.where((item) => item.needsAttention).toList();
});
