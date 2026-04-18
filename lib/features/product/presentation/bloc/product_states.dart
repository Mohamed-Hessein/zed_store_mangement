import 'package:equatable/equatable.dart';
import '../../data/model/product_model.dart';
import '../../../home/data/model/order_model.dart'; 

enum ProductRequestStatus {
  init,
  loading,
  success,
  error,
  updating,
  updateSuccess,
  updateError,
}

class ProductState extends Equatable {
  final ProductResponse? products;
  final ProductRequestStatus status;
  final String? errorMessage;
  final String? changeNotifier;
  final List<OrderModel>? orders; 

  final int currentPage;
  final bool hasMore;
  final bool isPaginating;

  const ProductState({
    this.products,
    this.status = ProductRequestStatus.init,
    this.errorMessage,
    this.changeNotifier,
    this.orders,
    this.currentPage = 1,
    this.hasMore = true,
    this.isPaginating = false,
  });

  ProductState copyWith({
    ProductResponse? products,
    ProductRequestStatus? status,
    String? errorMessage,
    String? changeNotifier,
    List<OrderModel>? orders, 
    int? currentPage,
    bool? hasMore,
    bool? isPaginating,
  }) {
    return ProductState(
      products: products ?? this.products,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      changeNotifier: changeNotifier ?? this.changeNotifier,
      orders: orders ?? this.orders,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isPaginating: isPaginating ?? this.isPaginating,
    );
  }

  @override
  List<Object?> get props => [
    products,
    status,
    errorMessage,
    changeNotifier,
    orders,
    currentPage,
    hasMore,
    isPaginating,
  ];
}
