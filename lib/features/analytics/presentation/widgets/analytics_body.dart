import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zed_store_mangent/core/resources/app_colors.dart';
import 'package:zed_store_mangent/core/resources/app_styles.dart';
import 'package:zed_store_mangent/features/analytics/domain/entity/analysis_entity.dart';
import 'package:zed_store_mangent/features/analytics/presentation/bloc/analysis_bloc.dart';
import 'package:zed_store_mangent/features/analytics/presentation/bloc/analysis_state.dart';
import 'package:zed_store_mangent/features/analytics/presentation/widgets/analytics_content.dart';

import '../../../../core/resources/app_strings.dart';
class AnalyticsBody extends StatelessWidget {
  const AnalyticsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalysisBloc, AnalysisState>(
      buildWhen: (previous, current) => previous.status != current.status || previous.data != current.data,
      builder: (context, state) {
        if (state.status == AnalysisStatus.loading) return const _LoadingWidget();
        if (state.status == AnalysisStatus.error) {
          return _ErrorWidget(errorMessage: state.errorMessage ?? AppStrings.unknownError);
        }
        if (state.status == AnalysisStatus.success && state.data != null) {
          return AnalyticsContent(data: state.data!);
        }
        return const SizedBox();
      },
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: AppColors.primaryPurple,
      ),
    );
  }
}


class _ErrorWidget extends StatelessWidget {
  final String errorMessage;

  const _ErrorWidget({required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.exclamationmark_circle,
            size: 50.sp,
            color: Colors.red,
          ),
          SizedBox(height: 16.h),
          Text(
            'Error loading analytics',
            style: AppStyles.text14DarkBold,
          ),
          SizedBox(height: 8.h),
          Text(
            errorMessage,
            style: AppStyles.text12DarkMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

