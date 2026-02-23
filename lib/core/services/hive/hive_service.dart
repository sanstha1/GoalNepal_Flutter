import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_nepal/core/constants/hive_table_constant.dart';
import 'package:goal_nepal/features/auth/data/models/auth_hive_model.dart';
import 'package:goal_nepal/features/tournament/data/models/tournament_hive_model.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

final hiveServiceProvider = Provider<HiveService>((ref) {
  throw UnimplementedError('HiveService must be initialized in main.dart');
});

class HiveService {
  static final Map<String, AuthHiveModel> _webAuthStorage = {};
  static final Map<String, TournamentHiveModel> _webTournamentStorage = {};

  Future<void> init() async {
    if (kIsWeb) return;

    final directory = await getApplicationCacheDirectory();
    final path = '${directory.path}/${HiveTableConstant.dbName}';

    Hive.init(path);
    _registerAdapters();
    await _openBoxes();
  }

  void _registerAdapters() {
    if (!Hive.isAdapterRegistered(HiveTableConstant.authTableTypeId)) {
      Hive.registerAdapter(AuthHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstant.tournamentTypeId)) {
      Hive.registerAdapter(TournamentHiveModelAdapter());
    }
  }

  Future<void> _openBoxes() async {
    if (!Hive.isBoxOpen(HiveTableConstant.authTable)) {
      await Hive.openBox<AuthHiveModel>(HiveTableConstant.authTable);
    }
    if (!Hive.isBoxOpen(HiveTableConstant.tournamentTable)) {
      await Hive.openBox<TournamentHiveModel>(
        HiveTableConstant.tournamentTable,
      );
    }
  }

  Future<void> close() async {
    if (!kIsWeb) {
      await Hive.close();
    }
  }

  Box<AuthHiveModel> get _authBox {
    if (kIsWeb) throw UnsupportedError('Hive not supported on web');
    if (!Hive.isBoxOpen(HiveTableConstant.authTable)) {
      throw HiveError('Auth box is not opened');
    }
    return Hive.box<AuthHiveModel>(HiveTableConstant.authTable);
  }

  Box<TournamentHiveModel> get _tournamentBox {
    if (kIsWeb) throw UnsupportedError('Hive not supported on web');
    if (!Hive.isBoxOpen(HiveTableConstant.tournamentTable)) {
      throw HiveError('Tournament box is not opened');
    }
    return Hive.box<TournamentHiveModel>(HiveTableConstant.tournamentTable);
  }

  // ======================= Auth Queries =========================

  Future<AuthHiveModel> registerUser(AuthHiveModel model) async {
    if (isEmailExists(model.email)) {
      throw Exception('Email already exists');
    }
    if (kIsWeb) {
      _webAuthStorage[model.authId!] = model;
    } else {
      await _authBox.put(model.authId, model);
    }
    return model;
  }

  Future<AuthHiveModel?> login(String email, String password) async {
    if (kIsWeb) {
      return _webAuthStorage.values
          .where((u) => u.email == email && u.password == password)
          .cast<AuthHiveModel?>()
          .firstOrNull;
    }
    final users = _authBox.values.where(
      (u) => u.email == email && u.password == password,
    );
    return users.isNotEmpty ? users.first : null;
  }

  AuthHiveModel? getCurrentUser(String authId) {
    if (kIsWeb) return _webAuthStorage[authId];
    return _authBox.get(authId);
  }

  bool isEmailExists(String email) {
    if (kIsWeb) return _webAuthStorage.values.any((u) => u.email == email);
    return _authBox.values.any((u) => u.email == email);
  }

  Future<void> logout() async {}

  // ======================= Tournament Queries =========================

  Future<TournamentHiveModel> createTournament(
    TournamentHiveModel tournament,
  ) async {
    if (kIsWeb) {
      _webTournamentStorage[tournament.tournamentId] = tournament;
    } else {
      await _tournamentBox.put(tournament.tournamentId, tournament);
    }
    return tournament;
  }

  List<TournamentHiveModel> getAllTournaments() {
    if (kIsWeb) return _webTournamentStorage.values.toList();
    return _tournamentBox.values.toList();
  }

  TournamentHiveModel? getTournamentById(String tournamentId) {
    if (kIsWeb) return _webTournamentStorage[tournamentId];
    return _tournamentBox.get(tournamentId);
  }

  List<TournamentHiveModel> getTournamentsByUser(String userId) {
    if (kIsWeb) {
      return _webTournamentStorage.values
          .where((t) => t.createdBy == userId)
          .toList();
    }
    return _tournamentBox.values.where((t) => t.createdBy == userId).toList();
  }

  Future<bool> updateTournament(TournamentHiveModel tournament) async {
    if (kIsWeb) {
      if (!_webTournamentStorage.containsKey(tournament.tournamentId)) {
        return false;
      }
      _webTournamentStorage[tournament.tournamentId] = tournament;
      return true;
    }
    if (_tournamentBox.containsKey(tournament.tournamentId)) {
      await _tournamentBox.put(tournament.tournamentId, tournament);
      return true;
    }
    return false;
  }

  Future<void> deleteTournament(String tournamentId) async {
    if (kIsWeb) {
      _webTournamentStorage.remove(tournamentId);
    } else {
      await _tournamentBox.delete(tournamentId);
    }
  }

  Future<bool> uploadTournamentBanner(
    String tournamentId,
    String bannerPath,
  ) async {
    final tournament = getTournamentById(tournamentId);
    if (tournament == null) return false;
    final updated = tournament.copyWith(bannerImage: bannerPath);
    return await updateTournament(updated);
  }
}
