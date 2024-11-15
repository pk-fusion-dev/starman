import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LicenseExpireScreen extends StatefulWidget {
  const LicenseExpireScreen({super.key});

  @override
  State<LicenseExpireScreen> createState() => _LicenseExpireScreenState();
}

class _LicenseExpireScreenState extends State<LicenseExpireScreen> {
  late final SharedPreferences prefs;
  late String? starID;

  @override
  void initState() {
    super.initState();
    starID = "";
    getStarId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: Image.asset("assets/images/logo.png"),
            ),
            Text(
              starID ?? "-",
              style: const TextStyle(fontSize: 18, color: Colors.green),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text("Your Starman license is expired."),
            const Text("Contact to 09427666386."),
          ],
        ),
      ),
    );
  }

  void getStarId() async {
    prefs = await SharedPreferences.getInstance();
    starID = prefs.getString("starID");
    setState(() {});
  }
}
