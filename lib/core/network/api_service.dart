import 'package:starman/core/config/fusion_config.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final baseUrl = "https://api.fusionmyanmar.com/rest/starman";
  final starGroup = "/getStarGroup";
  final lastSubscription = "/getLastSubscription";

  Future<http.Response> getStarGroup({required String starID}) async {
    final uri = Uri.parse("$baseUrl/$starGroup?starId=$starID");
    var header = await FusionConfig.getHeader();
    return await http.post(uri, headers: header);
  }

  Future<http.Response> getLastSubscription({required String starID}) async {
    final uri = Uri.parse("$baseUrl/$lastSubscription?starId=$starID");
    var header = await FusionConfig.getHeader();
    return await http.post(uri, headers: header);
  }
}
