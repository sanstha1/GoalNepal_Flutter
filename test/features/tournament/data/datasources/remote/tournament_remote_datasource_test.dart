import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_nepal/core/api/api_client.dart';
import 'package:goal_nepal/core/services/storage/token_service.dart';
import 'package:goal_nepal/features/tournament/data/datasources/remote/tournament_remote_datasource.dart';
import 'package:goal_nepal/features/tournament/data/models/tournament_api_model.dart';
import 'package:mocktail/mocktail.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockTokenService extends Mock implements TokenService {}

void main() {
  late TournamentRemoteDatasource datasource;
  late MockApiClient mockApiClient;
  late MockTokenService mockTokenService;

  setUpAll(() {
    registerFallbackValue(Options());
    registerFallbackValue(FormData.fromMap({}));
  });

  setUp(() {
    mockApiClient = MockApiClient();
    mockTokenService = MockTokenService();
    datasource = TournamentRemoteDatasource(
      apiClient: mockApiClient,
      tokenService: mockTokenService,
    );
  });

  final tTournamentApiModel = TournamentApiModel(
    tournamentId: '1',
    title: 'Test Tournament',
    location: 'Test Location',
    description: 'Test Description',
    organizer: 'Test Organizer',
    type: 'football',
    startDate: DateTime(2025, 6, 1),
    endDate: DateTime(2025, 6, 10),
    bannerImage: null,
    prize: null,
    maxTeams: null,
    createdBy: null,
  );

  final tTournamentApiModelList = [
    TournamentApiModel(
      tournamentId: '1',
      title: 'Football Cup',
      location: 'Kathmandu',
      description: 'Football tournament',
      organizer: 'Org1',
      type: 'football',
      startDate: DateTime(2025, 6, 1),
      endDate: DateTime(2025, 6, 10),
      bannerImage: null,
      prize: null,
      maxTeams: null,
      createdBy: null,
    ),
    TournamentApiModel(
      tournamentId: '2',
      title: 'Futsal League',
      location: 'Pokhara',
      description: 'Futsal tournament',
      organizer: 'Org2',
      type: 'futsal',
      startDate: DateTime(2025, 7, 1),
      endDate: DateTime(2025, 7, 10),
      bannerImage: null,
      prize: null,
      maxTeams: null,
      createdBy: null,
    ),
  ];

  group('createTournament', () {
    test(
      'should call apiClient.post with correct data when creating tournament',
      () async {
        // Arrange
        when(
          () => mockTokenService.getToken(),
        ).thenAnswer((_) async => 'test_token');
        when(
          () => mockApiClient.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/tournaments'),
            statusCode: 201,
            data: {'success': true},
          ),
        );

        // Act
        await datasource.createTournament(tTournamentApiModel);

        // Assert
        verify(() => mockTokenService.getToken()).called(1);
        verify(
          () => mockApiClient.post(
            any(),
            data: any(named: 'data'),
            options: any(named: 'options'),
          ),
        ).called(1);
      },
    );

    test('should throw DioException when apiClient.post fails', () async {
      // Arrange
      when(
        () => mockTokenService.getToken(),
      ).thenAnswer((_) async => 'test_token');
      when(
        () => mockApiClient.post(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/tournaments'),
          error: 'Network error',
        ),
      );

      // Act & Assert
      expect(
        () => datasource.createTournament(tTournamentApiModel),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('getAllTournaments', () {
    test('should return list of tournaments when api call succeeds', () async {
      // Arrange
      when(() => mockApiClient.get(any())).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/tournaments'),
          statusCode: 200,
          data: {
            'data': tTournamentApiModelList.map((t) => t.toJson()).toList(),
          },
        ),
      );

      // Act
      final result = await datasource.getAllTournaments();

      // Assert
      expect(result, isA<List<TournamentApiModel>>());
      expect(result.length, 2);
      expect(result[0].title, 'Football Cup');
      verify(() => mockApiClient.get(any())).called(1);
    });

    test('should throw DioException when api call fails', () async {
      // Arrange
      when(() => mockApiClient.get(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/tournaments'),
          error: 'Network error',
        ),
      );

      // Act & Assert
      expect(
        () => datasource.getAllTournaments(),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('getTournamentById', () {
    test('should throw DioException when tournament not found', () async {
      // Arrange
      when(() => mockApiClient.get(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/tournaments/999'),
          response: Response(
            requestOptions: RequestOptions(path: '/tournaments/999'),
            statusCode: 404,
            data: {'message': 'Not found'},
          ),
        ),
      );

      // Act & Assert
      expect(
        () => datasource.getTournamentById('999'),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('getMyTournaments', () {
    test('should return list of user tournaments with auth header', () async {
      // Arrange
      when(
        () => mockTokenService.getToken(),
      ).thenAnswer((_) async => 'user_token');
      when(
        () => mockApiClient.get(any(), options: any(named: 'options')),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/tournaments/my'),
          statusCode: 200,
          data: {
            'data': tTournamentApiModelList.map((t) => t.toJson()).toList(),
          },
        ),
      );

      // Act
      final result = await datasource.getMyTournaments();

      // Assert
      expect(result.length, 2);
      verify(() => mockTokenService.getToken()).called(1);
      verify(
        () => mockApiClient.get(any(), options: any(named: 'options')),
      ).called(1);
    });

    test('should throw DioException when api call fails', () async {
      // Arrange
      when(
        () => mockTokenService.getToken(),
      ).thenAnswer((_) async => 'user_token');
      when(
        () => mockApiClient.get(any(), options: any(named: 'options')),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/tournaments/my'),
          error: 'Auth error',
        ),
      );

      // Act & Assert
      expect(() => datasource.getMyTournaments(), throwsA(isA<DioException>()));
    });
  });

  group('getFootballTournaments', () {
    test(
      'should return list of football tournaments with type filter',
      () async {
        // Arrange
        when(
          () => mockApiClient.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: '/tournaments'),
            statusCode: 200,
            data: {
              'data': [tTournamentApiModelList[0].toJson()],
            },
          ),
        );

        // Act
        final result = await datasource.getFootballTournaments();

        // Assert
        expect(result.length, 1);
        expect(result[0].type, 'football');
        verify(
          () => mockApiClient.get(any(), queryParameters: {'type': 'football'}),
        ).called(1);
      },
    );
  });

  group('getFutsalTournaments', () {
    test('should return list of futsal tournaments with type filter', () async {
      // Arrange
      when(
        () => mockApiClient.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/tournaments'),
          statusCode: 200,
          data: {
            'data': [tTournamentApiModelList[1].toJson()],
          },
        ),
      );

      // Act
      final result = await datasource.getFutsalTournaments();

      // Assert
      expect(result.length, 1);
      expect(result[0].type, 'futsal');
      verify(
        () => mockApiClient.get(any(), queryParameters: {'type': 'futsal'}),
      ).called(1);
    });
  });

  group('updateTournament', () {
    test('should call apiClient.put with correct data when updating', () async {
      // Arrange
      when(
        () => mockTokenService.getToken(),
      ).thenAnswer((_) async => 'test_token');
      when(
        () => mockApiClient.put(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/tournaments/1'),
          statusCode: 200,
          data: {'success': true},
        ),
      );

      // Act
      await datasource.updateTournament(tTournamentApiModel);

      // Assert
      verify(() => mockTokenService.getToken()).called(1);
      verify(
        () => mockApiClient.put(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).called(1);
    });

    test('should throw DioException when update fails', () async {
      // Arrange
      when(
        () => mockTokenService.getToken(),
      ).thenAnswer((_) async => 'test_token');
      when(
        () => mockApiClient.put(
          any(),
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/tournaments/1'),
          error: 'Update failed',
        ),
      );

      // Act & Assert
      expect(
        () => datasource.updateTournament(tTournamentApiModel),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('deleteTournament', () {
    test('should call apiClient.delete with auth header', () async {
      // Arrange
      when(
        () => mockTokenService.getToken(),
      ).thenAnswer((_) async => 'test_token');
      when(
        () => mockApiClient.delete(any(), options: any(named: 'options')),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/tournaments/1'),
          statusCode: 204,
        ),
      );

      // Act
      await datasource.deleteTournament('1');

      // Assert
      verify(() => mockTokenService.getToken()).called(1);
      verify(
        () => mockApiClient.delete(any(), options: any(named: 'options')),
      ).called(1);
    });

    test('should throw DioException when delete fails', () async {
      // Arrange
      when(
        () => mockTokenService.getToken(),
      ).thenAnswer((_) async => 'test_token');
      when(
        () => mockApiClient.delete(any(), options: any(named: 'options')),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/tournaments/1'),
          error: 'Delete failed',
        ),
      );

      // Act & Assert
      expect(
        () => datasource.deleteTournament('1'),
        throwsA(isA<DioException>()),
      );
    });
  });

  group('uploadBanner', () {
    test('should throw UnimplementedError', () async {
      // Act & Assert
      expect(
        () => datasource.uploadBanner(File('test.jpg')),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });

  group('TournamentRemoteDatasource - Provider', () {
    test('should create instance with correct dependencies', () {
      // Arrange
      final container = ProviderContainer(
        overrides: [
          apiClientProvider.overrideWithValue(mockApiClient),
          tokenServiceProvider.overrideWithValue(mockTokenService),
        ],
      );
      addTearDown(container.dispose);

      // Act
      final result = container.read(tournamentRemoteDatasourceProvider);

      // Assert
      expect(result, isA<TournamentRemoteDatasource>());
    });
  });

  group('TournamentRemoteDatasource - Auth Options', () {
    test('should call getToken when making authenticated request', () async {
      // Arrange
      when(
        () => mockTokenService.getToken(),
      ).thenAnswer((_) async => 'bearer_123');
      when(
        () => mockApiClient.get(any(), options: any(named: 'options')),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/tournaments'),
          statusCode: 200,
          data: {'data': []},
        ),
      );

      // Act
      await datasource.getMyTournaments();

      // Assert
      verify(() => mockTokenService.getToken()).called(1);
      verify(
        () => mockApiClient.get(any(), options: any(named: 'options')),
      ).called(1);
    });
  });

  group('TournamentRemoteDatasource - Error Handling', () {
    test('should propagate DioException from apiClient', () async {
      // Arrange
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/tournaments'),
        error: 'Connection timeout',
        type: DioExceptionType.connectionTimeout,
      );
      when(() => mockApiClient.get(any())).thenThrow(dioError);

      // Act & Assert
      expect(
        () => datasource.getAllTournaments(),
        throwsA(isA<DioException>()),
      );
    });

    test('should handle empty response data gracefully', () async {
      // Arrange
      when(() => mockApiClient.get(any())).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/tournaments'),
          statusCode: 200,
          data: {'data': []},
        ),
      );

      // Act
      final result = await datasource.getAllTournaments();

      // Assert
      expect(result, isEmpty);
    });
  });
}
