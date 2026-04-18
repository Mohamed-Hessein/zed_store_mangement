import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/order_entity.dart';

abstract class OrdersRepository {
  Future<Either<Failure, OrderEntity>> getOrderDetails(String orderId);
  Future<Either<Failure, void>> updateOrderStatus(String orderId, String status);
}

