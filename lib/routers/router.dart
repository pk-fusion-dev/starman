import 'package:go_router/go_router.dart';
import 'package:starman/features/license/presentation/license_expire_screen.dart';
import 'package:starman/features/license/presentation/register_starid_screen.dart';
import 'package:starman/features/license/presentation/splash_screen.dart';
import 'package:starman/features/profit/presentation/profit_lose_screen.dart';

class RouteName {
  static String splash = 'splash';
  static String register = 'register';
  static String expire = 'expire';
  static String profitLost = 'profitLost';
}

class RoutePath {
  static String splash = '/splash';
  static String register = '/register';
  static String expire = '/expire';
  static String profitLost = '/profitLost';
}

final appRoute = GoRouter(routes: [
  GoRoute(
    path: RoutePath.splash,
    name: RouteName.splash,
    builder: (context, state) => const SplashScreen(),
  ),
  GoRoute(
    path: RoutePath.register,
    name: RouteName.register,
    builder: (context, state) => const RegisterStarIdScreen(),
  ),
  GoRoute(
    path: RoutePath.expire,
    name: RouteName.expire,
    builder: (context, state) => LicenseExpireScreen(),
  ),
  GoRoute(
    path: RoutePath.profitLost,
    name: RouteName.profitLost,
    builder: (context, state) => const ProfitLoseScreen(),
  ),
], initialLocation: RoutePath.splash);
