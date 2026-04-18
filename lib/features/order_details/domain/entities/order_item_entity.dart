class OrderItemEntity {
  final String id;
  final String productName;
  final double price;
  final int quantity;
  final String? imageUrl;

  OrderItemEntity({
    required this.id,
    required this.productName,
    required this.price,
    required this.quantity,
    this.imageUrl,
  });
}

