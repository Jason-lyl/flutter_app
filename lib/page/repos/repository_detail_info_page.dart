import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/common/dao/repos_dao.dart';
import 'package:flutter_app/common/localization/default_localizations.dart';
import 'package:flutter_app/common/style/gsy_style.dart';
import 'package:flutter_app/common/utils/common_utils.dart';
import 'package:flutter_app/common/utils/event_utils.dart';
import 'package:flutter_app/common/utils/navigator_utils.dart';
import 'package:flutter_app/model/RepoCommit.dart';
import 'package:flutter_app/page/push/widget/nested_refresh.dart';
import 'package:flutter_app/page/repos/scope/repos_detail_model.dart';
import 'package:flutter_app/page/repos/widget/repos_header_item.dart';
import 'package:flutter_app/page/repos/widget/repos_item.dart';
import 'package:flutter_app/widget/gsy_event_item.dart';
import 'package:flutter_app/widget/gsy_icon_text.dart';
import 'package:flutter_app/widget/gsy_select_item_widget.dart';
import 'package:flutter_app/widget/pull/nested/gsy_nested_pull_load_widget.dart';
import 'package:flutter_app/widget/pull/nested/gsy_sliver_header_delegate.dart';
import 'package:flutter_app/widget/state/gsy_list_state.dart';
import 'package:scoped_model/scoped_model.dart';

/**
 * @author: Jason
 * @create_at: Sep 28, 2020
 */

class RepositoryDetaiInfoPage extends StatefulWidget {
  final String userName;
  final String reposName;

  RepositoryDetaiInfoPage(this.userName, this.reposName, {Key key})
      : super(key: key);
  
  @override
  RepositoryDetaiInfoPageState createState() => RepositoryDetaiInfoPageState();
}

