import 'package:starman/core/network/api_service.dart';
import 'package:http/http.dart' as http;

class StarLinksRepository {
  ApiService apiService;
  StarLinksRepository({required this.apiService});

  Future<http.Response> getStarLinks({required String starID}) async {
    return apiService.getStarLinks(starID: starID);
  }
}
