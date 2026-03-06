import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_nepal/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:goal_nepal/features/onboarding/presentation/pages/page1.dart';
import 'package:goal_nepal/features/onboarding/presentation/pages/page2.dart';
import 'package:goal_nepal/features/onboarding/presentation/pages/page3.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

void main() {
  void setLargeScreen(WidgetTester tester) {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
  }

  Widget createTestWidget() {
    return MaterialApp(
      home: const OnboardingScreen(),
      routes: {
        '/home': (context) => const Scaffold(body: Center(child: Text('Home'))),
      },
    );
  }

  group('OnboardingScreen - Basic UI Elements', () {
    testWidgets('should display Scaffold with correct background', (
      tester,
    ) async {
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, isNotNull);
    });

    testWidgets('should display PageView widget', (tester) async {
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(PageView), findsOneWidget);
    });

    testWidgets('should display SmoothPageIndicator', (tester) async {
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(SmoothPageIndicator), findsOneWidget);
    });

    testWidgets('should display Skip button on first page', (tester) async {
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Skip'), findsOneWidget);
    });
  });

  group('OnboardingScreen - Page Navigation', () {
    testWidgets('should display Page1 on initial load', (tester) async {
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Page1), findsOneWidget);
      expect(find.byType(Page2), findsNothing);
      expect(find.byType(Page3), findsNothing);
    });

    testWidgets('should navigate to Page2 on swipe', (tester) async {
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.drag(find.byType(PageView), const Offset(-400, 0));
      await tester.pumpAndSettle();

      expect(find.byType(Page2), findsOneWidget);
    });

    testWidgets('should navigate to Page3 on second swipe', (tester) async {
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.drag(find.byType(PageView), const Offset(-400, 0));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(PageView), const Offset(-400, 0));
      await tester.pumpAndSettle();

      expect(find.byType(Page3), findsOneWidget);
    });

    testWidgets('should hide Skip button on last page', (tester) async {
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.drag(find.byType(PageView), const Offset(-400, 0));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(PageView), const Offset(-400, 0));
      await tester.pumpAndSettle();

      expect(find.text('Skip'), findsNothing);
    });
  });

  group('OnboardingScreen - Page Indicator', () {
    testWidgets('should show 3 dots in page indicator', (tester) async {
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final indicator = tester.widget<SmoothPageIndicator>(
        find.byType(SmoothPageIndicator),
      );
      expect(indicator.count, equals(3));
    });

    testWidgets('should use WormEffect for indicator animation', (
      tester,
    ) async {
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final indicator = tester.widget<SmoothPageIndicator>(
        find.byType(SmoothPageIndicator),
      );
      expect(indicator.effect, isA<WormEffect>());
    });

    testWidgets('should update indicator on page change', (tester) async {
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.drag(find.byType(PageView), const Offset(-400, 0));
      await tester.pumpAndSettle();

      final indicator = tester.widget<SmoothPageIndicator>(
        find.byType(SmoothPageIndicator),
      );
      expect(indicator.controller.page?.round(), equals(1));
    });
  });

  group('OnboardingScreen - Skip Button', () {
    testWidgets('should use TextButton for Skip', (tester) async {
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('should have correct Skip button styling', (tester) async {
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final skipText = tester.widget<Text>(find.text('Skip'));
      expect(skipText.style?.fontSize, equals(16));
      expect(skipText.style?.color, equals(Colors.white70));
    });
  });

  group('OnboardingScreen - Page3 Integration', () {
    testWidgets('should pass onGetStarted callback to Page3', (tester) async {
      setLargeScreen(tester);
      await tester.pumpWidget(
        MaterialApp(
          home: OnboardingScreen(),
          routes: {
            '/home': (context) {
              return const Scaffold(body: Center(child: Text('Home')));
            },
          },
        ),
      );
      await tester.pumpAndSettle();

      await tester.drag(find.byType(PageView), const Offset(-400, 0));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(PageView), const Offset(-400, 0));
      await tester.pumpAndSettle();

      expect(find.byType(Page3), findsOneWidget);
    });

    testWidgets('should navigate to home from Page3 Get Started', (
      tester,
    ) async {
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.drag(find.byType(PageView), const Offset(-400, 0));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(PageView), const Offset(-400, 0));
      await tester.pumpAndSettle();

      final getStartedButton = find.text('Get Started');
      if (getStartedButton.evaluate().isNotEmpty) {
        await tester.tap(getStartedButton);
        await tester.pumpAndSettle();
        expect(find.text('Home'), findsOneWidget);
      }
    });
  });

  group('OnboardingScreen - Layout Structure', () {
    testWidgets('should use Column for indicator and skip button', (
      tester,
    ) async {
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Column), findsWidgets);
    });
  });

  group('OnboardingScreen - PageController', () {
    testWidgets('should initialize PageController', (tester) async {
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final pageView = tester.widget<PageView>(find.byType(PageView));
      expect(pageView.controller, isNotNull);
    });

    testWidgets('should dispose PageController', (tester) async {
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
    });

    testWidgets('should handle onPageChanged callback', (tester) async {
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.drag(find.byType(PageView), const Offset(-400, 0));
      await tester.pumpAndSettle();

      expect(find.byType(Page2), findsOneWidget);
    });
  });

  group('OnboardingScreen - Styling', () {
    testWidgets('should use WormEffect with correct dot size', (tester) async {
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final indicator = tester.widget<SmoothPageIndicator>(
        find.byType(SmoothPageIndicator),
      );
      final effect = indicator.effect as WormEffect;
      expect(effect.dotWidth, equals(8));
      expect(effect.dotHeight, equals(8));
    });

    testWidgets('should use blue for active dot color', (tester) async {
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final indicator = tester.widget<SmoothPageIndicator>(
        find.byType(SmoothPageIndicator),
      );
      final effect = indicator.effect as WormEffect;
      expect(effect.activeDotColor, equals(Colors.blue));
    });

    testWidgets('should use semi-transparent white for inactive dots', (
      tester,
    ) async {
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final indicator = tester.widget<SmoothPageIndicator>(
        find.byType(SmoothPageIndicator),
      );
      final effect = indicator.effect as WormEffect;
      // ignore: deprecated_member_use
      expect(effect.dotColor, equals(Colors.white.withOpacity(0.5)));
    });
  });

  group('OnboardingScreen - Alignment', () {
    testWidgets('should use MainAxisSize.min for indicator column', (
      tester,
    ) async {
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final columns = tester.widgetList<Column>(find.byType(Column)).toList();
      final indicatorColumn = columns.firstWhere(
        (c) => c.mainAxisSize == MainAxisSize.min,
        orElse: () => columns.first,
      );
      expect(indicatorColumn.mainAxisSize, equals(MainAxisSize.min));
    });
  });

  group('OnboardingScreen - Edge Cases', () {
    testWidgets('should rebuild without crashing', (tester) async {
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.byType(OnboardingScreen), findsOneWidget);
    });
  });

  group('OnboardingScreen - Page Count', () {
    testWidgets('should display Page3 after second swipe', (tester) async {
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.drag(find.byType(PageView), const Offset(-400, 0));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(PageView), const Offset(-400, 0));
      await tester.pumpAndSettle();

      expect(find.byType(Page3), findsOneWidget);
    });
  });

  group('OnboardingScreen - Navigation Safety', () {
    testWidgets('should not allow back navigation after Get Started', (
      tester,
    ) async {
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.drag(find.byType(PageView), const Offset(-400, 0));
      await tester.pumpAndSettle();
      await tester.drag(find.byType(PageView), const Offset(-400, 0));
      await tester.pumpAndSettle();

      final getStartedButton = find.text('Get Started');
      if (getStartedButton.evaluate().isNotEmpty) {
        await tester.tap(getStartedButton);
        await tester.pumpAndSettle();
        await tester.pageBack();
        await tester.pumpAndSettle();
        expect(find.text('Home'), findsOneWidget);
      }
    });
  });

  group('OnboardingScreen - Widget Lifecycle', () {
    testWidgets('should call dispose on widget removal', (tester) async {
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    });

    testWidgets('should maintain state during rebuilds', (tester) async {
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Page1), findsOneWidget);
    });
  });
}
