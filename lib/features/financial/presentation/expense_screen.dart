import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starman/components/custom_card.dart';
import 'package:starman/components/custom_drawer.dart';
import 'package:starman/components/fusion_date_picker.dart';
import 'package:starman/components/loading_indicator.dart';
import 'package:starman/components/shop_dropdown.dart';
import 'package:starman/features/financial/models/expense_model.dart';
import 'package:starman/features/financial/viewmodel/expense_vm.dart';

class ExpenseScreen extends ConsumerStatefulWidget {
  const ExpenseScreen({super.key});

  @override
  ConsumerState<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends ConsumerState<ExpenseScreen> {
  String? selectedShop;
  String? selectedDate;
  int type = 1;
  SharedPreferences? prefs;
  List<StarIncExpList> starIncExpList = [];
  double total = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Durations.medium1, () async {
      ref.read(expenseVmProvider.notifier).loadData();
      prefs = await SharedPreferences.getInstance();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ExpenseState expenseState = ref.watch(expenseVmProvider);
    if (prefs != null) {
      selectedShop = prefs?.getString("lastShop");
    }
    if (expenseState.errorMessage != null) {
      Fluttertoast.showToast(
          msg: "Operation fails",
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ဝင်ငွေ/အသုံးစရိတ်အစီရင်ခံစာ",
        ),
        actions: [
          IconButton(
            onPressed: () async {
              if (selectedShop == null) {
                Fluttertoast.showToast(msg: "Please select the shop...");
              } else {
                starIncExpList.clear();
                selectedDate = "Today";
                await ref.read(expenseVmProvider.notifier).fetchData(
                    params: {"user_id": selectedShop!, "type": "EXP"});
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
          _buildBody(expenseState),
          expenseState.isLoading ? const LoadingWidget() : Container(),
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

  Widget _buildBody(ExpenseState state) {
    final ExpenseModel data =
        state.datas.isNotEmpty ? state.datas[0] : ExpenseModel();
    total = 0;
    if (data.starIncExpList != null) {
      for (var item in data.starIncExpList!) {
        if (item.starStatus == type) {
          starIncExpList.add(item);
          total += item.starAmount as double;
        }
      }
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
                  starIncExpList.clear();
                  ref
                      .read(expenseVmProvider.notifier)
                      .loadDataByFilter(date: value!, type: type);
                  setState(() {
                    selectedDate = value;
                  });
                },
              ),
            ],
          ),
          Row(
            children: [
              flowDropdown(data),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: CustomCard(
                title: Column(
                  children: [
                    Text("စုစုပေါင်း(${data.starCurrency ?? ''})"),
                    Text(total.toString()),
                  ],
                ),
                children: [
                  ListTile(
                    titleTextStyle: Theme.of(context).textTheme.bodyMedium,
                    title: const Row(
                      children: [
                        Expanded(child: Text("စဉ်")),
                        Expanded(flex: 3, child: Text("အမျိုးအစား")),
                        Expanded(flex: 1, child: Text("ပေးငွေ")),
                      ],
                    ),
                  ),
                  if (data.starIncExpList != null)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: starIncExpList.length,
                      itemBuilder: (context, index) {
                        var item = starIncExpList[index];
                        if (item.starStatus != type) return Container();
                        return listItem(
                          no: index + 1,
                          type: item.starName,
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

  Widget listItem({int? no, String? type, double? amount}) {
    return ListTile(
      titleTextStyle: Theme.of(context).textTheme.bodySmall,
      title: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(no.toString())),
          Expanded(flex: 3, child: Text(type!)),
          Expanded(flex: 1, child: Text(formatedDecimal(amount))),
        ],
      ),
    );
  }

  Widget flowDropdown(ExpenseModel data) {
    return DropdownButton<String>(
      value: type.toString(),
      items: const [
        DropdownMenuItem(
          value: "1",
          child: Text("ဝင်ငွေ"),
        ),
        DropdownMenuItem(
          value: "2",
          child: Text("ထွက်ငွေ"),
        ),
        DropdownMenuItem(
          value: "3",
          child: Text("အခြား"),
        ),
      ],
      onChanged: (value) {
        starIncExpList.clear();
        type = int.parse(value!);
        // for (var item in data.starIncExpList!) {
        //   if (item.starStatus == type) {
        //     starIncExpList.add(item);
        //   }
        // }
        setState(() {});
      },
      hint: const Text('Type'),
    );
  }
}
