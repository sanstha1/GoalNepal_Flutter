import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_nepal/core/api/api_client.dart';
import 'package:goal_nepal/core/api/api_endpoints.dart';
import 'package:goal_nepal/core/services/storage/token_service.dart';
import 'package:goal_nepal/features/tournament/data/datasources/tournament_datasource.dart';
import 'package:goal_nepal/features/tournament/data/models/tournament_api_model.dart';

final tournamentRemoteDatasourceProvider = Provider<TournamentRemoteDatasource>(
  (ref) {
    return TournamentRemoteDatasource(
      apiClient: ref.read(apiClientProvider),
      tokenService: ref.read(tokenServiceProvider),
    );
  },
);

class TournamentRemoteDatasource implements ITournamentRemoteDataSource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  TournamentRemoteDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  Future<Options> get _authOptions async {
    final token = await _tokenService.getToken();
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  @override
  Future<String> uploadBanner(File banner) async {
    final fileName = banner.path.split('/').last;
    final formData = FormData.fromMap({
      'tournamentBanner': await MultipartFile.fromFile(
        banner.path,
        filename: fileName,
      ),
    });
    final response = await _apiClient.uploadFile(
      '${ApiEndpoints.tournaments}/upload-banner',
      formData: formData,
      options: await _authOptions,
    );
    return response.data['data'];
  }

  @override
  Future<TournamentApiModel> createTournament(
    TournamentApiModel tournament,
  ) async {
    final response = await _apiClient.post(
      ApiEndpoints.tournaments,
      data: tournament.toJson(),
      options: await _authOptions,
    );
    return TournamentApiModel.fromJson(response.data['data']);
  }

  @override
  Future<List<TournamentApiModel>> getAllTournaments() async {
    final response = await _apiClient.get(ApiEndpoints.tournaments);
    final data = response.data['data'] as List;
    return data.map((json) => TournamentApiModel.fromJson(json)).toList();
  }

  @override
  Future<TournamentApiModel> getTournamentById(String tournamentId) async {
    final response = await _apiClient.get(
      ApiEndpoints.tournamentById(tournamentId),
    );
    return TournamentApiModel.fromJson(response.data['data']);
  }

  @override
  Future<List<TournamentApiModel>> getTournamentsByUser() async {
    final response = await _apiClient.get(
      ApiEndpoints.myTournaments,
      options: await _authOptions,
    );
    final data = response.data['data'] as List;
    return data.map((json) => TournamentApiModel.fromJson(json)).toList();
  }

  @override
  Future<List<TournamentApiModel>> getMyTournaments() async {
    final response = await _apiClient.get(
      ApiEndpoints.myTournaments,
      options: await _authOptions,
    );
    final data = response.data['data'] as List;
    return data.map((json) => TournamentApiModel.fromJson(json)).toList();
  }

  @override
  Future<List<TournamentApiModel>> getFootballTournaments() async {
    final response = await _apiClient.get(
      ApiEndpoints.tournaments,
      queryParameters: {'type': 'football'},
    );
    final data = response.data['data'] as List;
    return data.map((json) => TournamentApiModel.fromJson(json)).toList();
  }

  @override
  Future<List<TournamentApiModel>> getFutsalTournaments() async {
    final response = await _apiClient.get(
      ApiEndpoints.tournaments,
      queryParameters: {'type': 'futsal'},
    );
    final data = response.data['data'] as List;
    return data.map((json) => TournamentApiModel.fromJson(json)).toList();
  }

  @override
  Future<bool> updateTournament(TournamentApiModel tournament) async {
    await _apiClient.put(
      ApiEndpoints.tournamentById(tournament.tournamentId!),
      data: tournament.toJson(),
      options: await _authOptions,
    );
    return true;
  }

  @override
  Future<bool> deleteTournament(String tournamentId) async {
    await _apiClient.delete(
      ApiEndpoints.tournamentById(tournamentId),
      options: await _authOptions,
    );
    return true;
  }
}
