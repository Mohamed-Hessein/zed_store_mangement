import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:zed_store_mangent/core/api/api_manager.dart';
import 'package:zed_store_mangent/features/store_profile/data/model/store_profile_model.dart';

import '../../../spash_screen/domain/usecase/check_usecase.dart';

abstract class StoreProfileRemoteDataSource {
  Future<StoreProfileModel> getStoreProfile();
}
@Injectable(as:StoreProfileRemoteDataSource)
class StoreProfileRemoteDataSourceImpl implements StoreProfileRemoteDataSource {
ApiManager api;
final CheckSubscriptionUseCase checkSubscriptionUseCase;

  StoreProfileRemoteDataSourceImpl(this.api, this.checkSubscriptionUseCase);

  @override
  Future<StoreProfileModel> getStoreProfile() async {
    try {
      final subResult = await checkSubscriptionUseCase.call();


      bool isAllowed = subResult.fold(
            (failure) => false,
            (success) => success == true,
      );

      if (!isAllowed) {
        throw Exception("SUBSCRIPTION_EXPIRED");
      }
      final response = await api.get(
        '/v1/managers/account/profile',
        queryParameters: {
            },
        );
      final productsResponse = await api.get('/v1/products/', queryParameters: {
          'limit': 1,
        });final ordersres = await api.get('/v1/managers/store/orders', queryParameters: {
        'limit': 1,
      });
      final List allOrders = ordersres.data['orders'] ?? [];

      int numberOfOrders = allOrders.length; 
      if (response.statusCode == 200) {
       print(response.data);
       double totalRevenueCalc = 0;
       for (var order in allOrders) {
         totalRevenueCalc += (order['transaction_amount'] ?? 0).toDouble();
       }

       return StoreProfileModel.fromJson(
         response.data,
         productsCount: productsResponse.data['count'],
         totalSales: numberOfOrders,

         totalRevenue: totalRevenueCalc.toStringAsFixed(0),
       );   } else {
        throw Exception('Failed to fetch store profile');
      }
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    } catch (e) {
      throw Exception('Unknown error: $e');
    }
  }
}

