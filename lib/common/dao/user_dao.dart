import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/config/ignoreConfig.dart';
import 'package:flutter_app/common/dao/dao_result.dart';
import 'package:flutter_app/common/local/local_storage.dart';
import 'package:flutter_app/common/net/address.dart';
import 'package:flutter_app/common/net/api.dart';
import 'package:flutter_app/common/net/graphql/client.dart';
import 'package:flutter_app/common/utils/common_utils.dart';
import 'package:flutter_app/db/provider/user/user_followed_db_provider.dart';
import 'package:flutter_app/db/provider/user/user_orgs_db_provider.dart';
import 'package:flutter_app/db/provider/user/userinfo_db_provider.dart';
import 'package:flutter_app/model/SearchUserQL.dart';
import 'package:flutter_app/model/User.dart';
import 'package:flutter_app/model/UserOrg.dart';
import 'package:flutter_app/redux/locale_redux.dart';
import 'package:flutter_app/redux/user_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_app/model/Notification.dart' as Model;

/**
 * @author: Jason
 * @create_at: Sep 14, 2020
 */

class UserDao {
  static oauth(code, store) async {
    httpManager.clearAuthorization();
    var res = await httpManager.netFetch(
        "https://github.com/login/oauth/access_token?"
        "client_id=${NetConfig.CLIENT_ID}"
        "&client_secret=${NetConfig.CLIENT_SECRET}"
        "&code=${code}",
        null,
        null,
        null);

    var resultData = null;
    if (res != null && res.result) {
      print("######## ${res.data}");
      var result = Uri.parse("gsy://oauth?" + res.data);
      var token = result.queryParameters["access_token"];
      var _token = 'token' + token;
      await LocalStorage.save(Config.TOKEN_KEY, _token);
      resultData = await getUserInfo(null);
      if (Config.DEBUG) {
        print("user result " + resultData.result.toString());
        print(resultData.data);
        print(res.data.toString());
      }
      if (resultData.result == true) {
        store.dispatch(new UpdateUserAction(resultData.data));
      }
    }
    return new DataResult(resultData, res.result);
  }

  /// 获取本地登录用户信息
  static getUserInfoLocal() async {
    var userText = await LocalStorage.get(Config.USER_INFO);
    if (userText != null) {
      var userMap = json.decode(userText);
      User user = User.fromJson(userMap);
      return new DataResult(user, true);
    } else {
      return new DataResult(null, false);
    }
  }

  static login(userName, password, store) async {
    String type = userName + ":" + password;
    var bytes = utf8.encode(type);
    var base64Str = base64.encode(bytes);
    if (Config.DEBUG) {
      print("base64Str login" + base64Str);
    }
    await LocalStorage.save(Config.USER_NAME_KEY, userName);
    await LocalStorage.save(Config.USER_BASIC_CODE, base64Str);
    Map requestParams = {
      "scopes": ['user', 'repo', 'gist', 'notifications'],
      "note": "admin_script",
      "client_id": NetConfig.CLIENT_ID,
      "client_secret": NetConfig.CLIENT_SECRET
    };
    httpManager.clearAuthorization();

    var res = await httpManager.netFetch(Address.getAuthorization(),
        json.encode(requestParams), null, new Options(method: 'post'));
    var resultData = null;
    if (res != null && res.result) {
      await LocalStorage.save(Config.PW_KEY, password);
      var resultData = await getUserInfo(null);
      if (Config.DEBUG) {
        print("user result " + resultData.result.toString());
        print(resultData.data);
        print(res.data.toString());
      }
      store.dispatch(new UpdateUserAction(resultData.data));
    }
    return new DataResult(resultData, res.result);
  }

  /// 初始化用户信息
  static initUserInfo(Store store) async {
    var token = await LocalStorage.get(Config.TOKEN_KEY);
    var res = await getUserInfoLocal();
    if (res != null && res.result && token != null) {
      store.dispatch(UpdateUserAction(res.data));
    }

    ///读取主题
    String themeIndex = await LocalStorage.get(Config.THEME_COLOR);
    if (themeIndex != null && themeIndex.length != 0) {
      CommonUtils.pushTheme(store, int.parse(themeIndex));
    }

    ///切换语言
    String localIndex = await LocalStorage.get(Config.LOCALE);
    if (localIndex != null && localIndex.length != 0) {
      CommonUtils.changeLocale(store, int.parse(localIndex));
    } else {
      CommonUtils.curLocale = store.state.platformLocale;
      store.dispatch(RefreshLocaleAction(store.state.platformLocale));
    }
    return new DataResult(res.data, (res.result && (token != null)));
  }

