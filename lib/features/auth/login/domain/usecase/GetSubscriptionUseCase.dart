import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:zed_store_mangent/core/error/failures.dart';

import '../../../../../core/error/failure.dart' hide Failure;
import '../../data/datasource/remote/AuthRepository_subscribe.dart';
import '../subscribe_entity.dart';
@injectable
class GetSubscriptionUseCase {
  final AuthRepository repository;

  GetSubscriptionUseCase(this.repository);

  Future<Either<Failure, SubscriptionEntity>> call() {
    return repository.getSubscriptionDetails();
  }
}
