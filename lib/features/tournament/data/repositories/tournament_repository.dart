import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_nepal/core/error/failures.dart';
import 'package:goal_nepal/core/services/connectivity/network_info.dart';
import 'package:goal_nepal/features/tournament/data/datasources/tournament_datasource.dart';
import 'package:goal_nepal/features/tournament/data/datasources/local/tournament_local_datasource.dart';
import 'package:goal_nepal/features/tournament/data/datasources/remote/tournament_remote_datasource.dart';
import 'package:goal_nepal/features/tournament/data/models/tournament_api_model.dart';
import 'package:goal_nepal/features/tournament/data/models/tournament_hive_model.dart';
import 'package:goal_nepal/features/tournament/domain/entities/tournament_entity.dart';
import 'package:goal_nepal/features/tournament/domain/repositories/tournament_repository.dart';

final tournamentRepositoryProvider = Provider<ITournamentRepository>((ref) {
  final localDatasource = ref.read(tournamentLocalDatasourceProvider);
  final remoteDatasource = ref.read(tournamentRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return TournamentRepository(
    localDatasource: localDatasource,
    remoteDatasource: remoteDatasource,
    networkInfo: networkInfo,
  );
});

class TournamentRepository implements ITournamentRepository {
  final ITournamentLocalDataSource _localDataSource;
  final ITournamentRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  TournamentRepository({
    required ITournamentLocalDataSource localDatasource,
    required ITournamentRemoteDataSource remoteDatasource,
    required NetworkInfo networkInfo,
  }) : _localDataSource = localDatasource,
       _remoteDataSource = remoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, String>> uploadBanner(File banner) async {
    if (await _networkInfo.isConnected) {
      try {
        final url = await _remoteDataSource.uploadBanner(banner);
        return Right(url);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> createTournament(
    TournamentEntity tournament, {
    File? bannerFile,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = TournamentApiModel.fromEntity(tournament);
        await _remoteDataSource.createTournament(model, bannerFile: bannerFile);
        return const Right(true);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteTournament(String tournamentId) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.deleteTournament(tournamentId);
        return const Right(true);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final result = await _localDataSource.deleteTournament(tournamentId);
        if (result) return const Right(true);
        return const Left(
          LocalDatabaseFailure(message: 'Failed to delete tournament'),
        );
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<TournamentEntity>>> getAllTournaments() async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getAllTournaments();
        return Right(TournamentApiModel.toEntityList(models));
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final models = await _localDataSource.getAllTournaments();
        return Right(TournamentHiveModel.toEntityList(models));
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, TournamentEntity>> getTournamentById(
    String tournamentId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _remoteDataSource.getTournamentById(tournamentId);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final model = await _localDataSource.getTournamentById(tournamentId);
        if (model != null) return Right(model.toEntity());
        return const Left(
          LocalDatabaseFailure(message: 'Tournament not found'),
        );
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<TournamentEntity>>> getMyTournaments(
    String userId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getMyTournaments();
        return Right(TournamentApiModel.toEntityList(models));
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final models = await _localDataSource.getTournamentsByUser(userId);
        return Right(TournamentHiveModel.toEntityList(models));
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<TournamentEntity>>>
  getFootballTournaments() async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getFootballTournaments();
        return Right(TournamentApiModel.toEntityList(models));
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final models = await _localDataSource.getFootballTournaments();
        return Right(TournamentHiveModel.toEntityList(models));
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<TournamentEntity>>> getFutsalTournaments() async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getFutsalTournaments();
        return Right(TournamentApiModel.toEntityList(models));
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final models = await _localDataSource.getFutsalTournaments();
        return Right(TournamentHiveModel.toEntityList(models));
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> updateTournament(
    TournamentEntity tournament, {
    File? bannerFile,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = TournamentApiModel.fromEntity(tournament);
        await _remoteDataSource.updateTournament(model, bannerFile: bannerFile);
        return const Right(true);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final model = TournamentHiveModel.fromEntity(tournament);
        final result = await _localDataSource.updateTournament(model);
        if (result) return const Right(true);
        return const Left(
          LocalDatabaseFailure(message: 'Failed to update tournament'),
        );
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }
}
