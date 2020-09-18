
import 'package:flutter_app/db/sql_provider.dart';

/**
 * @author: Jason
 * @create_at: Sep 14, 2020
 */


///仓库分支表
class RepositoryBranchDbProvider extends BaseDbProvider {
  final String name = 'RepositoryPulse';
  final String columnId = "_id";
  final String columnFullName = "fullName";
  final String columnData = "data";

  int id;
  String fullName;
  String data;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {columnFullName: fullName, columnData: data};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  RepositoryBranchDbProvider.fromMap(Map map) {
    id = map[columnId];
    fullName = map[columnFullName];
    data = map[columnData];
  }

  @override
  tableSqlString() {}

  @override
  tableName() {
    return name;
  }
}