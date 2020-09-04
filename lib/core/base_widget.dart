import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloudMusic/const/constkey.dart';
import 'package:cloudMusic/provider/base_provider_bean.dart';
import 'package:cloudMusic/provider/global_bean.dart';
import 'package:cloudMusic/utils/log_plus.dart';
import 'package:cloudMusic/utils/wxutils.dart';
import 'package:cloudMusic/widgets/common_btn.dart';
import 'package:cloudMusic/widgets/loading_dialog.dart';
import 'package:oktoast/oktoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'base_processer.dart';

abstract class BaseStateLessWidget extends StatelessWidget {
  Color deepPurple = Color(0xFF111d3b);
  BuildContext ctx;
  Future<Widget> dialog;

  ///PushName 传参 统一接收
  Map<String, dynamic> paramsMap;
  Widget buildView();

  @override
  StatelessElement createElement() {
    return super.createElement();
  }

  @override
  Widget build(BuildContext context) {
    paramsMap = ModalRoute.of(context).settings?.arguments as Map;
    ctx = context;
    return buildView();
  }

  void showtoast(msg, {Duration duration, ToastPosition position}) {
    showToast(msg,
        duration: duration ?? Duration(milliseconds: 1500),
        position: position ?? ToastPosition.center);
  }

  void showdialog(widget) {
    dialog = showDialog(context: ctx, child: widget);
  }

  void dissmissdialog() {
    if (dialog == null) {
      return;
    }
    Navigator.of(ctx).pop();
    dialog = null;
  }

  void showLoading() {
    dialog = showDialog(context: ctx, child: LoadingDialog());
  }

  num setH(h) {
    return ScreenUtil().setHeight(0.0 + h);
  }

  num setW(w) {
    return ScreenUtil().setWidth(0.0 + w);
  }

  num setSP(w) {
    return ScreenUtil().setSp(0.0 + w);
  }

  Future<bool> requestPermission() async {
    final permissions = await Permission.locationWhenInUse.request();
    bool alawys = await Permission.locationAlways.isGranted;
    if (permissions.isGranted || alawys) {
      return true;
    } else {
      return false;
    }
  }
}

abstract class BaseStatefulWidget extends StatefulWidget {
  BaseProviderBean getBean() {
    return null;
  }
}

