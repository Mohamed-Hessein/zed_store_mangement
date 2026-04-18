import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api/api_manager.dart';
import '../../../../core/api/prefs_helper.dart';
import '../../../../core/resources/hive_helper.dart';
import '../../../order_details/data/models/order_model.dart';
import '../../../spash_screen/domain/usecase/check_usecase.dart';
import 'order_ds.dart';// تأكد من وجود هذا الـ import في أعلى الملف
import 'package:dartz/dartz.dart';

@Injectable(as: OrdersRemoteDataSource)
class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  final ApiManager api;
  final PrefsHelper _prefsHelper;

 final CheckSubscriptionUseCase checkSubscriptionUseCase;

  OrdersRemoteDataSourceImpl(this.api, this._prefsHelper, this.checkSubscriptionUseCase);

  @override
  Future<List<OrderModel>> getOrders(dynamic searchQuery, {int page = 1}) async {
    try {

      final subResult = await checkSubscriptionUseCase.call();


      bool isAllowed = subResult.fold(
            (failure) => false,
            (success) => success == true,
      );

      if (!isAllowed) {
        throw Exception("SUBSCRIPTION_EXPIRED");
      }


      final accessToken = _prefsHelper.getAccessToken();
      final managerToken = _prefsHelper.getManagerToken();
      final storeId = _prefsHelper.getStoreId();

      final response = await api.get(
          'https://api.zid.sa/v1/managers/store/orders',
          headers: {
            'Authorization': 'Bearer $accessToken',
            'X-MANAGER-TOKEN': managerToken,
            'Store-Id': '${storeId.toString()}',
            'Accept-Language': 'ar',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          queryParameters: {
            'page': page,
            'search_term': searchQuery,
            'page_size': 3,
          }
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List? data = response.data['orders'];
        if (data == null) return [];
        final orders = data.map((json) => OrderModel.fromJson(json)).toList();
        await HiveCacheHelper.saveData<List<OrderModel>>(
          boxName: HiveCacheHelper.ordersBoxName,
          key: 'all_orders',
          value: orders,
        );
        return orders;
      } else {
        throw Exception("فشل جلب الطلبات");
      }
    } catch (e) {
      rethrow;
    }
  }
}
