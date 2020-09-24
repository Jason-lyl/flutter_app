import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/common/dao/repos_dao.dart';
import 'package:flutter_app/common/style/gsy_style.dart';
import 'package:flutter_app/common/utils/html_utils.dart';
import 'package:flutter_app/common/utils/navigator_utils.dart';
import 'package:flutter_app/page/push/widget/push_code_item.dart';
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

  String htmlUrl;

  @override
  bool get isRefreshFirst => throw UnimplementedError();

  @override
  Future<Null> handleReresh() async {
    if (isLoading) {
      return null;
    }
    isLoading = true;
    page = 1;

    // 获取提交信息
  }

  // 绘制头部和提交item

  _renderEventItem(index) {
    if (index == 0) {
      return new PushHeader(pushHeaderViewModel);
    }
    PushCodeItemViewModel itemViewModel = PushCodeItemViewModel.fromMap(
        pullLoadWidgetControl.dataList[index - 1]);
    return new PushCodeItem(itemViewModel, () {
      String html = HtmlUtils.generateCode2HTml(
          HtmlUtils.parseDiffSource(itemViewModel.patch, false),
          backgroundColor: GSYColors.webDraculaBackgroundColorString,
          lang: '',
          userBR: false);
      NavigatorUtils.gotoCodeDetailPlatform(
        context,
        title: itemViewModel.name,
        reposName: widget.reposName,
        userName: widget.userName,
        path: itemViewModel.patch,
        data: new Uri.dataFromString(html,
                mimeType: 'text/html', encoding: Encoding.getByName("utf-8"))
            .toString(),
        branch: "",
      );
    });
  }

  _getDataLoginc() async {
    return await ReposDao.getReposCommitsInfoDao(
        widget.userName, widget.reposName, widget.sha);
  }
  
}
