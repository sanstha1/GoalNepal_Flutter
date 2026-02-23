import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_nepal/core/error/failures.dart';
import 'package:goal_nepal/core/usecase/app_usecase.dart';
import 'package:goal_nepal/features/tournament/data/repositories/tournament_repository.dart';
import 'package:goal_nepal/features/tournament/domain/entities/tournament_entity.dart';
import 'package:goal_nepal/features/tournament/domain/repositories/tournament_repository.dart';

class GetTournamentByIdParams extends Equatable {
  final String tournamentId;

  const GetTournamentByIdParams({required this.tournamentId});

  @override
  List<Object?> get props => [tournamentId];
}

final getTournamentByIdUsecaseProvider = Provider<GetTournamentByIdUsecase>((
  ref,
) {
  final repository = ref.read(tournamentRepositoryProvider);
  return GetTournamentByIdUsecase(repository: repository);
});

class GetTournamentByIdUsecase
    implements UsecaseWithParms<TournamentEntity, GetTournamentByIdParams> {
  final ITournamentRepository _repository;

  GetTournamentByIdUsecase({required ITournamentRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, TournamentEntity>> call(
    GetTournamentByIdParams params,
  ) {
    return _repository.getTournamentById(params.tournamentId);
  }
}
