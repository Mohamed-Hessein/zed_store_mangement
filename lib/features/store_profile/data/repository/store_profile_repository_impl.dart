import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:zed_store_mangent/core/error/failures.dart';
import 'package:zed_store_mangent/features/store_profile/data/datasource/store_profile_remote_datasource.dart';
import 'package:zed_store_mangent/features/store_profile/domain/entity/store_profile_entity.dart';
import 'package:zed_store_mangent/features/store_profile/domain/repository/store_profile_repository.dart';

@LazySingleton(as: StoreProfileRepository)
class StoreProfileRepositoryImpl implements StoreProfileRepository {
  final StoreProfileRemoteDataSource remoteDataSource;

  StoreProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, StoreProfileEntity>> getStoreProfile() async {
    try {
      final result = await remoteDataSource.getStoreProfile();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

