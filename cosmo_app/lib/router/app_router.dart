/// App router configuration for Cosmo Management
///
/// Uses GoRouter for declarative routing with auth guards.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/services/auth_service.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/splash_screen.dart';
import 'route_names.dart';

/// App router configuration
///
/// Provides:
/// - Route definitions for all screens
/// - Auth-based route guards
/// - Deep linking support
class AppRouter {
  final AuthService _authService;

  late final GoRouter router;

  AppRouter({required AuthService authService}) : _authService = authService {
    router = GoRouter(
      initialLocation: RouteNames.splash,
      debugLogDiagnostics: true,
      refreshListenable: GoRouterRefreshStream(_authService.authStateChanges),
      redirect: _handleRedirect,
      routes: _routes,
      errorBuilder: _errorBuilder,
    );
  }

  /// Handle auth-based redirects
  String? _handleRedirect(BuildContext context, GoRouterState state) {
    final authState = _authService.currentState;
    final currentPath = state.matchedLocation;

    // Still checking auth state
    if (authState == AuthState.unknown) {
      // Only redirect to splash if not already there
      if (currentPath != RouteNames.splash) {
        return RouteNames.splash;
      }
      return null;
    }

    final isAuthenticated = authState == AuthState.authenticated;
    final isAuthRoute = _isAuthRoute(currentPath);

    // If authenticated and trying to access auth routes, go to home
    if (isAuthenticated && isAuthRoute) {
      return RouteNames.home;
    }

    // If not authenticated and trying to access protected routes, go to login
    if (!isAuthenticated && !isAuthRoute) {
      return RouteNames.login;
    }

    return null;
  }

  /// Check if route is an auth route (doesn't require authentication)
  bool _isAuthRoute(String path) {
    return path == RouteNames.splash ||
        path == RouteNames.login ||
        path == RouteNames.forgotPassword;
  }

  /// Route definitions
  List<RouteBase> get _routes => [
        // Splash screen
        GoRoute(
          path: RouteNames.splash,
          name: 'splash',
          builder: (context, state) => const SplashScreen(),
        ),

        // Auth routes
        GoRoute(
          path: RouteNames.login,
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: RouteNames.forgotPassword,
          name: 'forgotPassword',
          builder: (context, state) => const _PlaceholderScreen(
            title: 'Forgot Password',
          ),
        ),

        // Main app routes (protected)
        GoRoute(
          path: RouteNames.home,
          name: 'home',
          builder: (context, state) => const _PlaceholderScreen(
            title: 'Home',
            showLogout: true,
          ),
          routes: [
            // Nested routes can go here
          ],
        ),

        // Tasks
        GoRoute(
          path: RouteNames.tasks,
          name: 'tasks',
          builder: (context, state) => const _PlaceholderScreen(
            title: 'Tasks',
          ),
          routes: [
            GoRoute(
              path: ':id',
              name: 'taskDetail',
              builder: (context, state) {
                final id = state.pathParameters['id']!;
                return _PlaceholderScreen(title: 'Task #$id');
              },
            ),
          ],
        ),

        // Properties
        GoRoute(
          path: RouteNames.properties,
          name: 'properties',
          builder: (context, state) => const _PlaceholderScreen(
            title: 'Properties',
          ),
        ),

        // Notifications
        GoRoute(
          path: RouteNames.notifications,
          name: 'notifications',
          builder: (context, state) => const _PlaceholderScreen(
            title: 'Notifications',
          ),
        ),

        // Settings
        GoRoute(
          path: RouteNames.settings,
          name: 'settings',
          builder: (context, state) => const _PlaceholderScreen(
            title: 'Settings',
          ),
        ),

        // Profile
        GoRoute(
          path: RouteNames.profile,
          name: 'profile',
          builder: (context, state) => const _PlaceholderScreen(
            title: 'Profile',
          ),
        ),
      ];

  /// Error page builder
  Widget _errorBuilder(BuildContext context, GoRouterState state) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64),
            const SizedBox(height: 16),
            Text('Route not found: ${state.matchedLocation}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(RouteNames.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper class to convert Stream to Listenable for GoRouter refresh
///
/// Properly manages the stream subscription to prevent memory leaks.
class GoRouterRefreshStream extends ChangeNotifier {
  late final Stream<dynamic> _stream;
  Object? _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) : _stream = stream {
    _subscription = _stream.listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    (_subscription as dynamic)?.cancel();
    super.dispose();
  }
}

/// Placeholder screen for routes not yet implemented
class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final bool showLogout;

  const _PlaceholderScreen({
    required this.title,
    this.showLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: showLogout
            ? [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    // Logout will be handled through provider
                    context.go(RouteNames.login);
                  },
                ),
              ]
            : null,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.construction,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Coming in Phase 3',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
