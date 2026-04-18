import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:zed_store_mangent/features/auth/login/domain/usecase/login_usecase.dart';
import 'package:zed_store_mangent/features/product/data/data_source/product_ds.dart';
import 'package:zed_store_mangent/core/resources/internet_checker.dart';
import 'package:zed_store_mangent/core/error/exception_handler.dart';
import 'package:zed_store_mangent/core/resources/app_strings.dart';
import 'package:zed_store_mangent/di.dart';
import '../../../../core/api/api_manager.dart';
import '../../../../core/api/prefs_helper.dart';
import '../../../../core/resources/hive_helper.dart';
import '../../../spash_screen/domain/usecase/check_usecase.dart';
import '../model/product_model.dart';
import '../model/update_product_request.dart';

@Injectable(as: ProductDs)
class ProductDsImpl implements ProductDs {
  final ApiManager apiManager;
  final LoginUsecase loginUsecase;
  final PrefsHelper _prefsHelper;
  final CheckSubscriptionUseCase checkSubscriptionUseCase;

  ProductDsImpl(this.checkSubscriptionUseCase,this.loginUsecase, this.apiManager, this._prefsHelper);

  @override@override
  Future<ProductResponse> getProducts(dynamic searchQuery, {required int page, required int pageSize}) async {
    try {
      final cleanSearch = (searchQuery?.toString().trim().isEmpty ?? true) ? null : searchQuery;


      if (page == 1 && cleanSearch == null) {
        final cachedResults = await HiveCacheHelper.getData<List<Results>>(
          boxName: HiveCacheHelper.productsBoxName,
          key: 'all_products',
        );


        if (cachedResults != null && cachedResults.isNotEmpty) {
          debugPrint('Returning Cached Data to UI immediately');



          return ProductResponse(results: cachedResults);
        }
      }

      final subResult = await checkSubscriptionUseCase.call();


      bool isAllowed = subResult.fold(
            (failure) => false,
            (success) => success ,
      );

      if (!isAllowed) {
        throw Exception("SUBSCRIPTION_EXPIRED");
      }


      final response = await apiManager.get(
        '/v1/products/',
        headers: {  },
        queryParameters: {
          'page': page,
          if (cleanSearch != null) 'name': cleanSearch,
          'page_size': pageSize
        },
      );

      if (response.data is Map<String, dynamic>) {
        final productRes = ProductResponse.fromJson(response.data as Map<String, dynamic>);


        if (productRes.results != null && page == 1 && cleanSearch == null) {
          await HiveCacheHelper.saveData<List<Results>>(
            boxName: HiveCacheHelper.productsBoxName,
            key: 'all_products',
            value: productRes.results!,
          );
        }

        return productRes;
      } else {
        throw Exception(AppStrings.parseError);
      }
    } catch (e) {
      rethrow;
    }
  }
  @override
  Future<UpdateProductRequest> updateProduct({
    required Results product,
    required dynamic newPrice,
    required dynamic newQuantity,
    required String nameAr,
    required String nameEn,
  }) async {
    final double? oldPrice = product.price;
    final int? oldQuantity = product.quantity;
    final dynamic oldName = product.name;

    try {
      product.price = double.tryParse(newPrice.toString());
      product.quantity = int.tryParse(newQuantity.toString());
      product.name = {'ar': nameAr, 'en': nameEn};

      await HiveCacheHelper.saveData<Results>(
        boxName: HiveCacheHelper.productsBoxName,
        key: product.id,
        value: product,
      );

      final Map<String, dynamic> requestBody = {
        'name': {'ar': nameAr, 'en': nameEn},
        'price': product.price.toString(),
        'quantity': product.quantity,
        'is_infinite': false,
      };

      final response = await apiManager.patch(
        '/v1/products/${product.id}/',
        headers: {
          'Authorization': 'Bearer ${_prefsHelper.getAccessToken()}',
          'X-MANAGER-TOKEN': _prefsHelper.getManagerToken(),
          'Store-Id': '${_prefsHelper.getStoreId()}',
        },
        data: requestBody,
      );

      return UpdateProductRequest.fromJson(response.data);
    } catch (e) {
      product.price = oldPrice;
      product.quantity = oldQuantity;
      product.name = oldName;

      await HiveCacheHelper.saveData<Results>(
        boxName: HiveCacheHelper.productsBoxName,
        key: product.id,
        value: product,
      );
      debugPrint('Update failed, rolled back Hive data: $e');
      rethrow;
    }
  }
}
