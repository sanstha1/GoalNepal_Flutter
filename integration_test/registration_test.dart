import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_nepal/core/services/hive/hive_service.dart';
import 'package:goal_nepal/core/services/storage/user_session_service.dart';
import 'package:goal_nepal/features/register/presentation/pages/register_buttom_sheet.dart';
import 'package:goal_nepal/features/register/presentation/state/register_state.dart';
import 'package:goal_nepal/features/register/presentation/view_model/register_viewmodel.dart';
import 'package:goal_nepal/features/tournament/domain/entities/tournament_entity.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeRegistrationViewModel extends StateNotifier<RegistrationState>
    implements RegistrationViewModel {
  FakeRegistrationViewModel() : super(const RegistrationState());

  @override
  Future<bool> registerForTournament({
    required String tournamentId,
    required String tournamentTitle,
    required String teamName,
    required String captainName,
    required String captainPhone,
    required String captainEmail,
    required int playerCount,
    List<Map<String, dynamic>>? players,
  }) async {
    return false;
  }

  @override
  void reset() => state = const RegistrationState();
}

TournamentEntity get _fakeTournament => TournamentEntity(
  tournamentId: 'test_001',
  title: 'Santosh Cup 2025',
  location: 'Kathmandu, Nepal',
  type: TournamentType.football,
  startDate: DateTime(2025, 6, 1),
  endDate: DateTime(2025, 6, 10),
  organizer: 'Nepal Football Association',
);

