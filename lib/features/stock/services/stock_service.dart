import 'package:starman/core/utils/zip_manager.dart';
import 'package:starman/features/stock/models/stock_balance_model.dart';
import 'package:starman/features/stock/models/stock_reorder_model.dart';
import 'package:starman/features/stock/repository/stock_repository.dart';

class StockService {
  StockRepository stockRepository;
  StockService({required this.stockRepository});

  Future<List<StockReorderModel>> getSRReport(
      {required Map<String, String> params}) async {
    List<StockReorderModel> finalDatas = [];
    var response = await stockRepository.getStockReport(params: params);
    var zipFile = await ZipManager.saveZip(response);
    await ZipManager.extractZipFile(zipFile!);
    var datas =
        await ZipManager.loadData("StarSR.json", StockReorderModel.fromJson);
    for (var data in datas) {
      finalDatas.add(data);
    }
    return finalDatas;
  }

  Future<List<StockBalanceModel>> getSBReport(
      {required Map<String, String> params}) async {
    List<StockBalanceModel> finalDatas = [];
    var response = await stockRepository.getStockReport(params: params);
    var zipFile = await ZipManager.saveZip(response);
    await ZipManager.extractZipFile(zipFile!);
    var datas = await ZipManager.loadDataStockBalance(
      "StarSB.json",
      StockBalanceModel.fromJson,
    );
    for (var data in datas) {
      finalDatas.add(data);
    }
    return finalDatas;
  }
}
