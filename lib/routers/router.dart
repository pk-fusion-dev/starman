import 'package:go_router/go_router.dart';
import 'package:starman/features/financial/presentation/cash_flow_daily_screen.dart';
import 'package:starman/features/financial/presentation/cash_flow_screen.dart';
import 'package:starman/features/financial/presentation/expense_screen.dart';
import 'package:starman/features/license/presentation/license_expire_screen.dart';
import 'package:starman/features/license/presentation/register_starid_screen.dart';
import 'package:starman/features/license/presentation/splash_screen.dart';
import 'package:starman/features/financial/presentation/profit_loss_screen.dart';

class RouteName {
  static String splash = 'splash';
  static String register = 'register';
  static String expire = 'expire';
  static String profitLost = 'profitLost';
  static String cashflow = 'cashflow';
  static String cashflowdaily = 'cashflowdaily';
  static String expense = 'expense';
}

class RoutePath {
  static String splash = '/splash';
  static String register = '/register';
  static String expire = '/expire';
  static String profitLost = '/profitLost';
  static String cashflow = '/cashflow';
  static String cashflowdaily = '/cashflowdaily';
  static String expense = '/expense';
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
    builder: (context, state) => const LicenseExpireScreen(),
  ),
  GoRoute(
    path: RoutePath.profitLost,
    name: RouteName.profitLost,
    builder: (context, state) => const ProfitLoseScreen(),
  ),
  GoRoute(
    path: RoutePath.cashflow,
    name: RouteName.cashflow,
    builder: (context, state) => const CashFlowScreen(),
  ),
  GoRoute(
    path: RoutePath.cashflowdaily,
    name: RouteName.cashflowdaily,
    builder: (context, state) => const CashFlowDailyScreen(),
  ),
  GoRoute(
    path: RoutePath.expense,
    name: RouteName.expense,
    builder: (context, state) => const ExpenseScreen(),
  ),
], initialLocation: RoutePath.splash);
