import 'dart:math';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:zed_store_mangent/features/auth/login/domain/repo/login_repo.dart';
@injectable
class LoginUsecase {
  LoginRepo repo;
  LoginUsecase(this.repo);

  Future<Response> call({required String code}) async {
    return await repo.logIn(code: code);
  }


  Future<Map<String, dynamic>> getStoreProfile(String accessToken, String managerToken) async {
    return await repo.getStoreProfile(accessToken, managerToken);
  }
}
