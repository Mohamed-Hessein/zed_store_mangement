

import '../models/order_model.dart' show OrderModel;

abstract class OrdersRemoteDataSource {
  Future<OrderModel> getOrderDetails(String orderId);
  Future<void> updateOrderStatus(String orderId, String status);
}

