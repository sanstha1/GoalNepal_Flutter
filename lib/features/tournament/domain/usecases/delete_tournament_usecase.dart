import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_nepal/core/error/failures.dart';
import 'package:goal_nepal/core/usecase/app_usecase.dart';
import 'package:goal_nepal/features/tournament/data/repositories/tournament_repository.dart';
import 'package:goal_nepal/features/tournament/domain/repositories/tournament_repository.dart';

class DeleteTournamentParams extends Equatable {
  final String tournamentId;

  const DeleteTournamentParams({required this.tournamentId});

  @override
  List<Object?> get props => [tournamentId];
}

final deleteTournamentUsecaseProvider = Provider<DeleteTournamentUsecase>((
  ref,
) {
  final repository = ref.read(tournamentRepositoryProvider);
  return DeleteTournamentUsecase(repository: repository);
});

class DeleteTournamentUsecase
    implements UsecaseWithParms<bool, DeleteTournamentParams> {
  final ITournamentRepository _repository;

  DeleteTournamentUsecase({required ITournamentRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, bool>> call(DeleteTournamentParams params) {
    return _repository.deleteTournament(params.tournamentId);
  }
}
