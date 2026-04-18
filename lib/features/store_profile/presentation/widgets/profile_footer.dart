import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zed_store_mangent/core/api/prefs_helper.dart';
import 'package:zed_store_mangent/core/resources/app_colors.dart';
import 'package:zed_store_mangent/core/resources/app_styles.dart';
import 'package:zed_store_mangent/core/resources/app_strings.dart';
import 'package:zed_store_mangent/di.dart';

class ProfileFooter extends StatelessWidget {
  final VoidCallback? onLogoutPressed;

  const ProfileFooter({super.key, this.onLogoutPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 32.h),
        Center(
          child: GestureDetector(
            onTap: onLogoutPressed ?? () {
              getIt<PrefsHelper>().clearData();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout, color: Colors.red, size: 18.sp),
                SizedBox(width: 8.w),
                Text(
                  'تسجيل الخروج',
                  style: AppStyles.text14DarkBold.copyWith(
                    color: Colors.red,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Center(
          child: Text(
            'الإصدار v1.0.4',
            style: AppStyles.text12DarkMedium.copyWith(
              fontSize: 11.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }
}
