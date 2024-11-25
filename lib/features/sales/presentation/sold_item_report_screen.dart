import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starman/components/custom_card.dart';
import 'package:starman/components/custom_drawer.dart';
import 'package:starman/components/fusion_date_picker.dart';
import 'package:starman/components/ios_loading_indication.dart';
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
  final refreshController = RefreshController();
  List<StarItemList> allItemList = [];
  List<StarItemList> showItemList = [];
  int maxCount = 20;
  String? lastSyncDate = '';

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
    if(soldItemState.datas.isNotEmpty){
      allItemList = soldItemState.datas[0].starItemList!;
    }
    // print("build again");
    if (allItemList.isNotEmpty) {
      showItemList.clear();
      maxCount = allItemList.length < maxCount ? allItemList.length : maxCount;
      for (int i = 0; i < maxCount; i++) {
        showItemList.add(allItemList[i]);
      }
    }
    if (prefs != null && selectedShop==null) {
      selectedShop = prefs?.getString("sold_item_Shop");
      lastSyncDate = prefs?.getString("sold_item_Date") ?? '';
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
                showItemList.clear();
                maxCount = 20;
                refreshController.loadFailed();
                selectedDate = "Today";
                prefs?.setString("sold_item_Shop", selectedShop!);
                DateTime lastDate = DateTime.now();
                lastSyncDate = DateFormat('yyyy-MM-dd h:m:s a').format(lastDate);
                prefs?.setString("sold_item_Date", lastSyncDate!);
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
                  });
                },
              ),
              FusionDatePick(
                selectedDate: selectedDate,
                onSelected: (value) {
                  maxCount = 20;
                  refreshController.loadFailed();
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              Text(
                lastSyncDate!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),            ],
          ),
          Expanded(
            child: CustomCard(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text("ကုန်ပစ္စည်းအရေအတွက်"),
                      Text(
                        formatedDecimal(state.totalQty),
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("ကျသင့်ငွေပေါင်း"),
                      Text(
                        "${state.totalAmount} $currency",
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
                  SingleChildScrollView(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: SmartRefresher(
                        controller: refreshController,
                        enablePullDown: false,
                        enablePullUp: true,
                        footer: CustomFooter(
                            builder: (context, LoadStatus? mode) {
                              Widget body = Container();
                              if (mode == LoadStatus.loading) {
                                body = const IosLoadingIndication();
                              } else if (mode == LoadStatus.noMore) {
                                body = const Text("No More Data...");
                              }
                              return SizedBox(
                                height: 55,
                                child: Center(
                                  child: body,
                                ),
                              );
                            }),
                        onLoading: () {
                          if (maxCount == allItemList.length) {
                            refreshController.loadNoData();
                          } else {
                            Future.delayed(const Duration(microseconds: 1000),
                                    () {
                                  int rmData = allItemList.length - maxCount;
                                  int nextCount = rmData >= 10 ? 10 : rmData;
                                  for (int i = maxCount;
                                  i < maxCount + nextCount;
                                  i++) {
                                    showItemList.add(allItemList[i]);
                                  }
                                  maxCount += nextCount;
                                  setState(() {});
                                });
                            refreshController.loadComplete();
                          }
                        },
                        child: ListView.builder(
                          itemCount: showItemList.length,
                          itemBuilder: (context, index) {
                            var item = showItemList[index];
                            // if (item.starUserName != user) return Container();
                            return listItem(
                              no: index + 1,
                              name: item.starItemName,
                              quantity: item.starQty,
                              amount: item.starAmount,
                            );
                          },
                        ),
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

  Widget listItem({int? no, String? name, double? quantity, double? amount}) {
    return ListTile(
      titleTextStyle: Theme.of(context).textTheme.bodySmall,
      textColor: Theme.of(context).colorScheme.secondary,
      title: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(no.toString())),
          Expanded(flex: 3, child: Text(name!)),
          Expanded(flex: 2, child: Text(formatedDecimal(quantity),textAlign: TextAlign.center,)),
          Expanded(flex: 2, child: Text(formatedDecimal(amount),textAlign: TextAlign.center,)),
        ],
      ),
    );
  }
}
