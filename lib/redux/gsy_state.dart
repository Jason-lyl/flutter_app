import 'package:flutter/material.dart';
import 'package:flutter_app/model/User.dart';
import 'package:flutter_app/redux/locale_redux.dart';
import 'package:flutter_app/redux/login_redux.dart';
import 'package:flutter_app/redux/theme_redux.dart';
import 'package:flutter_app/redux/user_redux.dart';
import 'package:redux/redux.dart';
import 'middleware/epic_middleware.dart';



/**
 * @author: Jason
 * @create_at: Sep 11, 2020
 */

///全局Redux store 的对象，保存State数据

class GSYState {
  /// 用户信息
  User userInfo;

  ///主题数据
  ThemeData themeData;

  ///语言
  Locale locale;

  ///当前手机平台默认语言
  Locale platformLocale;

  ///是否登录
  bool login;

  GSYState(
      {this.userInfo,
      this.themeData,
      this.locale,
      this.platformLocale,
      this.login});
}

GSYState appReducer(GSYState state, action) {
  return GSYState(
    ///通过 UserReducer 将 GSYState 内的 userInfo 和 action 关联在一起
    userInfo: UserReducer(state.userInfo, action),
    ///通过 ThemeDataReducer 将 GSYState 内的 themeData 和 action 关联在一起
    themeData: ThemeDataReducer(state.themeData, action),
        ///通过 LocaleReducer 将 GSYState 内的 locale 和 action 关联在一起
    locale: LocaleReducer(state.locale, action),
    login: LoginReducer(state.login, action),
  );
}

final List<Middleware<GSYState>> middleware = [
    EpicMiddleware<GSYState>(loginEpic),
    EpicMiddleware<GSYState>(userInfoEpic),
    EpicMiddleware<GSYState>(oauthEpic),
    UserInfoMiddleware(),
    LoginMiddleware(),


];
