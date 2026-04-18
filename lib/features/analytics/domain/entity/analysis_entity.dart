import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';




@HiveType(typeId: 20)
class AnalysisEntity extends Equatable {
  @HiveField(0)
  final double totalValue;
  @HiveField(1)
  final int totalStockCount;
  @HiveField(2)
  final int outOfStockCount;
  @HiveField(3)
  final List<StockLevelItem> stockLevels;
  @HiveField(4)
  final StockDistribution stockDistribution;

  const AnalysisEntity({
    required this.totalValue,
    required this.totalStockCount,
    required this.outOfStockCount,
    required this.stockLevels,
    required this.stockDistribution,
  });

  @override
  List<Object?> get props => [
    totalValue,
    totalStockCount,
    outOfStockCount,
    stockLevels,
    stockDistribution,
  ];
}

@HiveType(typeId: 21)
class StockLevelItem extends Equatable {
  @HiveField(0)
  final String productName;
  @HiveField(1)
  final int quantity;
  @HiveField(2)
  final double price;
  @HiveField(3)
  final String sku;

  const StockLevelItem({
    required this.productName,
    required this.quantity,
    required this.price,
    required this.sku,
  });

  @override
  List<Object?> get props => [productName, quantity, price, sku];
}

@HiveType(typeId: 22)
class StockDistribution extends Equatable {
  @HiveField(0)
  final int healthyCount;
  @HiveField(1)
  final int lowStockCount;
  @HiveField(2)
  final int outOfStockCount;

  const StockDistribution({
    required this.healthyCount,
    required this.lowStockCount,
    required this.outOfStockCount,
  });


  int get totalItems => healthyCount + lowStockCount + outOfStockCount;

  @override
  List<Object?> get props => [healthyCount, lowStockCount, outOfStockCount];
}


enum TimeRange {
  daily,
  weekly,
  monthly,
  custom,
}
