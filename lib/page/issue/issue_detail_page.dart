import 'package:flutter/material.dart';
import 'package:flutter_app/common/dao/issue_dao.dart';
import 'package:flutter_app/common/localization/default_localizations.dart';
import 'package:flutter_app/common/style/gsy_style.dart';
import 'package:flutter_app/common/utils/common_utils.dart';
import 'package:flutter_app/common/utils/navigator_utils.dart';
import 'package:flutter_app/model/Issue.dart';
import 'package:flutter_app/page/issue/widget/issue_header_item.dart';
import 'package:flutter_app/page/issue/widget/issue_item.dart';
import 'package:flutter_app/widget/gsy_common_option_widget.dart';
import 'package:flutter_app/widget/gsy_flex_button.dart';
import 'package:flutter_app/widget/gsy_title_bar.dart';
import 'package:flutter_app/widget/pull/gsy_pull_load_widget.dart';
import 'package:flutter_app/widget/state/gsy_list_state.dart';
import 'package:fluttertoast/fluttertoast.dart';

/**
 * @author: Jason
 * @create_at: Sep 18, 2020
 */

class IssueDetailPage extends StatefulWidget {
  final String userName;
  final String reposName;
  final String isssueNum;
  final bool needHomeIcon;

  IssueDetailPage(this.userName, this.reposName, this.isssueNum,
      {this.needHomeIcon = false});
  @override
  _IssueDetailPageState createState() => _IssueDetailPageState();
}

