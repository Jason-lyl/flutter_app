

import 'dart:convert';

import 'package:flutter_app/common/dao/dao_result.dart';
import 'package:flutter_app/common/net/address.dart';
import 'package:flutter_app/common/net/api.dart';
import 'package:flutter_app/db/provider/event/received_event_db_provider.dart';
import 'package:flutter_app/db/provider/event/user_event_db_provider.dart';
import 'package:flutter_app/model/Event.dart';

/**
 * @author: Jason
 * @create_at: Sep 11, 2020
 */


class EventDao {
  static getEventReceived(String userName,
      {page = 1, bool needDb = false}) async {
    if (userName == null) {
      return null;
    }
    ReceivedEventDbProvider provider = new ReceivedEventDbProvider();

    next() async {
      String url =
          Address.getEventReceived(userName) + Address.getPageParams("?", page);

      var res = await httpManager.netFetch(url, null, null, null);
      if (res != null && res.result) {
        List<Event> list = new List();
        var data = res.data;
        if (data == null || data.length == 0) {
          return null;
        }
        if (needDb) {
          await provider.insert(json.encode(data));
        }
        for (int i = 0; i < data.length; i++) {
          list.add(Event.fromJson(data[i]));
        }
        return new DataResult(list, true);
      } else {
        return new DataResult(null, false);
      }
    }

    if (needDb) {
      List<Event> dbList = await provider.getEvents();
      if (dbList == null || dbList.length == 0) {
        return await next();
      }
      DataResult dataResult = new DataResult(dbList, true, next: next);
      return dataResult;
    }
    return await next();
  }

  /**
   * 用户行为事件
   */
  static getEventDao(userName, {page = 0, bool needDb = false}) async {
    UserEventDbProvider provider = new UserEventDbProvider();
    next() async {
      String url =
          Address.getEvent(userName) + Address.getPageParams("?", page);
      var res = await httpManager.netFetch(url, null, null, null);
      if (res != null && res.result) {
        List<Event> list = new List();
        var data = res.data;
        if (data == null || data.length == 0) {
          return new DataResult(list, true);
        }
        if (needDb) {
          provider.insert(userName, json.encode(data));
        }
        for (int i = 0; i < data.length; i++) {
          list.add(Event.fromJson(data[i]));
        }
        return new DataResult(list, true);
      } else {
        return null;
      }
    }

    if (needDb) {
      List<Event> dbList = await provider.getEvents(userName);
      if (dbList == null || dbList.length == 0) {
        return await next();
      }
      DataResult dataResult = new DataResult(dbList, true, next: next);
      return dataResult;
    }
    return await next();
  }
}