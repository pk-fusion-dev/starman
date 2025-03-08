import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starman/components/custom_card.dart';
import 'package:starman/components/custom_drawer.dart';
import 'package:starman/components/loading_indicator.dart';
import 'package:starman/components/shop_dropdown.dart';
import 'package:starman/features/outstanding/models/outstanding_supplier_module.dart';
import 'package:starman/features/outstanding/viewmodel/outstanding_supplier_vm.dart';

import '../../star_links/providers/star_links_provider.dart';

class OutstandingSupplierScreen extends ConsumerStatefulWidget {
  const OutstandingSupplierScreen({super.key});

  @override
  ConsumerState<OutstandingSupplierScreen> createState() =>
      _OutstandingSupplierScreenState();
}

class _OutstandingSupplierScreenState
    extends ConsumerState<OutstandingSupplierScreen> {
  String? selectedShop;
  SharedPreferences? prefs;
  double totalStock = 0;
  double totalAmount = 0;
  String? lastSyncDate = '';

  @override
  void initState() {
    super.initState();
    Future.delayed(Durations.medium1, () async {
      ref.read(outstandingSupplierVmProvider.notifier).loadData();
      prefs = await SharedPreferences.getInstance();
    });
  }

  @override
  Widget build(BuildContext context) {
    final OutstandingSupplierState outstandingCustomerState =
        ref.watch(outstandingSupplierVmProvider);
    var shopList = ref.watch(starLinksProvider);
    if (prefs != null && selectedShop == null) {
      selectedShop = prefs?.getString("os_Shop");
      lastSyncDate = prefs?.getString("os_Date") ?? '';
      if (selectedShop == null && shopList.isNotEmpty) {
        selectedShop = ref.read(starLinksProvider.notifier).getInitShop();
      }
    }
    if (outstandingCustomerState.errorMessage != null) {
      Fluttertoast.showToast(
          msg: "လုပ်ဆောင်မှုမအောင်မြင်ပါ",
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ပေးရန်ရှိအစီရင်ခံစာ",
        ),
        actions: [
          IconButton(
            onPressed: () async {
              if (selectedShop == null) {
                Fluttertoast.showToast(msg: "Please select the shop...");
              } else {
                prefs?.setString("os_Shop", selectedShop!);
                DateTime lastDate = DateTime.now();
                lastSyncDate =
                    DateFormat('yyyy-MM-dd h:m:s a').format(lastDate);
                prefs?.setString("os_Date", lastSyncDate!);
                await ref
                    .read(outstandingSupplierVmProvider.notifier)
                    .fetchData(
                        params: {"user_id": selectedShop!, "type": "OS"});
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

  Widget _buildBody(OutstandingSupplierState state) {
    double totalCustomer = 0;
    double totalAmount = 0;
    String currency = '';
    if (state.outstandingList.isNotEmpty) {
      totalCustomer = state.outstandingList.length.toDouble();
      totalAmount = state.datas[0].starPayableTotal!;
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
                        const Text("ကုန်ရောင်းသူအရေအတွက်"),
                        Text(
                          formatedDecimal(totalCustomer),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("ပေးရန်လက်ကျန်ငွေစုစုပေါင်း"),
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
                          currency: currency,
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

  Widget listItem(
      {required int no,
      required StarOutstandingList models,
      required String currency}) {
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
                  Text("${formatedDecimal(models.starBalance)} $currency"),
                  Text(models.starAddress),
                ],
              )),
        ],
      ),
    );
  }
}
