import 'package:flutter/material.dart';
import 'package:flutter_app/common/dao/repos_dao.dart';
import 'package:flutter_app/common/localization/default_localizations.dart';
import 'package:flutter_app/common/style/gsy_style.dart';
import 'package:flutter_app/page/repos/scope/repos_detail_model.dart';
import 'package:flutter_app/widget/markdown/gsy_markdown_widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:scoped_model/scoped_model.dart';

/**
 * @author: Jason
 * @create_at: Sep 28, 2020
 */

class RepositoryDetailReadmePage extends StatefulWidget {
  final String userName;
  final String reposName;

  RepositoryDetailReadmePage(this.userName, this.reposName, {Key key})
      : super(key: key);

  @override
  RepositoryDetailReadmePageState createState() => RepositoryDetailReadmePageState();
}

class RepositoryDetailReadmePageState extends State<RepositoryDetailReadmePage>
    with AutomaticKeepAliveClientMixin {
  bool isShow = false;
  String markdownData;

  RepositoryDetailReadmePageState();

  refreshReadme() {
    ReposDao.getRepositoryDetailReadmeDao(widget.userName, widget.reposName,
            ReposDetailModel.of(context).currentBranch)
        .then((res) {
      if (res != null && res.result) {
        if (isShow) {
          setState(() {
            markdownData = res.data;
          });
          return res.next?.cal();
        }
      }
      return Future.value(null);
    }).then((res) {
      if (res != null && res.result) {
        if (isShow) {
          setState(() {
            markdownData = res.data;
          });
        }
      }
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    isShow = true;
    super.initState();
    refreshReadme();
  }

  @override
  void dispose() {
    isShow = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var widget = (markdownData == null)
        ? new Center(
            child: new Container(
              width: 200.0,
              height: 200.0,
              padding: EdgeInsets.all(4.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new SpinKitDoubleBounce(
                    color: Theme.of(context).primaryColor,
                  ),
                  new Container(width: 10.0),
                  new Container(
                    child: new Text(
                      GSYLocalizations.i18n(context).loading_text,
                      style: GSYConstant.middleText,
                    ),
                  )
                ],
              ),
            ),
          )
        : GSYMarkdownWidget(markdownData: markdownData);
    return new ScopedModelDescendant<ReposDetailModel>(
        builder: (context, child, model) => widget);
  }
}
