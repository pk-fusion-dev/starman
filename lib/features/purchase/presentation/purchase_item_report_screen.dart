import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starman/components/custom_card.dart';
import 'package:starman/components/custom_drawer.dart';
import 'package:starman/components/fusion_date_picker.dart';
import 'package:starman/components/ios_loading_indication.dart';
import 'package:starman/components/loading_indicator.dart';
import 'package:starman/components/shop_dropdown.dart';
import 'package:starman/features/purchase/models/purchase_item_model.dart';
import 'package:starman/features/purchase/viewmodel/purchase_item_vm.dart';

class PurchaseItemReportScreen extends ConsumerStatefulWidget {
  const PurchaseItemReportScreen({super.key});

  @override
  ConsumerState<PurchaseItemReportScreen> createState() =>
      _PurchaseItemReportScreenState();
}

class _PurchaseItemReportScreenState extends ConsumerState<PurchaseItemReportScreen> {
  String? selectedShop;
  String? selectedDate;
  SharedPreferences? prefs;
  final refreshController = RefreshController();
  List<StarItemList> allItemList = [];
  List<StarItemList> showItemList = [];
  int maxCount = 20;

  @override
  void initState() {
    super.initState();
    Future.delayed(Durations.medium1, () async {
      ref.read(purchaseItemVmProvider.notifier).loadData();
      prefs = await SharedPreferences.getInstance();
    });
  }

  @override
  Widget build(BuildContext context) {
    final PurchaseItemState purchaseItemState = ref.watch(purchaseItemVmProvider);
    if(purchaseItemState.datas.isNotEmpty){
      allItemList = purchaseItemState.datas[0].starItemList!;
    }
    // print("build again");
    if (allItemList.isNotEmpty) {
      showItemList.clear();
      maxCount = allItemList.length < maxCount ? allItemList.length : maxCount;
      for (int i = 0; i < maxCount; i++) {
        showItemList.add(allItemList[i]);
      }
    }
    if (prefs != null) {
      selectedShop = prefs?.getString("lastShop");
    }
    if (purchaseItemState.errorMessage != null) {
      Fluttertoast.showToast(
          msg: "Operation fails",
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ကုန်ပစ္စည်းအဝယ်အစီရင်ခံစာ",
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
                await ref.read(purchaseItemVmProvider.notifier).fetchData(
                    params: {"user_id": selectedShop!, "type": "PI"});
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
          _buildBody(purchaseItemState),
          purchaseItemState.isLoading ? const LoadingWidget() : Container(),
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

  Widget _buildBody(PurchaseItemState state) {
    final PurchaseItemModel data =
        state.datas.isNotEmpty ? state.datas[0] : PurchaseItemModel();
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
                  showItemList.clear();
                  maxCount = 20;
                  refreshController.loadFailed();
                  ref
                      .read(purchaseItemVmProvider.notifier)
                      .loadDataByFilter(date: value!);
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
                      Expanded(flex: 3, child: Text("အရေအတွက်")),
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
                            Future.delayed(const Duration(microseconds: 1000), () {
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
                          itemCount: allItemList.length,
                          itemBuilder: (context, index) {
                            var item = allItemList[index];
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
          Expanded(flex: 3, child: Text(formatedDecimal(quantity),textAlign: TextAlign.center,)),
          Expanded(flex: 2, child: Text(formatedDecimal(amount),textAlign: TextAlign.center,)),
        ],
      ),
    );
  }
}
