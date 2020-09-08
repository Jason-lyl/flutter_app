/*
 * Filename: /Users/youzy/Documents/demo/flutter_app/lib/common/local/local_storage.dart
 * Path: /Users/youzy/Documents/demo/flutter_app/lib/common/local
 * Created Date: Monday, September 7th 2020, 5:41:48 pm
 * Author: Jason
 * 
 * Copyright (c) 2020 app
 */

import 'package:shared_preferences/shared_preferences.dart';

///本地存储
class LocalStorage {
  static save(String key, value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(key, value);
  }

  static get(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.get(key);
  }

  static remove(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove(key);
  }
}
