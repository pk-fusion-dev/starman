import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starman/features/sales/models/sold_item_model.dart';
import 'package:starman/features/sales/providers/sales_service_provider.dart';
import 'package:starman/features/sales/services/sales_service.dart';
import '../../../core/utils/zip_manager.dart';
part 'sold_item_vm.g.dart';

@riverpod
class SoldItemVm extends _$SoldItemVm {
  late final SalesService salesService;
  List<SoldItemModel> allData = [];
  List<SoldItemModel> filterData = [];
  double totalQty = 0;
  double totalAmount = 0;
  @override
  SoldItemState build() {
    salesService = ref.read(salesServiceProvider);
    return SoldItemState.initial();
  }

  Future<void> fetchData({required Map<String, String> params}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    totalQty = 0;
    totalAmount = 0;
    try {
      final datas = await salesService.getSIReport(params: params);
      allData = datas;
      totalAmount = datas[0].starTotalAmount!;
      totalQty = datas[0].starTotalQty!;
      state = SoldItemState.success(datas, totalQty, totalAmount);
    } catch (e) {
      // print(e.toString());
      state = state.copyWith(
          errorMessage: 'Something went wrong', isLoading: false);
    }
  }

  Future<void> loadData() async {
    allData.clear();
    totalQty = 0;
    totalAmount = 0;
    state = state.copyWith(isLoading: true);
    try {
      var datas =
          await ZipManager.loadData("StarSI.json", SoldItemModel.fromJson);
      for (var data in datas) {
        allData.add(data);
      }
      totalAmount = allData[0].starTotalAmount!;
      totalQty = allData[0].starTotalQty!;
      state = SoldItemState.success(allData, totalQty, totalAmount);
    } on RangeError catch (_) {
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
          errorMessage: 'Something went wrong', isLoading: false);
    }
  }

  Future<void> loadDataByFilter({required String date}) async {
    filterData.clear();
    totalQty = 0;
    totalAmount = 0;
    state = state.copyWith(isLoading: true);
    try {
      for (var data in allData) {
        if (data.starFilter == date) {
          filterData.add(data);
          totalAmount += data.starTotalAmount!;
          totalQty += data.starTotalQty!;
        }
      }
      state = SoldItemState.success(filterData, totalQty, totalAmount);
    } catch (e) {
      state = state.copyWith(
          errorMessage: 'Something went wrong', isLoading: false);
    }
  }
}

class SoldItemState {
  final bool isLoading;
  final String? errorMessage;
  final List<SoldItemModel> datas;
  final double totalQty;
  final double totalAmount;

  SoldItemState({
    required this.isLoading,
    this.errorMessage,
    required this.datas,
    required this.totalQty,
    required this.totalAmount,
  });

  factory SoldItemState.initial() => SoldItemState(
        isLoading: false,
        datas: [],
        totalQty: 0,
        totalAmount: 0,
      );

  factory SoldItemState.success(
          List<SoldItemModel> datas, double totalQty, double totalAmount) =>
      SoldItemState(
        isLoading: false,
        datas: datas,
        errorMessage: null,
        totalQty: totalQty,
        totalAmount: totalAmount,
      );

  SoldItemState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<SoldItemModel>? datas,
    double? totalQty,
    double? totalAmount,
  }) {
    return SoldItemState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      datas: datas ?? this.datas,
      totalQty: totalQty ?? this.totalQty,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }
}
