import 'package:starman/core/config/fusion_config.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final baseUrl = "https://api.fusionmyanmar.com/rest/starman";
  final starGroup = "/getStarGroup";
  final starLinks = "/getStarLinks";
  final lastSubscription = "/getLastSubscription";
  final financialReport = "/downloadFinancialReport";
  final saleReport = "/downloadSaleReport";
  final purchaseReport = "/downloadPurchaseReport";
  final stockReport = "/downloadStockReport";
  final ostReport = "/downloadOstReport";

  Future<http.Response> getStarGroup({required String starID}) async {
    final uri = Uri.parse("$baseUrl/$starGroup?starId=$starID");
    var header = await FusionConfig.getHeader();
    return await http.post(uri, headers: header);
  }

  Future<http.Response> getStarLinks({required String starID}) async {
    final uri = Uri.parse("$baseUrl/$starLinks?starId=$starID");
    var header = await FusionConfig.getHeader();
    return await http.post(uri, headers: header);
  }

  Future<http.Response> getLastSubscription({required String starID}) async {
    final uri = Uri.parse("$baseUrl/$lastSubscription?starId=$starID");
    var header = await FusionConfig.getHeader();
    return await http.post(uri, headers: header);
  }

  Future<http.Response> getFinancialReport(
      {required Map<String, String> params}) async {
    final uri = Uri.https(
      "api.fusionmyanmar.com",
      "/rest/starman$financialReport",
      params,
    );
    var header = await FusionConfig.getHeader();
    return await http.post(uri, headers: header);
  }

  Future<http.Response> getSalesReport(
      {required Map<String, String> params}) async {
    final uri = Uri.https(
      "api.fusionmyanmar.com",
      "/rest/starman$saleReport",
      params,
    );
    var header = await FusionConfig.getHeader();
    return await http.post(uri, headers: header);
  }

  Future<http.Response> getPurchaseReport(
      {required Map<String, String> params}) async {
    final uri = Uri.https(
      "api.fusionmyanmar.com",
      "/rest/starman$purchaseReport",
      params,
    );
    var header = await FusionConfig.getHeader();
    return await http.post(uri, headers: header);
  }

  Future<http.Response> getStockReport(
      {required Map<String, String> params}) async {
    final uri = Uri.https(
      "api.fusionmyanmar.com",
      "/rest/starman$stockReport",
      params,
    );
    var header = await FusionConfig.getHeader();
    return await http.post(uri, headers: header);
  }

  Future<http.Response> getOstReport(
      {required Map<String, String> params}) async {
    final uri = Uri.https(
      "api.fusionmyanmar.com",
      "/rest/starman$ostReport",
      params,
    );
    var header = await FusionConfig.getHeader();
    return await http.post(uri, headers: header);
  }
}
