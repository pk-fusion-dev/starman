import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starman/core/utils/expansionTilePorvider.dart';
import 'package:starman/features/star_links/providers/star_links_provider.dart';
import 'package:starman/routers/router.dart';
import 'package:starman/theme/color_const.dart';
import 'package:starman/theme/font_const.dart';

class CustomDrawer extends ConsumerStatefulWidget {
  const CustomDrawer({super.key});

  @override
  ConsumerState<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends ConsumerState<CustomDrawer> {
  String? rmDay;
  String? finalEndDate;
  String? starID;
  ExpansionTileController financialTile = ExpansionTileController();
  ExpansionTileController salesTile = ExpansionTileController();
  ExpansionTileController purchaseTile = ExpansionTileController();
  ExpansionTileController stockTile = ExpansionTileController();
  ExpansionTileController ostTile = ExpansionTileController();
  int index = 0;

  @override
  void initState() {
    super.initState();
    getRmDays();
  }

  Future getRmDays() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    index = ref.watch(expansionTileProvider);
    var currentDate = DateTime.now();
    String endDateString = prefs.getString("endDate")!;
    DateFormat dateFormat = DateFormat("dd/MM/yyyy");
    DateTime endDate = dateFormat.parse(endDateString);
    int remainingDays = endDate.difference(currentDate).inDays;
    setState(() {
      switch (index) {
        case 1:
          financialTile.expand();
          break;
        case 2:
          salesTile.expand();
          break;
        case 3:
          purchaseTile.expand();
          break;
        case 4:
          stockTile.expand();
          break;
        case 5:
          ostTile.expand();
          break;
      }
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
                  title: Text(
                    "ငွေစာရင်းအစီရင်ခံစာ",
                    style: TextStyle(
                      fontSize: FontConst.tileTitleSize,
                    ),
                  ),
                  controller: financialTile,
                  onExpansionChanged: (_) {
                    // int newIndex = 1;
                    // if(index==1){newIndex=0;}
                    ref.read(expansionTileProvider.notifier).setIndex(1);
                  },
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
                  title: Text(
                    "အရောင်းအစီရင်ခံစာ",
                    style: TextStyle(
                      fontSize: FontConst.tileTitleSize,
                    ),
                  ),
                  controller: salesTile,
                  onExpansionChanged: (_) {
                    // int newIndex = 2;
                    // if(index==2){newIndex=0;}
                    ref.read(expansionTileProvider.notifier).setIndex(2);
                  },
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
                  title: Text(
                    "အဝယ်အစီရင်ခံစာ",
                    style: TextStyle(
                      fontSize: FontConst.tileTitleSize,
                    ),
                  ),
                  controller: purchaseTile,
                  onExpansionChanged: (_) {
                    // int newIndex = 3;
                    // if(index==3){newIndex=0;}
                    ref.read(expansionTileProvider.notifier).setIndex(3);
                  },
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
                  title: Text(
                    "ကုန်ပစ္စည်းအစီရင်ခံစာ",
                    style: TextStyle(
                      fontSize: FontConst.tileTitleSize,
                    ),
                  ),
                  controller: stockTile,
                  onExpansionChanged: (_) {
                    // int newIndex = 4;
                    // if(index==4){newIndex=0;}
                    ref.read(expansionTileProvider.notifier).setIndex(4);
                  },
                  children: [
                    listItem(
                      context,
                      const Icon(Icons.inventory),
                      "ကုန်ပစ္စည်းလက်ကျန်",
                      () {
                        context.goNamed(RouteName.stockBalance);
                      },
                    ),
                    listItem(
                      context,
                      const Icon(Icons.inventory),
                      "အရေအတွက်နည်းနေသောကုန်ပစ္စည်း",
                      () {
                        context.goNamed(RouteName.stockReorder);
                      },
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Text(
                    "အကြွေးအစီရင်ခံစာ",
                    style: TextStyle(
                      fontSize: FontConst.tileTitleSize,
                    ),
                  ),
                  controller: ostTile,
                  onExpansionChanged: (_) {
                    // int newIndex = 5;
                    // if(index==5){newIndex=0;}
                    ref.read(expansionTileProvider.notifier).setIndex(5);
                  },
                  children: [
                    listItem(
                      context,
                      const Icon(Icons.attach_money),
                      "ရရန်ရှိအစီရင်ခံစာ",
                      () {
                        context.goNamed(RouteName.outstandingCustomer);
                      },
                    ),
                    listItem(
                      context,
                      const Icon(Icons.attach_money),
                      "ပေးရန်ရှိအစီရင်ခံစာ",
                      () {
                        context.goNamed(RouteName.outstandingSupplier);
                      },
                    ),
                  ],
                ),
                ListTile(
                  title: Text(
                    "စနစ်ထိမ်းသိမ်းခြင်း",
                    style: TextStyle(
                      fontSize: FontConst.tileTitleSize,
                    ),
                  ),
                  onTap: () {
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
                    onPressed: () async {
                      await logout();
                    },
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.white,
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> logout() async {
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
    ref.invalidate(starLinksProvider);
    // ignore: use_build_context_synchronously
    context.goNamed(RouteName.splash);
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
