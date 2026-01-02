/// Forgot password screen for Cosmo Management
///
/// Handles password reset request flow.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/auth_notifier.dart';
import '../../../core/providers/service_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/widgets/inputs/app_text_field.dart';
import '../../../router/route_names.dart';

/// Forgot password screen for password reset
///
/// Features:
/// - Email input with validation
/// - Success state with email confirmation
/// - Error handling
/// - Return to login option
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _emailSent = false;
  String? _sentToEmail;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    await ref.read(authNotifierProvider.notifier).requestPasswordReset(email);
  }

  void _handleResend() async {
    if (_sentToEmail != null) {
      await ref
          .read(authNotifierProvider.notifier)
          .requestPasswordReset(_sentToEmail!);
    }
  }

  void _handleBackToLogin() {
    ref.read(authNotifierProvider.notifier).resetToUnauthenticated();
    context.go(RouteNames.login);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);

    // Listen for auth state changes
    ref.listen<AuthNotifierState>(authNotifierProvider, (previous, next) {
      if (next is PasswordResetSent) {
        setState(() {
          _emailSent = true;
          _sentToEmail = next.email;
        });
      }
    });

    final isLoading = authState is AuthLoading;
    final loadingMessage =
        authState is AuthLoading ? authState.message : null;
    final errorMessage = authState is AuthError ? authState.message : null;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: isLoading ? null : () => context.pop(),
        ),
        title: const Text('Reset Password'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: AppSpacing.screen,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _emailSent
                    ? _buildSuccessState(theme)
                    : _buildEmailForm(
                        theme, isLoading, loadingMessage, errorMessage),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailForm(
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
            'Forgot Password?',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Enter your email address and we\'ll send you instructions to reset your password.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xxl),

          // Error message
          if (errorMessage != null) ...[
            _buildErrorMessage(theme, errorMessage),
            const SizedBox(height: AppSpacing.lg),
          ],

          // Loading message
          if (isLoading && loadingMessage != null) ...[
            _buildLoadingMessage(theme, loadingMessage),
            const SizedBox(height: AppSpacing.lg),
          ],

          // Email field
          AppTextField(
            controller: _emailController,
            label: 'Email',
            hint: 'Enter your email address',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.email],
            validator: FormValidators.email,
            isRequired: true,
            enabled: !isLoading,
            onSubmitted: (_) => _handleSubmit(),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Submit button
          PrimaryButton(
            label: 'Send Reset Link',
            onPressed: isLoading ? null : _handleSubmit,
            isLoading: isLoading,
          ),
          const SizedBox(height: AppSpacing.lg),

          // Back to login
          Center(
            child: TextButton.icon(
              onPressed: isLoading ? null : _handleBackToLogin,
              icon: const Icon(Icons.arrow_back, size: 18),
              label: const Text('Back to Sign In'),
            ),
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
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.successContainer,
          ),
          child: const Icon(
            Icons.mark_email_read_outlined,
            size: 40,
            color: AppColors.success,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Title
        Text(
          'Check Your Email',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),

        // Description
        Text(
          'We\'ve sent password reset instructions to:',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xs),

        // Email
        Text(
          _sentToEmail ?? '',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.lg),

        // Info box
        Container(
          padding: AppSpacing.allMd,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: AppSpacing.borderRadiusSm,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 20,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'The link will expire in 24 hours',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Icon(
                    Icons.folder_outlined,
                    size: 20,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Check your spam folder if you don\'t see it',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),

        // Resend button
        OutlinedButton(
          onPressed: _handleResend,
          child: const Text('Resend Email'),
        ),
        const SizedBox(height: AppSpacing.md),

        // Back to login button
        PrimaryButton(
          label: 'Back to Sign In',
          onPressed: _handleBackToLogin,
        ),
      ],
    );
  }

  Widget _buildErrorMessage(ThemeData theme, String message) {
    return Container(
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
              _formatErrorMessage(message),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingMessage(ThemeData theme, String message) {
    return Container(
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
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatErrorMessage(String error) {
    if (error.contains('NetworkException') ||
        error.contains('SocketException')) {
      return 'No internet connection. Please check your network.';
    }
    if (error.contains('TimeoutException')) {
      return 'Connection timed out. Please try again.';
    }
    if (error.contains('429')) {
      return 'Too many requests. Please try again later.';
    }
    return error
        .replaceAll('Exception:', '')
        .replaceAll('ApiException:', '')
        .trim();
  }
}
