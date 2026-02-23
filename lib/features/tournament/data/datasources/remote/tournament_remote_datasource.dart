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
    // No separate upload endpoint — banner is sent with createTournament
    throw UnimplementedError('Use createTournament with bannerFile instead');
  }

  @override
  Future<TournamentApiModel> createTournament(
    TournamentApiModel tournament, {
    File? bannerFile,
  }) async {
    final token = await _tokenService.getToken();

    FormData formData;

    if (bannerFile != null) {
      final fileName = bannerFile.path.split('/').last;
      formData = FormData.fromMap({
        'title': tournament.title,
        'type': tournament.type,
        'location': tournament.location,
        'startDate': tournament.startDate.toIso8601String(),
        'endDate': tournament.endDate.toIso8601String(),
        if (tournament.createdBy != null) 'createdBy': tournament.createdBy,
        'bannerImage': await MultipartFile.fromFile(
          bannerFile.path,
          filename: fileName,
        ),
      });
    } else {
      formData = FormData.fromMap({
        'title': tournament.title,
        'type': tournament.type,
        'location': tournament.location,
        'startDate': tournament.startDate.toIso8601String(),
        'endDate': tournament.endDate.toIso8601String(),
        if (tournament.createdBy != null) 'createdBy': tournament.createdBy,
      });
    }

    final response = await _apiClient.post(
      ApiEndpoints.tournaments,
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
        },
      ),
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
  Future<bool> updateTournament(
    TournamentApiModel tournament, {
    File? bannerFile,
  }) async {
    final token = await _tokenService.getToken();

    FormData formData;

    if (bannerFile != null) {
      final fileName = bannerFile.path.split('/').last;
      formData = FormData.fromMap({
        'title': tournament.title,
        'type': tournament.type,
        'location': tournament.location,
        'startDate': tournament.startDate.toIso8601String(),
        'endDate': tournament.endDate.toIso8601String(),
        'bannerImage': await MultipartFile.fromFile(
          bannerFile.path,
          filename: fileName,
        ),
      });
    } else {
      formData = FormData.fromMap({
        'title': tournament.title,
        'type': tournament.type,
        'location': tournament.location,
        'startDate': tournament.startDate.toIso8601String(),
        'endDate': tournament.endDate.toIso8601String(),
      });
    }

    await _apiClient.put(
      ApiEndpoints.tournamentById(tournament.tournamentId!),
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
        },
      ),
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
