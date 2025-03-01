import 'package:http/http.dart' as http;
import '../repository/star_links_repository.dart';

class StarLinksService {
  StarLinksRepository starLinksRepository;
  StarLinksService({required this.starLinksRepository});

  Future<http.Response> getStarLinks({required String starID}) async {
    return starLinksRepository.getStarLinks(starID: starID);
  }
}
