///父处理者 生命周期方法回调
abstract class BaseProcesser {
  ///网络正常时的请求
  Future<dynamic> initDo();

  /// 从存储中读取缓存数据
  Future<dynamic> getDataFromCache() {
    return Future.value(null);
  }

  /// 页面不在前台时触发
  inactiveDo();

  ///页面不在前台时触发
  pausedDo();

  ///页面回到前台时触发
  resumedDo();

  ///页面第一次绘制完成时触发
  didChangeDependenciesDo();

  ///页面更新时触发
  didUpdateWidgetDo();

  ///页面销毁时触发
  disposeDo();

  ///页面销毁前
  deActiveDo();
}
