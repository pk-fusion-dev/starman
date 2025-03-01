import 'package:starman/core/network/api_service.dart';
import 'package:http/http.dart' as http;

class FinancialRepository {
  ApiService apiService;
  FinancialRepository({required this.apiService});

  Future<http.Response> getFinancialReport(
      {required Map<String, String> params}) async {
    return await apiService.getFinancialReport(params: params);
  }
}
