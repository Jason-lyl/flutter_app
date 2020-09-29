import 'package:flutter/material.dart';
import 'package:flutter_app/common/event/index.dart';
import 'package:flutter_app/common/utils/navigator_utils.dart';
import 'package:flutter_app/page/repos/widget/repos_item.dart';
import 'package:flutter_app/page/search/search_bloc.dart';
import 'package:flutter_app/page/search/widget/gsy_search_drawer.dart';
import 'package:flutter_app/page/user/widget/user_item.dart';
import 'package:flutter_app/widget/state/gsy_list_state.dart';

/**
 * @author: Jason
 * @create_at: Sep 18, 2020
 */

class SearchPage extends StatefulWidget {
  final Offset centerPosition;

  SearchPage(this.centerPosition);

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _SearchPageState extends State<SearchPage>
    with
        AutomaticKeepAliveClientMixin<SearchPage>,
        GSYListState<SearchPage>,
        SingleTickerProviderStateMixin {
  final SearchBLoC searchBLoC = new SearchBLoC();
  AnimationController controller;
  Animation animation;
  bool endAnima = false;

  // 绘制item
  _renderItem(index) {
    var data = pullLoadWidgetControl.dataList[index];
    if (searchBLoC.selectIndex == 0) {
      ReposViewModel reposViewModel = ReposViewModel.fromMap(data);
      return new ReposItem(reposViewModel, onPressed: () {
        NavigatorUtils.goReposDetail(
            context, reposViewModel.ownerName, reposViewModel.repositoryName);
      });
    } else if (searchBLoC.selectIndex == 1) {
      return new UserItem(UserItemViewModel.fromMap(data), onPressed: () {
        NavigatorUtils.goPerson(
            context, UserItemViewModel.fromMap(data).userName);
      });
    }
  }

  // 切换tab
  _resolveSelectIndex() {
    clearData();
    showRefreshLoading();
  }

  // 获取搜索数据
  _getDataLogic() async {
    return await searchBLoC.getDataLogic(page);
  }

  // 清空过滤数据
  _clearSelect(List<FilterModel> list) {
    for (FilterModel model in list) {
      model.select = false;
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  bool get needHeader => false;

  @override
  bool get isRefreshFirst => false;

  @override
  requestLoadMore() async {
    return await _getDataLogic();
  }

  @override
  requestRefresh() async {
    return await _getDataLogic();
  }

  _search() {
    if (searchBLoC.searchText == null ||
        searchBLoC.searchText.trim().length == 0) {
      return;
    }
    _resolveSelectIndex();
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    animation = CurvedAnimation(parent: controller, curve: Curves.easeInCubic)
      ..addListener(() {
        setState(() {});
      });
    Future.delayed(new Duration(seconds: 0), () {
      controller.forward().then((_) {
        setState(() {
          endAnima = true;
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _clearSelect(sortType);
    sortType[0].select = true;
    _clearSelect(searchLanguageType);
    searchLanguageType[0].select = true;
    _clearSelect(searchFilterType);
    searchFilterType[0].select = true;
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return super.build(context);
  }
}
