import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingDialog extends StatelessWidget {
  Widget buildView() {
    return Material(
        type: MaterialType.transparency, //透明类型
        child: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                width: ScreenUtil().setWidth(80),
                height: ScreenUtil().setWidth(80),
                decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().setWidth(10))),
                child: Theme(
                  data: ThemeData(
                      indicatorColor: Colors.white,
                      hintColor: Colors.white,
                      primaryColor: Colors.white),
                  child: CupertinoActivityIndicator(radius: 16.0),
                ))
            // Padding(
            //     padding: const EdgeInsets.only(top: 8.0), child: Text('正在加载数据'))
          ],
        )));
  }

  @override
  Widget build(BuildContext context) {
    return buildView();
  }
}
