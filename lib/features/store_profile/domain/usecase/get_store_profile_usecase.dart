
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:zed_store_mangent/core/error/failures.dart';
import 'package:zed_store_mangent/features/store_profile/domain/entity/store_profile_entity.dart';
import 'package:zed_store_mangent/features/store_profile/domain/repository/store_profile_repository.dart';

@injectable
class GetStoreProfileUseCase {
  final StoreProfileRepository repository;

  GetStoreProfileUseCase(this.repository);

  Future<Either<Failure, StoreProfileEntity>> call() =>
      repository.getStoreProfile();
}

