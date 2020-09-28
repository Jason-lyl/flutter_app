import 'package:flutter/material.dart';
import 'package:flutter_app/common/dao/repos_dao.dart';
import 'package:flutter_app/common/localization/default_localizations.dart';
import 'package:flutter_app/common/style/gsy_style.dart';
import 'package:flutter_app/common/utils/common_utils.dart';
import 'package:flutter_app/common/utils/html_utils.dart';
import 'package:flutter_app/page/release/widget/release_item.dart';
import 'package:flutter_app/widget/gsy_common_option_widget.dart';
import 'package:flutter_app/widget/gsy_select_item_widget.dart';
import 'package:flutter_app/widget/gsy_title_bar.dart';
import 'package:flutter_app/widget/pull/gsy_pull_load_widget.dart';
import 'package:flutter_app/widget/state/gsy_list_state.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

/**
 * @author: Jason
 * @create_at: Sep 16, 2020
 */

class ReleasePage extends StatefulWidget {
  final String userName;
  final String reposName;
  final String releaseUrl;
  final String tagUrl;

  ReleasePage(this.userName, this.reposName, this.releaseUrl, this.tagUrl);

  @override
  _ReleasePageState createState() => _ReleasePageState();
}

class _ReleasePageState extends State<ReleasePage>
    with AutomaticKeepAliveClientMixin<ReleasePage>, GSYListState<ReleasePage> {
  // 显示tag 还是release
  int selectIndex = 0;

  //绘制item
  _renderEventItem(index) {
    ReleaseItemViewModel releaseItemViewModel =
        ReleaseItemViewModel.fromMap(pullLoadWidgetControl.dataList[index]);
    return new ReleaseItem(
      releaseItemViewModel,
      onPressed: () {
        // 没有release 提示不显示
        if (selectIndex == 0 &&
            releaseItemViewModel.actionTargetHtml != null &&
            releaseItemViewModel.actionTargetHtml.length > 0) {
          String html = HtmlUtils.generateHtml(
              releaseItemViewModel.actionTargetHtml,
              backgroundColor: GSYColors.miWhiteString,
              userBR: false);
          CommonUtils.launchWebView(
              context, releaseItemViewModel.actionTitle, html);
        }
      },
      onLongPress: () {
        _launchURL();
      },
    );
  }

  // 打开外部url
  _launchURL() async {
    String url = _getUrl();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(
          msg: GSYLocalizations.i18n(context).option_web_launcher_error +
              ": " +
              url);
    }
  }

  String _getUrl() {
    return selectIndex == 0 ? widget.releaseUrl : widget.tagUrl;
  }

  _resolveSelectIndex() {
    clearData();
    showRefreshLoading();
  }

  _getDataLogic() async {
    return await ReposDao.getRepositoryReleaseDao(
        widget.userName, widget.reposName, page,
        needHtml: true, release: selectIndex == 0);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  bool get needHeader => true;

  @override
  bool get isRefreshFirst => true;

  @override
  requestLoadMore() async {
    return await _getDataLogic();
  }

  @override
  requestRefresh() async {
    return await _getDataLogic();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new Scaffold(
      backgroundColor: GSYColors.mainBackgroundColor,
      appBar: new AppBar(
        title: GSYTitleBar(
          widget.reposName,
          rightWidget: new GSYCommonOptionWidget(
            url: _getUrl(),
          ),
        ),
        bottom: new GSYSelectItemWidget(
          [
            GSYLocalizations.i18n(context).release_tab_release,
            GSYLocalizations.i18n(context).release_tab_tag,
          ],
          (selectIndex) {
            this.selectIndex = selectIndex;
            _resolveSelectIndex();
          },
          height: 30.0,
          margin: const EdgeInsets.all(0.0),
          elevation: 0.0,
        ),
        elevation: 4.0,
      ),
      body: GSYPullLoadWidget(
          pullLoadWidgetControl,
          (BuildContext context, int index) => _renderEventItem(index),
          handleRefresh,
          onLoadMore,
          refreshKey: refreshIndicatorKey),
    );
  }
}
