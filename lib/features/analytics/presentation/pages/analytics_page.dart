import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zed_store_mangent/core/resources/app_colors.dart';
import 'package:zed_store_mangent/di.dart';
import 'package:zed_store_mangent/features/analytics/domain/entity/analysis_entity.dart';
import 'package:zed_store_mangent/features/analytics/presentation/bloc/analysis_bloc.dart';
import 'package:zed_store_mangent/features/analytics/presentation/bloc/analysis_event.dart';
import 'package:zed_store_mangent/features/analytics/presentation/widgets/analytics_app_bar.dart';
import 'package:zed_store_mangent/features/analytics/presentation/widgets/analytics_body.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AnalysisBloc>()
        ..add(const FetchAnalyticsData(timeRange: TimeRange.daily)),
      child: const Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AnalyticsAppBar(),
        body: AnalyticsBody(),
      ),
    );
  }
}

