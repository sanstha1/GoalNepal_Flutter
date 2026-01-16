import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_nepal/core/api/api_client.dart';
import 'package:goal_nepal/core/api/api_endpoints.dart';
import 'package:goal_nepal/core/services/storage/user_session_service.dart';
import 'package:goal_nepal/features/auth/data/datasources/auth_datasource.dart';
import 'package:goal_nepal/features/auth/data/models/auth_api_model.dart';
import 'package:goal_nepal/features/auth/data/models/auth_hive_model.dart';

final authRemoteDatasourceProvider = Provider<IAuthRemoteDataSource>((ref) {
  return AuthRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    userSessionService: ref.read(userSessionServiceProvider),
  );
});

class AuthRemoteDatasource implements IAuthRemoteDataSource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;

  AuthRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
  }) : _apiClient = apiClient,
       _userSessionService = userSessionService;

  @override
  Future<AuthApiModel?> getUserById(AuthHiveModel authId) async {
    final response = await _apiClient.get('${ApiEndpoints.user}/${authId.id}');

    final data = response.data as Map<String, dynamic>;
    if (data['user'] != null) {
      return AuthApiModel.fromJson(data['user']);
    }
    return null;
  }

  @override
  Future<AuthApiModel?> login(String email, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );

    final data = response.data as Map<String, dynamic>;

    if (data['token'] != null && data['user'] != null) {
      // final token = data['token'] as String;
      final userMap = data['user'] as Map<String, dynamic>;

      final user = AuthApiModel.fromJson(userMap);

      // await _userSessionService.saveToken(token);

      await _userSessionService.saveUserSession(
        authId: user.id!,
        email: user.email,
        fullName: user.fullName,
        profileImage: user.profilePicture,
      );

      return user;
    }

    return null;
  }

  @override
  Future<AuthApiModel> register(AuthApiModel user) async {
    final response = await _apiClient.post(
      ApiEndpoints.register,
      data: user.toJson(),
    );

    final data = response.data as Map<String, dynamic>;

    if (data['user'] != null) {
      return AuthApiModel.fromJson(data['user']);
    }

    return user;
  }
}
