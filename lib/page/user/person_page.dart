import 'package:flutter/material.dart';

/**
 * @author: Jason
 * @create_at: Sep 16, 2020
 */

@Deprecated("待完善")
class PersonPage extends StatefulWidget {
  static final String sName = "person";

  final String userName;
  PersonPage(this.userName, {Key key}) : super(key: key);

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
