import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:goal_nepal/core/error/failures.dart';
import 'package:goal_nepal/features/tournament/domain/entities/tournament_entity.dart';

abstract interface class ITournamentRepository {
  Future<Either<Failure, List<TournamentEntity>>> getAllTournaments();
  Future<Either<Failure, List<TournamentEntity>>> getMyTournaments(
    String userId,
  );
  Future<Either<Failure, List<TournamentEntity>>> getFootballTournaments();
  Future<Either<Failure, List<TournamentEntity>>> getFutsalTournaments();
  Future<Either<Failure, TournamentEntity>> getTournamentById(
    String tournamentId,
  );
  Future<Either<Failure, bool>> createTournament(TournamentEntity tournament);
  Future<Either<Failure, bool>> updateTournament(TournamentEntity tournament);
  Future<Either<Failure, bool>> deleteTournament(String tournamentId);
  Future<Either<Failure, String>> uploadBanner(File banner);
}
