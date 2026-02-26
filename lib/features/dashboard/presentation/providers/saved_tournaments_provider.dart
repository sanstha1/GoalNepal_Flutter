import 'package:flutter_riverpod/legacy.dart';
import 'package:goal_nepal/features/tournament/domain/entities/tournament_entity.dart';

class SavedTournamentsNotifier extends StateNotifier<List<TournamentEntity>> {
  SavedTournamentsNotifier() : super([]);

  bool isSaved(TournamentEntity tournament) {
    return state.any((t) => t.tournamentId == tournament.tournamentId);
  }

  void toggle(TournamentEntity tournament) {
    if (isSaved(tournament)) {
      state = state
          .where((t) => t.tournamentId != tournament.tournamentId)
          .toList();
    } else {
      state = [...state, tournament];
    }
  }

  void remove(TournamentEntity tournament) {
    state = state
        .where((t) => t.tournamentId != tournament.tournamentId)
        .toList();
  }
}

final savedTournamentsProvider =
    StateNotifierProvider<SavedTournamentsNotifier, List<TournamentEntity>>(
      (ref) => SavedTournamentsNotifier(),
    );
