import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starman/core/network/api_service.dart';
import 'package:starman/core/network/starman_api.dart';
import 'package:starman/features/purchase/repository/purchase_repository.dart';
import 'package:starman/features/purchase/services/purchase_service.dart';

part 'purchase_service_provider.g.dart';

@riverpod
PurchaseRepository purchaseRepository(Ref ref) {
  ApiService apiService = ref.read(apiServiceProvider);
  return PurchaseRepository(apiService: apiService);
}

@riverpod
PurchaseService purchaseService(Ref ref) {
  PurchaseRepository purchaseRepository = ref.read(purchaseRepositoryProvider);
  return PurchaseService(purchaseRepository: purchaseRepository);
}
