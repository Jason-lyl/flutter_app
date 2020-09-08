/*
 * Filename: /Users/youzy/Documents/demo/flutter_app/lib/model/Branch.dart
 * Path: /Users/youzy/Documents/demo/flutter_app/lib/model
 * Created Date: Tuesday, September 8th 2020, 1:43:10 pm
 * Author: Jason
 * 
 * Copyright (c) 2020 app
 */

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

/*
Part与import有什么区别
可见性：
如果说在A库中import了B库，A库对B库是不可见的，也就是说B库是无法知道A库的存在的。
而part的作用是将一个库拆分成较小的组件。两个或多个part共同构成了一个库，它们彼此之间是知道互相的存在的。

作用域：import不会完全共享作用域，而part之间是完全共享的。如果说在A库中import了B库，
B库import了C库，A库是没有办法直接使用C库的对象的。
而B,C若是A的part，那么三者共享所有对象。并且包含所有导入

*/
part 'Branch.g.dart';


abstract class Branch implements Built<Branch, BranchBuilder> {
  static Serializer<Branch> get serializer => _$branchSerializer;

  @nullable
  String get name;

  @nullable
  @BuiltValueField(wireName: 'tarball_url')
  String get tarballUrl;

  @nullable
  @BuiltValueField(wireName: 'zipball_url')
  String get zipballUrl;


  Branch._();
  factory Branch([void Function(BranchBuilder) updates]) = _$Branch;
}

