import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_nepal/features/splash/presentation/pages/splash_screen.dart';
import 'package:goal_nepal/core/services/storage/user_session_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockUserSessionService extends Mock implements UserSessionService {}

void main() {
  late MockUserSessionService mockUserSessionService;
  late SharedPreferences sharedPreferences;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    sharedPreferences = await SharedPreferences.getInstance();
  });

  setUp(() {
    mockUserSessionService = MockUserSessionService();
    when(() => mockUserSessionService.isUserLoggedIn()).thenReturn(false);
  });

  void ignoreImageErrors(WidgetTester tester) {
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.exception is Exception &&
          details.exception.toString().contains('Unable to load asset')) {
        return;
      }
      originalOnError?.call(details);
    };
    addTearDown(() {
      FlutterError.onError = originalOnError;
    });
  }

  Widget createTestWidget({bool isLoggedIn = false}) {
    when(() => mockUserSessionService.isUserLoggedIn()).thenReturn(isLoggedIn);

    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        userSessionServiceProvider.overrideWithValue(mockUserSessionService),
      ],
      child: const MaterialApp(home: SplashScreen()),
    );
  }

  group('SplashScreen - UI Elements', () {
    testWidgets('should display scaffold with blueGrey background', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(seconds: 4));

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, equals(Colors.blueGrey));
    });

    testWidgets('should display logo image', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(seconds: 4));

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should display app tagline', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(seconds: 4));

      expect(find.text('Where Every Goal Counts'), findsOneWidget);
    });

    testWidgets('should center content vertically', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(seconds: 4));

      expect(find.byType(Center), findsOneWidget);
      final column = tester.widget<Column>(find.byType(Column).first);
      expect(column.mainAxisAlignment, equals(MainAxisAlignment.center));
    });
  });

  group('SplashScreen - Text Styling', () {
    testWidgets('should use correct font size for tagline', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(seconds: 4));

      final tagline = tester.widget<Text>(find.text('Where Every Goal Counts'));
      expect(tagline.style?.fontSize, equals(28));
    });

    testWidgets('should use bold font for tagline', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(seconds: 4));

      final tagline = tester.widget<Text>(find.text('Where Every Goal Counts'));
      expect(tagline.style?.fontWeight, equals(FontWeight.bold));
    });

    testWidgets('should use black color for tagline', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(seconds: 4));

      final tagline = tester.widget<Text>(find.text('Where Every Goal Counts'));
      expect(tagline.style?.color, equals(Colors.black));
    });

    testWidgets('should use letter spacing for tagline', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(seconds: 4));

      final tagline = tester.widget<Text>(find.text('Where Every Goal Counts'));
      expect(tagline.style?.letterSpacing, equals(1.5));
    });
  });

  group('SplashScreen - Navigation Logic', () {
    testWidgets('should verify login check is called once', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createTestWidget(isLoggedIn: false));
      await tester.pump(const Duration(seconds: 3));
      await tester.pump(const Duration(seconds: 1));

      verify(() => mockUserSessionService.isUserLoggedIn()).called(1);
    });
  });

  group('SplashScreen - Widget Lifecycle', () {
    testWidgets('should handle widget unmount during navigation delay', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createTestWidget(isLoggedIn: true));
      await tester.pumpAndSettle();

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(seconds: 4));
    });
  });

  group('SplashScreen - Responsive Design', () {
    testWidgets('should display content centered on screen', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(seconds: 4));

      expect(find.byType(Center), findsOneWidget);
    });
  });

  group('SplashScreen - Edge Cases', () {
    testWidgets('should not crash if navigation is cancelled', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(seconds: 4));
    });
  });

  group('SplashScreen - Asset Loading', () {
    testWidgets('should attempt to load logo asset', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(seconds: 4));

      final image = tester.widget<Image>(find.byType(Image));
      expect(image.image, isNotNull);
    });
  });
}
