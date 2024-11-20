import 'package:go_router/go_router.dart';
import 'package:starman/features/financial/presentation/cash_flow_daily_screen.dart';
import 'package:starman/features/financial/presentation/cash_flow_screen.dart';
import 'package:starman/features/financial/presentation/expense_screen.dart';
import 'package:starman/features/license/presentation/license_expire_screen.dart';
import 'package:starman/features/license/presentation/register_starid_screen.dart';
import 'package:starman/features/license/presentation/splash_screen.dart';
import 'package:starman/features/financial/presentation/profit_loss_screen.dart';
import 'package:starman/features/purchase/presentation/purchase_item_report_screen.dart';
import 'package:starman/features/purchase/presentation/purchase_report_screen.dart';
import 'package:starman/features/sales/presentation/sales_report_screen.dart';
import 'package:starman/features/sales/presentation/sold_item_report_screen.dart';
import 'package:starman/features/stock/presentation/stock_balance_screen.dart';
import 'package:starman/features/stock/presentation/stock_reorder_screen.dart';

class RouteName {
  static String splash = 'splash';
  static String register = 'register';
  static String expire = 'expire';
  static String profitLost = 'profitLost';
  static String cashflow = 'cashflow';
  static String cashflowdaily = 'cashflowdaily';
  static String expense = 'expense';
  static String sales = 'sales';
  static String soldItem = 'soldItem';
  static String purchase = 'purchase';
  static String purchaseItem = 'purchaseItem';
  static String stockBalance = 'stockBalance';
  static String stockReorder = 'stockReorder';
}

class RoutePath {
  static String splash = '/splash';
  static String register = '/register';
  static String expire = '/expire';
  static String profitLost = '/profitLost';
  static String cashflow = '/cashflow';
  static String cashflowdaily = '/cashflowdaily';
  static String expense = '/expense';
  static String sales = '/sales';
  static String soldItem = '/soldItem';
  static String purchase = '/purchase';
  static String purchaseItem = '/purchaseItem';
  static String stockBalance = '/stockBalance';
  static String stockReorder = '/stockReorder';
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
  GoRoute(
    path: RoutePath.sales,
    name: RouteName.sales,
    builder: (context, state) => const SalesReportScreen(),
  ),
  GoRoute(
    path: RoutePath.soldItem,
    name: RouteName.soldItem,
    builder: (context, state) => const SoldItemReportScreen(),
  ),
  GoRoute(
    path: RoutePath.purchase,
    name: RouteName.purchase,
    builder: (context, state) => const PurchaseReportScreen(),
  ),
  GoRoute(
    path: RoutePath.purchaseItem,
    name: RouteName.purchaseItem,
    builder: (context, state) => const PurchaseItemReportScreen(),
  ),
  GoRoute(
    path: RoutePath.stockBalance,
    name: RouteName.stockBalance,
    builder: (context, state) => const StockBalanceScreen(),
  ),
  GoRoute(
    path: RoutePath.stockReorder,
    name: RouteName.stockReorder,
    builder: (context, state) => const StockReorderScreen(),
  ),
], initialLocation: RoutePath.splash);