@optionalTypeArgs
abstract class BaseState<T extends BaseStatefulWidget> extends State
    with WidgetsBindingObserver {
  Color deepPurple = Color(0xFF111d3b);
  Future<Widget> dialog;
  GlobalBean globalBean;
  int didChangeDepenTimes = 0;

  ///PushName 传参 统一接收
  Map<String, dynamic> paramsMap;
  BaseProcesser getProcess();

  ///若需要在无网络时显示 实现buildViewWithNetJudge
  @override
  Widget build(BuildContext context) {
//    LogPlus.i(
//        "${context.toString()} rebuild basePage didChangeDepenTimes : $didChangeDepenTimes");
    paramsMap = ModalRoute.of(context).settings?.arguments as Map;
    //globalBean = Provider.of<GlobalBean>(context);

    ///未实现带网络判断的view 即不需要判断时
    if (buildViewWithNetJudge(context) == null) {
      return buildView(context);
    }

    ///防止重复执行 didChangeDepenTimes 后重新判断网络状况 例如弹出键盘关闭键盘时
    return didChangeDepenTimes > 1
        ? buildViewWithNetJudge(context)
        : getJudgeNetWidget(buildViewWithNetJudge(context));
  }

  Widget getJudgeNetWidget(Widget view) {
    return FutureBuilder(
      future: WxUtil.hasNetWork(),
      builder: (ctx, shot) {
        var hasNetWork = shot.data as bool;
//        LogPlus.i(
//            "rebuild getJudgeNetWidget  \n shot.connectionState : ${shot.connectionState.toString()}");

        ///在判断网络状态时 为异步返回  判断过程显示loading
        if (shot.connectionState != ConnectionState.done) {
          return Container(
              color: deepPurple,
              child: Container(
                width: setW(30),
                height: setW(30),
                child: CupertinoActivityIndicator(
                    radius:
                        (setSP(20) == null || setSP(20) <= 0) ? 15 : setSP(20)),
              ));
        }
        num oldStatus = globalBean.netWorkStatus;
        globalBean.netWorkStatus = hasNetWork ? 1 : 0;

        ///无网络且无该页面缓存时  显示无网络页面
        if (!hasNetWork && !hasPageCache()) {
          return noNetworkWidget();
        }

        ///有网络
        if (hasNetWork && oldStatus == 0) {
          getProcess()?.initDo();
        } else {
          ///无网络 但有缓存
          getProcess()?.getDataFromCache();
        }
        return view;
      },
    );
  }

  /// 子类页面需缓存的  必须重载该方法
  bool hasPageCache() {
    return false;
  }

  Widget noNetworkWidget() {
    return Scaffold(
      backgroundColor: deepPurple,
      body: SafeArea(
        child: Stack(children: <Widget>[
          Image.asset(
            "images/bg.png",
            width: setW(ConstKey.MaxWidth),
            height: setH(ConstKey.MaxHeight),
            fit: BoxFit.fill,
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.only(top: setH(20), bottom: setH(10)),
              width: setW(ConstKey.MaxWidth - 50),
              decoration: BoxDecoration(
                  color: Color(0xFFe0dfe1),
                  borderRadius: BorderRadius.circular(setH(20))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    "images/ic_error.png",
                    width: setW(500),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('网络不给力, 请稍后',
                            style: TextStyle(
                                fontSize: setSP(30), color: Colors.black54)),
                        CommonBtn(
                            Text('重试',
                                style: TextStyle(
                                    fontSize: setSP(30),
                                    color: Colors.blue)), () {
                          setState(() {
                            didChangeDepenTimes = 1;
                          });
                        })
                      ])
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: setH(15)),
              child: Text(
                '── 大家都是有底线的 ──',
                style: TextStyle(fontSize: setSP(20), color: Colors.black26),
              ),
            ),
          )
        ]),
      ),
    );
  }

  ///有网络判断的buildView
  Widget buildViewWithNetJudge(BuildContext context) {
    return null;
  }

  ///不判断网络状态的view
  Widget buildView(BuildContext context) {
    return Container();
  }

  ///HotReload 会执行
  @override
  void reassemble() {
    LogPlus.i('reassemble');
    super.reassemble();
  }

  ///重新进入页面会加载
  @override
  void deactivate() {
    LogPlus.i('deactivate  ${this.toString()}');
    super.deactivate();
    if (getProcess() != null) {
      getProcess().deActiveDo();
    }
  }

  @override
  initState() {
    LogPlus.i("initState 被调用了  ${context.toString()}");
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (getProcess() != null) {
      getProcess().initDo()?.then((d) {});
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        //进入后台时关闭焦点
        //GHUtil.clearFocus(context);
        LogPlus.i('AppLifecycleState.inactive');
        if (getProcess() != null) {
          getProcess().inactiveDo();
        }
        break;
      case AppLifecycleState.paused:
        LogPlus.i('AppLifecycleState.paused');
        if (getProcess() != null) {
          getProcess().pausedDo();
        }
        if (globalBean != null) {}
        break;
      case AppLifecycleState.resumed:
        LogPlus.i('AppLifecycleState.resumed');
        if (getProcess() != null) {
          getProcess().resumedDo();
        }
        if (globalBean != null) {}
        break;
      default:
    }
  }

  @override
  void didChangeDependencies() {
    ///定义这个的初衷: 打开关闭dialog 键盘 都会重新执行此方法 并且重新build
    ///避免重新判断网络状态 页面被初始化
    LogPlus.i("didChangeDependencies 被调用了");
    didChangeDepenTimes++;
    if (didChangeDepenTimes > 1) {
      return;
    }
    super.didChangeDependencies();

    if (getProcess() != null) {
      getProcess().didChangeDependenciesDo();
    }
  }

  @override
  void didUpdateWidget(BaseStatefulWidget oldWidget) {
    LogPlus.i("didUpdateWidget 被调用了");
    super.didUpdateWidget(oldWidget);
    if (getProcess() != null) {
      getProcess().didUpdateWidgetDo();
    }
  }

  @override
  void dispose() {
    LogPlus.i("dispose 被调用了  ${this.toString()}");
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    if (getProcess() != null) {
      getProcess().disposeDo();
    }
  }

  void showtoast(msg, {Duration duration, ToastPosition position}) {
    showToast(msg, duration: duration ?? Duration(milliseconds: 1500));
  }

  void showdialog(widget) {
    dialog = showDialog(context: context, child: widget);
  }

  void dissmissdialog() {
    if (dialog == null) {
      return;
    }
    Navigator.of(context).pop();
    dialog = null;
  }

  void showLoading() {
    dialog = showDialog(context: context, child: LoadingDialog());
  }

  Future<bool> requestPermission() async {
    final permissions = await Permission.locationWhenInUse.request();
    bool alawys = await Permission.locationAlways.isGranted;
    if (permissions.isGranted || alawys) {
      return true;
    } else {
      return false;
    }
  }

  num setH(h) {
    return ScreenUtil().setHeight(0.0 + h) * (globalBean?.scaleHeight ?? 1.0);
  }

  num setW(w) {
    return ScreenUtil().setWidth(0.0 + w) * (globalBean?.scaleWidth ?? 1.0);
  }

  num setSP(w) {
    return ScreenUtil().setSp(0.0 + w) * (globalBean?.scaleHeight ?? 1.0);
  }
}
