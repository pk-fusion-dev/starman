import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starman/features/financial/models/cash_flow_model.dart';
import 'package:starman/features/financial/providers/financial_service_provider.dart';
import 'package:starman/features/financial/services/financial_service.dart';

import '../../../core/utils/zip_manager.dart';
part 'cash_flow_vm.g.dart';

@riverpod
class CashFlowVm extends _$CashFlowVm {
  late final FinancialService financialService;
  List<CashFlowModel> allData = [];
  List<CashFlowModel> filterData = [];
  @override
  CashFlowState build() {
    financialService = ref.read(financialServiceProvider);
    return CashFlowState.initial();
  }

  Future<void> fetchData({required Map<String, String> params}) async {
    state = state.copyWith(isLoading: true);
    try {
      final datas = await financialService.getCFReport(params: params);
      allData = datas;
      state = CashFlowState.success(datas);
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
          await ZipManager.loadData("StarCF.json", CashFlowModel.fromJson);
      for (var data in datas) {
        allData.add(data);
      }
      state = CashFlowState.success(allData);
    } catch (e) {
      state = state.copyWith(
          errorMessage: 'Something went wrong', isLoading: false);
    }
  }

  Future<void> loadDataByDate({required String date}) async {
    filterData.clear();
    state = state.copyWith(isLoading: true);
    try {
      for (var data in allData) {
        if (data.starFilter == date) {
          filterData.add(data);
        }
      }
      state = CashFlowState.success(filterData);
    } catch (e) {
      state = state.copyWith(
          errorMessage: 'Something went wrong', isLoading: false);
    }
  }
}

class CashFlowState {
  final bool isLoading;
  final String? errorMessage;
  final List<CashFlowModel> datas;

  CashFlowState(
      {required this.isLoading, this.errorMessage, required this.datas});

  factory CashFlowState.initial() => CashFlowState(isLoading: false, datas: []);

  factory CashFlowState.success(List<CashFlowModel> datas) =>
      CashFlowState(isLoading: false, datas: datas, errorMessage: null);

  CashFlowState copyWith(
      {bool? isLoading, String? errorMessage, List<CashFlowModel>? datas}) {
    return CashFlowState(
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage ?? this.errorMessage,
        datas: datas ?? this.datas);
  }
}
