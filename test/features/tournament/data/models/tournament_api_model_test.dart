import 'package:flutter_test/flutter_test.dart';
import 'package:goal_nepal/features/tournament/data/models/tournament_api_model.dart';
import 'package:goal_nepal/features/tournament/domain/entities/tournament_entity.dart';

void main() {
  group('TournamentApiModel', () {
    final tStartDate = DateTime(2025, 6, 1, 0, 0, 0);
    final tEndDate = DateTime(2025, 6, 30, 0, 0, 0);
    final tCreatedAt = DateTime(2025, 1, 1, 12, 0, 0);
    final tUpdatedAt = DateTime(2025, 1, 2, 12, 0, 0);

    final tTournamentApiModel = TournamentApiModel(
      tournamentId: '1',
      title: 'Goal Nepal Cup 2025',
      type: 'football',
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

    final tTournamentEntity = TournamentEntity(
      tournamentId: '1',
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

    group('fromJson', () {
      test('should return a valid model from JSON', () {
        // Arrange
        final json = {
          '_id': '1',
          'title': 'Goal Nepal Cup 2025',
          'type': 'football',
          'location': 'Kathmandu',
          'startDate': '2025-06-01T00:00:00.000',
          'endDate': '2025-06-30T00:00:00.000',
          'organizer': 'Goal Nepal',
          'description': 'Annual football tournament',
          'prize': 'NPR 100,000',
          'maxTeams': 16,
          'bannerImage': 'https://cdn.example.com/banner.jpg',
          'createdBy': 'user_123',
          'createdAt': '2025-01-01T12:00:00.000',
          'updatedAt': '2025-01-02T12:00:00.000',
        };

        // Act
        final result = TournamentApiModel.fromJson(json);

        // Assert
        expect(result.tournamentId, '1');
        expect(result.title, 'Goal Nepal Cup 2025');
        expect(result.type, 'football');
        expect(result.location, 'Kathmandu');
        expect(result.startDate, tStartDate);
        expect(result.endDate, tEndDate);
        expect(result.organizer, 'Goal Nepal');
        expect(result.maxTeams, 16);
      });

      test('should handle nested createdBy object', () {
        // Arrange
        final json = {
          '_id': '1',
          'title': 'Goal Nepal Cup',
          'type': 'football',
          'location': 'Kathmandu',
          'startDate': '2025-06-01T00:00:00.000',
          'endDate': '2025-06-30T00:00:00.000',
          'createdBy': {'_id': 'user_123', 'name': 'Santosh'},
        };

        // Act
        final result = TournamentApiModel.fromJson(json);

        // Assert
        expect(result.createdBy, 'user_123');
      });

      test('should handle null createdBy', () {
        // Arrange
        final json = {
          '_id': '1',
          'title': 'Goal Nepal Cup',
          'type': 'football',
          'location': 'Kathmandu',
          'startDate': '2025-06-01T00:00:00.000',
          'endDate': '2025-06-30T00:00:00.000',
          'createdBy': null,
        };

        // Act
        final result = TournamentApiModel.fromJson(json);

        // Assert
        expect(result.createdBy, isNull);
      });

      test('should handle null optional fields', () {
        // Arrange
        final json = {
          '_id': '1',
          'title': 'Goal Nepal Cup',
          'type': 'futsal',
          'location': 'Pokhara',
          'startDate': '2025-06-01T00:00:00.000',
          'endDate': '2025-06-30T00:00:00.000',
        };

        // Act
        final result = TournamentApiModel.fromJson(json);

        // Assert
        expect(result.organizer, isNull);
        expect(result.description, isNull);
        expect(result.prize, isNull);
        expect(result.maxTeams, isNull);
        expect(result.bannerImage, isNull);
        expect(result.createdAt, isNull);
        expect(result.updatedAt, isNull);
      });

      test('should parse startDate and endDate correctly', () {
        // Arrange
        final json = {
          '_id': '1',
          'title': 'Goal Nepal Cup',
          'type': 'football',
          'location': 'Kathmandu',
          'startDate': '2025-06-01T00:00:00.000',
          'endDate': '2025-06-30T00:00:00.000',
        };

        // Act
        final result = TournamentApiModel.fromJson(json);

        // Assert
        expect(result.startDate, DateTime(2025, 6, 1));
        expect(result.endDate, DateTime(2025, 6, 30));
      });
    });

    group('toJson', () {
      test('should return a valid JSON map with all fields', () {
        // Act
        final result = tTournamentApiModel.toJson();

        // Assert
        expect(result['title'], 'Goal Nepal Cup 2025');
        expect(result['type'], 'football');
        expect(result['location'], 'Kathmandu');
        expect(result['organizer'], 'Goal Nepal');
        expect(result['description'], 'Annual football tournament');
        expect(result['prize'], 'NPR 100,000');
        expect(result['maxTeams'], 16);
        expect(result['bannerImage'], 'https://cdn.example.com/banner.jpg');
        expect(result['createdBy'], 'user_123');
      });

      test('should include startDate and endDate as ISO 8601 strings', () {
        // Act
        final result = tTournamentApiModel.toJson();

        // Assert
        expect(result['startDate'], tStartDate.toIso8601String());
        expect(result['endDate'], tEndDate.toIso8601String());
      });

      test('should omit null optional fields from JSON', () {
        // Arrange
        final minimalModel = TournamentApiModel(
          title: 'Basic Cup',
          type: 'futsal',
          location: 'Pokhara',
          startDate: tStartDate,
          endDate: tEndDate,
        );

        // Act
        final result = minimalModel.toJson();

        // Assert
        expect(result.containsKey('organizer'), isFalse);
        expect(result.containsKey('description'), isFalse);
        expect(result.containsKey('prize'), isFalse);
        expect(result.containsKey('maxTeams'), isFalse);
        expect(result.containsKey('bannerImage'), isFalse);
        expect(result.containsKey('createdBy'), isFalse);
      });
    });

    group('toEntity', () {
      test('should convert to TournamentEntity with football type', () {
        // Act
        final result = tTournamentApiModel.toEntity();

        // Assert
        expect(result.tournamentId, '1');
        expect(result.title, 'Goal Nepal Cup 2025');
        expect(result.type, TournamentType.football);
        expect(result.location, 'Kathmandu');
        expect(result.organizer, 'Goal Nepal');
        expect(result.maxTeams, 16);
        expect(result.createdBy, 'user_123');
      });

      test('should convert to TournamentEntity with futsal type', () {
        // Arrange
        final futsalModel = TournamentApiModel(
          tournamentId: '2',
          title: 'Futsal League',
          type: 'futsal',
          location: 'Lalitpur',
          startDate: tStartDate,
          endDate: tEndDate,
        );

        // Act
        final result = futsalModel.toEntity();

        // Assert
        expect(result.type, TournamentType.futsal);
      });

      test('should map all fields correctly to entity', () {
        // Act
        final result = tTournamentApiModel.toEntity();

        // Assert
        expect(result.startDate, tStartDate);
        expect(result.endDate, tEndDate);
        expect(result.description, 'Annual football tournament');
        expect(result.prize, 'NPR 100,000');
        expect(result.bannerImage, 'https://cdn.example.com/banner.jpg');
        expect(result.createdAt, tCreatedAt);
        expect(result.updatedAt, tUpdatedAt);
      });
    });

    group('fromEntity', () {
      test('should convert from TournamentEntity with football type', () {
        // Act
        final result = TournamentApiModel.fromEntity(tTournamentEntity);

        // Assert
        expect(result.tournamentId, '1');
        expect(result.title, 'Goal Nepal Cup 2025');
        expect(result.type, 'football');
        expect(result.location, 'Kathmandu');
        expect(result.organizer, 'Goal Nepal');
        expect(result.maxTeams, 16);
      });

      test('should convert from TournamentEntity with futsal type', () {
        // Arrange
        final futsalEntity = TournamentEntity(
          tournamentId: '2',
          title: 'Futsal League',
          type: TournamentType.futsal,
          location: 'Lalitpur',
          startDate: tStartDate,
          endDate: tEndDate,
        );

        // Act
        final result = TournamentApiModel.fromEntity(futsalEntity);

        // Assert
        expect(result.type, 'futsal');
      });

      test('should map all optional fields from entity', () {
        // Act
        final result = TournamentApiModel.fromEntity(tTournamentEntity);

        // Assert
        expect(result.description, 'Annual football tournament');
        expect(result.prize, 'NPR 100,000');
        expect(result.bannerImage, 'https://cdn.example.com/banner.jpg');
        expect(result.createdBy, 'user_123');
        expect(result.createdAt, tCreatedAt);
        expect(result.updatedAt, tUpdatedAt);
      });
    });

    group('toEntityList', () {
      test('should convert list of models to list of entities', () {
        // Arrange
        final models = [
          TournamentApiModel(
            tournamentId: '1',
            title: 'Football Cup',
            type: 'football',
            location: 'Kathmandu',
            startDate: tStartDate,
            endDate: tEndDate,
          ),
          TournamentApiModel(
            tournamentId: '2',
            title: 'Futsal League',
            type: 'futsal',
            location: 'Pokhara',
            startDate: tStartDate,
            endDate: tEndDate,
          ),
        ];

        // Act
        final result = TournamentApiModel.toEntityList(models);

        // Assert
        expect(result.length, 2);
        expect(result[0].title, 'Football Cup');
        expect(result[0].type, TournamentType.football);
        expect(result[1].title, 'Futsal League');
        expect(result[1].type, TournamentType.futsal);
      });

      test('should return empty list when given empty list', () {
        // Act
        final result = TournamentApiModel.toEntityList([]);

        // Assert
        expect(result, isEmpty);
      });
    });
  });
}
