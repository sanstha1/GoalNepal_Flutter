import 'package:dartz/dartz.dart';
import 'package:goal_nepal/core/error/failures.dart';

/// Generic interface for use cases that accept parameters.
///
/// T is the entity return type. Implementations should return
/// `Future<Either<Failure, T>>` from `call` when executing the use case.
abstract class UsecaseWithParams<T, P> {
  Future<Either<Failure, T>> call(P params);
}
