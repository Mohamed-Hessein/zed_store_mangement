import 'package:dartz/dartz.dart';
import 'package:zed_store_mangent/core/error/failures.dart';
import 'package:zed_store_mangent/features/store_profile/domain/entity/store_profile_entity.dart';

abstract class StoreProfileRepository {
  Future<Either<Failure, StoreProfileEntity>> getStoreProfile();
}

