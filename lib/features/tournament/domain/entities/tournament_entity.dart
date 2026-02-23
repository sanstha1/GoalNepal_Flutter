import 'package:equatable/equatable.dart';

enum TournamentType { football, futsal }

class TournamentEntity extends Equatable {
  final String? tournamentId;
  final String title;
  final TournamentType type;
  final String location;
  final DateTime startDate;
  final DateTime endDate;
  final String? bannerImage;
  final String? createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const TournamentEntity({
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

  @override
  List<Object?> get props => [
    tournamentId,
    title,
    type,
    location,
    startDate,
    endDate,
    bannerImage,
    createdBy,
    createdAt,
    updatedAt,
  ];
}
