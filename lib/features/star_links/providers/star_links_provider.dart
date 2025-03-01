import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starman/core/network/api_service.dart';
import '../models/star_link_model.dart';
import '../repository/star_links_repository.dart';
import '../services/star_links_service.dart';

final starLinksProvider =
    NotifierProvider<StarLinksProvider, List<StarLinksModel>>(() {
  return StarLinksProvider();
});

class StarLinksProvider extends Notifier<List<StarLinksModel>> {
  @override
  build() => <StarLinksModel>[];

  String getInitShop(){
    if(state.isNotEmpty){
      return state[0].userId.toString();
    }
    return '';
  }

  Future<void> getStarLinks() async {
    state.clear();
    List<StarLinksModel> lists = [];
    ApiService apiService = ApiService();
    StarLinksRepository starLinksRepository =
        StarLinksRepository(apiService: apiService);
    StarLinksService starLinksService =
        StarLinksService(starLinksRepository: starLinksRepository);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final starID = prefs.getString("starID");
    var datas = await starLinksService.getStarLinks(starID: starID!);
    if (datas.statusCode == 200) {
      for (var data in jsonDecode(datas.body)) {
        lists.add(StarLinksModel.fromJson(data));
      }
      state = lists;
    }
  }
}
