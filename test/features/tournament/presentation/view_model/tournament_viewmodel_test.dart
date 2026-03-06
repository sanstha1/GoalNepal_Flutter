import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_nepal/core/error/failures.dart';
import 'package:goal_nepal/features/tournament/domain/entities/tournament_entity.dart';
import 'package:goal_nepal/features/tournament/domain/usecases/create_tournament_usecase.dart';
import 'package:goal_nepal/features/tournament/domain/usecases/delete_tournament_usecase.dart';
import 'package:goal_nepal/features/tournament/domain/usecases/get_all_tournament_usecase.dart';
import 'package:goal_nepal/features/tournament/domain/usecases/get_tournament_by_id_usecase.dart';
import 'package:goal_nepal/features/tournament/domain/usecases/get_tournament_by_user_usecase.dart';
import 'package:goal_nepal/features/tournament/domain/usecases/update_tournament_usecase.dart';
import 'package:goal_nepal/features/tournament/presentation/state/tournament_state.dart';
import 'package:goal_nepal/features/tournament/presentation/view_model/tournament_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAllTournamentsUsecase extends Mock
    implements GetAllTournamentsUsecase {}

class MockGetTournamentByIdUsecase extends Mock
    implements GetTournamentByIdUsecase {}

class MockGetMyTournamentsUsecase extends Mock
    implements GetMyTournamentsUsecase {}

class MockCreateTournamentUsecase extends Mock
    implements CreateTournamentUsecase {}

class MockUpdateTournamentUsecase extends Mock
    implements UpdateTournamentUsecase {}

class MockDeleteTournamentUsecase extends Mock
    implements DeleteTournamentUsecase {}

class MockFile extends Mock implements File {}

