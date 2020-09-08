/*
 * Filename: /Users/youzy/Documents/demo/flutter_app/lib/common/net/transformer.dart
 * Path: /Users/youzy/Documents/demo/flutter_app/lib/common/net
 * Created Date: Tuesday, September 8th 2020, 1:40:33 pm
 * Author: Jason
 * 
 * Copyright (c) 2020 app
 */


import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:flutter_app/model/Branch.dart';

part 'transformer.g.dart';

@SerializersFor(const [
  Branch,
])
final Serializers serializers = (_$serializers.toBuilder()
  ..addPlugin(new StandardJsonPlugin())
  ..add(new Iso8601DateTimeSerializer())
).build();