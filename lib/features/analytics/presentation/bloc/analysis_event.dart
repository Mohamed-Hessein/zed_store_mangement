import 'package:equatable/equatable.dart';
import 'package:zed_store_mangent/features/analytics/domain/entity/analysis_entity.dart';

abstract class AnalysisEvent extends Equatable {
  const AnalysisEvent();
}

class FetchAnalyticsData extends AnalysisEvent {
  final TimeRange timeRange;

  const FetchAnalyticsData({this.timeRange = TimeRange.daily});

  @override
  List<Object?> get props => [timeRange];
}

class ChangeTimeRange extends AnalysisEvent {
  final TimeRange timeRange;

  const ChangeTimeRange(this.timeRange);

  @override
  List<Object?> get props => [timeRange];
}

