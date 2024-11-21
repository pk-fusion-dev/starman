import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starman/routers/router.dart';
import 'package:starman/theme/color_const.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String? rmDay;
  String? finalEndDate;
  String? starID;
  ExpansionTileController finanacialTile = ExpansionTileController();
  ExpansionTileController salesTile = ExpansionTileController();
  ExpansionTileController purchaseTile = ExpansionTileController();
  ExpansionTileController stockTile = ExpansionTileController();
  ExpansionTileController ostTile = ExpansionTileController();

  @override
  void initState() {
    super.initState();
    getRmDays();
  }

  Future getRmDays() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var currentDate = DateTime.now();
    String endDateString = prefs.getString("endDate")!;
    DateFormat dateFormat = DateFormat("dd/MM/yyyy");
    DateTime endDate = dateFormat.parse(endDateString);
    int remainingDays = endDate.difference(currentDate).inDays;
    setState(() {
      // ostTile.expand();
      rmDay = remainingDays.toString();
      finalEndDate = endDateString;
      starID = prefs.getString("starID")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: ColorConst.lightSurface,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: ColorConst.lightPrimary,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.asset('assets/images/Starman.png'),
                    ),
                    const Text(
                      "  Starman",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SelectableText(
                      "$starID --- ",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    Text(
                      "$rmDay days",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ExpansionTile(
                  title: const Text("ငွေစာရင်းအစီရင်ခံစာ"),
                  controller: finanacialTile,
                  children: [
                    listItem(
                      context,
                      const Icon(Icons.attach_money),
                      "အရှုံးအမြတ်အစီရင်ခံစာ",
                      () {
                        context.goNamed(RouteName.profitLost);
                      },
                    ),
                    listItem(
                      context,
                      const Icon(Icons.attach_money),
                      "ငွေအဝင်အထွက်အစီရင်ခံစာ",
                      () {
                        context.goNamed(RouteName.cashflow);
                      },
                    ),
                    listItem(
                      context,
                      const Icon(Icons.attach_money),
                      "နေ့အလိုက်ငွေအဝင်အထွက်အစီရင်ခံစာ",
                      () {
                        context.goNamed(RouteName.cashflowdaily);
                      },
                    ),
                    listItem(
                      context,
                      const Icon(Icons.attach_money),
                      "ဝင်ငွေ/အသုံးစရိတ်အစီရင်ခံစာ",
                      () {
                        context.goNamed(RouteName.expense);
                      },
                    ),
                  ],
                ),
                ExpansionTile(
                  title: const Text("အရောင်းအစီရင်ခံစာ"),
                  controller: salesTile,
                  children: [
                    listItem(
                      context,
                      const Icon(Icons.shopping_cart),
                      "အရောင်းအစီရင်ခံစာ",
                      () {
                        context.goNamed(RouteName.sales);
                      },
                    ),
                    listItem(
                      context,
                      const Icon(Icons.shopping_cart),
                      "ကုန်ပစ္စည်းအရောင်းအစီရင်ခံစာ",
                      () {
                        context.goNamed(RouteName.soldItem);
                      },
                    ),
                  ],
                ),
                ExpansionTile(
                  title: const Text("အဝယ်အစီရင်ခံစာ"),
                  controller: purchaseTile,
                  children: [
                    listItem(
                      context,
                      const Icon(Icons.add_shopping_cart),
                      "အဝယ်အစီရင်ခံစာ",
                      () {
                        context.goNamed(RouteName.purchase);
                      },
                    ),
                    listItem(
                      context,
                      const Icon(Icons.add_shopping_cart),
                      "ကုန်ပစ္စည်းအဝယ်အစီရင်ခံစာ",
                      () {
                        context.goNamed(RouteName.purchaseItem);
                      },
                    ),
                  ],
                ),
                ExpansionTile(
                  title: const Text("ကုန်ပစ္စည်းအစီရင်ခံစာ"),
                  controller: stockTile,
                  children: [
                    listItem(
                      context,
                      const Icon(Icons.add_shopping_cart),
                      "ကုန်ပစ္စည်းလက်ကျန်",
                      () {
                        context.goNamed(RouteName.stockBalance);
                      },
                    ),
                    listItem(
                      context,
                      const Icon(Icons.add_shopping_cart),
                      "အရေအတွက်နည်းနေသောကုန်ပစ္စည်း",
                      () {
                        context.goNamed(RouteName.stockReorder);
                      },
                    ),
                  ],
                ),
                ExpansionTile(
                  title: const Text("အကြွေးအစီရင်ခံစာ"),
                  controller: ostTile,
                  children: [
                    listItem(
                      context,
                      const Icon(Icons.add_shopping_cart),
                      "ရရန်ရှိအစီရင်ခံစာ",
                      () {
                        context.goNamed(RouteName.outstandingCustomer);
                      },
                    ),
                    listItem(
                      context,
                      const Icon(Icons.add_shopping_cart),
                      "ပေးရန်ရှိအစီရင်ခံစာ",
                      () {
                        context.goNamed(RouteName.outstandingSupplier);
                      },
                    ),
                  ],
                ),
                ListTile(
                  title: const Text("စနစ်ထိမ်းသိမ်းခြင်း"),
                  onTap: (){
                    context.goNamed(RouteName.setting);
                  },
                )
              ],
            ),
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Logout"),
                IconButton(
                    onPressed: () async{
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.remove('starID');
                      prefs.remove('pl_Shop');
                      prefs.remove('cf_Shop');
                      prefs.remove('cfd_Shop');
                      prefs.remove('exp_Shop');
                      prefs.remove('sales_Shop');
                      prefs.remove('sold_item_Shop');
                      prefs.remove('purchase_Shop');
                      prefs.remove('purchase_item_Shop');
                      prefs.remove('stock_balance_Shop');
                      prefs.remove('stock_reorder_Shop');
                      prefs.remove('oc_Shop');
                      prefs.remove('os_Shop');
                      context.goNamed(RouteName.splash);
                    },
                    icon: const Icon(Icons.logout,color: Colors.white,)
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget listItem(context, Icon icon, String title, VoidCallback fun) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: icon,
        iconColor: Theme.of(context).colorScheme.primary,
        title: Text(
          title,
          style: const TextStyle(fontSize: 12),
        ),
        onTap: fun,
      ),
    );
  }
}
