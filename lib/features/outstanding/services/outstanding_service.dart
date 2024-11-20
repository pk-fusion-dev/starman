import 'package:starman/core/utils/zip_manager.dart';
import 'package:starman/features/outstanding/models/outstanding_customer_module.dart';
import 'package:starman/features/outstanding/models/outstanding_supplier_module.dart';
import 'package:starman/features/outstanding/repository/outstanding_repository.dart';

class OutstandingService {
  OutstandingRepository outstandingRepository;
  OutstandingService({required this.outstandingRepository});

  Future<List<OutstandingCustomerModel>> getOCReport(
      {required Map<String, String> params}) async {
    List<OutstandingCustomerModel> finalDatas = [];
    var response =
        await outstandingRepository.getOutstandingReport(params: params);
    var zipFile = await ZipManager.saveZip(response);
    await ZipManager.extractZipFile(zipFile!);
    var datas = await ZipManager.loadDataStockBalance(
      "StarOC.json",
      OutstandingCustomerModel.fromJson,
    );
    for (var data in datas) {
      finalDatas.add(data);
    }
    return finalDatas;
  }

  Future<List<OutstandingSupplierModel>> getOSReport(
      {required Map<String, String> params}) async {
    List<OutstandingSupplierModel> finalDatas = [];
    var response =
        await outstandingRepository.getOutstandingReport(params: params);
    var zipFile = await ZipManager.saveZip(response);
    await ZipManager.extractZipFile(zipFile!);
    var datas = await ZipManager.loadDataStockBalance(
        "StarOS.json", OutstandingSupplierModel.fromJson);
    for (var data in datas) {
      finalDatas.add(data);
    }
    return finalDatas;
  }
}
