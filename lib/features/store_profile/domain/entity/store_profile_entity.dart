class StoreProfileEntity {
  final String storeName;
  final String storeId;
  final String storeImageUrl;
  final String rating;
  final String verificationStatus;
  final int totalProducts;
  final dynamic totalSales;
final dynamic  totalRevenue;
  const StoreProfileEntity({
    required this.storeName,
    required this.storeId,
    required this.totalRevenue,
    required this.storeImageUrl,
    required this.rating,
    required this.verificationStatus,
    required this.totalProducts,
    required this.totalSales,
  });
}

