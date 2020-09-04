import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloudMusic/utils/http_utils.dart';
import 'package:cloudMusic/utils/route_utils.dart';

class WxUtil {
  ///清除焦点
  static void clearFocus(ctx) {
    FocusScope.of(ctx).requestFocus(FocusNode());
  }

  ///秒转为倒计时
  static String formatLastTime(int allsecond) {
    if (allsecond <= 0) {
      return '${formatNumber(0)}:${formatNumber(0)}';
    }
    int hour = allsecond ~/ 3600;
    int minute = (allsecond % 3600) ~/ 60;
    int second = allsecond % 60;
    if (hour > 0) {
      return '${formatNumber(hour)}:${formatNumber(minute)}:${formatNumber(second)}';
    } else {
      return '${formatNumber(minute)}:${formatNumber(second)}';
    }
  }

  ///日期字符串转为距离天数
  static String dayformatLastTime(String time) {
    int allsecond = secFromDate(time);
    if (allsecond <= 0) {
      return '0';
    }
    int day = allsecond ~/ (3600 * 24);
    return day.toString();
  }

  static int getSecFromUTC(dynamic utc) {
    if (utc == null) {
      return -1;
    }
    if (utc is String) {
      return (int.tryParse(utc) - DateTime.now().millisecondsSinceEpoch) ~/
          1000;
    } else if (utc is int) {
      return (utc - DateTime.now().millisecondsSinceEpoch) ~/ 1000;
    }
  }

  static int getSecFromSec(dynamic sec) {
    return getSecFromUTC(sec * 1000);
  }

  ///传入时间-当前时间 的秒数
  static int secFromDate(String dateTime) {
    if (dateTime == null || dateTime.isEmpty) {
      return 0;
    }
    DateTime target = DateTime.parse(dateTime);
    return ((target.millisecondsSinceEpoch -
            DateTime.now().millisecondsSinceEpoch) ~/
        1000);
  }

  ///当前时间距离目标时间
  static String formatLastDateTime(String dateTime) {
    int sec = secFromDate(dateTime);
    return formatLastTime(sec);
  }

  static String formatNumber(int a) {
    return a < 10 ? '0$a' : '$a';
  }

  ///格式化时间
  static String formatDate(DateTime time, {String split, bool withT}) {
    int year = time.year;
    int month = time.month;
    int day = time.day;
    int hour = time.hour;
    int minute = time.minute;
    if (split == null) {
      split = '/';
    }
    String splitCenter = ' ';
    if (withT != null && withT) {
      splitCenter = 'T';
    }
    return '$year$split${month < 10 ? '0$month' : '$month'}$split${day < 10 ? '0$day' : '$day'}$splitCenter${hour < 10 ? '0$hour' : '$hour'}:${minute < 10 ? '0$minute' : '$minute'}';
  }

  static String formatYMD(DateTime time) {
    int year = time.year;
    int month = time.month;
    int day = time.day;
    return '$year/${month < 10 ? '0$month' : '$month'}/${day < 10 ? '0$day' : '$day'}';
  }

  ///格式化时间戳
  static String formatDateDMS2(DateTime time, {String split, bool withT}) {
    int second = time.second;
    return '${formatDate(time, split: split, withT: withT)}:${second < 10 ? '0$second' : '$second'}';
  }

  static bool matchMobile(String mobile) {
    RegExp exp = RegExp(
        r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    return exp.hasMatch(mobile);
  }

  ///格式化数字 超过10000用万表示
  static String formatCounts(int counts) {
    if (counts < 10000) {
      return "$counts";
    } else {
      return "${(counts / 10000).toStringAsFixed(1)}万";
    }
  }

  ///获取某一天最后的时间
  static DateTime getDayEndTime(DateTime time) {
    int year = time.year;
    int month = time.month;
    int day = time.day;
    String dataStr =
        '$year-${month < 10 ? '0$month' : '$month'}-${day < 10 ? '0$day' : '$day'} 23:59:59';
    return DateTime.parse(dataStr);
  }

  ///获取地理信息
  static Map getLocationInfo() {}

  ///获取本机信息
  static Map getMobileInfo() {}

  ///判断App在前台
  static bool isAPPFront() {}

  ///图片加载组件
  static Widget getImgWidget(url, {width, height}) {
    return CachedNetworkImage(
      fit: BoxFit.fill,
      width: width,
      height: height,
      imageUrl: url,
      placeholder: (context, url) => SizedBox(
          width: ScreenUtil().setWidth(5),
          height: ScreenUtil().setWidth(5),
          child: CupertinoActivityIndicator()),
      errorWidget: (context, url, error) => Icon(
        Icons.error,
        size: ScreenUtil().setSp(30),
      ),
    );
  }

  /// 判断是否有网络
  static Future<bool> hasNetWork() async {
    ConnectivityResult result = await (Connectivity().checkConnectivity());
    return result != ConnectivityResult.none;
  }

  static void judgeLoginThen(Function thenDo) {
    BuildContext context = RouteUtils.KEY.currentContext;
    if (HttpUtils.sign_in_info != null) {
      ///已经登陆
      thenDo?.call();
    } else {
      RouteUtils.pushNamed('login').then((value) {
        if (value != null && value == 0) {
          thenDo?.call();
        }
      });
    }
  }
}
