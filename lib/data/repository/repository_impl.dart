import 'package:dartz/dartz.dart';
import 'package:ecommerce_mvvm/data/data_source/remote_data_source.dart';
import 'package:ecommerce_mvvm/data/mapper/mapper.dart';
import 'package:ecommerce_mvvm/data/network/error_handler.dart';
import 'package:ecommerce_mvvm/data/network/failure.dart';
import 'package:ecommerce_mvvm/data/network/network_info.dart';
import 'package:ecommerce_mvvm/data/network/requests.dart';
import 'package:ecommerce_mvvm/domain/model/models.dart';
import 'package:ecommerce_mvvm/domain/repository/repository.dart';

import '../data_source/local_data_source.dart';

class RepositoryImpl implements Repository {
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;
  RepositoryImpl(
      this._remoteDataSource, this._networkInfo, this._localDataSource);
  @override
  Future<Either<Failure, Authentication>> login(
      LoginRequest loginRequest) async {
    if (await _networkInfo.isConnected) {
      final response = await _remoteDataSource.login(loginRequest);

      try {
        if (response.status == ApiInternalStatus.SUCCESS) {
          //success

          return Right(response.toDomain());
        } else {
          //failure

          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, Authentication>> register(
      RegisterRequest registerRequest) async {
    if (await _networkInfo.isConnected) {
      final response = await _remoteDataSource.register(registerRequest);

      try {
        if (response.status == ApiInternalStatus.SUCCESS) {
          //success

          return Right(response.toDomain());
        } else {
          //failure

          return Left(Failure(ApiInternalStatus.FAILURE,
              response.message ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, HomeObject>> getHomeData() async {
    try {
      final response = await _localDataSource.getHomeData();

      return Right(response.toDomain());
    } catch (cacheError) {
      if (await _networkInfo.isConnected) {
        final response = await _remoteDataSource.getHomeData();

        try {
          if (response.status == ApiInternalStatus.SUCCESS) {
            //success
            _localDataSource.saveHomeToCache(response);
            return Right(response.toDomain());
          } else {
            //failure

            return Left(Failure(ApiInternalStatus.FAILURE,
                response.message ?? ResponseMessage.DEFAULT));
          }
        } catch (error) {
          return Left(ErrorHandler.handle(error).failure);
        }
      } else {
        return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
      }
    }
  }
}
