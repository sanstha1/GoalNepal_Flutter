import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_nepal/core/services/hive/hive_service.dart';
import 'package:goal_nepal/core/services/storage/user_session_service.dart';
import 'package:goal_nepal/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:goal_nepal/features/auth/domain/usecases/login_usecase.dart';
import 'package:goal_nepal/features/auth/domain/usecases/register_usecase.dart';
import 'package:goal_nepal/features/auth/domain/usecases/upload_profilepicture_usecase.dart';
import 'package:goal_nepal/features/auth/presentation/state/auth_state.dart';
import 'package:goal_nepal/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:goal_nepal/features/buttom_navigation/presentation/pages/buttom_navigation_screen.dart';
import 'package:goal_nepal/features/tournament/presentation/state/tournament_state.dart';
import 'package:goal_nepal/features/tournament/presentation/view_model/tournament_viewmodel.dart';
import 'package:goal_nepal/core/services/sensors/shake_service.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockLoginUsecase extends Mock implements LoginUsecase {}

class MockRegisterUsecase extends Mock implements RegisterUsecase {}

class MockGetCurrentUserUsecase extends Mock implements GetCurrentUserUsecase {}

class MockUploadProfilePictureUsecase extends Mock
    implements UploadProfilePictureUsecase {}

class MockShakeService extends Mock implements ShakeService {}

class FakeTournamentViewModel extends TournamentViewModel {
  @override
  TournamentState build() =>
      const TournamentState(status: TournamentStatus.initial, tournaments: []);

  @override
  Future<void> getAllTournaments() async {}
}

class FakeAuthViewModel extends AuthViewModel {
  @override
  AuthState build() => const AuthState(status: AuthStatus.initial);

  @override
  Future<void> getCurrentUser() async {}
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Dashboard Integration Tests', () {
    late SharedPreferences sharedPreferences;
    late HiveService hiveService;
    late MockShakeService mockShakeService;

    setUpAll(() async {
      hiveService = HiveService();
      await hiveService.init();
      SharedPreferences.setMockInitialValues({});
      sharedPreferences = await SharedPreferences.getInstance();
    });

    tearDownAll(() async {
      await hiveService.close();
    });

    setUp(() {
      mockShakeService = MockShakeService();
      when(
        () => mockShakeService.start(onShake: any(named: 'onShake')),
      ).thenReturn(null);
      when(() => mockShakeService.stop()).thenReturn(null);
    });

    Widget createDashboardPage() {
      return ProviderScope(
        overrides: [
          hiveServiceProvider.overrideWithValue(hiveService),
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          loginUsecaseProvider.overrideWithValue(MockLoginUsecase()),
          registerUsecaseProvider.overrideWithValue(MockRegisterUsecase()),
          getCurrentUserUsecaseProvider.overrideWithValue(
            MockGetCurrentUserUsecase(),
          ),
          uploadProfilePictureUsecaseProvider.overrideWithValue(
            MockUploadProfilePictureUsecase(),
          ),
          shakeServiceProvider.overrideWithValue(mockShakeService),
          tournamentViewModelProvider.overrideWith(
            () => FakeTournamentViewModel(),
          ),
          authViewModelProvider.overrideWith(() => FakeAuthViewModel()),
        ],
        child: const MaterialApp(home: ButtomNavigationScreen()),
      );
    }

    testWidgets('Dashboard should display bottom navigation bar', (
      tester,
    ) async {
      await tester.pumpWidget(createDashboardPage());
      await tester.pump();

      expect(find.byType(BottomAppBar), findsOneWidget);
    });

