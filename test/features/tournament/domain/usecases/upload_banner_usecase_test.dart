import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_nepal/core/error/failures.dart';
import 'package:goal_nepal/features/tournament/domain/repositories/tournament_repository.dart';
import 'package:goal_nepal/features/tournament/domain/usecases/upload_banner_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockTournamentRepository extends Mock implements ITournamentRepository {}

class MockFile extends Mock implements File {}

void main() {
  late UploadBannerUsecase usecase;
  late MockTournamentRepository mockRepository;

  setUp(() {
    mockRepository = MockTournamentRepository();
    usecase = UploadBannerUsecase(repository: mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(MockFile());
  });

  group('UploadBannerUsecase', () {
    test('1. should return Right(String) with banner URL on success', () async {
      final mockFile = MockFile();
      const tBannerUrl = 'https://cdn.example.com/banners/tournament_001.jpg';

      when(
        () => mockRepository.uploadBanner(any()),
      ).thenAnswer((_) async => const Right(tBannerUrl));

      final result = await usecase(mockFile);

      expect(result, const Right(tBannerUrl));
      verify(() => mockRepository.uploadBanner(mockFile)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('2. should return Left(ApiFailure) when upload fails', () async {
      final mockFile = MockFile();
      const tFailure = ApiFailure(message: 'Failed to upload banner');

      when(
        () => mockRepository.uploadBanner(any()),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await usecase(mockFile);

      expect(result, const Left(tFailure));
      expect((result as Left).value.message, 'Failed to upload banner');
    });

    test(
      '3. should return Left(NetworkFailure) when device is offline',
      () async {
        final mockFile = MockFile();
        const tFailure = NetworkFailure();

        when(
          () => mockRepository.uploadBanner(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        final result = await usecase(mockFile);

        expect(result, isA<Left>());
        expect((result as Left).value, isA<NetworkFailure>());
      },
    );

    test('4. should forward exact File to repository', () async {
      final mockFile = MockFile();
      File? capturedFile;
      const tBannerUrl = 'https://cdn.example.com/banners/tournament_001.jpg';

      when(() => mockRepository.uploadBanner(any())).thenAnswer((invocation) {
        capturedFile = invocation.positionalArguments[0] as File;
        return Future.value(const Right(tBannerUrl));
      });

      await usecase(mockFile);

      expect(capturedFile, mockFile);
    });

    test(
      '5. should return Right with non-empty URL string on success',
      () async {
        final mockFile = MockFile();
        const tBannerUrl = 'https://cdn.example.com/banners/tournament_001.jpg';

        when(
          () => mockRepository.uploadBanner(any()),
        ).thenAnswer((_) async => const Right(tBannerUrl));

        final result = await usecase(mockFile);

        final value = (result as Right).value as String;
        expect(value, isA<String>());
        expect(value, isNotEmpty);
      },
    );
  });
}
