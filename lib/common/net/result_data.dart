/*
 * Filename: /Users/youzy/Documents/demo/flutter_app/lib/common/net/result_data.dart
 * Path: /Users/youzy/Documents/demo/flutter_app/lib/common/net
 * Created Date: Tuesday, September 8th 2020, 1:38:09 pm
 * Author: Jason
 * 
 * Copyright (c) 2020 app
 */

class ResultData {
  var data;
  bool result;
  int code;
  var headers;

  ResultData(this.data, this.result, this.code, {this.headers});
}