TournamentEntity get _fakeFutsalTournament => TournamentEntity(
  tournamentId: 'test_002',
  title: 'Futsal Premier League',
  location: 'Pokhara, Nepal',
  type: TournamentType.futsal,
  startDate: DateTime(2025, 7, 1),
  endDate: DateTime(2025, 7, 5),
  organizer: 'Nepal Futsal Association',
);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Registration Integration Tests', () {
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

    Widget createRegistrationSheet({TournamentEntity? tournament}) {
      return ProviderScope(
        overrides: [
          hiveServiceProvider.overrideWithValue(hiveService),
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          registrationViewModelProvider.overrideWith(
            (ref) => FakeRegistrationViewModel(),
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showRegistrationBottomSheet(
                  context: context,
                  tournament: tournament ?? _fakeTournament,
                ),
                child: const Text('Open Sheet'),
              ),
            ),
          ),
        ),
      );
    }

    Future<void> openSheet(
      WidgetTester tester, {
      TournamentEntity? tournament,
    }) async {
      await tester.pumpWidget(createRegistrationSheet(tournament: tournament));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();
    }

    group('Registration Sheet - UI Elements', () {
      testWidgets('Should display tournament title in header', (tester) async {
        await openSheet(tester);

        expect(find.textContaining('Santosh Cup 2025'), findsOneWidget);
      });

      testWidgets('Should display tournament location and dates', (
        tester,
      ) async {
        await openSheet(tester);

        expect(find.textContaining('Kathmandu, Nepal'), findsOneWidget);
      });

      testWidgets('Should display Team Name field', (tester) async {
        await openSheet(tester);

        expect(find.text('Team Name'), findsOneWidget);
      });

      testWidgets('Should display Captain Name field', (tester) async {
        await openSheet(tester);

        expect(find.text('Captain Name'), findsOneWidget);
      });

      testWidgets('Should display Captain Phone field', (tester) async {
        await openSheet(tester);

        expect(find.text('Captain Phone'), findsOneWidget);
      });

      testWidgets('Should display Captain Email field', (tester) async {
        await openSheet(tester);

        expect(find.text('Captain Email'), findsOneWidget);
      });

      testWidgets('Should display Number of Players field', (tester) async {
        await openSheet(tester);

        expect(find.text('Number of Players'), findsOneWidget);
      });

      testWidgets('Should display Submit Registration button', (tester) async {
        await openSheet(tester);

        expect(find.text('Submit Registration'), findsOneWidget);
      });

      testWidgets('Should display Cancel button', (tester) async {
        await openSheet(tester);

        expect(find.text('Cancel'), findsOneWidget);
      });

      testWidgets('Should display trophy icon in header', (tester) async {
        await openSheet(tester);

        expect(find.byIcon(Icons.emoji_events), findsOneWidget);
      });

      testWidgets('Should display 5 TextFormFields', (tester) async {
        await openSheet(tester);

        expect(find.byType(TextFormField), findsNWidgets(5));
      });

      testWidgets('Should show football player count hint', (tester) async {
        await openSheet(tester);

        expect(find.text('e.g. 11'), findsOneWidget);
      });

      testWidgets('Should show futsal player count hint', (tester) async {
        await openSheet(tester, tournament: _fakeFutsalTournament);

        expect(find.text('e.g. 5'), findsOneWidget);
      });
    });

    group('Registration Sheet - Text Entry', () {
      testWidgets('Should allow entering team name', (tester) async {
        await openSheet(tester);

        await tester.enterText(find.byType(TextFormField).at(0), 'Eagles FC');
        await tester.pump();

        expect(find.text('Eagles FC'), findsOneWidget);
      });

      testWidgets('Should allow entering captain name', (tester) async {
        await openSheet(tester);

        await tester.enterText(
          find.byType(TextFormField).at(1),
          'Santosh Shrestha',
        );
        await tester.pump();

        expect(find.text('Santosh Shrestha'), findsOneWidget);
      });

      testWidgets('Should allow entering captain phone', (tester) async {
        await openSheet(tester);

        await tester.enterText(find.byType(TextFormField).at(2), '9812345678');
        await tester.pump();

        expect(find.text('9812345678'), findsOneWidget);
      });

      testWidgets('Should allow entering captain email', (tester) async {
        await openSheet(tester);

        await tester.enterText(
          find.byType(TextFormField).at(3),
          'santosh.shrestha@email.com',
        );
        await tester.pump();

        expect(find.text('santosh.shrestha@email.com'), findsOneWidget);
      });

      testWidgets('Should allow entering player count', (tester) async {
        await openSheet(tester);

        await tester.enterText(find.byType(TextFormField).at(4), '11');
        await tester.pump();

        expect(find.text('11'), findsOneWidget);
      });
    });

    group('Registration Sheet - Validation', () {
      testWidgets('Should show team name required error', (tester) async {
        await openSheet(tester);

        await tester.tap(find.text('Submit Registration'));
        await tester.pump();

        expect(find.text('Team name is required'), findsOneWidget);
      });

      testWidgets('Should show captain name required error', (tester) async {
        await openSheet(tester);

        await tester.enterText(find.byType(TextFormField).at(0), 'Eagles FC');
        await tester.tap(find.text('Submit Registration'));
        await tester.pump();

        expect(find.text('Captain name is required'), findsOneWidget);
      });

      testWidgets('Should show phone required error', (tester) async {
        await openSheet(tester);

        await tester.enterText(find.byType(TextFormField).at(0), 'Eagles FC');
        await tester.enterText(
          find.byType(TextFormField).at(1),
          'Santosh Shrestha',
        );
        await tester.tap(find.text('Submit Registration'));
        await tester.pump();

        expect(find.text('Phone is required'), findsOneWidget);
      });

      testWidgets('Should show invalid phone error for short number', (
        tester,
      ) async {
        await openSheet(tester);

        await tester.enterText(find.byType(TextFormField).at(2), '12345');
        await tester.tap(find.text('Submit Registration'));
        await tester.pump();

        expect(find.text('Enter a valid phone number'), findsOneWidget);
      });

      testWidgets('Should show email required error', (tester) async {
        await openSheet(tester);

        await tester.enterText(find.byType(TextFormField).at(0), 'Eagles FC');
        await tester.enterText(
          find.byType(TextFormField).at(1),
          'Santosh Shrestha',
        );
        await tester.enterText(find.byType(TextFormField).at(2), '9812345678');
        await tester.tap(find.text('Submit Registration'));
        await tester.pump();

        expect(find.text('Email is required'), findsOneWidget);
      });

      testWidgets('Should show invalid email error', (tester) async {
        await openSheet(tester);

        await tester.enterText(find.byType(TextFormField).at(3), 'notanemail');
        await tester.tap(find.text('Submit Registration'));
        await tester.pump();

        expect(find.text('Enter a valid email'), findsOneWidget);
      });

      testWidgets('Should show player count required error', (tester) async {
        await openSheet(tester);

        await tester.enterText(find.byType(TextFormField).at(0), 'Eagles FC');
        await tester.enterText(
          find.byType(TextFormField).at(1),
          'Santosh Shrestha',
        );
        await tester.enterText(find.byType(TextFormField).at(2), '9812345678');
        await tester.enterText(
          find.byType(TextFormField).at(3),
          'santosh.shrestha@email.com',
        );
        await tester.tap(find.text('Submit Registration'));
        await tester.pump();

        expect(find.text('Player count is required'), findsOneWidget);
      });

      testWidgets('Should show invalid player count error for zero', (
        tester,
      ) async {
        await openSheet(tester);

        await tester.enterText(find.byType(TextFormField).at(4), '0');
        await tester.tap(find.text('Submit Registration'));
        await tester.pump();

        expect(find.text('Enter a valid number'), findsOneWidget);
      });
    });

    group('Registration Sheet - Cancel', () {
      testWidgets('Cancel button should close the sheet', (tester) async {
        await openSheet(tester);

        expect(find.text('Cancel'), findsOneWidget);

        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        expect(find.text('Submit Registration'), findsNothing);
      });
    });
  });
}
