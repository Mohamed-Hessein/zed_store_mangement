import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:zed_store_mangent/core/api/prefs_helper.dart';
import 'package:zed_store_mangent/core/error/error_handler.dart'; 

import 'constants_api_manager.dart';

@lazySingleton
class ApiManager {
  late Dio dio;
  final PrefsHelper _prefsHelper;

  ApiManager(this._prefsHelper) {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),

        validateStatus: (status) => status! < 500,
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {

          if (options.path.contains('/oauth/token')) {
            return handler.next(options);
          }

          final accessToken = _prefsHelper.getManagerToken();
          final managerToken = _prefsHelper.getAccessToken();
          final storeId = _prefsHelper.getStoreId();

          options.headers.addAll({
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Accept-Language': 'ar',
            'Currency': 'SAR'
          });

          options.headers['Role'] = 'Manager';

          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
          if (managerToken != null) {
            options.headers['X-MANAGER-TOKEN'] = managerToken;
          }
          if (storeId != null) {
            options.headers['Store-Id'] = storeId.toString();
          }

          return handler.next(options);
        },


        onError: (DioException e, handler) {

          final String friendlyMessage = ErrorHandler.handle(e);


          final customizedException = DioException(
            requestOptions: e.requestOptions,
            response: e.response,
            type: e.type,
            error: friendlyMessage,
          );

          return handler.next(customizedException);
        },
      ),
    );


    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: false,
      responseBody: true,
      error: true,
      compact: true,
    ));
  }


  Future<Response> get(
      String url, {
        String? baseUrl,
        Map<String, dynamic>? queryParameters,
        Map<String, dynamic>? headers,
      }) async {
    String finalUrl = (baseUrl != null) ? '$baseUrl$url' : url;
    final mergedHeaders = {...dio.options.headers, ...?headers};
    return await dio.get(
      finalUrl,
      queryParameters: queryParameters,
      options: Options(headers: mergedHeaders.isNotEmpty ? mergedHeaders : null),
    );
  }


  Future<Response> post(
      String url, {
        String? baseUrl,
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Map<String, dynamic>? headers,
      }) async {
    String finalUrl = (baseUrl != null) ? '$baseUrl$url' : url;
    final mergedHeaders = {...dio.options.headers, ...?headers};
    return await dio.post(
      finalUrl,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: mergedHeaders.isNotEmpty ? mergedHeaders : null),
    );
  }


  Future<Response> patch(
      String url, {
        String? baseUrl,
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Map<String, dynamic>? headers,
      }) async {
    String finalUrl = (baseUrl != null) ? '$baseUrl$url' : url;
    final mergedHeaders = {...dio.options.headers, ...?headers};
    return await dio.patch(
      finalUrl,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: mergedHeaders.isNotEmpty ? mergedHeaders : null),
    );
  }


  Future<Response> delete(
      String url, {
        String? baseUrl,
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Map<String, dynamic>? headers,
      }) async {
    String finalUrl = (baseUrl != null) ? '$baseUrl$url' : url;
    final mergedHeaders = {...dio.options.headers, ...?headers};
    return await dio.delete(
      finalUrl,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: mergedHeaders.isNotEmpty ? mergedHeaders : null),
    );
  }
}
