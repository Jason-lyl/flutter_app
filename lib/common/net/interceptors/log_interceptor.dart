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
   onRequest(RequestOptions options) async {
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
        "header:": {...options.headers},
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
  onResponse(Response response) async {
    if (Config.DEBUG) {
      if (response != null) {
        print('返回参数: ' + response.data.toString());
      }
    }
    if (response.data is Map || response.data is List) {
      try {
        var data = Map<String, dynamic>();
        data["data"] = response.data;
        addLogic(
            sResponsesHttpUrl, response?.request?.baseUrl?.toString() ?? "");
        addLogic(sHttpResponses, data);
      } catch (e) {
        print(e);
      }
    } else if (response.data is String) {
      try {
        var data = Map<String, dynamic>();
        data["data"] = response.data;
        addLogic(sRequestHttpUrl, response?.request?.baseUrl?.toString() ?? "");
        addLogic(sHttpRequest, data);
      } catch (e) {
        print(e);
      }
    } else if (response.data != null) {
      try {
        String data = response.data.toJson();
        addLogic(
            sResponsesHttpUrl, response?.request?.baseUrl?.toString() ?? "");
        addLogic(sHttpResponses, json.decode(data));
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  onError(DioError err) async {
    if (Config.DEBUG) {
      print('请求异常: ' + err.toString());
      print('请求异常信息: ' + err.response?.toString() ?? "");
    }

    try {
      addLogic(sHttpErrorUrl, err.request.path ?? "null");
      var errors = Map<String, dynamic>();
      errors["error"] = err.message;
      addLogic(sHttpError, errors);
    } catch (e) {
      print(e);
    }
    return err;
  }

  static addLogic(List list, data) {
    if (list.length > 20) {
      list.removeAt(0);
    }
    list.add(data);
  }
}
