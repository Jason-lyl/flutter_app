/*
 * Filename: /Users/youzy/Documents/demo/flutter_app/lib/common/net/api.dart
 * Path: /Users/youzy/Documents/demo/flutter_app/lib/common/net
 * Created Date: Wednesday, September 9th 2020, 4:44:42 pm
 * Author: Jason
 * 
 * Copyright (c) 2020 app
 */

import 'dart:collection';
import 'package:dio/dio.dart';
import 'package:flutter_app/common/net/code.dart';
import 'package:flutter_app/common/net/interceptors/error_interceptor.dart';
import 'package:flutter_app/common/net/interceptors/header_interceptor.dart';
import 'package:flutter_app/common/net/interceptors/response_interceptor.dart';
import 'package:flutter_app/common/net/interceptors/token_interceptor.dart';
import 'package:flutter_app/common/net/result_data.dart';

/*
dio是一个强大的Dart Http请求库，
支持Restful API、FormData、拦截器、请求取消、Cookie管理、文件上传/下载、超时、自定义适配器等
*/
class HttpManager {
  static const CONTENT_TYPE_JSON = "application/json";
  static const CONTENT_TYPE_FORM = "application/x-www-form-urlencoded";

  Dio _dio = new Dio();
  final TokenInterceptors _tokenInterceptors = new TokenInterceptors();

  HttpManager() {
    _dio.interceptors.add(new HeaderInterceptors());
    _dio.interceptors.add(_tokenInterceptors);
    _dio.interceptors.add(new LogInterceptor());
    _dio.interceptors.add(ErrorInterceptors(_dio));
    _dio.interceptors.add(ResponseInterceptors());
  }

  Future<ResultData> netFetch(
      url, params, Map<String, dynamic> header, Options option,
      {noTip = false}) async {
    Map<String, dynamic> headers = new HashMap();
    if (header != null) {
      option.headers = headers;
    } else {
      option = new Options(method: "get");
      option.headers = header;
    }

    resultError(DioError e) {
      Response errorResponse;
      if (e.response != null) {
        errorResponse = e.response;
      } else {
        errorResponse = new Response(statusCode: 666);
      }
      if (e.type == DioErrorType.CONNECT_TIMEOUT ||
          e.type == DioErrorType.RECEIVE_TIMEOUT) {
        errorResponse.statusCode = Code.NETWORK_ERROR;
      }
      return new ResultData(
          Code.errorHandleFunction(errorResponse.statusCode, e.message, noTip),
          false,
          errorResponse.statusCode);
    }

    Response response;
    try {
      response = await _dio.request(url, data: params, options: option);
    } on DioError catch (e) {
      return resultError(e);
    }

    if (response is DioError) {
      return resultError(response.data);
    }
    return response.data;
  }

  /// 清除授权
  clearAuthorization() {
    _tokenInterceptors.clearAuthorization();
  }

  /// 获取授权token
  getAuthorization() {
    return _tokenInterceptors.getAuthorization();
  }
}

final HttpManager httpManager = new HttpManager();
