import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zed_store_mangent/core/resources/app_colors.dart';
import 'package:zed_store_mangent/core/resources/app_styles.dart';
import 'package:zed_store_mangent/features/analytics/presentation/bloc/analysis_bloc.dart';
import 'package:zed_store_mangent/features/analytics/presentation/bloc/analysis_event.dart';
import 'package:zed_store_mangent/features/analytics/presentation/bloc/analysis_state.dart';
import 'package:zed_store_mangent/features/analytics/presentation/utils/analytics_helper.dart';

import '../../../../core/resources/app_strings.dart';
class AnalyticsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AnalyticsAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(Icons.analytics_outlined, color: AppColors.white, size: 20.sp),
              ),
              SizedBox(width: 12.w),
              Text(AppStrings.analyticsOverview, style: AppStyles.text16PurpleBold),
            ],
          ),
          GestureDetector(
            onTap: () {
              context.read<AnalysisBloc>().add(
                FetchAnalyticsData(
                  timeRange: AnalyticsHelper.getCurrentTimeRange(
                    context.read<AnalysisBloc>().state,
                  ),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.primaryPurpleLight,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(Icons.notifications_none, color: AppColors.primaryPurple, size: 20.sp),
            ),
          ),
        ],
      ),
    );
  }
}
