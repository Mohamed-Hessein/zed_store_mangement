import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:zed_store_mangent/core/api/api_manager.dart';
import 'package:zed_store_mangent/core/api/prefs_helper.dart';
import 'package:zed_store_mangent/core/resources/hive_helper.dart';

import '../models/order_model.dart' show OrderModel;
import 'orders_remote_data_source.dart';
@Injectable(as: OrdersRemoteDataSource)
class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  final ApiManager apiManager;
  final PrefsHelper _prefsHelper;

  OrdersRemoteDataSourceImpl(this._prefsHelper, {required this.apiManager});

  Map<String, String> _getHeaders() => {
    'Authorization': 'Bearer ${_prefsHelper.getAccessToken()}',
    'X-MANAGER-TOKEN': _prefsHelper.getManagerToken()!,
    'Accept-Language': 'ar',
    'Content-Type': 'application/json',
  };

  @override
  Future<OrderModel> getOrderDetails(String orderId) async {
    try {
      final response = await apiManager.get(
        '/v1/managers/store/orders/$orderId/view',
        headers: _getHeaders(),
      );

      if (response.data != null && response.data['order'] != null) {
        final order = OrderModel.fromJson(response.data['order']);
        await HiveCacheHelper.saveData<OrderModel>(
          boxName: HiveCacheHelper.ordersBoxName,
          key: orderId,
          value: order,
        );
        return order;
      }
      throw Exception('بيانات الطلب غير موجودة');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateOrderStatus(String orderId, String status) async {
    final response = await apiManager.post(
      '/v1/managers/store/orders/$orderId/change-order-status',
      data: {'order_status': status},
      headers: {
        'Authorization': 'Bearer ${_prefsHelper.getAccessToken()}',
        'X-MANAGER-TOKEN': _prefsHelper.getManagerToken()!,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {

      await _updateLocalCache(orderId, status);
    }
  }

  Future<void> _updateLocalCache(String orderId, String newStatus) async {

    final allOrders = await HiveCacheHelper.getData<dynamic>(
      boxName: HiveCacheHelper.ordersBoxName,
      key: 'all_orders',
    );

    if (allOrders is List) {
      final List<OrderModel> updatedList = allOrders.cast<OrderModel>().map((order) {
        if (order.id == orderId || order.transactionId == orderId) {
          return order.copyWith(status: newStatus);
        }
        return order;
      }).toList();

      await HiveCacheHelper.saveData(
        boxName: HiveCacheHelper.ordersBoxName,
        key: 'all_orders',
        value: updatedList,
      );
      debugPrint("✅ تم تحديث كاش الهوم من صفحة التفاصيل");
    }
  }
}

  String _handleDioError(DioException e) {
    if (e.response?.statusCode == 500) return "خطأ داخلي في سيرفر زد (500)";
    if (e.type == DioExceptionType.connectionTimeout) return "انتهى وقت الاتصال";
    return e.response?.data?['message']?['description'] ?? "حدث خطأ غير متوقع";

} 
