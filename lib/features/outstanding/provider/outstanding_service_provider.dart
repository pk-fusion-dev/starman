import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starman/core/network/api_service.dart';
import 'package:starman/core/network/starman_api.dart';
import 'package:starman/features/outstanding/repository/outstanding_repository.dart';
import 'package:starman/features/outstanding/services/outstanding_service.dart';

part 'outstanding_service_provider.g.dart';

@riverpod
OutstandingRepository outstandingRepository(Ref ref) {
  ApiService apiService = ref.read(apiServiceProvider);
  return OutstandingRepository(apiService: apiService);
}

@riverpod
OutstandingService outstandingService(Ref ref) {
  OutstandingRepository outstandingRepository =
      ref.read(outstandingRepositoryProvider);
  return OutstandingService(outstandingRepository: outstandingRepository);
}
