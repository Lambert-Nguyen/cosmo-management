/// Property list screen for Cosmo Management Portal
///
/// Displays list of owner's properties with search and responsive layout.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/responsive/responsive.dart';
import '../../../core/theme/app_spacing.dart';
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
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    // Trigger rebuild to update clear button visibility
    setState(() {});

    // Debounce the actual search
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      ref.read(propertyListProvider.notifier).search(_searchController.text);
    });
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
                      // Listener will handle the search call
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
      body: ResponsiveCenter(
        maxWidth: Breakpoints.maxContentWidth,
        child: switch (propertyState) {
          PropertyListInitial() ||
          PropertyListLoading() =>
            const PortalLoadingState(message: 'Loading properties...'),
          PropertyListError(message: final msg) => PortalErrorState(
              message: msg,
              onRetry: () => ref.read(propertyListProvider.notifier).refresh(),
            ),
          PropertyListLoaded(
            properties: final properties,
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
                    child: ScreenTypeBuilder(
                      builder: (context, screenType) {
                        final columns = screenType.gridColumns;
                        final padding = screenType.isExpanded
                            ? AppSpacing.lg
                            : AppSpacing.md;

                        if (columns == 1) {
                          // Single column list for mobile
                          return ListView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.all(padding),
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
                          );
                        }

                        // Grid layout for tablet/desktop
                        return GridView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.all(padding),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: columns,
                            mainAxisSpacing: AppSpacing.md,
                            crossAxisSpacing: AppSpacing.md,
                            childAspectRatio: 1.8,
                          ),
                          itemCount: properties.length + (hasMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == properties.length) {
                              return const Center(child: CircularProgressIndicator());
                            }

                            final property = properties[index];
                            return PropertyCard(
                              property: property,
                              onTap: () => context.push(
                                RouteNames.portalPropertyDetail(property.id),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
        },
      ),
    );
  }
}
