/// Integration test helpers for Cosmo Management
///
/// Common utilities and setup for integration tests.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:cosmo_app/main.dart' as app;

/// Initialize integration test binding
IntegrationTestWidgetsFlutterBinding ensureInitializedBinding() {
  return IntegrationTestWidgetsFlutterBinding.ensureInitialized();
}

/// Common test utilities
class IntegrationTestHelper {
  IntegrationTestHelper(this.tester);

  final WidgetTester tester;

  /// Pump the app and settle
  Future<void> pumpApp() async {
    app.main();
    await tester.pumpAndSettle();
  }

  /// Wait for widget to appear with timeout
  Future<void> waitForWidget(
    Finder finder, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final end = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(end)) {
      await tester.pump(const Duration(milliseconds: 100));
      if (finder.evaluate().isNotEmpty) {
        return;
      }
    }
    throw Exception('Widget not found within timeout: $finder');
  }

  /// Tap and settle
  Future<void> tapAndSettle(Finder finder) async {
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  /// Enter text in field
  Future<void> enterText(Finder finder, String text) async {
    await tester.enterText(finder, text);
    await tester.pumpAndSettle();
  }

  /// Scroll until widget is visible
  Future<void> scrollUntilVisible(
    Finder finder,
    Finder scrollable, {
    double delta = 100,
  }) async {
    await tester.scrollUntilVisible(
      finder,
      delta,
      scrollable: scrollable,
    );
    await tester.pumpAndSettle();
  }

  /// Take a screenshot (for debugging)
  Future<void> takeScreenshot(
    IntegrationTestWidgetsFlutterBinding binding,
    String name,
  ) async {
    await binding.takeScreenshot(name);
  }
}

/// Common finders for the app
class AppFinders {
  // Login screen
  static Finder get usernameField => find.byKey(const Key('username_field'));
  static Finder get passwordField => find.byKey(const Key('password_field'));
  static Finder get loginButton => find.byKey(const Key('login_button'));

  // Navigation
  static Finder get bottomNavBar => find.byType(NavigationBar);
  static Finder navItem(String label) => find.text(label);

  // Common widgets
  static Finder get loadingIndicator => find.byType(CircularProgressIndicator);
  static Finder get errorWidget => find.byIcon(Icons.error_outline);
  static Finder get refreshIndicator => find.byType(RefreshIndicator);
}
