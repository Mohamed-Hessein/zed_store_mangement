import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zed_store_mangent/core/resources/hive_helper.dart'; 
import 'package:zed_store_mangent/core/resources/internet_checker.dart'; 
import 'package:zed_store_mangent/di.dart';
import 'package:zed_store_mangent/features/analytics/domain/usecase/get_analytics_data_usecase.dart';
import 'package:zed_store_mangent/features/analytics/presentation/bloc/analysis_event.dart';
import 'package:zed_store_mangent/features/analytics/presentation/bloc/analysis_state.dart';

import '../../domain/entity/analysis_entity.dart';

@injectable
class AnalysisBloc extends Bloc<AnalysisEvent, AnalysisState> {
  final GetAnalyticsDataUsecase getAnalyticsDataUsecase;

  AnalysisBloc(this.getAnalyticsDataUsecase) : super(const AnalysisState()) {
    on<FetchAnalyticsData>(_onFetchAnalyticsData);
    on<ChangeTimeRange>(_onChangeTimeRange);
  }

  Future<void> _onFetchAnalyticsData(
      FetchAnalyticsData event,
      Emitter<AnalysisState> emit,
      ) async {

    final cachedData = await HiveCacheHelper.getData<dynamic>(
      boxName: HiveCacheHelper.analyticsBoxName,
      key: 'latest_analytics_${event.timeRange.toString()}',
    );

    if (cachedData != null) {
      emit(state.copyWith(
        status: AnalysisStatus.success,
        data: cachedData as AnalysisEntity, 
        timeRange: event.timeRange,
        selectedTimeRange: _mapTimeRangeToString(event.timeRange),
      ));
    } else {
      emit(state.copyWith(status: AnalysisStatus.loading));
    }


    if (!getIt<InternetConnectivity>().isConnected) {
      if (cachedData == null) {
        emit(state.copyWith(
            status: AnalysisStatus.error,
            errorMessage: "لا يتوفر اتصال بالإنترنت",
        ));
      }
      return;
    }


    final result = await getAnalyticsDataUsecase.call(event.timeRange);

    await result.fold(
          (failure) async {
        if (state.data == null) {
          emit(state.copyWith(
            status: AnalysisStatus.error,
            errorMessage: failure.message,
          ));
        }
      },
          (data) async {

        await HiveCacheHelper.saveData(
          boxName: HiveCacheHelper.analyticsBoxName,
          key: 'latest_analytics_${event.timeRange.toString()}',
          value: data,
        );

        emit(state.copyWith(
          status: AnalysisStatus.success,
          data: data,
          timeRange: event.timeRange,
          selectedTimeRange: _mapTimeRangeToString(event.timeRange),
        ));
      },
    );
  }

  Future<void> _onChangeTimeRange(
      ChangeTimeRange event,
      Emitter<AnalysisState> emit,
      ) async {
    add(FetchAnalyticsData(timeRange: event.timeRange));
  }

  String _mapTimeRangeToString(TimeRange timeRange) {
    switch (timeRange) {
      case TimeRange.daily: return 'Daily';
      case TimeRange.weekly: return 'Weekly';
      case TimeRange.monthly: return 'Monthly';
      case TimeRange.custom: return 'Custom';
      default: return 'Daily';
    }
  }
}
