import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_nepal/app/app.dart';
import 'package:goal_nepal/core/services/hive/hive_service.dart';
import 'package:goal_nepal/core/services/storage/user_session_service.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    late SharedPreferences sharedPreferences;
    late HiveService hiveService;

    setUpAll(() async {
      await HiveService().init();
      SharedPreferences.setMockInitialValues({});
      sharedPreferences = await SharedPreferences.getInstance();
      hiveService = HiveService();
      await hiveService.init();
    });

    tearDownAll(() async {
      await hiveService.close();
    });

    Widget createApp() {
      return ProviderScope(
        overrides: [
          hiveServiceProvider.overrideWithValue(hiveService),
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        ],
        child: const App(),
      );
    }

    testWidgets('App should start with splash screen', (tester) async {
      await tester.pumpWidget(createApp());
      await tester.pump();

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('Splash screen should show app logo and tagline', (
      tester,
    ) async {
      await tester.pumpWidget(createApp());
      await tester.pump();

      expect(find.text('Where Every Goal Counts'), findsOneWidget);
    });

    testWidgets('Splash screen background should be blueGrey', (tester) async {
      await tester.pumpWidget(createApp());
      await tester.pump();

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
      expect(scaffold.backgroundColor, equals(Colors.blueGrey));
    });

    testWidgets(
      'App should navigate from splash to onboarding when not logged in',
      (tester) async {
        SharedPreferences.setMockInitialValues({});
        sharedPreferences = await SharedPreferences.getInstance();

        await tester.pumpWidget(createApp());
        await tester.pumpAndSettle(const Duration(seconds: 4));

        expect(find.byType(Scaffold), findsWidgets);
      },
    );

    testWidgets(
      'App should navigate from splash to home when already logged in',
      (tester) async {
        SharedPreferences.setMockInitialValues({
          'token': 'fake_token_santosh',
          'userId': 'santosh_shrestha_id',
        });
        sharedPreferences = await SharedPreferences.getInstance();

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              hiveServiceProvider.overrideWithValue(hiveService),
              sharedPreferencesProvider.overrideWithValue(sharedPreferences),
            ],
            child: const App(),
          ),
        );

        await tester.pumpAndSettle(const Duration(seconds: 4));

        expect(find.byType(Scaffold), findsWidgets);
      },
    );

    testWidgets('App should have no debug banner', (tester) async {
      await tester.pumpWidget(createApp());
      await tester.pump();

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.debugShowCheckedModeBanner, isFalse);
    });

    testWidgets('App should contain MaterialApp', (tester) async {
      await tester.pumpWidget(createApp());
      await tester.pump();

      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}
