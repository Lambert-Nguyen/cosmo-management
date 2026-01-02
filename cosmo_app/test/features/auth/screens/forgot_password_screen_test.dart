import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cosmo_app/features/auth/screens/forgot_password_screen.dart';
import 'package:cosmo_app/core/providers/service_providers.dart';
import 'package:cosmo_app/core/services/auth_service.dart';

void main() {
  group('ForgotPasswordScreen', () {
    late AuthService mockAuthService;

    setUp(() {
      mockAuthService = AuthService();
    });

    Widget createTestWidget() {
      return ProviderScope(
        overrides: [
          authServiceProvider.overrideWithValue(mockAuthService),
        ],
        child: const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(800, 1200)),
            child: ForgotPasswordScreen(),
          ),
        ),
      );
    }

    testWidgets('should display initial email form', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Forgot Password?'), findsOneWidget);
      expect(
        find.text(
          'Enter your email address and we\'ll send you instructions to reset your password.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('should have email text field', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Enter your email address'), findsOneWidget);
    });

    testWidgets('should have send reset link button', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Send Reset Link'), findsOneWidget);
    });

    testWidgets('should have back to sign in link', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Back to Sign In'), findsOneWidget);
    });

    testWidgets('should have back button in app bar', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // One in app bar leading, one in "Back to Sign In" button
      expect(find.byIcon(Icons.arrow_back), findsNWidgets(2));
    });

    testWidgets('should have Reset Password as app bar title', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Reset Password'), findsOneWidget);
    });

    testWidgets('should display lock_reset icon', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.lock_reset), findsOneWidget);
    });

    testWidgets('should validate empty email', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Tap send without entering email
      await tester.tap(find.text('Send Reset Link'));
      await tester.pumpAndSettle();

      expect(find.text('Email is required'), findsOneWidget);
    });

    testWidgets('should validate invalid email format', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enter invalid email
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter your email address'),
        'invalid-email',
      );
      await tester.tap(find.text('Send Reset Link'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('should accept valid email', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // Enter valid email
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter your email address'),
        'test@example.com',
      );
      await tester.pumpAndSettle();

      // Should not show validation error
      expect(find.text('Email is required'), findsNothing);
      expect(find.text('Please enter a valid email'), findsNothing);
    });

    testWidgets('should have email icon prefix', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
    });
  });

  group('ForgotPasswordScreen - Form Validation', () {
    Widget createTestWidget() {
      return ProviderScope(
        overrides: [
          authServiceProvider.overrideWithValue(AuthService()),
        ],
        child: const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(size: Size(800, 1200)),
            child: ForgotPasswordScreen(),
          ),
        ),
      );
    }

    testWidgets('should validate email with spaces', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter your email address'),
        'test @example.com',
      );
      await tester.tap(find.text('Send Reset Link'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('should validate email without domain', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter your email address'),
        'test@',
      );
      await tester.tap(find.text('Send Reset Link'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('should validate email without TLD', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter your email address'),
        'test@example',
      );
      await tester.tap(find.text('Send Reset Link'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('should accept email with subdomain', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter your email address'),
        'test@mail.example.com',
      );
      // Just check that it can be entered
      expect(find.text('test@mail.example.com'), findsOneWidget);
    });
  });
}
