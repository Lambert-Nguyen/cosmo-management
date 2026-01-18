/// Keyboard navigation utilities for web platform
///
/// Provides keyboard shortcut handling and focus management
/// for improved desktop/web accessibility.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Common keyboard shortcuts for the application
class AppShortcuts {
  AppShortcuts._();

  /// Escape key - typically closes dialogs/modals
  static const escape = SingleActivator(LogicalKeyboardKey.escape);

  /// Enter/Return key - typically submits forms
  static const enter = SingleActivator(LogicalKeyboardKey.enter);

  /// Ctrl/Cmd + S - Save
  static final save = SingleActivator(
    LogicalKeyboardKey.keyS,
    control: !kIsWeb || !defaultTargetPlatform.toString().contains('macos'),
    meta: kIsWeb && defaultTargetPlatform.toString().contains('macos'),
  );

  /// Ctrl/Cmd + N - New item
  static final newItem = SingleActivator(
    LogicalKeyboardKey.keyN,
    control: !kIsWeb || !defaultTargetPlatform.toString().contains('macos'),
    meta: kIsWeb && defaultTargetPlatform.toString().contains('macos'),
  );

  /// Ctrl/Cmd + F - Search/Find
  static final search = SingleActivator(
    LogicalKeyboardKey.keyF,
    control: !kIsWeb || !defaultTargetPlatform.toString().contains('macos'),
    meta: kIsWeb && defaultTargetPlatform.toString().contains('macos'),
  );

  /// Ctrl/Cmd + R - Refresh
  static final refresh = SingleActivator(
    LogicalKeyboardKey.keyR,
    control: !kIsWeb || !defaultTargetPlatform.toString().contains('macos'),
    meta: kIsWeb && defaultTargetPlatform.toString().contains('macos'),
  );
}

/// A widget that provides keyboard shortcuts for common actions
///
/// Wrap your screen or widget tree with this to enable keyboard shortcuts.
///
/// Example:
/// ```dart
/// KeyboardShortcutsWrapper(
///   onEscape: () => Navigator.pop(context),
///   onSave: () => _saveForm(),
///   child: MyFormWidget(),
/// )
/// ```
class KeyboardShortcutsWrapper extends StatelessWidget {
  const KeyboardShortcutsWrapper({
    required this.child,
    this.onEscape,
    this.onEnter,
    this.onSave,
    this.onNewItem,
    this.onSearch,
    this.onRefresh,
    this.autofocus = false,
    super.key,
  });

  final Widget child;

  /// Called when Escape is pressed
  final VoidCallback? onEscape;

  /// Called when Enter is pressed
  final VoidCallback? onEnter;

  /// Called when Ctrl/Cmd+S is pressed
  final VoidCallback? onSave;

  /// Called when Ctrl/Cmd+N is pressed
  final VoidCallback? onNewItem;

  /// Called when Ctrl/Cmd+F is pressed
  final VoidCallback? onSearch;

  /// Called when Ctrl/Cmd+R is pressed
  final VoidCallback? onRefresh;

  /// Whether to autofocus the shortcuts widget
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        if (onEscape != null) AppShortcuts.escape: onEscape!,
        if (onEnter != null) AppShortcuts.enter: onEnter!,
        if (onSave != null) AppShortcuts.save: onSave!,
        if (onNewItem != null) AppShortcuts.newItem: onNewItem!,
        if (onSearch != null) AppShortcuts.search: onSearch!,
        if (onRefresh != null) AppShortcuts.refresh: onRefresh!,
      },
      child: Focus(
        autofocus: autofocus,
        child: child,
      ),
    );
  }
}

/// A focusable card widget with keyboard navigation support
///
/// Provides visible focus indicator and keyboard activation (Enter/Space).
class FocusableCard extends StatefulWidget {
  const FocusableCard({
    required this.child,
    required this.onTap,
    this.onLongPress,
    this.focusColor,
    this.borderRadius = 12.0,
    this.semanticLabel,
    super.key,
  });

  final Widget child;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final Color? focusColor;
  final double borderRadius;
  final String? semanticLabel;

  @override
  State<FocusableCard> createState() => _FocusableCardState();
}

class _FocusableCardState extends State<FocusableCard> {
  bool _isFocused = false;

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter ||
          event.logicalKey == LogicalKeyboardKey.space) {
        widget.onTap();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final focusColor = widget.focusColor ?? theme.colorScheme.primary;

    return Semantics(
      label: widget.semanticLabel,
      button: true,
      child: KeyboardListener(
        focusNode: FocusNode(),
        onKeyEvent: _handleKeyEvent,
        child: Focus(
          onFocusChange: (focused) => setState(() => _isFocused = focused),
          child: GestureDetector(
            onTap: widget.onTap,
            onLongPress: widget.onLongPress,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                border: _isFocused
                    ? Border.all(color: focusColor, width: 2)
                    : null,
                boxShadow: _isFocused
                    ? [
                        BoxShadow(
                          color: focusColor.withValues(alpha: 0.3),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}

/// A list view with keyboard navigation between items
///
/// Supports arrow keys to navigate between items and Enter to select.
class KeyboardNavigableList extends StatefulWidget {
  const KeyboardNavigableList({
    required this.itemCount,
    required this.itemBuilder,
    this.onItemSelected,
    this.scrollController,
    this.padding,
    super.key,
  });

  final int itemCount;
  final Widget Function(BuildContext context, int index, bool isFocused)
      itemBuilder;
  final void Function(int index)? onItemSelected;
  final ScrollController? scrollController;
  final EdgeInsets? padding;

  @override
  State<KeyboardNavigableList> createState() => _KeyboardNavigableListState();
}

class _KeyboardNavigableListState extends State<KeyboardNavigableList> {
  int _focusedIndex = -1;
  late final FocusNode _focusNode;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _scrollController = widget.scrollController ?? ScrollController();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      _moveFocus(1);
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      _moveFocus(-1);
    } else if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.space) {
      if (_focusedIndex >= 0 && _focusedIndex < widget.itemCount) {
        widget.onItemSelected?.call(_focusedIndex);
      }
    } else if (event.logicalKey == LogicalKeyboardKey.home) {
      setState(() => _focusedIndex = 0);
    } else if (event.logicalKey == LogicalKeyboardKey.end) {
      setState(() => _focusedIndex = widget.itemCount - 1);
    }
  }

  void _moveFocus(int delta) {
    setState(() {
      if (_focusedIndex < 0) {
        _focusedIndex = delta > 0 ? 0 : widget.itemCount - 1;
      } else {
        _focusedIndex = (_focusedIndex + delta).clamp(0, widget.itemCount - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      child: ListView.builder(
        controller: _scrollController,
        padding: widget.padding,
        itemCount: widget.itemCount,
        itemBuilder: (context, index) {
          return widget.itemBuilder(context, index, index == _focusedIndex);
        },
      ),
    );
  }
}

/// Extension for adding focus-related helpers to BuildContext
extension FocusContextExtension on BuildContext {
  /// Request focus on the nearest focusable widget
  void requestFocus() {
    FocusScope.of(this).requestFocus();
  }

  /// Move focus to the next focusable widget
  void nextFocus() {
    FocusScope.of(this).nextFocus();
  }

  /// Move focus to the previous focusable widget
  void previousFocus() {
    FocusScope.of(this).previousFocus();
  }

  /// Unfocus all focused widgets
  void unfocus() {
    FocusScope.of(this).unfocus();
  }
}
