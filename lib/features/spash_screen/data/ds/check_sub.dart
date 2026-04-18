import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import 'package:zed_store_mangent/core/api/api_manager.dart';
import 'package:zed_store_mangent/core/api/prefs_helper.dart';
import 'package:zed_store_mangent/di.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/failures.dart' hide Failure;

abstract class CheckSubDs {
  Future<Either<Failure, bool>>checkSubscriptionFromServer();
}
@Injectable(as: CheckSubDs)
class CheckSubImpl implements CheckSubDs {
  final PrefsHelper _prefsHelper;
  final ApiManager api;

  CheckSubImpl(this.api, this._prefsHelper);
  @override
  Future<Either<Failure, bool>> checkSubscriptionFromServer() async {
    try {
      final response = await api.get(
        "https://zid-backend-vercel.vercel.app/api/check-subscription",
        headers: {
          'Authorization': 'Bearer ${_prefsHelper.getManagerToken()}',
          'X-MANAGER-TOKEN': _prefsHelper.getAccessToken(),
          'Store-Id': '${_prefsHelper.getStoreId()}',
        },
      );


      if (response.statusCode == 200) {
        return const Right(true);
      }

      return const Right(false);

    } catch (e) {

      if (e is DioException) {
        if (e.response?.statusCode == 402) {


          debugPrint("⚠️ Subscription is Suspend (402), allowing access for testing...");
          return const Right(true);
        }
      }


      return Left(Failure(message: "Connection Error"));
    }
  }}
