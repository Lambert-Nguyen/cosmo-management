/// App router configuration for Cosmo Management
///
/// Uses GoRouter for declarative routing with auth guards.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/providers/auth_notifier.dart';
import '../core/providers/service_providers.dart';
import '../core/services/auth_service.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/widgets/buttons/primary_button.dart';
import '../core/widgets/inputs/app_text_field.dart';
import '../features/auth/screens/forgot_password_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/auth/screens/splash_screen.dart';
import '../features/inventory/screens/inventory_alerts_screen.dart';
import '../features/inventory/screens/inventory_detail_screen.dart';
import '../features/inventory/screens/inventory_screen.dart';
import '../features/lost_found/screens/lost_found_form_screen.dart';
import '../features/lost_found/screens/lost_found_list_screen.dart';
import '../features/photos/screens/photo_comparison_screen.dart';
import '../features/photos/screens/photo_upload_screen.dart';
import '../features/portal/screens/booking_detail_screen.dart';
import '../features/portal/screens/booking_list_screen.dart';
import '../features/portal/screens/calendar_screen.dart';
import '../features/portal/screens/photo_gallery_screen.dart';
import '../features/portal/screens/portal_dashboard_screen.dart';
import '../features/portal/screens/portal_shell.dart';
import '../features/portal/screens/property_detail_screen.dart';
import '../features/portal/screens/property_list_screen.dart';
import '../features/staff/screens/staff_dashboard_screen.dart';
import '../features/staff/screens/staff_shell.dart';
import '../features/staff/screens/sync_conflicts_screen.dart';
import '../features/staff/screens/task_detail_screen.dart';
import '../features/staff/screens/task_form_screen.dart';
import '../features/staff/screens/task_list_screen.dart';
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
        path == RouteNames.register ||
        path == RouteNames.forgotPassword ||
        path == RouteNames.resetPassword;
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
          path: RouteNames.register,
          name: 'register',
          builder: (context, state) {
            // Support deep link with invite code
            final inviteCode = state.uri.queryParameters['code'];
            return RegisterScreen(initialInviteCode: inviteCode);
          },
        ),
        GoRoute(
          path: RouteNames.forgotPassword,
          name: 'forgotPassword',
          builder: (context, state) => const ForgotPasswordScreen(),
        ),
        GoRoute(
          path: RouteNames.resetPassword,
          name: 'resetPassword',
          builder: (context, state) {
            // Support deep link with token and uid
            final token = state.uri.queryParameters['token'];
            final uid = state.uri.queryParameters['uid'];
            return _ResetPasswordScreen(token: token, uid: uid);
          },
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

        // Sync conflicts (outside shell for full screen)
        GoRoute(
          path: RouteNames.syncConflicts,
          name: 'syncConflicts',
          builder: (context, state) => const SyncConflictsScreen(),
        ),

        // Staff routes with bottom navigation shell
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return StaffShell(navigationShell: navigationShell);
          },
          branches: [
            // Dashboard branch
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RouteNames.staffDashboard,
                  name: 'staffDashboard',
                  builder: (context, state) => const StaffDashboardScreen(),
                ),
              ],
            ),
            // Tasks branch
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RouteNames.staffTaskList,
                  name: 'staffTaskList',
                  builder: (context, state) {
                    final status = state.uri.queryParameters['status'];
                    return TaskListScreen(initialStatus: status);
                  },
                  routes: [
                    // Task create
                    GoRoute(
                      path: 'create',
                      name: 'staffTaskCreate',
                      builder: (context, state) => const TaskFormScreen(),
                    ),
                    // Task detail
                    GoRoute(
                      path: ':id',
                      name: 'staffTaskDetail',
                      builder: (context, state) {
                        final id = int.parse(state.pathParameters['id']!);
                        return TaskDetailScreen(taskId: id);
                      },
                      routes: [
                        // Task edit
                        GoRoute(
                          path: 'edit',
                          name: 'staffTaskEdit',
                          builder: (context, state) {
                            final id = int.parse(state.pathParameters['id']!);
                            return TaskFormScreen(taskId: id);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            // Inventory branch
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RouteNames.staffInventory,
                  name: 'staffInventory',
                  builder: (context, state) => const InventoryScreen(),
                  routes: [
                    // Inventory alerts
                    GoRoute(
                      path: 'alerts',
                      name: 'staffInventoryAlerts',
                      builder: (context, state) => const InventoryAlertsScreen(),
                    ),
                    // Inventory detail
                    GoRoute(
                      path: ':id',
                      name: 'staffInventoryDetail',
                      builder: (context, state) {
                        final id = int.parse(state.pathParameters['id']!);
                        return InventoryDetailScreen(inventoryId: id);
                      },
                    ),
                  ],
                ),
              ],
            ),
            // Lost & Found branch
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RouteNames.staffLostFound,
                  name: 'staffLostFound',
                  builder: (context, state) => const LostFoundListScreen(),
                  routes: [
                    // Create lost/found item
                    GoRoute(
                      path: 'create',
                      name: 'staffLostFoundCreate',
                      builder: (context, state) => const LostFoundFormScreen(),
                    ),
                    // Lost/found detail/edit
                    GoRoute(
                      path: ':id',
                      name: 'staffLostFoundDetail',
                      builder: (context, state) {
                        final id = int.parse(state.pathParameters['id']!);
                        return LostFoundFormScreen(itemId: id);
                      },
                    ),
                  ],
                ),
              ],
            ),
            // Schedule branch
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RouteNames.staffSchedule,
                  name: 'staffSchedule',
                  builder: (context, state) => const _PlaceholderScreen(
                    title: 'Schedule',
                  ),
                ),
              ],
            ),
            // Profile branch
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RouteNames.staffProfile,
                  name: 'staffProfile',
                  builder: (context, state) => const _PlaceholderScreen(
                    title: 'Staff Profile',
                  ),
                ),
              ],
            ),
          ],
        ),

        // Photo routes (standalone, accessible from multiple places)
        GoRoute(
          path: RouteNames.staffPhotoUpload,
          name: 'staffPhotoUpload',
          builder: (context, state) {
            final entityType = state.uri.queryParameters['entityType'];
            final entityIdStr = state.uri.queryParameters['entityId'];
            final entityId = entityIdStr != null ? int.tryParse(entityIdStr) : null;
            return PhotoUploadScreen(
              entityType: entityType,
              entityId: entityId,
            );
          },
        ),
        GoRoute(
          path: '/staff/photos/comparison/:taskId',
          name: 'staffPhotoComparison',
          builder: (context, state) {
            final taskId = int.parse(state.pathParameters['taskId']!);
            final taskTitle = state.uri.queryParameters['title'];
            return PhotoComparisonScreen(
              taskId: taskId,
              taskTitle: taskTitle,
            );
          },
        ),

        // Portal routes with bottom navigation shell
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return PortalShell(navigationShell: navigationShell);
          },
          branches: [
            // Dashboard branch
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RouteNames.portalDashboard,
                  name: 'portalDashboard',
                  builder: (context, state) => const PortalDashboardScreen(),
                ),
              ],
            ),
            // Properties branch
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RouteNames.portalProperties,
                  name: 'portalProperties',
                  builder: (context, state) => const PropertyListScreen(),
                  routes: [
                    // Property detail
                    GoRoute(
                      path: ':id',
                      name: 'portalPropertyDetail',
                      builder: (context, state) {
                        final id = int.parse(state.pathParameters['id']!);
                        return PropertyDetailScreen(propertyId: id);
                      },
                    ),
                  ],
                ),
              ],
            ),
            // Calendar branch
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RouteNames.portalCalendar,
                  name: 'portalCalendar',
                  builder: (context, state) => const CalendarScreen(),
                ),
              ],
            ),
            // Bookings branch
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RouteNames.portalBookings,
                  name: 'portalBookings',
                  builder: (context, state) => const BookingListScreen(),
                  routes: [
                    // Booking detail
                    GoRoute(
                      path: ':id',
                      name: 'portalBookingDetail',
                      builder: (context, state) {
                        final id = int.parse(state.pathParameters['id']!);
                        return BookingDetailScreen(bookingId: id);
                      },
                    ),
                  ],
                ),
              ],
            ),
            // Photos branch
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RouteNames.portalPhotos,
                  name: 'portalPhotos',
                  builder: (context, state) => const PhotoGalleryScreen(),
                ),
              ],
            ),
          ],
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

