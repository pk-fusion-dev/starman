import 'package:starman/core/network/api_service.dart';
import 'package:http/http.dart' as http;

class StockRepository {
  ApiService apiService;
  StockRepository({required this.apiService});

  Future<http.Response> getStockReport(
      {required Map<String, String> params}) async {
    return await apiService.getStockReport(params: params);
  }
}
