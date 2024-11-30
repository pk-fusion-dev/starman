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
import 'package:starman/features/sales/models/sales_model.dart';
import 'package:starman/features/sales/viewmodel/sales_vm.dart';

import '../../star_links/providers/star_links_provider.dart';

class SalesReportScreen extends ConsumerStatefulWidget {
  const SalesReportScreen({super.key});

  @override
  ConsumerState<SalesReportScreen> createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends ConsumerState<SalesReportScreen> {
  String? selectedShop;
  String? selectedDate;
  String user = "All";
  SharedPreferences? prefs;
  int maxCount = 20;
  final refreshController = RefreshController();
  List<StarNsItemList> allData = [];
  List<StarNsItemList> showData = [];
  String? lastSyncDate = '';

  @override
  void initState() {
    super.initState();
    Future.delayed(Durations.medium1, () async {
      ref.read(salesVmProvider.notifier).loadData();
      prefs = await SharedPreferences.getInstance();
    });
  }

  @override
  Widget build(BuildContext context) {
    final SalesState salesState = ref.watch(salesVmProvider);
    var shopList = ref.watch(starLinksProvider);
    allData = salesState.vouchers;
    // print("build again");
    if (allData.isNotEmpty) {
      showData.clear();
      maxCount = allData.length < maxCount ? allData.length : maxCount;
      for (int i = 0; i < maxCount; i++) {
        showData.add(allData[i]);
      }
    }
    if (prefs != null && selectedShop==null) {
      selectedShop = prefs?.getString("sales_Shop");
      lastSyncDate = prefs?.getString("sales_Date") ?? '';
      if(selectedShop==null && shopList.isNotEmpty){
        selectedShop = ref.read(starLinksProvider.notifier).getInitShop();
      }
    }
    if (salesState.errorMessage != null) {
      Fluttertoast.showToast(
          msg: "လုပ်ဆောင်မှုမအောင်မြင်ပါ",
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "အရောင်းအစီရင်ခံစာ",
        ),
        actions: [
          IconButton(
            onPressed: () async {
              if (selectedShop == null) {
                Fluttertoast.showToast(msg: "Please select the shop...");
              } else {
                maxCount = 10;
                selectedDate = "Today";
                user = "All";
                prefs?.setString("sales_Shop", selectedShop!);
                DateTime lastDate = DateTime.now();
                lastSyncDate = DateFormat('yyyy-MM-dd h:m:s a').format(lastDate);
                prefs?.setString("sales_Date", lastSyncDate!);
                refreshController.loadFailed();
                await ref.read(salesVmProvider.notifier).fetchData(
                    params: {"user_id": selectedShop!, "type": "NS"});
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
          _buildBody(salesState),
          salesState.isLoading ? const LoadingWidget() : Container(),
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

  Widget _buildBody(SalesState state) {
    final SalesModel data =
        state.datas.isNotEmpty ? state.datas[0] : SalesModel();
    //
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
                onSelected: (value) async {
                  // allData.clear();
                  maxCount = 10;
                  refreshController.loadFailed();
                  ref
                      .read(salesVmProvider.notifier)
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
              userDropdown(state),
              Text(
                lastSyncDate!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),            ],
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
                          state.vouchers.length.toString(),
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
                    Column(
                      children: [
                        const Text("ပေးငွေပေါင်း"),
                        Text(
                          "${state.totalPaidAmount} $currency",
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
                  if (state.vouchers.isNotEmpty)
                    SingleChildScrollView(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: SmartRefresher(
                          controller: refreshController,
                          enablePullUp: true,
                          enablePullDown: false,
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
                            if (maxCount == allData.length) {
                              refreshController.loadNoData();
                            } else {
                              Future.delayed(const Duration(microseconds: 1000),
                                  () {
                                int rmData = allData.length - maxCount;
                                int nextCount = rmData >= 10 ? 10 : rmData;
                                for (int i = maxCount;
                                    i < maxCount + nextCount;
                                    i++) {
                                  showData.add(allData[i]);
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
                            itemCount: maxCount,
                            itemBuilder: (context, index) {
                              var item = showData[index];
                              // if (item.starUserName != user) return Container();
                              return listItem(
                                no: index + 1,
                                inv: item.starInvovice,
                                namount: item.starAmount,
                                pamount: item.starPaidAmount,
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

  Widget userDropdown(SalesState state) {
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
        ...state.users.map((user) {
          return DropdownMenuItem(
            value: user,
            child: Text(user),
          );
        })
      ],
      onChanged: (value) {
        maxCount = 10;
        refreshController.loadFailed();
        user = value!;
        setState(() {});
        ref.read(salesVmProvider.notifier).filterVoucherByUser(user: value);
      },
      hint: const Text('Users'),
    );
  }
}
