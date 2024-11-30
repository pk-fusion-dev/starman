import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starman/features/financial/models/profit_loss_model.dart';
import 'package:starman/features/financial/providers/financial_service_provider.dart';
import 'package:starman/features/financial/services/financial_service.dart';

import '../../../core/utils/zip_manager.dart';
part 'profit_lose_vm.g.dart';

@riverpod
class ProfitLoseVm extends _$ProfitLoseVm {
  late final FinancialService financialService;
  List<ProfitLossModel> allData = [];
  List<ProfitLossModel> filterData = [];
  @override
  ProfitLoseState build() {
    financialService = ref.read(financialServiceProvider);
    return ProfitLoseState.initial();
  }

  Future<void> fetchData({required Map<String, String> params}) async {
    state = state.copyWith(isLoading: true,errorMessage: null);
    try {
      final datas = await financialService.getPLReport(params: params);
      allData = datas;
      state = ProfitLoseState.success(datas);
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
          await ZipManager.loadData("StarPL.json", ProfitLossModel.fromJson);
      for (var data in datas) {
        allData.add(data);
      }
      state = ProfitLoseState.success(allData);
    } catch (e) {
      state = state.copyWith(
          errorMessage: 'Something went wrong', isLoading: false
      );
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
      state = ProfitLoseState.success(filterData);
    } catch (e) {
      state = state.copyWith(
          errorMessage: 'Something went wrong', isLoading: false);
    }
  }
}

class ProfitLoseState {
  final bool isLoading;
  final String? errorMessage;
  final List<ProfitLossModel> datas;

  ProfitLoseState(
      {required this.isLoading, this.errorMessage, required this.datas});

  factory ProfitLoseState.initial() =>
      ProfitLoseState(isLoading: false, datas: []);

  factory ProfitLoseState.success(List<ProfitLossModel> datas) =>
      ProfitLoseState(isLoading: false, datas: datas, errorMessage: null);

  ProfitLoseState copyWith(
      {bool? isLoading, String? errorMessage, List<ProfitLossModel>? datas}) {
    return ProfitLoseState(
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage ?? this.errorMessage,
        datas: datas ?? this.datas);
  }
}
