import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_nepal/core/error/failures.dart';
import 'package:goal_nepal/features/tournament/domain/entities/tournament_entity.dart';
import 'package:goal_nepal/features/tournament/domain/repositories/tournament_repository.dart';
import 'package:goal_nepal/features/tournament/domain/usecases/get_all_tournament_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockTournamentRepository extends Mock implements ITournamentRepository {}

void main() {
  late GetAllTournamentsUsecase usecase;
  late MockTournamentRepository mockRepository;

  setUp(() {
    mockRepository = MockTournamentRepository();
    usecase = GetAllTournamentsUsecase(repository: mockRepository);
  });

  final tTournaments = [
    TournamentEntity(
      tournamentId: '1',
      title: 'Goal Nepal Cup 2025',
      type: TournamentType.football,
      location: 'Kathmandu',
      startDate: DateTime(2025, 6, 1),
      endDate: DateTime(2025, 6, 30),
    ),
    TournamentEntity(
      tournamentId: '2',
      title: 'Futsal Premier League',
      type: TournamentType.futsal,
      location: 'Pokhara',
      startDate: DateTime(2025, 7, 1),
      endDate: DateTime(2025, 7, 31),
    ),
  ];

  group('GetAllTournamentsUsecase', () {
    test('1. should return Right(List<TournamentEntity>) on success', () async {
      when(
        () => mockRepository.getAllTournaments(),
      ).thenAnswer((_) async => Right(tTournaments));

      final result = await usecase();

      expect(result, Right(tTournaments));
      verify(() => mockRepository.getAllTournaments()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test(
      '2. should return Right with empty list when no tournaments exist',
      () async {
        when(
          () => mockRepository.getAllTournaments(),
        ).thenAnswer((_) async => const Right([]));

        final result = await usecase();

        expect(result, const Right(<TournamentEntity>[]));
        expect((result as Right).value, isEmpty);
      },
    );

    test('3. should return correct number of tournaments', () async {
      when(
        () => mockRepository.getAllTournaments(),
      ).thenAnswer((_) async => Right(tTournaments));

      final result = await usecase();

      expect((result as Right).value.length, 2);
    });

    test('4. should return Left(ApiFailure) when repository fails', () async {
      const tFailure = ApiFailure(message: 'Failed to fetch tournaments');
      when(
        () => mockRepository.getAllTournaments(),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await usecase();

      expect(result, const Left(tFailure));
      expect((result as Left).value.message, 'Failed to fetch tournaments');
    });

    test(
      '5. should return Left(NetworkFailure) when device is offline',
      () async {
        const tFailure = NetworkFailure();
        when(
          () => mockRepository.getAllTournaments(),
        ).thenAnswer((_) async => const Left(tFailure));

        final result = await usecase();

        expect(result, isA<Left>());
        expect((result as Left).value, isA<NetworkFailure>());
      },
    );
  });
}
