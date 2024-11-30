import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starman/features/purchase/models/purchase_model.dart';
import 'package:starman/features/purchase/providers/purchase_service_provider.dart';
import 'package:starman/features/purchase/services/purchase_service.dart';
import '../../../core/utils/zip_manager.dart';
part 'purchase_vm.g.dart';

@riverpod
class PurchaseVm extends _$PurchaseVm {
  late final PurchaseService purchaseService;
  List<PurchaseModel> allData = [];
  List<PurchaseModel> filterData = [];
  @override
  PurchaseState build() {
    purchaseService = ref.read(purchaseServiceProvider);
    return PurchaseState.initial();
  }

  Future<void> fetchData({required Map<String, String> params}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final datas = await purchaseService.getNPReport(params: params);
      allData = datas;
      state = PurchaseState.success(datas);
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
          await ZipManager.loadData("StarNP.json", PurchaseModel.fromJson);
      for (var data in datas) {
        allData.add(data);
      }
      state = PurchaseState.success(allData);
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
        if (data.starFiler == date) {
          filterData.add(data);
        }
      }
      state = PurchaseState.success(filterData);
    } catch (e) {
      state = state.copyWith(
          errorMessage: 'Something went wrong', isLoading: false);
    }
  }
}

class PurchaseState {
  final bool isLoading;
  final String? errorMessage;
  final List<PurchaseModel> datas;

  PurchaseState(
      {required this.isLoading, this.errorMessage, required this.datas});

  factory PurchaseState.initial() => PurchaseState(isLoading: false, datas: []);

  factory PurchaseState.success(List<PurchaseModel> datas) =>
      PurchaseState(isLoading: false, datas: datas, errorMessage: null);

  PurchaseState copyWith(
      {bool? isLoading, String? errorMessage, List<PurchaseModel>? datas}) {
    return PurchaseState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      datas: datas ?? this.datas,
    );
  }
}
