import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starman/components/custom_card.dart';
import 'package:starman/components/custom_drawer.dart';
import 'package:starman/components/fusion_date_picker.dart';
import 'package:starman/components/loading_indicator.dart';
import 'package:starman/components/shop_dropdown.dart';
import 'package:starman/features/sales/models/sold_item_model.dart';
import 'package:starman/features/sales/viewmodel/sold_item_vm.dart';

class SoldItemReportScreen extends ConsumerStatefulWidget {
  const SoldItemReportScreen({super.key});

  @override
  ConsumerState<SoldItemReportScreen> createState() =>
      _SoldItemReportScreenState();
}

class _SoldItemReportScreenState extends ConsumerState<SoldItemReportScreen> {
  String? selectedShop;
  String? selectedDate;
  SharedPreferences? prefs;
  List<StarItemList> starItemList = [];
  double totalStock = 0;
  double totalAmount = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Durations.medium1, () async {
      ref.read(soldItemVmProvider.notifier).loadData();
      prefs = await SharedPreferences.getInstance();
    });
  }

  @override
  Widget build(BuildContext context) {
    final SoldItemState soldItemState = ref.watch(soldItemVmProvider);
    if (prefs != null) {
      selectedShop = prefs?.getString("lastShop");
    }
    if (soldItemState.errorMessage != null) {
      Fluttertoast.showToast(
          msg: "Operation fails",
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ကုန်ပစ္စည်းအရောင်းအစီရင်ခံစာ",
        ),
        actions: [
          IconButton(
            onPressed: () async {
              if (selectedShop == null) {
                Fluttertoast.showToast(msg: "Please select the shop...");
              } else {
                starItemList.clear();
                selectedDate = "Today";
                await ref.read(soldItemVmProvider.notifier).fetchData(
                    params: {"user_id": selectedShop!, "type": "SI"});
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
          _buildBody(soldItemState),
          soldItemState.isLoading ? const LoadingWidget() : Container(),
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

  Widget _buildBody(SoldItemState state) {
    final SoldItemModel data =
        state.datas.isNotEmpty ? state.datas[0] : SoldItemModel();
    totalStock = 0;
    totalAmount = 0;
    if (data.starItemList != null) {
      starItemList = data.starItemList!;
      totalStock = data.starTotalQty!;
      totalAmount = data.starTotalAmount!;
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
                onSelected: (value) {
                  ref
                      .read(soldItemVmProvider.notifier)
                      .loadDataByFilter(date: value!);
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text("ကုန်ပစ္စည်းအရေအတွက်"),
                        Text(
                          formatedDecimal(totalStock),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("ကျသင့်ငွေပေါင်း"),
                        Text(
                          totalAmount.toString(),
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
                        Expanded(flex: 3, child: Text("အမည်")),
                        Expanded(flex: 2, child: Text("အရေအတွက်")),
                        Expanded(flex: 2, child: Text("ကျသင့်ငွေ")),
                      ],
                    ),
                  ),
                  if (data.starItemList != null)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: starItemList.length,
                      itemBuilder: (context, index) {
                        var item = starItemList[index];
                        // if (item.starUserName != user) return Container();
                        return listItem(
                          no: index + 1,
                          name: item.starItemName,
                          quantity: item.starQty,
                          amount: item.starAmount,
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

  Widget listItem({int? no, String? name, double? quantity, double? amount}) {
    return ListTile(
      titleTextStyle: Theme.of(context).textTheme.bodySmall,
      textColor: Theme.of(context).colorScheme.secondary,
      title: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(no.toString())),
          Expanded(flex: 3, child: Text(name!)),
          Expanded(flex: 2, child: Text(formatedDecimal(quantity))),
          Expanded(flex: 2, child: Text(formatedDecimal(amount))),
        ],
      ),
    );
  }
}
