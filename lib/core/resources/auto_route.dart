import 'package:auto_route/auto_route.dart';

import '../../features/home/presentation/widget/custom_btm_navgtor_bar.dart';
import 'auto_route.gr.dart';
@AutoRouterConfig()
class AppRouter extends RootStackRouter {


  @override
  List<AutoRoute> get routes {
    return [

      AutoRoute(
        page: SplashRouteRoute.page,
        initial: true,
      ),


      AutoRoute(page: LoginRoute.page),
      AutoRoute(page: SubscriptionExpiredRoute.page),

      AutoRoute(page: HomeBottomNavRoute.page),

      AutoRoute(page: DetailsRoute.page),
    ];
  }
}
