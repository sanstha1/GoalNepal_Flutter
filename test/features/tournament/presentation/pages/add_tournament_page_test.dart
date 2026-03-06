import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_nepal/features/tournament/domain/entities/tournament_entity.dart';
import 'package:goal_nepal/features/tournament/domain/usecases/create_tournament_usecase.dart';
import 'package:goal_nepal/features/tournament/domain/usecases/delete_tournament_usecase.dart';
import 'package:goal_nepal/features/tournament/domain/usecases/get_all_tournament_usecase.dart';
import 'package:goal_nepal/features/tournament/domain/usecases/get_tournament_by_id_usecase.dart';
import 'package:goal_nepal/features/tournament/domain/usecases/get_tournament_by_user_usecase.dart';
import 'package:goal_nepal/features/tournament/domain/usecases/update_tournament_usecase.dart';
import 'package:goal_nepal/features/tournament/presentation/pages/add_tournament_page.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateTournamentUsecase extends Mock
    implements CreateTournamentUsecase {}

class MockGetAllTournamentsUsecase extends Mock
    implements GetAllTournamentsUsecase {}

class MockGetTournamentByIdUsecase extends Mock
    implements GetTournamentByIdUsecase {}

class MockGetMyTournamentsUsecase extends Mock
    implements GetMyTournamentsUsecase {}

class MockUpdateTournamentUsecase extends Mock
    implements UpdateTournamentUsecase {}

class MockDeleteTournamentUsecase extends Mock
    implements DeleteTournamentUsecase {}

