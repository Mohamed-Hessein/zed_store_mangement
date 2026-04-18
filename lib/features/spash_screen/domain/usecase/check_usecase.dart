import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure.dart';
import '../../../auth/login/data/datasource/remote/AuthRepository_subscribe.dart';
import '../repo/check_repo.dart';

@lazySingleton
class CheckSubscriptionUseCase {
  final CheckRepo repository;

  CheckSubscriptionUseCase(this.repository);

  Future<Either<Failure, bool>> call() async {


    return await repository.checkSubscriptionFromServer();
  }
}
