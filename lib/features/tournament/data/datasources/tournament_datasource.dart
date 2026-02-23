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
  Future<TournamentApiModel> createTournament(TournamentApiModel tournament);
  Future<List<TournamentApiModel>> getAllTournaments();
  Future<TournamentApiModel> getTournamentById(String tournamentId);
  Future<List<TournamentApiModel>> getTournamentsByUser();
  Future<List<TournamentApiModel>> getMyTournaments();
  Future<List<TournamentApiModel>> getFootballTournaments();
  Future<List<TournamentApiModel>> getFutsalTournaments();
  Future<bool> updateTournament(TournamentApiModel tournament);
  Future<bool> deleteTournament(String tournamentId);
}
