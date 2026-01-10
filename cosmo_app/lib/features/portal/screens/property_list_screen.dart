/// Property list screen for Cosmo Management Portal
///
/// Displays list of owner's properties with search functionality.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../data/models/property_model.dart';
import '../../../router/route_names.dart';
import '../providers/portal_providers.dart';
import '../widgets/property_card.dart';
import 'portal_shell.dart';

/// Property list screen
///
/// Shows all properties owned by the portal user with search and filter.
class PropertyListScreen extends ConsumerStatefulWidget {
  const PropertyListScreen({super.key});

  @override
  ConsumerState<PropertyListScreen> createState() => _PropertyListScreenState();
}

class _PropertyListScreenState extends ConsumerState<PropertyListScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(propertyListProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final propertyState = ref.watch(propertyListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Properties'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Search properties...',
              leading: const Icon(Icons.search),
              trailing: [
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      ref.read(propertyListProvider.notifier).search('');
                    },
                  ),
              ],
              onChanged: (value) {
                ref.read(propertyListProvider.notifier).search(value);
              },
            ),
          ),
        ),
      ),
      body: switch (propertyState) {
        PropertyListInitial() ||
        PropertyListLoading() =>
          const PortalLoadingState(message: 'Loading properties...'),
        PropertyListError(message: final msg) => PortalErrorState(
            message: msg,
            onRetry: () => ref.read(propertyListProvider.notifier).refresh(),
          ),
        PropertyListLoaded(
          properties: final properties,
          totalCount: final totalCount,
          hasMore: final hasMore,
        ) =>
          properties.isEmpty
              ? PortalEmptyState(
                  icon: Icons.home_work_outlined,
                  title: 'No properties found',
                  subtitle: _searchController.text.isNotEmpty
                      ? 'Try a different search term'
                      : 'You have no properties assigned to your account',
                )
              : RefreshIndicator(
                  onRefresh: () =>
                      ref.read(propertyListProvider.notifier).refresh(),
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: properties.length + (hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == properties.length) {
                        return const Padding(
                          padding: EdgeInsets.all(AppSpacing.md),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final property = properties[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: PropertyCard(
                          property: property,
                          onTap: () => context.push(
                            RouteNames.portalPropertyDetail(property.id),
                          ),
                        ),
                      );
                    },
                  ),
                ),
      },
    );
  }
}
