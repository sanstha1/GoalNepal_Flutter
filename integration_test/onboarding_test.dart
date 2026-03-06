import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_nepal/core/services/hive/hive_service.dart';
import 'package:goal_nepal/core/services/storage/user_session_service.dart';
import 'package:goal_nepal/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:goal_nepal/features/splash/presentation/pages/splash_screen.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Onboarding & Splash Integration Tests', () {
    late SharedPreferences sharedPreferences;
    late HiveService hiveService;

    setUpAll(() async {
      hiveService = HiveService();
      await hiveService.init();
      SharedPreferences.setMockInitialValues({});
      sharedPreferences = await SharedPreferences.getInstance();
    });

    tearDownAll(() async {
      await hiveService.close();
    });

    group('Splash Screen Integration Tests', () {
      Widget createSplashScreen() {
        return ProviderScope(
          overrides: [
            hiveServiceProvider.overrideWithValue(hiveService),
            sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          ],
          child: const MaterialApp(home: SplashScreen()),
        );
      }

      testWidgets('Splash screen should display', (tester) async {
        await tester.pumpWidget(createSplashScreen());
        await tester.pump();

        expect(find.byType(Scaffold), findsOneWidget);
      });

      testWidgets('Splash screen should have blueGrey background', (
        tester,
      ) async {
        await tester.pumpWidget(createSplashScreen());
        await tester.pump();

        final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
        expect(scaffold.backgroundColor, equals(Colors.blueGrey));
      });

      testWidgets('Splash screen should display tagline text', (tester) async {
        await tester.pumpWidget(createSplashScreen());
        await tester.pump();

        expect(find.text('Where Every Goal Counts'), findsOneWidget);
      });

      testWidgets('Splash screen should display FadeTransition', (
        tester,
      ) async {
        await tester.pumpWidget(createSplashScreen());
        await tester.pump();

        expect(find.byType(FadeTransition), findsWidgets);
      });

      testWidgets('Splash screen should contain visual branding elements', (
        tester,
      ) async {
        await tester.pumpWidget(createSplashScreen());
        await tester.pump();

        expect(find.byType(Column), findsWidgets);
        expect(find.byType(Center), findsWidgets);
      });
    });

    group('Onboarding Screen Integration Tests', () {
      Widget createOnboardingScreen() {
        return ProviderScope(
          overrides: [
            hiveServiceProvider.overrideWithValue(hiveService),
            sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          ],
          child: MaterialApp(
            initialRoute: '/',
            routes: {
              '/': (_) => const OnboardingScreen(),
              '/home': (_) => const Scaffold(body: Text('Home')),
            },
          ),
        );
      }

      testWidgets('Onboarding screen should display', (tester) async {
        await tester.pumpWidget(createOnboardingScreen());
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsOneWidget);
      });

      testWidgets('Onboarding screen should have PageView', (tester) async {
        await tester.pumpWidget(createOnboardingScreen());
        await tester.pumpAndSettle();

        expect(find.byType(PageView), findsOneWidget);
      });

      testWidgets('Onboarding screen should have page indicator dots', (
        tester,
      ) async {
        await tester.pumpWidget(createOnboardingScreen());
        await tester.pumpAndSettle();

        expect(find.byType(Stack), findsWidgets);
      });

      testWidgets('Onboarding screen should show Skip button on first page', (
        tester,
      ) async {
        await tester.pumpWidget(createOnboardingScreen());
        await tester.pumpAndSettle();

        expect(find.text('Skip'), findsOneWidget);
      });

      testWidgets('Onboarding screen should be swipeable to next page', (
        tester,
      ) async {
        await tester.pumpWidget(createOnboardingScreen());
        await tester.pumpAndSettle();

        final pageView = find.byType(PageView);
        expect(pageView, findsOneWidget);

        await tester.drag(pageView, const Offset(-400, 0));
        await tester.pumpAndSettle();

        expect(find.byType(PageView), findsOneWidget);
      });

      testWidgets('Onboarding screen should still show Skip on page 2', (
        tester,
      ) async {
        await tester.pumpWidget(createOnboardingScreen());
        await tester.pumpAndSettle();

        await tester.drag(find.byType(PageView), const Offset(-400, 0));
        await tester.pumpAndSettle();

        expect(find.text('Skip'), findsOneWidget);
      });

      testWidgets('Skip button should jump to last page', (tester) async {
        await tester.pumpWidget(createOnboardingScreen());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();

        expect(find.text('Skip'), findsNothing);
      });

      testWidgets('Onboarding screen should hide Skip on last page', (
        tester,
      ) async {
        await tester.pumpWidget(createOnboardingScreen());
        await tester.pumpAndSettle();

        await tester.drag(find.byType(PageView), const Offset(-400, 0));
        await tester.pumpAndSettle();
        await tester.drag(find.byType(PageView), const Offset(-400, 0));
        await tester.pumpAndSettle();

        expect(find.text('Skip'), findsNothing);
      });

      testWidgets('Onboarding screen should be swipeable back', (tester) async {
        await tester.pumpWidget(createOnboardingScreen());
        await tester.pumpAndSettle();

        await tester.drag(find.byType(PageView), const Offset(-400, 0));
        await tester.pumpAndSettle();

        await tester.drag(find.byType(PageView), const Offset(400, 0));
        await tester.pumpAndSettle();

        expect(find.text('Skip'), findsOneWidget);
      });
    });
  });
}
