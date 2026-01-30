import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_nepal/features/auth/presentation/pages/login_screen.dart';

void main() {
  testWidgets('should display LOGIN title', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: LoginScreen())),
    );
    await tester.pumpAndSettle();
    expect(find.text('LOGIN', skipOffstage: false), findsOneWidget);
  });

  testWidgets('should have email and password text fields', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: LoginScreen())),
    );
    await tester.pumpAndSettle();
    final fields = tester.widgetList(find.byType(TextField));
    expect(fields.length, 2);
  });

  testWidgets('should have email hint text', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: LoginScreen())),
    );
    await tester.pumpAndSettle();
    expect(find.text('Enter your email'), findsOneWidget);
  });

  testWidgets('should have password hint text', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: LoginScreen())),
    );
    await tester.pumpAndSettle();
    expect(find.text('Enter your password'), findsOneWidget);
  });

  testWidgets('should allow text input in email field', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: LoginScreen())),
    );
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextField).first,
      'sthasantosh070@gmail.com',
    );
    await tester.pumpAndSettle();
    expect(find.text('sthasantosh070@gmail.com'), findsOneWidget);
  });

  testWidgets('should allow text input in password field', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: LoginScreen())),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, 'password123');
    await tester.pumpAndSettle();
    expect(find.text('••••••••••••'), findsNothing);
  });

  testWidgets('password field should be obscured by default', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: LoginScreen())),
    );
    await tester.pumpAndSettle();
    final passwordField = tester.widget<TextField>(find.byType(TextField).last);
    expect(passwordField.obscureText, isTrue);
  });

  testWidgets('should toggle password visibility', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: LoginScreen())),
    );
    await tester.pumpAndSettle();
    expect(
      tester.widget<TextField>(find.byType(TextField).last).obscureText,
      isTrue,
    );
    await tester.tap(find.byIcon(Icons.visibility_off).first);
    await tester.pumpAndSettle();
    expect(
      tester.widget<TextField>(find.byType(TextField).last).obscureText,
      isFalse,
    );
    await tester.tap(find.byIcon(Icons.visibility).first);
    await tester.pumpAndSettle();
    expect(
      tester.widget<TextField>(find.byType(TextField).last).obscureText,
      isTrue,
    );
  });

  testWidgets('should have Forgot Password text', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: LoginScreen())),
    );
    await tester.pumpAndSettle();
    expect(find.text('Forgot Password?'), findsOneWidget);
  });

  testWidgets('should have LOGIN button', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: LoginScreen())),
    );
    await tester.pumpAndSettle();
    expect(find.widgetWithText(ElevatedButton, 'LOGIN'), findsOneWidget);
  });

  testWidgets('should have Sign Up text', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: LoginScreen())),
    );
    await tester.pumpAndSettle();
    expect(find.text('Sign Up'), findsOneWidget);
  });

  testWidgets('should have "Don\'t have an account?" text', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: LoginScreen())),
    );
    await tester.pumpAndSettle();
    expect(find.text("Don't have an account?"), findsOneWidget);
  });

  testWidgets('should have OR divider text', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: LoginScreen())),
    );
    await tester.pumpAndSettle();
    expect(find.text('OR'), findsOneWidget);
  });

  testWidgets('should have email icon', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: LoginScreen())),
    );
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.email_outlined), findsOneWidget);
  });

  testWidgets('should have lock icon', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: LoginScreen())),
    );
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.lock_outline), findsOneWidget);
  });

  testWidgets('should accept email and password input', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: LoginScreen())),
    );
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byType(TextField).at(0),
      'sthasantosh070@gmail.com',
    );
    await tester.enterText(find.byType(TextField).at(1), 'password123');
    await tester.pumpAndSettle();
    expect(find.text('sthasantosh070@gmail.com'), findsOneWidget);
  });
}
