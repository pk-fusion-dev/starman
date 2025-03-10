import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starman/components/custom_card.dart';
import 'package:starman/components/custom_drawer.dart';
import 'package:starman/components/fusion_date_picker.dart';
import 'package:starman/components/loading_indicator.dart';
import 'package:starman/components/shop_dropdown.dart';
import 'package:starman/features/financial/models/profit_loss_model.dart';
import 'package:starman/features/financial/viewmodel/profit_lose_vm.dart';

import '../../star_links/providers/star_links_provider.dart';

class ProfitLoseScreen extends ConsumerStatefulWidget {
  const ProfitLoseScreen({super.key});

  @override
  ConsumerState<ProfitLoseScreen> createState() => _ProfitLoseScreenState();
}

class _ProfitLoseScreenState extends ConsumerState<ProfitLoseScreen> {
  String? selectedShop;
  String? selectedDate;
  SharedPreferences? prefs;
  String? lastSyncDate = '';
  bool isFirstLogin = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Durations.medium1, () async {
      ref.read(profitLoseVmProvider.notifier).loadData();
      prefs = await SharedPreferences.getInstance();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ProfitLoseState profitLoseState = ref.watch(profitLoseVmProvider);
    var shopList = ref.watch(starLinksProvider);
    // alert box for license
    if (prefs != null && shopList.isEmpty && isFirstLogin) {
      isFirstLogin = false;
      var currentDate = DateTime.now();
      String endDateString = prefs!.getString("endDate")!;
      DateFormat dateFormat = DateFormat("dd/MM/yyyy");
      DateTime endDate = dateFormat.parse(endDateString);
      int remainingDays = endDate.difference(currentDate).inDays;
      if (remainingDays <= 7) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              // title: const Text("Alert"),
              content: Text(
                "လိုင်စင်သက်တမ်းကုန်ဆုံးရန် $remainingDays ရက်သာလိုပါတော့သည်။",
              ),
            ),
          );
        });
      }
    }
    //
    if (prefs != null && selectedShop == null) {
      selectedShop = prefs?.getString("pl_Shop");
      lastSyncDate = prefs?.getString("pl_Date") ?? '';
      if (selectedShop == null && shopList.isNotEmpty) {
        selectedShop = ref.read(starLinksProvider.notifier).getInitShop();
      }
    }
    if (profitLoseState.errorMessage != null) {
      Fluttertoast.showToast(
        msg: "လုပ်ဆောင်မှုမအောင်မြင်ပါ",
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_SHORT,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "အရှုံးအမြတ်အစီရင်ခံစာ",
        ),
        actions: [
          IconButton(
            onPressed: () async {
              if (selectedShop == null) {
                Fluttertoast.showToast(msg: "Please select the shop...");
              } else {
                selectedDate = "Today";
                prefs?.setString("pl_Shop", selectedShop!);
                DateTime lastDate = DateTime.now();
                lastSyncDate =
                    DateFormat('yyyy-MM-dd h:m:s a').format(lastDate);
                prefs?.setString("pl_Date", lastSyncDate!);
                await ref.read(profitLoseVmProvider.notifier).fetchData(
                    params: {"user_id": selectedShop!, "type": "PL"});
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
          _buildBody(profitLoseState),
          profitLoseState.isLoading ? const LoadingWidget() : Container(),
        ],
      ),
    );
  }

  Widget _buildBody(ProfitLoseState state) {
    final ProfitLossModel data =
        state.datas.isNotEmpty ? state.datas[0] : ProfitLossModel();
    String plValue = '0';
    if (data.starProfitLoss != null) {
      plValue = data.starProfitLoss!.toStringAsFixed(3);
      plValue = plValue.contains('.')
          ? plValue.replaceAll(RegExp(r'\.?0+$'), '')
          : plValue;
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
              FusionDatePick(
                selectedDate: selectedDate,
                onSelected: (value) {
                  ref
                      .read(profitLoseVmProvider.notifier)
                      .loadDataByDate(date: value!);
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
              ),
            ],
          ),
          Expanded(
            child: CustomCard(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("အရှုံး/အမြတ်(${data.starCurrency ?? ''})"),
                  Text(plValue),
                ],
              ),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ExpansionTile(
                          title: Text(
                            "ဝင်ငွေ",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          children: [
                            listItem("အရောင်းပမာဏ", data.starSaleAmount ?? 0),
                            listItem("ကုန်ပစ္စည်းအရင်းတန်ဖိုး",
                                data.starSoldItemValue ?? 0,
                                isOut: true),
                            listItem("အဝယ်လျော့စျေး",
                                data.starPurchaseDiscount ?? 0),
                            listItem("အခြားဝင်ငွေ", data.starOtherIncome ?? 0),
                            listItem(
                                "စုစုပေါင်းဝင်ငွေ", data.starTotalIncome ?? 0),
                          ],
                        ),
                        ExpansionTile(
                          title: Text(
                            "ထွက်ငွေ",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          children: [
                            listItem(
                                "အရောင်းလျော့စျေး", data.starSalesDiscount ?? 0,
                                isOut: true),
                            listItem("အရောင်းအခွန်", data.starSalesTax ?? 0,
                                isOut: true),
                            listItem("အဝယ်အခွန်", data.starPurchaseTax ?? 0),
                            listItem("ကုန်ပစ္စည်းဆုံးရှုံးတန်ဖိုး",
                                data.starDamagedLostAmount ?? 0),
                            listItem("စုစုပေါင်းအသုံးစရိတ်",
                                data.starTotalExpense ?? 0),
                          ],
                        ),
                      ],
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
      textColor: Theme.of(context).colorScheme.secondary,
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
