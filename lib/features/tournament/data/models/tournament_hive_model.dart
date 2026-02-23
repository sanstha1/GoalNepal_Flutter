import 'package:hive/hive.dart';
import 'package:goal_nepal/core/constants/hive_table_constant.dart';
import 'package:goal_nepal/features/tournament/domain/entities/tournament_entity.dart';
import 'package:uuid/uuid.dart';

part 'tournament_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.tournamentTypeId)
class TournamentHiveModel extends HiveObject {
  @HiveField(0)
  final String tournamentId;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String type;

  @HiveField(3)
  final String location;

  @HiveField(4)
  final DateTime startDate;

  @HiveField(5)
  final DateTime endDate;

  @HiveField(6)
  final String? bannerImage;

  @HiveField(7)
  final String? createdBy;

  @HiveField(8)
  final DateTime? createdAt;

  @HiveField(9)
  final DateTime? updatedAt;

  TournamentHiveModel({
    String? tournamentId,
    required this.title,
    required this.type,
    required this.location,
    required this.startDate,
    required this.endDate,
    this.bannerImage,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  }) : tournamentId = tournamentId ?? const Uuid().v4();

  TournamentEntity toEntity() {
    return TournamentEntity(
      tournamentId: tournamentId,
      title: title,
      type: type == 'football'
          ? TournamentType.football
          : TournamentType.futsal,
      location: location,
      startDate: startDate,
      endDate: endDate,
      bannerImage: bannerImage,
      createdBy: createdBy,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory TournamentHiveModel.fromEntity(TournamentEntity entity) {
    return TournamentHiveModel(
      tournamentId: entity.tournamentId,
      title: entity.title,
      type: entity.type == TournamentType.football ? 'football' : 'futsal',
      location: entity.location,
      startDate: entity.startDate,
      endDate: entity.endDate,
      bannerImage: entity.bannerImage,
      createdBy: entity.createdBy,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  TournamentHiveModel copyWith({
    String? tournamentId,
    String? title,
    String? type,
    String? location,
    DateTime? startDate,
    DateTime? endDate,
    String? bannerImage,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TournamentHiveModel(
      tournamentId: tournamentId ?? this.tournamentId,
      title: title ?? this.title,
      type: type ?? this.type,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      bannerImage: bannerImage ?? this.bannerImage,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static List<TournamentEntity> toEntityList(List<TournamentHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
