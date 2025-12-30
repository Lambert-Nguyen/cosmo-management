/// App spacing constants for Cosmo Management
///
/// Defines consistent spacing values for margins, paddings, and gaps.
library;

import 'package:flutter/material.dart';

/// App spacing constants
///
/// Uses a 4px base unit with a consistent scale for
/// predictable and harmonious layouts.
class AppSpacing {
  AppSpacing._();

  // ============================================
  // Base Spacing Values
  // ============================================

  /// 4px - Extra extra small
  static const double xxs = 4;

  /// 8px - Extra small
  static const double xs = 8;

  /// 12px - Small
  static const double sm = 12;

  /// 16px - Medium (default)
  static const double md = 16;

  /// 20px - Medium large
  static const double ml = 20;

  /// 24px - Large
  static const double lg = 24;

  /// 32px - Extra large
  static const double xl = 32;

  /// 40px - Extra extra large
  static const double xxl = 40;

  /// 48px - Triple extra large
  static const double xxxl = 48;

  // ============================================
  // Common EdgeInsets
  // ============================================

  /// No padding
  static const EdgeInsets none = EdgeInsets.zero;

  /// 4px all around
  static const EdgeInsets allXxs = EdgeInsets.all(xxs);

  /// 8px all around
  static const EdgeInsets allXs = EdgeInsets.all(xs);

  /// 12px all around
  static const EdgeInsets allSm = EdgeInsets.all(sm);

  /// 16px all around
  static const EdgeInsets allMd = EdgeInsets.all(md);

  /// 24px all around
  static const EdgeInsets allLg = EdgeInsets.all(lg);

  /// 32px all around
  static const EdgeInsets allXl = EdgeInsets.all(xl);

  /// Horizontal 16px
  static const EdgeInsets horizontalMd = EdgeInsets.symmetric(horizontal: md);

  /// Horizontal 24px
  static const EdgeInsets horizontalLg = EdgeInsets.symmetric(horizontal: lg);

  /// Vertical 8px
  static const EdgeInsets verticalXs = EdgeInsets.symmetric(vertical: xs);

  /// Vertical 12px
  static const EdgeInsets verticalSm = EdgeInsets.symmetric(vertical: sm);

  /// Vertical 16px
  static const EdgeInsets verticalMd = EdgeInsets.symmetric(vertical: md);

  /// Screen padding (horizontal 16px, vertical 24px)
  static const EdgeInsets screen = EdgeInsets.symmetric(
    horizontal: md,
    vertical: lg,
  );

  /// Card padding (16px all around)
  static const EdgeInsets card = EdgeInsets.all(md);

  /// List item padding (horizontal 16px, vertical 12px)
  static const EdgeInsets listItem = EdgeInsets.symmetric(
    horizontal: md,
    vertical: sm,
  );

  // ============================================
  // Border Radius
  // ============================================

  /// No radius
  static const double radiusNone = 0;

  /// 4px radius - Extra small
  static const double radiusXs = 4;

  /// 8px radius - Small
  static const double radiusSm = 8;

  /// 12px radius - Medium
  static const double radiusMd = 12;

  /// 16px radius - Large
  static const double radiusLg = 16;

  /// 24px radius - Extra large
  static const double radiusXl = 24;

  /// Full circular radius
  static const double radiusFull = 999;

  /// BorderRadius 4px
  static BorderRadius get borderRadiusXs => BorderRadius.circular(radiusXs);

  /// BorderRadius 8px
  static BorderRadius get borderRadiusSm => BorderRadius.circular(radiusSm);

  /// BorderRadius 12px
  static BorderRadius get borderRadiusMd => BorderRadius.circular(radiusMd);

  /// BorderRadius 16px
  static BorderRadius get borderRadiusLg => BorderRadius.circular(radiusLg);

  /// BorderRadius 24px
  static BorderRadius get borderRadiusXl => BorderRadius.circular(radiusXl);

  // ============================================
  // Icon Sizes
  // ============================================

  /// 16px icon
  static const double iconXs = 16;

  /// 20px icon
  static const double iconSm = 20;

  /// 24px icon (default)
  static const double iconMd = 24;

  /// 32px icon
  static const double iconLg = 32;

  /// 48px icon
  static const double iconXl = 48;

  // ============================================
  // Component Sizes
  // ============================================

  /// Button height - small
  static const double buttonHeightSm = 36;

  /// Button height - medium (default)
  static const double buttonHeightMd = 44;

  /// Button height - large
  static const double buttonHeightLg = 52;

  /// Input field height
  static const double inputHeight = 48;

  /// App bar height
  static const double appBarHeight = 56;

  /// Bottom nav bar height
  static const double bottomNavHeight = 80;

  /// Card min height
  static const double cardMinHeight = 80;

  /// Avatar size - small
  static const double avatarSm = 32;

  /// Avatar size - medium
  static const double avatarMd = 40;

  /// Avatar size - large
  static const double avatarLg = 56;
}
