import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starman/core/network/api_service.dart';
import 'package:starman/core/network/starman_api.dart';
import 'package:starman/features/stock/repository/stock_repository.dart';
import 'package:starman/features/stock/services/stock_service.dart';

part 'stock_service_provider.g.dart';

@riverpod
StockRepository stockRepository(Ref ref) {
  ApiService apiService = ref.read(apiServiceProvider);
  return StockRepository(apiService: apiService);
}

@riverpod
StockService stockService(Ref ref) {
  StockRepository stockRepository = ref.read(stockRepositoryProvider);
  return StockService(stockRepository: stockRepository);
}
