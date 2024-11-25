import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starman/features/outstanding/models/outstanding_supplier_module.dart';
import 'package:starman/features/outstanding/provider/outstanding_service_provider.dart';
import 'package:starman/features/outstanding/services/outstanding_service.dart';
import '../../../core/utils/zip_manager.dart';
// ignore: unused_import
import 'dart:developer';
part 'outstanding_supplier_vm.g.dart';

@riverpod
class OutstandingSupplierVm extends _$OutstandingSupplierVm {
  late final OutstandingService outstandingService;
  List<OutstandingSupplierModel> allData = [];
  List<StarOutstandingList> allList = [];
  @override
  OutstandingSupplierState build() {
    outstandingService = ref.read(outstandingServiceProvider);
    return OutstandingSupplierState.initial();
  }

  Future<void> fetchData({required Map<String, String> params}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final datas = await outstandingService.getOSReport(params: params);
      allData = datas;
      allList = allData[0].starOutstandingList!;
      state = OutstandingSupplierState.success(
        datas,
        allList,
      );
    } catch (e) {
      // print(e.toString());
      state = state.copyWith(
        errorMessage: 'Something went wrong',
        isLoading: false,
      );
    }
  }

  Future<void> loadData() async {
    state = state.copyWith(isLoading: true);
    try {
      var datas = await ZipManager.loadDataStockBalance(
        "StarOS.json",
        OutstandingSupplierModel.fromJson,
      );
      for (var data in datas) {
        allData.add(data);
      }
      allList = allData[0].starOutstandingList!;
      state = OutstandingSupplierState.success(
        allData,
        allList,
      );
    }on RangeError catch(e){
      state = state.copyWith(isLoading: false);
    }catch (e) {
      // print(e.toString());
      state = state.copyWith(
          errorMessage: 'Something went wrong', isLoading: false);
    }
  }
}

class OutstandingSupplierState {
  final bool isLoading;
  final String? errorMessage;
  final List<OutstandingSupplierModel> datas;
  final List<StarOutstandingList> outstandingList;

  OutstandingSupplierState({
    required this.isLoading,
    this.errorMessage,
    required this.datas,
    required this.outstandingList,
  });

  factory OutstandingSupplierState.initial() => OutstandingSupplierState(
        isLoading: false,
        datas: [],
        outstandingList: [],
      );

  factory OutstandingSupplierState.success(List<OutstandingSupplierModel> datas,
          List<StarOutstandingList> outstandingList) =>
      OutstandingSupplierState(
        isLoading: false,
        datas: datas,
        outstandingList: outstandingList,
        errorMessage: null,
      );

  OutstandingSupplierState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<OutstandingSupplierModel>? datas,
    List<StarOutstandingList>? outstandingList,
  }) {
    return OutstandingSupplierState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      datas: datas ?? this.datas,
      outstandingList: outstandingList ?? this.outstandingList,
    );
  }
}
