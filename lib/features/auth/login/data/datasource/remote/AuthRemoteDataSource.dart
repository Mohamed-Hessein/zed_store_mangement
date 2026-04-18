import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:zed_store_mangent/core/api/api_manager.dart';

import '../../../../../../core/api/prefs_helper.dart';
import '../../model/SubscriptionModel.dart';

abstract class AuthRemoteDataSource {
  Future<SubscriptionModel> getSubscriptionDetails();
}@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiManager api;
  final PrefsHelper prefsHelper;

  AuthRemoteDataSourceImpl(this.api, this.prefsHelper);

  @override
  Future<SubscriptionModel> getSubscriptionDetails() async {

    final accessToken = prefsHelper.getAccessToken(); // التوكن الأساسي
    final managerToken = prefsHelper.getManagerToken(); // توكن المدير
    final storeId = prefsHelper.getStoreId();

    final response = await api.get(
      'https://api.zid.sa/v1/market/app/subscription',
      headers: {
        'Authorization': 'Bearer $accessToken',
        'X-MANAGER-TOKEN': managerToken,
        'Store-Id': storeId.toString(),
        'app_id': '6231',
        'Accept-Language': 'ar',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200 && response.data['subscription'] != null) {

      var model = SubscriptionModel.fromJson(response.data['subscription']);

      /* 🚨 تعديل الشروط (Logic Override):
         بما أن متجرك التجريبي حالته 'suspend'، والـ Splash بترميك بره،
         هنعدل الـ Model داخلياً "فقط في حالة الـ suspend" عشان نعتبرها Active مؤقتاً.
      */

      if (model.status == 'suspend') {


        model = model.copyWith(status: 'active');
      }

      return model;
    } else {
      throw Exception("فشل في جلب بيانات الاشتراك");
    }
  }
}
