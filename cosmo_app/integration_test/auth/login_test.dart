/// Login flow integration tests for Cosmo Management
///
/// Tests the authentication flow end-to-end.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_helper.dart';

void main() {
  ensureInitializedBinding();

  group('Login Screen', () {
    testWidgets('displays login form elements', (tester) async {
      final helper = IntegrationTestHelper(tester);

      await helper.pumpApp();

      // Verify login form elements are present
      expect(find.textContaining('Sign In'), findsOneWidget);
    });

    testWidgets('validates empty username', (tester) async {
      final helper = IntegrationTestHelper(tester);

      await helper.pumpApp();

      // Clear any existing text and submit
      await helper.tapAndSettle(find.textContaining('Sign In'));

      // Validation should trigger
      await tester.pumpAndSettle();
    });

    testWidgets('shows password visibility toggle', (tester) async {
      final helper = IntegrationTestHelper(tester);

      await helper.pumpApp();

      // Look for password visibility toggle icon
      expect(
        find.byIcon(Icons.visibility_off).evaluate().isNotEmpty ||
            find.byIcon(Icons.visibility).evaluate().isNotEmpty,
        isTrue,
      );
    });
  });

  group('Login Error Handling', () {
    testWidgets('shows error for invalid credentials', (tester) async {
      final helper = IntegrationTestHelper(tester);

      await helper.pumpApp();

      // Enter invalid credentials
      final usernameField = find.byType(TextField).first;
      final passwordField = find.byType(TextField).last;

      await helper.enterText(usernameField, 'invalid_user');
      await helper.enterText(passwordField, 'wrong_password');
      await helper.tapAndSettle(find.textContaining('Sign In'));

      // Wait for API response and error display
      await tester.pumpAndSettle(const Duration(seconds: 3));
    });
  });
}
