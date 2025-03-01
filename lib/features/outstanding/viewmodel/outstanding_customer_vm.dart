import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starman/features/outstanding/models/outstanding_customer_module.dart';
import 'package:starman/features/outstanding/provider/outstanding_service_provider.dart';
import 'package:starman/features/outstanding/services/outstanding_service.dart';
import '../../../core/utils/zip_manager.dart';
// ignore: unused_import
import 'dart:developer';
part 'outstanding_customer_vm.g.dart';

@riverpod
class OutstandingCustomerVm extends _$OutstandingCustomerVm {
  late final OutstandingService outstandingService;
  List<OutstandingCustomerModel> allData = [];
  List<StarOutstandingList> allList = [];
  @override
  OutstandingCustomerState build() {
    outstandingService = ref.read(outstandingServiceProvider);
    return OutstandingCustomerState.initial();
  }

  Future<void> fetchData({required Map<String, String> params}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final datas = await outstandingService.getOCReport(params: params);
      allData = datas;
      allList = allData[0].starOutstandingList!;
      state = OutstandingCustomerState.success(
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
        "StarOC.json",
        OutstandingCustomerModel.fromJson,
      );
      for (var data in datas) {
        allData.add(data);
      }
      allList = allData[0].starOutstandingList!;
      state = OutstandingCustomerState.success(
        allData,
        allList,
      );
    } on RangeError catch (_) {
      state = state.copyWith(isLoading: false);
    } catch (e) {
      // print(e.toString());
      state = state.copyWith(
          errorMessage: 'Something went wrong', isLoading: false);
    }
  }
}

class OutstandingCustomerState {
  final bool isLoading;
  final String? errorMessage;
  final List<OutstandingCustomerModel> datas;
  final List<StarOutstandingList> outstandingList;

  OutstandingCustomerState({
    required this.isLoading,
    this.errorMessage,
    required this.datas,
    required this.outstandingList,
  });

  factory OutstandingCustomerState.initial() => OutstandingCustomerState(
        isLoading: false,
        datas: [],
        outstandingList: [],
      );

  factory OutstandingCustomerState.success(List<OutstandingCustomerModel> datas,
          List<StarOutstandingList> outstandingList) =>
      OutstandingCustomerState(
        isLoading: false,
        datas: datas,
        outstandingList: outstandingList,
        errorMessage: null,
      );

  OutstandingCustomerState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<OutstandingCustomerModel>? datas,
    List<StarOutstandingList>? outstandingList,
  }) {
    return OutstandingCustomerState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      datas: datas ?? this.datas,
      outstandingList: outstandingList ?? this.outstandingList,
    );
  }
}
