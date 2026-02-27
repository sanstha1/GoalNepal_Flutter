import 'package:dio/dio.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:goal_nepal/features/register/data/datasources/remote/register_remote_datasource.dart';
import 'package:goal_nepal/features/register/presentation/state/register_state.dart';

final registrationViewModelProvider =
    StateNotifierProvider<RegistrationViewModel, RegistrationState>((ref) {
      return RegistrationViewModel(
        ref.read(registrationRemoteDatasourceProvider),
      );
    });

class RegistrationViewModel extends StateNotifier<RegistrationState> {
  final RegistrationRemoteDatasource _datasource;

  RegistrationViewModel(this._datasource) : super(const RegistrationState());

  Future<bool> registerForTournament({
    required String tournamentId,
    required String tournamentTitle,
    required String teamName,
    required String captainName,
    required String captainPhone,
    required String captainEmail,
    required int playerCount,
    List<Map<String, dynamic>>? players,
  }) async {
    state = state.copyWith(status: RegistrationStatus.loading);
    try {
      await _datasource.registerForTournament(
        tournamentId: tournamentId,
        tournamentTitle: tournamentTitle,
        teamName: teamName,
        captainName: captainName,
        captainPhone: captainPhone,
        captainEmail: captainEmail,
        playerCount: playerCount,
        players: players,
      );
      state = state.copyWith(status: RegistrationStatus.success);
      return true;
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? 'Registration failed';
      state = state.copyWith(
        status: RegistrationStatus.error,
        errorMessage: message,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        status: RegistrationStatus.error,
        errorMessage: 'Something went wrong',
      );
      return false;
    }
  }

  void reset() => state = const RegistrationState();
}
