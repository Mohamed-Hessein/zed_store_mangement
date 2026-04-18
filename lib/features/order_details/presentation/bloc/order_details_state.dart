import 'package:equatable/equatable.dart';
import '../../domain/entities/order_entity.dart';

abstract class OrderDetailsState extends Equatable {
  const OrderDetailsState();

  @override
  List<Object?> get props => [];
}

class OrderDetailsInitial extends OrderDetailsState {
  const OrderDetailsInitial();
}

class OrderDetailsLoading extends OrderDetailsState {
  const OrderDetailsLoading();
}

class OrderDetailsSuccess extends OrderDetailsState {
  final OrderEntity order;

  const OrderDetailsSuccess(this.order);

  @override
  List<Object?> get props => [order];
}

class OrderDetailsError extends OrderDetailsState {
  final String message;

  const OrderDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}

class OrderStatusUpdating extends OrderDetailsState {
  final OrderEntity order;

  const OrderStatusUpdating(this.order);

  @override
  List<Object?> get props => [order];
}

class OrderStatusUpdated extends OrderDetailsState {
  final OrderEntity updatedOrder;

  const OrderStatusUpdated(this.updatedOrder);

  @override
  List<Object?> get props => [updatedOrder];
}


class OrderDetailsBulkSuccess extends OrderDetailsState {
  final List<String> updatedIds;
  const OrderDetailsBulkSuccess(this.updatedIds);

  @override
  List<Object?> get props => [updatedIds];
}
