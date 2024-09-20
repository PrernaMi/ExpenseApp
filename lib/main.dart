import 'dart:async';

import 'package:expanses_task11/bloc/bloc_expense.dart';
import 'package:expanses_task11/data/local/db_helper.dart';
import 'package:expanses_task11/provider/theme_provider.dart';
import 'package:expanses_task11/start_screens/login_page.dart';
import 'package:expanses_task11/start_screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MultiBlocListener(listeners: [
    BlocProvider(
        create: (context) => ExpenseBloc(mainDb: DbHelper.getInstance)),
    ChangeNotifierProvider(create: (context) => ThemeProvider())
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<ThemeProvider>().getDefaultTheme();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "My App",
      //day theme
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      //night theme
      darkTheme: ThemeData(
        brightness: Brightness.dark,
       ),
      //provider is used for in switching the button it adapt the theme accordingly
      themeMode: context.watch<ThemeProvider>().getTheme()
          ? ThemeMode.dark
          : ThemeMode.light,
      home: SplashScreen(),
    );
  }
}
