import 'package:equatable/equatable.dart';
import 'customer_entity.dart';
import 'order_item_entity.dart';
import 'shipping_address_entity.dart';

class OrderEntity extends Equatable {
  final String id;
  final String transactionId;
  final CustomerEntity customer;
  final List<OrderItemEntity> items;
  final ShippingAddressEntity shippingAddress;
  final String status; 
  final double subtotal;
  final double shippingCost;
  final double vatAmount;
  final double grandTotal;
  final String paymentMethod;
  final DateTime createdAt;
  final DateTime? updatedAt;

  OrderEntity({
    required this.id,
    required this.transactionId,
    required this.customer,
    required this.items,
    required this.shippingAddress,
    required this.status,
    required this.subtotal,
    required this.shippingCost,
    required this.vatAmount,
    required this.grandTotal,
    required this.paymentMethod,
    required this.createdAt,
    this.updatedAt,
  });


  OrderEntity copyWith({
    String? id,
    String? transactionId,
    CustomerEntity? customer,
    List<OrderItemEntity>? items,
    ShippingAddressEntity? shippingAddress,
    String? status,
    double? subtotal,
    double? shippingCost,
    double? vatAmount,
    double? grandTotal,
    String? paymentMethod,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderEntity(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      customer: customer ?? this.customer,
      items: items ?? this.items,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      status: status ?? this.status,
      subtotal: subtotal ?? this.subtotal,
      shippingCost: shippingCost ?? this.shippingCost,
      vatAmount: vatAmount ?? this.vatAmount,
      grandTotal: grandTotal ?? this.grandTotal,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    transactionId,
    customer,
    items,
    shippingAddress,
    status,
    subtotal,
    shippingCost,
    vatAmount,
    grandTotal,
    paymentMethod,
    createdAt,
    updatedAt,
  ];
}
