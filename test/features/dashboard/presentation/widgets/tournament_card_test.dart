import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_nepal/features/dashboard/presentation/widgets/tournament_card.dart';
import 'package:goal_nepal/features/dashboard/presentation/providers/saved_tournaments_provider.dart';
import 'package:goal_nepal/features/tournament/domain/entities/tournament_entity.dart';

class TestSavedTournamentsNotifier extends SavedTournamentsNotifier {
  final List<TournamentEntity> savedList;
  bool toggleCalled = false;

  TestSavedTournamentsNotifier(this.savedList);

  List<TournamentEntity> build() => savedList;

  @override
  Future<void> toggle(TournamentEntity tournament) async {
    toggleCalled = true;
  }
}

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

  TournamentEntity makeTournament({
    String? tournamentId = 't_1',
    String title = 'Test Tournament',
    String location = 'Kathmandu',
    String? bannerImage,
  }) {
    return TournamentEntity(
      tournamentId: tournamentId,
      title: title,
      location: location,
      type: TournamentType.football,
      startDate: DateTime(2025, 6, 1),
      endDate: DateTime(2025, 6, 10),
      bannerImage: bannerImage,
      description: 'Test description',
      organizer: 'Test Organizer',
    );
  }

  Widget createTestWidget({
    String title = 'Test Tournament',
    String location = 'Kathmandu',
    String date = '1 Jun - 10 Jun, 2025',
    String imagePath = '',
    TournamentEntity? tournament,
    List<TournamentEntity>? savedTournaments,
  }) {
    final testTournament =
        tournament ??
        makeTournament(
          tournamentId: 't_1',
          title: title,
          location: location,
          bannerImage: imagePath.isEmpty ? null : imagePath,
        );
    final saved = savedTournaments ?? [];

    return ProviderScope(
      overrides: [
        savedTournamentsProvider.overrideWith(
          (ref) => TestSavedTournamentsNotifier(saved),
        ),
      ],
      child: MaterialApp(
        home: Material(
          child: TournamentCard(
            title: title,
            location: location,
            date: date,
            imagePath: imagePath,
            tournament: testTournament,
          ),
        ),
      ),
    );
  }

  group('TournamentCard - Basic UI Elements', () {
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
      await tester.pumpWidget(createTestWidget(date: '15 Jan - 25 Jan, 2025'));
      await tester.pumpAndSettle();

      expect(find.text('15 Jan - 25 Jan, 2025'), findsOneWidget);
      expect(find.byIcon(Icons.calendar_month), findsOneWidget);
    });

    testWidgets('should display Register button', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Register'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should display bookmark toggle button', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
    });
  });

  group('TournamentCard - Saved State', () {
    testWidgets('should show outline bookmark when tournament is not saved', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      final tournament = makeTournament(tournamentId: 'not_saved_1');
      await tester.pumpWidget(
        createTestWidget(tournament: tournament, savedTournaments: []),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
      expect(find.byIcon(Icons.bookmark), findsNothing);
    });

    testWidgets('should call toggle when bookmark is tapped', (tester) async {
      ignoreImageErrors(tester);
      final notifier = TestSavedTournamentsNotifier([]);
      final tournament = makeTournament(tournamentId: 'toggle_1');

      await tester.pumpWidget(
        ProviderScope(
          overrides: [savedTournamentsProvider.overrideWith((ref) => notifier)],
          child: MaterialApp(
            home: Material(
              child: TournamentCard(
                title: 'Test',
                location: 'Test',
                date: 'Test',
                imagePath: '',
                tournament: tournament,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.bookmark_border));
      await tester.pump();

      expect(notifier.toggleCalled, isTrue);
    });
  });

  group('TournamentCard - Image Handling', () {
    testWidgets('should show placeholder when imagePath is empty', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget(imagePath: ''));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.image_not_supported), findsOneWidget);
    });

    testWidgets('should show placeholder on network image error', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(imagePath: 'https://invalid.example.com/img.jpg'),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.image_not_supported), findsOneWidget);
    });

    testWidgets('should display loading indicator for network image', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(imagePath: 'https://example.com/image.jpg'),
      );
      await tester.pump();

      expect(find.byType(Image), findsOneWidget);
    });
  });

  group('TournamentCard - Styling', () {
    testWidgets('should use Card with elevation', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, equals(3));
    });

    testWidgets('should have rounded corners', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final card = tester.widget<Card>(find.byType(Card));
      expect(card.shape, isA<RoundedRectangleBorder>());
    });

    testWidgets('should use bold font for title', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final titleText = tester.widget<Text>(find.text('Test Tournament'));
      expect(titleText.style?.fontWeight, equals(FontWeight.bold));
      expect(titleText.style?.fontSize, equals(14));
    });

    testWidgets('should use grey color for location text', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final locationText = tester.widget<Text>(find.text('Kathmandu'));
      expect(locationText.style?.color, equals(Colors.grey));
      expect(locationText.style?.fontSize, equals(12));
    });

    testWidgets('should use italic style for date text', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final texts = tester.widgetList<Text>(find.byType(Text)).toList();
      final dateText = texts.firstWhere(
        (t) => t.data?.contains('Jun') ?? false,
        orElse: () => texts.first,
      );
      expect(dateText.style?.fontStyle, equals(FontStyle.italic));
    });
  });

  group('TournamentCard - Register Button', () {
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
      expect(buttonText.style?.fontSize, equals(15));
      expect(buttonText.style?.fontWeight, equals(FontWeight.bold));
    });
  });

  group('TournamentCard - Bookmark Button Styling', () {
    testWidgets('should have white bookmark icon', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final icon = tester.widget<Icon>(find.byIcon(Icons.bookmark_border));
      expect(icon.color, equals(Colors.white));
      expect(icon.size, equals(18));
    });

    testWidgets('should position bookmark at top right', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Positioned), findsOneWidget);
    });
  });

  group('TournamentCard - Text Overflow', () {
    testWidgets('should limit title to 2 lines with ellipsis', (tester) async {
      ignoreImageErrors(tester);
      final longTitle = 'A' * 100;
      await tester.pumpWidget(createTestWidget(title: longTitle));
      await tester.pumpAndSettle();

      final titleText = tester.widget<Text>(find.byType(Text).first);
      expect(titleText.maxLines, equals(2));
      expect(titleText.overflow, equals(TextOverflow.ellipsis));
    });

    testWidgets('should limit location to 1 line with ellipsis', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      final longLocation = 'B' * 100;
      await tester.pumpWidget(createTestWidget(location: longLocation));
      await tester.pumpAndSettle();

      final texts = tester.widgetList<Text>(find.byType(Text)).toList();
      final locationText = texts.firstWhere(
        (t) => t.data == longLocation,
        orElse: () => texts.first,
      );
      expect(locationText.maxLines, equals(1));
      expect(locationText.overflow, equals(TextOverflow.ellipsis));
    });
  });

  group('TournamentCard - Layout Structure', () {
    testWidgets('should use Card as root widget', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(Card), findsOneWidget);
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

      expect(find.byType(Expanded), findsNWidgets(2));
    });
  });

  group('TournamentCard - Placeholder Widget', () {
    testWidgets('should display placeholder with grey background', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget(imagePath: ''));
      await tester.pumpAndSettle();

      final containers = tester
          .widgetList<Container>(find.byType(Container))
          .toList();
      final placeholder = containers.firstWhere(
        (c) => c.color == Colors.grey.shade200,
        orElse: () => containers.first,
      );
      expect(placeholder.color, equals(Colors.grey.shade200));
    });

    testWidgets('should display placeholder with correct icon', (tester) async {
      await tester.pumpWidget(createTestWidget(imagePath: ''));
      await tester.pumpAndSettle();

      final icon = tester.widget<Icon>(find.byIcon(Icons.image_not_supported));
      expect(icon.color, equals(Colors.grey));
      expect(icon.size, equals(36));
    });
  });

  group('TournamentCard - Info Row Structure', () {
    testWidgets('should display location in Row with icon', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final rows = tester.widgetList<Row>(find.byType(Row)).toList();
      expect(rows.length, greaterThanOrEqualTo(2));
    });

    testWidgets('should use small icon size for info rows', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final locationIcon = tester.widget<Icon>(find.byIcon(Icons.location_on));
      expect(locationIcon.size, equals(14));
    });
  });

  group('TournamentCard - Edge Cases', () {
    testWidgets('should handle very long title without crashing', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      final veryLongTitle = 'Tournament ' * 50;
      await tester.pumpWidget(createTestWidget(title: veryLongTitle));
      await tester.pumpAndSettle();

      expect(find.byType(TournamentCard), findsOneWidget);
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
        createTestWidget(title: '', location: '', date: '', imagePath: ''),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TournamentCard), findsOneWidget);
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

  group('TournamentCard - Widget Key', () {
    testWidgets('should accept and use key parameter', (tester) async {
      ignoreImageErrors(tester);
      final key = GlobalKey();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            savedTournamentsProvider.overrideWith(
              (ref) => TestSavedTournamentsNotifier([]),
            ),
          ],
          child: MaterialApp(
            home: Material(
              child: TournamentCard(
                key: key,
                title: 'Test',
                location: 'Test',
                date: 'Test',
                imagePath: '',
                tournament: makeTournament(),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(key.currentWidget, isNotNull);
    });
  });

  group('TournamentCard - Accessibility', () {
    testWidgets('should have tappable Register button', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final button = find.byType(ElevatedButton);
      expect(button, findsOneWidget);
    });

    testWidgets('should have tappable bookmark button', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final bookmark = find.byIcon(Icons.bookmark_border);
      expect(bookmark, findsOneWidget);
    });
  });
}
