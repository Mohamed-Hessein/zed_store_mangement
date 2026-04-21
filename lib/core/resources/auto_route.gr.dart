// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i8;
import 'package:flutter/material.dart' as _i9;
import 'package:zed_store_mangent/features/auth/login/presentation/screens/login_screen.dart'
    as _i5;
import 'package:zed_store_mangent/features/home/presentation/screen/home_screen.dart'
    as _i3;
import 'package:zed_store_mangent/features/home/presentation/widget/custom_btm_navgtor_bar.dart'
    as _i2;
import 'package:zed_store_mangent/features/order_details/presentation/screen/details_screen.dart'
    as _i1;
import 'package:zed_store_mangent/features/product/presentation/pages/inventory_page.dart'
    as _i4;
import 'package:zed_store_mangent/features/spash_screen/screen/splash_screen.dart'
    as _i6;
import 'package:zed_store_mangent/features/spash_screen/screen/SubscriptionExpiredPage.dart'
    as _i7;

/// generated route for
/// [_i1.DetailsScreen]
class DetailsRoute extends _i8.PageRouteInfo<DetailsRouteArgs> {
  DetailsRoute({
    _i9.Key? key,
    required String orderId,
    List<_i8.PageRouteInfo>? children,
  }) : super(
         DetailsRoute.name,
         args: DetailsRouteArgs(key: key, orderId: orderId),
         initialChildren: children,
       );

  static const String name = 'DetailsRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DetailsRouteArgs>();
      return _i8.WrappedRoute(
        child: _i1.DetailsScreen(key: args.key, orderId: args.orderId),
      );
    },
  );
}

class DetailsRouteArgs {
  const DetailsRouteArgs({this.key, required this.orderId});

  final _i9.Key? key;

  final String orderId;

  @override
  String toString() {
    return 'DetailsRouteArgs{key: $key, orderId: $orderId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DetailsRouteArgs) return false;
    return key == other.key && orderId == other.orderId;
  }

  @override
  int get hashCode => key.hashCode ^ orderId.hashCode;
}

/// generated route for
/// [_i2.HomeBottomNavPage]
class HomeBottomNavRoute extends _i8.PageRouteInfo<void> {
  const HomeBottomNavRoute({List<_i8.PageRouteInfo>? children})
    : super(HomeBottomNavRoute.name, initialChildren: children);

  static const String name = 'HomeBottomNavRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i2.HomeBottomNavPage();
    },
  );
}

/// generated route for
/// [_i3.HomeScreen]
class HomeRoute extends _i8.PageRouteInfo<void> {
  const HomeRoute({List<_i8.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i3.HomeScreen();
    },
  );
}

/// generated route for
/// [_i4.InventoryPage]
class InventoryRoute extends _i8.PageRouteInfo<void> {
  const InventoryRoute({List<_i8.PageRouteInfo>? children})
    : super(InventoryRoute.name, initialChildren: children);

  static const String name = 'InventoryRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i4.InventoryPage();
    },
  );
}

/// generated route for
/// [_i5.LoginScreen]
class LoginRoute extends _i8.PageRouteInfo<void> {
  const LoginRoute({List<_i8.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i5.LoginScreen();
    },
  );
}

/// generated route for
/// [_i6.SplashScreenPage]
class SplashRouteRoute extends _i8.PageRouteInfo<void> {
  const SplashRouteRoute({List<_i8.PageRouteInfo>? children})
    : super(SplashRouteRoute.name, initialChildren: children);

  static const String name = 'SplashRouteRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i6.SplashScreenPage();
    },
  );
}

/// generated route for
/// [_i7.SubscriptionExpiredPage]
class SubscriptionExpiredRoute extends _i8.PageRouteInfo<void> {
  const SubscriptionExpiredRoute({List<_i8.PageRouteInfo>? children})
    : super(SubscriptionExpiredRoute.name, initialChildren: children);

  static const String name = 'SubscriptionExpiredRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i7.SubscriptionExpiredPage();
    },
  );
}
