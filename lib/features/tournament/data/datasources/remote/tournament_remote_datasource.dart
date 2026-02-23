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
    throw UnimplementedError('Use createTournament with bannerFile instead');
  }

  @override
  Future<void> createTournament(
    TournamentApiModel tournament, {
    File? bannerFile,
  }) async {
    final token = await _tokenService.getToken();

    final Map<String, dynamic> fields = {
      'title': tournament.title,
      'type': tournament.type,
      'location': tournament.location,
      'startDate': tournament.startDate.toIso8601String(),
      'endDate': tournament.endDate.toIso8601String(),
      if (tournament.organizer != null) 'organizer': tournament.organizer,
      if (tournament.description != null) 'description': tournament.description,
      if (tournament.prize != null) 'prize': tournament.prize,
      if (tournament.maxTeams != null) 'maxTeams': tournament.maxTeams,
      if (tournament.createdBy != null) 'createdBy': tournament.createdBy,
    };

    if (bannerFile != null) {
      fields['bannerImage'] = await MultipartFile.fromFile(
        bannerFile.path,
        filename: bannerFile.path.split('/').last,
      );
    }

    await _apiClient.post(
      ApiEndpoints.tournaments,
      data: FormData.fromMap(fields),
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
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
  Future<void> updateTournament(
    TournamentApiModel tournament, {
    File? bannerFile,
  }) async {
    final token = await _tokenService.getToken();

    final Map<String, dynamic> fields = {
      'title': tournament.title,
      'type': tournament.type,
      'location': tournament.location,
      'startDate': tournament.startDate.toIso8601String(),
      'endDate': tournament.endDate.toIso8601String(),
      if (tournament.organizer != null) 'organizer': tournament.organizer,
      if (tournament.description != null) 'description': tournament.description,
      if (tournament.prize != null) 'prize': tournament.prize,
      if (tournament.maxTeams != null) 'maxTeams': tournament.maxTeams,
    };

    if (bannerFile != null) {
      fields['bannerImage'] = await MultipartFile.fromFile(
        bannerFile.path,
        filename: bannerFile.path.split('/').last,
      );
    }

    await _apiClient.put(
      ApiEndpoints.tournamentById(tournament.tournamentId!),
      data: FormData.fromMap(fields),
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
  }

  @override
  Future<void> deleteTournament(String tournamentId) async {
    await _apiClient.delete(
      ApiEndpoints.tournamentById(tournamentId),
      options: await _authOptions,
    );
  }
}
