import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum RequestState {
  ///初始状态
  init,

  ///加载中
  loading,

  ///失败 重试刷新
  failed,

  ///无网络
  noNetwork,

  ///成功
  success,

  ///请求更多
  more,
}

abstract class TabProviderBean extends BaseProviderBean {
  requestWhenTabChange();
}

abstract class BaseProviderBean with ChangeNotifier {
  RequestState state = RequestState.init;

  request();

  setState(RequestState state) {
    this.state = state;
    notifyListeners();
  }

  num setH(h) {
    return ScreenUtil().setHeight(0.0 + h);
  }

  num setW(w) {
    return ScreenUtil().setWidth(0.0 + w);
  }
}