  /// 获取用户详细信息
  static getUserInfo(userName, {needDb = false}) async {
    UserInfoDbProvider provider = new UserInfoDbProvider();
    next() async {
      var res;
      if (userName == null) {
        res = await httpManager.netFetch(
            Address.getMyUserInfo(), null, null, null);
      } else {
        res = await httpManager.netFetch(
            Address.getUserInfo(userName), null, null, null);
      }
      if (res != null && res.result) {
        String starred = "---";
        if (res.data["type"] != "Origanization") {
          var countRes = await getUserStaredCountNet(res.data["login"]);
          if (countRes.result) {
            starred = countRes.data;
          }
        }
        User user = User.fromJson(res.data);
        user.starred = starred;
        if (userName == null) {
          LocalStorage.save(Config.USER_INFO, json.encode(user.toJson()));
        } else {
          if (needDb) {
            provider.insert(userName, json.encode(user.toJson()));
          }
        }
        return new DataResult(user, true);
      } else {
        return new DataResult(null, false);
      }
    }

    if (needDb) {
      User user = await provider.getUserInfo(userName);
      if (user == null) {
        return await next();
      }
      DataResult dataResult = new DataResult(user, true, next: next);
      return dataResult;
    }
    return await next();
  }

  static clearAll(Store store) async {
    httpManager.clearAuthorization();
    LocalStorage.remove(Config.USER_INFO);
    store.dispatch(new UpdateUserAction(User.empty()));
  }

  /// 在header 中提起 stared count
  static getUserStaredCountNet(userName) async {
    String url = Address.userStar(userName, null) + "&per_page=1";
    var res = await httpManager.netFetch(url, null, null, null);
    if (res != null && res.result && res.headers != null) {
      try {
        List<String> link = res.headers['link'];
        if (link != null) {
          int indexStart = link[0].lastIndexOf("page=") + 5;
          int indexEnd = link[0].lastIndexOf(">");
          if (indexStart >= 0 && indexEnd >= 0) {
            String count = link[0].substring(indexStart, indexEnd);
            return new DataResult(count, true);
          }
        }
      } catch (e) {
        print(e);
      }
    }
    return new DataResult(null, false);
  }

  /// 获取用户粉丝列表
  static getFollowerListDao(userName, page, {needDb = false}) async {
    UserFollowedDbProvider provider = new UserFollowedDbProvider();
    next() async {
      String url =
          Address.getUserFollower(userName) + Address.getPageParams("?", page);
      var res = await httpManager.netFetch(url, null, null, null);
      if (res != null && res.result) {
        List<User> list = new List();
        var data = res.data;
        if (data == null || data.length == 0) {
          return new DataResult(null, false);
        }
        for (var i = 0; i < data.length; i++) {
          list.add(new User.fromJson(data[i]));
        }
        if (needDb) {
          provider.insert(userName, json.encode(data));
        }
        return new DataResult(list, true);
      } else {
        return new DataResult(null, false);
      }
    }

    if (needDb) {
      List<User> list = await provider.geData(userName);
      if (list == null) {
        return await next();
      }
      DataResult dataResult = new DataResult(list, true, next: next);
      return dataResult;
    }
    return await next();
  }

  /// 获取用户关注列表
  static getFollowedListDao(userName, page, {needDb = false}) async {
    UserFollowedDbProvider provider = new UserFollowedDbProvider();
    next() async {
      String url =
          Address.getUserFollow(userName) + Address.getPageParams("?", page);
      var res = await httpManager.netFetch(url, null, null, null);
      if (res != null && res.result) {
        List<User> list = new List();
        var data = res.data;
        if (data == null || data.kength) {
          return new DataResult(null, false);
        }
        for (var i = 0; i < data.length; i++) {
          list.add(new User.fromJson(data[i]));
        }
        if (needDb) {
          provider.insert(userName, json.encode(data));
        }
        return new DataResult(list, true);
      } else {
        return new DataResult(null, false);
      }
    }

    if (needDb) {
      List<User> list = await provider.geData(userName);
      if (list == null) {
        return await next();
      }
      DataResult dataResult = new DataResult(list, true, next: next);
      return dataResult;
    }
    return await next();
  }

