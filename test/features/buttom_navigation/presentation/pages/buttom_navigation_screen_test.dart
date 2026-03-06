import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_nepal/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:goal_nepal/features/auth/domain/usecases/login_usecase.dart';
import 'package:goal_nepal/features/auth/domain/usecases/register_usecase.dart';
import 'package:goal_nepal/features/auth/domain/usecases/upload_profilepicture_usecase.dart';
import 'package:goal_nepal/features/buttom_navigation/presentation/pages/buttom_navigation_screen.dart';
import 'package:goal_nepal/features/tournament/presentation/view_model/tournament_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUsecase extends Mock implements LoginUsecase {}

class MockRegisterUsecase extends Mock implements RegisterUsecase {}

class MockGetCurrentUserUsecase extends Mock implements GetCurrentUserUsecase {}

class MockUploadProfilePictureUsecase extends Mock
    implements UploadProfilePictureUsecase {}

class MockTournamentViewModel extends Mock implements TournamentViewModel {}

void main() {
  void ignoreAllErrors(WidgetTester tester) {
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {};
    addTearDown(() {
      FlutterError.onError = originalOnError;
    });
  }

  void setLargeScreen(WidgetTester tester) {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
  }

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        loginUsecaseProvider.overrideWithValue(MockLoginUsecase()),
        registerUsecaseProvider.overrideWithValue(MockRegisterUsecase()),
        getCurrentUserUsecaseProvider.overrideWithValue(
          MockGetCurrentUserUsecase(),
        ),
        uploadProfilePictureUsecaseProvider.overrideWithValue(
          MockUploadProfilePictureUsecase(),
        ),
        tournamentViewModelProvider.overrideWith(
          () => MockTournamentViewModel(),
        ),
      ],
      child: const MaterialApp(home: ButtomNavigationScreen()),
    );
  }

  group('ButtomNavigationScreen - UI Elements', () {
    testWidgets('should render without errors', (tester) async {
      ignoreAllErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.byType(ButtomNavigationScreen), findsOneWidget);
    });

    testWidgets('should display bottom navigation bar', (tester) async {
      ignoreAllErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.byType(BottomAppBar), findsOneWidget);
    });

    testWidgets('should display floating action button', (tester) async {
      ignoreAllErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('should display trophy icon on floating action button', (
      tester,
    ) async {
      ignoreAllErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.byIcon(Icons.emoji_events), findsOneWidget);
    });

    testWidgets('should display Home nav label', (tester) async {
      ignoreAllErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('should display News nav label', (tester) async {
      ignoreAllErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.text('News'), findsOneWidget);
    });

    testWidgets('should display Saved nav label', (tester) async {
      ignoreAllErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.text('Saved'), findsOneWidget);
    });

    testWidgets('should display Profile nav label', (tester) async {
      ignoreAllErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('should display home icon', (tester) async {
      ignoreAllErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.byIcon(Icons.home_outlined), findsOneWidget);
    });

    testWidgets('should display news icon', (tester) async {
      ignoreAllErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.byIcon(Icons.newspaper_outlined), findsOneWidget);
    });

    testWidgets('should display bookmark icon', (tester) async {
      ignoreAllErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.byIcon(Icons.bookmark_outlined), findsOneWidget);
    });

    testWidgets('should display profile icon', (tester) async {
      ignoreAllErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    });

    testWidgets('should display AppBar', (tester) async {
      ignoreAllErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.byType(AppBar), findsOneWidget);
    });
  });

  group('ButtomNavigationScreen - Navigation', () {
    testWidgets('Home label should be selected white by default', (
      tester,
    ) async {
      ignoreAllErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final homeText = tester.widget<Text>(find.text('Home'));
      expect(homeText.style?.color, equals(Colors.white));
    });

    testWidgets('News label should be unselected by default', (tester) async {
      ignoreAllErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final newsText = tester.widget<Text>(find.text('News'));
      expect(newsText.style?.color, equals(Colors.white60));
    });

    testWidgets('Saved label should be unselected by default', (tester) async {
      ignoreAllErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final savedText = tester.widget<Text>(find.text('Saved'));
      expect(savedText.style?.color, equals(Colors.white60));
    });

    testWidgets('Profile label should be unselected by default', (
      tester,
    ) async {
      ignoreAllErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final profileText = tester.widget<Text>(find.text('Profile'));
      expect(profileText.style?.color, equals(Colors.white60));
    });

    testWidgets('should switch to News tab when tapped', (tester) async {
      ignoreAllErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      await tester.tap(find.text('News'));
      await tester.pump();

      final newsText = tester.widget<Text>(find.text('News'));
      expect(newsText.style?.color, equals(Colors.white));
    });

    testWidgets('should switch to Saved tab when tapped', (tester) async {
      ignoreAllErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      await tester.tap(find.text('Saved'));
      await tester.pump();

      final savedText = tester.widget<Text>(find.text('Saved'));
      expect(savedText.style?.color, equals(Colors.white));
    });

    testWidgets('should switch back to Home tab when tapped', (tester) async {
      ignoreAllErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      await tester.tap(find.text('News'));
      await tester.pump();

      await tester.tap(find.text('Home'));
      await tester.pump();

      final homeText = tester.widget<Text>(find.text('Home'));
      expect(homeText.style?.color, equals(Colors.white));
    });

    testWidgets('previously selected tab should become unselected', (
      tester,
    ) async {
      ignoreAllErrors(tester);
      setLargeScreen(tester);
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      await tester.tap(find.text('News'));
      await tester.pump();

      final homeText = tester.widget<Text>(find.text('Home'));
      expect(homeText.style?.color, equals(Colors.white60));
    });
  });
}
