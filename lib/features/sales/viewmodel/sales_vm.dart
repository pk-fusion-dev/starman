import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:starman/features/sales/models/sales_model.dart';
import 'package:starman/features/sales/providers/sales_service_provider.dart';
import 'package:starman/features/sales/services/sales_service.dart';
import '../../../core/utils/zip_manager.dart';
part 'sales_vm.g.dart';

@riverpod
class SalesVm extends _$SalesVm {
  late final SalesService salesService;
  List<SalesModel> allData = [];
  List<SalesModel> filterData = [];
  List<StarNsItemList> allVoucher = [];
  List<StarNsItemList> filterVoucher = [];
  List<String> users = [];
  double totalAmount = 0;
  double totalPaidAmount = 0;
  @override
  SalesState build() {
    salesService = ref.read(salesServiceProvider);
    return SalesState.initial();
  }

  Future<void> fetchData({required Map<String, String> params}) async {
    allData.clear();
    allVoucher.clear();
    totalPaidAmount = 0;
    totalAmount = 0;
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final datas = await salesService.getNSReport(params: params);
      allData = datas;
      allVoucher = allData[0].starNsItemList!;
      for(var i in allVoucher){
        if(!users.contains(i.starUserName)){
          users.add(i.starUserName!);
        }
        totalAmount+=i.starAmount!;
        totalPaidAmount+=i.starPaidAmount!;
      }
      state = SalesState.success(datas,allVoucher,totalAmount,totalPaidAmount,users);
    } catch (e) {
      // print(e.toString());
      state = state.copyWith(
          errorMessage: 'Something went wrong', isLoading: false);
    }
  }

  Future<void> loadData() async {
    allData.clear();
    allVoucher.clear();
    totalPaidAmount = 0;
    totalAmount = 0;
    state = state.copyWith(isLoading: true);
    try {
      var datas = await ZipManager.loadData("StarNS.json", SalesModel.fromJson);
      for (var data in datas) {
        allData.add(data);
      }
      allVoucher = allData[0].starNsItemList!;
      for(var i in allVoucher){
        if(!users.contains(i.starUserName)){
          users.add(i.starUserName!);
        }
        totalAmount+=i.starAmount!;
        totalPaidAmount+=i.starPaidAmount!;
      }
      state = SalesState.success(
          allData,allVoucher,totalAmount,totalPaidAmount,users
      );
    } catch (e) {
      state = state.copyWith(
          errorMessage: 'Something went wrong', isLoading: false);
    }
  }

  Future<void> loadDataByFilter({required String date}) async {
    filterData.clear();
    totalPaidAmount = 0;
    totalAmount = 0;
    state = state.copyWith(isLoading: true);
    try {
      for (var data in allData) {
        if (data.starFiler == date) {
          filterData.add(data);
        }
      }
      allVoucher = filterData[0].starNsItemList!;
      for(var i in allVoucher){
        if(!users.contains(i.starUserName)){
          users.add(i.starUserName!);
        }
        totalAmount+=i.starAmount!;
        totalPaidAmount+=i.starPaidAmount!;
      }
      state = SalesState.success(
          filterData,allVoucher,totalAmount,totalPaidAmount,users
      );
    } catch (e) {
      state = state.copyWith(
          errorMessage: 'Something went wrong', isLoading: false);
    }
  }

  Future<void> filterVoucherByUser({required String user}) async {
    filterVoucher.clear();
    totalPaidAmount = 0;
    totalAmount = 0;
    state = state.copyWith(isLoading: true);
    try {
      for (var voucher in allVoucher) {
        if (user=="All" ||voucher.starUserName == user) {
          filterVoucher.add(voucher);
        }
      }
      for(var i in filterVoucher){
        totalAmount+=i.starAmount!;
        totalPaidAmount+=i.starPaidAmount!;
      }
      state = state.copyWith(
          vouchers: filterVoucher,
          isLoading: false,
          totalPaidAmount: totalPaidAmount,
          totalAmount: totalAmount,
      );
    } catch (e) {
      state = state.copyWith(
          errorMessage: 'Something went wrong', isLoading: false,
      );
    }
  }
}

class SalesState {
  final bool isLoading;
  final String? errorMessage;
  final List<SalesModel> datas;
  final List<StarNsItemList> vouchers;
  final double totalAmount;
  final double totalPaidAmount;
  final List<String> users;

  SalesState({
    required this.isLoading,
    this.errorMessage,
    required this.datas,
    required this.vouchers,
    required this.totalAmount,
    required this.totalPaidAmount,
    required this.users,
  });

  factory SalesState.initial() => SalesState(
      isLoading: false,
    datas: [],
    vouchers: [],
    totalAmount: 0,
    totalPaidAmount: 0,
    users: [],
  );

  factory SalesState.success(
      List<SalesModel> datas,List<StarNsItemList> vouchers,double totalAmount,double totalPaidAmount,List<String> users
      ) =>
      SalesState(
          isLoading: false,
          datas: datas,
          vouchers: vouchers,
          errorMessage: null,
          totalPaidAmount: totalAmount,
          totalAmount: totalPaidAmount,
          users: users,
      );

  SalesState copyWith(
      {bool? isLoading,
        String? errorMessage,
        List<SalesModel>? datas,
        List<StarNsItemList>? vouchers,
        double? totalAmount,
        double? totalPaidAmount,
        List<String>? users,
      }) {
    return SalesState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      datas: datas ?? this.datas,
      vouchers: vouchers ?? this.vouchers,
      totalAmount: totalAmount ?? this.totalAmount,
      totalPaidAmount: totalPaidAmount ?? this.totalPaidAmount,
      users: users ?? this.users
    );
  }
}
