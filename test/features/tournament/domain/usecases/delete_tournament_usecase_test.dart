import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_nepal/core/error/failures.dart';
import 'package:goal_nepal/features/tournament/domain/repositories/tournament_repository.dart';
import 'package:goal_nepal/features/tournament/domain/usecases/delete_tournament_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockTournamentRepository extends Mock implements ITournamentRepository {}

void main() {
  late DeleteTournamentUsecase usecase;
  late MockTournamentRepository mockRepository;

  setUp(() {
    mockRepository = MockTournamentRepository();
    usecase = DeleteTournamentUsecase(repository: mockRepository);
  });

  const tTournamentId = 'tournament_001';
  const tParams = DeleteTournamentParams(tournamentId: tTournamentId);

  group('DeleteTournamentUsecase', () {
    test('1. should return Right(true) on successful deletion', () async {
      when(
        () => mockRepository.deleteTournament(any()),
      ).thenAnswer((_) async => const Right(true));

      final result = await usecase(tParams);

      expect(result, const Right(true));
      verify(() => mockRepository.deleteTournament(tTournamentId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test(
      '2. should return Left(ApiFailure) when tournament not found',
      () async {
        const tFailure = ApiFailure(message: 'Tournament not found');
        when(
          () => mockRepository.deleteTournament(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        final result = await usecase(tParams);

        expect(result, const Left(tFailure));
        expect((result as Left).value.message, 'Tournament not found');
      },
    );

    test(
      '3. should return Left(NetworkFailure) when device is offline',
      () async {
        const tFailure = NetworkFailure();
        when(
          () => mockRepository.deleteTournament(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        final result = await usecase(tParams);

        expect(result, isA<Left>());
        expect((result as Left).value, isA<NetworkFailure>());
      },
    );

    test('4. should forward exact tournamentId string to repository', () async {
      String? capturedId;
      when(() => mockRepository.deleteTournament(any())).thenAnswer((
        invocation,
      ) {
        capturedId = invocation.positionalArguments[0] as String;
        return Future.value(const Right(true));
      });

      await usecase(tParams);

      expect(capturedId, tTournamentId);
    });

    test('5. DeleteTournamentParams props equality works correctly', () {
      const tParams2 = DeleteTournamentParams(tournamentId: tTournamentId);
      expect(tParams, tParams2);
    });
  });
}
