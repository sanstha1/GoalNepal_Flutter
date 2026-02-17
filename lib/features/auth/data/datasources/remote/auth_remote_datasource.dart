import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_nepal/core/api/api_client.dart';
import 'package:goal_nepal/core/api/api_endpoints.dart';
import 'package:goal_nepal/core/services/storage/token_service.dart';
import 'package:goal_nepal/core/services/storage/user_session_service.dart';
import 'package:goal_nepal/features/auth/data/datasources/auth_datasource.dart';
import 'package:goal_nepal/features/auth/data/models/auth_api_model.dart';
import 'package:goal_nepal/features/auth/data/models/auth_hive_model.dart';

final authRemoteDatasourceProvider = Provider<IAuthRemoteDataSource>((ref) {
  return AuthRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    userSessionService: ref.read(userSessionServiceProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class AuthRemoteDatasource implements IAuthRemoteDataSource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;
  final TokenService _tokenService;

  AuthRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _userSessionService = userSessionService,
       _tokenService = tokenService;

  @override
  Future<AuthApiModel?> getUserById(AuthHiveModel auth) async {
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.user}/${auth.authId}',
      );
      final data = response.data;

      if (data is Map<String, dynamic> &&
          data['user'] is Map<String, dynamic>) {
        return AuthApiModel.fromJson(data['user']);
      }
      return null;
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map<String, dynamic>
          ? data['message']
          : data?.toString();
      throw Exception(message ?? 'Failed to fetch user');
    }
  }

  @override
  Future<AuthApiModel?> login(String email, String password) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );

      final responseData = response.data;

      if (responseData is Map<String, dynamic> &&
          responseData['data'] is Map<String, dynamic>) {
        final user = AuthApiModel.fromJson(responseData['data']);

        await _userSessionService.saveUserSession(
          authId: user.id!,
          email: user.email,
          fullName: user.fullName,
          profileImage: user.profilePicture,
        );

        final token = responseData['token'];
        await _tokenService.saveToken(token);

        return user;
      }

      throw Exception('Invalid login response');
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map<String, dynamic>
          ? data['message']
          : data?.toString();
      throw Exception(message ?? 'Login failed');
    }
  }

  @override
  Future<AuthApiModel> register(AuthApiModel user) async {
    try {
      await _apiClient.post(
        ApiEndpoints.register,
        data: {
          'fullName': user.fullName,
          'email': user.email,
          'password': user.password,
        },
      );
      return user;
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map<String, dynamic>
          ? data['message']
          : data?.toString();
      throw Exception(message ?? 'Registration failed');
    }
  }

  @override
  Future<String> uploadProfilePicture(File photo, String userId) async {
    try {
      String fileName = photo.path.split('/').last;
      FormData formData = FormData.fromMap({
        'profilePicture': await MultipartFile.fromFile(
          photo.path,
          filename: fileName,
        ),
      });

      if (kDebugMode) {
        print('=== UPLOAD DEBUG ===');
      }
      if (kDebugMode) {
        print('Uploading to: ${ApiEndpoints.uploadProfilePicture}/$userId');
      }
      if (kDebugMode) {
        print('File name: $fileName');
      }

      final response = await _apiClient.post(
        '${ApiEndpoints.uploadProfilePicture}/$userId',
        data: formData,
      );

      if (kDebugMode) {
        print('Upload response status: ${response.statusCode}');
      }
      if (kDebugMode) {
        print('Upload response data: ${response.data}');
      }

      final data = response.data;
      if (data is Map<String, dynamic> && data['profilePicture'] != null) {
        if (kDebugMode) {
          print('Profile picture URL: ${data['profilePicture']}');
        }
        return data['profilePicture'];
      }

      throw Exception('Failed to get profile picture URL');
    } on DioException catch (e) {
      if (kDebugMode) {
        print('Upload error: ${e.response?.data}');
      }
      final data = e.response?.data;
      final message = data is Map<String, dynamic>
          ? data['message']
          : data?.toString();
      throw Exception(message ?? 'Failed to upload profile picture');
    }
  }

  @override
  Future<AuthApiModel> updateProfilePicture(
    String userId,
    String profilePictureUrl,
  ) async {
    try {
      if (kDebugMode) {
        print('=== UPDATE DEBUG ===');
      }
      if (kDebugMode) {
        print('Updating user: $userId');
      }
      if (kDebugMode) {
        print('New profile picture: $profilePictureUrl');
      }

      final response = await _apiClient.patch(
        '${ApiEndpoints.user}/$userId',
        data: {'profilePicture': profilePictureUrl},
      );

      if (kDebugMode) {
        print('Update response status: ${response.statusCode}');
      }
      if (kDebugMode) {
        print('Update response data: ${response.data}');
      }

      final data = response.data;
      if (data is Map<String, dynamic> &&
          data['user'] is Map<String, dynamic>) {
        final updatedUser = AuthApiModel.fromJson(data['user']);

        await _userSessionService.saveUserSession(
          authId: updatedUser.id!,
          email: updatedUser.email,
          fullName: updatedUser.fullName,
          profileImage: updatedUser.profilePicture,
        );

        return updatedUser;
      }

      throw Exception('Failed to update profile picture');
    } on DioException catch (e) {
      if (kDebugMode) {
        print('Update error: ${e.response?.data}');
      }
      final data = e.response?.data;
      final message = data is Map<String, dynamic>
          ? data['message']
          : data?.toString();
      throw Exception(message ?? 'Failed to update profile picture');
    }
  }
}
