import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../order_details/data/models/order_model.dart';

abstract class OrdersRepository {
  Future<Either<Failure, List<OrderModel>>> getOrders(dynamic searchQuery,{int page = 1});}
