import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:cloudMusic/bean/wx_response.dart';
import 'package:cloudMusic/const/constkey.dart';
import 'package:cloudMusic/utils/log_plus.dart';
import 'package:cloudMusic/utils/sp_util.dart';
import 'package:cloudMusic/utils/urls.dart';
import 'package:oktoast/oktoast.dart';

/*
 * 封装 restful 请求
 *
 * GET、POST、DELETE、PATCH
 * 主要作用为统一处理相关事务：
 *  - 统一处理请求前缀；
 *  - 统一打印请求信息；
 *  - 统一打印响应信息；
 *  - 统一打印报错信息；
 */

class HttpUtils {
  /// global dio object
  static Dio dio;
  static Map sign_in_info;

  /// default options
  static const String API_PREFIX = 'http://118.24.63.15';
  static const String API_PREFIX_PRODUCT = 'https://wxapi.qtwo.fun';
  static const String API_PREFIX_LOCAL = 'http://118.24.63.15';
  static const int CONNECT_TIMEOUT = 10000;
  static const int RECEIVE_TIMEOUT = 12000;

  /// http request methods
  static const String GET = 'get';
  static const String POST = 'post';
  static const String PUT = 'put';
  static const String PATCH = 'patch';
  static const String DELETE = 'delete';

  static const num SUCCESS_CODE = 0;
  static const num FAIL_CODE = -200;
  static num last_jump_login_time = -1;
  /**
   * GET 请求
   *  【path】 在 $API_PREFIX 后 待拼接部分
   *  【params】 参数 Map类型
   */
  static Future<dynamic> get(path, params, {bool toast = true}) async {
    dio = createInstance();
    if (sign_in_info != null) {
      Map<String, dynamic> headers = Map();
      headers['Authorization'] = sign_in_info['Authorization'];
      dio.options.headers = headers;
    }
    Response resData;
    try {
      resData = await dio.get(path, queryParameters: params);
      WxResponse response = WxResponse.fromJson(resData.data);
      if (response.code != SUCCESS_CODE) {
        LogPlus.e(resData); //打印
        if (toast) {
          showToast(response.message); //提示
        }
        return FAIL_CODE; //返回失败
      }
      return response.data;
    } on DioError catch (e) {
      LogPlus.e("error in Get : url: $path " + e.error.toString());
      if (e.error.toString().contains('Http status error [40')) {
        bool refreshSuccess = await refreshToken();
        if (refreshSuccess) {
          return get(path, params); //刷新成功后重新请求一次
        }
      } else {
        return FAIL_CODE;
      }
    }
  }

  static Future<dynamic> baseGet(path, params, {bool toast = true}) async {
    dio = createInstance();
    if (sign_in_info != null) {
      Map<String, dynamic> headers = Map();
      headers['Authorization'] = sign_in_info['Authorization'];
      dio.options.headers = headers;
    }
    Response resData;
    try {
      resData = await dio.get(path, queryParameters: params);
      return WxResponse.fromJson(resData.data);
    } on DioError catch (e) {
      if (e.error.toString().contains('Http status error [40')) {
        bool refreshSuccess = await refreshToken();
        if (refreshSuccess) {
          return await get(path, params); //刷新成功后重新请求一次
        }
      }
      return FAIL_CODE;
    }
  }

//  static getImage(path) async {
//    var response = await http.get(path);
//    if (response.statusCode != SUCCESS_CODE) {
//      // LogPlus.e(resData); //打印
//      // toast("有一张图片失败"); //提示
//      return FAIL_CODE; //返回失败
//    }
//    return response.bodyBytes;
//  }

  /**
   * POST 请求
   *  【path】 在 $API_PREFIX 后 待拼接部分
   *  【params】 参数 Map类型
   */
  static Future<dynamic> post(path, params, {bool toast = false}) async {
    dio = createInstance();
    if (sign_in_info != null) {
      Map<String, dynamic> headers = Map();
      headers['Authorization'] = sign_in_info['Authorization'];
      dio.options.headers = headers;
    }
    Response resData;
    try {
      resData = await dio.post(path, data: params);
      WxResponse response = WxResponse.fromJson(resData.data);
      if (response.code != SUCCESS_CODE) {
        LogPlus.e("URL: $path  response: ${resData.toString()}"); //打印
        if (toast) {
          showToast(response.message); //提示
        }
        return FAIL_CODE; //返回失败
      }
      return response.data;
    } on DioError catch (e) {
      LogPlus.i('error ${e.error.toString()}');
      if (e.error.toString().compareTo('Http status error [401]') == 0 ||
          e.error.toString().compareTo('Http status error [403]') == 0) {
        bool refreshSuccess = await refreshToken();
        if (refreshSuccess) {
          return await post(path, params); //刷新成功后重新请求一次
        }
      } else if (e.error
          .toString()
          .contains('Network is unreachable, errno = 101')) {
        //未开启网络
        showToast('无网络连接');
      } else if (e.error
          .toString()
          .contains('SocketException: OS Error: No route to host')) {
        showToast('连接异常');
      }
      return FAIL_CODE;
    }
  }

