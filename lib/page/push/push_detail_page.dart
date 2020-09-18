import 'package:flutter/material.dart';

/**
 * @author: Jason
 * @create_at: Sep 18, 2020
 */

@Deprecated("待完善")
class PushDetailPage extends StatefulWidget {
  final String userName;
  final String reposName;
  final String sha;
  final bool needHomeIcon;

  PushDetailPage(this.sha, this.userName, this.reposName, {this.needHomeIcon = false});

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
