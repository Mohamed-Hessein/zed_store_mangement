import '../../../../core/api/api_manager.dart';
import '../../../../core/api/prefs_helper.dart';
import '../../../order_details/data/models/order_model.dart';

abstract class OrdersRemoteDataSource {

  Future<List<OrderModel>> getOrders(dynamic searchQuery,{int page = 1});
}
