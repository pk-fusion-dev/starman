import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starman/core/network/api_service.dart';
import 'package:starman/core/network/starman_api.dart';
import 'package:starman/features/license/repository/license_repo.dart';
import 'package:starman/features/license/service/license_service.dart';

part 'license_service_provider.g.dart';

@riverpod
LicenseRepo licenseRepo(Ref ref){
  final ApiService apiService = ref.read(apiServiceProvider);
  return LicenseRepo(apiService: apiService);
}

@riverpod
LicenseService licenseService(Ref ref){
  final LicenseRepo licenseRepo = ref.read(licenseRepoProvider);
  return LicenseService(licenseRepo: licenseRepo);
}