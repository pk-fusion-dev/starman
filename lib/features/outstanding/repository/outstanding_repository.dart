import 'package:starman/core/network/api_service.dart';
import 'package:http/http.dart' as http;

class OutstandingRepository {
  ApiService apiService;
  OutstandingRepository({required this.apiService});

  Future<http.Response> getOutstandingReport(
      {required Map<String, String> params}) async {
    return await apiService.getOstReport(params: params);
  }
}
