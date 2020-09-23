import 'package:flutter/material.dart';
import 'package:flutter_app/page/push/widget/push_header.dart';
import 'package:flutter_app/widget/state/gsy_list_state.dart';

/**
 * @author: Jason
 * @create_at: Sep 18, 2020
 */

class PushDetailPage extends StatefulWidget {
  final String userName;
  final String reposName;
  final String sha;
  final bool needHomeIcon;

  PushDetailPage(this.sha, this.userName, this.reposName,
      {this.needHomeIcon = false});

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _PushDetailPageState extends State<PushDetailPage>
    with
        AutomaticKeepAliveClientMixin<PushDetailPage>,
        GSYListState<PushDetailPage> {
  /// 提价信息页面的头部数据实体
  PushHeaderViewModel pushHeaderViewModel = new PushHeaderViewModel();

  @override
  // TODO: implement isRefreshFirst
  bool get isRefreshFirst => throw UnimplementedError();
}
