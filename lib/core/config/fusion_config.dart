import 'dart:convert';

class FusionConfig {
  static const String _userName = 'fusion_dev';
  static const String _password = 'fusion_dev';
  static  String basicAuth =
      'Basic ${base64.encode(utf8.encode('$_userName:$_password'))}';
  static const String token =
      "\$2a\$10\$wl2BjK4NHQwB6npW2xOWCOyFN/x3s92TKnLdSDFSVnTCuxIDg8mVG";
}
