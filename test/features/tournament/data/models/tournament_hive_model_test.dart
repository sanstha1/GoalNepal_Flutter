import 'package:flutter_test/flutter_test.dart';
import 'package:goal_nepal/features/tournament/data/models/tournament_hive_model.dart';
import 'package:goal_nepal/features/tournament/domain/entities/tournament_entity.dart';

void main() {
  group('TournamentHiveModel', () {
    final tStartDate = DateTime(2025, 6, 1, 0, 0, 0);
    final tEndDate = DateTime(2025, 6, 30, 0, 0, 0);
    final tCreatedAt = DateTime(2025, 1, 1, 12, 0, 0);
    final tUpdatedAt = DateTime(2025, 1, 2, 12, 0, 0);

    final tHiveModel = TournamentHiveModel(
      tournamentId: 'tournament_001',
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

    group('constructor', () {
      test('should auto-generate tournamentId when not provided', () {
        final model = TournamentHiveModel(
          title: 'Auto ID Cup',
          type: 'football',
          location: 'Kathmandu',
          startDate: tStartDate,
          endDate: tEndDate,
        );

        expect(model.tournamentId, isNotNull);
        expect(model.tournamentId, isNotEmpty);
      });

      test('should use provided tournamentId when given', () {
        expect(tHiveModel.tournamentId, 'tournament_001');
      });
    });

    group('toEntity', () {
      test('should convert to TournamentEntity with football type', () {
        final result = tHiveModel.toEntity();

        expect(result.tournamentId, 'tournament_001');
        expect(result.title, 'Goal Nepal Cup 2025');
        expect(result.type, TournamentType.football);
        expect(result.location, 'Kathmandu');
        expect(result.organizer, 'Goal Nepal');
        expect(result.maxTeams, 16);
        expect(result.createdBy, 'user_123');
      });

      test('should convert to TournamentEntity with futsal type', () {
        final futsalModel = TournamentHiveModel(
          tournamentId: 'tournament_002',
          title: 'Futsal League',
          type: 'futsal',
          location: 'Pokhara',
          startDate: tStartDate,
          endDate: tEndDate,
        );

        final result = futsalModel.toEntity();

        expect(result.type, TournamentType.futsal);
      });

      test('should map all optional fields to entity', () {
        final result = tHiveModel.toEntity();

        expect(result.description, 'Annual football tournament');
        expect(result.prize, 'NPR 100,000');
        expect(result.bannerImage, 'https://cdn.example.com/banner.jpg');
        expect(result.startDate, tStartDate);
        expect(result.endDate, tEndDate);
        expect(result.createdAt, tCreatedAt);
        expect(result.updatedAt, tUpdatedAt);
      });

      test('should handle null optional fields', () {
        final minimalModel = TournamentHiveModel(
          tournamentId: 'tournament_003',
          title: 'Minimal Cup',
          type: 'football',
          location: 'Lalitpur',
          startDate: tStartDate,
          endDate: tEndDate,
        );

        final result = minimalModel.toEntity();

        expect(result.organizer, isNull);
        expect(result.description, isNull);
        expect(result.prize, isNull);
        expect(result.maxTeams, isNull);
        expect(result.bannerImage, isNull);
        expect(result.createdBy, isNull);
        expect(result.createdAt, isNull);
        expect(result.updatedAt, isNull);
      });
    });

    group('fromEntity', () {
      test('should convert from TournamentEntity with football type', () {
        final result = TournamentHiveModel.fromEntity(tTournamentEntity);

        expect(result.tournamentId, 'tournament_001');
        expect(result.title, 'Goal Nepal Cup 2025');
        expect(result.type, 'football');
        expect(result.location, 'Kathmandu');
        expect(result.organizer, 'Goal Nepal');
        expect(result.maxTeams, 16);
      });

      test('should convert from TournamentEntity with futsal type', () {
        final futsalEntity = TournamentEntity(
          tournamentId: 'tournament_002',
          title: 'Futsal League',
          type: TournamentType.futsal,
          location: 'Pokhara',
          startDate: tStartDate,
          endDate: tEndDate,
        );

        final result = TournamentHiveModel.fromEntity(futsalEntity);

        expect(result.type, 'futsal');
      });

      test('should map all optional fields from entity', () {
        final result = TournamentHiveModel.fromEntity(tTournamentEntity);

        expect(result.description, 'Annual football tournament');
        expect(result.prize, 'NPR 100,000');
        expect(result.bannerImage, 'https://cdn.example.com/banner.jpg');
        expect(result.createdBy, 'user_123');
        expect(result.createdAt, tCreatedAt);
        expect(result.updatedAt, tUpdatedAt);
      });
    });

    group('copyWith', () {
      test('should return same values when no arguments provided', () {
        final result = tHiveModel.copyWith();

        expect(result.tournamentId, tHiveModel.tournamentId);
        expect(result.title, tHiveModel.title);
        expect(result.type, tHiveModel.type);
        expect(result.location, tHiveModel.location);
        expect(result.organizer, tHiveModel.organizer);
      });

      test('should update title when provided', () {
        final result = tHiveModel.copyWith(title: 'Updated Cup 2025');

        expect(result.title, 'Updated Cup 2025');
        expect(result.location, tHiveModel.location);
        expect(result.type, tHiveModel.type);
      });

      test('should update multiple fields when provided', () {
        final result = tHiveModel.copyWith(
          title: 'New Cup',
          location: 'Bhaktapur',
          maxTeams: 32,
        );

        expect(result.title, 'New Cup');
        expect(result.location, 'Bhaktapur');
        expect(result.maxTeams, 32);
        expect(result.type, tHiveModel.type);
        expect(result.organizer, tHiveModel.organizer);
      });
    });

    group('toEntityList', () {
      test('should convert list of models to list of entities', () {
        final models = [
          TournamentHiveModel(
            tournamentId: '1',
            title: 'Football Cup',
            type: 'football',
            location: 'Kathmandu',
            startDate: tStartDate,
            endDate: tEndDate,
          ),
          TournamentHiveModel(
            tournamentId: '2',
            title: 'Futsal League',
            type: 'futsal',
            location: 'Pokhara',
            startDate: tStartDate,
            endDate: tEndDate,
          ),
        ];

        final result = TournamentHiveModel.toEntityList(models);

        expect(result.length, 2);
        expect(result[0].title, 'Football Cup');
        expect(result[0].type, TournamentType.football);
        expect(result[1].title, 'Futsal League');
        expect(result[1].type, TournamentType.futsal);
      });

      test('should return empty list when given empty list', () {
        final result = TournamentHiveModel.toEntityList([]);

        expect(result, isEmpty);
      });
    });
  });
}
