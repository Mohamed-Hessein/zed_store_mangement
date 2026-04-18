import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../order_details/data/models/order_model.dart';
import '../repo/order_repo.dart';
@lazySingleton
class GetOrdersUseCase {
  final OrdersRepository repository;
  GetOrdersUseCase(this.repository);

  Future<Either<Failure, List<OrderModel>>> call(dynamic searchQuery,{int page = 1}) =>
      repository.getOrders(searchQuery,page: page);
}
