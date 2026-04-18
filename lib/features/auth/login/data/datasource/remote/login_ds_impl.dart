import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:zed_store_mangent/core/api/api_manager.dart';
import 'package:zed_store_mangent/features/auth/login/data/datasource/remote/login_ds.dart';
import '../../../../../../core/api/prefs_helper.dart';

@Injectable(as: LoginDs)
class LoginDsImpl implements LoginDs {
  final ApiManager api;
  final PrefsHelper prefs;

  LoginDsImpl(this.api, this.prefs);

  @override
  Future<Response<dynamic>> exchangeCodeForTokens({required String code}) async {
    try {

      final String proxyUrl = 'https://zid-backend-vercel.vercel.app/api/exchange-token';

      debugPrint('📡 Sending code to Vercel: $code');

      final response = await api.dio.post(
        proxyUrl,
        data: {
          'code': code, 
        },
      );

      if (response.statusCode == 200) {
        debugPrint('✅ Secure OAuth exchange successful via Vercel');
        return response;
      } else {
        throw Exception('Server error: ${response.statusMessage}');
      }
    } on DioException catch (e) {

      debugPrint('❌ Proxy Error Data: ${e.response?.data}');
      throw Exception(
        e.response?.data['message']?['description'] ?? 'Security proxy failure',
      );
    } catch (e) {
      debugPrint('❌ Unexpected Error: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> fetchStoreProfile(String accessToken, String managerToken) async {
    final response = await api.dio.get(
      'https://api.zid.sa/v1/managers/account/profile',
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
          'X-MANAGER-TOKEN': managerToken,
          'Accept-Language': 'ar',
        },
      ),
    );
    return response.data;
  }
}
