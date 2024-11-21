import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starman/components/custom_card.dart';
import 'package:starman/components/custom_drawer.dart';
import 'package:starman/components/fusion_date_picker.dart';
import 'package:starman/components/loading_indicator.dart';
import 'package:starman/components/shop_dropdown.dart';
import 'package:starman/features/financial/models/cash_flow_model.dart';
import 'package:starman/features/financial/viewmodel/cash_flow_vm.dart';

class CashFlowScreen extends ConsumerStatefulWidget {
  const CashFlowScreen({super.key});

  @override
  ConsumerState<CashFlowScreen> createState() => _CashFlowScreenState();
}

class _CashFlowScreenState extends ConsumerState<CashFlowScreen> {
  String? selectedShop;
  String? selectedDate;
  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    Future.delayed(Durations.medium1, () async {
      ref.read(cashFlowVmProvider.notifier).loadData();
      prefs = await SharedPreferences.getInstance();
    });
  }

  @override
  Widget build(BuildContext context) {
    final CashFlowState cashFlowState = ref.watch(cashFlowVmProvider);
    if (prefs != null && selectedShop==null) {
      selectedShop = prefs?.getString("cf_Shop");
    }
    if(cashFlowState.errorMessage!=null){
      Fluttertoast.showToast(
          msg: "Operation fails",
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ငွေအဝင်အထွက်အစီရင်ခံစာ",
        ),
        actions: [
          IconButton(
            onPressed: () async {
              if (selectedShop == null) {
                Fluttertoast.showToast(msg: "Please select the shop...");
              } else {
                selectedDate = "Today";
                prefs?.setString("cf_Shop", selectedShop!);
                await ref.read(cashFlowVmProvider.notifier).fetchData(
                    params: {"user_id": selectedShop!, "type": "CF"});
              }
            },
            icon: Icon(
              Icons.cloud_download,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: Stack(
        children: [
          _buildBody(cashFlowState),
          cashFlowState.isLoading ? const LoadingWidget() : Container(),
        ],
      ),
    );
  }

  Widget _buildBody(CashFlowState state) {
    final CashFlowModel data =
        state.datas.isNotEmpty ? state.datas[0] : CashFlowModel();
    String totalIn = '0';
    String totalOut = '0';
    String total = '0';
    String currency = data.starCurrency ?? '';
    if (data.starTotalCashIn != null) {
      totalIn = data.starTotalCashIn!.toStringAsFixed(3);
      totalIn = totalIn.contains('.')
          ? totalIn.replaceAll(RegExp(r'\.?0+$'), '')
          : totalIn;
    }
    if (data.starTotalCashOut != null) {
      totalOut = data.starTotalCashOut!.toStringAsFixed(3);
      totalOut = totalOut.contains('.')
          ? totalOut.replaceAll(RegExp(r'\.?0+$'), '')
          : totalOut;
    }
    if (data.starTotal != null) {
      total = data.starTotal!.toStringAsFixed(3);
      total =
          total.contains('.') ? total.replaceAll(RegExp(r'\.?0+$'), '') : total;
    }
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShopDropdown(
                selectedItem: selectedShop,
                onSelected: (value) {
                  setState(() {
                    selectedShop = value;
                  });
                },
              ),
              FusionDatePick(
                selectedDate: selectedDate,
                onSelected: (value) {
                  ref
                      .read(cashFlowVmProvider.notifier)
                      .loadDataByDate(date: value!);
                  setState(() {
                    selectedDate = value;
                  });
                },
              ),
            ],
          ),
          Expanded(
            child: CustomCard(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const Text("စုစုပေါင်းငွေအဝင်"),
                      Text("$totalIn $currency")
                    ],
                  ),
                  Column(
                    children: [
                      const Text("စုစုပေါင်းငွေအထွက်"),
                      Text("$totalOut $currency"),
                    ],
                  ),
                ],
              ),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ExpansionTile(
                          title: Text(
                            "ငွေအဝင်",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          children: [
                            listItem("ရောင်းရငွေ", data.starSalesAmount ?? 0),
                            listItem("အခြားဝင်ငွေ", data.starOtherIncome ?? 0),
                            listItem("ကုန်ဝယ်သူမှပေးချေငွေ",
                                data.starCustomerPayment ?? 0),
                            listItem("စုစုပေါင်းငွေအဝင်", data.starTotalCashIn ?? 0),
                          ],
                        ),
                        ExpansionTile(
                          title: Text(
                            "ငွေအထွက်",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          children: [
                            listItem("ကုန်ဝယ်ငွေ", data.starPurchaseAmount ?? 0),
                            listItem("အခြားအသုံးစရိတ်", data.starOtherExpense ?? 0),
                            listItem("ကုန်ရောင်းသူအားပေးချေငွေ",
                                data.starSupplierPayment ?? 0),
                            listItem("ပိုင်ရှင်ထံအပ်ငွေ", data.starDepositOwner ?? 0,
                                isOut: true),
                            listItem(
                                "စုစုပေါင်းငွေအထွက်", data.starTotalCashOut ?? 0),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text("Total"),
                Text("$total ${data.starCurrency ?? ''}"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget listItem(String title, double value, {bool? isOut}) {
    String formatted = value.toStringAsFixed(3);
    formatted = formatted.contains('.')
        ? formatted.replaceAll(RegExp(r'\.?0+$'), '')
        : formatted;
    if (isOut ?? false) {
      formatted = "($formatted)";
    }
    return ListTile(
      titleTextStyle: Theme.of(context).textTheme.bodyMedium,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(formatted),
        ],
      ),
    );
  }
}
