import 'package:starman/core/utils/zip_manager.dart';
import 'package:starman/features/sales/models/sales_model.dart';
import 'package:starman/features/sales/models/sold_item_model.dart';
import 'package:starman/features/sales/repository/sales_repository.dart';

class SalesService {
  SalesRepository salesRepository;
  SalesService({required this.salesRepository});

  Future<List<SalesModel>> getNSReport(
      {required Map<String, String> params}) async {
    List<SalesModel> finalDatas = [];
    var response = await salesRepository.getSalesReport(params: params);
    var zipFile = await ZipManager.saveZip(response);
    await ZipManager.extractZipFile(zipFile!);
    var datas = await ZipManager.loadData("StarNS.json", SalesModel.fromJson);
    for (var data in datas) {
      finalDatas.add(data);
    }
    return finalDatas;
  }

  Future<List<SoldItemModel>> getSIReport(
      {required Map<String, String> params}) async {
    List<SoldItemModel> finalDatas = [];
    var response = await salesRepository.getSalesReport(params: params);
    var zipFile = await ZipManager.saveZip(response);
    await ZipManager.extractZipFile(zipFile!);
    var datas =
        await ZipManager.loadData("StarSI.json", SoldItemModel.fromJson);
    for (var data in datas) {
      finalDatas.add(data);
    }
    return finalDatas;
  }
}
