import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_nepal/core/error/failures.dart';
import 'package:goal_nepal/features/auth/domain/entities/auth_entity.dart';
import 'package:goal_nepal/features/auth/domain/repositories/auth_repository.dart';
import 'package:goal_nepal/features/auth/domain/usecases/register_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late RegisterUsecase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = RegisterUsecase(authRepository: mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(
      const AuthEntity(
        fullName: 'fallback',
        email: 'fallback@example.com',
        password: 'fallback',
      ),
    );
  });

  const tFullName = 'Santosh';
  const tEmail = 'sthasantosh070@gmail.com';
  const tPassword = 'password123';
  const tParams = RegisterUsecaseParams(
    fullname: tFullName,
    email: tEmail,
    password: tPassword,
  );

  group('RegisterUsecase', () {
    test('should return true when registration is successful', () async {
      // Arrange
      when(
        () => mockRepository.register(any()),
      ).thenAnswer((_) async => const Right(true));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Right(true));
      verify(() => mockRepository.register(any())).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should pass AuthEntity with correct data to repository', () async {
      // Arrange
      AuthEntity? capturedEntity;
      when(() => mockRepository.register(any())).thenAnswer((invocation) {
        capturedEntity = invocation.positionalArguments[0] as AuthEntity;
        return Future.value(const Right(true));
      });

      // Act
      await usecase(tParams);

      // Assert
      expect(capturedEntity, isNotNull);
      expect(capturedEntity?.fullName, tFullName);
      expect(capturedEntity?.email, tEmail);
      expect(capturedEntity?.password, tPassword);
    });

    test('should return ValidationFailure when email is invalid', () async {
      // Arrange
      const tInvalidParams = RegisterUsecaseParams(
        fullname: tFullName,
        email: 'invalid-email',
        password: tPassword,
      );

      // Act
      final result = await usecase(tInvalidParams);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect((failure as ValidationFailure).message, 'Invalid email address');
      }, (_) => fail('Should return ValidationFailure'));
      verifyNever(() => mockRepository.register(any()));
    });

    test('should return ValidationFailure when email is empty', () async {
      // Arrange
      const tInvalidParams = RegisterUsecaseParams(
        fullname: tFullName,
        email: '',
        password: tPassword,
      );

      // Act
      final result = await usecase(tInvalidParams);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect((failure as ValidationFailure).message, 'Invalid email address');
      }, (_) => fail('Should return ValidationFailure'));
      verifyNever(() => mockRepository.register(any()));
    });

    test(
      'should return ValidationFailure when email format is wrong',
      () async {
        // Arrange
        const tInvalidParams = RegisterUsecaseParams(
          fullname: tFullName,
          email: 'test@',
          password: tPassword,
        );

        // Act
        final result = await usecase(tInvalidParams);

        // Assert
        expect(result.isLeft(), true);
        result.fold((failure) {
          expect(failure, isA<ValidationFailure>());
        }, (_) => fail('Should return ValidationFailure'));
        verifyNever(() => mockRepository.register(any()));
      },
    );

    test('should return ApiFailure when email already exists', () async {
      // Arrange
      const tFailure = ApiFailure(message: 'Email already exists');
      when(
        () => mockRepository.register(any()),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Left(tFailure));
      verify(() => mockRepository.register(any())).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ApiFailure when registration fails', () async {
      // Arrange
      const tFailure = ApiFailure(
        message: 'Registration failed',
        statusCode: 400,
      );
      when(
        () => mockRepository.register(any()),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Left(tFailure));
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<ApiFailure>());
        expect((failure as ApiFailure).message, 'Registration failed');
        expect(failure.statusCode, 400);
      }, (_) => fail('Should return failure'));
    });

    test(
      'should return NetworkFailure when there is no internet connection',
      () async {
        // Arrange
        const tFailure = NetworkFailure();
        when(
          () => mockRepository.register(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await usecase(tParams);

        // Assert
        expect(result, const Left(tFailure));
        verify(() => mockRepository.register(any())).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should return LocalDatabaseFailure when offline registration fails',
      () async {
        // Arrange
        const tFailure = LocalDatabaseFailure(
          message: 'Failed to save user locally',
        );
        when(
          () => mockRepository.register(any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await usecase(tParams);

        // Assert
        expect(result, const Left(tFailure));
        verify(() => mockRepository.register(any())).called(1);
      },
    );

    test('should call repository only once for valid data', () async {
      // Arrange
      when(
        () => mockRepository.register(any()),
      ).thenAnswer((_) async => const Right(true));

      // Act
      await usecase(tParams);

      // Assert
      verify(() => mockRepository.register(any())).called(1);
    });

    test('should not call repository if email validation fails', () async {
      // Arrange
      const tInvalidParams = RegisterUsecaseParams(
        fullname: tFullName,
        email: 'invalid',
        password: tPassword,
      );

      // Act
      await usecase(tInvalidParams);

      // Assert
      verifyNever(() => mockRepository.register(any()));
    });

    test('should handle registration with all valid fields', () async {
      // Arrange
      const tCompleteParams = RegisterUsecaseParams(
        fullname: 'Santosh Shrestha',
        email: 'sthasantosh070@gmail.com',
        password: 'SecurePass123!',
      );
      when(
        () => mockRepository.register(any()),
      ).thenAnswer((_) async => const Right(true));

      // Act
      final result = await usecase(tCompleteParams);

      // Assert
      expect(result, const Right(true));
      verify(() => mockRepository.register(any())).called(1);
    });
  });

  group('RegisterUsecaseParams', () {
    test('should have correct props', () {
      // Arrange
      const params = RegisterUsecaseParams(
        fullname: tFullName,
        email: tEmail,
        password: tPassword,
      );

      // Assert
      expect(params.props, [tFullName, tEmail, tPassword]);
    });

    test('two params with same values should be equal', () {
      // Arrange
      const params1 = RegisterUsecaseParams(
        fullname: tFullName,
        email: tEmail,
        password: tPassword,
      );
      const params2 = RegisterUsecaseParams(
        fullname: tFullName,
        email: tEmail,
        password: tPassword,
      );

      // Assert
      expect(params1, params2);
    });

    test('two params with different values should not be equal', () {
      // Arrange
      const params1 = RegisterUsecaseParams(
        fullname: tFullName,
        email: tEmail,
        password: tPassword,
      );
      const params2 = RegisterUsecaseParams(
        fullname: 'Different Name',
        email: 'different@example.com',
        password: 'different123',
      );

      // Assert
      expect(params1, isNot(params2));
    });
  });
}
