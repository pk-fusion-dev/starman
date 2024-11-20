import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starman/components/custom_card.dart';
import 'package:starman/components/custom_drawer.dart';
import 'package:starman/components/loading_indicator.dart';
import 'package:starman/components/shop_dropdown.dart';
import 'package:starman/features/stock/models/stock_reorder_model.dart';
import 'package:starman/features/stock/view_model/stock_reorder_vm.dart';

class StockReorderScreen extends ConsumerStatefulWidget {
  const StockReorderScreen({super.key});

  @override
  ConsumerState<StockReorderScreen> createState() => _StockReorderScreenState();
}

class _StockReorderScreenState extends ConsumerState<StockReorderScreen> {
  String? selectedShop;
  String? selectedDate;
  SharedPreferences? prefs;
  String? category = "All";
  final refreshController = RefreshController();
  int maxCount = 20;
  List<StockReorderModel> allStock = [];
  List<StockReorderModel> showStock = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Durations.medium1, () async {
      ref.read(stockReorderVmProvider.notifier).loadData();
      prefs = await SharedPreferences.getInstance();
    });
  }

  @override
  Widget build(BuildContext context) {
    final StockReorderState stockReorderState =
        ref.watch(stockReorderVmProvider);
    allStock = stockReorderState.datas;
    if (allStock.isNotEmpty) {
      showStock.clear();
      maxCount = allStock.length < maxCount ? allStock.length : maxCount;
      for (int i = 0; i < maxCount; i++) {
        showStock.add(allStock[i]);
      }
    }
    if (prefs != null) {
      selectedShop = prefs?.getString("lastShop");
    }
    if (stockReorderState.errorMessage != null) {
      Fluttertoast.showToast(
          msg: "Operation fails",
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "အရေအတွက်နည်းနေသောကုန်ပစ္စည်း",
        ),
        actions: [
          IconButton(
            onPressed: () async {
              if (selectedShop == null) {
                Fluttertoast.showToast(msg: "Please select the shop...");
              } else {
                selectedDate = "Today";
                await ref.read(stockReorderVmProvider.notifier).fetchData(
                    params: {"user_id": selectedShop!, "type": "RS"});
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
          _buildBody(stockReorderState),
          stockReorderState.isLoading ? const LoadingWidget() : Container(),
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

  Widget _buildBody(StockReorderState state) {
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
                        prefs?.setString("lastShop", value!);
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  catDropdown(state),
                ],
              )
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: CustomCard(
                title: Column(
                  children: [
                    const Text("အော်ဒါမှာရမည့်ကုန်ပစ္စည်းအရေအတွက်"),
                    Text(
                      formatedDecimal(state.datas.length),
                      style: Theme.of(context).textTheme.labelSmall,
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
                        Expanded(flex: 2, child: Text("ဂိုထောင်လက်ကျန်")),
                        Expanded(flex: 2, child: Text("အနည်းဆုံးလက်ကျန်")),
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
                              body = const CircularProgressIndicator();
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
                                name: item.starItemName,
                                whQty: item.starInventoryQty,
                                reorderQty: item.starReorderQty,
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

  Widget listItem({int? no, String? name, double? whQty, double? reorderQty}) {
    return ListTile(
      titleTextStyle: Theme.of(context).textTheme.bodySmall,
      textColor: Theme.of(context).colorScheme.secondary,
      title: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(no.toString())),
          Expanded(flex: 3, child: Text(name!)),
          Expanded(
              flex: 2,
              child: Text(
                formatedDecimal(whQty),
                textAlign: TextAlign.center,
              )),
          Expanded(
              flex: 2,
              child: Text(
                formatedDecimal(reorderQty),
                textAlign: TextAlign.center,
              )),
        ],
      ),
    );
  }

  Widget catDropdown(StockReorderState state) {
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
            .read(stockReorderVmProvider.notifier)
            .loadDataByFilter(category: value);
      },
      hint: const Text('Category'),
    );
  }
}