class _IssueDetailPageState extends State<IssueDetailPage>
    with
        AutomaticKeepAliveClientMixin<IssueDetailPage>,
        GSYListState<IssueDetailPage> {
  int selectIndex = 0;

  // 头部信息数据是否加载成功，成功了就可以显示底部状态
  bool headerStatus = false;
  String htmlUrl;

  // issue 的头部数据显示
  IssueHeaderViewModel issueHeaderViewModel = new IssueHeaderViewModel();

  // 控制编辑时issue 的title
  TextEditingController issueInfoTitleControl = new TextEditingController();

  // 控制编辑时issue 的content
  TextEditingController issueInfoValueControl = new TextEditingController();

  // 绘制item
  _renderEventItem(index) {
    // 第一个绘制头部
    if (index == 0) {
      return new IssueHeaderItem(
        issueHeaderViewModel,
        onPressed: () {},
      );
    }
    Issue issue = pullLoadWidgetControl.dataList[index - 1];
    return new IssueItem(
      IssueItemViewModel.fromMap(issue, needTitle: false),
      hideBottom: true,
      limitComment: false,
      onLongPress: () {
        NavigatorUtils.showGSYDialog(
            context: context,
            builder: (BuildContext context) {
              return new Center(
                child: new Container(
                  decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      color: GSYColors.white,
                      border: new Border.all(
                          color: GSYColors.subTextColor, width: 0.3)),
                  margin: EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new GSYFlexButton(
                        color: GSYColors.white,
                        text: GSYLocalizations.i18n(context)
                            .issue_edit_issue_commit,
                        onPress: () {
                          _editCommit(issue.id.toString(), issue.body);
                        },
                      ),
                      new GSYFlexButton(
                        color: GSYColors.white,
                        text: GSYLocalizations.i18n(context)
                            .issue_edit_issue_delete_commit,
                        onPress: () {
                          _deleteCommit(issue.id.toString());
                        },
                      ),
                      new GSYFlexButton(
                        color: GSYColors.white,
                        text: GSYLocalizations.i18n(context)
                            .issue_edit_issue_copy_commit,
                        onPress: () {
                          CommonUtils.copy(issue.body, context);
                        },
                      )
                    ],
                  ),
                ),
              );
            });
      },
    );
  }

  // 获取页面数据
  _getDataLogic() async {
    // 刷新同时跟新头部数据
    if (page < 1) {}
  }

  // 获取头部数据
  _getHeaderInfo() {
    .getIssueInfoDao(
            widget.userName, widget.reposName, widget.isssueNum)
        .then((res) {
      if (res != null && res.result) {
        _resolveHeaderInfo(res);
        return res.next?.call();
      }
      return new Future.value(null);
    }).then((res) {
      if (res != null && res.result) {
        _resolveHeaderInfo(res);
      }
    });
  }

  // 数据转换显示
  _resolveHeaderInfo(res) {
    Issue issue = res.data;
    setState(() {
      issueHeaderViewModel = IssueHeaderViewModel.fromMap(issue);
      htmlUrl = issue.htmlUrl;
      headerStatus = true;
    });
  }

  // 编辑回复
  _editCommit(id, content) {
    Navigator.pop(context);
    String contentData = content;
    issueInfoValueControl = new TextEditingController(text: contentData);

    // 编译Issue info
    CommonUtils.showEditDialog(
      context,
      GSYLocalizations.i18n(context).issue_edit_issue,
      null,
      (contentValue) {
        contentData = contentValue;
      },
      () {
        if (contentData == null || contentData.trim().length == 0) {
          Fluttertoast.showToast(
              msg: GSYLocalizations.i18n(context)
                  .issue_edit_issue_content_not_be_null);
          return;
        }
        CommonUtils.showLoadingDialog(context);
        // 提交修改
        .editCommentDao(widget.userName, widget.reposName,
            widget.isssueNum, id, {"body": contentData}).then((result) {
          showRefreshLoading();
          Navigator.pop(context);
          Navigator.pop(context);
        });
      },
      valueController: issueInfoTitleControl,
      needTitle: false,
    );
  }

  // 删除回复
  _deleteCommit(id) {
    Navigator.pop(context);
    CommonUtils.showLoadingDialog(context);
    // 提交修改
    .deleteCommentDao(
            widget.userName, widget.reposName, widget.isssueNum, id)
        .then((result) {
      Navigator.pop(context);
      showRefreshLoading();
    });

    // 编译issue
    _editIssue() {
      String title = issueHeaderViewModel.issueComment;
      String content = issueHeaderViewModel.issueDesHtml;
      issueInfoTitleControl = new TextEditingController(text: title);
      issueInfoValueControl = new TextEditingController(text: content);

      CommonUtils.showEditDialog(
          context, GSYLocalizations.i18n(context).issue_edit_issue,
          (titleValue) {
        title = titleValue;
      }, (contentValue) {
        content = contentValue;
      }, () {
        if (title == null || title.trim().length == 0) {
          Fluttertoast.showToast(
              msg: GSYLocalizations.i18n(context)
                  .issue_edit_issue_title_not_be_null);
          return;
        }
        if (content == null || content.trim().length == 0) {
          Fluttertoast.showToast(
              msg: GSYLocalizations.i18n(context)
                  .issue_edit_issue_content_not_be_null);
          return;
        }
        CommonUtils.showLoadingDialog(context);

        // 提交修改
        .editIssueDao(
            widget.userName,
            widget.reposName,
            widget.isssueNum,
            {"title": title, "body": content}).then((result) {});
      });
    }
  }

  //回复 issue
  _replyIssue() {
    // 回复 Info
    issueInfoTitleControl = new TextEditingController(text: "");
    issueInfoValueControl = new TextEditingController(text: "");

    String content = "";
    CommonUtils.showEditDialog(
      context,
      GSYLocalizations.i18n(context).issue_reply_issue,
      null,
      (replyContent) {
        content = replyContent;
      },
      () {
        if (content == null || content.trim().length == 0) {
          Fluttertoast.showToast(
              msg: GSYLocalizations.i18n(context)
                  .issue_edit_issue_content_not_be_null);
          return;
        }
        CommonUtils.showLoadingDialog(context);
        // 提交评论
        .addIssueCommentDao(
                widget.userName, widget.reposName, widget.isssueNum, content)
            .then((reslut) {
          showRefreshLoading();
          Navigator.pop(context);
          Navigator.pop(context);
        });
      },
      needTitle: false,
      titleController: issueInfoTitleControl,
      valueController: issueInfoValueControl,
    );
  }

  // 获取底部状态控件显示
  _getBottomWidget() {
    List<Widget> bottomWidget = (!headerStatus)
        ? []
        : <Widget>[
            new FlatButton(
              onPressed: () {
                _replyIssue();
              },
              child: new Text(GSYLocalizations.i18n(context).issue_reply,
                  style: GSYConstant.smallText),
            ),
            new Container(
              width: 0.3,
              height: 30.0,
              color: GSYColors.subLightTextColor,
            ),
            new FlatButton(
              onPressed: () {
                CommonUtils.showLoadingDialog(context);
                .editIssueDao(
                    widget.userName, widget.reposName, widget.isssueNum, {
                  "state": (issueHeaderViewModel.state == "closed")
                      ? 'open'
                      : 'closed'
                }).then((result) {
                  _getHeaderInfo();
                  Navigator.pop(context);
                });
              },
              child: new Text(
                (issueHeaderViewModel.state == "closed")
                    ? GSYLocalizations.i18n(context).issue_open
                    : GSYLocalizations.i18n(context).issue_close,
                style: GSYConstant.smallText,
              ),
            ),
            new Container(
              width: 0.3,
              height: 30.0,
              color: GSYColors.subLightTextColor,
            ),
            new FlatButton(
              onPressed: () {
                CommonUtils.showLoadingDialog(context);
                .lockIssueDao(widget.userName, widget.reposName,
                        widget.isssueNum, issueHeaderViewModel.locked)
                    .then((result) {
                  _getHeaderInfo();
                  Navigator.pop(context);
                });
              },
              child: new Text(
                (issueHeaderViewModel.locked)
                    ? GSYLocalizations.i18n(context).issue_unlock
                    : GSYLocalizations.i18n(context).issue_lock,
                style: GSYConstant.smallText,
              ),
            )
          ];
    return bottomWidget;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  requestRefresh() async {
    return await _getDataLogic();
  }

  @override
  requestLoadMore() async {
    return await _getDataLogic();
  }

  @override
  bool get isRefreshFirst => true;

  @override
  bool get needHeader => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Widget widgetContent = (widget.needHomeIcon)
        ? null
        : new GSYCommonOptionWidget(
            url: htmlUrl,
          );
    return new Scaffold(
      persistentFooterButtons: _getBottomWidget(),
      appBar: new AppBar(
        title: GSYTitleBar(
          widget.reposName,
          rightWidget: widgetContent,
          needRightLocalIcon: widget.needHomeIcon,
          iconData: GSYICons.HOME,
          onRigintIconPressed: (_) {
            NavigatorUtils.goReposDetail(
                context, widget.userName, widget.reposName);
          },
        ),
      ),
      body: GSYPullLoadWidget(
        pullLoadWidgetControl,
        (BuildContext context, int index) => _renderEventItem(index),
        handleReresh,
        onLoadMore,
        refreshKey: refreshIndicatorKey,
      ),
    );
  }
}
