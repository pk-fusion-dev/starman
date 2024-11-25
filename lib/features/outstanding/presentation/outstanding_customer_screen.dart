import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starman/components/custom_card.dart';
import 'package:starman/components/custom_drawer.dart';
import 'package:starman/components/loading_indicator.dart';
import 'package:starman/components/shop_dropdown.dart';
import 'package:starman/features/outstanding/models/outstanding_customer_module.dart';
import 'package:starman/features/outstanding/viewmodel/outstanding_customer_vm.dart';

class OutstandingCustomerScreen extends ConsumerStatefulWidget {
  const OutstandingCustomerScreen({super.key});

  @override
  ConsumerState<OutstandingCustomerScreen> createState() =>
      _OutstandingCustomerScreenState();
}

class _OutstandingCustomerScreenState
    extends ConsumerState<OutstandingCustomerScreen> {
  String? selectedShop;
  SharedPreferences? prefs;
  double totalStock = 0;
  double totalAmount = 0;
  String? lastSyncDate = '';

  @override
  void initState() {
    super.initState();
    Future.delayed(Durations.medium1, () async {
      ref.read(outstandingCustomerVmProvider.notifier).loadData();
      prefs = await SharedPreferences.getInstance();
    });
  }

  @override
  Widget build(BuildContext context) {
    final OutstandingCustomerState outstandingCustomerState =
        ref.watch(outstandingCustomerVmProvider);
    if (prefs != null && selectedShop==null) {
      selectedShop = prefs?.getString("oc_Shop");
      lastSyncDate = prefs?.getString("oc_Date") ?? '';
    }
    if (outstandingCustomerState.errorMessage != null) {
      Fluttertoast.showToast(
          msg: "Operation fails",
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ရရန်ရှိအစီရင်ခံစာ",
        ),
        actions: [
          IconButton(
            onPressed: () async {
              if (selectedShop == null) {
                Fluttertoast.showToast(msg: "Please select the shop...");
              } else {
                prefs?.setString("oc_Shop", selectedShop!);
                DateTime lastDate = DateTime.now();
                lastSyncDate = DateFormat('yyyy-MM-dd h:m:s a').format(lastDate);
                prefs?.setString("oc_Date", lastSyncDate!);
                await ref
                    .read(outstandingCustomerVmProvider.notifier)
                    .fetchData(
                        params: {"user_id": selectedShop!, "type": "OC"});
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
          _buildBody(outstandingCustomerState),
          outstandingCustomerState.isLoading
              ? const LoadingWidget()
              : Container(),
        ],
      ),
    );
  }

  String formatedDecimal(num? num) {
    if (num != null) {
      String formatedNum = num.toStringAsFixed(3);
      formatedNum = formatedNum.contains('.')
          ? formatedNum.replaceAll(RegExp(r'\.?0+$'), '')
          : formatedNum;
      return formatedNum;
    }
    return "0";
  }

  Widget _buildBody(OutstandingCustomerState state) {
    double totalCustomer = 0;
    double totalAmount = 0;
    String currency = '';
    if (state.outstandingList.isNotEmpty) {
      totalCustomer = state.outstandingList.length.toDouble();
      totalAmount = state.datas[0].starReceivableTotal!;
      currency = state.datas[0].starCurrency!;
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
              Text(
                lastSyncDate!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: CustomCard(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text("ကုန်ဝယ်သူအရေအတွက်"),
                        Text(
                          formatedDecimal(totalCustomer),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("ရရန်လက်ကျန်ငွေစုစုပေါင်း"),
                        Text(
                          "${formatedDecimal(totalAmount)} $currency",
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ],
                ),
                children: [
                  ListTile(
                    titleTextStyle: Theme.of(context).textTheme.bodyMedium,
                    textColor: Theme.of(context).colorScheme.secondary,
                    title: const Row(
                      children: [
                        Expanded(child: Text("စဉ်")),
                        Expanded(flex: 3, child: Text("အမည်/ဖုန်းနံပါတ်")),
                        Expanded(
                            flex: 3,
                            child: Text(
                              "ကျန်ငွေ/လိပ်စာ",
                              textAlign: TextAlign.end,
                            )),
                      ],
                    ),
                  ),
                  if (state.outstandingList.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.outstandingList.length,
                      itemBuilder: (context, index) {
                        var item = state.outstandingList[index];
                        // if (item.starUserName != user) return Container();
                        return listItem(
                          no: index + 1,
                          models: item,
                        );
                      },
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget listItem({required int no, required StarOutstandingList models}) {
    return ListTile(
      titleTextStyle: Theme.of(context).textTheme.bodySmall,
      textColor: Theme.of(context).colorScheme.secondary,
      title: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(no.toString())),
          Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(models.starName),
                  Text(models.starPhone),
                ],
              )),
          Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(formatedDecimal(models.starBalance)),
                  Text(models.starAddress),
                ],
              )),
        ],
      ),
    );
  }
}
