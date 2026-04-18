import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/orders_repository.dart';
import '../datasources/orders_remote_data_source.dart';
@Injectable(as:OrdersRepository)
class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSource remoteDataSource;

  OrdersRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, OrderEntity>> getOrderDetails(String orderId) async {
    try {
      final orderModel = await remoteDataSource.getOrderDetails(orderId);
      return Right(orderModel);
    } catch (e) {
      return Left(ServerFailure( e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateOrderStatus(String orderId, String status) async {
    try {
      await remoteDataSource.updateOrderStatus(orderId, status);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure( e.toString()));
    }
  }
}

