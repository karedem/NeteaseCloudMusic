import 'package:flutter/material.dart';
import 'package:cloudMusic/core/base_widget.dart';

class CommonInkwell extends BaseStateLessWidget {
  Widget child;
  Function tap;
  CommonInkwell(this.child, {this.tap});

  @override
  Widget buildView() {
    return Material(
        type: MaterialType.transparency,
        child: InkWell(
          child: child,
          onTap: () {
            tap?.call();
          },
        ));
  }
}
