import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_nepal/core/error/failures.dart';
import 'package:goal_nepal/core/usecase/usecase_with_params.dart';
import 'package:goal_nepal/features/auth/data/repositories/auth_repository.dart';
import 'package:goal_nepal/features/auth/domain/entities/auth_entity.dart';
import 'package:goal_nepal/features/auth/domain/repositories/auth_repository.dart';

class RegisterUsecaseParams extends Equatable {
  final String fullname;
  final String email;
  final String password;

  const RegisterUsecaseParams({
    required this.fullname,
    required this.email,
    required this.password,
  });
  @override
  List<Object?> get props => [email, fullname, password];
}

//provider
final registerUsecaseProvider = Provider<RegisterUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return RegisterUsecase(authRepository: authRepository);
});

class RegisterUsecase
    implements UsecaseWithParams<bool, RegisterUsecaseParams> {
  final IAuthRepository _authRepository;

  RegisterUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call(RegisterUsecaseParams params) {
    final entity = AuthEntity(
      fullName: params.fullname,
      email: params.email,
      password: params.password,
    );
    return _authRepository.register(entity);
  }
}
