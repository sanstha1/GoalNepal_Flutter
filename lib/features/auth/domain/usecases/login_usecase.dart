import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_nepal/core/error/failures.dart';
import 'package:goal_nepal/core/usecase/usecase_with_params.dart';
import 'package:goal_nepal/features/auth/data/repositories/auth_repository.dart';
import 'package:goal_nepal/features/auth/domain/entities/auth_entity.dart';
import 'package:goal_nepal/features/auth/domain/repositories/auth_repository.dart';
import 'package:goal_nepal/features/auth/domain/validators/email_validator.dart';

class LoginUsecaseParams extends Equatable {
  final String email;
  final String password;

  const LoginUsecaseParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

/// Provider
final loginUsecaseProvider = Provider<LoginUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return LoginUsecase(authRepository: authRepository);
});

class LoginUsecase
    implements UsecaseWithParams<AuthEntity, LoginUsecaseParams> {
  final IAuthRepository _authRepository;

  LoginUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, AuthEntity>> call(LoginUsecaseParams params) async {
    if (!EmailValidator.isValid(params.email)) {
      return const Left<Failure, AuthEntity>(
        ValidationFailure(message: 'Invalid email address'),
      );
    }

    return await _authRepository.login(params.email, params.password);
  }
}
