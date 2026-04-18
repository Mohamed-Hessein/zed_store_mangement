import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zed_store_mangent/core/resources/app_colors.dart';
import 'package:zed_store_mangent/core/resources/app_styles.dart';
import 'package:zed_store_mangent/features/store_profile/domain/entity/store_profile_entity.dart';

class QuickStatsRow extends StatelessWidget {
  final StoreProfileEntity storeProfile;

  const QuickStatsRow({super.key, required this.storeProfile});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          _StatCard(
            label: 'إجمالي\nالمنتجات',
            value: (storeProfile.totalProducts ?? 0).toString(),
          ),
          SizedBox(width: 12.w),
          _StatCard(
            label: 'إجمالي\nالمبيعات',
            value: (storeProfile.totalSales ?? 0).toString(),
          ),
          SizedBox(width: 12.w),
          _StatCard(
            label: 'إجمالي\nالإيرادات',
            value: '${storeProfile.totalRevenue ?? '0'}',
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              label,
              style: AppStyles.text12DarkMedium.copyWith(fontSize: 9.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              value,
              style: AppStyles.text14DarkBold,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
