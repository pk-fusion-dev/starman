import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starman/core/network/api_service.dart';
import 'package:starman/core/network/starman_api.dart';
import 'package:starman/features/financial/repository/financial_repository.dart';
import 'package:starman/features/financial/services/financial_service.dart';

part 'financial_service_provider.g.dart';

@riverpod
FinancialRepository financialRepository(Ref ref) {
  ApiService apiService = ref.read(apiServiceProvider);
  return FinancialRepository(apiService: apiService);
}

@riverpod
FinancialService financialService(Ref ref) {
  FinancialRepository financialRepository =
      ref.read(financialRepositoryProvider);
  return FinancialService(financialRepository: financialRepository);
}
