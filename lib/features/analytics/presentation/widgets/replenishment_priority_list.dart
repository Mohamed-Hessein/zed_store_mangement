import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zed_store_mangent/core/resources/app_colors.dart';
import 'package:zed_store_mangent/core/resources/app_styles.dart';
import 'package:zed_store_mangent/features/analytics/domain/entity/analysis_entity.dart';

class ReplenishmentPriorityList extends StatelessWidget {
  final List<StockLevelItem> stockLevels;

  const ReplenishmentPriorityList({required this.stockLevels});

  @override
  Widget build(BuildContext context) {
    final lowStockItems = stockLevels
        .where((item) => item.quantity > 0 && item.quantity <= 10)
        .toList();

    return Container(
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
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Replenishment Priority',
                  style: AppStyles.text14DarkBold.copyWith(fontSize: 16.sp),
                ),
              ],
            ),
          ),
          Divider(height: 1.h, color: AppColors.divider),
          if (lowStockItems.isEmpty)
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Center(
                child: Text(
                  'All items have healthy stock levels',
                  style: AppStyles.text13DarkMedium,
                ),
              ),
            )
          else
            ...List.generate(
              lowStockItems.length,
              (index) {
                final item = lowStockItems[index];
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12.w),
                      child: Row(
                        children: [
                          Container(
                            width: 50.w,
                            height: 50.h,
                            decoration: BoxDecoration(
                              color: AppColors.primaryPurpleLight,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(
                              CupertinoIcons.cube_box,
                              color: AppColors.primaryPurple,
                              size: 24.sp,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.productName,
                                  style: AppStyles.text13DarkBold,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '${item.quantity} units left',
                                  style: AppStyles.text12DarkMedium,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                width: 10.w,
                                height: 10.h,
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(5.r),
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Container(
                                width: 10.w,
                                height: 10.h,
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(5.r),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (index < lowStockItems.length - 1)
                      Divider(
                        height: 1.h,
                        color: AppColors.divider,
                        indent: 16.w,
                        endIndent: 16.w,
                      ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}

