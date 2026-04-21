// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import 'core/api/api_manager.dart' as _i237;
import 'core/api/prefs_helper.dart' as _i295;
import 'core/firebase/fcm.dart' as _i944;
import 'core/resources/internet_checker.dart' as _i228;
import 'core/usecase/usecases.dart' as _i987;
import 'di.dart' as _i913;
import 'features/analytics/data/datasource/analysis_datasource.dart' as _i879;
import 'features/analytics/data/repository/analysis_repository_impl.dart'
    as _i982;
import 'features/analytics/domain/repository/analysis_repository.dart' as _i527;
import 'features/analytics/domain/usecase/get_analytics_data_usecase.dart'
    as _i813;
import 'features/analytics/presentation/bloc/analysis_bloc.dart' as _i40;
import 'features/auth/login/data/datasource/remote/AuthRemoteDataSource.dart'
    as _i479;
import 'features/auth/login/data/datasource/remote/AuthRepository_subscribe.dart'
    as _i345;
import 'features/auth/login/data/datasource/remote/login_ds.dart' as _i612;
import 'features/auth/login/data/datasource/remote/login_ds_impl.dart' as _i744;
import 'features/auth/login/data/repo/login_repo_impl.dart' as _i1063;
import 'features/auth/login/domain/repo/login_repo.dart' as _i947;
import 'features/auth/login/domain/usecase/GetSubscriptionUseCase.dart'
    as _i676;
import 'features/auth/login/domain/usecase/login_usecase.dart' as _i133;
import 'features/auth/login/presentation/cubit/login_cunit.dart' as _i1046;
import 'features/home/data/data_source/order_ds.dart' as _i194;
import 'features/home/data/data_source/order_ds_impl.dart' as _i934;
import 'features/home/data/repo/order_repo_impl.dart' as _i877;
import 'features/home/domian/repo/order_repo.dart' as _i1044;
import 'features/home/domian/usecase/order_usecase.dart' as _i470;
import 'features/home/presentation/bloc/order_bloc.dart' as _i162;
import 'features/order_details/data/datasources/orders_remote_data_source.dart'
    as _i634;
import 'features/order_details/data/datasources/orders_remote_data_source_impl.dart'
    as _i569;
import 'features/order_details/data/repositories/orders_repository_impl.dart'
    as _i181;
import 'features/order_details/domain/entities/order_entity.dart' as _i768;
import 'features/order_details/domain/repositories/orders_repository.dart'
    as _i810;
import 'features/order_details/domain/usecases/get_order_details.dart' as _i602;
import 'features/order_details/presentation/bloc/order_details_bloc.dart'
    as _i437;
import 'features/product/data/data_source/ai_ds.dart' as _i722;
import 'features/product/data/data_source/product_ds.dart' as _i104;
import 'features/product/data/data_source/product_ds_impl.dart' as _i268;
import 'features/product/data/repo/product_repo_impl.dart' as _i619;
import 'features/product/domain/repo/product_repo.dart' as _i1038;
import 'features/product/domain/usecase/product_usecaswe.dart' as _i98;
import 'features/product/presentation/bloc/ai_bloc.dart' as _i996;
import 'features/product/presentation/bloc/products_bloc.dart' as _i810;
import 'features/spash_screen/data/ds/check_sub.dart' as _i325;
import 'features/spash_screen/data/repo/check_repo_impl.dart' as _i151;
import 'features/spash_screen/domain/repo/check_repo.dart' as _i1030;
import 'features/spash_screen/domain/usecase/check_usecase.dart' as _i872;
import 'features/store_profile/data/datasource/store_profile_remote_datasource.dart'
    as _i827;
import 'features/store_profile/data/repository/store_profile_repository_impl.dart'
    as _i286;
import 'features/store_profile/domain/repository/store_profile_repository.dart'
    as _i572;
import 'features/store_profile/domain/usecase/get_store_profile_usecase.dart'
    as _i238;