  /**
   * POST 请求
   *  【path】 在 $API_PREFIX 后 待拼接部分
   *  【params】 参数 Map类型
   */
  static Future<dynamic> basePost(path, params, {bool toast}) async {
    dio = createInstance();
    if (sign_in_info != null) {
      Map<String, dynamic> headers = Map();
      headers['Authorization'] = sign_in_info['Authorization'];
      dio.options.headers = headers;
    }
    Response resData;
    try {
      resData = await dio.post(path, data: params);
      return WxResponse.fromJson(resData.data);
    } on DioError catch (e) {
      LogPlus.i('error ${e.error.toString()}');
      if (e.error.toString().contains('Http status error [40')) {
        bool refreshSuccess = await refreshToken();
        if (refreshSuccess) {
          return await post(path, params); //刷新成功后重新请求一次
        }
      } else if (e.error
          .toString()
          .contains('Network is unreachable, errno = 101')) {
        //未开启网络
        showToast('无网络连接');
      } else if (e.error
          .toString()
          .contains('SocketException: OS Error: No route to host')) {
        showToast('连接异常');
      }
      return FAIL_CODE;
    }
  }

  static Future<dynamic> put(path, params) async {
    dio = createInstance();
    if (sign_in_info != null) {
      Map<String, dynamic> headers = Map();
      headers['Authorization'] = sign_in_info['Authorization'];
      dio.options.headers = headers;
    }
    Response resData;
    try {
      resData = await dio.put(path, data: params);

      WxResponse response = WxResponse.fromJson(resData.data);
      if (response.code != SUCCESS_CODE) {
        LogPlus.e("URL: $path  response: ${resData.toString()}"); //打印
        showToast(response.message); //提示
        return FAIL_CODE; //返回失败
      }
      return response.data;
    } on DioError catch (e) {
      LogPlus.i('error ${e.error.toString()}');

      if (e.error.toString().contains('Http status error [40')) {
        bool refreshSuccess = await refreshToken();
        if (refreshSuccess) {
          return await post(path, params); //刷新成功后重新请求一次
        }
      } else if (e.error
          .toString()
          .contains('Network is unreachable, errno = 101')) {
        //未开启网络
        showToast('无网络连接');
      } else if (e.error
          .toString()
          .contains('SocketException: OS Error: No route to host')) {
        showToast('连接异常');
      }
      return FAIL_CODE;
    }
  }

  static Future<dynamic> basePut(path, params) async {
    dio = createInstance();
    if (sign_in_info != null) {
      Map<String, dynamic> headers = Map();
      headers['Authorization'] = sign_in_info['Authorization'];
      dio.options.headers = headers;
    }
    Response resData;
    try {
      resData = await dio.put(path, data: params);
      return WxResponse.fromJson(resData.data);
    } on DioError catch (e) {
      LogPlus.e(
          'error path: $path params:${json.encode(params)} ${e.error.toString()}');
      if (e.error.toString().contains('Http status error [40')) {
        bool refreshSuccess = await refreshToken();
        if (refreshSuccess) {
          return await post(path, params); //刷新成功后重新请求一次
        }
      } else if (e.error
          .toString()
          .contains('Network is unreachable, errno = 101')) {
        //未开启网络
        showToast('无网络连接');
      } else if (e.error
          .toString()
          .contains('SocketException: OS Error: No route to host')) {
        showToast('连接异常');
      }
      return FAIL_CODE;
    }
  }

  ///重新获取token
  static Future<bool> refreshToken() async {
    String refreshToken = SpUtil.getString(ConstKey.refreshTokenKey);

    if (refreshToken == null || refreshToken.isEmpty) {
      //showToast('登陆状态已失效～');
      return Future.value(false);
    }
    Map<String, dynamic> params = Map();
    params['client_id'] = 'app';
    params['client_secret'] = '123456';
    params['grant_type'] = 'refresh_token';
    params['refresh_token'] = refreshToken;
    sign_in_info = null;
    createInstance().options.headers = Map();
    LogPlus.i('refreshToken req : ${json.encode(params)}');
    var res = await form(URL.Login, params);
    LogPlus.i('refreshToken res : ${json.encode(res)}');
    if (res is num) {
      showToast('登陆状态已失效～');
      return Future.value(false);
    }
    //LoginInfoEntity loginInfo = LoginInfoEntity.fromJson(res);
//    String auth =
//        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX25hbWUiOiJPUEVOSUQ6b3pWOEM1YjFWMnAwLXp5LW5ub3FEakh0ZTFMRSIsInNjb3BlIjpbImFsbCJdLCJleHAiOjE1OTE4NTU2MzIsInVzZXJHdWlkIjoiNTEzMDVhYTUwZWJjNDM4MzhmZDc3ZmNlNWQxNjQ2MTciLCJ1c2VySWQiOjgsImF1dGhvcml0aWVzIjpbIlJPTEVfVVNFUiJdLCJqdGkiOiIzZTEwOTgzZC0wNjQ1LTQyNjYtODI5Ny1mYTY4MjdjMDYyOTgiLCJjbGllbnRfaWQiOiJhcHAifQ.JNv6u5FleJ2BvvaMdVOoOF1tdY_HQA7ft8kB-jAthVM';
//    sign_in_info = Map()..['Authorization'] = auth;
//    sign_in_info = Map()..['Authorization'] = "Bearer " + loginInfo.accessToken;
//    bool b = await SpUtil.putString(
//        ConstKey.refreshTokenKey, loginInfo.refreshToken);
//    LogPlus.i('save Authorization res : $b');
    return Future.value(false);
  }

