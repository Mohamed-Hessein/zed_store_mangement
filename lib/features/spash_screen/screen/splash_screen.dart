import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:auto_route/auto_route.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zed_store_mangent/core/resources/app_colors.dart';

import '../../../core/api/prefs_helper.dart';
import '../../../core/firebase/fcm.dart';
import '../../../core/resources/auto_route.gr.dart';
import '../../../di.dart';
import '../../auth/login/domain/usecase/GetSubscriptionUseCase.dart';

@RoutePage()
class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();

    _checkAndSendToken();
  }

  Future<void> _checkAndSendToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? lastToken = prefs.getString('last_fcm_token');

      final prefsHelper = getIt<PrefsHelper>();
      String? storeId = prefsHelper.getStoreId();
      String? currentToken = await FirebaseMessaging.instance.getToken();

      if (currentToken != null && currentToken != lastToken && storeId != null) {
        bool success = await sendTokenToServer(currentToken, storeId);
        if (success) {
          await prefs.setString('last_fcm_token', currentToken);
        }
      }
    } catch (e) {
      debugPrint("❌ FCM Token Check Error: $e");
    }
  }

  Future<bool> sendTokenToServer(String token, String storeId) async {
    try {
      const String url = "https://zid-backend-vercel.vercel.app/api/save-token";
      final response = await Dio().post(
        url,
        data: {
          "store_id": storeId,
          "fcmToken": token,
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryPurple,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 250.h,
              width: 250.w,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Lottie.asset(
                  'assets/animations/bag_shop_ic.json',
                  height: 120.h,
                  width: 120.w,
                  fit: BoxFit.contain,
                  repeat: true,
                  onLoaded: (composition) {

                    _checkAuthAndNavigate();
                  },
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Store Manager',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25.sp, color: Colors.white, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _checkAuthAndNavigate() async {

    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final prefs = getIt<PrefsHelper>();
    final token = prefs.getManagerToken();


    if (token == null || token.isEmpty) {
      context.router.replace(const LoginRoute());
      return;
    }


    await getIt<NotificationService>().initNotification();



    final result = await getIt<GetSubscriptionUseCase>().call();

    if (!mounted) return;
    result.fold(
          (failure) {
        context.router.replace(const LoginRoute());
      },
          (statusData) {


       if (statusData.status == 'active' || statusData.status == 'suspend') {
          context.router.replace(const HomeBottomNavRoute());
        } else {
          context.router.replace(const SubscriptionExpiredRoute());
        }
      },
    );
  }
}