import 'features/store_profile/presentation/bloc/profile_bloc.dart' as _i188;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => appModule.prefs,
      preResolve: true,
    );
    gh.singleton<_i228.InternetConnectivity>(
      () => _i228.InternetConnectivity(),
    );
    gh.lazySingleton<_i944.NotificationService>(
      () => _i944.NotificationService(),
    );
    gh.lazySingleton<_i722.AIChatRemoteDataSource>(
      () => _i722.AIChatRemoteDataSource(),
    );
    gh.factory<_i996.AiAssistantBloc>(
      () => _i996.AiAssistantBloc(gh<_i722.AIChatRemoteDataSource>()),
    );
    gh.lazySingleton<_i295.PrefsHelper>(
      () => _i295.PrefsHelper(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i237.ApiManager>(
      () => _i237.ApiManager(gh<_i295.PrefsHelper>()),
    );
    gh.factory<_i325.CheckSubDs>(
      () => _i325.CheckSubImpl(gh<_i237.ApiManager>(), gh<_i295.PrefsHelper>()),
    );
    gh.factory<_i612.LoginDs>(
      () => _i744.LoginDsImpl(gh<_i237.ApiManager>(), gh<_i295.PrefsHelper>()),
    );
    gh.factory<_i479.AuthRemoteDataSource>(
      () => _i479.AuthRemoteDataSourceImpl(
        gh<_i237.ApiManager>(),
        gh<_i295.PrefsHelper>(),
      ),
    );
    gh.factory<_i1030.CheckRepo>(
      () => _i151.CheckRepoImpl(gh<_i325.CheckSubDs>()),
    );
    gh.factory<_i947.LoginRepo>(
      () => _i1063.LoginRepoImpl(gh<_i612.LoginDs>()),
    );
    gh.factory<_i133.LoginUsecase>(
      () => _i133.LoginUsecase(gh<_i947.LoginRepo>()),
    );
    gh.factory<_i345.AuthRepository>(
      () => _i345.AuthRepositoryImpl(gh<_i479.AuthRemoteDataSource>()),
    );
    gh.lazySingleton<_i872.CheckSubscriptionUseCase>(
      () => _i872.CheckSubscriptionUseCase(gh<_i1030.CheckRepo>()),
    );
    gh.factory<_i1046.LoginCubit>(
      () =>
          _i1046.LoginCubit(gh<_i133.LoginUsecase>(), gh<_i295.PrefsHelper>()),
    );
    gh.factory<_i634.OrdersRemoteDataSource>(
      () => _i569.OrdersRemoteDataSourceImpl(
        gh<_i295.PrefsHelper>(),
        apiManager: gh<_i237.ApiManager>(),
      ),
    );
    gh.factory<_i194.OrdersRemoteDataSource>(
      () => _i934.OrdersRemoteDataSourceImpl(
        gh<_i237.ApiManager>(),
        gh<_i295.PrefsHelper>(),
        gh<_i872.CheckSubscriptionUseCase>(),
      ),
    );
    gh.factory<_i810.OrdersRepository>(
      () => _i181.OrdersRepositoryImpl(
        remoteDataSource: gh<_i634.OrdersRemoteDataSource>(),
      ),
    );
    gh.factory<_i827.StoreProfileRemoteDataSource>(
      () => _i827.StoreProfileRemoteDataSourceImpl(
        gh<_i237.ApiManager>(),
        gh<_i872.CheckSubscriptionUseCase>(),
      ),
    );
    gh.factory<_i104.ProductDs>(
      () => _i268.ProductDsImpl(
        gh<_i872.CheckSubscriptionUseCase>(),
        gh<_i133.LoginUsecase>(),
        gh<_i237.ApiManager>(),
        gh<_i295.PrefsHelper>(),
      ),
    );
    gh.lazySingleton<_i879.AnalysisDataSource>(
      () => _i879.AnalysisDataSourceImpl(
        gh<_i872.CheckSubscriptionUseCase>(),
        gh<_i295.PrefsHelper>(),
        gh<_i237.ApiManager>(),
      ),
    );
    gh.factory<_i676.GetSubscriptionUseCase>(
      () => _i676.GetSubscriptionUseCase(gh<_i345.AuthRepository>()),
    );
    gh.factory<_i987.UseCase<_i768.OrderEntity, String>>(
      () => _i602.GetOrderDetailsUseCase(gh<_i810.OrdersRepository>()),
    );
    gh.lazySingleton<_i572.StoreProfileRepository>(
      () => _i286.StoreProfileRepositoryImpl(
        gh<_i827.StoreProfileRemoteDataSource>(),
      ),
    );
    gh.factory<_i437.OrderDetailsBloc>(
      () => _i437.OrderDetailsBloc(repository: gh<_i810.OrdersRepository>()),
    );
    gh.factory<_i1044.OrdersRepository>(
      () => _i877.OrdersRepositoryImpl(gh<_i194.OrdersRemoteDataSource>()),
    );
    gh.factory<_i1038.ProductRepo>(
      () => _i619.ProductRepoImpl(gh<_i104.ProductDs>()),
    );
    gh.lazySingleton<_i470.GetOrdersUseCase>(
      () => _i470.GetOrdersUseCase(gh<_i1044.OrdersRepository>()),
    );
    gh.lazySingleton<_i527.AnalysisRepository>(
      () => _i982.AnalysisRepositoryImpl(gh<_i879.AnalysisDataSource>()),
    );
    gh.factory<_i162.OrdersBloc>(
      () => _i162.OrdersBloc(gh<_i470.GetOrdersUseCase>()),
    );
    gh.factory<_i238.GetStoreProfileUseCase>(
      () => _i238.GetStoreProfileUseCase(gh<_i572.StoreProfileRepository>()),
    );
    gh.factory<_i813.GetAnalyticsDataUsecase>(
      () => _i813.GetAnalyticsDataUsecase(gh<_i527.AnalysisRepository>()),
    );
    gh.factory<_i98.ProductUsecase>(
      () => _i98.ProductUsecase(gh<_i1038.ProductRepo>()),
    );
    gh.factory<_i188.ProfileBloc>(
      () => _i188.ProfileBloc(gh<_i238.GetStoreProfileUseCase>()),
    );
    gh.factory<_i40.AnalysisBloc>(
      () => _i40.AnalysisBloc(gh<_i813.GetAnalyticsDataUsecase>()),
    );
    gh.factory<_i810.ProductsBloc>(
      () => _i810.ProductsBloc(gh<_i98.ProductUsecase>()),
    );
    return this;
  }
}

class _$AppModule extends _i913.AppModule {}
