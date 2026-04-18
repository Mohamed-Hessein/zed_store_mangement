
import 'package:dartz/dartz.dart';
import 'package:zed_store_mangent/core/error/failure.dart';
import 'package:zed_store_mangent/features/analytics/domain/entity/analysis_entity.dart';

abstract class AnalysisRepository {
  Future<Either<Failure, AnalysisEntity>> getAnalyticsData(TimeRange timeRange);
}

