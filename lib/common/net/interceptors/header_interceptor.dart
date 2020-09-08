/*
 * Filename: /Users/youzy/Documents/demo/flutter_app/lib/common/net/interceptors/header_interceptor.dart
 * Path: /Users/youzy/Documents/demo/flutter_app/lib/common/net/interceptors
 * Created Date: Tuesday, September 8th 2020, 4:23:32 pm
 * Author: Jason
 * 
 * Copyright (c) 2020 app
 */

import 'package:dio/dio.dart';

//header 拦截器
class HeaderInterceptors extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) async {
    // 超时
    options.connectTimeout = 30000;
    options.receiveTimeout = 30000;
    return options;
  }
}
