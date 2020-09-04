import 'dart:async';
import 'dart:convert';

import 'package:flutter_des/flutter_des.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';

/// SharedPreferences Util.
/// 支持加密对象 数组存取
class SpUtil {
  static const String Asckey = 'ghdeveloper)(*&^';
  static const String iv = 'ghdev123';

  static SpUtil _singleton;
  static SharedPreferences _prefs;
  static Lock _lock = Lock();

  static Future<SpUtil> getInstance() async {
    if (_singleton == null) {
      await _lock.synchronized(() async {
        if (_singleton == null) {
          // keep local instance till it is fully initialized.
          // 保持本地实例直到完全初始化。
          var singleton = SpUtil._();
          await singleton._init();
          _singleton = singleton;
        }
      });
    }
    return _singleton;
  }

  SpUtil._();

  Future _init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future reload() async {
    await _prefs.reload();
  }

  /// put object.
  static Future<bool> putObject(String key, Object value) {
    if (_prefs == null) return null;
    return _prefs.setString(key, value == null ? "" : json.encode(value));
  }

  /// put object with Encrypt
  static Future<bool> putEncObject(String key, Object value) async {
    String cipherText = await FlutterDes.encryptToHex(
        value == null ? "" : json.encode(value), Asckey,
        iv: iv);
    return putString(key, cipherText);
  }

  static Future<bool> putEncString(String key, String value) async {
    String cipherText =
        await FlutterDes.encryptToHex(value ?? "", Asckey, iv: iv);
    if (_prefs == null) return null;
    return _prefs.setString(key, cipherText);
  }

  static Future<String> getEncString(String key, {String defValue = ''}) async {
    String cipherText = getString(key, defValue: defValue);
    if (cipherText.length == 0) {
      return cipherText;
    }
    String text = await FlutterDes.decryptFromHex(cipherText, Asckey, iv: iv);
    return text;
  }

  /// get object with Decrypt
  static Future<T> getEncObj<T>(String key, T f(Map v), {T defValue}) async {
    String ciphertText = await getEncString(key);
    Map objMap = (ciphertText == null || ciphertText.isEmpty)
        ? null
        : json.decode(ciphertText);
    return objMap == null ? defValue : f(objMap);
  }

  /// get obj.
  static T getObj<T>(String key, T f(Map v), {T defValue}) {
    Map map = getObject(key);
    return map == null ? defValue : f(map);
  }

  /// get object.
  static Map getObject(String key) {
    if (_prefs == null) return null;
    String _data = _prefs.getString(key);
    return (_data == null || _data.isEmpty) ? null : json.decode(_data);
  }

  /// put object list.
  static Future<bool> putObjectList(String key, List<Object> list) {
    if (_prefs == null) return null;
    List<String> _dataList = list?.map((value) {
      return json.encode(value);
    })?.toList();
    return _prefs.setStringList(key, _dataList);
  }

  /// put object list with Encrypt
  static Future<bool> putEncObjList(String key, List<Object> list) async {
    if (_prefs == null) return null;
    Stream<Object> s = Stream.fromIterable(list);
    List<String> cipherList = [];
    await for (var obj in s) {
      String objStr = json.encode(obj);
      var ciphert = await FlutterDes.encryptToHex(objStr, Asckey, iv: iv);
      cipherList.add(ciphert);
    }
    return _prefs.setStringList(key, cipherList);
  }

  static Future<List<T>> getEncObjList<T>(String key, T f(Map v),
      {List<T> defValue = const []}) async {
    List<Map> dataList = await getEncObjectList(key);
    if (dataList == null) {
      return defValue;
    }
    List<T> list = dataList?.map((value) {
      return f(value);
    })?.toList();
    return list ?? defValue;
  }

  static Future<List<Map>> getEncObjectList(String key) async {
    if (_prefs == null) return Future.value([]);
    List<String> dataLis = _prefs.getStringList(key);
    if (dataLis == null) {
      return Future.value([]);
    }
    List<Map> res = [];
    Stream<String> s = Stream.fromIterable(dataLis);
    await for (var data in s) {
      String text = await FlutterDes.decryptFromHex(data, Asckey, iv: iv);
      res.add(json.decode(text));
    }
    return res;
  }

  /// get obj list.
  static List<T> getObjList<T>(String key, T f(Map v),
      {List<T> defValue = const []}) {
    List<Map> dataList = getObjectList(key);
    List<T> list = dataList?.map((value) {
      return f(value);
    })?.toList();
    return list ?? defValue;
  }

  /// get object list.
  static List<Map> getObjectList(String key) {
    if (_prefs == null) return null;
    List<String> dataLis = _prefs.getStringList(key);
    return dataLis?.map((value) {
      Map _dataMap = json.decode(value);
      return _dataMap;
    })?.toList();
  }

  /// get string.
  static String getString(String key, {String defValue = ''}) {
    if (_prefs == null) return defValue;
    return _prefs.getString(key) ?? defValue;
  }

  /// put string.
  static Future<bool> putString(String key, String value) {
    if (_prefs == null) return null;
    return _prefs.setString(key, value);
  }

  /// get bool.
  static bool getBool(String key, {bool defValue = false}) {
    if (_prefs == null) return defValue;
    return _prefs.getBool(key) ?? defValue;
  }

  /// put bool.
  static Future<bool> putBool(String key, bool value) {
    if (_prefs == null) return null;
    return _prefs.setBool(key, value);
  }

  /// get int.
  static int getInt(String key, {int defValue = 0}) {
    if (_prefs == null) return defValue;
    return _prefs.getInt(key) ?? defValue;
  }

  /// put int.
  static Future<bool> putInt(String key, int value) {
    if (_prefs == null) return null;
    return _prefs.setInt(key, value);
  }

  /// get double.
  static double getDouble(String key, {double defValue = 0.0}) {
    if (_prefs == null) return defValue;
    return _prefs.getDouble(key) ?? defValue;
  }

  /// put double.
  static Future<bool> putDouble(String key, double value) {
    if (_prefs == null) return null;
    return _prefs.setDouble(key, value);
  }

  /// get string list.
  static List<String> getStringList(String key,
      {List<String> defValue = const []}) {
    if (_prefs == null) return defValue;
    return _prefs.getStringList(key) ?? defValue;
  }

  /// put string list.
  static Future<bool> putStringList(String key, List<String> value) {
    if (_prefs == null) return null;
    return _prefs.setStringList(key, value);
  }

  /// get dynamic.
  static dynamic getDynamic(String key, {Object defValue}) {
    if (_prefs == null) return defValue;
    return _prefs.get(key) ?? defValue;
  }

  /// have key.
  static bool haveKey(String key) {
    if (_prefs == null) return null;
    return _prefs.getKeys().contains(key);
  }

  /// get keys.
  static Set<String> getKeys() {
    if (_prefs == null) return null;
    return _prefs.getKeys();
  }

  /// remove.
  static Future<bool> remove(String key) {
    if (_prefs == null) return null;
    return _prefs.remove(key);
  }

  /// clear.
  static Future<bool> clear() {
    if (_prefs == null) return null;
    return _prefs.clear();
  }

  ///Sp is initialized.
  static bool isInitialized() {
    return _prefs != null;
  }
}
