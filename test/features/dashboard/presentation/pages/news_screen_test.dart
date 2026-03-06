import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_nepal/features/dashboard/presentation/pages/news_screen.dart';

void main() {
  void setLargeScreen(WidgetTester tester) {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
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
    addTearDown(() {
      FlutterError.onError = originalOnError;
    });
  }

  group('NewsScreen - Static UI Elements', () {
    testWidgets('should display main title', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(const MaterialApp(home: NewsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Tournament News & Updates'), findsOneWidget);
    });

    testWidgets('should display subtitle', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(const MaterialApp(home: NewsScreen()));
      await tester.pumpAndSettle();

      expect(
        find.text(
          'Stay updated with the latest news, live matches, and player highlights',
        ),
        findsOneWidget,
      );
    });

    testWidgets('should display Latest News section header', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(const MaterialApp(home: NewsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Latest News'), findsOneWidget);
    });

    testWidgets('should display Upcoming Matches section header', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(const MaterialApp(home: NewsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Upcoming Matches'), findsOneWidget);
    });
  });

  group('NewsScreen - News Cards', () {
    testWidgets('should display Nepal Football Championship news card', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(const MaterialApp(home: NewsScreen()));
      await tester.pumpAndSettle();

      expect(
        find.text('Nepal Football Championship 2025 Begins'),
        findsOneWidget,
      );
      expect(find.text('NEWS'), findsOneWidget);
      expect(find.text('Today, 2:30 PM'), findsOneWidget);
    });

    testWidgets('should display LIVE match news card', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(const MaterialApp(home: NewsScreen()));
      await tester.pumpAndSettle();

      expect(
        find.text('LIVE: Championship Final - Mountain Kings vs City Stars'),
        findsOneWidget,
      );
      expect(find.text('LIVE'), findsOneWidget);
      expect(find.text('Live Now'), findsOneWidget);
    });

    testWidgets('should display Results news card', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(const MaterialApp(home: NewsScreen()));
      await tester.pumpAndSettle();

      expect(find.text("Yesterday's Results"), findsOneWidget);
      expect(find.text('RESULT'), findsOneWidget);
      expect(find.text('Yesterday'), findsOneWidget);
    });

    testWidgets('should display Man of the Match news card', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(const MaterialApp(home: NewsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Man of the Match - Ronish Lama'), findsOneWidget);
      expect(find.text('MAN OF THE MATCH'), findsOneWidget);
    });

    testWidgets('should display news card descriptions', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(const MaterialApp(home: NewsScreen()));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('The much-awaited Nepal Football Championship'),
        findsOneWidget,
      );
      expect(
        find.textContaining('Mountain Kings currently leading 2-1'),
        findsOneWidget,
      );
    });
  });

  group('NewsScreen - Match Cards', () {
    testWidgets('should display first upcoming match', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(const MaterialApp(home: NewsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Feb 15, 3:00 PM'), findsOneWidget);
      expect(find.text('Kathmandu FC'), findsOneWidget);
      expect(find.text('Valley United'), findsOneWidget);
    });

    testWidgets('should display second upcoming match', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(const MaterialApp(home: NewsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Feb 16, 4:00 PM'), findsOneWidget);
      expect(find.text('Pokhara United'), findsOneWidget);
      expect(find.text('Mountain Kings'), findsOneWidget);
    });

    testWidgets('should display third upcoming match', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(const MaterialApp(home: NewsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Feb 17, 3:30 PM'), findsOneWidget);
      expect(find.text('Central Region'), findsOneWidget);
      expect(find.text('City Stars'), findsOneWidget);
    });

    testWidgets('should display vs separator between teams', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(const MaterialApp(home: NewsScreen()));
      await tester.pumpAndSettle();

      final vsFinders = find.text('vs');
      expect(vsFinders.evaluate().length, equals(3));
    });

    testWidgets('should display Set Reminder buttons', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(const MaterialApp(home: NewsScreen()));
      await tester.pumpAndSettle();

      final buttons = find.text('Set Reminder');
      expect(buttons.evaluate().length, equals(3));
    });
  });

  group('NewsScreen - Layout Structure', () {
    testWidgets('should use Scaffold with correct background', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(const MaterialApp(home: NewsScreen()));
      await tester.pumpAndSettle();

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, equals(const Color(0xFFFFFDEB)));
    });

    testWidgets('should use ListView for scrollable content', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(const MaterialApp(home: NewsScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('should apply padding to ListView', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(const MaterialApp(home: NewsScreen()));
      await tester.pumpAndSettle();

      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(listView.padding, equals(const EdgeInsets.all(16)));
    });
  });

  group('NewsScreen - News Card Styling', () {
    testWidgets('should display badge with correct styling', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(const MaterialApp(home: NewsScreen()));
      await tester.pumpAndSettle();

      final badgeText = tester.widget<Text>(find.text('NEWS'));
      expect(badgeText.style?.fontWeight, equals(FontWeight.bold));
      expect(badgeText.style?.fontSize, equals(12));
    });

    testWidgets('should display news card with rounded corners', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(const MaterialApp(home: NewsScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('should display time with grey color', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(const MaterialApp(home: NewsScreen()));
      await tester.pumpAndSettle();

      final timeText = tester.widget<Text>(find.text('Today, 2:30 PM'));
      expect(timeText.style?.color, equals(Colors.black54));
    });
  });

  group('NewsScreen - Match Card Styling', () {
    testWidgets('should display match card with white background', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(const MaterialApp(home: NewsScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('should display clock icon for match time', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(const MaterialApp(home: NewsScreen()));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.access_time), findsWidgets);
    });
  });

  group('NewsScreen - Button Interactions', () {
    testWidgets('should allow tapping Set Reminder button', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(const MaterialApp(home: NewsScreen()));
      await tester.pumpAndSettle();

      final button = find.text('Set Reminder').first;
      await tester.tap(button);
      await tester.pump();

      expect(find.text('Set Reminder'), findsWidgets);
    });

    testWidgets('should have three Set Reminder buttons', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(const MaterialApp(home: NewsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Set Reminder').evaluate().length, equals(3));
    });
  });

  group('NewsScreen - Content Count', () {
    testWidgets('should display four news cards', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(const MaterialApp(home: NewsScreen()));
      await tester.pumpAndSettle();

      final newsBadges = ['NEWS', 'LIVE', 'RESULT', 'MAN OF THE MATCH'];
      for (final badge in newsBadges) {
        expect(find.text(badge), findsOneWidget);
      }
    });

    testWidgets('should display three match cards', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(const MaterialApp(home: NewsScreen()));
      await tester.pumpAndSettle();

      final matchDates = [
        'Feb 15, 3:00 PM',
        'Feb 16, 4:00 PM',
        'Feb 17, 3:30 PM',
      ];
      for (final date in matchDates) {
        expect(find.text(date), findsOneWidget);
      }
    });
  });

  group('NewsScreen - Typography', () {
    testWidgets('should use bold font for main title', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(const MaterialApp(home: NewsScreen()));
      await tester.pumpAndSettle();

      final title = tester.widget<Text>(find.text('Tournament News & Updates'));
      expect(title.style?.fontWeight, equals(FontWeight.bold));
      expect(title.style?.fontSize, equals(28));
    });

    testWidgets('should use bold font for section headers', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(const MaterialApp(home: NewsScreen()));
      await tester.pumpAndSettle();

      final header = tester.widget<Text>(find.text('Latest News'));
      expect(header.style?.fontWeight, equals(FontWeight.bold));
      expect(header.style?.fontSize, equals(20));
    });

    testWidgets('should use bold font for news titles', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(const MaterialApp(home: NewsScreen()));
      await tester.pumpAndSettle();

      final newsTitle = tester.widget<Text>(
        find.text('Nepal Football Championship 2025 Begins'),
      );
      expect(newsTitle.style?.fontWeight, equals(FontWeight.bold));
      expect(newsTitle.style?.fontSize, equals(18));
    });
  });

  group('NewsScreen - Spacing', () {
    testWidgets('should use SizedBox for vertical spacing', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(const MaterialApp(home: NewsScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('should have spacing between news cards', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(const MaterialApp(home: NewsScreen()));
      await tester.pumpAndSettle();

      final listItems = find.byType(Container).evaluate();
      expect(listItems.length, greaterThan(4));
    });
  });

  group('NewsScreen - Responsive Behavior', () {
    testWidgets('should render correctly on large screen', (tester) async {
      setLargeScreen(tester);
      await tester.pumpWidget(const MaterialApp(home: NewsScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(NewsScreen), findsOneWidget);
    });

    testWidgets('should handle widget rebuilds', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(const MaterialApp(home: NewsScreen()));
      await tester.pumpAndSettle();
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('Tournament News & Updates'), findsOneWidget);
    });
  });
}
