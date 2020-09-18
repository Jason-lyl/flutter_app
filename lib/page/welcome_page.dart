import 'package:flutter/material.dart';
import 'package:flutter_app/common/dao/user_dao.dart';
import 'package:flutter_app/redux/gsy_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'dart:async';
import 'package:redux/redux.dart';



/**
 * @author: Jason
 * @create_at: Sep 16, 2020
 */

@Deprecated("待完善")
class WelecomePage extends StatefulWidget {
  static final String sName = "/";

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

class _WelecomePageState extends State<WelecomePage> {
  bool hadInit = false;
  String text = "";
  double fontSize = 76;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (hadInit) {
      return;
    }
    hadInit = true;

    Store<GSYState> store = StoreProvider.of(context);
    new Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        text = "Welecome";
        fontSize = 60;
      });
    });

    new Future.delayed(const Duration(seconds: 1, milliseconds: 500), () {
      setState(() {
        text = "Flutter_app";
        fontSize = 60;
      });
    });
    new Future.delayed(const Duration(seconds: 2, microseconds: 500), () {
      UserDao.initUserInfo(store).then((res) {
        if (res != null && res.result) {

        } else {
        }
      });
    });
  }

  @override
  Widget build(Object context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
