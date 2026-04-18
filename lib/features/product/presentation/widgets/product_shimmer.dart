import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zed_store_mangent/core/resources/app_colors.dart';

class InventoryShimmer extends StatelessWidget {
  const InventoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(

        itemCount: 5,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: 16.h),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(
                  width: 90.w,
                  height: 90.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Container(width: 120.w, height: 15.h, color: Colors.white),

                          Container(width: 40.w, height: 15.h, color: Colors.white),
                        ],
                      ),
                      SizedBox(height: 12.h),

                      Container(width: 60.w, height: 20.h, color: Colors.white),
                      SizedBox(height: 12.h),

                      Container(
                        width: 100.w,
                        height: 25.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
