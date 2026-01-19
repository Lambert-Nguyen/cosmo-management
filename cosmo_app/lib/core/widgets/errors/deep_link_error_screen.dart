/// Deep link error screen for handling navigation errors
///
/// Provides user-friendly error messages for invalid or expired deep links.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_spacing.dart';
import '../buttons/primary_button.dart';

/// Types of deep link errors
enum DeepLinkErrorType {
  /// The route/page was not found
  notFound,

  /// The resource (task, property, etc.) was not found
  resourceNotFound,

  /// The link has expired
  expired,

  /// The user doesn't have permission to access
  unauthorized,

  /// Invalid parameters in the URL
  invalidParameters,

  /// Generic/unknown error
  unknown,
}

/// Error screen for deep linking failures
///
/// Displays user-friendly error messages with recovery options.
class DeepLinkErrorScreen extends StatelessWidget {
  const DeepLinkErrorScreen({
    required this.errorType,
    this.path,
    this.resourceType,
    this.resourceId,
    this.message,
    this.homeRoute = '/staff/dashboard',
    super.key,
  });

  /// The type of error that occurred
  final DeepLinkErrorType errorType;

  /// The path that was attempted (for debugging)
  final String? path;

  /// The type of resource being accessed (e.g., "task", "property")
  final String? resourceType;

  /// The ID of the resource being accessed
  final String? resourceId;

  /// Optional custom error message
  final String? message;

  /// Route to navigate to when going home
  final String homeRoute;

  /// Create from GoRouterState for 404 errors
  factory DeepLinkErrorScreen.fromRouterState(GoRouterState state) {
    return DeepLinkErrorScreen(
      errorType: DeepLinkErrorType.notFound,
      path: state.matchedLocation,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final errorInfo = _getErrorInfo();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: AppSpacing.screen,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Error icon
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: errorInfo.iconColor.withValues(alpha: 0.1),
                    ),
                    child: Icon(
                      errorInfo.icon,
                      size: 48,
                      color: errorInfo.iconColor,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Error title
                  Text(
                    errorInfo.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Error description
                  Text(
                    errorInfo.description,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xxl),

                  // Primary action button
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      label: errorInfo.primaryAction,
                      onPressed: () => _handlePrimaryAction(context),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Secondary action (go back if possible)
                  if (Navigator.of(context).canPop())
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Go Back'),
                    ),

                  // Debug info in debug mode
                  if (kDebugMode && path != null) ...[
                    const SizedBox(height: AppSpacing.xxl),
                    Container(
                      padding: AppSpacing.allMd,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: AppSpacing.borderRadiusSm,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Debug Info',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          SelectableText(
                            'Path: $path',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontFamily: 'monospace',
                            ),
                          ),
                          if (resourceType != null)
                            SelectableText(
                              'Resource: $resourceType${resourceId != null ? " #$resourceId" : ""}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontFamily: 'monospace',
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _ErrorInfo _getErrorInfo() {
    switch (errorType) {
      case DeepLinkErrorType.notFound:
        return _ErrorInfo(
          icon: Icons.search_off_rounded,
          iconColor: Colors.orange,
          title: 'Page Not Found',
          description: message ??
              'The page you\'re looking for doesn\'t exist or has been moved.',
          primaryAction: 'Go to Dashboard',
        );

      case DeepLinkErrorType.resourceNotFound:
        final resource = resourceType ?? 'item';
        return _ErrorInfo(
          icon: Icons.inbox_outlined,
          iconColor: Colors.orange,
          title: '${_capitalize(resource)} Not Found',
          description: message ??
              'The $resource you\'re looking for doesn\'t exist or has been deleted.',
          primaryAction: 'Go to Dashboard',
        );

      case DeepLinkErrorType.expired:
        return _ErrorInfo(
          icon: Icons.timer_off_outlined,
          iconColor: Colors.red,
          title: 'Link Expired',
          description:
              message ?? 'This link has expired. Please request a new one.',
          primaryAction: 'Go to Dashboard',
        );

      case DeepLinkErrorType.unauthorized:
        return _ErrorInfo(
          icon: Icons.lock_outline,
          iconColor: Colors.red,
          title: 'Access Denied',
          description: message ??
              'You don\'t have permission to access this content.',
          primaryAction: 'Go to Dashboard',
        );

      case DeepLinkErrorType.invalidParameters:
        return _ErrorInfo(
          icon: Icons.warning_amber_rounded,
          iconColor: Colors.orange,
          title: 'Invalid Link',
          description:
              message ?? 'This link contains invalid or missing parameters.',
          primaryAction: 'Go to Dashboard',
        );

      case DeepLinkErrorType.unknown:
        return _ErrorInfo(
          icon: Icons.error_outline,
          iconColor: Colors.red,
          title: 'Something Went Wrong',
          description:
              message ?? 'An unexpected error occurred. Please try again.',
          primaryAction: 'Go to Dashboard',
        );
    }
  }

  void _handlePrimaryAction(BuildContext context) {
    context.go(homeRoute);
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}

class _ErrorInfo {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final String primaryAction;

  const _ErrorInfo({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.primaryAction,
  });
}

/// Helper function to parse path parameters safely
///
/// Returns null if parsing fails instead of throwing an exception.
/// Use this for parsing IDs from route parameters.
///
/// Example:
/// ```dart
/// final taskId = parseIntParam(state.pathParameters['id']);
/// if (taskId == null) {
///   return DeepLinkErrorScreen(...);
/// }
/// return TaskDetailScreen(taskId: taskId);
/// ```
int? parseIntParam(String? value) {
  if (value == null) return null;
  return int.tryParse(value);
}

/// Extension for safe route parameter parsing
extension SafeRouteParams on GoRouterState {
  /// Get an integer path parameter safely
  int? intParam(String name) {
    final value = pathParameters[name];
    if (value == null) return null;
    return int.tryParse(value);
  }

  /// Get a required integer path parameter or show error screen
  Widget withIntParam(
    String name,
    Widget Function(int id) builder, {
    String? resourceType,
  }) {
    final value = intParam(name);
    if (value == null) {
      return DeepLinkErrorScreen(
        errorType: DeepLinkErrorType.invalidParameters,
        path: matchedLocation,
        resourceType: resourceType,
        resourceId: pathParameters[name],
        message: 'Invalid ${resourceType ?? "resource"} ID',
      );
    }
    return builder(value);
  }
}