/// Reset password screen for confirming password reset from email link
class _ResetPasswordScreen extends ConsumerStatefulWidget {
  final String? token;
  final String? uid;

  const _ResetPasswordScreen({this.token, this.uid});

  @override
  ConsumerState<_ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<_ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _resetComplete = false;

  @override
  void initState() {
    super.initState();
    // Validate that we have required parameters
    if (widget.token == null || widget.uid == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showInvalidLinkError();
      });
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showInvalidLinkError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Invalid password reset link'),
        backgroundColor: AppColors.error,
      ),
    );
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain an uppercase letter';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain a lowercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain a number';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (widget.token == null || widget.uid == null) {
      _showInvalidLinkError();
      return;
    }

    await ref.read(authNotifierProvider.notifier).confirmPasswordReset(
          token: widget.token!,
          uid: widget.uid!,
          newPassword: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);

    // Listen for auth state changes
    ref.listen<AuthNotifierState>(authNotifierProvider, (previous, next) {
      if (next is PasswordResetComplete) {
        setState(() => _resetComplete = true);
      }
    });

    final isLoading = authState is AuthLoading;
    final loadingMessage =
        authState is AuthLoading ? authState.message : null;
    final errorMessage = authState is AuthError ? authState.message : null;

    // Check for missing parameters
    if (widget.token == null || widget.uid == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Reset Password')),
        body: Center(
          child: Padding(
            padding: AppSpacing.screen,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppColors.error,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Invalid Reset Link',
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'This password reset link is invalid or has expired.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xl),
                PrimaryButton(
                  label: 'Request New Link',
                  onPressed: () => context.go(RouteNames.forgotPassword),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: isLoading ? null : () => context.go(RouteNames.login),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: AppSpacing.screen,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _resetComplete
                    ? _buildSuccessState(theme)
                    : _buildResetForm(
                        theme, isLoading, loadingMessage, errorMessage),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResetForm(
    ThemeData theme,
    bool isLoading,
    String? loadingMessage,
    String? errorMessage,
  ) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Icon and title
          Icon(
            Icons.lock_reset,
            size: 64,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Create New Password',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Enter your new password below.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xxl),

          // Error message
          if (errorMessage != null) ...[
            Container(
              padding: AppSpacing.allMd,
              decoration: BoxDecoration(
                color: AppColors.errorContainer,
                borderRadius: AppSpacing.borderRadiusSm,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: AppColors.error,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      errorMessage,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],

          // Loading message
          if (isLoading && loadingMessage != null) ...[
            Container(
              padding: AppSpacing.allMd,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: AppSpacing.borderRadiusSm,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      loadingMessage,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],

          // Password field
          PasswordTextField(
            controller: _passwordController,
            label: 'New Password',
            hint: 'Create a strong password',
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.newPassword],
            validator: _validatePassword,
            isRequired: true,
            enabled: !isLoading,
          ),
          const SizedBox(height: AppSpacing.md),

          // Confirm password field
          PasswordTextField(
            controller: _confirmPasswordController,
            label: 'Confirm Password',
            hint: 'Re-enter your password',
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.newPassword],
            validator: _validateConfirmPassword,
            isRequired: true,
            onSubmitted: (_) => _handleSubmit(),
            enabled: !isLoading,
          ),
          const SizedBox(height: AppSpacing.xl),

          // Submit button
          PrimaryButton(
            label: 'Reset Password',
            onPressed: isLoading ? null : _handleSubmit,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Success icon
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.successContainer,
          ),
          child: const Icon(
            Icons.check_circle_outline,
            size: 40,
            color: AppColors.success,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Title
        Text(
          'Password Reset!',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),

        // Description
        Text(
          'Your password has been successfully reset. You can now sign in with your new password.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xl),

        // Sign in button
        PrimaryButton(
          label: 'Sign In',
          onPressed: () => context.go(RouteNames.login),
        ),
      ],
    );
  }
}
