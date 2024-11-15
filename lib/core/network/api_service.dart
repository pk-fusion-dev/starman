import 'package:starman/core/config/fusion_config.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final baseUrl = "https://api.fusionmyanmar.com/rest/starman";
  final starGroup = "/getStarGroup";
  final lastSubscription = "/getLastSubscription";

  var header = <String, String>{
    'Authorization': FusionConfig.basicAuth,
    'SECRET_ACCESS_TOKEN': FusionConfig.token
  };

  Future<http.Response> getStarGroup({required String starID}) async {
    final uri = Uri.parse("$baseUrl/$starGroup?starId=$starID");
    return await http.post(uri, headers: header);
  }

  Future<http.Response> getLastSubscription({required String starID}) async {
    final uri = Uri.parse("$baseUrl/$lastSubscription?starId=$starID");
    return await http.post(uri, headers: header);
  }
}
