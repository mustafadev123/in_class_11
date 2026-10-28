import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haunted_signup_mansion/main.dart';
import 'package:haunted_signup_mansion/screens/signup_screen.dart';
import 'package:haunted_signup_mansion/screens/success_screen.dart';

void main() {
  Future<void> openSignupForm(WidgetTester tester) async {
    await tester.pumpWidget(const HauntedMansionApp());
    await tester.tap(find.text('Enter If You Dare'));
    await tester.pumpAndSettle();
  }

  Future<void> fillValidSignup(WidgetTester tester) async {
    await tester.enterText(find.byType(EditableText).at(0), 'Morgan');
    await tester.enterText(
      find.byType(EditableText).at(1),
      'morgan@example.com',
    );
    await tester.enterText(find.byType(EditableText).at(2), 'secret1');
    await tester.ensureVisible(find.byType(TextFormField).at(3));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(TextFormField).at(3));
    await tester.pumpAndSettle();
    await tester.tap(find.text('15').last);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
  }

  testWidgets('opens the animated welcome screen first', (tester) async {
    await tester.pumpWidget(const HauntedMansionApp());

    expect(find.text('Sign the guest book… if you dare.'), findsOneWidget);
    expect(find.text('Enter If You Dare'), findsOneWidget);
  });

  testWidgets('opens the enhanced Activity 10 form from the foyer', (
    tester,
  ) async {
    await openSignupForm(tester);

    expect(find.text('Create Your Haunted Pass'), findsOneWidget);
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Birth Date'), findsOneWidget);
    expect(find.text('Join the Mansion'), findsOneWidget);
  });

  testWidgets('shows all required errors for empty input', (tester) async {
    await openSignupForm(tester);
    await tester.tap(find.text('Join the Mansion'));
    await tester.pump();

    expect(find.text('Please enter your name'), findsOneWidget);
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter a password'), findsOneWidget);
    expect(find.text('Pick your birth date'), findsOneWidget);
  });

  testWidgets('rejects an invalid email and short password', (tester) async {
    await openSignupForm(tester);
    await tester.enterText(find.byType(EditableText).at(0), 'Morgan');
    await tester.enterText(
      find.byType(EditableText).at(1),
      'morgan.example.com',
    );
    await tester.enterText(find.byType(EditableText).at(2), '12345');
    await tester.tap(find.text('Join the Mansion'));
    await tester.pump();

    expect(find.text('Please enter a valid email'), findsOneWidget);
    expect(find.text('Password must be at least 6 characters'), findsOneWidget);
  });

  testWidgets('password visibility button toggles obscuring', (tester) async {
    await openSignupForm(tester);
    TextField passwordField = tester.widget<TextField>(
      find.byType(TextField).at(2),
    );
    expect(passwordField.obscureText, isTrue);

    await tester.tap(find.byTooltip('Show password'));
    await tester.pump();

    passwordField = tester.widget<TextField>(find.byType(TextField).at(2));
    expect(passwordField.obscureText, isFalse);
    expect(find.byTooltip('Hide password'), findsOneWidget);
  });

  testWidgets('valid signup loads and opens personalized success', (
    tester,
  ) async {
    await openSignupForm(tester);
    await fillValidSignup(tester);

    await tester.tap(find.text('Join the Mansion'));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pump();
    expect(find.text('Welcome, Morgan!'), findsOneWidget);
    expect(find.text('Back to the Foyer'), findsOneWidget);
  });

  testWidgets('empty success name returns to the foyer', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: SuccessScreen(userName: '   ')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Enter If You Dare'), findsOneWidget);
    expect(find.text('Welcome, !'), findsNothing);
  });

  testWidgets('rapid double-tap creates only one success screen', (
    tester,
  ) async {
    await openSignupForm(tester);
    await fillValidSignup(tester);

    final submitButton = find.text('Join the Mansion');
    await tester.tap(submitButton);
    await tester.tap(submitButton);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pump();
    expect(find.text('Welcome, Morgan!'), findsOneWidget);
    expect(find.byType(SuccessScreen), findsOneWidget);
  });

  testWidgets('leaving during loading does not navigate after disposal', (
    tester,
  ) async {
    await openSignupForm(tester);
    await fillValidSignup(tester);
    await tester.tap(find.text('Join the Mansion'));
    await tester.pump();

    Navigator.of(tester.element(find.byType(SignupScreen))).pop();
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 2));
    await tester.pump();

    expect(find.text('Enter If You Dare'), findsOneWidget);
    expect(find.byType(SuccessScreen), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
