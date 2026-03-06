import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_nepal/core/error/failures.dart';
import 'package:goal_nepal/core/services/sensors/biometric_service.dart';
import 'package:goal_nepal/features/auth/domain/entities/auth_entity.dart';
import 'package:goal_nepal/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:goal_nepal/features/auth/domain/usecases/login_usecase.dart';
import 'package:goal_nepal/features/auth/domain/usecases/register_usecase.dart';
import 'package:goal_nepal/features/auth/domain/usecases/upload_profilepicture_usecase.dart';
import 'package:goal_nepal/features/auth/presentation/pages/login_screen.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUsecase extends Mock implements LoginUsecase {}

class MockRegisterUsecase extends Mock implements RegisterUsecase {}

class MockGetCurrentUserUsecase extends Mock implements GetCurrentUserUsecase {}

class MockUploadProfilePictureUsecase extends Mock
    implements UploadProfilePictureUsecase {}

class MockBiometricService extends Mock implements BiometricService {}

void main() {
  late MockLoginUsecase mockLoginUsecase;
  late MockRegisterUsecase mockRegisterUsecase;
  late MockGetCurrentUserUsecase mockGetCurrentUserUsecase;
  late MockUploadProfilePictureUsecase mockUploadProfilePictureUsecase;
  late MockBiometricService mockBiometricService;

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
    mockBiometricService = MockBiometricService();

    when(
      () => mockBiometricService.isAvailable(),
    ).thenAnswer((_) async => false);
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
        biometricServiceProvider.overrideWithValue(mockBiometricService),
      ],
      child: MediaQuery(
        data: const MediaQueryData(size: Size(800, 1200)),
        child: const MaterialApp(home: LoginScreen()),
      ),
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

  Future<void> tapButton(WidgetTester tester) async {
    final button = find.byType(ElevatedButton);
    await tester.ensureVisible(button);
    await tester.tap(button);
  }

  group('LoginScreen - UI Elements', () {
    testWidgets('should display LOGIN title', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.text('LOGIN', skipOffstage: false), findsWidgets);
    });

    testWidgets('should have two text fields', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.byType(TextField), findsNWidgets(2));
    });

    testWidgets('should have email hint text', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.text('Enter your email'), findsOneWidget);
    });

    testWidgets('should have password hint text', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.text('Enter your password'), findsOneWidget);
    });

    testWidgets('should have email icon', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
    });

    testWidgets('should have lock icon', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    });

    testWidgets('should have Forgot Password text', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.text('Forgot Password?'), findsOneWidget);
    });

    testWidgets('should have LOGIN button', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.widgetWithText(ElevatedButton, 'LOGIN'), findsOneWidget);
    });

    testWidgets('should have "Don\'t have an account?" text', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.text("Don't have an account?"), findsOneWidget);
    });

    testWidgets('should have Sign Up text', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.text('  Sign Up'), findsOneWidget);
    });
  });

  group('LoginScreen - Text Input', () {
    testWidgets('should allow text input in email field', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      await tester.enterText(
        find.byType(TextField).first,
        'sthasantosh070@gmail.com',
      );
      await tester.pump();

      expect(find.text('sthasantosh070@gmail.com'), findsOneWidget);
    });

    testWidgets('should allow text input in password field', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      await tester.enterText(find.byType(TextField).last, 'password123');
      await tester.pump();

      final passwordField = tester.widget<TextField>(
        find.byType(TextField).last,
      );
      expect(passwordField.controller?.text, 'password123');
    });

    testWidgets('should accept both email and password input', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      await tester.enterText(
        find.byType(TextField).at(0),
        'sthasantosh070@gmail.com',
      );
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      await tester.pump();

      expect(find.text('sthasantosh070@gmail.com'), findsOneWidget);
    });
  });

  group('LoginScreen - Password Visibility', () {
    testWidgets('password field should be obscured by default', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final passwordField = tester.widget<TextField>(
        find.byType(TextField).last,
      );
      expect(passwordField.obscureText, isTrue);
    });

    testWidgets('should show visibility_off icon by default', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('should toggle password visibility when icon tapped', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(
        tester.widget<TextField>(find.byType(TextField).last).obscureText,
        isTrue,
      );

      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump();

      expect(
        tester.widget<TextField>(find.byType(TextField).last).obscureText,
        isFalse,
      );

      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pump();

      expect(
        tester.widget<TextField>(find.byType(TextField).last).obscureText,
        isTrue,
      );
    });
  });

  group('LoginScreen - Form Submission', () {
    testWidgets(
      'should call login usecase when fields are filled and submitted',
      (tester) async {
        ignoreImageErrors(tester);
        final completer = Completer<Either<Failure, AuthEntity>>();
        when(() => mockLoginUsecase(any())).thenAnswer((_) => completer.future);

        await tester.pumpWidget(createTestWidget());
        await tester.pump();

        await tester.enterText(
          find.byType(TextField).first,
          'sthasantosh070@gmail.com',
        );
        await tester.enterText(find.byType(TextField).last, 'password123');
        await tapButton(tester);
        await tester.pump();

        verify(() => mockLoginUsecase(any())).called(1);
      },
    );

    testWidgets('should show LOGGING IN... text while loading', (tester) async {
      ignoreImageErrors(tester);
      final completer = Completer<Either<Failure, AuthEntity>>();
      when(() => mockLoginUsecase(any())).thenAnswer((_) => completer.future);

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      await tester.enterText(
        find.byType(TextField).first,
        'sthasantosh070@gmail.com',
      );
      await tester.enterText(find.byType(TextField).last, 'password123');
      await tapButton(tester);
      await tester.pump();

      expect(find.text('LOGGING IN...'), findsOneWidget);
    });

    testWidgets('should not call login usecase when fields are empty', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      await tapButton(tester);
      await tester.pump();

      verifyNever(() => mockLoginUsecase(any()));
    });

    testWidgets('should call login with correct email and password params', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      final completer = Completer<Either<Failure, AuthEntity>>();
      LoginUsecaseParams? capturedParams;

      when(() => mockLoginUsecase(any())).thenAnswer((invocation) {
        capturedParams =
            invocation.positionalArguments[0] as LoginUsecaseParams;
        return completer.future;
      });

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      await tester.enterText(
        find.byType(TextField).first,
        'sthasantosh070@gmail.com',
      );
      await tester.enterText(find.byType(TextField).last, 'password123');
      await tapButton(tester);
      await tester.pump();

      expect(capturedParams?.email, 'sthasantosh070@gmail.com');
      expect(capturedParams?.password, 'password123');
    });

    testWidgets('should show error snackbar on login failure', (tester) async {
      ignoreImageErrors(tester);
      const tFailure = ApiFailure(message: 'Invalid email or password');
      when(
        () => mockLoginUsecase(any()),
      ).thenAnswer((_) async => const Left(tFailure));

      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      await tester.enterText(
        find.byType(TextField).first,
        'sthasantosh070@gmail.com',
      );
      await tester.enterText(find.byType(TextField).last, 'wrongpassword');
      await tapButton(tester);
      await tester.pumpAndSettle();

      expect(find.text('Invalid email or password'), findsOneWidget);
    });
  });
}