  /**
   * POST 请求
   *  【path】 在 $API_PREFIX 后 待拼接部分
   *  【params】 参数 Map类型
   */
  static postNoToast(path, params) async {
    dio = createInstance();
    if (sign_in_info != null) {
      Map headers = dio.options.headers;
      headers['Authorization'] = sign_in_info['Authorization'];
      dio.options.headers = headers;
    }
    Response resData = await dio.post(path, data: params);
    WxResponse response = WxResponse.fromJson(resData.data);
    if (response.code != SUCCESS_CODE) {
      LogPlus.e("URL: $path  response: ${resData.toString()}"); //打印
      return FAIL_CODE; //返回失败
    }
    return response.data;
  }

  ///form请求 不论失败与否 不刷新token
  static Future<dynamic> formWithoutRefresh(path, params) async {
    dio = createInstance();
    FormData formParams = FormData.fromMap(params);
    // FormData formParams = FormData.fromMap(params);
    if (sign_in_info != null) {
      Map<String, dynamic> headers = Map();
      headers['Authorization'] = sign_in_info['Authorization'];
      dio.options.headers = headers;
    }
    Response resData;
    try {
      resData = await dio.post(path, data: formParams);
      WxResponse response = WxResponse.fromJson(resData.data);
      if (response.code != SUCCESS_CODE) {
        LogPlus.e(resData); //打印
        showToast(response.message); //提示
        return FAIL_CODE; //返回失败
      }
      return response.data;
    } on DioError catch (_) {
      return FAIL_CODE;
    }
  }

  /**
   * POST 请求  (实际送的是form数据)
   * 【path】 在 $API_PREFIX 后 待拼接部分
   * 【params】 参数 Map类型
   */
  static Future<dynamic> form(path, params, {bool toast = true}) async {
    dio = createInstance();
    FormData formParams = FormData.fromMap(params);
    // FormData formParams = FormData.fromMap(params);
    if (sign_in_info != null) {
      Map<String, dynamic> headers = Map();
      headers['Authorization'] = sign_in_info['Authorization'];
      dio.options.headers = headers;
    }
    Response resData;
    try {
      resData = await dio.post(path, data: formParams);
      WxResponse response = WxResponse.fromJson(resData.data);
      if (response.code != SUCCESS_CODE) {
        LogPlus.e(resData); //打印
        if (toast) {
          showToast(response.message); //提示
        }
        return FAIL_CODE; //返回失败
      }
      return response.data;
    } on DioError catch (e) {
      if (e.error.toString().compareTo('Http status error [401]') == 0) {
        LogPlus.i('http_error :' + e.error);
        bool refreshSuccess = await refreshToken();
        if (refreshSuccess) {
          return await form(path, params); //刷新成功后重新请求一次
        }
      }
      return FAIL_CODE;
    }
  }

  /// 创建 dio 实例对象
  static Dio createInstance() {
    if (dio == null) {
      /// 全局属性：请求前缀、连接超时时间、响应超时时间
      BaseOptions options = BaseOptions(
          baseUrl: API_PREFIX,
          connectTimeout: CONNECT_TIMEOUT,
          receiveTimeout: RECEIVE_TIMEOUT,
          contentType: Headers.jsonContentType,
//          contentType: ContentType.parse("application/x-www-form-urlencoded"),
          headers: {
            "Content-Type": "application/json",
          });
      dio = Dio(options);
    }
    return dio;
  }

  //登陆之后 赋值uid和token
  static setSignInInfo(Map map) {
    if (map['Authorization'] == null) {
      LogPlus.e(map.toString());
      return;
    }
//    String auth =
//        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX25hbWUiOiJPUEVOSUQ6b3pWOEM1YjFWMnAwLXp5LW5ub3FEakh0ZTFMRSIsInNjb3BlIjpbImFsbCJdLCJleHAiOjE1OTE4NTU2MzIsInVzZXJHdWlkIjoiNTEzMDVhYTUwZWJjNDM4MzhmZDc3ZmNlNWQxNjQ2MTciLCJ1c2VySWQiOjgsImF1dGhvcml0aWVzIjpbIlJPTEVfVVNFUiJdLCJqdGkiOiIzZTEwOTgzZC0wNjQ1LTQyNjYtODI5Ny1mYTY4MjdjMDYyOTgiLCJjbGllbnRfaWQiOiJhcHAifQ.JNv6u5FleJ2BvvaMdVOoOF1tdY_HQA7ft8kB-jAthVM';
//    map['Authorization'] = auth;
    sign_in_info = map;
  }

  /// 清空 dio 对象
  static clear() {
    dio = null;
  }
}
