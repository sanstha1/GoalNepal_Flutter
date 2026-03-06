import 'package:flutter_test/flutter_test.dart';
import 'package:goal_nepal/core/services/hive/hive_service.dart';
import 'package:goal_nepal/features/tournament/data/datasources/local/tournament_local_datasource.dart';
import 'package:goal_nepal/features/tournament/data/models/tournament_hive_model.dart';
import 'package:mocktail/mocktail.dart';

class MockHiveService extends Mock implements HiveService {}

void main() {
  late TournamentLocalDatasource datasource;
  late MockHiveService mockHiveService;

  setUp(() {
    mockHiveService = MockHiveService();
    datasource = TournamentLocalDatasource(hiveService: mockHiveService);
  });

  final tTournamentHiveModel = TournamentHiveModel(
    tournamentId: '1',
    title: 'Test Tournament',
    location: 'Test Location',
    description: 'Test Description',
    organizer: 'Test Organizer',
    type: 'football',
    startDate: DateTime(2025, 6, 1),
    endDate: DateTime(2025, 6, 10),
    bannerImage: null,
  );

  final tTournamentHiveModelList = [
    TournamentHiveModel(
      tournamentId: '1',
      title: 'Football Cup',
      location: 'Kathmandu',
      description: 'Football tournament',
      organizer: 'Org1',
      type: 'football',
      startDate: DateTime(2025, 6, 1),
      endDate: DateTime(2025, 6, 10),
      bannerImage: null,
    ),
    TournamentHiveModel(
      tournamentId: '2',
      title: 'Futsal League',
      location: 'Pokhara',
      description: 'Futsal tournament',
      organizer: 'Org2',
      type: 'futsal',
      startDate: DateTime(2025, 7, 1),
      endDate: DateTime(2025, 7, 10),
      bannerImage: null,
    ),
  ];

  group('createTournament', () {
    test(
      'should return true when tournament is created successfully',
      () async {
        // Arrange
        when(
          () => mockHiveService.createTournament(tTournamentHiveModel),
        ).thenAnswer((_) async => tTournamentHiveModel);

        // Act
        final result = await datasource.createTournament(tTournamentHiveModel);

        // Assert
        expect(result, true);
        verify(
          () => mockHiveService.createTournament(tTournamentHiveModel),
        ).called(1);
      },
    );

    test('should return false when hive service throws exception', () async {
      // Arrange
      when(
        () => mockHiveService.createTournament(tTournamentHiveModel),
      ).thenThrow(Exception('Database error'));

      // Act
      final result = await datasource.createTournament(tTournamentHiveModel);

      // Assert
      expect(result, false);
    });
  });

  group('deleteTournament', () {
    test(
      'should return true when tournament is deleted successfully',
      () async {
        // Arrange
        when(
          () => mockHiveService.deleteTournament('1'),
        ).thenAnswer((_) async {});

        // Act
        final result = await datasource.deleteTournament('1');

        // Assert
        expect(result, true);
        verify(() => mockHiveService.deleteTournament('1')).called(1);
      },
    );

    test('should return false when hive service throws exception', () async {
      // Arrange
      when(
        () => mockHiveService.deleteTournament('1'),
      ).thenThrow(Exception('Database error'));

      // Act
      final result = await datasource.deleteTournament('1');

      // Assert
      expect(result, false);
    });
  });

  group('getAllTournaments', () {
    test('should return list of tournaments when successful', () async {
      // Arrange
      when(
        () => mockHiveService.getAllTournaments(),
      ).thenReturn(tTournamentHiveModelList);

      // Act
      final result = await datasource.getAllTournaments();

      // Assert
      expect(result, tTournamentHiveModelList);
      expect(result.length, 2);
      verify(() => mockHiveService.getAllTournaments()).called(1);
    });

    test(
      'should return empty list when hive service throws exception',
      () async {
        // Arrange
        when(
          () => mockHiveService.getAllTournaments(),
        ).thenThrow(Exception('Database error'));

        // Act
        final result = await datasource.getAllTournaments();

        // Assert
        expect(result, isEmpty);
      },
    );
  });

  group('getTournamentById', () {
    test('should return tournament when found', () async {
      // Arrange
      when(
        () => mockHiveService.getTournamentById('1'),
      ).thenReturn(tTournamentHiveModel);

      // Act
      final result = await datasource.getTournamentById('1');

      // Assert
      expect(result, tTournamentHiveModel);
      verify(() => mockHiveService.getTournamentById('1')).called(1);
    });

    test('should return null when tournament not found', () async {
      // Arrange
      when(() => mockHiveService.getTournamentById('999')).thenReturn(null);

      // Act
      final result = await datasource.getTournamentById('999');

      // Assert
      expect(result, isNull);
    });

    test('should return null when hive service throws exception', () async {
      // Arrange
      when(
        () => mockHiveService.getTournamentById('1'),
      ).thenThrow(Exception('Database error'));

      // Act
      final result = await datasource.getTournamentById('1');

      // Assert
      expect(result, isNull);
    });
  });

  group('getTournamentsByUser', () {
    test('should return list of tournaments for user', () async {
      // Arrange
      final userTournaments = [tTournamentHiveModelList[0]];
      when(
        () => mockHiveService.getTournamentsByUser('user1'),
      ).thenReturn(userTournaments);

      // Act
      final result = await datasource.getTournamentsByUser('user1');

      // Assert
      expect(result, userTournaments);
      expect(result.length, 1);
      verify(() => mockHiveService.getTournamentsByUser('user1')).called(1);
    });

    test(
      'should return empty list when hive service throws exception',
      () async {
        // Arrange
        when(
          () => mockHiveService.getTournamentsByUser('user1'),
        ).thenThrow(Exception('Database error'));

        // Act
        final result = await datasource.getTournamentsByUser('user1');

        // Assert
        expect(result, isEmpty);
      },
    );
  });

  group('getFootballTournaments', () {
    test('should return list of football tournaments', () async {
      // Arrange
      when(
        () => mockHiveService.getAllTournaments(),
      ).thenReturn(tTournamentHiveModelList);

      // Act
      final result = await datasource.getFootballTournaments();

      // Assert
      expect(result.length, 1);
      expect(result[0].type, 'football');
      verify(() => mockHiveService.getAllTournaments()).called(1);
    });

    test(
      'should return empty list when hive service throws exception',
      () async {
        // Arrange
        when(
          () => mockHiveService.getAllTournaments(),
        ).thenThrow(Exception('Database error'));

        // Act
        final result = await datasource.getFootballTournaments();

        // Assert
        expect(result, isEmpty);
      },
    );
  });

  group('getFutsalTournaments', () {
    test('should return list of futsal tournaments', () async {
      // Arrange
      when(
        () => mockHiveService.getAllTournaments(),
      ).thenReturn(tTournamentHiveModelList);

      // Act
      final result = await datasource.getFutsalTournaments();

      // Assert
      expect(result.length, 1);
      expect(result[0].type, 'futsal');
      verify(() => mockHiveService.getAllTournaments()).called(1);
    });

    test(
      'should return empty list when hive service throws exception',
      () async {
        // Arrange
        when(
          () => mockHiveService.getAllTournaments(),
        ).thenThrow(Exception('Database error'));

        // Act
        final result = await datasource.getFutsalTournaments();

        // Assert
        expect(result, isEmpty);
      },
    );
  });

  group('updateTournament', () {
    test(
      'should return true when tournament is updated successfully',
      () async {
        // Arrange
        when(
          () => mockHiveService.updateTournament(tTournamentHiveModel),
        ).thenAnswer((_) async => true);

        // Act
        final result = await datasource.updateTournament(tTournamentHiveModel);

        // Assert
        expect(result, true);
        verify(
          () => mockHiveService.updateTournament(tTournamentHiveModel),
        ).called(1);
      },
    );

    test(
      'should return true even when hive service returns false (no exception)',
      () async {
        // Note: The datasource implementation returns true if no exception is thrown,
        // regardless of HiveService.updateTournament's return value.
        // Arrange
        when(
          () => mockHiveService.updateTournament(tTournamentHiveModel),
        ).thenAnswer((_) async => false);

        // Act
        final result = await datasource.updateTournament(tTournamentHiveModel);

        // Assert
        expect(result, true);
      },
    );

    test('should return false when hive service throws exception', () async {
      // Arrange
      when(
        () => mockHiveService.updateTournament(tTournamentHiveModel),
      ).thenThrow(Exception('Database error'));

      // Act
      final result = await datasource.updateTournament(tTournamentHiveModel);

      // Assert
      expect(result, false);
    });
  });

  group('uploadTournamentBanner', () {
    test('should return true when banner is uploaded successfully', () async {
      // Arrange
      when(
        () => mockHiveService.uploadTournamentBanner('1', 'path/to/banner.jpg'),
      ).thenAnswer((_) async => true);

      // Act
      final result = await datasource.uploadTournamentBanner(
        '1',
        'path/to/banner.jpg',
      );

      // Assert
      expect(result, true);
      verify(
        () => mockHiveService.uploadTournamentBanner('1', 'path/to/banner.jpg'),
      ).called(1);
    });

    test('should return false when hive service returns false', () async {
      // Arrange
      when(
        () => mockHiveService.uploadTournamentBanner('1', 'path/to/banner.jpg'),
      ).thenAnswer((_) async => false);

      // Act
      final result = await datasource.uploadTournamentBanner(
        '1',
        'path/to/banner.jpg',
      );

      // Assert
      expect(result, false);
    });

    test('should return false when hive service throws exception', () async {
      // Arrange
      when(
        () => mockHiveService.uploadTournamentBanner('1', 'path/to/banner.jpg'),
      ).thenThrow(Exception('Upload error'));

      // Act
      final result = await datasource.uploadTournamentBanner(
        '1',
        'path/to/banner.jpg',
      );

      // Assert
      expect(result, false);
    });
  });
}
