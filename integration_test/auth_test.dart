import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_nepal/core/services/hive/hive_service.dart';
import 'package:goal_nepal/core/services/sensors/biometric_service.dart';
import 'package:goal_nepal/core/services/storage/user_session_service.dart';
import 'package:goal_nepal/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:goal_nepal/features/auth/domain/usecases/login_usecase.dart';
import 'package:goal_nepal/features/auth/domain/usecases/register_usecase.dart';
import 'package:goal_nepal/features/auth/domain/usecases/upload_profilepicture_usecase.dart';
import 'package:goal_nepal/features/auth/presentation/pages/login_screen.dart';
import 'package:goal_nepal/features/auth/presentation/pages/register_screen.dart';
import 'package:goal_nepal/features/auth/presentation/state/auth_state.dart';
import 'package:goal_nepal/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockLoginUsecase extends Mock implements LoginUsecase {}

class MockRegisterUsecase extends Mock implements RegisterUsecase {}

class MockGetCurrentUserUsecase extends Mock implements GetCurrentUserUsecase {}

class MockUploadProfilePictureUsecase extends Mock
    implements UploadProfilePictureUsecase {}

class MockBiometricService extends Mock implements BiometricService {}

class FakeAuthViewModel extends AuthViewModel {
  @override
  AuthState build() => const AuthState(status: AuthStatus.initial);

  @override
  Future<void> getCurrentUser() async {}

  @override
  Future<void> login({required String email, required String password}) async {}

  @override
  Future<void> register({
    required String fullname,
    required String email,
    required String password,
  }) async {}
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Auth Integration Tests', () {
    late SharedPreferences sharedPreferences;
    late HiveService hiveService;
    late MockBiometricService mockBiometricService;

    setUpAll(() async {
      hiveService = HiveService();
      await hiveService.init();
      SharedPreferences.setMockInitialValues({});
      sharedPreferences = await SharedPreferences.getInstance();
    });

    tearDownAll(() async {
      await hiveService.close();
    });

    setUp(() {
      mockBiometricService = MockBiometricService();
      when(
        () => mockBiometricService.isAvailable(),
      ).thenAnswer((_) async => false);
    });

