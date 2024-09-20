import 'dart:ui';

import 'package:flutter/material.dart';

class CustomTextStyle {

  static TextStyle mTextStyle14({
    Color color = Colors.black,
    bool isLight = false,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextStyle(
      color: isLight == true ? Colors.black : Colors.white,
      fontSize: 14,
      fontWeight: fontWeight
    );
  }
  static TextStyle mTextStyle20({
    Color color = Colors.black,
    bool isLight = false,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextStyle(
        color: isLight == true ? Colors.black : Colors.white,
        fontSize: 20,
        fontWeight: fontWeight
    );
  }

  TextStyle mTextStyle11({
    Color color = Colors.black,
    bool isLight = false,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextStyle(
        color: isLight == true ? Colors.black : Colors.white,
        fontSize: 11,
        fontWeight: fontWeight
    );
  }
  TextStyle mTextStyle12({
    Color color = Colors.black,
    bool isLight = false,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextStyle(
        color: isLight == true ? Colors.black : Colors.white,
        fontSize: 12,
        fontWeight: fontWeight
    );
  }

  TextStyle mTextStyle22({
    Color color = Colors.black,
    bool isLight = false,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextStyle(
        color: isLight == true ? Colors.black : Colors.white,
        fontSize: 22,
        fontWeight: fontWeight
    );
  }
  TextStyle mTextStyle17({
    Color color = Colors.black,
    bool isLight = false,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextStyle(
        color: isLight == true ? Colors.black : Colors.white,
        fontSize: 14,
        fontWeight: fontWeight
    );
  }
}
