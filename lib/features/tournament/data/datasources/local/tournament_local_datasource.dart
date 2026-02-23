import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_nepal/core/services/hive/hive_service.dart';
import 'package:goal_nepal/features/tournament/data/datasources/tournament_datasource.dart';
import 'package:goal_nepal/features/tournament/data/models/tournament_hive_model.dart';

final tournamentLocalDatasourceProvider = Provider<TournamentLocalDatasource>((
  ref,
) {
  final hiveService = ref.read(hiveServiceProvider);
  return TournamentLocalDatasource(hiveService: hiveService);
});

class TournamentLocalDatasource implements ITournamentLocalDataSource {
  final HiveService _hiveService;

  TournamentLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<bool> createTournament(TournamentHiveModel tournament) async {
    try {
      await _hiveService.createTournament(tournament);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteTournament(String tournamentId) async {
    try {
      await _hiveService.deleteTournament(tournamentId);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<TournamentHiveModel>> getAllTournaments() async {
    try {
      return _hiveService.getAllTournaments();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<TournamentHiveModel?> getTournamentById(String tournamentId) async {
    try {
      return _hiveService.getTournamentById(tournamentId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<TournamentHiveModel>> getTournamentsByUser(String userId) async {
    try {
      return _hiveService.getTournamentsByUser(userId);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<TournamentHiveModel>> getFootballTournaments() async {
    try {
      final all = _hiveService.getAllTournaments();
      return all.where((t) => t.type == 'football').toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<TournamentHiveModel>> getFutsalTournaments() async {
    try {
      final all = _hiveService.getAllTournaments();
      return all.where((t) => t.type == 'futsal').toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<bool> updateTournament(TournamentHiveModel tournament) async {
    try {
      await _hiveService.updateTournament(tournament);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> uploadTournamentBanner(
    String tournamentId,
    String bannerPath,
  ) async {
    try {
      return await _hiveService.uploadTournamentBanner(
        tournamentId,
        bannerPath,
      );
    } catch (e) {
      return false;
    }
  }
}
