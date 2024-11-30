import 'dart:convert';
import 'package:starman/features/license/model/last_sub_model.dart';
import 'package:starman/features/license/model/star_group_model.dart';
import 'package:starman/features/license/repository/license_repo.dart';

class LicenseService {
  final LicenseRepo licenseRepo;
  LicenseService({required this.licenseRepo});

  Future<StarGroupModel> getStarGroup({required String starID}) async {
    var resp = await licenseRepo.getStarGroup(starID: starID);
    if (resp.statusCode == 404) {
      return StarGroupModel();
    } else {
      return StarGroupModel.fromJson(jsonDecode(resp.body));
    }
  }

  Future<LastSubscriptionModel> getLastSubscription(
      {required String starID}) async {
    var resp = await licenseRepo.getLastSubscription(starID: starID);
    return LastSubscriptionModel.fromJson(jsonDecode(resp.body));
  }
}
