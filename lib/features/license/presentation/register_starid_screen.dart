import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starman/features/license/model/last_sub_model.dart';
import 'package:starman/features/license/model/star_group_model.dart';
import 'package:starman/features/license/provider/license_service_provider.dart';
import 'package:starman/routers/router.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';

class RegisterStarIdScreen extends ConsumerStatefulWidget {
  const RegisterStarIdScreen({super.key});

  @override
  ConsumerState<RegisterStarIdScreen> createState() =>
      _RegisterStarIdScreenState();
}

class _RegisterStarIdScreenState extends ConsumerState<RegisterStarIdScreen> {
  final idController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: SingleChildScrollView(
          child: _buildForm(),
        ));
  }

  Future<void> _register() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String starID = idController.text;
    try {
      StarGroupModel data =
          await ref.read(licenseServiceProvider).getStarGroup(starID: starID);
      if (data.id != null) {
        LastSubscriptionModel lastSubscriptionModel = await ref
            .read(licenseServiceProvider)
            .getLastSubscription(starID: starID);
        // prefs.setString("starID", starID);
        // prefs.setString("endDate", lastSubscriptionModel.licenseInfo!.endDate!);
        if (lastSubscriptionModel.licenseInfo?.licenseStatus == "ACTIVE") {
          // ignore: use_build_context_synchronously
          // context.goNamed(RouteName.expire);
          screenLockCreate(
            // ignore: use_build_context_synchronously
            context: context,
            canCancel: false,
            onConfirmed: (pin) {
              prefs.setString("starID", starID);
              prefs.setString("endDate", lastSubscriptionModel.licenseInfo!.endDate!);
              prefs.setString("passcode", pin);
              context.goNamed(RouteName.profitLost);
            },
          );
        } else {
          // ignore: use_build_context_synchronously
          context.goNamed(RouteName.expire);
        }
      } else {
        Fluttertoast.showToast(msg: "StarID is not exists...");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Something Wrong...");
    }
  }

  Widget _buildForm() {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 150,
          ),
          SizedBox(
            width: 200,
            height: 200,
            child: Image.asset("assets/images/sslogo.png"),
          ),
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withOpacity(.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextFormField(
              controller: idController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "StarID",
              ),
              style: const TextStyle(
                color: Colors.black,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "StarID is required";
                }
                return null;
              },
            ),
          ),
          CupertinoButton.filled(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                Fluttertoast.showToast(msg: "Please Wait...");
                _register();
              }
            },
            child: const Text("REGISTER"),
          ),
        ],
      ),
    );
  }
}
