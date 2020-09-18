


import 'package:flutter_app/db/sql_provider.dart';

/**
 * @author: Jason
 * @create_at: Sep 15, 2020
 */


class OrgMemberDbProvider extends BaseDbProvider {
  final String name = 'OrgMember';

  final String columnId = "_id";
  final String columnOrg = "org";
  final String columnData = "data";

  int id;
  String org;
  String data;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {columnOrg: org, columnData: data};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  OrgMemberDbProvider.fromMap(Map map) {
    id = map[columnId];
    org = map[columnOrg];
    data = map[columnData];
  }

  @override
  tableSqlString() {}

  @override
  tableName() {
    return name;
  }
}