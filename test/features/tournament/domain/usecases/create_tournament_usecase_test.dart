import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_nepal/core/error/failures.dart';
import 'package:goal_nepal/features/tournament/domain/entities/tournament_entity.dart';
import 'package:goal_nepal/features/tournament/domain/repositories/tournament_repository.dart';
import 'package:goal_nepal/features/tournament/domain/usecases/create_tournament_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockTournamentRepository extends Mock implements ITournamentRepository {}

class MockFile extends Mock implements File {}

void main() {
  late CreateTournamentUsecase usecase;
  late MockTournamentRepository mockRepository;

  setUp(() {
    mockRepository = MockTournamentRepository();
    usecase = CreateTournamentUsecase(mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(
      TournamentEntity(
        title: 'fallback',
        type: TournamentType.football,
        location: 'fallback',
        startDate: DateTime(2025),
        endDate: DateTime(2025),
        createdAt: DateTime(2025),
        updatedAt: DateTime(2025),
      ),
    );
    registerFallbackValue(MockFile());
  });

  final tStartDate = DateTime(2025, 6, 1);
  final tEndDate = DateTime(2025, 6, 30);

  final tParams = CreateTournamentParams(
    title: 'Goal Nepal Cup 2025',
    type: TournamentType.football,
    location: 'Kathmandu',
    startDate: tStartDate,
    endDate: tEndDate,
    organizer: 'Goal Nepal',
    description: 'Annual football tournament',
    prize: 'NPR 100,000',
    maxTeams: 16,
    createdBy: 'user_123',
  );

  group('CreateTournamentUsecase', () {
    test(
      '1. should return Right(true) on successful tournament creation',
      () async {
        when(
          () => mockRepository.createTournament(
            any(),
            bannerFile: any(named: 'bannerFile'),
          ),
        ).thenAnswer((_) async => const Right(true));

        final result = await usecase(tParams);

        expect(result, const Right(true));
        verify(
          () => mockRepository.createTournament(
            any(),
            bannerFile: any(named: 'bannerFile'),
          ),
        ).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test('2. should return Left(ApiFailure) when repository fails', () async {
      const tFailure = ApiFailure(message: 'Failed to create tournament');
      when(
        () => mockRepository.createTournament(
          any(),
          bannerFile: any(named: 'bannerFile'),
        ),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await usecase(tParams);

      expect(result, const Left(tFailure));
      expect((result as Left).value.message, 'Failed to create tournament');
    });

    test(
      '3. should return Left(NetworkFailure) when device is offline',
      () async {
        const tFailure = NetworkFailure();
        when(
          () => mockRepository.createTournament(
            any(),
            bannerFile: any(named: 'bannerFile'),
          ),
        ).thenAnswer((_) async => const Left(tFailure));

        final result = await usecase(tParams);

        expect(result, isA<Left>());
        expect((result as Left).value, isA<NetworkFailure>());
      },
    );

    test('4. should pass correct tournament fields to repository', () async {
      TournamentEntity? capturedEntity;

      when(
        () => mockRepository.createTournament(
          any(),
          bannerFile: any(named: 'bannerFile'),
        ),
      ).thenAnswer((invocation) {
        capturedEntity = invocation.positionalArguments[0] as TournamentEntity;
        return Future.value(const Right(true));
      });

      await usecase(tParams);

      expect(capturedEntity?.title, tParams.title);
      expect(capturedEntity?.type, tParams.type);
      expect(capturedEntity?.location, tParams.location);
      expect(capturedEntity?.startDate, tParams.startDate);
      expect(capturedEntity?.endDate, tParams.endDate);
      expect(capturedEntity?.organizer, tParams.organizer);
      expect(capturedEntity?.description, tParams.description);
      expect(capturedEntity?.prize, tParams.prize);
      expect(capturedEntity?.maxTeams, tParams.maxTeams);
      expect(capturedEntity?.createdBy, tParams.createdBy);
    });

    test('5. should pass bannerFile to repository when provided', () async {
      final mockFile = MockFile();
      File? capturedFile;

      final tParamsWithBanner = CreateTournamentParams(
        title: 'Goal Nepal Cup 2025',
        type: TournamentType.football,
        location: 'Kathmandu',
        startDate: tStartDate,
        endDate: tEndDate,
        bannerImage: mockFile,
      );

      when(
        () => mockRepository.createTournament(
          any(),
          bannerFile: any(named: 'bannerFile'),
        ),
      ).thenAnswer((invocation) {
        capturedFile = invocation.namedArguments[#bannerFile] as File?;
        return Future.value(const Right(true));
      });

      await usecase(tParamsWithBanner);

      expect(capturedFile, mockFile);
    });

    test(
      '6. should pass null bannerFile to repository when not provided',
      () async {
        File? capturedFile = MockFile();

        when(
          () => mockRepository.createTournament(
            any(),
            bannerFile: any(named: 'bannerFile'),
          ),
        ).thenAnswer((invocation) {
          capturedFile = invocation.namedArguments[#bannerFile] as File?;
          return Future.value(const Right(true));
        });

        await usecase(tParams);

        expect(capturedFile, isNull);
      },
    );

    test(
      '7. should set createdAt and updatedAt on the tournament entity',
      () async {
        TournamentEntity? capturedEntity;

        when(
          () => mockRepository.createTournament(
            any(),
            bannerFile: any(named: 'bannerFile'),
          ),
        ).thenAnswer((invocation) {
          capturedEntity =
              invocation.positionalArguments[0] as TournamentEntity;
          return Future.value(const Right(true));
        });

        final before = DateTime.now();
        await usecase(tParams);
        final after = DateTime.now();

        expect(capturedEntity?.createdAt, isNotNull);
        expect(capturedEntity?.updatedAt, isNotNull);
        expect(
          capturedEntity!.createdAt!.isAfter(before) ||
              capturedEntity!.createdAt!.isAtSameMomentAs(before),
          isTrue,
        );
        expect(
          capturedEntity!.createdAt!.isBefore(after) ||
              capturedEntity!.createdAt!.isAtSameMomentAs(after),
          isTrue,
        );
      },
    );

    test(
      '8. should work with only required params (all optional fields null)',
      () async {
        final tMinimalParams = CreateTournamentParams(
          title: 'Basic Cup',
          type: TournamentType.futsal,
          location: 'Pokhara',
          startDate: tStartDate,
          endDate: tEndDate,
        );

        when(
          () => mockRepository.createTournament(
            any(),
            bannerFile: any(named: 'bannerFile'),
          ),
        ).thenAnswer((_) async => const Right(true));

        final result = await usecase(tMinimalParams);

        expect(result, const Right(true));
      },
    );

    test('9. CreateTournamentParams props equality works correctly', () {
      final tParams2 = CreateTournamentParams(
        title: 'Goal Nepal Cup 2025',
        type: TournamentType.football,
        location: 'Kathmandu',
        startDate: tStartDate,
        endDate: tEndDate,
        organizer: 'Goal Nepal',
        description: 'Annual football tournament',
        prize: 'NPR 100,000',
        maxTeams: 16,
        createdBy: 'user_123',
      );

      expect(tParams, tParams2);
    });

    test(
      '10. should call repository exactly once per usecase invocation',
      () async {
        when(
          () => mockRepository.createTournament(
            any(),
            bannerFile: any(named: 'bannerFile'),
          ),
        ).thenAnswer((_) async => const Right(true));

        await usecase(tParams);
        await usecase(tParams);

        verify(
          () => mockRepository.createTournament(
            any(),
            bannerFile: any(named: 'bannerFile'),
          ),
        ).called(2);
      },
    );
  });
}
