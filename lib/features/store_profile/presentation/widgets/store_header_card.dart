import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zed_store_mangent/core/resources/app_colors.dart';
import 'package:zed_store_mangent/core/resources/app_styles.dart';
import 'package:zed_store_mangent/features/store_profile/domain/entity/store_profile_entity.dart';

class StoreHeaderCard extends StatelessWidget {
  final StoreProfileEntity storeProfile;

  const StoreHeaderCard({super.key, required this.storeProfile});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 70.w,
                height: 70.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primaryPurple.withOpacity(0.1),
                    width: 2.w,
                  ),
                  image: DecorationImage(
                    image: NetworkImage(storeProfile.storeImageUrl ?? 'https://ui-avatars.com/api/?name=Store'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (storeProfile.verificationStatus == 'VERIFIED STORE')
                Container(
                  width: 20.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryPurple,
                    border: Border.all(color: AppColors.white, width: 1.5.w),
                  ),
                  child: Icon(Icons.verified, color: AppColors.white, size: 12.sp),
                ),
            ],
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  storeProfile.storeName ?? 'متجر غير معروف',
                  style: AppStyles.text16PurpleBold.copyWith(fontSize: 15.sp),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    storeProfile.verificationStatus == 'VERIFIED STORE' ? 'متجر موثق' : 'غير موثق',
                    style: AppStyles.text12DarkMedium.copyWith(
                      color: AppColors.primaryPurple,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
