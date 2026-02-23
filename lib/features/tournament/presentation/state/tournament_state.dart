import 'package:equatable/equatable.dart';
import 'package:goal_nepal/features/tournament/domain/entities/tournament_entity.dart';

enum TournamentStatus {
  initial,
  loading,
  loaded,
  error,
  created,
  updated,
  deleted,
}

class TournamentState extends Equatable {
  final TournamentStatus status;
  final List<TournamentEntity> tournaments;
  final List<TournamentEntity> footballTournaments;
  final List<TournamentEntity> futsalTournaments;
  final List<TournamentEntity> myTournaments;
  final TournamentEntity? selectedTournament;
  final String? errorMessage;
  final String? uploadedBannerUrl;

  const TournamentState({
    this.status = TournamentStatus.initial,
    this.tournaments = const [],
    this.footballTournaments = const [],
    this.futsalTournaments = const [],
    this.myTournaments = const [],
    this.selectedTournament,
    this.errorMessage,
    this.uploadedBannerUrl,
  });

  TournamentState copyWith({
    TournamentStatus? status,
    List<TournamentEntity>? tournaments,
    List<TournamentEntity>? footballTournaments,
    List<TournamentEntity>? futsalTournaments,
    List<TournamentEntity>? myTournaments,
    TournamentEntity? selectedTournament,
    bool resetSelectedTournament = false,
    String? errorMessage,
    bool resetErrorMessage = false,
    String? uploadedBannerUrl,
    bool resetUploadedBannerUrl = false,
  }) {
    return TournamentState(
      status: status ?? this.status,
      tournaments: tournaments ?? this.tournaments,
      footballTournaments: footballTournaments ?? this.footballTournaments,
      futsalTournaments: futsalTournaments ?? this.futsalTournaments,
      myTournaments: myTournaments ?? this.myTournaments,
      selectedTournament: resetSelectedTournament
          ? null
          : (selectedTournament ?? this.selectedTournament),
      errorMessage: resetErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      uploadedBannerUrl: resetUploadedBannerUrl
          ? null
          : (uploadedBannerUrl ?? this.uploadedBannerUrl),
    );
  }

  @override
  List<Object?> get props => [
    status,
    tournaments,
    footballTournaments,
    futsalTournaments,
    myTournaments,
    selectedTournament,
    errorMessage,
    uploadedBannerUrl,
  ];
}
