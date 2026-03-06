import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_nepal/features/register/data/datasources/remote/register_remote_datasource.dart';
import 'package:goal_nepal/features/register/presentation/state/register_state.dart';
import 'package:goal_nepal/features/register/presentation/view_model/register_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockRegistrationRemoteDatasource extends Mock
    implements RegistrationRemoteDatasource {}

void main() {
  late RegistrationViewModel viewModel;
  late MockRegistrationRemoteDatasource mockDatasource;
  late ProviderContainer container;

  setUp(() {
    mockDatasource = MockRegistrationRemoteDatasource();

    container = ProviderContainer(
      overrides: [
        registrationRemoteDatasourceProvider.overrideWithValue(mockDatasource),
      ],
    );

    viewModel = container.read(registrationViewModelProvider.notifier);
  });

  tearDown(() {
    container.dispose();
  });

  const tTournamentId = 'tournament_001';
  const tTournamentTitle = 'Goal Nepal Cup 2025';
  const tTeamName = 'Rising Stars';
  const tCaptainName = 'Santosh';
  const tCaptainPhone = '9841000000';
  const tCaptainEmail = 'sthasantosh070@gmail.com';
  const tPlayerCount = 11;

  group('RegistrationViewModel - Initial State', () {
    test('initial state should be RegistrationStatus.initial', () {
      final state = container.read(registrationViewModelProvider);
      expect(state.status, RegistrationStatus.initial);
      expect(state.errorMessage, isNull);
    });
  });

  group('RegistrationViewModel - Register For Tournament', () {
    test(
      'should emit loading then success on successful registration',
      () async {
        final states = <RegistrationStatus>[];

        container.listen<RegistrationState>(
          registrationViewModelProvider,
          (previous, next) => states.add(next.status),
          fireImmediately: false,
        );

        when(
          () => mockDatasource.registerForTournament(
            tournamentId: any(named: 'tournamentId'),
            tournamentTitle: any(named: 'tournamentTitle'),
            teamName: any(named: 'teamName'),
            captainName: any(named: 'captainName'),
            captainPhone: any(named: 'captainPhone'),
            captainEmail: any(named: 'captainEmail'),
            playerCount: any(named: 'playerCount'),
            players: any(named: 'players'),
          ),
        ).thenAnswer((_) async => <String, dynamic>{});

        await viewModel.registerForTournament(
          tournamentId: tTournamentId,
          tournamentTitle: tTournamentTitle,
          teamName: tTeamName,
          captainName: tCaptainName,
          captainPhone: tCaptainPhone,
          captainEmail: tCaptainEmail,
          playerCount: tPlayerCount,
        );

        expect(states, [
          RegistrationStatus.loading,
          RegistrationStatus.success,
        ]);
        verify(
          () => mockDatasource.registerForTournament(
            tournamentId: tTournamentId,
            tournamentTitle: tTournamentTitle,
            teamName: tTeamName,
            captainName: tCaptainName,
            captainPhone: tCaptainPhone,
            captainEmail: tCaptainEmail,
            playerCount: tPlayerCount,
            players: null,
          ),
        ).called(1);
      },
    );

    test('should return true on successful registration', () async {
      when(
        () => mockDatasource.registerForTournament(
          tournamentId: any(named: 'tournamentId'),
          tournamentTitle: any(named: 'tournamentTitle'),
          teamName: any(named: 'teamName'),
          captainName: any(named: 'captainName'),
          captainPhone: any(named: 'captainPhone'),
          captainEmail: any(named: 'captainEmail'),
          playerCount: any(named: 'playerCount'),
          players: any(named: 'players'),
        ),
      ).thenAnswer((_) async => <String, dynamic>{});

      final result = await viewModel.registerForTournament(
        tournamentId: tTournamentId,
        tournamentTitle: tTournamentTitle,
        teamName: tTeamName,
        captainName: tCaptainName,
        captainPhone: tCaptainPhone,
        captainEmail: tCaptainEmail,
        playerCount: tPlayerCount,
      );

      expect(result, isTrue);
    });

    test('should emit loading then error on DioException', () async {
      final states = <RegistrationStatus>[];

      container.listen<RegistrationState>(
        registrationViewModelProvider,
        (previous, next) => states.add(next.status),
        fireImmediately: false,
      );

      final dioError = DioException(
        requestOptions: RequestOptions(path: '/register'),
        response: Response(
          requestOptions: RequestOptions(path: '/register'),
          data: {'message': 'Registration failed'},
          statusCode: 400,
        ),
      );

      when(
        () => mockDatasource.registerForTournament(
          tournamentId: any(named: 'tournamentId'),
          tournamentTitle: any(named: 'tournamentTitle'),
          teamName: any(named: 'teamName'),
          captainName: any(named: 'captainName'),
          captainPhone: any(named: 'captainPhone'),
          captainEmail: any(named: 'captainEmail'),
          playerCount: any(named: 'playerCount'),
          players: any(named: 'players'),
        ),
      ).thenThrow(dioError);

      await viewModel.registerForTournament(
        tournamentId: tTournamentId,
        tournamentTitle: tTournamentTitle,
        teamName: tTeamName,
        captainName: tCaptainName,
        captainPhone: tCaptainPhone,
        captainEmail: tCaptainEmail,
        playerCount: tPlayerCount,
      );

      expect(states, [RegistrationStatus.loading, RegistrationStatus.error]);

      final state = container.read(registrationViewModelProvider);
      expect(state.status, RegistrationStatus.error);
      expect(state.errorMessage, 'Registration failed');
    });

    test('should return false on DioException', () async {
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/register'),
        response: Response(
          requestOptions: RequestOptions(path: '/register'),
          data: {'message': 'Registration failed'},
          statusCode: 400,
        ),
      );

      when(
        () => mockDatasource.registerForTournament(
          tournamentId: any(named: 'tournamentId'),
          tournamentTitle: any(named: 'tournamentTitle'),
          teamName: any(named: 'teamName'),
          captainName: any(named: 'captainName'),
          captainPhone: any(named: 'captainPhone'),
          captainEmail: any(named: 'captainEmail'),
          playerCount: any(named: 'playerCount'),
          players: any(named: 'players'),
        ),
      ).thenThrow(dioError);

      final result = await viewModel.registerForTournament(
        tournamentId: tTournamentId,
        tournamentTitle: tTournamentTitle,
        teamName: tTeamName,
        captainName: tCaptainName,
        captainPhone: tCaptainPhone,
        captainEmail: tCaptainEmail,
        playerCount: tPlayerCount,
      );

      expect(result, isFalse);
    });

    test('should use DioException response message when available', () async {
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/register'),
        response: Response(
          requestOptions: RequestOptions(path: '/register'),
          data: {'message': 'Team name already taken'},
          statusCode: 409,
        ),
      );

      when(
        () => mockDatasource.registerForTournament(
          tournamentId: any(named: 'tournamentId'),
          tournamentTitle: any(named: 'tournamentTitle'),
          teamName: any(named: 'teamName'),
          captainName: any(named: 'captainName'),
          captainPhone: any(named: 'captainPhone'),
          captainEmail: any(named: 'captainEmail'),
          playerCount: any(named: 'playerCount'),
          players: any(named: 'players'),
        ),
      ).thenThrow(dioError);

      await viewModel.registerForTournament(
        tournamentId: tTournamentId,
        tournamentTitle: tTournamentTitle,
        teamName: tTeamName,
        captainName: tCaptainName,
        captainPhone: tCaptainPhone,
        captainEmail: tCaptainEmail,
        playerCount: tPlayerCount,
      );

      final state = container.read(registrationViewModelProvider);
      expect(state.status, RegistrationStatus.error);
      expect(state.errorMessage, 'Team name already taken');
    });

    test(
      'should fall back to "Registration failed" when DioException has no response message',
      () async {
        final dioError = DioException(
          requestOptions: RequestOptions(path: '/register'),
        );

        when(
          () => mockDatasource.registerForTournament(
            tournamentId: any(named: 'tournamentId'),
            tournamentTitle: any(named: 'tournamentTitle'),
            teamName: any(named: 'teamName'),
            captainName: any(named: 'captainName'),
            captainPhone: any(named: 'captainPhone'),
            captainEmail: any(named: 'captainEmail'),
            playerCount: any(named: 'playerCount'),
            players: any(named: 'players'),
          ),
        ).thenThrow(dioError);

        await viewModel.registerForTournament(
          tournamentId: tTournamentId,
          tournamentTitle: tTournamentTitle,
          teamName: tTeamName,
          captainName: tCaptainName,
          captainPhone: tCaptainPhone,
          captainEmail: tCaptainEmail,
          playerCount: tPlayerCount,
        );

        final state = container.read(registrationViewModelProvider);
        expect(state.status, RegistrationStatus.error);
        expect(state.errorMessage, 'Registration failed');
      },
    );

    test(
      'should emit error with "Something went wrong" on generic exception',
      () async {
        when(
          () => mockDatasource.registerForTournament(
            tournamentId: any(named: 'tournamentId'),
            tournamentTitle: any(named: 'tournamentTitle'),
            teamName: any(named: 'teamName'),
            captainName: any(named: 'captainName'),
            captainPhone: any(named: 'captainPhone'),
            captainEmail: any(named: 'captainEmail'),
            playerCount: any(named: 'playerCount'),
            players: any(named: 'players'),
          ),
        ).thenThrow(Exception('Unexpected error'));

        await viewModel.registerForTournament(
          tournamentId: tTournamentId,
          tournamentTitle: tTournamentTitle,
          teamName: tTeamName,
          captainName: tCaptainName,
          captainPhone: tCaptainPhone,
          captainEmail: tCaptainEmail,
          playerCount: tPlayerCount,
        );

        final state = container.read(registrationViewModelProvider);
        expect(state.status, RegistrationStatus.error);
        expect(state.errorMessage, 'Something went wrong');
      },
    );

    test('should return false on generic exception', () async {
      when(
        () => mockDatasource.registerForTournament(
          tournamentId: any(named: 'tournamentId'),
          tournamentTitle: any(named: 'tournamentTitle'),
          teamName: any(named: 'teamName'),
          captainName: any(named: 'captainName'),
          captainPhone: any(named: 'captainPhone'),
          captainEmail: any(named: 'captainEmail'),
          playerCount: any(named: 'playerCount'),
          players: any(named: 'players'),
        ),
      ).thenThrow(Exception('Unexpected error'));

      final result = await viewModel.registerForTournament(
        tournamentId: tTournamentId,
        tournamentTitle: tTournamentTitle,
        teamName: tTeamName,
        captainName: tCaptainName,
        captainPhone: tCaptainPhone,
        captainEmail: tCaptainEmail,
        playerCount: tPlayerCount,
      );

      expect(result, isFalse);
    });

    test('should pass players list to datasource when provided', () async {
      final tPlayers = [
        {'name': 'Player 1', 'position': 'Forward'},
        {'name': 'Player 2', 'position': 'Midfielder'},
      ];

      List<Map<String, dynamic>>? capturedPlayers;

      when(
        () => mockDatasource.registerForTournament(
          tournamentId: any(named: 'tournamentId'),
          tournamentTitle: any(named: 'tournamentTitle'),
          teamName: any(named: 'teamName'),
          captainName: any(named: 'captainName'),
          captainPhone: any(named: 'captainPhone'),
          captainEmail: any(named: 'captainEmail'),
          playerCount: any(named: 'playerCount'),
          players: any(named: 'players'),
        ),
      ).thenAnswer((invocation) {
        capturedPlayers =
            invocation.namedArguments[#players] as List<Map<String, dynamic>>?;
        return Future.value(<String, dynamic>{});
      });

      await viewModel.registerForTournament(
        tournamentId: tTournamentId,
        tournamentTitle: tTournamentTitle,
        teamName: tTeamName,
        captainName: tCaptainName,
        captainPhone: tCaptainPhone,
        captainEmail: tCaptainEmail,
        playerCount: tPlayerCount,
        players: tPlayers,
      );

      expect(capturedPlayers, tPlayers);
    });
  });

  group('RegistrationViewModel - Reset', () {
    test('should reset state back to initial after error', () async {
      final states = <RegistrationStatus>[];

      container.listen<RegistrationState>(
        registrationViewModelProvider,
        (previous, next) => states.add(next.status),
        fireImmediately: false,
      );

      final dioError = DioException(
        requestOptions: RequestOptions(path: '/register'),
        response: Response(
          requestOptions: RequestOptions(path: '/register'),
          data: {'message': 'Registration failed'},
          statusCode: 400,
        ),
      );

      when(
        () => mockDatasource.registerForTournament(
          tournamentId: any(named: 'tournamentId'),
          tournamentTitle: any(named: 'tournamentTitle'),
          teamName: any(named: 'teamName'),
          captainName: any(named: 'captainName'),
          captainPhone: any(named: 'captainPhone'),
          captainEmail: any(named: 'captainEmail'),
          playerCount: any(named: 'playerCount'),
          players: any(named: 'players'),
        ),
      ).thenThrow(dioError);

      await viewModel.registerForTournament(
        tournamentId: tTournamentId,
        tournamentTitle: tTournamentTitle,
        teamName: tTeamName,
        captainName: tCaptainName,
        captainPhone: tCaptainPhone,
        captainEmail: tCaptainEmail,
        playerCount: tPlayerCount,
      );

      expect(
        container.read(registrationViewModelProvider).status,
        RegistrationStatus.error,
      );

      viewModel.reset();

      expect(states, [
        RegistrationStatus.loading,
        RegistrationStatus.error,
        RegistrationStatus.initial,
      ]);

      final state = container.read(registrationViewModelProvider);
      expect(state.status, RegistrationStatus.initial);
      expect(state.errorMessage, isNull);
    });

    test('should reset state back to initial after success', () async {
      final states = <RegistrationStatus>[];

      container.listen<RegistrationState>(
        registrationViewModelProvider,
        (previous, next) => states.add(next.status),
        fireImmediately: false,
      );

      when(
        () => mockDatasource.registerForTournament(
          tournamentId: any(named: 'tournamentId'),
          tournamentTitle: any(named: 'tournamentTitle'),
          teamName: any(named: 'teamName'),
          captainName: any(named: 'captainName'),
          captainPhone: any(named: 'captainPhone'),
          captainEmail: any(named: 'captainEmail'),
          playerCount: any(named: 'playerCount'),
          players: any(named: 'players'),
        ),
      ).thenAnswer((_) async => <String, dynamic>{});

      await viewModel.registerForTournament(
        tournamentId: tTournamentId,
        tournamentTitle: tTournamentTitle,
        teamName: tTeamName,
        captainName: tCaptainName,
        captainPhone: tCaptainPhone,
        captainEmail: tCaptainEmail,
        playerCount: tPlayerCount,
      );

      expect(
        container.read(registrationViewModelProvider).status,
        RegistrationStatus.success,
      );

      viewModel.reset();

      expect(states, [
        RegistrationStatus.loading,
        RegistrationStatus.success,
        RegistrationStatus.initial,
      ]);

      final state = container.read(registrationViewModelProvider);
      expect(state.status, RegistrationStatus.initial);
      expect(state.errorMessage, isNull);
    });
  });
}
