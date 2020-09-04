import 'package:flutter/cupertino.dart';

class AppLocalization {
  final Locale locale;
  AppLocalization(this.locale);

  static Map<String, Map<String, String>> _localValue = {
    'en': {
      'task title': 'Flutter Demo',
      'appbar title': 'Flutter Demo Home Page',
      'click tip': 'you have pushed the button this many times:',
      'plus': 'Increment'
    },
    'zh': {
      'task title': 'Flutter 示例',
      'appbar title': 'Flutter 示例 主页',
      'click tip': '你一共点击了这么多次按钮:',
      'plus': '增加'
    }
  };

  get taskTitle {
    return _localValue[locale.languageCode]['task title'];
  }

  get appBarTitle {
    return _localValue[locale.languageCode]['appbar title'];
  }

  get clickTip {
    return _localValue[locale.languageCode]['click tip'];
  }

  get plus {
    return _localValue[locale.languageCode]['plus'];
  }
}
