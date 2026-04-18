import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zed_store_mangent/core/resources/app_colors.dart';
import 'package:zed_store_mangent/core/resources/app_styles.dart';

class SettingsListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const SettingsListTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: AppColors.primaryPurpleLight,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, color: AppColors.primaryPurple, size: 20.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  title,
                  style: AppStyles.text14DarkBold,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.textSecondary,
                size: 16.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
