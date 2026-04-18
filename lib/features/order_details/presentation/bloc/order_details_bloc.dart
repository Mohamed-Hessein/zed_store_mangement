import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/orders_repository.dart';
import 'order_details_event.dart';
import 'order_details_state.dart';

@injectable
class OrderDetailsBloc extends Bloc<OrderDetailsEvent, OrderDetailsState> {
  final OrdersRepository repository;

  OrderDetailsBloc({required this.repository}) : super(const OrderDetailsInitial()) {
    on<FetchOrderDetailsEvent>(_onFetchOrderDetails);
    on<UpdateOrderStatusEvent>(_onUpdateOrderStatus);
    on<UpdateMultipleOrdersStatusEvent>(_onUpdateMultipleOrders);
  }


  Future<void> _onUpdateMultipleOrders(
      UpdateMultipleOrdersStatusEvent event,
      Emitter<OrderDetailsState> emit,
      ) async {
    final List<OrderEntity> validOrders = event.orders.where((order) {
      return _canUpdateStatus(currentStatus: order.status, newStatus: event.newStatus);
    }).toList();

    if (validOrders.isEmpty) return;

    final List<String> validIds = validOrders.map((e) => e.id).toList();

    try {
      emit(const OrderDetailsLoading());

      await Future.wait(validIds.map((id) => repository.updateOrderStatus(id, event.newStatus)));
      emit(OrderDetailsBulkSuccess(validIds));
    } catch (e) {
      emit(OrderDetailsError("حدث خطأ أثناء التحديث الجماعي: ${e.toString()}"));
    }
  }


  Future<void> _onFetchOrderDetails(
      FetchOrderDetailsEvent event,
      Emitter<OrderDetailsState> emit,
      ) async {
    emit(const OrderDetailsLoading());
    final result = await repository.getOrderDetails(event.orderId);
    result.fold(
          (failure) => emit(OrderDetailsError(failure.message)),
          (order) => emit(OrderDetailsSuccess(order)),
    );
  }


  Future<void> _onUpdateOrderStatus(
      UpdateOrderStatusEvent event,
      Emitter<OrderDetailsState> emit,
      ) async {
    final currentState = state;
    OrderEntity? previousOrder;

    if (currentState is OrderDetailsSuccess) {
      previousOrder = currentState.order;
    }

    if (previousOrder != null) {
      final optimisticOrder = previousOrder.copyWith(status: event.newStatus);
      emit(OrderDetailsSuccess(optimisticOrder));

      final result = await repository.updateOrderStatus(event.orderId, event.newStatus);
      result.fold(
            (failure) {
          emit(OrderDetailsError(failure.message));
          emit(OrderDetailsSuccess(previousOrder!));
        },
            (_) => emit(OrderDetailsSuccess(optimisticOrder)),
      );
    }
  }

  bool _canUpdateStatus({required String currentStatus, required String newStatus}) {
    return currentStatus.toLowerCase().trim() != newStatus.toLowerCase().trim();
  }
}
