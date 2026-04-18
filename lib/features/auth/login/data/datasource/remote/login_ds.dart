import 'package:dio/dio.dart';
abstract class LoginDs {
  Future<Response> exchangeCodeForTokens({required String code});

  Future<Map<String, dynamic>> fetchStoreProfile(String accessToken, String managerToken);
}
