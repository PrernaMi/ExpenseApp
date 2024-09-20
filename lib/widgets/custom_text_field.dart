import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  TextEditingController mController;
  double mRadius;
  String mHint;
  double? mBorderWidth;
  IconData mPrefixIcon;
  Color? mColor;
  TextInputType keyBoardType;
  String mLabel;
  double fieldWidth;

  CustomTextField(
      {required this.keyBoardType,
      required this.mLabel,
      required this.fieldWidth,
      required this.mPrefixIcon,
      required this.mController,
      required this.mRadius,
      required this.mHint,
      this.mBorderWidth,
      this.mColor});

  @override
  Widget build(BuildContext context) {
    bool isLight = Theme.of(context).brightness == Brightness.light;
    return SizedBox(
      width: fieldWidth,
      child: TextField(
        controller: mController,
        keyboardType: keyBoardType,
        decoration: InputDecoration(
          label: Text(mLabel),
          hintText: mHint,
          prefixIcon: Icon(mPrefixIcon),
          enabledBorder: getMyBorder(
              mRadius: mRadius,
              mWidth: mBorderWidth = 1,
              mColor: mColor = isLight? Colors.black: Colors.white
          ),
          focusedBorder: getMyBorder(
              mRadius: mRadius,
              mWidth: mBorderWidth = 2,
              mColor: isLight? Colors.black: Colors.white),
        ),
      ),
    );
  }

  InputBorder getMyBorder(
      {double mRadius = 12, required double mWidth, required Color mColor}) {
    return OutlineInputBorder(
      borderSide: BorderSide(width: mWidth, color: mColor),
      borderRadius: BorderRadius.circular(mRadius),
    );
  }
}
