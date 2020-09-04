import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';
import 'package:cloudMusic/config/app_localization.dart';

class S extends LocalizationsDelegate<AppLocalization> {
  const S();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'zh'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalization> load(Locale locale) {
    return SynchronousFuture<AppLocalization>(AppLocalization(locale));
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalization> old) {
    return false;
  }

  static AppLocalization of(BuildContext context) {
    return Localizations.of(context, AppLocalization);
  }
}
