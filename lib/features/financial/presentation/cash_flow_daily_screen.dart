import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starman/components/custom_card.dart';
import 'package:starman/components/custom_drawer.dart';
import 'package:starman/components/fusion_date_picker.dart';
import 'package:starman/components/loading_indicator.dart';
import 'package:starman/components/shop_dropdown.dart';
import 'package:starman/features/financial/viewmodel/cash_flow_daily_vm.dart';
import 'package:starman/features/financial/viewmodel/cash_flow_vm.dart';

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
                await ref.read(cashFlowVmProvider.notifier).fetchData(
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

  Widget _buildBody(CashFlowDailyState state) {
    // final CashFlowDailyModel data =
    //     state.datas.isNotEmpty ? state.datas[0] : CashFlowDailyModel();
    String totalIn = '0';
    // if (data.starTotalCashIn != null) {
    //   totalIn = data.starTotalCashIn!.toStringAsFixed(3);
    //   totalIn = totalIn.contains('.')
    //       ? totalIn.replaceAll(RegExp(r'\.?0+$'), '')
    //       : totalIn;
    // }
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
            child: SingleChildScrollView(
              child: CustomCard(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const Text("စုစုပေါင်းဝင်ငွေ"),
                        Text(totalIn),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("စုစုပေါင်းထွက်ငွေ"),
                        Text(totalIn),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("စုစုပေါင်းကျန်ငွေ"),
                        Text(totalIn),
                      ],
                    ),
                  ],
                ),
                children: [],
              ),
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
