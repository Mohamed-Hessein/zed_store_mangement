import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zed_store_mangent/core/resources/app_colors.dart';

class OrderShimmerLoading extends StatelessWidget {
  const OrderShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        itemCount: 6, 
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: 16.h),
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(width: 80.w, height: 20.h, color: Colors.white),
                    Container(width: 60.w, height: 20.h, color: Colors.white),
                  ],
                ),
                SizedBox(height: 15.h),

                Container(width: 50.w, height: 12.h, color: Colors.white),
                SizedBox(height: 5.h),

                Container(width: 120.w, height: 15.h, color: Colors.white),
                SizedBox(height: 20.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 70.w,
                      height: 30.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(width: 60.w, height: 10.h, color: Colors.white),
                        SizedBox(height: 5.h),
                        Container(width: 40.w, height: 15.h, color: Colors.white),
                      ],
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
