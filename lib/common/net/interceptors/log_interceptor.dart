/*
 * Filename: /Users/youzy/Documents/demo/flutter_app/lib/common/net/interceptors/log_interceptor.dart
 * Path: /Users/youzy/Documents/demo/flutter_app/lib/common/net/interceptors
 * Created Date: Tuesday, September 8th 2020, 4:26:25 pm
 * Author: Jason
 * 
 * Copyright (c) 2020 app
 */

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_app/common/config/config.dart';

/// log 拦截器
class LogsInterceptors extends InterceptorsWrapper {
  static List<Map> sHttpResponses = new List<Map>();
  static List<String> sResponsesHttpUrl = new List<String>();

  static List<Map<String, dynamic>> sHttpRequest =
      new List<Map<String, dynamic>>();
  static List<String> sRequestHttpUrl = new List<String>();
  static List<Map<String, dynamic>> sHttpError =
      new List<Map<String, dynamic>>();

  static List<String> sHttpErrorUrl = new List<String>();

  @override
  Future onRequest(RequestOptions options) async {
    if (Config.DEBUG) {
      print("请求Url: ${options.path}");
      print('请求头: ' + options.headers.toString());
      if (options.data != null) {
        print('请求参数: ' + options.data.toString());
      }
    }

    try {
      addLogic(sRequestHttpUrl, options.path);
      var data;
      if (options.data is Map) {
        data = options.data;
      } else {
        data = Map<String, dynamic>();
      }

      var map = {
        // "header:": {...options.headers},
      };
      if (options.method == "POST") {
        map["data"] = data;
      }
      addLogic(sHttpRequest, map);
    } catch (e) {
      print(e);
    }
    return options;
  }

  @override
  Future onResponse(Response response) {
    // TODO: implement onResponse
  }

  static addLogic(List list, data) {
    if (list.length > 20) {
      list.removeAt(0);
    }
    list.add(data);
  }
}
