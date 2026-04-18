import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:zed_store_mangent/core/api/api_manager.dart';
import 'package:zed_store_mangent/features/product/data/model/product_model.dart';

import '../../../../core/api/prefs_helper.dart';
import '../../../spash_screen/domain/usecase/check_usecase.dart';

abstract class AnalysisDataSource {
  Future<ProductResponse> fetchAllProducts();
}

@LazySingleton(as: AnalysisDataSource)
class AnalysisDataSourceImpl implements AnalysisDataSource {
  final ApiManager apiManager;
PrefsHelper _prefsHelper;
  final CheckSubscriptionUseCase checkSubscriptionUseCase;

  AnalysisDataSourceImpl(this.checkSubscriptionUseCase,this._prefsHelper,this.apiManager);

  @override
  Future<ProductResponse> fetchAllProducts() async {
    try {  final subResult = await checkSubscriptionUseCase.call();


    bool isAllowed = subResult.fold(
          (failure) => false,
          (success) => success == true,
    );

    if (!isAllowed) {
      throw Exception("SUBSCRIPTION_EXPIRED");
    }

      final accessToken = _prefsHelper.getManagerToken();
      final managerToken = _prefsHelper.getAccessToken();


      String? storeId = _prefsHelper.getStoreId();

      final response = await apiManager.get('/v1/products/',headers: {
        'Authorization': 'Bearer $accessToken',
        'X-MANAGER-TOKEN': managerToken,
        'Store-Id': '${_prefsHelper.getStoreId()}', 
        'Accept-Language': 'ar',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },);
      if (response.statusCode == 200) {
        return ProductResponse.fromJson(response.data);
      }
      throw Exception('Failed to fetch products');
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    }
  }
}

