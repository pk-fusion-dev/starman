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
      state = PurchaseItemState.success(datas);
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
      state = PurchaseItemState.success(allData);
    } catch (e) {
      state = state.copyWith(
          errorMessage: 'Something went wrong', isLoading: false);
    }
  }

  Future<void> loadDataByFilter({required String date}) async {
    filterData.clear();
    state = state.copyWith(isLoading: true);
    try {
      for (var data in allData) {
        if (data.starFilter == date) {
          filterData.add(data);
        }
      }
      state = PurchaseItemState.success(filterData);
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

  PurchaseItemState(
      {required this.isLoading, this.errorMessage, required this.datas});

  factory PurchaseItemState.initial() =>
      PurchaseItemState(isLoading: false, datas: []);

  factory PurchaseItemState.success(List<PurchaseItemModel> datas) =>
      PurchaseItemState(isLoading: false, datas: datas, errorMessage: null);

  PurchaseItemState copyWith(
      {bool? isLoading, String? errorMessage, List<PurchaseItemModel>? datas}) {
    return PurchaseItemState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      datas: datas ?? this.datas,
    );
  }
}
