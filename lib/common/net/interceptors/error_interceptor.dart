/*
 * Filename: /Users/youzy/Documents/demo/flutter_app/lib/common/net/interceptors/error_interceptor.dart
 * Path: /Users/youzy/Documents/demo/flutter_app/lib/common/net/interceptors
 * Created Date: Tuesday, September 8th 2020, 4:11:32 pm
 * Author: Jason
 * 
 * Copyright (c) 2020 app
 */

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/common/net/code.dart';
import 'package:flutter_app/common/net/result_data.dart';

const NOT_TIP_KEY = "noTip";

///错误拦截
class ErrorInterceptors extends InterceptorsWrapper {
  final Dio _dio;

  ErrorInterceptors(this._dio);

  @override
  Future onRequest(RequestOptions options) async {
    //没有网络
    var connectivityResult = await (new Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      return _dio.resolve(new ResultData(
          Code.errorHandleFunction(Code.NETWORK_ERROR, "", false),
          false,
          Code.NETWORK_ERROR));
    }
    return options;
  }
}
