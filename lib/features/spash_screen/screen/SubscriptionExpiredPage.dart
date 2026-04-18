import 'package:flutter/material.dart';
import 'package:auto_route/annotations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zed_store_mangent/core/resources/app_colors.dart';

@RoutePage()
class SubscriptionExpiredPage extends StatelessWidget {
  const SubscriptionExpiredPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline_rounded,
              size: 100.sp,
              color: AppColors.primaryPurple,
            ),
            SizedBox(height: 30.h),
            Text(
              'انتهت فترة اشتراكك في التطبيق',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 15.h),
            Text(
              'يرجى تجديد الاشتراك من خلال متجر تطبيقات زد لتتمكن من إدارة متجرك واستخدام ميزات الذكاء الاصطناعي.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 40.h),

            ElevatedButton(
              onPressed: () {_openZidSubscription();


              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                minimumSize: Size(double.infinity, 50.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'فهمت',
                style: TextStyle(color: Colors.white, fontSize: 18.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> _openZidSubscription() async {
    final Uri url = Uri.parse('https://zedstore.ct.ws/auth.php'); 
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}











