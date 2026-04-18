import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';

import '../../../../core/usecase/usecases.dart';
import '../entities/order_entity.dart';
import '../repositories/orders_repository.dart';
@Injectable(as :UseCase)
class GetOrderDetailsUseCase implements UseCase<OrderEntity, String> {
  final OrdersRepository repository;

  GetOrderDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, OrderEntity>> call(String orderId) async {
    return await repository.getOrderDetails(orderId);
  }
}

