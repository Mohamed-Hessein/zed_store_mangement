import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zed_store_mangent/core/resources/app_colors.dart';
import 'package:zed_store_mangent/core/resources/app_styles.dart';
import 'package:zed_store_mangent/core/resources/app_strings.dart'; 
import 'package:zed_store_mangent/features/analytics/presentation/bloc/analysis_bloc.dart';
import 'package:zed_store_mangent/features/analytics/presentation/bloc/analysis_event.dart';
import 'package:zed_store_mangent/features/analytics/presentation/bloc/analysis_state.dart';
import '../../domain/entity/analysis_entity.dart';

class TimeRangeSelector extends StatelessWidget {
  const TimeRangeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalysisBloc, AnalysisState>(
      builder: (context, state) {

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _TimeRangeButton(
                label: AppStrings.dailyAnalytics,
                isSelected: state.selectedTimeRange == 'Daily',
                onTap: () => context.read<AnalysisBloc>().add(
                  const FetchAnalyticsData(timeRange: TimeRange.daily),
                ),
              ),
              SizedBox(width: 12.w),
              _TimeRangeButton(
                label: AppStrings.weeklyAnalytics,
                isSelected: state.selectedTimeRange == 'Weekly',
                onTap: () => context.read<AnalysisBloc>().add(
                  const FetchAnalyticsData(timeRange: TimeRange.weekly),
                ),
              ),
              SizedBox(width: 12.w),
              _TimeRangeButton(
                label: AppStrings.monthlyAnalytics,
                isSelected: state.selectedTimeRange == 'Monthly',
                onTap: () => context.read<AnalysisBloc>().add(
                  const FetchAnalyticsData(timeRange: TimeRange.monthly),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


class _TimeRangeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TimeRangeButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryPurple : AppColors.primaryPurpleLight,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Text(
          label,
          style: AppStyles.text13DarkBold.copyWith(
            color: isSelected ? AppColors.white : AppColors.primaryPurple,
          ),
        ),
      ),
    );
  }
}
