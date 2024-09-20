import 'dart:async';
import 'package:expanses_task11/data/local/db_helper.dart';
import 'package:expanses_task11/ui/global_ui/dashBoard_page.dart';

import '../widgets/color_constant.dart';
import '../ui/global_ui/navPage.dart';
import 'login_page.dart';
import 'sign_up_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPreferences? prefs;
  int? uid;

  @override
  void initState() {
    nextPage();
    super.initState();
  }

  Widget page = NavPage();

  void nextPage() async {
    prefs = await SharedPreferences.getInstance();
    uid = prefs!.getInt(DbHelper.Prefs_uid);

    if (uid == null || uid == 0) {
      page = LoginPage();
    }

    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return page;
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/app_logo.png"),
            Text(
              "Monety",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: ColorConstant.colors[3].withOpacity(0.4),
        child: Image.asset(
            "assets/splash_img/non_tracking_expenses-removebg-preview.png"),
      ),
    );
  }
}
