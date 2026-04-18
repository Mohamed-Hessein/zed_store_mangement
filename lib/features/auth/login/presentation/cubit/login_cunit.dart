import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/api/constants_api_manager.dart';
import '../../../../../core/api/prefs_helper.dart';
import '../../domain/usecase/login_usecase.dart';
import 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final LoginUsecase loginUsecase;
  final PrefsHelper prefsHelper;
  LoginCubit(this.loginUsecase, this.prefsHelper) : super(LoginState());
  Future<void> login({required String code}) async {
    try {
      emit(LoginLoading());
      final result = await loginUsecase.call(code: code);

      if (result.statusCode == 200) {
        final data = result.data;
        final String accessToken = data['access_token'];
        final String managerToken = data['authorization'];


        final storeResponse = await loginUsecase.getStoreProfile(managerToken, accessToken);




        String? realStoreId;

        try {
          if (storeResponse is Map<String, dynamic>) {

            if (storeResponse['user'] != null && storeResponse['user']['store'] != null) {
              realStoreId = storeResponse['user']['store']['id']?.toString();
            }

            else if (storeResponse['store'] != null) {
              realStoreId = storeResponse['store']['id']?.toString();
            }
          }
        } catch (e) {
          print("❌ Error extracting Store ID: $e");
        }

        print("DEBUG: Final Store ID extracted -> $realStoreId");
        print("DEBUG: Final Store ID -> $realStoreId");

        print("DEBUG: Final Store ID -> $realStoreId");

        print("DEBUG: Extracted Store ID is -> $realStoreId");



        await prefsHelper.saveUserData(
          accessToken: accessToken,
          managerToken: managerToken,
          storeId: realStoreId ?? '',
        );

        print("✅ Data Saved Successfully with Store-Id: ${realStoreId ?? 'EMPTY'}");

        emit(LoginSucess(code));
      } else {
        emit(LoginError("خطأ من السيرفر: ${result.statusMessage}"));
      }
    } catch (e) {
      print("❌ Login Error Details: $e");
      emit(LoginError("فشل تسجيل الدخول: $e"));
    }
  }  Future<void> startZidAuth() async {
    final Uri authUri = Uri.parse(
        "https://oauth.zid.sa/oauth/authorize?client_id=${AppConstants.clientId}&redirect_uri=${AppConstants.redirectUri}&response_type=code"
    );
    if (await canLaunchUrl(authUri)) {
      await launchUrl(authUri, mode: LaunchMode.externalApplication);
    } else {
      emit(LoginError("تعذر فتح المتصفح"));
    }
  }
}
