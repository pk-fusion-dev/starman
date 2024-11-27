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
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SingleChildScrollView(
          child: _buildForm(),
        ));
  }

  Future<void> _register() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? passCode = prefs.getString("passcode");
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
          if(passCode==null){
            screenLockCreate(
              // ignore: use_build_context_synchronously
              context: context,
              config: ScreenLockConfig(
                // ignore: use_build_context_synchronously
                backgroundColor: Theme.of(context).colorScheme.surface,
                buttonStyle: const ButtonStyle(
                  foregroundColor: WidgetStatePropertyAll(Colors.white),
                ),
              ),
              canCancel: false,
              onConfirmed: (pin) {
                prefs.setString("starID", starID);
                prefs.setString("endDate", lastSubscriptionModel.licenseInfo!.endDate!);
                prefs.setString("passcode", pin);
                context.goNamed(RouteName.profitLost);
              },
            );
          }else{
            prefs.setString("starID", starID);
            prefs.setString("endDate", lastSubscriptionModel.licenseInfo!.endDate!);
            // ignore: use_build_context_synchronously
            context.goNamed(RouteName.splash);
          }
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
            height: 100,
          ),
          SizedBox(
            width: 200,
            height: 200,
            child: Image.asset("assets/images/Starman.png"),
          ),
          const Text(
            "Starman",
            style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),
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
                counter: null,
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
              onChanged: (value){
                // Store the previous text to compare changes
                String newValue = value.toUpperCase();

                // Remove the '-' if the user deletes it
                newValue = newValue.replaceAll('-', '');

                // Insert '-' after 4 characters
                if (newValue.length > 4) {
                  newValue = '${newValue.substring(0, 4)}-${newValue.substring(4)}';
                }

                // Limit the text to 9 characters
                if (newValue.length > 9) {
                  newValue = newValue.substring(0, 9);
                }

                // Update the controller only if the value has changed
                if (newValue != idController.text) {
                  idController.value = TextEditingValue(
                    text: newValue,
                    selection: TextSelection.collapsed(offset: newValue.length),
                  );
                }
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
            child: const Text(
              "REGISTER",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: .5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
