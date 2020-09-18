import 'package:flutter/material.dart';

/**
 * @author: Jason
 * @create_at: Sep 18, 2020
 */

@Deprecated("待完善")

class IssueDetailPage extends StatefulWidget {
  final String userName;
  final String reposName;
  final String isssueNum;
  final bool needHomeIcon;

  IssueDetailPage(this.userName, this.reposName, this.isssueNum, {this.needHomeIcon = false});
  

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
