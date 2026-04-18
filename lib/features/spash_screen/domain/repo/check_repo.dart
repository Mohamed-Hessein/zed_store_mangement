import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';

abstract class CheckRepo {
  Future<Either<Failure, bool>> checkSubscriptionFromServer();
}
