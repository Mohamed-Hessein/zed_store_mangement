import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:zed_store_mangent/core/error/failure.dart';
import 'package:zed_store_mangent/features/analytics/domain/entity/analysis_entity.dart';
import 'package:zed_store_mangent/features/analytics/domain/repository/analysis_repository.dart';

@injectable
class GetAnalyticsDataUsecase {
  final AnalysisRepository repository;

  GetAnalyticsDataUsecase(this.repository);

  Future<Either<Failure, AnalysisEntity>> call(TimeRange timeRange) {
    return repository.getAnalyticsData(timeRange);
  }
}

