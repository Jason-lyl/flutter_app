import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/dao/user_dao.dart';
import 'package:flutter_app/common/style/gsy_style.dart';
import 'package:flutter_app/common/utils/navigator_utils.dart';
import 'package:flutter_app/redux/gsy_state.dart';
import 'package:flutter_app/widget/diff_scale_text.dart';
import 'package:flutter_app/widget/mole_widget.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:redux/redux.dart';

/**
 * @author: Jason
 * @create_at: Sep 16, 2020
 */

class WelecomePage extends StatefulWidget {
  static final String sName = "/";

@override
  _WelecomePageState createState() => _WelecomePageState();
}

class _WelecomePageState extends State<WelecomePage> {
  bool hadInit = false;
  String text = "";
  double fontSize = 76;

  @override
  void didChangeDependencies() {
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
          NavigatorUtils.goHome(context);
        } else {
          NavigatorUtils.goLogin(context);
        }
        return true;
      });
    });
  }

  @override
  Widget build(Object context) {
    return StoreBuilder<GSYState>(
      builder: (context, store) {
        double size = 20;
        return Material(
          child: new Container(
            color: GSYColors.white,
            child: Stack(
              children: <Widget>[
                new Center(
                  child: new Image(
                      image: new AssetImage('static/images/welcome.png')),
                ),
                Align(
                  alignment: Alignment(0.0, 0.3),
                  child: DiffScaleText(
                    text: text,
                    textStyle: GoogleFonts.akronim().copyWith(
                      color: GSYColors.primaryValue,
                      fontSize: fontSize,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment(0.0, 0.8),
                  child: Mole(),
                ),
                new Align(
                  alignment: Alignment.bottomCenter,
                  child: new Container(
                    width: size,
                    height: size,
                    child: new FlareActor("static/file/flare_flutter_logo_.flr",
                        alignment: Alignment.topCenter,
                        fit: BoxFit.fill,
                        animation: "Placeholder"),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