  /// 获取用户通知
  static getNotifyDao(bool all, bool participating, page) async {
    String tag = (!all && !participating) ? '?' : '&';
    String url = Address.getNotifation(all, participating) +
        Address.getPageParams(tag, page);
    var res = await httpManager.netFetch(url, null, null, null);
    if (res != null && res.result) {
      List<Model.Notification> list = new List();
      var data = res.data;
      if (data == null || data.length == 0) {
        return new DataResult([], true);
      }
      for (var i = 0; i < data.length; i++) {
        list.add(Model.Notification.fromJson(data[i]));
      }
      return new DataResult(list, true);
    } else {
      return new DataResult(null, false);
    }
  }

  /// 设置单个通知已读
  static setNotificationAsReadDao(id) async {
    String url = Address.setNotificationAsRead(id);
    var res = await httpManager
        .netFetch(url, null, null, new Options(method: 'PATCH'), noTip: true);
    return res;
  }

  /// 设置所有通知已读
  static setAllNotificationAsReadDao() async {
    String url = Address.setAllNotificationAsRead();
    var res =
        await httpManager.netFetch(url, null, null, new Options(method: "PUT"));
    return new DataResult(res.data, res.result);
  }

  /// 检查用户关注状态
  static checkFollowDao(name) async {
    String url = Address.doFollow(name);
    var res = await httpManager.netFetch(url, null, null, null, noTip: true);
    return new DataResult(res.data, res.result);
  }

  ///关注用户
  static doFollowDao(name, bool followed) async {
    String url = Address.doFollow(name);
    var res = await httpManager.netFetch(
        url, null, null, new Options(method: !followed ? 'PUT' : "DELETE"));
    return new DataResult(res.data, res.result);
  }

  /// 组织成员
  static getMemberDao(userName, page) async {
    String url = Address.getMember(userName) + Address.getPageParams("?", page);
    var res = await httpManager.netFetch(url, null, null, null);
    if (res != null && res.result) {
      List<User> list = new List();
      var data = res.data;
      if (data == null || data.length == 0) {
        return new DataResult(null, false);
      }
      for (var i = 0; i < data.length; i++) {
        list.add(new User.fromJson(data[i]));
      }
      return new DataResult(list, true);
    } else {
      return new DataResult(null, false);
    }
  }

  ///跟新用户信息
  static updateUserDao(params, Store store) async {
    String url = Address.getMyUserInfo();
    var res = await httpManager.netFetch(
        url, params, null, new Options(method: 'PATCH'));
    if (res != null && res.result) {
      var localResult = await getUserInfoLocal();
      User newUser = User.fromJson(res.data);
      newUser.starred = localResult.data.starred;
      await LocalStorage.save(Config.USER_INFO, json.encode(newUser.toJson()));
      store.dispatch(new UpdateUserAction(newUser));
      return new DataResult(newUser, true);
    }
    return new DataResult(null, false);
  }

  /// 获取用户组织
  static getUserOrgsDao(userName, page, {needDB = false}) async {
    UserOrgsDbProvider provider = new UserOrgsDbProvider();
    next() async {
      String url =
          Address.getUserOrgs(userName) + Address.getPageParams("?", page);
      var res = await httpManager.netFetch(url, null, null, null);
      if (res != null && res.result) {
        List<UserOrg> list = new List();
        var data = res.data;
        if (data == null || data.length == 0) {
          return new DataResult(null, false);
        }
        for (var i = 0; i < data.length; i++) {
          list.add(new UserOrg.fromJson(data[i]));
        }
        if (needDB) {
          provider.insert(userName, json.encode(data));
        }
        return new DataResult(list, true);
      } else {
        return new DataResult(null, false);
      }
    }

    if (needDB) {
      List<UserOrg> list = await provider.geData(userName);
      if (list == null) {
        return await next();
      }
      DataResult dataResult = new DataResult(list, true, next: next);
      return dataResult;
    }
    return await next();
  }

  static searchTrendUserDao(String location,
      {String cursor, ValueChanged valueChanged}) async {
    var result = await getTrendUser(location, cursor: cursor);
    if (result != null && result.data != null) {
      var endCursor = result.data["search"]["pageInfo"]["endCursor"];
      var dataList = result.data["search"]["user"];
      if (dataList == null || dataList.length == 0) {
        return new DataResult(null, false);
      }
      var dataResult = List();
      valueChanged?.call(endCursor);
      dataList.forEach((item) {
        var userModel = SearchUserQL.fromMap(item["user"]);
        dataResult.add(userModel);
      });
      return new DataResult(dataResult, true);
    } else {
      return new DataResult(null, false);
    }
  }
}
