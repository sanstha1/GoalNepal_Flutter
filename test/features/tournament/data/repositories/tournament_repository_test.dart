import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_nepal/core/error/failures.dart';
import 'package:goal_nepal/core/services/connectivity/network_info.dart';
import 'package:goal_nepal/features/tournament/data/datasources/tournament_datasource.dart';
import 'package:goal_nepal/features/tournament/data/models/tournament_api_model.dart';
import 'package:goal_nepal/features/tournament/data/models/tournament_hive_model.dart';
import 'package:goal_nepal/features/tournament/data/repositories/tournament_repository.dart';
import 'package:goal_nepal/features/tournament/domain/entities/tournament_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockTournamentLocalDatasource extends Mock
    implements ITournamentLocalDataSource {}

class MockTournamentRemoteDatasource extends Mock
    implements ITournamentRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockFile extends Mock implements File {}

void main() {
  late TournamentRepository repository;
  late MockTournamentLocalDatasource mockLocalDatasource;
  late MockTournamentRemoteDatasource mockRemoteDatasource;
  late MockNetworkInfo mockNetworkInfo;

  final tStartDate = DateTime(2025, 6, 1);
  final tEndDate = DateTime(2025, 6, 30);
  final tCreatedAt = DateTime(2025, 1, 1);
  final tUpdatedAt = DateTime(2025, 1, 2);

  final tTournamentEntity = TournamentEntity(
    tournamentId: 'tournament_001',
    title: 'Goal Nepal Cup 2025',
    type: TournamentType.football,
    location: 'Kathmandu',
    startDate: tStartDate,
    endDate: tEndDate,
    organizer: 'Goal Nepal',
    description: 'Annual football tournament',
    prize: 'NPR 100,000',
    maxTeams: 16,
    bannerImage: 'https://cdn.example.com/banner.jpg',
    createdBy: 'user_123',
    createdAt: tCreatedAt,
    updatedAt: tUpdatedAt,
  );

  final tTournamentApiModel = TournamentApiModel(
    tournamentId: 'tournament_001',
    title: 'Goal Nepal Cup 2025',
    type: 'football',
    location: 'Kathmandu',
    startDate: tStartDate,
    endDate: tEndDate,
    organizer: 'Goal Nepal',
    createdBy: 'user_123',
    createdAt: tCreatedAt,
    updatedAt: tUpdatedAt,
  );

  final tTournamentHiveModel = TournamentHiveModel(
    tournamentId: 'tournament_001',
    title: 'Goal Nepal Cup 2025',
    type: 'football',
    location: 'Kathmandu',
    startDate: tStartDate,
    endDate: tEndDate,
    createdBy: 'user_123',
    createdAt: tCreatedAt,
    updatedAt: tUpdatedAt,
  );

  setUp(() {
    mockLocalDatasource = MockTournamentLocalDatasource();
    mockRemoteDatasource = MockTournamentRemoteDatasource();
    mockNetworkInfo = MockNetworkInfo();
    repository = TournamentRepository(
      localDatasource: mockLocalDatasource,
      remoteDatasource: mockRemoteDatasource,
      networkInfo: mockNetworkInfo,
    );
  });

  setUpAll(() {
    registerFallbackValue(
      TournamentApiModel(
        title: 'fallback',
        type: 'football',
        location: 'fallback',
        startDate: DateTime(2025),
        endDate: DateTime(2025),
      ),
    );
    registerFallbackValue(
      TournamentHiveModel(
        title: 'fallback',
        type: 'football',
        location: 'fallback',
        startDate: DateTime(2025),
        endDate: DateTime(2025),
      ),
    );
    registerFallbackValue(MockFile());
  });

  group('uploadBanner', () {
    test('should return Right(url) when online and upload succeeds', () async {
      // Arrange
      final mockFile = MockFile();
      const tUrl = 'https://cdn.example.com/banner.jpg';
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockRemoteDatasource.uploadBanner(any()),
      ).thenAnswer((_) async => tUrl);

      // Act
      final result = await repository.uploadBanner(mockFile);

      // Assert
      expect(result, const Right(tUrl));
      verify(() => mockRemoteDatasource.uploadBanner(any())).called(1);
    });

    test(
      'should return Left(ApiFailure) when online and upload throws',
      () async {
        // Arrange
        final mockFile = MockFile();
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockRemoteDatasource.uploadBanner(any()),
        ).thenThrow(Exception('Upload failed'));

        // Act
        final result = await repository.uploadBanner(mockFile);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<ApiFailure>()),
          (_) => fail('Should return failure'),
        );
      },
    );

    test('should return Left(NetworkFailure) when offline', () async {
      // Arrange
      final mockFile = MockFile();
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final result = await repository.uploadBanner(mockFile);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('Should return failure'),
      );
      verifyNever(() => mockRemoteDatasource.uploadBanner(any()));
    });
  });

  group('createTournament', () {
    test(
      'should return Right(true) when online and creation succeeds',
      () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockRemoteDatasource.createTournament(
            any(),
            bannerFile: any(named: 'bannerFile'),
          ),
        ).thenAnswer((_) async {});

        // Act
        final result = await repository.createTournament(tTournamentEntity);

        // Assert
        expect(result, const Right(true));
        verify(
          () => mockRemoteDatasource.createTournament(
            any(),
            bannerFile: any(named: 'bannerFile'),
          ),
        ).called(1);
      },
    );

    test(
      'should return Left(ApiFailure) when online and creation throws',
      () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockRemoteDatasource.createTournament(
            any(),
            bannerFile: any(named: 'bannerFile'),
          ),
        ).thenThrow(Exception('Creation failed'));

        // Act
        final result = await repository.createTournament(tTournamentEntity);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<ApiFailure>()),
          (_) => fail('Should return failure'),
        );
      },
    );

    test('should return Left(NetworkFailure) when offline', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final result = await repository.createTournament(tTournamentEntity);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('Should return failure'),
      );
    });
  });

  group('deleteTournament', () {
    test(
      'should return Right(true) when online and deletion succeeds',
      () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockRemoteDatasource.deleteTournament(any()),
        ).thenAnswer((_) async {});

        // Act
        final result = await repository.deleteTournament('tournament_001');

        // Assert
        expect(result, const Right(true));
        verify(() => mockRemoteDatasource.deleteTournament(any())).called(1);
      },
    );

    test(
      'should return Left(ApiFailure) when online and deletion throws',
      () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockRemoteDatasource.deleteTournament(any()),
        ).thenThrow(Exception('Delete failed'));

        // Act
        final result = await repository.deleteTournament('tournament_001');

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<ApiFailure>()),
          (_) => fail('Should return failure'),
        );
      },
    );

    test(
      'should delete locally when offline and local deletion succeeds',
      () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(
          () => mockLocalDatasource.deleteTournament(any()),
        ).thenAnswer((_) async => true);

        // Act
        final result = await repository.deleteTournament('tournament_001');

        // Assert
        expect(result, const Right(true));
        verify(() => mockLocalDatasource.deleteTournament(any())).called(1);
        verifyNever(() => mockRemoteDatasource.deleteTournament(any()));
      },
    );

    test(
      'should return Left(LocalDatabaseFailure) when offline and local deletion returns false',
      () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(
          () => mockLocalDatasource.deleteTournament(any()),
        ).thenAnswer((_) async => false);

        // Act
        final result = await repository.deleteTournament('tournament_001');

        // Assert
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<LocalDatabaseFailure>());
          expect(
            (failure as LocalDatabaseFailure).message,
            'Failed to delete tournament',
          );
        }, (_) => fail('Should return failure'));
      },
    );
  });

  group('getAllTournaments', () {
    test(
      'should return Right(List<TournamentEntity>) when online and fetch succeeds',
      () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockRemoteDatasource.getAllTournaments(),
        ).thenAnswer((_) async => [tTournamentApiModel]);

        // Act
        final result = await repository.getAllTournaments();

        // Assert
        expect(result.isRight(), true);
        result.fold((_) => fail('Should return list'), (list) {
          expect(list.length, 1);
          expect(list[0].title, 'Goal Nepal Cup 2025');
          expect(list[0].type, TournamentType.football);
        });
      },
    );

    test(
      'should return Left(ApiFailure) when online and fetch throws',
      () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockRemoteDatasource.getAllTournaments(),
        ).thenThrow(Exception('Fetch failed'));

        // Act
        final result = await repository.getAllTournaments();

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<ApiFailure>()),
          (_) => fail('Should return failure'),
        );
      },
    );

    test(
      'should return Right(List<TournamentEntity>) from local when offline and fetch succeeds',
      () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(
          () => mockLocalDatasource.getAllTournaments(),
        ).thenAnswer((_) async => [tTournamentHiveModel]);

        // Act
        final result = await repository.getAllTournaments();

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should return list'),
          (list) => expect(list.length, 1),
        );
        verifyNever(() => mockRemoteDatasource.getAllTournaments());
      },
    );

    test(
      'should return Left(LocalDatabaseFailure) when offline and local fetch throws',
      () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(
          () => mockLocalDatasource.getAllTournaments(),
        ).thenThrow(Exception('Local fetch failed'));

        // Act
        final result = await repository.getAllTournaments();

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<LocalDatabaseFailure>()),
          (_) => fail('Should return failure'),
        );
      },
    );
  });

  group('getTournamentById', () {
    test(
      'should return Right(TournamentEntity) when online and fetch succeeds',
      () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockRemoteDatasource.getTournamentById(any()),
        ).thenAnswer((_) async => tTournamentApiModel);

        // Act
        final result = await repository.getTournamentById('tournament_001');

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should return entity'),
          (entity) => expect(entity.title, 'Goal Nepal Cup 2025'),
        );
      },
    );

    test(
      'should return Left(ApiFailure) when online and fetch throws',
      () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockRemoteDatasource.getTournamentById(any()),
        ).thenThrow(Exception('Not found'));

        // Act
        final result = await repository.getTournamentById('tournament_001');

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<ApiFailure>()),
          (_) => fail('Should return failure'),
        );
      },
    );

    test(
      'should return Right(TournamentEntity) from local when offline and found',
      () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(
          () => mockLocalDatasource.getTournamentById(any()),
        ).thenAnswer((_) async => tTournamentHiveModel);

        // Act
        final result = await repository.getTournamentById('tournament_001');

        // Assert
        expect(result.isRight(), true);
        verifyNever(() => mockRemoteDatasource.getTournamentById(any()));
      },
    );

    test(
      'should return Left(LocalDatabaseFailure) when offline and not found locally',
      () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(
          () => mockLocalDatasource.getTournamentById(any()),
        ).thenAnswer((_) async => null);

        // Act
        final result = await repository.getTournamentById('tournament_001');

        // Assert
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<LocalDatabaseFailure>());
          expect(
            (failure as LocalDatabaseFailure).message,
            'Tournament not found',
          );
        }, (_) => fail('Should return failure'));
      },
    );
  });

  group('getMyTournaments', () {
    test(
      'should return Right(List<TournamentEntity>) when online and fetch succeeds',
      () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockRemoteDatasource.getMyTournaments(),
        ).thenAnswer((_) async => [tTournamentApiModel]);

        // Act
        final result = await repository.getMyTournaments('user_123');

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should return list'),
          (list) => expect(list.length, 1),
        );
      },
    );

    test(
      'should return Left(ApiFailure) when online and fetch throws',
      () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockRemoteDatasource.getMyTournaments(),
        ).thenThrow(Exception('Fetch failed'));

        // Act
        final result = await repository.getMyTournaments('user_123');

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<ApiFailure>()),
          (_) => fail('Should return failure'),
        );
      },
    );

    test(
      'should fetch from local datasource using userId when offline',
      () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(
          () => mockLocalDatasource.getTournamentsByUser(any()),
        ).thenAnswer((_) async => [tTournamentHiveModel]);

        // Act
        final result = await repository.getMyTournaments('user_123');

        // Assert
        expect(result.isRight(), true);
        verify(
          () => mockLocalDatasource.getTournamentsByUser('user_123'),
        ).called(1);
        verifyNever(() => mockRemoteDatasource.getMyTournaments());
      },
    );
  });

  group('updateTournament', () {
    test('should return Right(true) when online and update succeeds', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockRemoteDatasource.updateTournament(
          any(),
          bannerFile: any(named: 'bannerFile'),
        ),
      ).thenAnswer((_) async {});

      // Act
      final result = await repository.updateTournament(tTournamentEntity);

      // Assert
      expect(result, const Right(true));
      verify(
        () => mockRemoteDatasource.updateTournament(
          any(),
          bannerFile: any(named: 'bannerFile'),
        ),
      ).called(1);
    });

    test(
      'should return Left(ApiFailure) when online and update throws',
      () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockRemoteDatasource.updateTournament(
            any(),
            bannerFile: any(named: 'bannerFile'),
          ),
        ).thenThrow(Exception('Update failed'));

        // Act
        final result = await repository.updateTournament(tTournamentEntity);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<ApiFailure>()),
          (_) => fail('Should return failure'),
        );
      },
    );

    test('should update locally when offline and update succeeds', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(
        () => mockLocalDatasource.updateTournament(any()),
      ).thenAnswer((_) async => true);

      // Act
      final result = await repository.updateTournament(tTournamentEntity);

      // Assert
      expect(result, const Right(true));
      verify(() => mockLocalDatasource.updateTournament(any())).called(1);
      verifyNever(
        () => mockRemoteDatasource.updateTournament(
          any(),
          bannerFile: any(named: 'bannerFile'),
        ),
      );
    });

    test(
      'should return Left(LocalDatabaseFailure) when offline and update returns false',
      () async {
        // Arrange
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(
          () => mockLocalDatasource.updateTournament(any()),
        ).thenAnswer((_) async => false);

        // Act
        final result = await repository.updateTournament(tTournamentEntity);

        // Assert
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<LocalDatabaseFailure>());
          expect(
            (failure as LocalDatabaseFailure).message,
            'Failed to update tournament',
          );
        }, (_) => fail('Should return failure'));
      },
    );
  });
}
