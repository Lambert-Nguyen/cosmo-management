/// Primary button widget for Cosmo Management
library;

import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';

/// Primary action button with loading state support
///
/// Used for main actions like "Save", "Submit", "Continue".
class PrimaryButton extends StatelessWidget {
  /// Button label text
  final String label;

  /// Callback when button is pressed
  final VoidCallback? onPressed;

  /// Whether the button is in loading state
  final bool isLoading;

  /// Optional icon to display before label
  final IconData? icon;

  /// Whether to expand to full width
  final bool fullWidth;

  /// Button size variant
  final ButtonSize size;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.fullWidth = true,
    this.size = ButtonSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    final height = switch (size) {
      ButtonSize.small => AppSpacing.buttonHeightSm,
      ButtonSize.medium => AppSpacing.buttonHeightMd,
      ButtonSize.large => AppSpacing.buttonHeightLg,
    };

    final child = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: AppSpacing.xs),
              ],
              Text(label),
            ],
          );

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: child,
      ),
    );
  }
}

/// Secondary button with outline style
class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool fullWidth;
  final ButtonSize size;

  const SecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.fullWidth = true,
    this.size = ButtonSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    final height = switch (size) {
      ButtonSize.small => AppSpacing.buttonHeightSm,
      ButtonSize.medium => AppSpacing.buttonHeightMd,
      ButtonSize.large => AppSpacing.buttonHeightLg,
    };

    final child = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Theme.of(context).colorScheme.primary,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: AppSpacing.xs),
              ],
              Text(label),
            ],
          );

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: height,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        child: child,
      ),
    );
  }
}

/// Button size variants
enum ButtonSize {
  small,
  medium,
  large,
}
