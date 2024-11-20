import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starman/features/purchase/models/purchase_item_model.dart';
import 'package:starman/features/purchase/providers/purchase_service_provider.dart';
import 'package:starman/features/purchase/services/purchase_service.dart';
import '../../../core/utils/zip_manager.dart';
part 'purchase_item_vm.g.dart';

@riverpod
class PurchaseItemVm extends _$PurchaseItemVm {
  late final PurchaseService purchaseService;
  List<PurchaseItemModel> allData = [];
  List<PurchaseItemModel> filterData = [];
  double totalQty = 0;
  double totalAmount = 0;
  @override
  PurchaseItemState build() {
    purchaseService = ref.read(purchaseServiceProvider);
    return PurchaseItemState.initial();
  }

  Future<void> fetchData({required Map<String, String> params}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final datas = await purchaseService.getPIReport(params: params);
      allData = datas;
      totalAmount = datas[0].starTotalAmount!;
      totalQty = datas[0].starTotalQty!;
      state = PurchaseItemState.success(datas,totalQty,totalAmount);
    } catch (e) {
      // print(e.toString());
      state = state.copyWith(
          errorMessage: 'Something went wrong', isLoading: false);
    }
  }

  Future<void> loadData() async {
    allData.clear();
    state = state.copyWith(isLoading: true);
    try {
      var datas =
          await ZipManager.loadData("StarPI.json", PurchaseItemModel.fromJson);
      for (var data in datas) {
        allData.add(data);
      }
      totalAmount = allData[0].starTotalAmount!;
      totalQty = allData[0].starTotalQty!;
      state = PurchaseItemState.success(allData,totalQty,totalAmount);
    } catch (e) {
      state = state.copyWith(
          errorMessage: 'Something went wrong', isLoading: false);
    }
  }

  Future<void> loadDataByFilter({required String date}) async {
    filterData.clear();
    totalAmount = 0;
    totalQty = 0;
    state = state.copyWith(isLoading: true);
    try {
      for (var data in allData) {
        if (data.starFilter == date) {
          filterData.add(data);
          totalAmount += data.starTotalAmount!;
          totalQty += data.starTotalQty!;
        }
      }
      state = PurchaseItemState.success(filterData,totalQty,totalAmount);
    } catch (e) {
      state = state.copyWith(
          errorMessage: 'Something went wrong', isLoading: false);
    }
  }
}

class PurchaseItemState {
  final bool isLoading;
  final String? errorMessage;
  final List<PurchaseItemModel> datas;
  final double totalQty;
  final double totalAmount;

  PurchaseItemState(
      {
        required this.isLoading,
        this.errorMessage,
        required this.datas,
        required this.totalQty,
        required this.totalAmount,
      });

  factory PurchaseItemState.initial() =>
      PurchaseItemState(
          isLoading: false, datas: [],totalQty: 0,totalAmount: 0,
      );

  factory PurchaseItemState.success(List<PurchaseItemModel> datas,double totalQty,double totalAmount) =>
      PurchaseItemState(
          isLoading: false,
        datas: datas,
        errorMessage: null,
        totalQty: totalQty,
        totalAmount: totalAmount,
      );

  PurchaseItemState copyWith(
      {
        bool? isLoading,
        String? errorMessage,
        List<PurchaseItemModel>? datas,
        double? totalQty,
        double? totalAmount,
      }) {
    return PurchaseItemState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      datas: datas ?? this.datas,
      totalQty: totalQty ?? this.totalQty,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }
}
