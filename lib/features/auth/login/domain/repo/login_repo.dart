import 'package:dio/dio.dart';

abstract class LoginRepo {
  Future<Response>logIn({required String code});
  Future<Map<String, dynamic>> getStoreProfile(String accessToken, String managerToken);

}
