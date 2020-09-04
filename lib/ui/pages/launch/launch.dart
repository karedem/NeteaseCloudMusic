import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloudMusic/core/base_widget.dart';

class LaunchPage extends BaseStateLessWidget {
  @override
  Widget buildView() {
    ScreenUtil.getInstance().init(ctx);
    return Scaffold(
        body: SafeArea(
            child: Center(
                child: Text('启动页', style: TextStyle(fontSize: setSP(40))))));
  }
}
