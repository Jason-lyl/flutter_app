/*
 * Filename: /Users/youzy/Documents/demo/flutter_app/lib/common/net/interceptors/token_interceptor.dart
 * Path: /Users/youzy/Documents/demo/flutter_app/lib/common/net/interceptors
 * Created Date: Wednesday, September 9th 2020, 11:48:41 am
 * Author: Jason
 * 
 * Copyright (c) 2020 app
 */

import 'package:dio/dio.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/local/local_storage.dart';
import 'package:flutter_app/common/net/graphql/client.dart';

/// token 拦截器
class TokenInterceptors extends InterceptorsWrapper {
  String _token;

  @override
  onRequest(RequestOptions options) async {
    //授权码
    if (_token == null) {
      var authorizationCode = await getAuthorization();
      if (authorizationCode != null) {
        _token = authorizationCode;
        initClient(_token);
      }
    }
    options.headers["token"] = _token;
    return options;
  }

  @override
  onResponse(Response response) async {
    try {
      var responseJson = response.data;
      if (response.statusCode == 201 && responseJson["token"] != null) {
        _token = 'token ' + responseJson["token"];
        await LocalStorage.save(Config.TOKEN_KEY, _token);
      }
    } catch (e) {
      print(e);
    }
    return response;
  }

  //清除授权
  clearAuthorization() {
    this._token = null;
    LocalStorage.remove(Config.TOKEN_KEY);
    realeaseClient();
  }

  //获取授权token
  getAuthorization() async {
    String token = await LocalStorage.get(Config.TOKEN_KEY);
    if (token == null) {
      String basic = await LocalStorage.get(Config.USER_BASIC_CODE);
      if (basic == null) {
        //提示用户输入账号密码
      } else {
        //通过 basic 去获取token，获取到设置，返回token
        return "Basic $basic";
      }
    } else {
      this._token = token;
      return token;
    }
  }
}
