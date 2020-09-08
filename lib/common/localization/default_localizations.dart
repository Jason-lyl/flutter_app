/*
 * Filename: /Users/youzy/Documents/demo/flutter_app/lib/common/localization/default_localizations.dart
 * Path: /Users/youzy/Documents/demo/flutter_app/lib/common/localization
 * Created Date: Monday, September 7th 2020, 5:59:34 pm
 * Author: Jason
 * 
 * Copyright (c) 2020 app
 */

import 'package:flutter/material.dart';
import 'package:flutter_app/common/localization/gsy_string_base.dart';
import 'package:flutter_app/common/localization/gsy_string_en.dart';
import 'package:flutter_app/common/localization/gsy_string_zh.dart';

class GSYLocalizations {
  final Locale locale;

  GSYLocalizations(this.locale);

  static Map<String, GSYStringBase> _localizedValues = {
    'en': new GSYStringEn(),
    'zh': new GSYStringZh()
  };

  GSYStringBase get currentLocalized {
    if (_localizedValues.containsKey(locale.languageCode)) {
      return _localizedValues[locale.languageCode];
    }

    return _localizedValues["en"];
  }

  static GSYLocalizations of(BuildContext context) {
    return Localizations.of(context, GSYLocalizations);
  }

  static GSYStringBase is18n(BuildContext context) {
    return (Localizations.of(context, GSYLocalizations) as GSYLocalizations).currentLocalized;
  }
  
}
