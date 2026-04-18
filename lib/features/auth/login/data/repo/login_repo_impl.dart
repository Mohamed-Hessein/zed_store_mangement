import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:zed_store_mangent/features/auth/login/data/datasource/remote/login_ds.dart';
import 'package:zed_store_mangent/features/auth/login/domain/repo/login_repo.dart';
@Injectable(
  as: LoginRepo
)
class LoginRepoImpl implements LoginRepo {
  LoginDs loginDs;
  LoginRepoImpl(this.loginDs);

  @override
  Future<Response> logIn({required String code}) async {
    return await loginDs.exchangeCodeForTokens(code: code);
  }


  @override
  Future<Map<String, dynamic>> getStoreProfile(String accessToken, String managerToken) async {
    return await loginDs.fetchStoreProfile(accessToken, managerToken);
  }
}
