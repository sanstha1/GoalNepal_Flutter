import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_nepal/features/dashboard/presentation/pages/saved_screen.dart';

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

  group('SavedScreen - Static UI Elements', () {
    testWidgets('should display Saved Tournaments title', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(
        ProviderScope(child: const MaterialApp(home: SavedScreen())),
      );
      await tester.pumpAndSettle();

      expect(find.text('Saved Tournaments'), findsOneWidget);
    });

    testWidgets('should display subtitle with zero count', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(
        ProviderScope(child: const MaterialApp(home: SavedScreen())),
      );
      await tester.pumpAndSettle();

      expect(find.text('You have 0 saved tournaments'), findsOneWidget);
    });

    testWidgets('should display search field with hint', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(
        ProviderScope(child: const MaterialApp(home: SavedScreen())),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Search tournaments...'), findsOneWidget);
    });

    testWidgets('should show empty state message', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(
        ProviderScope(child: const MaterialApp(home: SavedScreen())),
      );
      await tester.pumpAndSettle();

      expect(find.text('No saved tournaments yet'), findsOneWidget);
    });
  });

  group('SavedScreen - Layout Structure', () {
    testWidgets('should use CustomScrollView', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(
        ProviderScope(child: const MaterialApp(home: SavedScreen())),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CustomScrollView), findsOneWidget);
    });

    testWidgets('should have pinned search header', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(
        ProviderScope(child: const MaterialApp(home: SavedScreen())),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SliverPersistentHeader), findsOneWidget);
    });

    testWidgets('should use SafeArea wrapper', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(
        ProviderScope(child: const MaterialApp(home: SavedScreen())),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SafeArea), findsOneWidget);
    });

    testWidgets('should use SliverPadding for content', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(
        ProviderScope(child: const MaterialApp(home: SavedScreen())),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SliverPadding), findsWidgets);
    });
  });

  group('SavedScreen - Header Styling', () {
    testWidgets('should use bold font for main title', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(
        ProviderScope(child: const MaterialApp(home: SavedScreen())),
      );
      await tester.pumpAndSettle();

      final title = tester.widget<Text>(find.text('Saved Tournaments'));
      expect(title.style?.fontWeight, equals(FontWeight.bold));
      expect(title.style?.fontSize, equals(28));
    });

    testWidgets('should use smaller font for subtitle', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(
        ProviderScope(child: const MaterialApp(home: SavedScreen())),
      );
      await tester.pumpAndSettle();

      final subtitle = tester.widget<Text>(
        find.text('You have 0 saved tournaments'),
      );
      expect(subtitle.style?.fontSize, equals(14));
    });
  });

  group('SavedScreen - Search Field Styling', () {
    testWidgets('should have rounded search field border', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(
        ProviderScope(child: const MaterialApp(home: SavedScreen())),
      );
      await tester.pumpAndSettle();

      final textField = tester.widget<TextField>(find.byType(TextField));
      final border = textField.decoration?.border as OutlineInputBorder?;
      expect(border?.borderRadius, isNotNull);
    });

    testWidgets('should have white background for search field', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(
        ProviderScope(child: const MaterialApp(home: SavedScreen())),
      );
      await tester.pumpAndSettle();

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.decoration?.filled, isTrue);
      expect(textField.decoration?.fillColor, equals(Colors.white));
    });

    testWidgets('should display search icon', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(
        ProviderScope(child: const MaterialApp(home: SavedScreen())),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('should have no border side on search field', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(
        ProviderScope(child: const MaterialApp(home: SavedScreen())),
      );
      await tester.pumpAndSettle();

      final textField = tester.widget<TextField>(find.byType(TextField));
      final border = textField.decoration?.border as OutlineInputBorder?;
      expect(border?.borderSide, equals(BorderSide.none));
    });
  });

  group('SavedScreen - Search Input', () {
    testWidgets('should allow text entry in search field', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(
        ProviderScope(child: const MaterialApp(home: SavedScreen())),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Football');
      await tester.pump();

      expect(find.text('Football'), findsOneWidget);
    });

    testWidgets('should clear search input', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(
        ProviderScope(child: const MaterialApp(home: SavedScreen())),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Test');
      await tester.pump();
      await tester.enterText(find.byType(TextField), '');
      await tester.pump();

      expect(find.text('Test'), findsNothing);
    });
  });

  group('SavedScreen - Empty State', () {
    testWidgets('should not show grid when empty', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(
        ProviderScope(child: const MaterialApp(home: SavedScreen())),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SliverGrid), findsNothing);
    });

    testWidgets('should show empty message with correct font size', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(
        ProviderScope(child: const MaterialApp(home: SavedScreen())),
      );
      await tester.pumpAndSettle();

      final text = tester.widget<Text>(find.text('No saved tournaments yet'));
      expect(text.style?.fontSize, equals(16));
    });
  });

  group('SavedScreen - Widget Hierarchy', () {
    testWidgets('should use Column for header section', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(
        ProviderScope(child: const MaterialApp(home: SavedScreen())),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('should use SizedBox for spacing', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(
        ProviderScope(child: const MaterialApp(home: SavedScreen())),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SizedBox), findsWidgets);
    });
  });

  group('SavedScreen - Responsive Behavior', () {
    testWidgets('should render on large screen', (tester) async {
      setLargeScreen(tester);
      await tester.pumpWidget(
        ProviderScope(child: const MaterialApp(home: SavedScreen())),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SavedScreen), findsOneWidget);
    });

    testWidgets('should render on default screen size', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(
        ProviderScope(child: const MaterialApp(home: SavedScreen())),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
    });
  });

  group('SavedScreen - Navigation Safety', () {
    testWidgets('should not crash on widget rebuild', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(
        ProviderScope(child: const MaterialApp(home: SavedScreen())),
      );
      await tester.pumpAndSettle();
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('Saved Tournaments'), findsOneWidget);
    });

    testWidgets('should handle theme changes', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(home: SavedScreen(), theme: ThemeData.light()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SavedScreen), findsOneWidget);
    });
  });
}
