import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starman/components/custom_card.dart';
import 'package:starman/components/custom_drawer.dart';
import 'package:starman/components/fusion_date_picker.dart';
import 'package:starman/components/loading_indicator.dart';
import 'package:starman/components/shop_dropdown.dart';
import 'package:starman/features/purchase/models/purchase_model.dart';
import 'package:starman/features/purchase/viewmodel/purchase_vm.dart';

class PurchaseReportScreen extends ConsumerStatefulWidget {
  const PurchaseReportScreen({super.key});

  @override
  ConsumerState<PurchaseReportScreen> createState() =>
      _PurchaseReportScreenState();
}

class _PurchaseReportScreenState extends ConsumerState<PurchaseReportScreen> {
  String? selectedShop;
  String? selectedDate;
  String user = "All";
  SharedPreferences? prefs;
  List<StarNpItemList> starNpItemList = [];
  int totalinv = 0;
  double netTotal = 0;
  double paidTotal = 0;
  List<String> userList = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Durations.medium1, () async {
      ref.read(purchaseVmProvider.notifier).loadData();
      prefs = await SharedPreferences.getInstance();
    });
  }

  @override
  Widget build(BuildContext context) {
    final PurchaseState purchaseState = ref.watch(purchaseVmProvider);
    if (prefs != null) {
      selectedShop = prefs?.getString("lastShop");
    }
    if (purchaseState.errorMessage != null) {
      Fluttertoast.showToast(
          msg: "Operation fails",
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "အဝယ်အစီရင်ခံစာ",
        ),
        actions: [
          IconButton(
            onPressed: () async {
              if (selectedShop == null) {
                Fluttertoast.showToast(msg: "Please select the shop...");
              } else {
                starNpItemList.clear();
                selectedDate = "Today";
                await ref.read(purchaseVmProvider.notifier).fetchData(
                    params: {"user_id": selectedShop!, "type": "NP"});
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
          _buildBody(purchaseState),
          purchaseState.isLoading ? const LoadingWidget() : Container(),
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

  Future<void> dataFilter(List<StarNpItemList> items) async {
    totalinv = 0;
    netTotal = 0;
    paidTotal = 0;
    if (items.isNotEmpty) {
      for (var item in items) {
        if (!userList.contains(item.starUserName)) {
          userList.add(item.starUserName!);
        }
        if (user == 'All' || item.starUserName == user) {
          starNpItemList.add(item);
          totalinv += 1;
          netTotal += item.starAmount!;
          paidTotal += item.starPaidAmount!;
        }
      }
    }
    setState(() {});
  }

  Widget _buildBody(PurchaseState state) {
    final PurchaseModel data =
        state.datas.isNotEmpty ? state.datas[0] : PurchaseModel();
    if (data.starNpItemList != null) {
      dataFilter(data.starNpItemList!);
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
                    prefs?.setString("lastShop", value!);
                  });
                },
              ),
              FusionDatePick(
                selectedDate: selectedDate,
                onSelected: (value) async {
                  starNpItemList.clear();
                  ref
                      .read(purchaseVmProvider.notifier)
                      .loadDataByFilter(date: value!);
                  setState(() {
                    selectedDate = value;
                  });
                },
              ),
            ],
          ),
          Row(
            children: [
              userDropdown(),
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
                        const Text("ပြေစာအရေအတွက်"),
                        Text(
                          totalinv.toString(),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("ကျသင့်ငွေပေါင်း"),
                        Text(
                          "$netTotal ${data.starCurrency}",
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("ပေးငွေပေါင်း"),
                        Text(
                          "$paidTotal ${data.starCurrency}",
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
                        Expanded(flex: 3, child: Text("ပြေစာအမှတ်")),
                        Expanded(flex: 3, child: Text("ကျသင့်ငွေ")),
                        Expanded(flex: 2, child: Text("ပေးငွေ")),
                      ],
                    ),
                  ),
                  if (data.starNpItemList != null)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: starNpItemList.length,
                      itemBuilder: (context, index) {
                        var item = starNpItemList[index];
                        // if (item.starUserName != user) return Container();
                        return listItem(
                          no: index + 1,
                          inv: item.starInvovice,
                          namount: item.starAmount,
                          pamount: item.starPaidAmount,
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

  Widget listItem({int? no, String? inv, double? namount, double? pamount}) {
    return ListTile(
      titleTextStyle: Theme.of(context).textTheme.bodySmall,
      textColor: Theme.of(context).colorScheme.secondary,
      title: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(no.toString())),
          Expanded(flex: 3, child: Text(inv!)),
          Expanded(flex: 3, child: Text(formatedDecimal(namount))),
          Expanded(flex: 2, child: Text(formatedDecimal(pamount))),
        ],
      ),
    );
  }

  Widget userDropdown() {
    return DropdownButton<String>(
      style: TextStyle(
        color: Theme.of(context).colorScheme.secondary,
      ),
      value: user,
      items: [
        const DropdownMenuItem(
          value: "All",
          child: Text("All"),
        ),
        ...userList.map((user) {
          return DropdownMenuItem(
            value: user,
            child: Text(user),
          );
        })
      ],
      onChanged: (value) {
        starNpItemList.clear();
        user = value!;
        setState(() {});
      },
      hint: const Text('Users'),
    );
  }
}
