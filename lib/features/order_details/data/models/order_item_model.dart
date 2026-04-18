import 'package:hive/hive.dart';
import '../../domain/entities/order_item_entity.dart';

@HiveType(typeId: 12)
class OrderItemModel extends OrderItemEntity {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String productName;
  @HiveField(2)
  final double price;
  @HiveField(3)
  final int quantity;
  @HiveField(4)
  final String? imageUrl;

  OrderItemModel({
    required this.id,
    required this.productName,
    required this.price,
    required this.quantity,
    this.imageUrl,
  }) : super(
    id: id,
    productName: productName,
    price: price,
    quantity: quantity,
    imageUrl: imageUrl,
  );

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id']?.toString() ?? '',
      productName: json['name']?.toString() ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      quantity: int.tryParse(json['quantity']?.toString() ?? '1') ?? 1,
      imageUrl: (json['images'] != null && (json['images'] as List).isNotEmpty)
          ? json['images'][0]['origin']?.toString()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_name': productName,
      'price': price,
      'quantity': quantity,
      'image_url': imageUrl,
    };
  }
}
