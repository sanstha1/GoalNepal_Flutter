import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_nepal/core/error/failures.dart';
import 'package:goal_nepal/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:goal_nepal/features/auth/domain/usecases/login_usecase.dart';
import 'package:goal_nepal/features/auth/domain/usecases/register_usecase.dart';
import 'package:goal_nepal/features/auth/domain/usecases/upload_profilepicture_usecase.dart';
import 'package:goal_nepal/features/auth/presentation/pages/register_screen.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUsecase extends Mock implements LoginUsecase {}

class MockRegisterUsecase extends Mock implements RegisterUsecase {}

class MockGetCurrentUserUsecase extends Mock implements GetCurrentUserUsecase {}

class MockUploadProfilePictureUsecase extends Mock
    implements UploadProfilePictureUsecase {}

void main() {
  late MockLoginUsecase mockLoginUsecase;
  late MockRegisterUsecase mockRegisterUsecase;
  late MockGetCurrentUserUsecase mockGetCurrentUserUsecase;
  late MockUploadProfilePictureUsecase mockUploadProfilePictureUsecase;

  setUpAll(() {
    registerFallbackValue(
      const LoginUsecaseParams(
        email: 'fallback@email.com',
        password: 'fallback',
      ),
    );
    registerFallbackValue(
      const RegisterUsecaseParams(
        fullname: 'fallback',
        email: 'fallback@email.com',
        password: 'fallback',
      ),
    );
  });

  setUp(() {
    mockLoginUsecase = MockLoginUsecase();
    mockRegisterUsecase = MockRegisterUsecase();
    mockGetCurrentUserUsecase = MockGetCurrentUserUsecase();
    mockUploadProfilePictureUsecase = MockUploadProfilePictureUsecase();
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        loginUsecaseProvider.overrideWithValue(mockLoginUsecase),
        registerUsecaseProvider.overrideWithValue(mockRegisterUsecase),
        getCurrentUserUsecaseProvider.overrideWithValue(
          mockGetCurrentUserUsecase,
        ),
        uploadProfilePictureUsecaseProvider.overrideWithValue(
          mockUploadProfilePictureUsecase,
        ),
      ],
      child: const MaterialApp(home: RegisterScreen()),
    );
  }

  void ignoreImageErrors(WidgetTester tester) {
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.exception is Exception &&
          details.exception.toString().contains('Unable to load asset')) {
        return;
      }
      originalOnError?.call(details);
    };
  }

  void setLargeScreen(WidgetTester tester) {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
  }

  Future<void> tapSignUpButton(WidgetTester tester) async {
    final finder = find.byType(ElevatedButton);
    await tester.ensureVisible(finder);
    await tester.tap(finder, warnIfMissed: false);
  }

  Future<void> tapIcon(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.tap(finder, warnIfMissed: false);
  }

  group('RegisterScreen - UI Elements', () {
    testWidgets('should display Register title', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.text('Register', skipOffstage: false), findsOneWidget);
    });

    testWidgets('should have four text fields', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.byType(TextField), findsNWidgets(4));
    });

    testWidgets('should have Full Name hint text', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.text('Full Name'), findsOneWidget);
    });

    testWidgets('should have Email hint text', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.text('Email'), findsOneWidget);
    });

    testWidgets('should have Password hint text', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('should have Confirm Password hint text', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.text('Confirm Password'), findsOneWidget);
    });

    testWidgets('should have person icon', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    });

    testWidgets('should have email icon', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
    });

    testWidgets('should have lock icons', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.byIcon(Icons.lock_outline), findsNWidgets(2));
    });

    testWidgets('should have SIGN UP button', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.widgetWithText(ElevatedButton, 'SIGN UP'), findsOneWidget);
    });

    testWidgets('should have "Already have an account?" text', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.text('Already have an account?'), findsOneWidget);
    });

    testWidgets('should have LOG IN text', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.text('  LOG IN'), findsOneWidget);
    });
  });

  group('RegisterScreen - Text Input', () {
    testWidgets('should allow text input in full name field', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      await tester.enterText(find.byType(TextField).at(0), 'Santosh Shrestha');
      await tester.pump();

      expect(find.text('Santosh Shrestha'), findsOneWidget);
    });

    testWidgets('should allow text input in email field', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      await tester.enterText(
        find.byType(TextField).at(1),
        'santosh.shrestha@email.com',
      );
      await tester.pump();

      expect(find.text('santosh.shrestha@email.com'), findsOneWidget);
    });

    testWidgets('should allow text input in password field', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      await tester.enterText(find.byType(TextField).at(2), 'santosh@123');
      await tester.pump();

      final passwordField = tester.widget<TextField>(
        find.byType(TextField).at(2),
      );
      expect(passwordField.controller?.text, 'santosh@123');
    });

    testWidgets('should allow text input in confirm password field', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      await tester.enterText(find.byType(TextField).at(3), 'santosh@123');
      await tester.pump();

      final confirmField = tester.widget<TextField>(
        find.byType(TextField).at(3),
      );
      expect(confirmField.controller?.text, 'santosh@123');
    });
  });

  group('RegisterScreen - Password Visibility', () {
    testWidgets('password field should be obscured by default', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final passwordField = tester.widget<TextField>(
        find.byType(TextField).at(2),
      );
      expect(passwordField.obscureText, isTrue);
    });

    testWidgets('confirm password field should be obscured by default', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final confirmField = tester.widget<TextField>(
        find.byType(TextField).at(3),
      );
      expect(confirmField.obscureText, isTrue);
    });

    testWidgets('should show two visibility_off icons by default', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.byIcon(Icons.visibility_off), findsNWidgets(2));
    });

    testWidgets('should toggle password visibility when icon tapped', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(
        tester.widget<TextField>(find.byType(TextField).at(2)).obscureText,
        isTrue,
      );

      await tapIcon(tester, find.byIcon(Icons.visibility_off).first);
      await tester.pump();

      expect(
        tester.widget<TextField>(find.byType(TextField).at(2)).obscureText,
        isFalse,
      );

      await tapIcon(tester, find.byIcon(Icons.visibility).first);
      await tester.pump();

      expect(
        tester.widget<TextField>(find.byType(TextField).at(2)).obscureText,
        isTrue,
      );
    });

    testWidgets('should toggle confirm password visibility when icon tapped', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(
        tester.widget<TextField>(find.byType(TextField).at(3)).obscureText,
        isTrue,
      );

      await tapIcon(tester, find.byIcon(Icons.visibility_off).last);
      await tester.pump();

      expect(
        tester.widget<TextField>(find.byType(TextField).at(3)).obscureText,
        isFalse,
      );

      await tapIcon(tester, find.byIcon(Icons.visibility).last);
      await tester.pump();

      expect(
        tester.widget<TextField>(find.byType(TextField).at(3)).obscureText,
        isTrue,
      );
    });
  });

  group('RegisterScreen - Form Validation', () {
    testWidgets('should show error when fields are empty', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      await tapSignUpButton(tester);
      await tester.pumpAndSettle();

      expect(find.text('Please fill all fields'), findsOneWidget);
    });

    testWidgets('should show error when passwords do not match', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      await tester.enterText(find.byType(TextField).at(0), 'Santosh Shrestha');
      await tester.enterText(
        find.byType(TextField).at(1),
        'santosh.shrestha@email.com',
      );
      await tester.enterText(find.byType(TextField).at(2), 'santosh@123');
      await tester.enterText(find.byType(TextField).at(3), 'wrongpassword');
      await tester.pump();
      await tapSignUpButton(tester);
      await tester.pumpAndSettle();

      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets('should not call register usecase when fields are empty', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      await tapSignUpButton(tester);
      await tester.pump();

      verifyNever(() => mockRegisterUsecase(any()));
    });

    testWidgets(
      'should not call register usecase when passwords do not match',
      (tester) async {
        ignoreImageErrors(tester);
        setLargeScreen(tester);
        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        await tester.enterText(
          find.byType(TextField).at(0),
          'Santosh Shrestha',
        );
        await tester.enterText(
          find.byType(TextField).at(1),
          'santosh.shrestha@email.com',
        );
        await tester.enterText(find.byType(TextField).at(2), 'santosh@123');
        await tester.enterText(find.byType(TextField).at(3), 'wrongpassword');
        await tester.pump();
        await tapSignUpButton(tester);
        await tester.pump();

        verifyNever(() => mockRegisterUsecase(any()));
      },
    );
  });

  group('RegisterScreen - Form Submission', () {
    testWidgets('should show SIGNING UP... text while loading', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      final completer = Completer<Either<Failure, bool>>();
      when(
        () => mockRegisterUsecase(any()),
      ).thenAnswer((_) => completer.future);

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      await tester.enterText(find.byType(TextField).at(0), 'Santosh Shrestha');
      await tester.enterText(
        find.byType(TextField).at(1),
        'santosh.shrestha@email.com',
      );
      await tester.enterText(find.byType(TextField).at(2), 'santosh@123');
      await tester.enterText(find.byType(TextField).at(3), 'santosh@123');
      await tester.pump();
      await tapSignUpButton(tester);
      await tester.pump();

      expect(find.text('SIGNING UP...'), findsOneWidget);

      completer.complete(const Right(true));
      await tester.pumpAndSettle(const Duration(seconds: 3));
    });
  });
}
