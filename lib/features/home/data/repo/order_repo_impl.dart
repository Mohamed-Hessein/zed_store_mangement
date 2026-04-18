
import 'package:dartz/dartz.dart' show Either, Right, Left;
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../domian/repo/order_repo.dart';
import '../data_source/order_ds.dart';
import '../../../order_details/data/models/order_model.dart';
@Injectable(as:OrdersRepository )
class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSource remoteDataSource;
  OrdersRepositoryImpl(this.remoteDataSource);
  @override
  Future<Either<Failure, List<OrderModel>>> getOrders(dynamic searchQuery,{int page = 1}) async {
    try {
      final orders = await remoteDataSource.getOrders(searchQuery,page: page);
      return Right(orders);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
