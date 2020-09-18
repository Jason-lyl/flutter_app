
import 'package:flutter/foundation.dart';
import 'package:flutter_app/common/utils/code_utils.dart';
import 'package:flutter_app/db/sql_provider.dart';
import 'package:flutter_app/model/User.dart';
import 'package:sqflite/sqflite.dart';

/**
 * @author: Jason
 * @create_at: Sep 11, 2020
 */


///仓库订阅用户表
class RepositoryWatcherDbProvider extends BaseDbProvider {
  final String name = 'RepositoryWatcher';
  final String columnId = "_id";
  final String columnFullName = "fullName";
  final String columnData = "data";

  int id;
  String fullName;
  String data;

  RepositoryWatcherDbProvider();

  Map<String, dynamic> toMap(String fullName, String data) {
    Map<String, dynamic> map = {columnFullName: fullName, columnData: data};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  RepositoryWatcherDbProvider.fromMap(Map map) {
    id = map[columnId];
    fullName = map[columnFullName];
    data = map[columnData];
  }

  @override
  tableSqlString() {
    return tableBaseString(name, columnId) +
        '''
        $columnFullName text not null,
        $columnData text not null)
      ''';
  }

  @override
  tableName() {
    return name;
  }

  Future _getProvider(Database db, String fullName) async {
    List<Map<String, dynamic>> maps = await db.query(name,
        columns: [columnId, columnFullName, columnData],
        where: "$columnFullName = ?",
        whereArgs: [fullName]);
    if (maps.length > 0) {
      RepositoryWatcherDbProvider provider =
          RepositoryWatcherDbProvider.fromMap(maps.first);
      return provider;
    }
    return null;
  }

  ///插入到数据库
  Future insert(String fullName, String dataMapString) async {
    Database db = await getDataBase();
    var provider = await _getProvider(db, fullName);
    if (provider != null) {
      await db
          .delete(name, where: "$columnFullName = ?", whereArgs: [fullName]);
    }
    return await db.insert(name, toMap(fullName, dataMapString));
  }

  ///获取事件数据
  Future<List<User>> geData(String fullName) async {
    Database db = await getDataBase();

    var provider = await _getProvider(db, fullName);
    if (provider != null) {
      List<User> list = new List();

      ///使用 compute 的 Isolate 优化 json decode
      List<dynamic> eventMap =
          await compute(CodeUtils.decodeListResult, provider.data as String);

      if (eventMap.length > 0) {
        for (var item in eventMap) {
          list.add(User.fromJson(item));
        }
      }
      return list;
    }
    return null;
  }
}