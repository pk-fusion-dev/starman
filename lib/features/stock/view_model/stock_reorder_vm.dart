import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starman/features/stock/models/stock_reorder_model.dart';
import 'package:starman/features/stock/providers/stock_service_provider.dart';
import 'package:starman/features/stock/services/stock_service.dart';
import '../../../core/utils/zip_manager.dart';
// import 'dart:developer';
part 'stock_reorder_vm.g.dart';

@riverpod
class StockReorderVm extends _$StockReorderVm {
  late final StockService stockService;
  List<StockReorderModel> allData = [];
  List<StockReorderModel> filterData = [];
  List<String> categories = [];
  @override
  StockReorderState build() {
    stockService = ref.read(stockServiceProvider);
    return StockReorderState.initial();
  }

  Future<void> fetchData({required Map<String, String> params}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final datas = await stockService.getSRReport(params: params);
      allData = datas;
      for (var stock in allData) {
        if (!categories.contains(stock.starCategoryName)) {
          categories.add(stock.starCategoryName!);
        }
      }
      state = StockReorderState.success(datas, categories);
    } catch (e) {
      // print(e.toString());
      state = state.copyWith(
          errorMessage: 'Something went wrong', isLoading: false);
    }
  }

  Future<void> loadData() async {
    state = state.copyWith(isLoading: true);
    try {
      var datas =
          await ZipManager.loadData("StarSR.json", StockReorderModel.fromJson);
      for (var data in datas) {
        if (!categories.contains(data.starCategoryName)) {
          categories.add(data.starCategoryName!);
        }
        allData.add(data);
      }
      state = StockReorderState.success(allData, categories);
    } catch (e) {
      // print(e.toString());
      state = state.copyWith(
          errorMessage: 'Something went wrong', isLoading: false);
    }
  }

  Future<void> loadDataByFilter({required String category}) async {
    filterData.clear();
    state = state.copyWith(isLoading: true);
    try {
      for (var data in allData) {
        if (category == 'All' || data.starCategoryName == category) {
          filterData.add(data);
        }
      }
      state = StockReorderState.success(filterData, categories);
    } catch (e) {
      state = state.copyWith(
          errorMessage: 'Something went wrong', isLoading: false);
    }
  }
}

class StockReorderState {
  final bool isLoading;
  final String? errorMessage;
  final List<StockReorderModel> datas;
  final List<String> categories;

  StockReorderState(
      {required this.isLoading,
      this.errorMessage,
      required this.datas,
      required this.categories});

  factory StockReorderState.initial() =>
      StockReorderState(isLoading: false, datas: [], categories: []);

  factory StockReorderState.success(
          List<StockReorderModel> datas, List<String> categories) =>
      StockReorderState(
          isLoading: false,
          datas: datas,
          errorMessage: null,
          categories: categories);

  StockReorderState copyWith(
      {bool? isLoading,
      String? errorMessage,
      List<StockReorderModel>? datas,
      List<String>? categories}) {
    return StockReorderState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      datas: datas ?? this.datas,
      categories: categories ?? this.categories,
    );
  }
}
