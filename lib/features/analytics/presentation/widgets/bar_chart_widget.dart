import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zed_store_mangent/core/resources/app_colors.dart';
import 'package:zed_store_mangent/core/resources/app_styles.dart';
import 'package:zed_store_mangent/features/analytics/domain/entity/analysis_entity.dart';

import '../../../../core/resources/app_strings.dart';

class BarChartWidget extends StatelessWidget {
  final List<StockLevelItem> stockLevels;

  const BarChartWidget({super.key, required this.stockLevels});

  @override
  Widget build(BuildContext context) {
    if (stockLevels.isEmpty) {
      return Center(
        child: Text(
          AppStrings.noAnalyticsData, 
          style: AppStyles.text14DarkBold,
        ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.inventoryManagement, 
            style: AppStyles.text14DarkBold.copyWith(fontSize: 16.sp),
          ),
          Text(
            'أفضل 5 منتجات أداءً',
            style: AppStyles.text12DarkMedium,
          ),
          SizedBox(height: 24.h),
          SizedBox(
            height: 280.h,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: _getMaxY(),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) => Text(
                        '${value.toInt()}',
                        style: AppStyles.text12DarkMedium,
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= stockLevels.length) return const SizedBox();
                        final productName = stockLevels[index].productName;
                        return Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: Text(
                            productName.length > 8 ? '${productName.substring(0, 8)}...' : productName,
                            style: AppStyles.text12DarkMedium,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(color: AppColors.divider, strokeWidth: 1),
                ),
                barGroups: _buildBarGroups(),
              ),
            ),
          ),
        ],
      ),
    );
  }
  List<BarChartGroupData> _buildBarGroups() {
    return List.generate(
      stockLevels.length,
      (index) => BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: stockLevels[index].quantity.toDouble(),
            color: AppColors.primaryPurple,
            width: 20.w,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(6.r),
              topRight: Radius.circular(6.r),
            ),
          ),
        ],
      ),
    );
  }

  double _getMaxY() {
    if (stockLevels.isEmpty) return 10;
    final maxQuantity = stockLevels
        .map((item) => item.quantity)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();
    return maxQuantity * 1.2;
  }
}

