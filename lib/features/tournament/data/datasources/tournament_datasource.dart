import 'dart:io';

import 'package:goal_nepal/features/tournament/data/models/tournament_api_model.dart';
import 'package:goal_nepal/features/tournament/data/models/tournament_hive_model.dart';

abstract interface class ITournamentLocalDataSource {
  Future<List<TournamentHiveModel>> getAllTournaments();
  Future<List<TournamentHiveModel>> getTournamentsByUser(String userId);
  Future<List<TournamentHiveModel>> getFootballTournaments();
  Future<List<TournamentHiveModel>> getFutsalTournaments();
  Future<TournamentHiveModel?> getTournamentById(String tournamentId);
  Future<bool> createTournament(TournamentHiveModel tournament);
  Future<bool> updateTournament(TournamentHiveModel tournament);
  Future<bool> deleteTournament(String tournamentId);
  Future<bool> uploadTournamentBanner(String tournamentId, String bannerPath);
}

abstract interface class ITournamentRemoteDataSource {
  Future<String> uploadBanner(File banner);
  Future<void> createTournament(
    TournamentApiModel tournament, {
    File? bannerFile,
  });
  Future<List<TournamentApiModel>> getAllTournaments();
  Future<TournamentApiModel> getTournamentById(String tournamentId);
  Future<List<TournamentApiModel>> getMyTournaments();
  Future<List<TournamentApiModel>> getFootballTournaments();
  Future<List<TournamentApiModel>> getFutsalTournaments();
  Future<void> updateTournament(
    TournamentApiModel tournament, {
    File? bannerFile,
  });
  Future<void> deleteTournament(String tournamentId);
}
