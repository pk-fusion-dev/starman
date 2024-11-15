import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starman/features/license/model/last_sub_model.dart';
import 'package:starman/features/license/provider/license_service_provider.dart';
import 'package:starman/routers/router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  late SharedPreferences prefs;
  String? starID;
  // ignore: prefer_typing_uninitialized_variables
  late final licenseService;
  bool isDisconnected = false;

  @override
  void initState() {
    licenseService = ref.read(licenseServiceProvider);
    super.initState();
    checkAuth();
  }

  Future<void> checkAuth() async {
    prefs = await SharedPreferences.getInstance();
    // prefs.remove("starID");
    starID = prefs.getString("starID");
    if (starID == null) {
      // ignore: use_build_context_synchronously
      context.goNamed(RouteName.register);
    } else {
      try {
        LastSubscriptionModel lastSubscriptionModel = await ref
            .read(licenseServiceProvider)
            .getLastSubscription(starID: starID!);
        // lastSubscriptionModel.licenseInfo?.licenseStatus = "op";
        if (lastSubscriptionModel.licenseInfo?.licenseStatus != "ACTIVE") {
          // ignore: use_build_context_synchronously
          context.goNamed(RouteName.expire);
        }
        // ignore: use_build_context_synchronously
        String? pin = prefs.getString("passcode");
        await screenLock(
            // ignore: use_build_context_synchronously
            context: context,
            correctString: pin!,
            canCancel: false,
            onUnlocked: () {
              context.goNamed(RouteName.profitLost);
            });
      } catch (e) {
        // setState(() {
        //   isDisconnected = true;
        // });
        Fluttertoast.showToast(msg: "No internet connection...");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
              child: SizedBox(
            width: 200,
            height: 200,
            child: Image.asset(
              "assets/images/logo.png",
            ),
          )),
          if (isDisconnected)
            const Align(
              alignment: Alignment.bottomCenter,
              child: Text("No internet connection..."),
            )
        ],
      ),
    );
  }
}
