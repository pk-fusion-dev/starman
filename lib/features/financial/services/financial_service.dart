import 'package:starman/core/utils/zip_manager.dart';
import 'package:starman/features/financial/models/cash_flow_daily_model.dart';
import 'package:starman/features/financial/models/cash_flow_model.dart';
import 'package:starman/features/financial/models/expense_model.dart';
import 'package:starman/features/financial/models/profit_loss_model.dart';
import 'package:starman/features/financial/repository/financial_repository.dart';

class FinancialService {
  FinancialRepository financialRepository;
  FinancialService({required this.financialRepository});

  Future<List<ProfitLossModel>> getPLReport(
      {required Map<String, String> params}) async {
    List<ProfitLossModel> finalDatas = [];
    var response = await financialRepository.getFinancialReport(params: params);
    var zipFile = await ZipManager.saveZip(response);
    await ZipManager.extractZipFile(zipFile!);
    var datas =
        await ZipManager.loadData("StarPL.json", ProfitLossModel.fromJson);
    for (var data in datas) {
      finalDatas.add(data);
    }
    return finalDatas;
  }

  Future<List<CashFlowModel>> getCFReport(
      {required Map<String, String> params}) async {
    List<CashFlowModel> finalDatas = [];
    var response = await financialRepository.getFinancialReport(params: params);
    var zipFile = await ZipManager.saveZip(response);
    await ZipManager.extractZipFile(zipFile!);
    var datas =
        await ZipManager.loadData("StarCF.json", CashFlowModel.fromJson);
    for (var data in datas) {
      finalDatas.add(data);
    }
    return finalDatas;
  }

  Future<List<CashFlowDailyModel>> getCFDailyReport(
      {required Map<String, String> params}) async {
    List<CashFlowDailyModel> finalDatas = [];
    var response = await financialRepository.getFinancialReport(params: params);
    var zipFile = await ZipManager.saveZip(response);
    await ZipManager.extractZipFile(zipFile!);
    var datas = await ZipManager.loadData(
        "StarCFByDate.json", CashFlowDailyModel.fromJson);
    for (var data in datas) {
      finalDatas.add(data);
    }
    return finalDatas;
  }

  Future<List<ExpenseModel>> getExpenseReport(
      {required Map<String, String> params}) async {
    List<ExpenseModel> finalDatas = [];
    var response = await financialRepository.getFinancialReport(params: params);
    var zipFile = await ZipManager.saveZip(response);
    await ZipManager.extractZipFile(zipFile!);
    var datas =
        await ZipManager.loadData("StarEXP.json", ExpenseModel.fromJson);
    for (var data in datas) {
      finalDatas.add(data);
    }
    return finalDatas;
  }
}