class RepositoryDetaiInfoPageState extends State<RepositoryDetaiInfoPage>
    with
        AutomaticKeepAliveClientMixin<RepositoryDetaiInfoPage>,
        GSYListState<RepositoryDetaiInfoPage>,
        TickerProviderStateMixin {
  // 滑动监听
  final ScrollController scrollController = new ScrollController();

  // 当前显示tab
  int selectIndex = 0;

  // 初始化默认header 大小
  double headerSize = 270;

  // NestedScrollView 的刷新状态 GlobalKey ，方便主动刷新使用
  final GlobalKey<NestedScrollViewRefreshIndicatorState> refreshIKey =
      new GlobalKey<NestedScrollViewRefreshIndicatorState>();

  // 动画控制器
  AnimationController animationController;

  @override
  showRefreshLoading() {
    new Future.delayed(const Duration(seconds: 0), () {
      refreshIKey.currentState.show().then((e) {});
      return true;
    });
  }

  // 渲染item或提交item
  _renderEventItem(index) {
    var item = pullLoadWidgetControl.dataList[index];
    if (selectIndex == 1 && item is RepoCommit) {
      // 提交
      return GSYEventItem(
        EventViewModel.fromCommitMap(item),
        onPressed: () {
          RepoCommit model = pullLoadWidgetControl.dataList[index];
          NavigatorUtils.goPushDetailPage(
              context, widget.userName, widget.reposName, model.sha, false);
        },
        needImage: false,
      );
    }
    return new GSYEventItem(
      EventViewModel.fromEventMap(pullLoadWidgetControl.dataList[index]),
      onPressed: () {
        EventUtils.ActionUtils(context, pullLoadWidgetControl.dataList[index],
            widget.userName + "/" + widget.reposName);
      },
    );
  }

  // 获取列表
  _getDataLogic() async {
    if (selectIndex == 1) {
      return await ReposDao.getReposCommitsDao(
          widget.userName, widget.reposName,
          page: page,
          branch: ReposDetailModel.of(context).currentBranch,
          needDb: page <= 1);
    }
    return await ReposDao.getRepositoryEventDao(
        widget.userName, widget.reposName,
        page: page,
        branch: ReposDetailModel.of(context).currentBranch,
        needDb: page <= 1);
  }

  // 获取详情
  _getReposDetail() {
    ReposDao.getRepositoryDetailDao(widget.userName, widget.reposName,
            ReposDetailModel.of(context).currentBranch)
        .then((result) {
      if (result != null && result.result) {
        if (result.data.defaultBranch != null &&
            result.data.defaultBranch.length > 0) {
          ReposDetailModel.of(context).currentBranch =
              result.data.defaultBranch;
        }
        ReposDetailModel.of(context).repository = result.data;
        ReposDetailModel.of(context).getReposStatus(_getBottomWidget);
      }
    });
  }

  //绘制底部状态
  List<Widget> _getBottomWidget() {
    // 根据网络返回数据，返回底部状态数据
    List<Widget> bottomWidget = (ReposDetailModel.of(context).bottomModel ==
            null)
        ? []
        : <Widget>[
            // star
            _renderBottomItem(ReposDetailModel.of(context).bottomModel.starText,
                ReposDetailModel.of(context).bottomModel.starIcon, () {
              CommonUtils.showLoadingDialog(context);
              return ReposDao.doRepositoryStarDao(
                      widget.userName,
                      widget.reposName,
                      ReposDetailModel.of(context).repository.isStared)
                  .then((result) {
                showRefreshLoading();
                Navigator.pop(context);
              });
            }),

            // watch
            _renderBottomItem(
                ReposDetailModel.of(context).bottomModel.watchText,
                ReposDetailModel.of(context).bottomModel.watchIcon, () {
              return ReposDao.doRepositoryWatchDao(
                      widget.userName,
                      widget.reposName,
                      ReposDetailModel.of(context).repository.isSubscription ==
                          "SUBSCRIBED")
                  .then((reslut) {
                showRefreshLoading();
                Navigator.pop(context);
              });
            }),

            // fork
            _renderBottomItem("fork", GSYICons.REPOS_ITEM_FORK, () {
              CommonUtils.showLoadingDialog(context);
              return ReposDao.createForkDao(widget.userName, widget.reposName)
                  .then((result) {
                showRefreshLoading();
                Navigator.pop(context);
              });
            }),
          ];
    return bottomWidget;
  }

  // 绘制底部状态item
  _renderBottomItem(var text, var icon, var onPressed) {
    return new FlatButton(
        onPressed: onPressed,
        child: new GSYIConText(
            icon, text, GSYConstant.smallText, GSYColors.primaryValue, 15.0,
            padding: 5.0, mainAxisAlignment: MainAxisAlignment.center));
  }

  @override
  bool get wantKeepAlive => true;

  @override
  requestRefresh() async {
    _getReposDetail();
    return await _getDataLogic();
  }

  @override
  requestLoadMore() async {
    return await _getDataLogic();
  }

  @override
  bool get isRefreshFirst => true;

  @override
  bool get needHeader => false;

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ScopedModelDescendant<ReposDetailModel>(
      builder: (context, child, model) {
        return GSYNestedPullLoadWidget(
          pullLoadWidgetControl,
          (BuildContext context, int index) => _renderEventItem(index),
          handleRefresh,
          onLoadMore,
          refreshKey: refreshIndicatorKey,
          scrollController: scrollController,
          headerSliverBuilder: (context, _) {},
        );
      },
    );
  }

  //绘制内置Header, 支持部分停靠支持

  List<Widget> _sliverBuilder(BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      // 头部信息
      SliverPersistentHeader(
        delegate: GSYSliverHeaderDelegate(
            maxHeight: headerSize,
            minHeight: headerSize,
            snapConfig: FloatingHeaderSnapConfiguration(
              vsync: this,
              curve: Curves.bounceInOut,
              duration: const Duration(milliseconds: 10),
            ),
            child: new ReposHeaderItem(
              ReposHeaderViewModel.fromHttpMap(widget.userName,
                  widget.reposName, ReposDetailModel.of(context).repository),
              layoutListener: (size) {
                setState(() {
                  headerSize = size.height;
                });
              },
            )),
      ),

      // 动态放大缩小的tab控件
      SliverPersistentHeader(
        pinned: true,
        delegate: GSYSliverHeaderDelegate(
          maxHeight: 60,
          minHeight: 60,
          changeSize: true,
          snapConfig: FloatingHeaderSnapConfiguration(
            vsync: this,
            curve: Curves.bounceInOut,
            duration: const Duration(milliseconds: 10),
          ),
          builder: (context, shrinkOffset, overlapsContent) {
            ///根据数值计算偏差
            var lr = 10 - shrinkOffset / 60 * 10;
            var radius = Radius.circular(4 - shrinkOffset / 60 * 4);
            return SizedBox.expand(
              child: Padding(
                padding: EdgeInsets.only(bottom: 10.0, left: lr, right: lr),
                child: new GSYSelectItemWidget(
                  [
                    GSYLocalizations.i18n(context).repos_tab_activity,
                    GSYLocalizations.i18n(context).repos_tab_commits
                  ],
                  (index) {
                    // 切换时先滑动
                    scrollController
                        .animateTo(0,
                            duration: Duration(milliseconds: 200),
                            curve: Curves.bounceInOut)
                        .then((_) {
                      selectIndex = index;
                      clearData();
                      showRefreshLoading();
                    });
                  },
                  margin: EdgeInsets.zero,
                  shape: new RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(radius)),
                ),
              ),
            );
          },
        ),
      )
    ];
  }
}
