import 'package:equatable/equatable.dart';

import '../../domain/entities/order_entity.dart';

abstract class OrderDetailsEvent extends Equatable {
  const OrderDetailsEvent();

  @override
  List<Object?> get props => [];
}

class FetchOrderDetailsEvent extends OrderDetailsEvent {
  final String orderId;

  const FetchOrderDetailsEvent(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class UpdateOrderStatusEvent extends OrderDetailsEvent {
  final String orderId;
  final String newStatus;

  const UpdateOrderStatusEvent(this.orderId, this.newStatus);

  @override
  List<Object?> get props => [orderId, newStatus];
}
class UpdateMultipleOrdersStatusEvent extends OrderDetailsEvent {
  final List<OrderEntity> orders; 
  final List<String> orderIds;
  final String newStatus;

  const UpdateMultipleOrdersStatusEvent({
    required this.orders, 
    required this.orderIds,
    required this.newStatus
  });

  @override
  List<Object?> get props => [orders, orderIds, newStatus];
}
