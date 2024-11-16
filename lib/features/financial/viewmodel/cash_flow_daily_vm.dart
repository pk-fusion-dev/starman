import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starman/features/financial/models/cash_flow_daily_model.dart';
import 'package:starman/features/financial/providers/financial_service_provider.dart';
import 'package:starman/features/financial/services/financial_service.dart';

import '../../../core/utils/zip_manager.dart';
part 'cash_flow_daily_vm.g.dart';

@riverpod
class CashFlowDailyVm extends _$CashFlowDailyVm {
  late final FinancialService financialService;
  List<CashFlowDailyModel> allData = [];
  List<CashFlowDailyModel> filterData = [];
  @override
  CashFlowDailyState build() {
    financialService = ref.read(financialServiceProvider);
    return CashFlowDailyState.initial();
  }

  Future<void> fetchData({required Map<String, String> params}) async {
    state = state.copyWith(isLoading: true);
    try {
      final datas = await financialService.getCFDailyReport(params: params);
      allData = datas;
      state = CashFlowDailyState.success(datas);
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
      var datas = await ZipManager.loadData(
          "StarCFByDate.json", CashFlowDailyModel.fromJson);
      for (var data in datas) {
        allData.add(data);
      }
      state = CashFlowDailyState.success(allData);
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
      state = CashFlowDailyState.success(filterData);
    } catch (e) {
      state = state.copyWith(
          errorMessage: 'Something went wrong', isLoading: false);
    }
  }
}

class CashFlowDailyState {
  final bool isLoading;
  final String? errorMessage;
  final List<CashFlowDailyModel> datas;

  CashFlowDailyState(
      {required this.isLoading, this.errorMessage, required this.datas});

  factory CashFlowDailyState.initial() =>
      CashFlowDailyState(isLoading: false, datas: []);

  factory CashFlowDailyState.success(List<CashFlowDailyModel> datas) =>
      CashFlowDailyState(isLoading: false, datas: datas, errorMessage: null);

  CashFlowDailyState copyWith(
      {bool? isLoading,
      String? errorMessage,
      List<CashFlowDailyModel>? datas}) {
    return CashFlowDailyState(
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage ?? this.errorMessage,
        datas: datas ?? this.datas);
  }
}
