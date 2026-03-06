import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_nepal/core/services/hive/hive_service.dart';
import 'package:goal_nepal/core/services/storage/user_session_service.dart';
import 'package:goal_nepal/features/tournament/presentation/pages/add_tournament_page.dart';
import 'package:goal_nepal/features/tournament/presentation/state/tournament_state.dart';
import 'package:goal_nepal/features/tournament/presentation/view_model/tournament_viewmodel.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeTournamentViewModel extends TournamentViewModel {
  @override
  TournamentState build() =>
      const TournamentState(status: TournamentStatus.initial, tournaments: []);

  @override
  Future<void> getAllTournaments() async {}

  @override
  Future<void> createTournament({
    required String title,
    required dynamic type,
    required String location,
    required DateTime startDate,
    required DateTime endDate,
    String? description,
    String? organizer,
    String? prize,
    int? maxTeams,
    dynamic bannerImage,
  }) async {}
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Tournament Integration Tests', () {
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

    Widget createAddTournamentPage() {
      return ProviderScope(
        overrides: [
          hiveServiceProvider.overrideWithValue(hiveService),
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          tournamentViewModelProvider.overrideWith(
            () => FakeTournamentViewModel(),
          ),
        ],
        child: const MaterialApp(home: AddTournamentPage()),
      );
    }

    group('Add Tournament Page Integration Tests', () {
      testWidgets('Add Tournament page should display header', (tester) async {
        await tester.pumpWidget(createAddTournamentPage());
        await tester.pumpAndSettle();

        expect(find.text('Add Tournament'), findsOneWidget);
        expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
      });

      testWidgets('Add Tournament page should display type toggle', (
        tester,
      ) async {
        await tester.pumpWidget(createAddTournamentPage());
        await tester.pumpAndSettle();

        expect(find.text('Football'), findsWidgets);
        expect(find.text('Futsal'), findsWidgets);
      });

      testWidgets('Football should be selected by default', (tester) async {
        await tester.pumpWidget(createAddTournamentPage());
        await tester.pumpAndSettle();

        expect(find.text('Add Football Tournament'), findsOneWidget);
      });

      testWidgets('Should switch to Futsal when tapped', (tester) async {
        await tester.pumpWidget(createAddTournamentPage());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Futsal').first);
        await tester.pump();

        expect(find.text('Add Futsal Tournament'), findsOneWidget);
      });

      testWidgets('Should switch back to Football when tapped', (tester) async {
        await tester.pumpWidget(createAddTournamentPage());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Futsal').first);
        await tester.pump();

        await tester.tap(find.text('Football').first);
        await tester.pump();

        expect(find.text('Add Football Tournament'), findsOneWidget);
      });

      testWidgets('Add Tournament page should display Banner Image section', (
        tester,
      ) async {
        await tester.pumpWidget(createAddTournamentPage());
        await tester.pumpAndSettle();

        expect(find.text('Banner Image'), findsOneWidget);
        expect(find.text('Add Banner'), findsOneWidget);
      });

      testWidgets('Add Tournament page should display banner upload icon', (
        tester,
      ) async {
        await tester.pumpWidget(createAddTournamentPage());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.add_photo_alternate_rounded), findsOneWidget);
      });

      testWidgets('Add Tournament page should display Banner preview', (
        tester,
      ) async {
        await tester.pumpWidget(createAddTournamentPage());
        await tester.pumpAndSettle();

        expect(find.text('Banner preview'), findsOneWidget);
        expect(find.byIcon(Icons.image_rounded), findsOneWidget);
      });

      testWidgets('Add Tournament page should display Tournament Title label', (
        tester,
      ) async {
        await tester.pumpWidget(createAddTournamentPage());
        await tester.pumpAndSettle();

        expect(find.text('Tournament Title'), findsOneWidget);
      });

      testWidgets('Add Tournament page should display Location label', (
        tester,
      ) async {
        await tester.pumpWidget(createAddTournamentPage());
        await tester.pumpAndSettle();

        expect(find.text('Location'), findsOneWidget);
      });

      testWidgets('Add Tournament page should display Date Range label', (
        tester,
      ) async {
        await tester.pumpWidget(createAddTournamentPage());
        await tester.pumpAndSettle();

        expect(find.text('Date Range'), findsOneWidget);
      });

      testWidgets('Add Tournament page should display Start Date tile', (
        tester,
      ) async {
        await tester.pumpWidget(createAddTournamentPage());
        await tester.pumpAndSettle();

        expect(find.text('Start Date'), findsOneWidget);
        expect(find.byIcon(Icons.calendar_today_rounded), findsOneWidget);
      });

      testWidgets('Add Tournament page should display End Date tile', (
        tester,
      ) async {
        await tester.pumpWidget(createAddTournamentPage());
        await tester.pumpAndSettle();

        expect(find.text('End Date'), findsOneWidget);
        expect(find.byIcon(Icons.event_rounded), findsOneWidget);
      });

      testWidgets('Start and End Date should show Select date by default', (
        tester,
      ) async {
        await tester.pumpWidget(createAddTournamentPage());
        await tester.pumpAndSettle();

        expect(find.text('Select date'), findsNWidgets(2));
      });

      testWidgets('Add Tournament page should display Organizer label', (
        tester,
      ) async {
        await tester.pumpWidget(createAddTournamentPage());
        await tester.pumpAndSettle();

        expect(find.text('Organizer'), findsOneWidget);
      });

      testWidgets('Add Tournament page should display Prize Pool label', (
        tester,
      ) async {
        await tester.pumpWidget(createAddTournamentPage());
        await tester.pumpAndSettle();

        expect(find.text('Prize Pool'), findsOneWidget);
      });

      testWidgets('Add Tournament page should display Max Teams label', (
        tester,
      ) async {
        await tester.pumpWidget(createAddTournamentPage());
        await tester.pumpAndSettle();

        expect(find.text('Max Teams'), findsOneWidget);
      });

      testWidgets('Add Tournament page should display Description label', (
        tester,
      ) async {
        await tester.pumpWidget(createAddTournamentPage());
        await tester.pumpAndSettle();

        expect(find.text('Description'), findsOneWidget);
      });

      testWidgets('Should allow entering tournament title', (tester) async {
        await tester.pumpWidget(createAddTournamentPage());
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byType(TextFormField).first,
          'Santosh Cup 2025',
        );
        await tester.pump();

        expect(find.text('Santosh Cup 2025'), findsOneWidget);
      });

      testWidgets('Should allow entering location', (tester) async {
        await tester.pumpWidget(createAddTournamentPage());
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byType(TextFormField).at(1),
          'Kathmandu, Nepal',
        );
        await tester.pump();

        expect(find.text('Kathmandu, Nepal'), findsOneWidget);
      });

      testWidgets('Should allow entering organizer name', (tester) async {
        await tester.pumpWidget(createAddTournamentPage());
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byType(TextFormField).at(2),
          'Nepal Football Association',
        );
        await tester.pump();

        expect(find.text('Nepal Football Association'), findsOneWidget);
      });

      testWidgets('Should allow entering prize pool', (tester) async {
        await tester.pumpWidget(createAddTournamentPage());
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextFormField).at(3), 'NPR 50,000');
        await tester.pump();

        expect(find.text('NPR 50,000'), findsOneWidget);
      });

      testWidgets('Should allow entering max teams', (tester) async {
        await tester.pumpWidget(createAddTournamentPage());
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextFormField).at(4), '16');
        await tester.pump();

        expect(find.text('16'), findsOneWidget);
      });

      testWidgets('Should allow entering description', (tester) async {
        await tester.pumpWidget(createAddTournamentPage());
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byType(TextFormField).last,
          'Annual football tournament in Kathmandu.',
        );
        await tester.pump();

        expect(
          find.text('Annual football tournament in Kathmandu.'),
          findsOneWidget,
        );
      });

      testWidgets('Should show error snackbar when submitting without dates', (
        tester,
      ) async {
        await tester.pumpWidget(createAddTournamentPage());
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byType(TextFormField).first,
          'Santosh Cup 2025',
        );
        await tester.enterText(
          find.byType(TextFormField).at(1),
          'Kathmandu, Nepal',
        );
        await tester.pump();

        final submitButton = find.text('Add Football Tournament');
        await tester.ensureVisible(submitButton);
        await tester.tap(submitButton);
        await tester.pump();

        expect(find.byType(SnackBar), findsOneWidget);
      });

      testWidgets('Should show validation error when submitting empty title', (
        tester,
      ) async {
        await tester.pumpWidget(createAddTournamentPage());
        await tester.pumpAndSettle();

        final submitButton = find.text('Add Football Tournament');
        await tester.ensureVisible(submitButton);
        await tester.tap(submitButton);
        await tester.pump();

        expect(find.text('Please enter tournament title'), findsOneWidget);
      });

      testWidgets(
        'Should show validation error when submitting empty location',
        (tester) async {
          await tester.pumpWidget(createAddTournamentPage());
          await tester.pumpAndSettle();

          await tester.enterText(
            find.byType(TextFormField).first,
            'Santosh Cup 2025',
          );
          await tester.pump();

          final submitButton = find.text('Add Football Tournament');
          await tester.ensureVisible(submitButton);
          await tester.tap(submitButton);
          await tester.pump();

          expect(find.text('Please enter location'), findsOneWidget);
        },
      );

      testWidgets('Back button should be tappable', (tester) async {
        await tester.pumpWidget(createAddTournamentPage());
        await tester.pumpAndSettle();

        final backButton = find.byIcon(Icons.arrow_back_rounded);
        expect(backButton, findsOneWidget);

        await tester.tap(backButton);
        await tester.pumpAndSettle();
      });
    });
  });
}