    testWidgets('Dashboard should display Home nav label', (tester) async {
      await tester.pumpWidget(createDashboardPage());
      await tester.pump();

      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('Dashboard should display News nav label', (tester) async {
      await tester.pumpWidget(createDashboardPage());
      await tester.pump();

      expect(find.text('News'), findsOneWidget);
    });

    testWidgets('Dashboard should display Saved nav label', (tester) async {
      await tester.pumpWidget(createDashboardPage());
      await tester.pump();

      expect(find.text('Saved'), findsOneWidget);
    });

    testWidgets('Dashboard should display Profile nav label', (tester) async {
      await tester.pumpWidget(createDashboardPage());
      await tester.pump();

      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('Dashboard should display home icon', (tester) async {
      await tester.pumpWidget(createDashboardPage());
      await tester.pump();

      expect(find.byIcon(Icons.home_outlined), findsOneWidget);
    });

    testWidgets('Dashboard should display news icon', (tester) async {
      await tester.pumpWidget(createDashboardPage());
      await tester.pump();

      expect(find.byIcon(Icons.newspaper_outlined), findsOneWidget);
    });

    testWidgets('Dashboard should display saved icon', (tester) async {
      await tester.pumpWidget(createDashboardPage());
      await tester.pump();

      expect(find.byIcon(Icons.bookmark_outlined), findsOneWidget);
    });

    testWidgets('Dashboard should display profile icon', (tester) async {
      await tester.pumpWidget(createDashboardPage());
      await tester.pump();

      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    });

    testWidgets('Dashboard should display floating action button', (
      tester,
    ) async {
      await tester.pumpWidget(createDashboardPage());
      await tester.pump();

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('Dashboard FAB should display trophy icon', (tester) async {
      await tester.pumpWidget(createDashboardPage());
      await tester.pump();

      expect(find.byIcon(Icons.emoji_events), findsOneWidget);
    });

    testWidgets('Dashboard should show Home screen by default', (tester) async {
      await tester.pumpWidget(createDashboardPage());
      await tester.pump();

      // Home label is white (selected) by default
      final homeText = tester.widget<Text>(find.text('Home'));
      expect(homeText.style?.color, equals(Colors.white));
    });

    testWidgets('Dashboard should show News as unselected by default', (
      tester,
    ) async {
      await tester.pumpWidget(createDashboardPage());
      await tester.pump();

      final newsText = tester.widget<Text>(find.text('News'));
      expect(newsText.style?.color, equals(Colors.white60));
    });

    testWidgets('Dashboard should navigate to News on tap', (tester) async {
      await tester.pumpWidget(createDashboardPage());
      await tester.pump();

      await tester.tap(find.text('News'));
      await tester.pump();

      final newsText = tester.widget<Text>(find.text('News'));
      expect(newsText.style?.color, equals(Colors.white));
    });

    testWidgets('Dashboard should navigate to Saved on tap', (tester) async {
      await tester.pumpWidget(createDashboardPage());
      await tester.pump();

      await tester.tap(find.text('Saved'));
      await tester.pump();

      final savedText = tester.widget<Text>(find.text('Saved'));
      expect(savedText.style?.color, equals(Colors.white));
    });

    testWidgets('Dashboard should navigate to Profile on tap', (tester) async {
      await tester.pumpWidget(createDashboardPage());
      await tester.pump();

      await tester.tap(find.text('Profile'));
      await tester.pump();

      final profileText = tester.widget<Text>(find.text('Profile'));
      expect(profileText.style?.color, equals(Colors.white));
    });

    testWidgets('Dashboard should return to Home after switching tabs', (
      tester,
    ) async {
      await tester.pumpWidget(createDashboardPage());
      await tester.pump();

      await tester.tap(find.text('News'));
      await tester.pump();

      await tester.tap(find.text('Home'));
      await tester.pump();

      final homeText = tester.widget<Text>(find.text('Home'));
      expect(homeText.style?.color, equals(Colors.white));
    });

    testWidgets('Dashboard FAB should be tappable without error', (
      tester,
    ) async {
      await tester.pumpWidget(createDashboardPage());
      await tester.pump();

      final fab = find.byType(FloatingActionButton);
      expect(fab, findsOneWidget);

      await tester.tap(fab);
      await tester.pump();
    });

    testWidgets('Dashboard should deselect previous tab when switching', (
      tester,
    ) async {
      await tester.pumpWidget(createDashboardPage());
      await tester.pump();

      await tester.tap(find.text('News'));
      await tester.pump();

      final homeText = tester.widget<Text>(find.text('Home'));
      expect(homeText.style?.color, equals(Colors.white60));

      final newsText = tester.widget<Text>(find.text('News'));
      expect(newsText.style?.color, equals(Colors.white));
    });
  });
}
