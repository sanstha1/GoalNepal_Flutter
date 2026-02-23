import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_nepal/core/error/failures.dart';
import 'package:goal_nepal/core/usecase/app_usecase.dart';
import 'package:goal_nepal/features/tournament/data/repositories/tournament_repository.dart';
import 'package:goal_nepal/features/tournament/domain/entities/tournament_entity.dart';
import 'package:goal_nepal/features/tournament/domain/repositories/tournament_repository.dart';

class UpdateTournamentParams extends Equatable {
  final String tournamentId;
  final String title;
  final TournamentType type;
  final String location;
  final DateTime startDate;
  final DateTime endDate;
  final File? bannerImage;
  final String? createdBy;

  const UpdateTournamentParams({
    required this.tournamentId,
    required this.title,
    required this.type,
    required this.location,
    required this.startDate,
    required this.endDate,
    this.bannerImage,
    this.createdBy,
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
  ];
}

final updateTournamentUsecaseProvider = Provider<UpdateTournamentUsecase>((
  ref,
) {
  final repository = ref.read(tournamentRepositoryProvider);
  return UpdateTournamentUsecase(repository: repository);
});

class UpdateTournamentUsecase
    implements UsecaseWithParms<bool, UpdateTournamentParams> {
  final ITournamentRepository _repository;

  UpdateTournamentUsecase({required ITournamentRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, bool>> call(UpdateTournamentParams params) {
    final tournament = TournamentEntity(
      tournamentId: params.tournamentId,
      title: params.title,
      type: params.type,
      location: params.location,
      startDate: params.startDate,
      endDate: params.endDate,
      createdBy: params.createdBy,
      updatedAt: DateTime.now(),
    );

    return _repository.updateTournament(
      tournament,
      bannerFile: params.bannerImage,
    );
  }
}
