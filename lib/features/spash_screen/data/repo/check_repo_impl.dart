import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure.dart';
import '../../domain/repo/check_repo.dart';
import '../ds/check_sub.dart';
@Injectable( as: CheckRepo)
class CheckRepoImpl  implements CheckRepo{
  CheckSubDs checkSubDs;
  CheckRepoImpl(this.checkSubDs);
  @override
  Future<Either<Failure, bool>> checkSubscriptionFromServer() async{

  try{
    return await checkSubDs.checkSubscriptionFromServer();
  }catch(e){
    rethrow;
  }
  }
}
