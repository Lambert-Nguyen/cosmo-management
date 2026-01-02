import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cosmo_app/features/auth/screens/register_screen.dart';
import 'package:cosmo_app/core/providers/service_providers.dart';
import 'package:cosmo_app/core/services/auth_service.dart';

void main() {
  group('RegisterScreen widget', () {
    late AuthService mockAuthService;

    setUp(() {
      mockAuthService = AuthService();
    });

    Widget createTestWidget({String? initialInviteCode}) {
      return ProviderScope(
        overrides: [
          authServiceProvider.overrideWithValue(mockAuthService),
        ],
        child: MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(800, 1200)),
            child: RegisterScreen(initialInviteCode: initialInviteCode),
          ),
        ),
      );
    }

    testWidgets('should display invite code step initially', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Enter Invite Code'), findsOneWidget);
      expect(find.text('Welcome to Cosmo'), findsOneWidget);
    });

    testWidgets('should have invite code text field', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Invite Code'), findsOneWidget);
    });

    testWidgets('should have continue button', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('should display step indicator', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Invite'), findsOneWidget);
      expect(find.text('Account'), findsOneWidget);
    });

    testWidgets('should have back button in app bar', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });
  });

  group('RegisterStep enum', () {
    test('should have inviteCode value', () {
      expect(RegisterStep.inviteCode, isNotNull);
      expect(RegisterStep.inviteCode.name, 'inviteCode');
    });

    test('should have accountDetails value', () {
      expect(RegisterStep.accountDetails, isNotNull);
      expect(RegisterStep.accountDetails.name, 'accountDetails');
    });

    test('should have two values', () {
      expect(RegisterStep.values, hasLength(2));
    });
  });

  group('UpperCaseTextFormatter', () {
    test('should convert text to uppercase', () {
      final formatter = UpperCaseTextFormatter();
      const oldValue = TextEditingValue(text: '');
      const newValue = TextEditingValue(
        text: 'hello',
        selection: TextSelection.collapsed(offset: 5),
      );

      final result = formatter.formatEditUpdate(oldValue, newValue);

      expect(result.text, 'HELLO');
      expect(result.selection.baseOffset, 5);
    });

    test('should preserve selection position', () {
      final formatter = UpperCaseTextFormatter();
      const oldValue = TextEditingValue(text: 'AB');
      const newValue = TextEditingValue(
        text: 'ABc',
        selection: TextSelection.collapsed(offset: 3),
      );

      final result = formatter.formatEditUpdate(oldValue, newValue);

      expect(result.text, 'ABC');
      expect(result.selection.baseOffset, 3);
    });

    test('should handle empty text', () {
      final formatter = UpperCaseTextFormatter();
      const oldValue = TextEditingValue(text: 'A');
      const newValue = TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );

      final result = formatter.formatEditUpdate(oldValue, newValue);

      expect(result.text, '');
    });

    test('should handle already uppercase text', () {
      final formatter = UpperCaseTextFormatter();
      const oldValue = TextEditingValue(text: '');
      const newValue = TextEditingValue(
        text: 'HELLO',
        selection: TextSelection.collapsed(offset: 5),
      );

      final result = formatter.formatEditUpdate(oldValue, newValue);

      expect(result.text, 'HELLO');
    });

    test('should handle mixed case text', () {
      final formatter = UpperCaseTextFormatter();
      const oldValue = TextEditingValue(text: '');
      const newValue = TextEditingValue(
        text: 'HeLLo WoRLd',
        selection: TextSelection.collapsed(offset: 11),
      );

      final result = formatter.formatEditUpdate(oldValue, newValue);

      expect(result.text, 'HELLO WORLD');
    });
  });
}
