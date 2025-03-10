import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starman/components/custom_card.dart';
import 'package:starman/components/custom_drawer.dart';
import 'package:starman/components/ios_loading_indication.dart';
import 'package:starman/components/loading_indicator.dart';
import 'package:starman/components/shop_dropdown.dart';
import 'package:starman/features/stock/models/stock_balance_model.dart';
import 'package:starman/features/stock/view_model/stock_balance_vm.dart';

import '../../star_links/providers/star_links_provider.dart';

class StockBalanceScreen extends ConsumerStatefulWidget {
  const StockBalanceScreen({super.key});

  @override
  ConsumerState<StockBalanceScreen> createState() => _StockBalanceScreenState();
}

class _StockBalanceScreenState extends ConsumerState<StockBalanceScreen> {
  String? selectedShop;
  SharedPreferences? prefs;
  String? category = "All";
  final refreshController = RefreshController();
  int maxCount = 20;
  List<StarStockBalanceList> allStock = [];
  List<StarStockBalanceList> showStock = [];
  String? lastSyncDate = '';

  @override
  void initState() {
    super.initState();
    Future.delayed(Durations.medium1, () async {
      ref.read(stockBalanceVmProvider.notifier).loadData();
      prefs = await SharedPreferences.getInstance();
    });
  }

  @override
  Widget build(BuildContext context) {
    final StockBalanceState stockBalanceState =
        ref.watch(stockBalanceVmProvider);
    allStock = stockBalanceState.stockList;
    var shopList = ref.watch(starLinksProvider);
    if (allStock.isNotEmpty) {
      showStock.clear();
      maxCount = allStock.length < maxCount ? allStock.length : maxCount;
      for (int i = 0; i < maxCount; i++) {
        showStock.add(allStock[i]);
      }
    }
    if (prefs != null && selectedShop == null) {
      selectedShop = prefs?.getString("stock_balance_Shop");
      lastSyncDate = prefs?.getString("stock_balance_Date") ?? '';
      if (selectedShop == null && shopList.isNotEmpty) {
        selectedShop = ref.read(starLinksProvider.notifier).getInitShop();
      }
    }
    if (stockBalanceState.errorMessage != null) {
      Fluttertoast.showToast(
          msg: "လုပ်ဆောင်မှုမအောင်မြင်ပါ",
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ကုန်ပစ္စည်းလက်ကျန်အစီရင်ခံစာ",
        ),
        actions: [
          IconButton(
            onPressed: () async {
              if (selectedShop == null) {
                Fluttertoast.showToast(msg: "Please select the shop...");
              } else {
                maxCount = 20;
                refreshController.loadFailed();
                prefs?.setString("stock_balance_Shop", selectedShop!);
                DateTime lastDate = DateTime.now();
                lastSyncDate =
                    DateFormat('yyyy-MM-dd h:m:s a').format(lastDate);
                prefs?.setString("stock_balance_Date", lastSyncDate!);
                await ref.read(stockBalanceVmProvider.notifier).fetchData(
                    params: {"user_id": selectedShop!, "type": "SB"});
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
          _buildBody(stockBalanceState),
          stockBalanceState.isLoading ? const LoadingWidget() : Container(),
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

  Widget _buildBody(StockBalanceState state) {
    var currency = '-';
    if (state.datas.isNotEmpty) {
      currency = state.datas[0].starCurrency!;
    }
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Column(
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
                  catDropdown(state),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(),
                  Text(
                    lastSyncDate!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
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
                        const Text("စုစုပေါင်းအရေအတွက်"),
                        Text(
                          formatedDecimal(state.totalQuantity),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text("စုစုပေါင်း"),
                        Text(
                          "${formatedDecimal(state.totalAmount)} $currency",
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
                        Expanded(flex: 3, child: Text("အမည်/ကုန်အုပ်စု")),
                        Expanded(flex: 2, child: Text("အရေအတွက်")),
                        Expanded(flex: 1, child: Text("ယူနစ်")),
                      ],
                    ),
                  ),
                  if (state.datas.isNotEmpty)
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
                            if (maxCount == allStock.length) {
                              refreshController.loadNoData();
                            } else {
                              Future.delayed(const Duration(microseconds: 1000),
                                  () {
                                int rmData = allStock.length - maxCount;
                                int nextCount = rmData >= 10 ? 10 : rmData;
                                for (int i = maxCount;
                                    i < maxCount + nextCount;
                                    i++) {
                                  showStock.add(allStock[i]);
                                }
                                maxCount += nextCount;
                                setState(() {});
                              });
                              refreshController.loadComplete();
                            }
                          },
                          child: ListView.builder(
                            // shrinkWrap: true,
                            // physics: const NeverScrollableScrollPhysics(),
                            itemCount: showStock.length,
                            itemBuilder: (context, index) {
                              var item = showStock[index];
                              // if (item.starUserName != user) return Container();
                              return listItem(
                                no: index + 1,
                                item: item,
                              );
                            },
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget listItem({required int no, required StarStockBalanceList item}) {
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
                  Text(item.starItemName),
                  Text(item.starCategoryName),
                ],
              )),
          Expanded(
              flex: 2,
              child: Text(
                formatedDecimal(item.starQty),
                textAlign: TextAlign.center,
              )),
          Expanded(
              flex: 1,
              child: Text(
                item.starUnit,
                textAlign: TextAlign.center,
              )),
        ],
      ),
    );
  }

  Widget catDropdown(StockBalanceState state) {
    return DropdownButton<String>(
      style: TextStyle(
        color: Theme.of(context).colorScheme.secondary,
      ),
      value: category,
      items: [
        const DropdownMenuItem(
          value: "All",
          child: Text("All"),
        ),
        ...state.categories.map((category) {
          return DropdownMenuItem(
            value: category,
            child: Text(category),
          );
        })
      ],
      onChanged: (value) {
        maxCount = 10;
        refreshController.loadFailed();
        category = value!;
        setState(() {});
        ref
            .read(stockBalanceVmProvider.notifier)
            .loadDataByFilter(category: category!);
      },
      hint: const Text('Category'),
    );
  }
}
