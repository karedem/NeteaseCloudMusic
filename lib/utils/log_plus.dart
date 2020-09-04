///控制日志打印
class LogPlus {
  static final bool isDebug = true; //正式打包需改为false
  static final bool showError = true; //正式打包需改为false

  //打印dubug信息
  static e(obj) {
    if (showError) {
      print("【ERROR!!】" + obj.toString());
    }
  }

  static i(obj) {
    if (isDebug) {
      print("【INFO】" + obj.toString());
    }
  }
}
