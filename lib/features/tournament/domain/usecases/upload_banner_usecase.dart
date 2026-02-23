import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_nepal/core/error/failures.dart';
import 'package:goal_nepal/core/usecase/app_usecase.dart';
import 'package:goal_nepal/features/tournament/data/repositories/tournament_repository.dart';
import 'package:goal_nepal/features/tournament/domain/repositories/tournament_repository.dart';

final uploadBannerUsecaseProvider = Provider<UploadBannerUsecase>((ref) {
  final repository = ref.read(tournamentRepositoryProvider);
  return UploadBannerUsecase(repository: repository);
});

class UploadBannerUsecase implements UsecaseWithParms<String, File> {
  final ITournamentRepository _repository;

  UploadBannerUsecase({required ITournamentRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, String>> call(File banner) {
    return _repository.uploadBanner(banner);
  }
}
