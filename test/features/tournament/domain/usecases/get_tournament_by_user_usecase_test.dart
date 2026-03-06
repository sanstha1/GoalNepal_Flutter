import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_nepal/core/error/failures.dart';
import 'package:goal_nepal/features/tournament/domain/entities/tournament_entity.dart';
import 'package:goal_nepal/features/tournament/domain/repositories/tournament_repository.dart';
import 'package:goal_nepal/features/tournament/domain/usecases/get_tournament_by_user_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockTournamentRepository extends Mock implements ITournamentRepository {}

void main() {
  late GetMyTournamentsUsecase usecase;
  late MockTournamentRepository mockRepository;

  setUp(() {
    mockRepository = MockTournamentRepository();
    usecase = GetMyTournamentsUsecase(repository: mockRepository);
  });

  const tUserId = 'user_123';
  const tParams = GetMyTournamentsParams(userId: tUserId);

  final tMyTournaments = [
    TournamentEntity(
      tournamentId: '1',
      title: 'My Football Cup',
      type: TournamentType.football,
      location: 'Kathmandu',
      startDate: DateTime(2025, 6, 1),
      endDate: DateTime(2025, 6, 30),
      createdBy: tUserId,
    ),
    TournamentEntity(
      tournamentId: '2',
      title: 'My Futsal League',
      type: TournamentType.futsal,
      location: 'Lalitpur',
      startDate: DateTime(2025, 8, 1),
      endDate: DateTime(2025, 8, 31),
      createdBy: tUserId,
    ),
  ];

  group('GetMyTournamentsUsecase', () {
    test('1. should return Right(List<TournamentEntity>) on success', () async {
      when(
        () => mockRepository.getMyTournaments(any()),
      ).thenAnswer((_) async => Right(tMyTournaments));

      final result = await usecase(tParams);

      expect(result, Right(tMyTournaments));
      verify(() => mockRepository.getMyTournaments(tUserId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test(
      '2. should return Right with empty list when user has no tournaments',
      () async {
        when(
          () => mockRepository.getMyTournaments(any()),
        ).thenAnswer((_) async => const Right([]));

        final result = await usecase(tParams);

        expect(result, const Right(<TournamentEntity>[]));
        expect((result as Right).value, isEmpty);
      },
    );

    test('3. should forward exact userId to repository', () async {
      String? capturedUserId;
      when(() => mockRepository.getMyTournaments(any())).thenAnswer((
        invocation,
      ) {
        capturedUserId = invocation.positionalArguments[0] as String;
        return Future.value(Right(tMyTournaments));
      });

      await usecase(tParams);

      expect(capturedUserId, tUserId);
    });

    test('4. should return Left(ApiFailure) when repository fails', () async {
      const tFailure = ApiFailure(message: 'Failed to fetch tournaments');
      when(
        () => mockRepository.getMyTournaments(any()),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await usecase(tParams);

      expect(result, const Left(tFailure));
      expect((result as Left).value.message, 'Failed to fetch tournaments');
    });

    test('5. GetMyTournamentsParams props equality works correctly', () {
      const tParams2 = GetMyTournamentsParams(userId: tUserId);
      expect(tParams, tParams2);
    });
  });
}
