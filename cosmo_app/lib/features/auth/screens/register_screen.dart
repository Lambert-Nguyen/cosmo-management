/// Register screen for Cosmo Management
///
/// Multi-step registration flow with invite code validation.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/auth_notifier.dart';
import '../../../core/providers/service_providers.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/buttons/primary_button.dart';
import '../../../core/widgets/inputs/app_text_field.dart';
import '../../../router/route_names.dart';

/// Registration step enum
enum RegisterStep {
  inviteCode,
  accountDetails,
}

/// Register screen for new user registration
///
/// Features:
/// - Step 1: Invite code validation
/// - Step 2: Account details (email, password, name)
/// - Form validation
/// - Loading states
/// - Error handling with field-level errors
class RegisterScreen extends ConsumerStatefulWidget {
  /// Optional pre-filled invite code (from deep link)
  final String? initialInviteCode;

  const RegisterScreen({super.key, this.initialInviteCode});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _inviteCodeController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  final _inviteFormKey = GlobalKey<FormState>();
  final _detailsFormKey = GlobalKey<FormState>();

  RegisterStep _currentStep = RegisterStep.inviteCode;
  InviteValidation? _validatedInvite;
  Map<String, List<String>> _fieldErrors = {};

  @override
  void initState() {
    super.initState();
    if (widget.initialInviteCode != null) {
      _inviteCodeController.text = widget.initialInviteCode!;
      // Auto-validate if code is provided
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _validateInviteCode();
      });
    }
  }

  @override
  void dispose() {
    _inviteCodeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _validateInviteCode() async {
    if (!_inviteFormKey.currentState!.validate()) return;

    setState(() => _fieldErrors = {});
    final code = _inviteCodeController.text.trim();
    await ref.read(authNotifierProvider.notifier).validateInviteCode(code);
  }

  Future<void> _handleRegister() async {
    if (!_detailsFormKey.currentState!.validate()) return;

    setState(() => _fieldErrors = {});

    await ref.read(authNotifierProvider.notifier).register(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          inviteCode: _inviteCodeController.text.trim(),
          firstName: _firstNameController.text.trim().isNotEmpty
              ? _firstNameController.text.trim()
              : null,
          lastName: _lastNameController.text.trim().isNotEmpty
              ? _lastNameController.text.trim()
              : null,
        );
  }

  void _goBack() {
    if (_currentStep == RegisterStep.accountDetails) {
      setState(() {
        _currentStep = RegisterStep.inviteCode;
        _validatedInvite = null;
        _fieldErrors = {};
      });
      ref.read(authNotifierProvider.notifier).resetToUnauthenticated();
    } else {
      context.pop();
    }
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);

    // Listen for auth state changes
    ref.listen<AuthNotifierState>(authNotifierProvider, (previous, next) {
      if (next is InviteValidated) {
        setState(() {
          _validatedInvite = next.validation;
          _currentStep = RegisterStep.accountDetails;
        });
        // Pre-fill email if provided by invite
        if (next.validation.email != null) {
          _emailController.text = next.validation.email!;
        }
      } else if (next is AuthAuthenticated) {
        context.go(RouteNames.home);
      } else if (next is AuthError) {
        setState(() {
          _fieldErrors = next.fieldErrors;
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
          onPressed: isLoading ? null : _goBack,
        ),
        title: Text(_currentStep == RegisterStep.inviteCode
            ? 'Enter Invite Code'
            : 'Create Account'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: AppSpacing.screen,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Step indicator
                  _buildStepIndicator(theme),
                  const SizedBox(height: AppSpacing.xl),

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

                  // Form content
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _currentStep == RegisterStep.inviteCode
                        ? _buildInviteCodeStep(theme, isLoading)
                        : _buildAccountDetailsStep(theme, isLoading),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator(ThemeData theme) {
    return Row(
      children: [
        _buildStepDot(
          theme,
          stepNumber: 1,
          label: 'Invite',
          isActive: true,
          isCompleted: _currentStep == RegisterStep.accountDetails,
        ),
        Expanded(
          child: Container(
            height: 2,
            color: _currentStep == RegisterStep.accountDetails
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        _buildStepDot(
          theme,
          stepNumber: 2,
          label: 'Account',
          isActive: _currentStep == RegisterStep.accountDetails,
          isCompleted: false,
        ),
      ],
    );
  }

  Widget _buildStepDot(
    ThemeData theme, {
    required int stepNumber,
    required String label,
    required bool isActive,
    required bool isCompleted,
  }) {
    final color = isActive || isCompleted
        ? theme.colorScheme.primary
        : theme.colorScheme.outline.withValues(alpha: 0.5);

    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                isActive || isCompleted ? color : color.withValues(alpha: 0.1),
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: isCompleted
                ? Icon(Icons.check, size: 18, color: Colors.white)
                : Text(
                    '$stepNumber',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isActive ? Colors.white : color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: isActive || isCompleted
                ? theme.colorScheme.onSurface
                : theme.colorScheme.outline,
          ),
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

  Widget _buildInviteCodeStep(ThemeData theme, bool isLoading) {
    return Form(
      key: _inviteFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Icon and title
          Icon(
            Icons.mail_outline,
            size: 64,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Welcome to Cosmo',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Enter your invite code to get started',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xxl),

          // Invite code field
          AppTextField(
            controller: _inviteCodeController,
            label: 'Invite Code',
            hint: 'Enter your invite code',
            prefixIcon: Icons.vpn_key_outlined,
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9-]')),
              UpperCaseTextFormatter(),
            ],
            onSubmitted: (_) => _validateInviteCode(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Invite code is required';
              }
              if (value.length < 6) {
                return 'Invalid invite code format';
              }
              return null;
            },
            isRequired: true,
            enabled: !isLoading,
            errorText: _fieldErrors['code']?.first,
          ),
          const SizedBox(height: AppSpacing.lg),

          // Continue button
          PrimaryButton(
            label: 'Continue',
            onPressed: isLoading ? null : _validateInviteCode,
            isLoading: isLoading,
          ),
          const SizedBox(height: AppSpacing.lg),

          // Already have an account
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'Already have an account?',
                style: theme.textTheme.bodyMedium,
              ),
              TextButton(
                onPressed: isLoading ? null : () => context.go(RouteNames.login),
                child: const Text('Sign In'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccountDetailsStep(ThemeData theme, bool isLoading) {
    return Form(
      key: _detailsFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Welcome message with role info
          if (_validatedInvite != null && _validatedInvite!.role != null) ...[
            Container(
              padding: AppSpacing.allMd,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: AppSpacing.borderRadiusSm,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.badge_outlined,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'You\'ll be joining as ${_formatRole(_validatedInvite!.role!)}',
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

          // Name fields (optional)
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _firstNameController,
                  label: 'First Name',
                  hint: 'John',
                  prefixIcon: Icons.person_outline,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  autofillHints: const [AutofillHints.givenName],
                  enabled: !isLoading,
                  errorText: _fieldErrors['first_name']?.first,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppTextField(
                  controller: _lastNameController,
                  label: 'Last Name',
                  hint: 'Doe',
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  autofillHints: const [AutofillHints.familyName],
                  enabled: !isLoading,
                  errorText: _fieldErrors['last_name']?.first,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Email field
          AppTextField(
            controller: _emailController,
            label: 'Email',
            hint: 'you@example.com',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.email],
            validator: FormValidators.email,
            isRequired: true,
            enabled: !isLoading && _validatedInvite?.email == null,
            errorText: _fieldErrors['email']?.first,
          ),
          const SizedBox(height: AppSpacing.md),

          // Password field
          PasswordTextField(
            controller: _passwordController,
            label: 'Password',
            hint: 'Create a strong password',
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.newPassword],
            validator: _validatePassword,
            isRequired: true,
            enabled: !isLoading,
            errorText: _fieldErrors['password']?.first,
          ),
          const SizedBox(height: AppSpacing.xs),
          _buildPasswordHints(theme),
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
            onSubmitted: (_) => _handleRegister(),
            enabled: !isLoading,
          ),
          const SizedBox(height: AppSpacing.xl),

          // Create account button
          PrimaryButton(
            label: 'Create Account',
            onPressed: isLoading ? null : _handleRegister,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordHints(ThemeData theme) {
    final password = _passwordController.text;
    final hints = [
      (password.length >= 8, 'At least 8 characters'),
      (password.contains(RegExp(r'[A-Z]')), 'One uppercase letter'),
      (password.contains(RegExp(r'[a-z]')), 'One lowercase letter'),
      (password.contains(RegExp(r'[0-9]')), 'One number'),
    ];

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.xs,
      children: hints.map((hint) {
        final (isValid, text) = hint;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isValid ? Icons.check_circle : Icons.circle_outlined,
              size: 14,
              color: isValid
                  ? AppColors.success
                  : theme.colorScheme.outline.withValues(alpha: 0.5),
            ),
            const SizedBox(width: 4),
            Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isValid
                    ? AppColors.success
                    : theme.colorScheme.outline.withValues(alpha: 0.7),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  String _formatErrorMessage(String error) {
    if (error.contains('ValidationException')) {
      return error.replaceAll('ValidationException:', '').trim();
    }
    if (error.contains('NetworkException') ||
        error.contains('SocketException')) {
      return 'No internet connection. Please check your network.';
    }
    if (error.contains('TimeoutException')) {
      return 'Connection timed out. Please try again.';
    }
    if (error.contains('NotFoundException')) {
      return 'Invite code not found or has expired';
    }
    return error
        .replaceAll('Exception:', '')
        .replaceAll('ApiException:', '')
        .trim();
  }

  String _formatRole(String role) {
    switch (role.toLowerCase()) {
      case 'manager':
        return 'a Manager';
      case 'staff':
        return 'Staff';
      case 'owner':
        return 'an Owner';
      case 'admin':
        return 'an Admin';
      default:
        return role;
    }
  }
}

/// Text input formatter that converts text to uppercase
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
