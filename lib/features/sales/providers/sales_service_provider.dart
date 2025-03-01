import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starman/core/network/api_service.dart';
import 'package:starman/core/network/starman_api.dart';
import 'package:starman/features/sales/repository/sales_repository.dart';
import 'package:starman/features/sales/services/sales_service.dart';

part 'sales_service_provider.g.dart';

@riverpod
SalesRepository salesRepository(Ref ref) {
  ApiService apiService = ref.read(apiServiceProvider);
  return SalesRepository(apiService: apiService);
}

@riverpod
SalesService salesService(Ref ref) {
  SalesRepository salesRepository = ref.read(salesRepositoryProvider);
  return SalesService(salesRepository: salesRepository);
}
