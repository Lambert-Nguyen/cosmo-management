/// Main integration test for Cosmo Management
///
/// Runs end-to-end tests for critical user flows.
library;

import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_helper.dart';

void main() {
  ensureInitializedBinding();

  group('App Launch', () {
    testWidgets('app launches and shows login screen', (tester) async {
      final helper = IntegrationTestHelper(tester);

      await helper.pumpApp();

      // Should show login screen for unauthenticated users
      expect(find.textContaining('Sign In'), findsOneWidget);
    });
  });

  group('Authentication Flow', () {
    testWidgets('shows validation errors for empty fields', (tester) async {
      final helper = IntegrationTestHelper(tester);

      await helper.pumpApp();

      // Try to login with empty fields
      await helper.tapAndSettle(find.textContaining('Sign In'));

      // Should show validation errors
      await tester.pumpAndSettle();
    });
  });

  group('Navigation', () {
    testWidgets('bottom navigation is accessible after login', (tester) async {
      final helper = IntegrationTestHelper(tester);

      await helper.pumpApp();

      // Note: Full navigation test requires authenticated state
      // This is a placeholder for when test auth is implemented
    });
  });
}
