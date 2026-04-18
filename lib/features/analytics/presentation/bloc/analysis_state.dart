import 'package:equatable/equatable.dart';
import 'package:zed_store_mangent/features/analytics/domain/entity/analysis_entity.dart';

enum AnalysisStatus { initial, loading, success, error }

class AnalysisState extends Equatable {
  final AnalysisStatus status;
  final AnalysisEntity? data;
  final String? errorMessage;
  final TimeRange timeRange;
  final String selectedTimeRange;

  const AnalysisState({
    this.status = AnalysisStatus.initial,
    this.data,
    this.errorMessage,
    this.timeRange = TimeRange.daily,
    this.selectedTimeRange = 'Daily',
  });

  AnalysisState copyWith({
    AnalysisStatus? status,
    AnalysisEntity? data,
    String? errorMessage,
    TimeRange? timeRange,
    String? selectedTimeRange,
  }) {
    return AnalysisState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
      timeRange: timeRange ?? this.timeRange,
      selectedTimeRange: selectedTimeRange ?? this.selectedTimeRange,
    );
  }

  @override
  List<Object?> get props => [status, data, errorMessage, timeRange, selectedTimeRange];
}

