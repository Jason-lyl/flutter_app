import 'package:flutter/material.dart';
import 'package:flutter_app/common/net/interceptors/log_interceptor.dart';
import 'package:flutter_app/common/style/gsy_style.dart';
import 'package:flutter_app/page/error_page.dart';
import 'package:flutter_app/test/demo_tab_page.dart';
import 'package:flutter/services.dart';

/**
 * @author: Jason
 * @create_at: Sep 16, 2020
 */

class DebugDataPage extends StatefulWidget {
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _DebugDataPageState extends State<DebugDataPage> {
  int tabIndex = 0;

  _renderTab(String text, index) {
    return new Tab(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[new Text(text, style: new TextStyle(fontSize: 11))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new TabWidget(
      type: TabType.top,

      /// 返回数据和请求数据
      tabItems: [
        _renderTab("Responses", 0),
        _renderTab("Request", 1),
        _renderTab("Error", 2),
        _renderTab("ErrorWidget", 3)
      ],
      title: new Text(
        "Debug",
        style: TextStyle(color: GSYColors.white),
      ),
      tabViews: [
        DebugDataList(
            LogsInterceptors.sRequestHttpUrl, LogsInterceptors.sHttpResponses),
        DebugDataList(
            LogsInterceptors.sRequestHttpUrl, LogsInterceptors.sHttpRequest),
        DebugDataList(
            LogsInterceptors.sHttpErrorUrl, LogsInterceptors.sHttpError),
        DebugDataList(ErrorPageState.sErrorName, ErrorPageState.sErrorStack),
      ],
      indicatorColor: GSYColors.primaryValue,
      onTap: (index) {
        setState(() {
          tabIndex = index;
        });
      },
    );
  }
}

class DebugDataList extends StatefulWidget {
  final List<Map> dataList;

  final List<String> titles;

  DebugDataList(this.titles, this.dataList);

  @override
  _DebugDataListState createState() => _DebugDataListState();
}

class _DebugDataListState extends State<DebugDataList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: GSYColors.white,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, i) {
          var index = widget.dataList.length - i - 1;
          return InkWell(
            child: Row(
              children: <Widget>[
                new Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(right: 5),
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                      color: GSYColors.primaryValue,
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      )),
                  child: new Text(
                    index.toString(),
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white.withAlpha(200),
                    ),
                  ),
                ),
                new Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: new Text(
                      widget.titles[index] ?? "",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
