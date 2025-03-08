import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FusionConfig {
  static Future<Map<String, String>> getHeader() async {
    await dotenv.load(fileName: ".env");
    String userName = dotenv.env['FUSION_USERNAME']!;
    String password = dotenv.env['FUSION_PASSWORD']!;
    String token = dotenv.env['FUSION_TOKEN']!;
    String basicAuth =
        'Basic ${base64.encode(utf8.encode('$userName:$password'))}';
    return {
      "Authorization": basicAuth,
      "SECRET_ACCESS_TOKEN": token,
    };
  }
}
