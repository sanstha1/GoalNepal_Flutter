import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_nepal/core/error/failures.dart';
import 'package:goal_nepal/features/tournament/domain/entities/tournament_entity.dart';
import 'package:goal_nepal/features/tournament/domain/repositories/tournament_repository.dart';
import 'package:goal_nepal/features/tournament/domain/usecases/get_tournament_by_id_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockTournamentRepository extends Mock implements ITournamentRepository {}

void main() {
  late GetTournamentByIdUsecase usecase;
  late MockTournamentRepository mockRepository;

  setUp(() {
    mockRepository = MockTournamentRepository();
    usecase = GetTournamentByIdUsecase(repository: mockRepository);
  });

  const tTournamentId = 'tournament_001';
  const tParams = GetTournamentByIdParams(tournamentId: tTournamentId);

  final tTournament = TournamentEntity(
    tournamentId: tTournamentId,
    title: 'Goal Nepal Cup 2025',
    type: TournamentType.football,
    location: 'Kathmandu',
    startDate: DateTime(2025, 6, 1),
    endDate: DateTime(2025, 6, 30),
    organizer: 'Goal Nepal',
  );

  group('GetTournamentByIdUsecase', () {
    test('1. should return Right(TournamentEntity) on success', () async {
      when(
        () => mockRepository.getTournamentById(any()),
      ).thenAnswer((_) async => Right(tTournament));

      final result = await usecase(tParams);

      expect(result, Right(tTournament));
      verify(() => mockRepository.getTournamentById(tTournamentId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('2. should return tournament with correct tournamentId', () async {
      when(
        () => mockRepository.getTournamentById(any()),
      ).thenAnswer((_) async => Right(tTournament));

      final result = await usecase(tParams);

      expect((result as Right).value.tournamentId, tTournamentId);
    });

    test('3. should forward exact tournamentId to repository', () async {
      String? capturedId;
      when(() => mockRepository.getTournamentById(any())).thenAnswer((
        invocation,
      ) {
        capturedId = invocation.positionalArguments[0] as String;
        return Future.value(Right(tTournament));
      });

      await usecase(tParams);

      expect(capturedId, tTournamentId);
    });

    test(
      '4. should return Left(ApiFailure) when tournament not found',
      () async {
        const tFailure = ApiFailure(message: 'Tournament not found');
        when(
          () => mockRepository.getTournamentById(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        final result = await usecase(tParams);

        expect(result, const Left(tFailure));
        expect((result as Left).value.message, 'Tournament not found');
      },
    );

    test('5. GetTournamentByIdParams props equality works correctly', () {
      const tParams2 = GetTournamentByIdParams(tournamentId: tTournamentId);
      expect(tParams, tParams2);
    });
  });
}
