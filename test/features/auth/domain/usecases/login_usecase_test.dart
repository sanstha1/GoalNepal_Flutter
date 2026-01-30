import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:goal_nepal/core/error/failures.dart';
import 'package:goal_nepal/features/auth/domain/entities/auth_entity.dart';
import 'package:goal_nepal/features/auth/domain/repositories/auth_repository.dart';
import 'package:goal_nepal/features/auth/domain/usecases/login_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late LoginUsecase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = LoginUsecase(authRepository: mockRepository);
  });

  const tEmail = 'sthasantosh070@gmail.com';
  const tPassword = 'password123';
  const tParams = LoginUsecaseParams(email: tEmail, password: tPassword);

  const tAuthEntity = AuthEntity(
    authId: '123',
    fullName: 'Santosh',
    email: tEmail,
    password: tPassword,
  );

  group('LoginUsecase', () {
    test('should return AuthEntity when login is successful', () async {
      // Arrange
      when(
        () => mockRepository.login(any(), any()),
      ).thenAnswer((_) async => const Right(tAuthEntity));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Right(tAuthEntity));
      verify(() => mockRepository.login(tEmail, tPassword)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should pass correct email and password to repository', () async {
      // Arrange
      String? capturedEmail;
      String? capturedPassword;
      when(() => mockRepository.login(any(), any())).thenAnswer((invocation) {
        capturedEmail = invocation.positionalArguments[0] as String;
        capturedPassword = invocation.positionalArguments[1] as String;
        return Future.value(const Right(tAuthEntity));
      });

      // Act
      await usecase(tParams);

      // Assert
      expect(capturedEmail, tEmail);
      expect(capturedPassword, tPassword);
    });

    test('should return ValidationFailure when email is invalid', () async {
      // Arrange
      const tInvalidParams = LoginUsecaseParams(
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
      verifyNever(() => mockRepository.login(any(), any()));
    });

    test('should return ValidationFailure when email is empty', () async {
      // Arrange
      const tInvalidParams = LoginUsecaseParams(email: '', password: tPassword);

      // Act
      final result = await usecase(tInvalidParams);

      // Assert
      expect(result.isLeft(), true);
      result.fold((failure) {
        expect(failure, isA<ValidationFailure>());
        expect((failure as ValidationFailure).message, 'Invalid email address');
      }, (_) => fail('Should return ValidationFailure'));
      verifyNever(() => mockRepository.login(any(), any()));
    });

    test(
      'should return ValidationFailure when email format is wrong',
      () async {
        // Arrange
        const tInvalidParams = LoginUsecaseParams(
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
        verifyNever(() => mockRepository.login(any(), any()));
      },
    );

    test('should return ApiFailure when credentials are invalid', () async {
      // Arrange
      const tFailure = ApiFailure(message: 'Invalid email or password');
      when(
        () => mockRepository.login(any(), any()),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await usecase(tParams);

      // Assert
      expect(result, const Left(tFailure));
      verify(() => mockRepository.login(tEmail, tPassword)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test(
      'should return NetworkFailure when there is no internet connection',
      () async {
        // Arrange
        const tFailure = NetworkFailure();
        when(
          () => mockRepository.login(any(), any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await usecase(tParams);

        // Assert
        expect(result, const Left(tFailure));
        verify(() => mockRepository.login(tEmail, tPassword)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );

    test(
      'should return LocalDatabaseFailure when offline login fails',
      () async {
        // Arrange
        const tFailure = LocalDatabaseFailure(
          message: 'Invalid email or password',
        );
        when(
          () => mockRepository.login(any(), any()),
        ).thenAnswer((_) async => const Left(tFailure));

        // Act
        final result = await usecase(tParams);

        // Assert
        expect(result, const Left(tFailure));
        verify(() => mockRepository.login(tEmail, tPassword)).called(1);
      },
    );

    test('should call repository only once for valid credentials', () async {
      // Arrange
      when(
        () => mockRepository.login(any(), any()),
      ).thenAnswer((_) async => const Right(tAuthEntity));

      // Act
      await usecase(tParams);

      // Assert
      verify(() => mockRepository.login(tEmail, tPassword)).called(1);
    });

    test('should not call repository if email validation fails', () async {
      // Arrange
      const tInvalidParams = LoginUsecaseParams(
        email: 'invalid',
        password: tPassword,
      );

      // Act
      await usecase(tInvalidParams);

      // Assert
      verifyNever(() => mockRepository.login(any(), any()));
    });
  });

  group('LoginUsecaseParams', () {
    test('should have correct props', () {
      // Arrange
      const params = LoginUsecaseParams(email: tEmail, password: tPassword);

      // Assert
      expect(params.props, [tEmail, tPassword]);
    });

    test('two params with same values should be equal', () {
      // Arrange
      const params1 = LoginUsecaseParams(email: tEmail, password: tPassword);
      const params2 = LoginUsecaseParams(email: tEmail, password: tPassword);

      // Assert
      expect(params1, params2);
    });

    test('two params with different values should not be equal', () {
      // Arrange
      const params1 = LoginUsecaseParams(email: tEmail, password: tPassword);
      const params2 = LoginUsecaseParams(
        email: 'different@example.com',
        password: 'different123',
      );

      // Assert
      expect(params1, isNot(params2));
    });
  });
}
