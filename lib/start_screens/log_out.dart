import 'package:expanses_task11/data/local/db_helper.dart';
import 'package:expanses_task11/start_screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Logout extends StatefulWidget{
  @override
  State<Logout> createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  @override
  void initState() {
    removeUserInfo();
    super.initState();
  }

  void removeUserInfo()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(DbHelper.Prefs_uid, 0);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
      return LoginPage();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Log Out page"),
      ),
      body: Container(
      ),
    );
  }
}