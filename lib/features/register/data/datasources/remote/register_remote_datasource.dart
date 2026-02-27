import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_nepal/core/api/api_client.dart';
import 'package:goal_nepal/core/api/api_endpoints.dart';
import 'package:goal_nepal/core/services/storage/token_service.dart';

final registrationRemoteDatasourceProvider =
    Provider<RegistrationRemoteDatasource>((ref) {
      return RegistrationRemoteDatasource(
        apiClient: ref.read(apiClientProvider),
        tokenService: ref.read(tokenServiceProvider),
      );
    });

class RegistrationRemoteDatasource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  RegistrationRemoteDatasource({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  Future<Map<String, dynamic>> registerForTournament({
    required String tournamentId,
    required String tournamentTitle,
    required String teamName,
    required String captainName,
    required String captainPhone,
    required String captainEmail,
    required int playerCount,
    List<Map<String, dynamic>>? players,
  }) async {
    final token = await _tokenService.getToken();

    final response = await _apiClient.post(
      ApiEndpoints.registrations,
      data: {
        'tournamentId': tournamentId,
        'tournamentTitle': tournamentTitle,
        'teamName': teamName,
        'captainName': captainName,
        'captainPhone': captainPhone,
        'captainEmail': captainEmail,
        'playerCount': playerCount,
        'players': ?players,
      },
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return response.data as Map<String, dynamic>;
  }
}
