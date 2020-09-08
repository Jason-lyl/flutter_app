/*
 * Filename: /Users/youzy/Documents/demo/flutter_app/lib/common/net/code.dart
 * Path: /Users/youzy/Documents/demo/flutter_app/lib/common/net
 * Created Date: Tuesday, September 8th 2020, 1:36:26 pm
 * Author: Jason
 * 
 * Copyright (c) 2020 app
 */

import 'package:flutter_app/common/event/http_error_event.dart';
import 'package:flutter_app/common/event/index.dart';

///错误编码
class Code {
  ///网络错误
  static const NETWORK_ERROR = -1;

  ///网络超时
  static const NETWORK_TIMEOUT = -2;

  ///网络返回数据格式化一次
  static const NETWORK_JSON_EXCEPTION = -3;

  ///Github APi Connection refused
  static const GITHUB_API_REFUSED = -4;

  static const SUCCESS = 200;

  static errorHandleFunction(code, message, noTip) {
    if (noTip) {
      return message;
    }
    if(message != null && message is String && (message.contains("Connection refused") || message.contains("Connection reset"))) {
      code = GITHUB_API_REFUSED;
    }
    eventBus.fire(new HttpErrorEvent(code, message));
    return message;
  }
}
