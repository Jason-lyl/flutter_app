import 'package:flutter/material.dart';

/**
 * @author: Jason
 * @create_at: Sep 16, 2020
 */

@Deprecated("待完善")
class ReleasePage extends StatefulWidget {
  final String userName;
  final String reposName;
  final String releaseUrl;
  final String tagUrl;

  ReleasePage(this.userName, this.reposName, this.releaseUrl, this.tagUrl);

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
