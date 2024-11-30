import 'package:starman/core/utils/zip_manager.dart';
import 'package:starman/features/purchase/models/purchase_item_model.dart';
import 'package:starman/features/purchase/models/purchase_model.dart';
import 'package:starman/features/purchase/repository/purchase_repository.dart';

class PurchaseService {
  PurchaseRepository purchaseRepository;
  PurchaseService({required this.purchaseRepository});

  Future<List<PurchaseModel>> getNPReport(
      {required Map<String, String> params}) async {
    List<PurchaseModel> finalDatas = [];
    var response = await purchaseRepository.getPurchaseReport(params: params);
    var zipFile = await ZipManager.saveZip(response);
    await ZipManager.extractZipFile(zipFile!);
    var datas =
        await ZipManager.loadData("StarNP.json", PurchaseModel.fromJson);
    for (var data in datas) {
      finalDatas.add(data);
    }
    return finalDatas;
  }

  Future<List<PurchaseItemModel>> getPIReport(
      {required Map<String, String> params}) async {
    List<PurchaseItemModel> finalDatas = [];
    var response = await purchaseRepository.getPurchaseReport(params: params);
    var zipFile = await ZipManager.saveZip(response);
    await ZipManager.extractZipFile(zipFile!);
    var datas =
        await ZipManager.loadData("StarPI.json", PurchaseItemModel.fromJson);
    for (var data in datas) {
      finalDatas.add(data);
    }
    return finalDatas;
  }
}
