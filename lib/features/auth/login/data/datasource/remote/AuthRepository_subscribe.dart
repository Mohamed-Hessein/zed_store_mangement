import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../core/error/failure.dart' hide Failure;
import '../../../../../../core/error/failures.dart';
import '../../../domain/subscribe_entity.dart';
import 'AuthRemoteDataSource.dart';

abstract class AuthRepository {
  Future<Either<Failure, SubscriptionEntity>> getSubscriptionDetails();
}
@Injectable(as :AuthRepository )
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, SubscriptionEntity>> getSubscriptionDetails() async {
    try {
      final model = await remoteDataSource.getSubscriptionDetails();
      return Right(model);
    } catch (e) {
      return Left(ServerFailure(e.toString())); 
    }
  }
}
