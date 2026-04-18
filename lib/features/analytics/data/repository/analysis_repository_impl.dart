import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:zed_store_mangent/core/error/failure.dart';
import 'package:zed_store_mangent/features/analytics/data/datasource/analysis_datasource.dart';
import 'package:zed_store_mangent/features/analytics/domain/entity/analysis_entity.dart';
import 'package:zed_store_mangent/features/analytics/domain/repository/analysis_repository.dart';

@LazySingleton(as: AnalysisRepository)
class AnalysisRepositoryImpl implements AnalysisRepository {
  final AnalysisDataSource dataSource;

  AnalysisRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, AnalysisEntity>> getAnalyticsData(TimeRange timeRange) async {
    try {
      final productResponse = await dataSource.fetchAllProducts();
      final products = productResponse.results ?? [];

      double totalValue = 0;
      int totalStock = 0;
      int outOfStock = 0;
      int healthyCount = 0;
      int lowStockCount = 0;
      List<StockLevelItem> topItems = [];

      for (var product in products) {
        final price = product.price ?? 0.0;
        final quantity = product.quantity ?? 0;
        
        totalValue += price * quantity;
        totalStock += quantity;

        if (quantity == 0) {
          outOfStock++;
        } else if (quantity > 10) {
          healthyCount++;
        } else if (quantity > 0) {
          lowStockCount++;
        }

        topItems.add(StockLevelItem(
          productName: _getProductName(product.name),
          quantity: quantity,
          price: price,
          sku: product.sku ?? 'N/A',
        ));
      }

      topItems.sort((a, b) => b.quantity.compareTo(a.quantity));
      topItems = topItems.take(5).toList();

      final analysis = AnalysisEntity(
        totalValue: totalValue,
        totalStockCount: totalStock,
        outOfStockCount: outOfStock,
        stockLevels: topItems,
        stockDistribution: StockDistribution(
          healthyCount: healthyCount,
          lowStockCount: lowStockCount,
          outOfStockCount: outOfStock,
        ),
      );

      return Right(analysis);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  String _getProductName(dynamic name) {
    if (name == null) return 'Unknown Product';
    if (name is Map) {
      return name['ar'] ?? name['en'] ?? 'Unknown Product';
    }
    return name.toString();
  }
}

