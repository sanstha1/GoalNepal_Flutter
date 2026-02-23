import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_nepal/features/tournament/domain/entities/tournament_entity.dart';
import 'package:goal_nepal/features/tournament/domain/usecases/create_tournament_usecase.dart';
import 'package:goal_nepal/features/tournament/domain/usecases/delete_tournament_usecase.dart';
import 'package:goal_nepal/features/tournament/domain/usecases/get_all_tournament_usecase.dart';
import 'package:goal_nepal/features/tournament/domain/usecases/get_tournament_by_id_usecase.dart';
import 'package:goal_nepal/features/tournament/domain/usecases/get_tournament_by_user_usecase.dart';
import 'package:goal_nepal/features/tournament/domain/usecases/update_tournament_usecase.dart';
import 'package:goal_nepal/features/tournament/domain/usecases/upload_banner_usecase.dart';
import 'package:goal_nepal/features/tournament/presentation/state/tournament_state.dart';

final tournamentViewModelProvider =
    NotifierProvider<TournamentViewModel, TournamentState>(
      TournamentViewModel.new,
    );

class TournamentViewModel extends Notifier<TournamentState> {
  late final GetAllTournamentsUsecase _getAllTournamentsUsecase;
  late final GetTournamentByIdUsecase _getTournamentByIdUsecase;
  late final GetMyTournamentsUsecase _getMyTournamentsUsecase;
  late final CreateTournamentUsecase _createTournamentUsecase;
  late final UpdateTournamentUsecase _updateTournamentUsecase;
  late final DeleteTournamentUsecase _deleteTournamentUsecase;
  late final UploadBannerUsecase _uploadBannerUsecase;

  @override
  TournamentState build() {
    _getAllTournamentsUsecase = ref.read(getAllTournamentsUsecaseProvider);
    _getTournamentByIdUsecase = ref.read(getTournamentByIdUsecaseProvider);
    _getMyTournamentsUsecase = ref.read(getMyTournamentsUsecaseProvider);
    _createTournamentUsecase = ref.read(createTournamentUsecaseProvider);
    _updateTournamentUsecase = ref.read(updateTournamentUsecaseProvider);
    _deleteTournamentUsecase = ref.read(deleteTournamentUsecaseProvider);
    _uploadBannerUsecase = ref.read(uploadBannerUsecaseProvider);
    return const TournamentState();
  }

  Future<void> getAllTournaments() async {
    state = state.copyWith(status: TournamentStatus.loading);

    final result = await _getAllTournamentsUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: TournamentStatus.error,
        errorMessage: failure.message,
      ),
      (tournaments) {
        final footballTournaments = tournaments
            .where((tournament) => tournament.type == TournamentType.football)
            .toList();
        final futsalTournaments = tournaments
            .where((tournament) => tournament.type == TournamentType.futsal)
            .toList();
        state = state.copyWith(
          status: TournamentStatus.loaded,
          tournaments: tournaments,
          footballTournaments: footballTournaments,
          futsalTournaments: futsalTournaments,
        );
      },
    );
  }

  Future<void> getTournamentById(String tournamentId) async {
    state = state.copyWith(status: TournamentStatus.loading);

    final result = await _getTournamentByIdUsecase(
      GetTournamentByIdParams(tournamentId: tournamentId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: TournamentStatus.error,
        errorMessage: failure.message,
      ),
      (tournament) => state = state.copyWith(
        status: TournamentStatus.loaded,
        selectedTournament: tournament,
      ),
    );
  }

  Future<void> getMyTournaments(String userId) async {
    state = state.copyWith(status: TournamentStatus.loading);

    final result = await _getMyTournamentsUsecase(
      GetMyTournamentsParams(userId: userId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: TournamentStatus.error,
        errorMessage: failure.message,
      ),
      (tournaments) {
        state = state.copyWith(
          status: TournamentStatus.loaded,
          myTournaments: tournaments,
        );
      },
    );
  }

  Future<void> createTournament({
    required String title,
    required TournamentType type,
    required String location,
    required DateTime startDate,
    required DateTime endDate,
    String? organizer,
    String? description,
    String? prize,
    int? maxTeams,
    File? bannerImage,
  }) async {
    state = state.copyWith(status: TournamentStatus.loading);

    String? bannerUrl;
    if (bannerImage != null) {
      bannerUrl = await uploadBanner(bannerImage);
      if (bannerUrl == null) return;
    }

    final result = await _createTournamentUsecase(
      CreateTournamentParams(
        title: title,
        type: type,
        location: location,
        startDate: startDate,
        endDate: endDate,
        bannerImage: bannerUrl,
      ),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: TournamentStatus.error,
        errorMessage: failure.message,
      ),
      (success) {
        state = state.copyWith(
          status: TournamentStatus.created,
          resetUploadedBannerUrl: true,
        );
        getAllTournaments();
      },
    );
  }

  Future<void> updateTournament({
    required String tournamentId,
    required String title,
    required TournamentType type,
    required String location,
    required DateTime startDate,
    required DateTime endDate,
    String? organizer,
    String? description,
    String? prize,
    int? maxTeams,
    File? bannerImage,
  }) async {
    state = state.copyWith(status: TournamentStatus.loading);

    String? bannerUrl;
    if (bannerImage != null) {
      bannerUrl = await uploadBanner(bannerImage);
      if (bannerUrl == null) return;
    }

    final result = await _updateTournamentUsecase(
      UpdateTournamentParams(
        tournamentId: tournamentId,
        title: title,
        type: type,
        location: location,
        startDate: startDate,
        endDate: endDate,
        bannerImage: bannerUrl,
      ),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: TournamentStatus.error,
        errorMessage: failure.message,
      ),
      (success) {
        state = state.copyWith(status: TournamentStatus.updated);
        getAllTournaments();
      },
    );
  }

  Future<void> deleteTournament(String tournamentId) async {
    state = state.copyWith(status: TournamentStatus.loading);

    final result = await _deleteTournamentUsecase(
      DeleteTournamentParams(tournamentId: tournamentId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: TournamentStatus.error,
        errorMessage: failure.message,
      ),
      (success) {
        state = state.copyWith(status: TournamentStatus.deleted);
        getAllTournaments();
      },
    );
  }

  Future<String?> uploadBanner(File banner) async {
    state = state.copyWith(status: TournamentStatus.loading);

    final result = await _uploadBannerUsecase(banner);

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: TournamentStatus.error,
          errorMessage: failure.message,
        );
        return null;
      },
      (url) {
        state = state.copyWith(
          status: TournamentStatus.loaded,
          uploadedBannerUrl: url,
        );
        return url;
      },
    );
  }

  void clearError() {
    state = state.copyWith(resetErrorMessage: true);
  }

  void clearSelectedTournament() {
    state = state.copyWith(resetSelectedTournament: true);
  }

  void clearReportState() {
    state = state.copyWith(
      status: TournamentStatus.initial,
      resetUploadedBannerUrl: true,
      resetErrorMessage: true,
    );
  }
}
