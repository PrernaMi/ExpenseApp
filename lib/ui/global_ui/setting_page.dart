import 'package:expanses_task11/start_screens/log_out.dart';
import 'package:expanses_task11/widgets/custom_text_style.dart';
import 'package:expanses_task11/widgets/icon_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../provider/theme_provider.dart';

class SettingPage extends StatefulWidget {
  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isLight = false;

  @override
  Widget build(BuildContext context) {
    isLight = Theme.of(context).brightness == Brightness.light;
    String themeText = isLight ? "Dark Mode" : "Light Mode";
    List<dynamic> mList = [
      Row(
        children: [
          Text(
            themeText,
            style: CustomTextStyle.mTextStyle20(
                fontWeight: FontWeight.bold, isLight: isLight),
          ),
          SizedBox(
            width: 10,
          ),
          Switch.adaptive(
              value: context.watch<ThemeProvider>().getTheme(),
              onChanged: (value) {
                context.read<ThemeProvider>().changeTheme(value);
              })
        ],
      ),
      Text(
        'Logout',
        style: CustomTextStyle.mTextStyle20(
            fontWeight: FontWeight.bold, isLight: isLight),
      )
    ];

    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Settings")),
        ),
        body: ListView.builder(
            itemCount: mList.length,
            itemBuilder: (_, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      onTapped(index: index);
                      setState(() {});
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: mList[index],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey, width: 2))),
                  )
                ],
              );
            }));
  }

  onTapped({required int index}) {
    if (index == 1) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return Logout();
      }));
    }
  }
}
