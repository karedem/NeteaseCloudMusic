import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloudMusic/core/base_widget.dart';

class CommonBtn extends BaseStateLessWidget {
  Function click;
  Widget child;
  bool disable = false;
  Color disableColor = Colors.white70;

  CommonBtn(this.child, this.click, {bool disable, Color disableColor}) {
    if (disable != null) {
      this.disable = disable;
    }
    if (disableColor != null) {
      this.disableColor = disableColor;
    }
  }

  @override
  Widget buildView() {
    return CupertinoButton(
      padding: EdgeInsets.all(0.0),
      child: child,
      onPressed: disable ? null : click,
      disabledColor: disableColor,
      minSize: null,
      borderRadius: BorderRadius.circular(0.0),
    );
  }
}
