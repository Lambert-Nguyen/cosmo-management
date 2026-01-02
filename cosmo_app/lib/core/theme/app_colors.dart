/// App colors for Cosmo Management
///
/// Defines the color palette for light and dark themes.
library;

import 'package:flutter/material.dart';

/// App color palette
///
/// Based on a blue primary color scheme with semantic colors
/// for status indicators and feedback.
class AppColors {
  AppColors._();

  // ============================================
  // Primary Colors
  // ============================================

  /// Primary blue - main brand color
  static const Color primary = Color(0xFF3B82F6);

  /// Primary light variant
  static const Color primaryLight = Color(0xFF60A5FA);

  /// Primary dark variant
  static const Color primaryDark = Color(0xFF2563EB);

  /// Primary container (for backgrounds)
  static const Color primaryContainer = Color(0xFFDBEAFE);

  /// On primary (text/icons on primary)
  static const Color onPrimary = Color(0xFFFFFFFF);

  // ============================================
  // Secondary Colors
  // ============================================

  /// Secondary purple - accent color
  static const Color secondary = Color(0xFF8B5CF6);

  /// Secondary light variant
  static const Color secondaryLight = Color(0xFFA78BFA);

  /// Secondary dark variant
  static const Color secondaryDark = Color(0xFF7C3AED);

  /// Secondary container
  static const Color secondaryContainer = Color(0xFFEDE9FE);

  /// On secondary
  static const Color onSecondary = Color(0xFFFFFFFF);

  // ============================================
  // Neutral Colors
  // ============================================

  /// Background color (light mode)
  static const Color background = Color(0xFFF8FAFC);

  /// Surface color (cards, sheets)
  static const Color surface = Color(0xFFFFFFFF);

  /// Surface variant
  static const Color surfaceVariant = Color(0xFFF1F5F9);

  /// On background
  static const Color onBackground = Color(0xFF0F172A);

  /// On surface
  static const Color onSurface = Color(0xFF1E293B);

  /// On surface variant (secondary text)
  static const Color onSurfaceVariant = Color(0xFF64748B);

  /// Outline color
  static const Color outline = Color(0xFFCBD5E1);

  /// Outline variant (subtle borders)
  static const Color outlineVariant = Color(0xFFE2E8F0);

  // ============================================
  // Dark Mode Colors
  // ============================================

  /// Background color (dark mode)
  static const Color backgroundDark = Color(0xFF0F172A);

  /// Surface color (dark mode)
  static const Color surfaceDark = Color(0xFF1E293B);

  /// Surface variant (dark mode)
  static const Color surfaceVariantDark = Color(0xFF334155);

  /// On background (dark mode)
  static const Color onBackgroundDark = Color(0xFFF8FAFC);

  /// On surface (dark mode)
  static const Color onSurfaceDark = Color(0xFFE2E8F0);

  /// On surface variant (dark mode)
  static const Color onSurfaceVariantDark = Color(0xFF94A3B8);

  /// Outline (dark mode)
  static const Color outlineDark = Color(0xFF475569);

  /// Outline variant (dark mode)
  static const Color outlineVariantDark = Color(0xFF334155);

  // ============================================
  // Semantic Colors - Status
  // ============================================

  /// Success green
  static const Color success = Color(0xFF22C55E);

  /// Success container
  static const Color successContainer = Color(0xFFDCFCE7);

  /// On success
  static const Color onSuccess = Color(0xFFFFFFFF);

  /// Warning amber
  static const Color warning = Color(0xFFF59E0B);

  /// Warning container
  static const Color warningContainer = Color(0xFFFEF3C7);

  /// On warning
  static const Color onWarning = Color(0xFF000000);

  /// Error red
  static const Color error = Color(0xFFEF4444);

  /// Error container
  static const Color errorContainer = Color(0xFFFEE2E2);

  /// On error
  static const Color onError = Color(0xFFFFFFFF);

  /// Info blue
  static const Color info = Color(0xFF0EA5E9);

  /// Info container
  static const Color infoContainer = Color(0xFFE0F2FE);

  /// On info
  static const Color onInfo = Color(0xFFFFFFFF);

  // ============================================
  // Task Status Colors
  // ============================================

  /// Pending task color
  static const Color taskPending = Color(0xFF94A3B8);

  /// In progress task color
  static const Color taskInProgress = Color(0xFF3B82F6);

  /// Completed task color
  static const Color taskCompleted = Color(0xFF22C55E);

  /// Cancelled task color
  static const Color taskCancelled = Color(0xFFEF4444);

  /// Overdue task color
  static const Color taskOverdue = Color(0xFFF59E0B);

  // ============================================
  // Priority Colors
  // ============================================

  /// Low priority
  static const Color priorityLow = Color(0xFF22C55E);

  /// Medium priority
  static const Color priorityMedium = Color(0xFFF59E0B);

  /// High priority
  static const Color priorityHigh = Color(0xFFF97316);

  /// Urgent priority
  static const Color priorityUrgent = Color(0xFFEF4444);
}
