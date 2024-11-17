import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starman/features/financial/models/expense_model.dart';
import 'package:starman/features/financial/providers/financial_service_provider.dart';
import 'package:starman/features/financial/services/financial_service.dart';

import '../../../core/utils/zip_manager.dart';
part 'expense_vm.g.dart';

@riverpod
class ExpenseVm extends _$ExpenseVm {
  late final FinancialService financialService;
  List<ExpenseModel> allData = [];
  List<ExpenseModel> filterData = [];
  @override
  ExpenseState build() {
    financialService = ref.read(financialServiceProvider);
    return ExpenseState.initial();
  }

  Future<void> fetchData({required Map<String, String> params}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final datas = await financialService.getExpenseReport(params: params);
      allData = datas;
      state = ExpenseState.success(datas);
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
          await ZipManager.loadData("StarEXP.json", ExpenseModel.fromJson);
      for (var data in datas) {
        allData.add(data);
      }
      state = ExpenseState.success(allData);
    } catch (e) {
      state = state.copyWith(
          errorMessage: 'Something went wrong', isLoading: false);
    }
  }

  Future<void> loadDataByFilter(
      {required int type, required String date}) async {
    filterData.clear();
    state = state.copyWith(isLoading: true);
    try {
      for (var data in allData) {
        if (data.starFilter == date) {
          filterData.add(data);
        }
      }
      state = ExpenseState.success(filterData);
    } catch (e) {
      state = state.copyWith(
          errorMessage: 'Something went wrong', isLoading: false);
    }
  }
}

class ExpenseState {
  final bool isLoading;
  final String? errorMessage;
  final List<ExpenseModel> datas;

  ExpenseState(
      {required this.isLoading, this.errorMessage, required this.datas});

  factory ExpenseState.initial() => ExpenseState(isLoading: false, datas: []);

  factory ExpenseState.success(List<ExpenseModel> datas) =>
      ExpenseState(isLoading: false, datas: datas, errorMessage: null);

  ExpenseState copyWith(
      {bool? isLoading, String? errorMessage, List<ExpenseModel>? datas}) {
    return ExpenseState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      datas: datas ?? this.datas,
    );
  }
}
