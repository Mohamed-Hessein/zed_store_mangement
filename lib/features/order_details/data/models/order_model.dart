import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import '../../domain/entities/order_entity.dart';
import 'customer_model.dart';
import 'order_item_model.dart';
import 'shipping_address_model.dart';

@HiveType(typeId: 10)
class OrderModel extends OrderEntity {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String transactionId;
  @HiveField(2)
  final CustomerModel customer;
  @HiveField(3)
  final List<OrderItemModel> items;
  @HiveField(4)
  final ShippingAddressModel shippingAddress;
  @HiveField(5)
  final String status;
  @HiveField(6)
  final double subtotal;
  @HiveField(7)
  final double shippingCost;
  @HiveField(8)
  final double vatAmount;
  @HiveField(9)
  final double grandTotal;
  @HiveField(10)
  final String paymentMethod;
  @HiveField(11)
  final DateTime createdAt;
  @HiveField(12)
  final DateTime? updatedAt;

  OrderModel({
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
  }) : super(
    id: id,
    transactionId: transactionId,
    customer: customer,
    items: items,
    shippingAddress: shippingAddress,
    status: status,
    subtotal: subtotal,
    shippingCost: shippingCost,
    vatAmount: vatAmount,
    grandTotal: grandTotal,
    paymentMethod: paymentMethod,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  String get code => transactionId;

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

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id']?.toString() ?? '',
      transactionId: (json['code'] ?? json['id'])?.toString() ?? '',
      customer: CustomerModel.fromJson(json['customer'] ?? {}),
      items: (json['products'] as List?)?.map((i) => OrderItemModel.fromJson(i)).toList() ?? [],
      shippingAddress: ShippingAddressModel.fromJson(json['shipping']?['address'] ?? {}),
      status: json['order_status']?['name'] ?? 'pending',
      subtotal: double.tryParse(json['order_total']?.toString() ?? '0') ?? 0.0,
      shippingCost: 0.0,
      vatAmount: 0.0,
      grandTotal: double.tryParse(json['order_total']?.toString() ?? '0') ?? 0.0,
      paymentMethod: json['payment']?['method']?['name'] ?? 'N/A',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  @override
  OrderModel copyWith({
    String? id,
    String? transactionId,
    covariant CustomerModel? customer,
    covariant List<OrderItemModel>? items,
    covariant ShippingAddressModel? shippingAddress,
    String? status,
    double? subtotal,
    double? shippingCost,
    double? vatAmount,
    double? grandTotal,
    String? paymentMethod,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderModel(
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
}
