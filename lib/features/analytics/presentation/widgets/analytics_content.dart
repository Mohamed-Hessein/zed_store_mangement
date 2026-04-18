import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zed_store_mangent/core/resources/app_colors.dart';
import 'package:zed_store_mangent/features/analytics/domain/entity/analysis_entity.dart';
import 'package:zed_store_mangent/features/analytics/presentation/widgets/bar_chart_widget.dart';
import 'package:zed_store_mangent/features/analytics/presentation/widgets/metric_card.dart';
import 'package:zed_store_mangent/features/analytics/presentation/widgets/replenishment_priority_list.dart';
import 'package:zed_store_mangent/features/analytics/presentation/widgets/stock_donut_chart.dart';
import 'package:zed_store_mangent/features/analytics/presentation/widgets/time_range_selector.dart';
import 'package:zed_store_mangent/features/analytics/presentation/utils/analytics_helper.dart';

import '../../../../core/resources/app_strings.dart';
class AnalyticsContent extends StatelessWidget {
  final AnalysisEntity data;
  const AnalyticsContent({required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TimeRangeSelector(),
          SizedBox(height: 24.h),
          MetricCard(
            title: AppStrings.revenue,
            value: 'SAR ${AnalyticsHelper.formatValue(data.totalValue)}',
            subtitle: AppStrings.orderTotal,
            icon: CupertinoIcons.creditcard,
            iconColor: AppColors.primaryPurple,
            badge: '+12.4%',
            badgeColor: AppColors.statusSuccessBg,
          ),
          SizedBox(height: 16.h),
          MetricCard(
            title: AppStrings.totalProducts,
            value: '${AnalyticsHelper.formatValue(data.totalStockCount)}',
            subtitle: AppStrings.inventory,
            icon: Icons.inventory_2_outlined,
            iconColor: AppColors.primaryPurple,
            badge: AppStrings.success,
            badgeColor: AppColors.statusSuccessBg,
          ),
          SizedBox(height: 16.h),
          MetricCard(
            title: AppStrings.outOfStock,
            value: '${data.outOfStockCount}',
            subtitle: AppStrings.products,
            icon: CupertinoIcons.exclamationmark_circle_fill,
            iconColor: Colors.red,
            badge: AppStrings.errorOccurred,
            badgeColor: const Color(0xFFFFEBEE),
          ),
          SizedBox(height: 24.h),
          BarChartWidget(stockLevels: data.stockLevels),
          SizedBox(height: 24.h),
          StockDonutChart(stockDistribution: data.stockDistribution),
          SizedBox(height: 24.h),
          ReplenishmentPriorityList(stockLevels: data.stockLevels),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
