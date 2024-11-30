import 'package:http/http.dart';
import 'package:starman/core/network/api_service.dart';

class LicenseRepo {
  final ApiService apiService;
  LicenseRepo({required this.apiService});

  Future<Response> getStarGroup({required String starID}) async{
    return await apiService.getStarGroup(starID: starID);
  }

  Future<Response> getLastSubscription({required String starID}) async{
    return await apiService.getLastSubscription(starID: starID);
  }
}