void main() {
  late TournamentViewModel viewModel;
  late MockGetAllTournamentsUsecase mockGetAllTournaments;
  late MockGetTournamentByIdUsecase mockGetTournamentById;
  late MockGetMyTournamentsUsecase mockGetMyTournaments;
  late MockCreateTournamentUsecase mockCreateTournament;
  late MockUpdateTournamentUsecase mockUpdateTournament;
  late MockDeleteTournamentUsecase mockDeleteTournament;
  late ProviderContainer container;

  final tStartDate = DateTime(2025, 6, 1);
  final tEndDate = DateTime(2025, 6, 30);

  final tFootballTournament = TournamentEntity(
    tournamentId: '1',
    title: 'Goal Nepal Football Cup',
    type: TournamentType.football,
    location: 'Kathmandu',
    startDate: tStartDate,
    endDate: tEndDate,
  );

  final tFutsalTournament = TournamentEntity(
    tournamentId: '2',
    title: 'Goal Nepal Futsal Cup',
    type: TournamentType.futsal,
    location: 'Pokhara',
    startDate: tStartDate,
    endDate: tEndDate,
  );

  final tAllTournaments = [tFootballTournament, tFutsalTournament];

  setUp(() {
    mockGetAllTournaments = MockGetAllTournamentsUsecase();
    mockGetTournamentById = MockGetTournamentByIdUsecase();
    mockGetMyTournaments = MockGetMyTournamentsUsecase();
    mockCreateTournament = MockCreateTournamentUsecase();
    mockUpdateTournament = MockUpdateTournamentUsecase();
    mockDeleteTournament = MockDeleteTournamentUsecase();

    container = ProviderContainer(
      overrides: [
        getAllTournamentsUsecaseProvider.overrideWithValue(
          mockGetAllTournaments,
        ),
        getTournamentByIdUsecaseProvider.overrideWithValue(
          mockGetTournamentById,
        ),
        getMyTournamentsUsecaseProvider.overrideWithValue(mockGetMyTournaments),
        createTournamentUsecaseProvider.overrideWithValue(mockCreateTournament),
        updateTournamentUsecaseProvider.overrideWithValue(mockUpdateTournament),
        deleteTournamentUsecaseProvider.overrideWithValue(mockDeleteTournament),
      ],
    );

    viewModel = container.read(tournamentViewModelProvider.notifier);
  });

  setUpAll(() {
    registerFallbackValue(
      TournamentEntity(
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
      CreateTournamentParams(
        title: 'fallback',
        type: TournamentType.football,
        location: 'fallback',
        startDate: DateTime(2025),
        endDate: DateTime(2025),
      ),
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
    registerFallbackValue(
      const DeleteTournamentParams(tournamentId: 'fallback'),
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('TournamentViewModel - Initial State', () {
    test('initial state should be TournamentStatus.initial', () {
      final state = container.read(tournamentViewModelProvider);
      expect(state.status, TournamentStatus.initial);
      expect(state.tournaments, isEmpty);
      expect(state.footballTournaments, isEmpty);
      expect(state.futsalTournaments, isEmpty);
      expect(state.myTournaments, isEmpty);
      expect(state.selectedTournament, isNull);
      expect(state.errorMessage, isNull);
    });
  });

  group('TournamentViewModel - Get All Tournaments', () {
    test(
      'should emit loading then loaded with filtered lists on success',
      () async {
        when(
          () => mockGetAllTournaments(),
        ).thenAnswer((_) async => Right(tAllTournaments));

        final future = viewModel.getAllTournaments();

        expect(
          container.read(tournamentViewModelProvider).status,
          TournamentStatus.loading,
        );

        await future;

        final state = container.read(tournamentViewModelProvider);
        expect(state.status, TournamentStatus.loaded);
        expect(state.tournaments, tAllTournaments);
        expect(state.footballTournaments, [tFootballTournament]);
        expect(state.futsalTournaments, [tFutsalTournament]);
        verify(() => mockGetAllTournaments()).called(1);
      },
    );

    test('should emit loading then error on failure', () async {
      const tFailure = ApiFailure(message: 'Failed to fetch tournaments');
      when(
        () => mockGetAllTournaments(),
      ).thenAnswer((_) async => const Left(tFailure));

      final future = viewModel.getAllTournaments();

      expect(
        container.read(tournamentViewModelProvider).status,
        TournamentStatus.loading,
      );

      await future;

      final state = container.read(tournamentViewModelProvider);
      expect(state.status, TournamentStatus.error);
      expect(state.errorMessage, 'Failed to fetch tournaments');
    });
  });

  group('TournamentViewModel - Get Tournament By Id', () {
    test(
      'should emit loading then loaded with selectedTournament on success',
      () async {
        when(
          () => mockGetTournamentById(any()),
        ).thenAnswer((_) async => Right(tFootballTournament));

        final future = viewModel.getTournamentById('1');

        expect(
          container.read(tournamentViewModelProvider).status,
          TournamentStatus.loading,
        );

        await future;

        final state = container.read(tournamentViewModelProvider);
        expect(state.status, TournamentStatus.loaded);
        expect(state.selectedTournament, tFootballTournament);
        verify(() => mockGetTournamentById(any())).called(1);
      },
    );

    test('should emit loading then error when tournament not found', () async {
      const tFailure = ApiFailure(message: 'Tournament not found');
      when(
        () => mockGetTournamentById(any()),
      ).thenAnswer((_) async => const Left(tFailure));

      await viewModel.getTournamentById('invalid_id');

      final state = container.read(tournamentViewModelProvider);
      expect(state.status, TournamentStatus.error);
      expect(state.errorMessage, 'Tournament not found');
    });
  });

  group('TournamentViewModel - Get My Tournaments', () {
    test(
      'should emit loading then loaded with myTournaments on success',
      () async {
        when(
          () => mockGetMyTournaments(any()),
        ).thenAnswer((_) async => Right(tAllTournaments));

        final future = viewModel.getMyTournaments('user_123');

        expect(
          container.read(tournamentViewModelProvider).status,
          TournamentStatus.loading,
        );

        await future;

        final state = container.read(tournamentViewModelProvider);
        expect(state.status, TournamentStatus.loaded);
        expect(state.myTournaments, tAllTournaments);
        verify(() => mockGetMyTournaments(any())).called(1);
      },
    );
  });

  group('TournamentViewModel - Create Tournament', () {
    test(
      'should emit loading then created and refresh tournaments on success',
      () async {
        when(
          () => mockCreateTournament(any()),
        ).thenAnswer((_) async => const Right(true));
        when(
          () => mockGetAllTournaments(),
        ).thenAnswer((_) async => Right(tAllTournaments));

        final future = viewModel.createTournament(
          title: 'Goal Nepal Cup',
          type: TournamentType.football,
          location: 'Kathmandu',
          startDate: tStartDate,
          endDate: tEndDate,
        );

        expect(
          container.read(tournamentViewModelProvider).status,
          TournamentStatus.loading,
        );

        await future;
        await Future.delayed(Duration.zero);

        expect(
          container.read(tournamentViewModelProvider).status,
          TournamentStatus.loaded,
        );
        verify(() => mockCreateTournament(any())).called(1);
        verify(() => mockGetAllTournaments()).called(1);
      },
    );

    test('should emit loading then error on create failure', () async {
      const tFailure = ApiFailure(message: 'Failed to create tournament');
      when(
        () => mockCreateTournament(any()),
      ).thenAnswer((_) async => const Left(tFailure));

      await viewModel.createTournament(
        title: 'Goal Nepal Cup',
        type: TournamentType.football,
        location: 'Kathmandu',
        startDate: tStartDate,
        endDate: tEndDate,
      );

      final state = container.read(tournamentViewModelProvider);
      expect(state.status, TournamentStatus.error);
      expect(state.errorMessage, 'Failed to create tournament');
      verifyNever(() => mockGetAllTournaments());
    });
  });

  group('TournamentViewModel - Update Tournament', () {
    test(
      'should emit loading then updated and refresh tournaments on success',
      () async {
        when(
          () => mockUpdateTournament(any()),
        ).thenAnswer((_) async => const Right(true));
        when(
          () => mockGetAllTournaments(),
        ).thenAnswer((_) async => Right(tAllTournaments));

        final future = viewModel.updateTournament(
          tournamentId: '1',
          title: 'Updated Cup',
          type: TournamentType.football,
          location: 'Kathmandu',
          startDate: tStartDate,
          endDate: tEndDate,
        );

        expect(
          container.read(tournamentViewModelProvider).status,
          TournamentStatus.loading,
        );

        await future;
        await Future.delayed(Duration.zero);

        expect(
          container.read(tournamentViewModelProvider).status,
          TournamentStatus.loaded,
        );
        verify(() => mockUpdateTournament(any())).called(1);
        verify(() => mockGetAllTournaments()).called(1);
      },
    );

    test('should emit loading then error on update failure', () async {
      const tFailure = ApiFailure(message: 'Failed to update tournament');
      when(
        () => mockUpdateTournament(any()),
      ).thenAnswer((_) async => const Left(tFailure));

      await viewModel.updateTournament(
        tournamentId: '1',
        title: 'Updated Cup',
        type: TournamentType.football,
        location: 'Kathmandu',
        startDate: tStartDate,
        endDate: tEndDate,
      );

      final state = container.read(tournamentViewModelProvider);
      expect(state.status, TournamentStatus.error);
      expect(state.errorMessage, 'Failed to update tournament');
      verifyNever(() => mockGetAllTournaments());
    });
  });

  group('TournamentViewModel - Delete Tournament', () {
    test(
      'should emit loading then deleted and refresh tournaments on success',
      () async {
        when(
          () => mockDeleteTournament(any()),
        ).thenAnswer((_) async => const Right(true));
        when(
          () => mockGetAllTournaments(),
        ).thenAnswer((_) async => Right(tAllTournaments));

        final future = viewModel.deleteTournament('1');

        expect(
          container.read(tournamentViewModelProvider).status,
          TournamentStatus.loading,
        );

        await future;
        await Future.delayed(Duration.zero);

        expect(
          container.read(tournamentViewModelProvider).status,
          TournamentStatus.loaded,
        );
        verify(() => mockDeleteTournament(any())).called(1);
        verify(() => mockGetAllTournaments()).called(1);
      },
    );

    test('should emit loading then error on delete failure', () async {
      const tFailure = ApiFailure(message: 'Failed to delete tournament');
      when(
        () => mockDeleteTournament(any()),
      ).thenAnswer((_) async => const Left(tFailure));

      await viewModel.deleteTournament('1');

      final state = container.read(tournamentViewModelProvider);
      expect(state.status, TournamentStatus.error);
      expect(state.errorMessage, 'Failed to delete tournament');
      verifyNever(() => mockGetAllTournaments());
    });
  });

  group('TournamentViewModel - Utility Methods', () {
    test('clearError should reset errorMessage to null', () async {
      const tFailure = ApiFailure(message: 'Some error');
      when(
        () => mockGetAllTournaments(),
      ).thenAnswer((_) async => const Left(tFailure));

      await viewModel.getAllTournaments();

      expect(
        container.read(tournamentViewModelProvider).errorMessage,
        'Some error',
      );

      viewModel.clearError();

      expect(container.read(tournamentViewModelProvider).errorMessage, isNull);
    });

    test(
      'clearSelectedTournament should reset selectedTournament to null',
      () async {
        when(
          () => mockGetTournamentById(any()),
        ).thenAnswer((_) async => Right(tFootballTournament));

        await viewModel.getTournamentById('1');

        expect(
          container.read(tournamentViewModelProvider).selectedTournament,
          tFootballTournament,
        );

        viewModel.clearSelectedTournament();

        expect(
          container.read(tournamentViewModelProvider).selectedTournament,
          isNull,
        );
      },
    );

    test(
      'clearReportState should reset status to initial and clear error',
      () async {
        const tFailure = ApiFailure(message: 'Some error');
        when(
          () => mockGetAllTournaments(),
        ).thenAnswer((_) async => const Left(tFailure));

        await viewModel.getAllTournaments();

        expect(
          container.read(tournamentViewModelProvider).status,
          TournamentStatus.error,
        );

        viewModel.clearReportState();

        final state = container.read(tournamentViewModelProvider);
        expect(state.status, TournamentStatus.initial);
        expect(state.errorMessage, isNull);
      },
    );
  });
}
