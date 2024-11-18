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
  @override
  SoldItemState build() {
    salesService = ref.read(salesServiceProvider);
    return SoldItemState.initial();
  }

  Future<void> fetchData({required Map<String, String> params}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final datas = await salesService.getSIReport(params: params);
      allData = datas;
      state = SoldItemState.success(datas);
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
          await ZipManager.loadData("StarSI.json", SoldItemModel.fromJson);
      for (var data in datas) {
        allData.add(data);
      }
      state = SoldItemState.success(allData);
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
      state = SoldItemState.success(filterData);
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

  SoldItemState(
      {required this.isLoading, this.errorMessage, required this.datas});

  factory SoldItemState.initial() => SoldItemState(isLoading: false, datas: []);

  factory SoldItemState.success(List<SoldItemModel> datas) =>
      SoldItemState(isLoading: false, datas: datas, errorMessage: null);

  SoldItemState copyWith(
      {bool? isLoading, String? errorMessage, List<SoldItemModel>? datas}) {
    return SoldItemState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      datas: datas ?? this.datas,
    );
  }
}