    group('Login Screen Integration Tests', () {
      Widget createLoginScreen() {
        return ProviderScope(
          overrides: [
            hiveServiceProvider.overrideWithValue(hiveService),
            sharedPreferencesProvider.overrideWithValue(sharedPreferences),
            loginUsecaseProvider.overrideWithValue(MockLoginUsecase()),
            registerUsecaseProvider.overrideWithValue(MockRegisterUsecase()),
            getCurrentUserUsecaseProvider.overrideWithValue(
              MockGetCurrentUserUsecase(),
            ),
            uploadProfilePictureUsecaseProvider.overrideWithValue(
              MockUploadProfilePictureUsecase(),
            ),
            biometricServiceProvider.overrideWithValue(mockBiometricService),
            authViewModelProvider.overrideWith(() => FakeAuthViewModel()),
          ],
          child: const MaterialApp(home: LoginScreen()),
        );
      }

      testWidgets('Login screen should display LOGIN title', (tester) async {
        await tester.pumpWidget(createLoginScreen());
        await tester.pumpAndSettle();

        expect(find.text('LOGIN'), findsWidgets);
      });

      testWidgets('Login screen should display 2 TextFields', (tester) async {
        await tester.pumpWidget(createLoginScreen());
        await tester.pumpAndSettle();

        expect(find.byType(TextField), findsNWidgets(2));
      });

      testWidgets('Login screen should display email hint', (tester) async {
        await tester.pumpWidget(createLoginScreen());
        await tester.pumpAndSettle();

        expect(find.text('Enter your email'), findsOneWidget);
      });

      testWidgets('Login screen should display password hint', (tester) async {
        await tester.pumpWidget(createLoginScreen());
        await tester.pumpAndSettle();

        expect(find.text('Enter your password'), findsOneWidget);
      });

      testWidgets('Login screen should display Forgot Password text', (
        tester,
      ) async {
        await tester.pumpWidget(createLoginScreen());
        await tester.pumpAndSettle();

        expect(find.text('Forgot Password?'), findsOneWidget);
      });

      testWidgets('Login screen should display LOGIN button', (tester) async {
        await tester.pumpWidget(createLoginScreen());
        await tester.pumpAndSettle();

        expect(find.text('LOGIN'), findsWidgets);
      });

      testWidgets('Login screen should display Sign Up link', (tester) async {
        await tester.pumpWidget(createLoginScreen());
        await tester.pumpAndSettle();

        expect(find.text('  Sign Up'), findsOneWidget);
      });

      testWidgets('Login screen should allow email text entry', (tester) async {
        await tester.pumpWidget(createLoginScreen());
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byType(TextField).first,
          'santosh.shrestha@email.com',
        );
        await tester.pump();

        expect(find.text('santosh.shrestha@email.com'), findsOneWidget);
      });

      testWidgets('Login screen should allow password text entry', (
        tester,
      ) async {
        await tester.pumpWidget(createLoginScreen());
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField).last, 'santosh@123');
        await tester.pump();

        final passwordField = tester.widget<TextField>(
          find.byType(TextField).last,
        );
        expect(passwordField.controller?.text, 'santosh@123');
      });

      testWidgets('Login screen should toggle password visibility', (
        tester,
      ) async {
        await tester.pumpWidget(createLoginScreen());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.visibility_off), findsOneWidget);

        await tester.tap(find.byIcon(Icons.visibility_off));
        await tester.pump();

        expect(find.byIcon(Icons.visibility), findsOneWidget);
      });

      testWidgets('Login screen should show error when fields are empty', (
        tester,
      ) async {
        await tester.pumpWidget(createLoginScreen());
        await tester.pumpAndSettle();

        await tester.tap(find.text('LOGIN').last);
        await tester.pump();

        expect(find.byType(SnackBar), findsOneWidget);
      });

      testWidgets('Login screen should accept valid credentials input', (
        tester,
      ) async {
        await tester.pumpWidget(createLoginScreen());
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byType(TextField).first,
          'santosh.shrestha@email.com',
        );
        await tester.enterText(find.byType(TextField).last, 'santosh@123');
        await tester.pump();

        expect(find.text('santosh.shrestha@email.com'), findsOneWidget);
        final passwordField = tester.widget<TextField>(
          find.byType(TextField).last,
        );
        expect(passwordField.controller?.text, 'santosh@123');
      });
    });

    group('Register Screen Integration Tests', () {
      Widget createRegisterScreen() {
        return ProviderScope(
          overrides: [
            hiveServiceProvider.overrideWithValue(hiveService),
            sharedPreferencesProvider.overrideWithValue(sharedPreferences),
            loginUsecaseProvider.overrideWithValue(MockLoginUsecase()),
            registerUsecaseProvider.overrideWithValue(MockRegisterUsecase()),
            getCurrentUserUsecaseProvider.overrideWithValue(
              MockGetCurrentUserUsecase(),
            ),
            uploadProfilePictureUsecaseProvider.overrideWithValue(
              MockUploadProfilePictureUsecase(),
            ),
            authViewModelProvider.overrideWith(() => FakeAuthViewModel()),
          ],
          child: const MaterialApp(home: RegisterScreen()),
        );
      }

      testWidgets('Register screen should display Register title', (
        tester,
      ) async {
        await tester.pumpWidget(createRegisterScreen());
        await tester.pumpAndSettle();

        expect(find.text('Register'), findsOneWidget);
      });

      testWidgets('Register screen should display 4 TextFields', (
        tester,
      ) async {
        await tester.pumpWidget(createRegisterScreen());
        await tester.pumpAndSettle();

        expect(find.byType(TextField), findsNWidgets(4));
      });

      testWidgets('Register screen should display Full Name hint', (
        tester,
      ) async {
        await tester.pumpWidget(createRegisterScreen());
        await tester.pumpAndSettle();

        expect(find.text('Full Name'), findsOneWidget);
      });

      testWidgets('Register screen should display Email hint', (tester) async {
        await tester.pumpWidget(createRegisterScreen());
        await tester.pumpAndSettle();

        expect(find.text('Email'), findsOneWidget);
      });

      testWidgets('Register screen should display Password hint', (
        tester,
      ) async {
        await tester.pumpWidget(createRegisterScreen());
        await tester.pumpAndSettle();

        expect(find.text('Password'), findsOneWidget);
      });

      testWidgets('Register screen should display Confirm Password hint', (
        tester,
      ) async {
        await tester.pumpWidget(createRegisterScreen());
        await tester.pumpAndSettle();

        expect(find.text('Confirm Password'), findsOneWidget);
      });

      testWidgets('Register screen should display SIGN UP button', (
        tester,
      ) async {
        await tester.pumpWidget(createRegisterScreen());
        await tester.pumpAndSettle();

        expect(find.text('SIGN UP'), findsOneWidget);
      });

      testWidgets('Register screen should display LOG IN link', (tester) async {
        await tester.pumpWidget(createRegisterScreen());
        await tester.pumpAndSettle();

        expect(find.text('  LOG IN'), findsOneWidget);
      });

      testWidgets('Register screen should allow full name entry', (
        tester,
      ) async {
        await tester.pumpWidget(createRegisterScreen());
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byType(TextField).first,
          'Santosh Shrestha',
        );
        await tester.pump();

        expect(find.text('Santosh Shrestha'), findsOneWidget);
      });

      testWidgets('Register screen should allow email entry', (tester) async {
        await tester.pumpWidget(createRegisterScreen());
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byType(TextField).at(1),
          'santosh.shrestha@email.com',
        );
        await tester.pump();

        expect(find.text('santosh.shrestha@email.com'), findsOneWidget);
      });

      testWidgets('Register screen should allow password entry', (
        tester,
      ) async {
        await tester.pumpWidget(createRegisterScreen());
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField).at(2), 'santosh@123');
        await tester.pump();

        final passwordField = tester.widget<TextField>(
          find.byType(TextField).at(2),
        );
        expect(passwordField.controller?.text, 'santosh@123');
      });

      testWidgets('Register screen should allow confirm password entry', (
        tester,
      ) async {
        await tester.pumpWidget(createRegisterScreen());
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField).at(3), 'santosh@123');
        await tester.pump();

        final confirmField = tester.widget<TextField>(
          find.byType(TextField).at(3),
        );
        expect(confirmField.controller?.text, 'santosh@123');
      });

      testWidgets('Register screen should toggle password visibility', (
        tester,
      ) async {
        await tester.pumpWidget(createRegisterScreen());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.visibility_off), findsWidgets);

        await tester.tap(find.byIcon(Icons.visibility_off).first);
        await tester.pump();

        expect(find.byIcon(Icons.visibility), findsOneWidget);
      });

      testWidgets('Register screen should show error when fields are empty', (
        tester,
      ) async {
        await tester.pumpWidget(createRegisterScreen());
        await tester.pumpAndSettle();

        await tester.tap(find.text('SIGN UP'));
        await tester.pump();

        expect(find.byType(SnackBar), findsOneWidget);
      });

      testWidgets('Register screen should fill all fields successfully', (
        tester,
      ) async {
        await tester.pumpWidget(createRegisterScreen());
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byType(TextField).first,
          'Santosh Shrestha',
        );
        await tester.enterText(
          find.byType(TextField).at(1),
          'santosh.shrestha@email.com',
        );
        await tester.enterText(find.byType(TextField).at(2), 'santosh@123');
        await tester.enterText(find.byType(TextField).at(3), 'santosh@123');
        await tester.pump();

        expect(find.text('Santosh Shrestha'), findsOneWidget);
        expect(find.text('santosh.shrestha@email.com'), findsOneWidget);
      });

      group('User Session Integration Tests', () {
        testWidgets('User should not be logged in with empty preferences', (
          tester,
        ) async {
          SharedPreferences.setMockInitialValues({});
          final prefs = await SharedPreferences.getInstance();
          final sessionService = UserSessionService(prefs: prefs);

          expect(sessionService.isUserLoggedIn(), isFalse);
        });

        testWidgets('User should be logged in after saving session', (
          tester,
        ) async {
          SharedPreferences.setMockInitialValues({});
          final prefs = await SharedPreferences.getInstance();
          final sessionService = UserSessionService(prefs: prefs);

          await sessionService.saveUserSession(
            authId: 'santosh_id_001',
            email: 'santosh.shrestha@email.com',
            fullName: 'Santosh Shrestha',
          );

          expect(sessionService.isUserLoggedIn(), isTrue);
          expect(sessionService.getEmail(), 'santosh.shrestha@email.com');
          expect(sessionService.getFullName(), 'Santosh Shrestha');
          expect(sessionService.getAuthId(), 'santosh_id_001');
        });

        testWidgets('User should not be logged in after clearing session', (
          tester,
        ) async {
          SharedPreferences.setMockInitialValues({
            'is_logged_in': true,
            'auth_id': 'santosh_id_001',
            'email': 'santosh.shrestha@email.com',
            'full_name': 'Santosh Shrestha',
          });
          final prefs = await SharedPreferences.getInstance();
          final sessionService = UserSessionService(prefs: prefs);

          expect(sessionService.isUserLoggedIn(), isTrue);

          await sessionService.clearUserSession();

          expect(sessionService.isUserLoggedIn(), isFalse);
          expect(sessionService.getEmail(), isNull);
          expect(sessionService.getFullName(), isNull);
          expect(sessionService.getAuthId(), isNull);
        });

        testWidgets('Profile image should be null when not set', (
          tester,
        ) async {
          SharedPreferences.setMockInitialValues({});
          final prefs = await SharedPreferences.getInstance();
          final sessionService = UserSessionService(prefs: prefs);

          expect(sessionService.getProfileImage(), isNull);
        });

        testWidgets('Profile image should be saved and retrieved', (
          tester,
        ) async {
          SharedPreferences.setMockInitialValues({});
          final prefs = await SharedPreferences.getInstance();
          final sessionService = UserSessionService(prefs: prefs);

          await sessionService.saveUserSession(
            authId: 'santosh_id_001',
            email: 'santosh.shrestha@email.com',
            fullName: 'Santosh Shrestha',
            profileImage: 'assets/images/profile.png',
          );

          expect(sessionService.getProfileImage(), 'assets/images/profile.png');
        });
      });
    });
  });
}
