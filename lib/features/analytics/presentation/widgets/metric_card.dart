import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zed_store_mangent/core/resources/app_colors.dart';
import 'package:zed_store_mangent/core/resources/app_styles.dart';

class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final String? badge;
  final Color? badgeColor;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    this.badge,
    this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24.sp,
                ),
              ),
              if (badge != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: (badgeColor?.withValues(alpha: 0.1) ?? AppColors.statusSuccessBg),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                  child: Text(
                    badge!,
                    style: AppStyles.text12DarkMedium.copyWith(
                      color: badgeColor ?? AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            subtitle,
            style: AppStyles.text12DarkMedium,
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: AppStyles.text20purple.copyWith(fontSize: 24.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            style: AppStyles.text14DarkBold,
          ),
        ],
      ),
    );
  }
}

