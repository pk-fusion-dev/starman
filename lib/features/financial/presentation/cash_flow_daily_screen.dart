import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starman/components/custom_card.dart';
import 'package:starman/components/custom_drawer.dart';
import 'package:starman/components/fusion_date_picker.dart';
import 'package:starman/components/loading_indicator.dart';
import 'package:starman/components/shop_dropdown.dart';
import 'package:starman/features/financial/models/cash_flow_daily_model.dart';
import 'package:starman/features/financial/viewmodel/cash_flow_daily_vm.dart';

class CashFlowDailyScreen extends ConsumerStatefulWidget {
  const CashFlowDailyScreen({super.key});

  @override
  ConsumerState<CashFlowDailyScreen> createState() =>
      _CashFlowDailyScreenState();
}

class _CashFlowDailyScreenState extends ConsumerState<CashFlowDailyScreen> {
  String? selectedShop;
  String? selectedDate;
  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    Future.delayed(Durations.medium1, () async {
      ref.read(cashFlowDailyVmProvider.notifier).loadData();
      prefs = await SharedPreferences.getInstance();
    });
  }

  @override
  Widget build(BuildContext context) {
    final CashFlowDailyState cashFlowDailyState =
        ref.watch(cashFlowDailyVmProvider);
    if (prefs != null) {
      selectedShop = prefs?.getString("lastShop");
    }
    if(cashFlowDailyState.errorMessage!=null){
      Fluttertoast.showToast(
          msg: "Operation fails",
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "နေ့အလိုက်ငွေအဝင်အထွက်အစီရင်ခံစာ",
        ),
        actions: [
          IconButton(
            onPressed: () async {
              if (selectedShop == null) {
                Fluttertoast.showToast(msg: "Please select the shop...");
              } else {
                selectedDate = "Today";
                await ref.read(cashFlowDailyVmProvider.notifier).fetchData(
                    params: {"user_id": selectedShop!, "type": "CFD"});
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
          _buildBody(cashFlowDailyState),
          cashFlowDailyState.isLoading ? const LoadingWidget() : Container(),
        ],
      ),
    );
  }

  String formatedDecimal(num? num){
    if(num!=null){
      String formatedNum = num.toStringAsFixed(3);
      formatedNum = formatedNum.contains('.')
          ? formatedNum.replaceAll(RegExp(r'\.?0+$'), '')
          : formatedNum;
      return formatedNum;
    }
    return "0";
  }

  Widget _buildBody(CashFlowDailyState state) {
    final CashFlowDailyModel data =
        state.datas.isNotEmpty ? state.datas[0] : CashFlowDailyModel();
    String totalIn = formatedDecimal(data.starTotalIncome);
    String totalExp = formatedDecimal(data.starTotalExpense);
    String totalBalance = formatedDecimal(data.starTotalBalance);
    String currency = data.starCurrency ?? '';
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
                    prefs?.setString("lastShop", value!);
                  });
                },
              ),
              FusionDatePick(
                selectedDate: selectedDate,
                onSelected: (value) {
                  ref
                      .read(cashFlowDailyVmProvider.notifier)
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
                      const Text("စုစုပေါင်းဝင်ငွေ"),
                      Text("$totalIn $currency"),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("စုစုပေါင်းထွက်ငွေ"),
                      Text("$totalExp $currency"),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("စုစုပေါင်းကျန်ငွေ"),
                      Text("$totalBalance $currency"),
                    ],
                  ),
                ],
              ),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListTile(
                          titleTextStyle: Theme.of(context).textTheme.bodyMedium,
                          title: const Row(
                            children: [
                              Expanded(child: Text("စဉ်")),
                              Expanded(flex: 3,child: Text("နေ့စွဲ")),
                              Expanded(flex: 2,child: Text("ဝင်ငွေ")),
                              Expanded(flex: 2,child: Text("ထွက်ငွေ")),
                              Expanded(flex: 2,child: Text("ကျန်ငွေ")),
                            ],
                          ),
                        ),
                        if(data.starCFByDateDetailList != null)
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: data.starCFByDateDetailList!.length,
                            itemBuilder: (context,index){
                              var item = data.starCFByDateDetailList![index];
                              return listItem(
                                no: index,
                                date: item.starDate,
                                income: item.starIncome,
                                expense: item.starExpense,
                                balance: item.starBalance,
                              );
                            },
                          )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget listItem({int? no,String? date,double? income,double? expense,double? balance}) {
    return ListTile(
      titleTextStyle: Theme.of(context).textTheme.bodySmall,
      textColor: Theme.of(context).colorScheme.secondary,
      title: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(no.toString())),
          Expanded(flex: 3,child: Text(date!)),
          Expanded(flex: 2,child: Text(formatedDecimal(income))),
          Expanded(flex: 2,child: Text(formatedDecimal(expense))),
          Expanded(flex: 2,child: Text(formatedDecimal(balance))),
        ],
      ),
    );
  }
}
