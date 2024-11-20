import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starman/features/stock/models/stock_balance_model.dart';
import 'package:starman/features/stock/providers/stock_service_provider.dart';
import 'package:starman/features/stock/services/stock_service.dart';
import '../../../core/utils/zip_manager.dart';
// ignore: unused_import
import 'dart:developer';
part 'stock_balance_vm.g.dart';

@riverpod
class StockBalanceVm extends _$StockBalanceVm {
  late final StockService stockService;
  List<StockBalanceModel> allData = [];
  List<StarStockBalanceList> allStock = [];
  List<StarStockBalanceList> filterStock = [];
  List<String> categories = [];
  double totalQuantity = 0;
  double totalAmount = 0;
  @override
  StockBalanceState build() {
    stockService = ref.read(stockServiceProvider);
    return StockBalanceState.initial();
  }

  Future<void> fetchData({required Map<String, String> params}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final datas = await stockService.getSBReport(params: params);
      allData = datas;
      allStock = allData[0].starStockBalanceList!;
      for (var stock in allData[0].starStockBalanceList!) {
        if (!categories.contains(stock.starCategoryName)) {
          categories.add(stock.starCategoryName);
        }
      }
      state = StockBalanceState.success(
        datas,
        allStock,
        categories,
        allData[0].starTotalQty!,
        allData[0].starTotalAmount!,
      );
    } catch (e) {
      // print(e.toString());
      state = state.copyWith(
        errorMessage: 'Something went wrong',
        isLoading: false,
      );
    }
  }

  Future<void> loadData() async {
    state = state.copyWith(isLoading: true);
    try {
      var datas = await ZipManager.loadDataStockBalance(
          "StarSB.json", StockBalanceModel.fromJson);
      for(var data in datas){
        allData.add(data);
      }
      allStock = allData[0].starStockBalanceList!;
      for (var stock in allData[0].starStockBalanceList!) {
        if (!categories.contains(stock.starCategoryName)) {
          categories.add(stock.starCategoryName);
        }
      }
      state = StockBalanceState.success(
        allData,
        allStock,
        categories,
        allData[0].starTotalQty!,
        allData[0].starTotalAmount!,
      );
    } catch (e) {
      // print(e.toString());
      state = state.copyWith(
          errorMessage: 'Something went wrong', isLoading: false);
    }
  }

  Future<void> loadDataByFilter({required String category}) async {
    filterStock.clear();
    totalAmount = 0;
    totalQuantity = 0;
    state = state.copyWith(isLoading: true);
    try {
      for (var data in allStock) {
        if (category == 'All' || data.starCategoryName == category) {
          filterStock.add(data);
          totalAmount += data.starAmount;
          totalQuantity += data.starQty;
        }
      }
      state = StockBalanceState.success(
        allData,
        filterStock,
        categories,
        totalQuantity,
        totalAmount,
      );
    } catch (e) {
      state = state.copyWith(
          errorMessage: 'Something went wrong', isLoading: false);
    }
  }
}

class StockBalanceState {
  final bool isLoading;
  final String? errorMessage;
  final List<StockBalanceModel> datas;
  final List<StarStockBalanceList> stockList;
  final List<String> categories;
  final double totalQuantity;
  final double totalAmount;

  StockBalanceState({
    required this.isLoading,
    this.errorMessage,
    required this.datas,
    required this.stockList,
    required this.categories,
    required this.totalQuantity,
    required this.totalAmount,
  });

  factory StockBalanceState.initial() => StockBalanceState(
        isLoading: false,
        datas: [],
        stockList: [],
        categories: [],
        totalQuantity: 0,
        totalAmount: 0,
      );

  factory StockBalanceState.success(
          List<StockBalanceModel> datas,
          List<StarStockBalanceList> stockList,
          List<String> categories,
          double totalQuantity,
          double totalAmount) =>
      StockBalanceState(
        isLoading: false,
        datas: datas,
        stockList: stockList,
        errorMessage: null,
        categories: categories,
        totalQuantity: totalQuantity,
        totalAmount: totalAmount,
      );

  StockBalanceState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<StockBalanceModel>? datas,
    List<StarStockBalanceList>? stockList,
    List<String>? categories,
    double? totalQuantity,
    double? totalAmount,
  }) {
    return StockBalanceState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      datas: datas ?? this.datas,
      stockList: stockList ?? this.stockList,
      categories: categories ?? this.categories,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }
}
