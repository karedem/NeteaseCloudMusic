import 'package:flutter/material.dart';

class GlobalBean with ChangeNotifier {
  ///主题
  Theme theme;

  ///语言
  String localization;

  ///字体
  String fontStyle;

  ///字体大小缩放比例 x0.8 ~ x2.0
  double fontScale;

  double scaleHeight;

  double scaleWidth;

  int netWorkStatus;
}
