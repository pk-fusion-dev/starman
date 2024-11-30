import 'package:starman/core/network/api_service.dart';
import 'package:http/http.dart' as http;

class PurchaseRepository {
  ApiService apiService;
  PurchaseRepository({required this.apiService});

  Future<http.Response> getPurchaseReport(
      {required Map<String, String> params}) async {
    return await apiService.getPurchaseReport(params: params);
  }
}
