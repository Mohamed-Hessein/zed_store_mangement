class UpdateProductRequest {
  final dynamic? price;
  final dynamic? quantity;
  final dynamic? isActive;

  final dynamic name;

  UpdateProductRequest({this.price, this.quantity, this.isActive, this.name});

  factory UpdateProductRequest.fromJson(Map<String, dynamic> json) {

    var priceData = json['price'];

    return UpdateProductRequest(
      price: priceData != null ? double.tryParse(priceData.toString()) : null,
      quantity: json['quantity'] as int?,
      isActive: json['is_active'] as bool?,
      name: json['name'], 
    );
  }
}
