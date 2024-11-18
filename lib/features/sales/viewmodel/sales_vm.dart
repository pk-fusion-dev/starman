import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starman/features/sales/models/sales_model.dart';
import 'package:starman/features/sales/providers/sales_service_provider.dart';
import 'package:starman/features/sales/services/sales_service.dart';
import '../../../core/utils/zip_manager.dart';
part 'sales_vm.g.dart';

@riverpod
class SalesVm extends _$SalesVm {
  late final SalesService salesService;
  List<SalesModel> allData = [];
  List<SalesModel> filterData = [];
  @override
  SalesState build() {
    salesService = ref.read(salesServiceProvider);
    return SalesState.initial();
  }

  Future<void> fetchData({required Map<String, String> params}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final datas = await salesService.getNSReport(params: params);
      allData = datas;
      state = SalesState.success(datas);
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
      var datas = await ZipManager.loadData("StarNS.json", SalesModel.fromJson);
      for (var data in datas) {
        allData.add(data);
      }
      state = SalesState.success(allData);
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
      state = SalesState.success(filterData);
    } catch (e) {
      state = state.copyWith(
          errorMessage: 'Something went wrong', isLoading: false);
    }
  }
}

class SalesState {
  final bool isLoading;
  final String? errorMessage;
  final List<SalesModel> datas;

  SalesState({required this.isLoading, this.errorMessage, required this.datas});

  factory SalesState.initial() => SalesState(isLoading: false, datas: []);

  factory SalesState.success(List<SalesModel> datas) =>
      SalesState(isLoading: false, datas: datas, errorMessage: null);

  SalesState copyWith(
      {bool? isLoading, String? errorMessage, List<SalesModel>? datas}) {
    return SalesState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      datas: datas ?? this.datas,
    );
  }
}
