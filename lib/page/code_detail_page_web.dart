import 'package:flutter/material.dart';

/**
 * @author: Jason
 * @create_at: Sep 18, 2020
 */

class CodeDetailPageWeb extends StatefulWidget {
  final String userName;
  final String reposName;
  final String path;
  final String data;
  final String title;
  final String branch;
  final String htmlUrl;

  CodeDetailPageWeb(
    {
      this.userName,
      this.reposName,
      this.path,
      this.data,
      this.title,
      this.branch,
      this.htmlUrl});
      

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
