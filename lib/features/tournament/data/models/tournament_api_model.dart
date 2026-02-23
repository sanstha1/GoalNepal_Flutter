import 'package:goal_nepal/features/tournament/domain/entities/tournament_entity.dart';

class TournamentApiModel {
  final String? tournamentId;
  final String title;
  final String type;
  final String location;
  final DateTime startDate;
  final DateTime endDate;
  final String? bannerImage;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TournamentApiModel({
    this.tournamentId,
    required this.title,
    required this.type,
    required this.location,
    required this.startDate,
    required this.endDate,
    this.bannerImage,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'type': type,
      'location': location,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      if (bannerImage != null) 'bannerImage': bannerImage,
      if (createdBy != null) 'createdBy': createdBy,
    };
  }

  factory TournamentApiModel.fromJson(Map<String, dynamic> json) {
    String? extractId(dynamic value) {
      if (value == null) return null;
      if (value is Map) return value['_id'] as String?;
      return value as String?;
    }

    return TournamentApiModel(
      tournamentId: json['_id'] as String?,
      title: json['title'] as String,
      type: json['type'] as String,
      location: json['location'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      bannerImage: json['bannerImage'] as String?,
      createdBy: extractId(json['createdBy']),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

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

  factory TournamentApiModel.fromEntity(TournamentEntity entity) {
    return TournamentApiModel(
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

  static List<TournamentEntity> toEntityList(List<TournamentApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
