/*
 * Filename: /Users/youzy/Documents/demo/flutter_app/lib/common/localization/gsy_locations_delegate.dart
 * Path: /Users/youzy/Documents/demo/flutter_app/lib/common/localization
 * Created Date: Tuesday, September 8th 2020, 9:55:26 am
 * Author: Jason
 * 
 * Copyright (c) 2020 app
 */

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/localization/default_localizations.dart';

class GSYLocationsDelegate extends LocalizationsDelegate<GSYLocalizations> {
  GSYLocationsDelegate();
  @override
  bool isSupported(Locale locale) {
    ///支持中文和英语
    return true;
  }

  ///根据locale，创建一个对象用于提供当前locale下的文本显示

  @override
  Future<GSYLocalizations> load(Locale locale) {
    return new SynchronousFuture<GSYLocalizations>(
        new GSYLocalizations(locale));
  }

  @override
  bool shouldReload(LocalizationsDelegate<GSYLocalizations> old) {
    // TODO: implement shouldReload
    return false;
  }

  static GSYLocationsDelegate delegate = new GSYLocationsDelegate();
}
