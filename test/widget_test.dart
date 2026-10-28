import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haunted_signup_mansion/main.dart';

void main() {
  Future<void> openSignupForm(WidgetTester tester) async {
    await tester.pumpWidget(const HauntedMansionApp());
    await tester.tap(find.text('Enter If You Dare'));
    await tester.pumpAndSettle();
  }

  testWidgets('opens the animated welcome screen first', (tester) async {
    await tester.pumpWidget(const HauntedMansionApp());

    expect(find.text('Sign the guest book… if you dare.'), findsOneWidget);
    expect(find.text('Enter If You Dare'), findsOneWidget);
  });

  testWidgets('opens the Activity 10 starter form from the foyer', (
    tester,
  ) async {
    await openSignupForm(tester);

    expect(find.text('Create Your Account'), findsOneWidget);
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Email Address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);
  });

  testWidgets('shows all required errors for empty input', (tester) async {
    await openSignupForm(tester);
    await tester.tap(find.text('Sign Up'));
    await tester.pump();

    expect(find.text('Please enter your name'), findsOneWidget);
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter a password'), findsOneWidget);
  });

  testWidgets('rejects an invalid email and short password', (tester) async {
    await openSignupForm(tester);
    await tester.enterText(find.byType(EditableText).at(0), 'Morgan');
    await tester.enterText(
      find.byType(EditableText).at(1),
      'morgan.example.com',
    );
    await tester.enterText(find.byType(EditableText).at(2), '12345');
    await tester.tap(find.text('Sign Up'));
    await tester.pump();

    expect(find.text('Please enter a valid email'), findsOneWidget);
    expect(find.text('Password must be at least 6 characters'), findsOneWidget);
  });

  testWidgets('accepts valid starter-form input', (tester) async {
    await openSignupForm(tester);
    await tester.enterText(find.byType(EditableText).at(0), 'Morgan');
    await tester.enterText(
      find.byType(EditableText).at(1),
      'morgan@example.com',
    );
    await tester.enterText(find.byType(EditableText).at(2), 'secret1');
    await tester.tap(find.text('Sign Up'));
    await tester.pump();

    expect(
      find.text('Demo signup complete — your form passed validation!'),
      findsOneWidget,
    );
  });
}
