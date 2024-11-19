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
  ExpansionTileController inventoryTile = ExpansionTileController();

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
      inventoryTile.expand();
      rmDay = remainingDays.toString();
      finalEndDate = endDateString;
      starID = prefs.getString("starID")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: ColorConst.lightSurface,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset('assets/images/logo.png'),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SelectableText(
                      "StarID: $starID",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      "End Date: $finalEndDate",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      "Remaining days : $rmDay",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
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
                  title: const Text("Financial Report"),
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
                  title: const Text("Sales Report"),
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
                  title: const Text("Purchase Report"),
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
                  title: const Text("Inventory Report"),
                  controller: inventoryTile,
                  children: [
                    listItem(
                      context,
                      const Icon(Icons.add_shopping_cart),
                      "ကုန်ပစ္စည်းလက်ကျန်",
                          () {
                        // context.goNamed(RouteName.purchase);
                      },
                    ),
                    listItem(
                      context,
                      const Icon(Icons.add_shopping_cart),
                      "အရေအတွက်နည်းနေသောကုန်ပစ္စည်း",
                          () {
                        // context.goNamed(RouteName.purchaseItem);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
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
