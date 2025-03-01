import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starman/core/network/api_service.dart';

part 'starman_api.g.dart';

@riverpod
ApiService apiService(Ref ref){
  return ApiService();
}