void main() {
  late MockCreateTournamentUsecase mockCreateTournamentUsecase;
  late MockGetAllTournamentsUsecase mockGetAllTournamentsUsecase;
  late MockGetTournamentByIdUsecase mockGetTournamentByIdUsecase;
  late MockGetMyTournamentsUsecase mockGetMyTournamentsUsecase;
  late MockUpdateTournamentUsecase mockUpdateTournamentUsecase;
  late MockDeleteTournamentUsecase mockDeleteTournamentUsecase;

  setUpAll(() {
    registerFallbackValue(
      CreateTournamentParams(
        title: 'fallback',
        type: TournamentType.football,
        location: 'fallback',
        startDate: DateTime(2025),
        endDate: DateTime(2025),
      ),
    );
    registerFallbackValue(
      const GetTournamentByIdParams(tournamentId: 'fallback'),
    );
    registerFallbackValue(const GetMyTournamentsParams(userId: 'fallback'));
    registerFallbackValue(
      const DeleteTournamentParams(tournamentId: 'fallback'),
    );
    registerFallbackValue(
      UpdateTournamentParams(
        tournamentId: 'fallback',
        title: 'fallback',
        type: TournamentType.football,
        location: 'fallback',
        startDate: DateTime(2025),
        endDate: DateTime(2025),
      ),
    );
  });

  setUp(() {
    mockCreateTournamentUsecase = MockCreateTournamentUsecase();
    mockGetAllTournamentsUsecase = MockGetAllTournamentsUsecase();
    mockGetTournamentByIdUsecase = MockGetTournamentByIdUsecase();
    mockGetMyTournamentsUsecase = MockGetMyTournamentsUsecase();
    mockUpdateTournamentUsecase = MockUpdateTournamentUsecase();
    mockDeleteTournamentUsecase = MockDeleteTournamentUsecase();

    when(
      () => mockGetAllTournamentsUsecase(),
    ).thenAnswer((_) async => const Right([]));
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        createTournamentUsecaseProvider.overrideWithValue(
          mockCreateTournamentUsecase,
        ),
        getAllTournamentsUsecaseProvider.overrideWithValue(
          mockGetAllTournamentsUsecase,
        ),
        getTournamentByIdUsecaseProvider.overrideWithValue(
          mockGetTournamentByIdUsecase,
        ),
        getMyTournamentsUsecaseProvider.overrideWithValue(
          mockGetMyTournamentsUsecase,
        ),
        updateTournamentUsecaseProvider.overrideWithValue(
          mockUpdateTournamentUsecase,
        ),
        deleteTournamentUsecaseProvider.overrideWithValue(
          mockDeleteTournamentUsecase,
        ),
      ],
      child: const MaterialApp(home: AddTournamentPage()),
    );
  }

  void ignoreImageErrors(WidgetTester tester) {
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.exception.toString().contains('Unable to load asset')) {
        return;
      }
      originalOnError?.call(details);
    };
  }

  group('AddTournamentPage - UI Elements', () {
    testWidgets('should display Add Tournament title', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.text('Add Tournament'), findsOneWidget);
    });

    testWidgets('should display Football and Futsal toggle options', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.text('Football'), findsOneWidget);
      expect(find.text('Futsal'), findsOneWidget);
    });

    testWidgets('should display Banner Image label', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.text('Banner Image'), findsOneWidget);
    });

    testWidgets('should display Add Banner button', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.text('Add Banner'), findsOneWidget);
    });

    testWidgets('should display Banner preview placeholder when no image', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.text('Banner preview'), findsOneWidget);
    });

    testWidgets('should display Tournament Title label and hint', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.text('Tournament Title'), findsOneWidget);
      expect(
        find.widgetWithText(TextFormField, 'e.g., Kathmandu Futsal Cup 2025'),
        findsOneWidget,
      );
    });

    testWidgets('should display Location label and hint', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.text('Location'), findsOneWidget);
      expect(
        find.widgetWithText(TextFormField, 'e.g., Kathmandu, Nepal'),
        findsOneWidget,
      );
    });

    testWidgets('should display Date Range section with Start and End tiles', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.text('Date Range'), findsOneWidget);
      expect(find.text('Start Date'), findsOneWidget);
      expect(find.text('End Date'), findsOneWidget);
    });

    testWidgets('should show Select date placeholder on both date tiles', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.text('Select date'), findsNWidgets(2));
    });

    testWidgets('should display Organizer field', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.text('Organizer'), findsOneWidget);
    });

    testWidgets('should display Prize Pool and Max Teams fields', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.text('Prize Pool'), findsOneWidget);
      expect(find.text('Max Teams'), findsOneWidget);
    });

    testWidgets('should display Description field', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.text('Description'), findsOneWidget);
    });

    testWidgets('should display Add Football Tournament submit button', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.text('Add Football Tournament'), findsOneWidget);
    });

    testWidgets('should display back arrow icon', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    });
  });

  group('AddTournamentPage - Tournament Type Toggle', () {
    testWidgets('should default to Football type', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.text('Add Football Tournament'), findsOneWidget);
    });

    testWidgets('should switch to Futsal when Futsal tab tapped', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      await tester.tap(find.text('Futsal'));
      await tester.pump();

      expect(find.text('Add Futsal Tournament'), findsOneWidget);
    });

    testWidgets('should switch back to Football when Football tab tapped', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      await tester.tap(find.text('Futsal'));
      await tester.pump();
      await tester.tap(find.text('Football'));
      await tester.pump();

      expect(find.text('Add Football Tournament'), findsOneWidget);
    });
  });

  group('AddTournamentPage - Form Input', () {
    testWidgets('should accept text input in title field', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'e.g., Kathmandu Futsal Cup 2025'),
        'Goal Nepal Cup 2025',
      );
      await tester.pump();

      expect(find.text('Goal Nepal Cup 2025'), findsOneWidget);
    });

    testWidgets('should accept text input in location field', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'e.g., Kathmandu, Nepal'),
        'Kathmandu, Nepal',
      );
      await tester.pump();

      expect(find.text('Kathmandu, Nepal'), findsOneWidget);
    });

    testWidgets('should accept text input in organizer field', (tester) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'e.g., Nepal Football Association'),
        'Goal Nepal',
      );
      await tester.pump();

      expect(find.text('Goal Nepal'), findsOneWidget);
    });

    testWidgets('should accept numeric input in max teams field', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'e.g., 16'),
        '16',
      );
      await tester.pump();

      expect(find.text('16'), findsOneWidget);
    });
  });

  group('AddTournamentPage - Form Validation', () {
    testWidgets('should not call createTournament when form is invalid', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      await tester.tap(find.text('Add Football Tournament'));
      await tester.pump();

      verifyNever(() => mockCreateTournamentUsecase(any()));
    });
  });

  group('AddTournamentPage - Icons', () {
    testWidgets('should display emoji_events icon for title field', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.byIcon(Icons.emoji_events_rounded), findsOneWidget);
    });

    testWidgets('should display location icon for location field', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.byIcon(Icons.location_on_rounded), findsOneWidget);
    });

    testWidgets('should display add_photo icon for banner uploader', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.byIcon(Icons.add_photo_alternate_rounded), findsOneWidget);
    });

    testWidgets('should display add_circle icon on submit button', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.byIcon(Icons.add_circle_rounded), findsOneWidget);
    });
  });
}
