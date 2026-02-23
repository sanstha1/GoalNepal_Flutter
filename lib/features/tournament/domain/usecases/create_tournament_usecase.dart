import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_nepal/core/error/failures.dart';
import 'package:goal_nepal/core/usecase/app_usecase.dart';
import 'package:goal_nepal/features/tournament/data/repositories/tournament_repository.dart';
import 'package:goal_nepal/features/tournament/domain/entities/tournament_entity.dart';
import 'package:goal_nepal/features/tournament/domain/repositories/tournament_repository.dart';

class CreateTournamentParams extends Equatable {
  final String title;
  final TournamentType type;
  final String location;
  final DateTime startDate;
  final DateTime endDate;
  final String? organizer;
  final String? description;
  final String? prize;
  final int? maxTeams;
  final File? bannerImage;
  final String? createdBy;

  const CreateTournamentParams({
    required this.title,
    required this.type,
    required this.location,
    required this.startDate,
    required this.endDate,
    this.organizer,
    this.description,
    this.prize,
    this.maxTeams,
    this.bannerImage,
    this.createdBy,
  });

  @override
  List<Object?> get props => [
    title,
    type,
    location,
    startDate,
    endDate,
    organizer,
    description,
    prize,
    maxTeams,
    bannerImage,
    createdBy,
  ];
}

final createTournamentUsecaseProvider = Provider<CreateTournamentUsecase>((
  ref,
) {
  final repository = ref.read(tournamentRepositoryProvider);
  return CreateTournamentUsecase(repository);
});

class CreateTournamentUsecase
    implements UsecaseWithParms<bool, CreateTournamentParams> {
  final ITournamentRepository _repository;

  CreateTournamentUsecase(this._repository);

  @override
  Future<Either<Failure, bool>> call(CreateTournamentParams params) async {
    final tournament = TournamentEntity(
      title: params.title,
      type: params.type,
      location: params.location,
      startDate: params.startDate,
      endDate: params.endDate,
      organizer: params.organizer,
      description: params.description,
      prize: params.prize,
      maxTeams: params.maxTeams,
      createdBy: params.createdBy,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return await _repository.createTournament(
      tournament,
      bannerFile: params.bannerImage,
    );
  }
}
