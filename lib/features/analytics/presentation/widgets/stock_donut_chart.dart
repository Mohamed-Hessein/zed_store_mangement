import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zed_store_mangent/core/resources/app_colors.dart';
import 'package:zed_store_mangent/core/resources/app_styles.dart';
import 'package:zed_store_mangent/features/analytics/domain/entity/analysis_entity.dart';

import '../../../../core/resources/app_strings.dart';

class StockDonutChart extends StatefulWidget {
  final StockDistribution stockDistribution;
  const StockDonutChart({super.key, required this.stockDistribution});

  @override
  State<StockDonutChart> createState() => _StockDonutChartState();
}

class _StockDonutChartState extends State<StockDonutChart> {
  @override
  Widget build(BuildContext context) {
    final distribution = widget.stockDistribution;
    final total = distribution.totalItems;

    if (total == 0) {
      return Center(
        child: Text(AppStrings.noData, style: AppStyles.text14DarkBold),
      );
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.r),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'توزيع المخزون',
                style: AppStyles.text14DarkBold.copyWith(fontSize: 16.sp),
              ),
              Icon(Icons.more_vert, color: AppColors.textSecondary, size: 20.sp),
            ],
          ),
          SizedBox(height: 24.h),
          SizedBox(
            height: 200.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: distribution.healthyCount.toDouble(),
                        title: '${(distribution.healthyCount / total * 100).toStringAsFixed(0)}%',
                        radius: 70.r,
                        color: AppColors.primaryPurple,
                        titleStyle: AppStyles.text12DarkMedium.copyWith(color: AppColors.white),
                      ),
                      PieChartSectionData(
                        value: distribution.lowStockCount.toDouble(),
                        title: '${(distribution.lowStockCount / total * 100).toStringAsFixed(0)}%',
                        radius: 70.r,
                        color: const Color(0xFFFFA726),
                        titleStyle: AppStyles.text12DarkMedium.copyWith(color: AppColors.white),
                      ),
                      PieChartSectionData(
                        value: distribution.outOfStockCount.toDouble(),
                        title: '${(distribution.outOfStockCount / total * 100).toStringAsFixed(0)}%',
                        radius: 70.r,
                        color: const Color(0xFFEF5350),
                        titleStyle: AppStyles.text12DarkMedium.copyWith(color: AppColors.white),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('100%', style: AppStyles.text14DarkBold.copyWith(fontSize: 20.sp)),
                    Text('التغطية', style: AppStyles.text12DarkMedium),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          _buildLegendItem(
            color: AppColors.primaryPurple,
            label: AppStrings.allProducts, 
            count: distribution.healthyCount,
            units: 'منتج',
          ),
          SizedBox(height: 12.h),
          _buildLegendItem(
            color: const Color(0xFFFFA726),
            label: AppStrings.lowStock,
            count: distribution.lowStockCount,
            units: 'منتج',
          ),
          SizedBox(height: 12.h),
          _buildLegendItem(
            color: const Color(0xFFEF5350),
            label: AppStrings.outOfStock,
            count: distribution.outOfStockCount,
            units: 'منتج',
          ),
        ],
      ),
    );
  }
  Widget _buildLegendItem({
    required Color color,
    required String label,
    required int count,
    required String units,
  }) {
    return Row(
      children: [
        Container(
          width: 12.w,
          height: 12.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3.r),
          ),
        ),
        SizedBox(width: 12.w),
        Text(
          label,
          style: AppStyles.text13DarkBold,
        ),
        const Spacer(),
        Text(
          '$count $units',
          style: AppStyles.text13DarkMedium,
        ),
      ],
    );
  }
}

