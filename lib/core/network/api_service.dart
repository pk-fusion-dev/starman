import 'package:starman/core/config/fusion_config.dart';
import 'package:http/http.dart' as http;

class ApiService{
  var header = <String, String>{
    'Authorization': FusionConfig.basicAuth,
    'SECRET_ACCESS_TOKEN': FusionConfig.token
  };
}