import 'package:starman/core/network/api_service.dart';
import 'package:http/http.dart' as http;

class SalesRepository {
  ApiService apiService;
  SalesRepository({required this.apiService});

  Future<http.Response> getSalesReport(
      {required Map<String, String> params}) async {
    return await apiService.getSalesReport(params: params);
  }
}
