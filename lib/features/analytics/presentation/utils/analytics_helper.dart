import 'package:zed_store_mangent/features/analytics/domain/entity/analysis_entity.dart';
import 'package:zed_store_mangent/features/analytics/presentation/bloc/analysis_state.dart';

class AnalyticsHelper {

  static String formatValue(dynamic value) {
    if (value is int) {
      if (value >= 1000000) {
        return '${(value / 1000000).toStringAsFixed(1)}M';
      } else if (value >= 1000) {
        return '${(value / 1000).toStringAsFixed(1)}K';
      }
      return value.toString();
    }
    if (value is double) {
      if (value >= 1000000) {
        return '${(value / 1000000).toStringAsFixed(1)}M';
      } else if (value >= 1000) {
        return '${(value / 1000).toStringAsFixed(1)}K';
      }
      return value.toStringAsFixed(2);
    }
    return value.toString();
  }


  static TimeRange mapStringToTimeRange(String range) {
    switch (range) {
      case 'Daily':
        return TimeRange.daily;
      case 'Weekly':
        return TimeRange.weekly;
      case 'Monthly':
        return TimeRange.monthly;
      case 'Custom':
        return TimeRange.custom;
      default:
        return TimeRange.daily;
    }
  }


  static TimeRange getCurrentTimeRange(AnalysisState state) {
    final selectedRange = state.selectedTimeRange ?? 'Daily';
    return mapStringToTimeRange(selectedRange);
  }
}

