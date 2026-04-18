import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zed_store_mangent/core/resources/app_colors.dart';

import '../../../../core/resources/app_string.dart';
import '../../../../core/resources/app_strings.dart';

class OrderCard extends StatelessWidget {
  final String id;
  final String name;
  final String date;
  final String status;
  final String amount;

  const OrderCard({
    super.key,
    required this.id,
    required this.name,
    required this.date,
    required this.status,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    Color statusBg;


    String s = status.toLowerCase();
    if (s.contains("قيد") || s.contains("pending") || s.contains("preparing")) {
      statusColor = AppColors.statusPending;
      statusBg = AppColors.statusPendingBg;
    } else if (s.contains("مكتمل") || s.contains("delivered") || s.contains("success") || s.contains("تم التوصيل")) {
      statusColor = AppColors.statusSuccess;
      statusBg = AppColors.statusSuccessBg;
    } else {
      statusColor = AppColors.statusInfo;
      statusBg = AppColors.statusInfoBg;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [

              Expanded(
                child: Text(
                  id,
                  style: TextStyle(
                    color: AppColors.primaryPurple,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 10.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.backgroundLightGrey,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  date,
                  style: TextStyle(
                    color: AppColors.textGreyShade600,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          Text(
            AppStrings.customer,
            style: TextStyle(color: AppColors.textGreyShade500, fontSize: 12.sp),
          ),

          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.textBlack87,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [

              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              SizedBox(width: 10.w),

              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      AppStrings.totalAmount,
                      style: TextStyle(
                        color: AppColors.textGreyShade500,
                        fontSize: 11.sp,
                      ),
                    ),
                    Text(
                      amount,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13.sp, 
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.end,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
