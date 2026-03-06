import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_nepal/core/services/sensors/shake_service.dart';
import 'package:goal_nepal/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:goal_nepal/features/auth/domain/usecases/login_usecase.dart';
import 'package:goal_nepal/features/auth/domain/usecases/register_usecase.dart';
import 'package:goal_nepal/features/auth/domain/usecases/upload_profilepicture_usecase.dart';
import 'package:goal_nepal/features/dashboard/presentation/pages/home_screen.dart';
import 'package:goal_nepal/features/tournament/domain/entities/tournament_entity.dart';
import 'package:goal_nepal/features/tournament/presentation/state/tournament_state.dart';
import 'package:goal_nepal/features/tournament/presentation/view_model/tournament_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUsecase extends Mock implements LoginUsecase {}

class MockRegisterUsecase extends Mock implements RegisterUsecase {}

class MockGetCurrentUserUsecase extends Mock implements GetCurrentUserUsecase {}

class MockUploadProfilePictureUsecase extends Mock
    implements UploadProfilePictureUsecase {}

class MockShakeService extends Mock implements ShakeService {}

class FakeTournamentViewModel extends TournamentViewModel {
  final TournamentState fakeState;

  FakeTournamentViewModel({required this.fakeState});

  @override
  TournamentState build() => fakeState;

  @override
  Future<void> getAllTournaments() async {}
}

void main() {
  late MockShakeService mockShakeService;

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

  setUp(() {
    mockShakeService = MockShakeService();
    when(
      () => mockShakeService.start(onShake: any(named: 'onShake')),
    ).thenReturn(null);
    when(() => mockShakeService.stop()).thenReturn(null);
  });

  Widget createTestWidget({TournamentState? state}) {
    final testState =
        state ??
        const TournamentState(
          status: TournamentStatus.initial,
          tournaments: [],
        );

    return ProviderScope(
      overrides: [
        loginUsecaseProvider.overrideWithValue(MockLoginUsecase()),
        registerUsecaseProvider.overrideWithValue(MockRegisterUsecase()),
        getCurrentUserUsecaseProvider.overrideWithValue(
          MockGetCurrentUserUsecase(),
        ),
        uploadProfilePictureUsecaseProvider.overrideWithValue(
          MockUploadProfilePictureUsecase(),
        ),
        shakeServiceProvider.overrideWithValue(mockShakeService),
        tournamentViewModelProvider.overrideWith(
          () => FakeTournamentViewModel(fakeState: testState),
        ),
      ],
      child: const MaterialApp(home: HomeScreen()),
    );
  }

  TournamentEntity makeTournament({
    String? tournamentId = '1',
    String title = 'Santosh Cup 2025',
    String location = 'Kathmandu',
    TournamentType type = TournamentType.football,
  }) {
    return TournamentEntity(
      tournamentId: tournamentId,
      title: title,
      location: location,
      type: type,
      startDate: DateTime(2025, 6, 1),
      endDate: DateTime(2025, 6, 10),
      bannerImage: null,
      description: 'Test tournament',
      organizer: 'Santosh Shrestha',
    );
  }

  group('HomeScreen - UI Elements', () {
    testWidgets('should display Ongoing Tournaments title', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.text('Ongoing Tournaments'), findsOneWidget);
    });

    testWidgets('should display subtitle text', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(
        find.text(
          'Discover and register for the best football and futsal tournaments in Nepal',
        ),
        findsOneWidget,
      );
    });

    testWidgets('should display All category button', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.text('All'), findsOneWidget);
    });

    testWidgets('should display Football category button', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.text('Football'), findsOneWidget);
    });

    testWidgets('should display Futsal category button', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.text('Futsal'), findsOneWidget);
    });

    testWidgets('All button should be selected by default', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final allText = tester.widget<Text>(find.text('All'));
      expect(allText.style?.color, equals(Colors.white));
    });

    testWidgets('Football button should be unselected by default', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final footballText = tester.widget<Text>(find.text('Football'));
      expect(footballText.style?.color, equals(Colors.black));
    });

    testWidgets('Futsal button should be unselected by default', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final futsalText = tester.widget<Text>(find.text('Futsal'));
      expect(futsalText.style?.color, equals(Colors.black));
    });
  });

  group('HomeScreen - Loading State', () {
    testWidgets('should show loading indicator when status is loading', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(
        createTestWidget(
          state: const TournamentState(
            status: TournamentStatus.loading,
            tournaments: [],
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should not show error when status is loading', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(
        createTestWidget(
          state: const TournamentState(
            status: TournamentStatus.loading,
            tournaments: [],
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Something went wrong'), findsNothing);
    });
  });

  group('HomeScreen - Error State', () {
    testWidgets('should show error message when status is error', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(
        createTestWidget(
          state: const TournamentState(
            status: TournamentStatus.error,
            tournaments: [],
            errorMessage: 'Something went wrong',
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Something went wrong'), findsOneWidget);
    });

    testWidgets('should not show loading indicator when status is error', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(
        createTestWidget(
          state: const TournamentState(
            status: TournamentStatus.error,
            tournaments: [],
            errorMessage: 'Something went wrong',
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });

  group('HomeScreen - Empty State', () {
    testWidgets('should show no tournaments found when list is empty', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(
        createTestWidget(
          state: const TournamentState(
            status: TournamentStatus.success,
            tournaments: [],
          ),
        ),
      );
      await tester.pump();

      expect(find.text('No tournaments found'), findsOneWidget);
    });
  });

  group('HomeScreen - Category Filter', () {
    testWidgets('should select Football category when tapped', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      await tester.tap(find.text('Football'));
      await tester.pump();

      final footballText = tester.widget<Text>(find.text('Football'));
      expect(footballText.style?.color, equals(Colors.white));
    });

    testWidgets('should select Futsal category when tapped', (tester) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      await tester.tap(find.text('Futsal'));
      await tester.pump();

      final futsalText = tester.widget<Text>(find.text('Futsal'));
      expect(futsalText.style?.color, equals(Colors.white));
    });

    testWidgets('should deselect Football when All is tapped after', (
      tester,
    ) async {
      ignoreImageErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      await tester.tap(find.text('Football'));
      await tester.pump();
      await tester.tap(find.text('All'));
      await tester.pump();

      final allText = tester.widget<Text>(find.text('All'));
      expect(allText.style?.color, equals(Colors.white));

      final footballText = tester.widget<Text>(find.text('Football'));
      expect(footballText.style?.color, equals(Colors.black));
    });

    testWidgets(
      'should show no tournaments when Football selected and none exist',
      (tester) async {
        ignoreImageErrors(tester);
        setLargeScreen(tester);
        await tester.pumpWidget(
          createTestWidget(
            state: TournamentState(
              status: TournamentStatus.success,
              tournaments: [makeTournament(type: TournamentType.futsal)],
            ),
          ),
        );
        await tester.pump();

        await tester.tap(find.text('Football'));
        await tester.pump();

        expect(find.text('No tournaments found'), findsOneWidget);
      },
    );
  });
}
