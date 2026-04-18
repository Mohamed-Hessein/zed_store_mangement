import 'package:equatable/equatable.dart';
import '../../../order_details/data/models/order_model.dart';

enum OrdersRequestStatus {
  init,
  loading,
  success,
  error,
}
class OrdersState extends Equatable {
  final List<OrderModel>? orders;
  final OrdersRequestStatus status;
  final String? errorMessage;

  final int currentPage;
  final bool hasMore;
  final bool isPaginating;

  const OrdersState({
    this.orders,
    this.status = OrdersRequestStatus.init,
    this.errorMessage,
    this.currentPage = 1,
    this.hasMore = true,
    this.isPaginating = false,
  });

  OrdersState copyWith({
    List<OrderModel>? orders,
    OrdersRequestStatus? status,
    String? errorMessage,
    int? currentPage,
    bool? hasMore,
    bool? isPaginating,
  }) {
    return OrdersState(
      orders: orders ?? this.orders,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isPaginating: isPaginating ?? this.isPaginating,
    );
  }
  @override
  List<Object?> get props => [orders, status, errorMessage, currentPage, hasMore, isPaginating];
}
