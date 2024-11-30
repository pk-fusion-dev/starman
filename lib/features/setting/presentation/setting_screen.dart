import 'package:flutter/material.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starman/components/custom_drawer.dart';

import '../../../routers/router.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  Future<void> changePassword(BuildContext context) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String passcode = prefs.getString("passcode")!;
    await Future.delayed(Durations.medium1,()async{
      screenLock(
        // ignore: use_build_context_synchronously
          context: context,
          config: ScreenLockConfig(
            // ignore: use_build_context_synchronously
            backgroundColor: Theme.of(context).colorScheme.surface,
            buttonStyle: const ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(Colors.white),
            ),
          ),
          correctString: passcode,
          canCancel: true,
          cancelButton: const Text("X"),
          onUnlocked: () async{
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
                prefs.setString("passcode", pin);
                context.goNamed(RouteName.splash);
              },
            );
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("စနစ်ထိမ်းသိမ်းခြင်း"),
      ),
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          listItem(
              context,
              const Icon(Icons.lock),
              "Change Password",
              () async{
                await changePassword(context);
              }
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
          style: const TextStyle(fontSize: 15),
        ),
        onTap: fun,
      ),
    );
  }
}
