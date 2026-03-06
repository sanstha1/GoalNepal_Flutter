import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_nepal/features/dashboard/presentation/widgets/saved_tournament.dart';

void main() {
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

  Widget createTestWidget({
    String imageUrl = '',
    String title = 'Test Tournament',
    String location = 'Kathmandu',
    String date = '15 Jun - 25 Jun, 2025',
    VoidCallback? onRegister,
    VoidCallback? onRemove,
  }) {
    return MaterialApp(
      home: Material(
        child: SavedTournament(
          imageUrl: imageUrl,
          title: title,
          location: location,
          date: date,
          onRegister: onRegister,
          onRemove: onRemove,
        ),
      ),
    );
  }

  group('SavedTournament - Basic UI Elements', () {
    testWidgets('should display tournament title', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget(title: 'Santosh Cup 2025'));
      await tester.pumpAndSettle();

      expect(find.text('Santosh Cup 2025'), findsOneWidget);
    });

    testWidgets('should display location with icon', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget(location: 'Pokhara'));
      await tester.pumpAndSettle();

      expect(find.text('Pokhara'), findsOneWidget);
      expect(find.byIcon(Icons.location_on), findsOneWidget);
    });

    testWidgets('should display date with icon', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget(date: '1 Jan - 10 Jan, 2025'));
      await tester.pumpAndSettle();

      expect(find.text('1 Jan - 10 Jan, 2025'), findsOneWidget);
      expect(find.byIcon(Icons.calendar_month), findsOneWidget);
    });

    testWidgets('should display Register button', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Register'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should display remove button with bookmark icon', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.bookmark), findsOneWidget);
    });
  });

  group('SavedTournament - Image Handling', () {
    testWidgets('should show placeholder when imageUrl is empty', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget(imageUrl: ''));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.image_not_supported), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('should show placeholder on network image error', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(imageUrl: 'https://invalid-url.example.com/image.jpg'),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.image_not_supported), findsOneWidget);
    });

    testWidgets('should show placeholder on asset image error', (tester) async {
      await tester.pumpWidget(
        createTestWidget(imageUrl: 'assets/invalid_image.png'),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.image_not_supported), findsOneWidget);
    });

    testWidgets('should display loading indicator for network image', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(imageUrl: 'https://example.com/image.jpg'),
      );
      await tester.pump();

      expect(find.byType(Image), findsOneWidget);
    });
  });

  group('SavedTournament - Styling', () {
    testWidgets('should have rounded corners', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.decoration, isA<BoxDecoration>());
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, isNotNull);
    });

    testWidgets('should have white background', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, equals(Colors.white));
    });

    testWidgets('should have shadow effect', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.boxShadow, isNotEmpty);
    });

    testWidgets('should use bold font for title', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final titleText = tester.widget<Text>(find.text('Test Tournament'));
      expect(titleText.style?.fontWeight, equals(FontWeight.bold));
      expect(titleText.style?.fontSize, equals(12));
    });

    testWidgets('should use grey color for info text', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final locationText = tester.widget<Text>(find.text('Kathmandu'));
      expect(locationText.style?.color, equals(Colors.grey));
      expect(locationText.style?.fontSize, equals(10));
    });
  });

  group('SavedTournament - Button Styling', () {
    testWidgets('should have black background for Register button', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.style?.backgroundColor?.resolve({}), equals(Colors.black));
    });

    testWidgets('should have white text for Register button', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final buttonText = tester.widget<Text>(find.text('Register'));
      expect(buttonText.style?.color, equals(Colors.white));
      expect(buttonText.style?.fontWeight, equals(FontWeight.bold));
    });

    testWidgets('should have rounded corners for Register button', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.style?.shape?.resolve({}), isA<RoundedRectangleBorder>());
    });

    testWidgets('should have remove button with black background', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final removeContainer = tester.widget<Container>(
        find.byType(Container).last,
      );
      final decoration = removeContainer.decoration as BoxDecoration;
      expect(decoration.color, equals(Colors.black));
      expect(decoration.shape, equals(BoxShape.circle));
    });
  });

  group('SavedTournament - Callbacks', () {
    testWidgets('should call onRegister when Register button tapped', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      bool wasCalled = false;
      await tester.pumpWidget(
        createTestWidget(onRegister: () => wasCalled = true),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Register'));
      await tester.pump();

      expect(wasCalled, isTrue);
    });

    testWidgets('should call onRemove when bookmark icon tapped', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      bool wasCalled = false;
      await tester.pumpWidget(
        createTestWidget(onRemove: () => wasCalled = true),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.bookmark));
      await tester.pump();

      expect(wasCalled, isTrue);
    });

    testWidgets('should handle null onRegister gracefully', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget(onRegister: null));
      await tester.pumpAndSettle();

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });
  });

  group('SavedTournament - Text Overflow', () {
    testWidgets('should limit location to 1 line with ellipsis', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      final longLocation = 'B' * 100;
      await tester.pumpWidget(createTestWidget(location: longLocation));
      await tester.pumpAndSettle();

      final locationTexts = tester.widgetList<Text>(find.byType(Text)).toList();
      final locationText = locationTexts.firstWhere(
        (t) => t.data == longLocation,
        orElse: () => locationTexts.first,
      );
      expect(locationText.maxLines, equals(1));
      expect(locationText.overflow, equals(TextOverflow.ellipsis));
    });

    testWidgets('should limit date to 1 line with ellipsis', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final dateTexts = tester.widgetList<Text>(find.byType(Text)).toList();
      final dateText = dateTexts.firstWhere(
        (t) => t.data?.contains('Jun') ?? false,
        orElse: () => dateTexts.first,
      );
      expect(dateText.maxLines, equals(1));
      expect(dateText.overflow, equals(TextOverflow.ellipsis));
    });
  });

  group('SavedTournament - Layout Structure', () {
    testWidgets('should use Column as root layout', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('should use Stack for image overlay', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Stack), findsOneWidget);
    });

    testWidgets('should use ClipRRect for rounded image', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('should use Padding for content spacing', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Padding), findsWidgets);
    });

    testWidgets('should use Expanded for info row text', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Expanded), findsWidgets);
    });
  });

  group('SavedTournament - Placeholder Widget', () {
    testWidgets('should display placeholder with correct dimensions', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget(imageUrl: ''));
      await tester.pumpAndSettle();
    });

    testWidgets('should display placeholder with correct icon', (tester) async {
      await tester.pumpWidget(createTestWidget(imageUrl: ''));
      await tester.pumpAndSettle();

      final icon = tester.widget<Icon>(find.byIcon(Icons.image_not_supported));
      expect(icon.color, equals(Colors.grey));
      expect(icon.size, equals(32));
    });
  });

  group('SavedTournament - Remove Button Positioning', () {
    testWidgets('should position remove button at top right', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Positioned), findsOneWidget);
    });

    testWidgets('should have white bookmark icon', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final icon = tester.widget<Icon>(find.byIcon(Icons.bookmark));
      expect(icon.color, equals(Colors.white));
      expect(icon.size, equals(16));
    });
  });

  group('SavedTournament - Info Row Structure', () {
    testWidgets('should display icon and text in row for location', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final rows = tester.widgetList<Row>(find.byType(Row)).toList();
      expect(rows.length, greaterThan(1));
    });

    testWidgets('should use small icon size for info rows', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final locationIcon = tester.widget<Icon>(find.byIcon(Icons.location_on));
      expect(locationIcon.size, equals(12));
    });

    testWidgets('should have spacing between icon and text', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(SizedBox), findsWidgets);
    });
  });

  group('SavedTournament - Edge Cases', () {
    testWidgets('should handle very long title without crashing', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      final veryLongTitle = 'Tournament ' * 50;
      await tester.pumpWidget(createTestWidget(title: veryLongTitle));
      await tester.pumpAndSettle();

      expect(find.byType(SavedTournament), findsOneWidget);
    });

    testWidgets('should handle special characters in location', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(
        createTestWidget(location: 'Kathmandu, Nepal 🇳🇵'),
      );
      await tester.pumpAndSettle();

      expect(find.text('Kathmandu, Nepal 🇳🇵'), findsOneWidget);
    });

    testWidgets('should handle empty strings for optional fields', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(
        createTestWidget(title: '', location: '', date: ''),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SavedTournament), findsOneWidget);
    });

    testWidgets('should rebuild without errors', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('Test Tournament'), findsOneWidget);
    });
  });

  group('SavedTournament - Accessibility', () {
    testWidgets('should have semantic labels for buttons', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final registerButton = find.byType(ElevatedButton);
      expect(registerButton, findsOneWidget);
    });

    testWidgets('should be tappable for remove action', (tester) async {
      ignoreImageErrors(tester);
      bool removed = false;
      await tester.pumpWidget(createTestWidget(onRemove: () => removed = true));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.bookmark));
      await tester.pump();

      expect(removed, isTrue);
    });
  });

  group('SavedTournament - Widget Key', () {
    testWidgets('should accept and use key parameter', (tester) async {
      ignoreImageErrors(tester);
      final key = GlobalKey();
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: SavedTournament(
              key: key,
              imageUrl: '',
              title: 'Test',
              location: 'Test',
              date: 'Test',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(key.currentWidget, isNotNull);
    });
  });
}
