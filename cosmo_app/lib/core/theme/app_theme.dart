/// App theme for Cosmo Management
///
/// Provides complete light and dark themes using Material 3.
library;

import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// App theme configuration
///
/// Combines colors, typography, and component themes
/// for consistent styling across the app.
class AppTheme {
  AppTheme._();

  /// Light theme
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: _lightColorScheme,
        textTheme: AppTypography.lightTextTheme,
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: _lightAppBarTheme,
        cardTheme: _lightCardTheme,
        elevatedButtonTheme: _elevatedButtonTheme,
        outlinedButtonTheme: _outlinedButtonTheme,
        textButtonTheme: _textButtonTheme,
        inputDecorationTheme: _lightInputDecorationTheme,
        chipTheme: _lightChipTheme,
        dividerTheme: _lightDividerTheme,
        bottomNavigationBarTheme: _lightBottomNavTheme,
        floatingActionButtonTheme: _fabTheme,
        snackBarTheme: _snackBarTheme,
        dialogTheme: _dialogTheme,
        bottomSheetTheme: _bottomSheetTheme,
      );

  /// Dark theme
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: _darkColorScheme,
        textTheme: AppTypography.darkTextTheme,
        scaffoldBackgroundColor: AppColors.backgroundDark,
        appBarTheme: _darkAppBarTheme,
        cardTheme: _darkCardTheme,
        elevatedButtonTheme: _elevatedButtonTheme,
        outlinedButtonTheme: _outlinedButtonTheme,
        textButtonTheme: _textButtonTheme,
        inputDecorationTheme: _darkInputDecorationTheme,
        chipTheme: _darkChipTheme,
        dividerTheme: _darkDividerTheme,
        bottomNavigationBarTheme: _darkBottomNavTheme,
        floatingActionButtonTheme: _fabTheme,
        snackBarTheme: _snackBarTheme,
        dialogTheme: _dialogTheme,
        bottomSheetTheme: _bottomSheetTheme,
      );

  // ============================================
  // Color Schemes
  // ============================================

  static const ColorScheme _lightColorScheme = ColorScheme.light(
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.primaryDark,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    secondaryContainer: AppColors.secondaryContainer,
    onSecondaryContainer: AppColors.secondaryDark,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    surfaceContainerHighest: AppColors.surfaceVariant,
    onSurfaceVariant: AppColors.onSurfaceVariant,
    error: AppColors.error,
    onError: AppColors.onError,
    errorContainer: AppColors.errorContainer,
    outline: AppColors.outline,
    outlineVariant: AppColors.outlineVariant,
  );

  static const ColorScheme _darkColorScheme = ColorScheme.dark(
    primary: AppColors.primaryLight,
    onPrimary: AppColors.primaryDark,
    primaryContainer: AppColors.primaryDark,
    onPrimaryContainer: AppColors.primaryContainer,
    secondary: AppColors.secondaryLight,
    onSecondary: AppColors.secondaryDark,
    secondaryContainer: AppColors.secondaryDark,
    onSecondaryContainer: AppColors.secondaryContainer,
    surface: AppColors.surfaceDark,
    onSurface: AppColors.onSurfaceDark,
    surfaceContainerHighest: AppColors.surfaceVariantDark,
    onSurfaceVariant: AppColors.onSurfaceVariantDark,
    error: AppColors.error,
    onError: AppColors.onError,
    errorContainer: AppColors.errorContainer,
    outline: AppColors.outlineDark,
    outlineVariant: AppColors.outlineVariantDark,
  );

  // ============================================
  // App Bar Themes
  // ============================================

  static const AppBarTheme _lightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: true,
    backgroundColor: AppColors.surface,
    foregroundColor: AppColors.onSurface,
    surfaceTintColor: Colors.transparent,
    titleTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.onSurface,
    ),
  );

  static const AppBarTheme _darkAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: true,
    backgroundColor: AppColors.surfaceDark,
    foregroundColor: AppColors.onSurfaceDark,
    surfaceTintColor: Colors.transparent,
    titleTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.onSurfaceDark,
    ),
  );

  // ============================================
  // Card Themes
  // ============================================

  static CardThemeData _lightCardTheme = CardThemeData(
    elevation: 0,
    color: AppColors.surface,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: AppSpacing.borderRadiusMd,
      side: const BorderSide(color: AppColors.outlineVariant),
    ),
    margin: EdgeInsets.zero,
  );

  static CardThemeData _darkCardTheme = CardThemeData(
    elevation: 0,
    color: AppColors.surfaceDark,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: AppSpacing.borderRadiusMd,
      side: const BorderSide(color: AppColors.outlineVariantDark),
    ),
    margin: EdgeInsets.zero,
  );

  // ============================================
  // Button Themes
  // ============================================

  static final ElevatedButtonThemeData _elevatedButtonTheme =
      ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      minimumSize: const Size(double.infinity, AppSpacing.buttonHeightMd),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusSm,
      ),
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  static final OutlinedButtonThemeData _outlinedButtonTheme =
      OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      minimumSize: const Size(double.infinity, AppSpacing.buttonHeightMd),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusSm,
      ),
      side: const BorderSide(color: AppColors.outline),
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  static final TextButtonThemeData _textButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      minimumSize: const Size(0, AppSpacing.buttonHeightSm),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusSm,
      ),
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  // ============================================
  // Input Decoration Themes
  // ============================================

  static InputDecorationTheme _lightInputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surfaceVariant,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.sm,
    ),
    border: OutlineInputBorder(
      borderRadius: AppSpacing.borderRadiusSm,
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: AppSpacing.borderRadiusSm,
      borderSide: const BorderSide(color: AppColors.outline),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: AppSpacing.borderRadiusSm,
      borderSide: const BorderSide(color: AppColors.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: AppSpacing.borderRadiusSm,
      borderSide: const BorderSide(color: AppColors.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: AppSpacing.borderRadiusSm,
      borderSide: const BorderSide(color: AppColors.error, width: 2),
    ),
    hintStyle: const TextStyle(color: AppColors.onSurfaceVariant),
    labelStyle: const TextStyle(color: AppColors.onSurfaceVariant),
  );

  static InputDecorationTheme _darkInputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surfaceVariantDark,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.sm,
    ),
    border: OutlineInputBorder(
      borderRadius: AppSpacing.borderRadiusSm,
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: AppSpacing.borderRadiusSm,
      borderSide: const BorderSide(color: AppColors.outlineDark),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: AppSpacing.borderRadiusSm,
      borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: AppSpacing.borderRadiusSm,
      borderSide: const BorderSide(color: AppColors.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: AppSpacing.borderRadiusSm,
      borderSide: const BorderSide(color: AppColors.error, width: 2),
    ),
    hintStyle: const TextStyle(color: AppColors.onSurfaceVariantDark),
    labelStyle: const TextStyle(color: AppColors.onSurfaceVariantDark),
  );

  // ============================================
  // Chip Themes
  // ============================================

  static ChipThemeData _lightChipTheme = ChipThemeData(
    backgroundColor: AppColors.surfaceVariant,
    selectedColor: AppColors.primaryContainer,
    labelStyle: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.sm,
      vertical: AppSpacing.xxs,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: AppSpacing.borderRadiusSm,
    ),
  );

  static ChipThemeData _darkChipTheme = ChipThemeData(
    backgroundColor: AppColors.surfaceVariantDark,
    selectedColor: AppColors.primaryDark,
    labelStyle: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.sm,
      vertical: AppSpacing.xxs,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: AppSpacing.borderRadiusSm,
    ),
  );

  // ============================================
  // Divider Themes
  // ============================================

  static const DividerThemeData _lightDividerTheme = DividerThemeData(
    color: AppColors.outlineVariant,
    thickness: 1,
    space: 1,
  );

  static const DividerThemeData _darkDividerTheme = DividerThemeData(
    color: AppColors.outlineVariantDark,
    thickness: 1,
    space: 1,
  );

  // ============================================
  // Bottom Navigation Themes
  // ============================================

  static const BottomNavigationBarThemeData _lightBottomNavTheme =
      BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    backgroundColor: AppColors.surface,
    selectedItemColor: AppColors.primary,
    unselectedItemColor: AppColors.onSurfaceVariant,
    elevation: 8,
  );

  static const BottomNavigationBarThemeData _darkBottomNavTheme =
      BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    backgroundColor: AppColors.surfaceDark,
    selectedItemColor: AppColors.primaryLight,
    unselectedItemColor: AppColors.onSurfaceVariantDark,
    elevation: 8,
  );

  // ============================================
  // FAB Theme
  // ============================================

  static FloatingActionButtonThemeData _fabTheme = FloatingActionButtonThemeData(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.onPrimary,
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: AppSpacing.borderRadiusMd,
    ),
  );

  // ============================================
  // SnackBar Theme
  // ============================================

  static SnackBarThemeData _snackBarTheme = SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: AppSpacing.borderRadiusSm,
    ),
  );

  // ============================================
  // Dialog Theme
  // ============================================

  static DialogThemeData _dialogTheme = DialogThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: AppSpacing.borderRadiusLg,
    ),
  );

  // ============================================
  // Bottom Sheet Theme
  // ============================================

  static BottomSheetThemeData _bottomSheetTheme = BottomSheetThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSpacing.radiusLg),
      ),
    ),
  );
}
