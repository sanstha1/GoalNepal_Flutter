import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_nepal/core/error/failures.dart';
import 'package:goal_nepal/core/usecase/app_usecase.dart';
import 'package:goal_nepal/features/tournament/data/repositories/tournament_repository.dart';
import 'package:goal_nepal/features/tournament/domain/entities/tournament_entity.dart';
import 'package:goal_nepal/features/tournament/domain/repositories/tournament_repository.dart';

class GetMyTournamentsParams extends Equatable {
  final String userId;

  const GetMyTournamentsParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}

final getMyTournamentsUsecaseProvider = Provider<GetMyTournamentsUsecase>((
  ref,
) {
  final repository = ref.read(tournamentRepositoryProvider);
  return GetMyTournamentsUsecase(repository: repository);
});

class GetMyTournamentsUsecase
    implements
        UsecaseWithParms<List<TournamentEntity>, GetMyTournamentsParams> {
  final ITournamentRepository _repository;

  GetMyTournamentsUsecase({required ITournamentRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, List<TournamentEntity>>> call(
    GetMyTournamentsParams params,
  ) {
    return _repository.getMyTournaments(params.userId);
  }
}
