import 'package:flutter/material.dart';
import 'package:flutter_app/common/style/gsy_style.dart';
import 'package:flutter_app/common/utils/common_utils.dart';
import 'package:flutter_app/common/utils/navigator_utils.dart';
import 'package:flutter_app/model/Repository.dart';
import 'package:flutter_app/model/RepositoryQL.dart';
import 'package:flutter_app/widget/gsy_card_item.dart';
import 'package:flutter_app/widget/gsy_icon_text.dart';
import 'package:flutter_app/widget/gsy_user_icon_widget.dart';
import 'package:scoped_model/scoped_model.dart';

/**
 * @author: Jason
 * @create_at: Sep 18, 2020
 */

class ReposItem extends StatelessWidget {
  final ReposViewModel reposViewModel;
  final VoidCallback onPressed;

  ReposItem(this.reposViewModel, {this.onPressed}) : super();

  _getBottomItem(BuildContext context, IconData iconData, String text,
      {int flex = 3}) {
    return new Expanded(
      flex: flex,
      child: new Center(
        child: new GSYIConText(iconData, text, GSYConstant.smallSubText,
            GSYColors.subTextColor, 15.0,
            padding: 5.0,
            textWidth: flex == 4
                ? (MediaQuery.of(context).size.width - 100) / 3
                : (MediaQuery.of(context).size.width - 100) / 5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      child: new GSYCardItem(
        child: new FlatButton(
          onPressed: onPressed, 
          child: new Padding(
            padding: new EdgeInsets.only(
              left: 0.0, top: 10.0, right: 10.0, bottom: 10.0),
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ///头像
                      new GSYUserIconWidget(
                        padding: const EdgeInsets.only(
                          top: 0.0, right: 5.0, left: 0.0),
                          width: 40.0,
                          height: 40.0,
                          image: reposViewModel.ownerPic,
                          onPressed: (){
                            NavigatorUtils.goPerson(context, reposViewModel.ownerName);
                          }),
                          new Expanded(
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ///仓库
                                new Text(reposViewModel.repositoryName ?? "",
                                style: GSYConstant.normalTextBold),

                                /// 用户名
                                new GSYIConText(
                                 GSYICons.REPOS_ITEM_USER,
                                 reposViewModel.ownerName,
                                 GSYConstant.smallSubLightText,
                                 GSYColors.subLightTextColor,
                                 10.0,
                                 padding: 3.0,
                                  )
                              ],
                            ),
                          ),
                          /// 仓库语言
                          new Text(reposViewModel.repositoryType,
                          style: GSYConstant.smallSubText,)
                    ],
                  ),
                  new Container(
                    child: new Text(
                      reposViewModel.repositoryDes,
                      style: GSYConstant.smallSubText,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    margin: new EdgeInsets.only(top: 6.0, bottom: 2.0),
                    alignment: Alignment.topLeft,                    
                  ),

                new Padding(padding: EdgeInsets.all(10.0)),

                /// 仓库状态数值
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:<Widget> [
                    _getBottomItem(context, GSYICons.REPOS_ITEM_STAR, reposViewModel.repositoryStar),
                    new SizedBox(width: 5),
                    _getBottomItem(context, GSYICons.REPOS_ITEM_FORK, reposViewModel.repositoryFork),
                    new SizedBox(width: 5,),
                    _getBottomItem(context, GSYICons.REPOS_ITEM_ISSUE, reposViewModel.repositoryWatch, flex: 4),
                  ],
                ),

                ],
              ),
            ))),
      );
  }
}

class ReposViewModel {
  String ownerName;
  String ownerPic;
  String repositoryName;
  String repositoryStar;
  String repositoryFork;
  String repositoryWatch;
  String hideWatchIcon;
  String repositoryType = "";
  String repositoryDes;

  ReposViewModel();

  ReposViewModel.fromMap(Repository data) {
    ownerName = data.owner.login;
    ownerPic = data.owner.avatar_url;
    repositoryName = data.name;
    repositoryStar = data.watchersCount.toString();
    repositoryFork = data.forksCount.toString();
    repositoryWatch = data.openIssuesCount.toString();
    repositoryType = data.language ?? "---";
    repositoryDes = data.description ?? "---";
  }

  ReposViewModel.fromQL(RepositoryQL data) {
    ownerName = data.ownerName;
    ownerPic = data.ownerAvatarUrl;
    repositoryName = data.reposName;
    repositoryStar = data.starCount.toString();
    repositoryFork = data.forkCount.toString();
    repositoryWatch = data.watcherCount.toString();
    repositoryType = data.language ?? "---";
    repositoryDes =
        CommonUtils.removeTextTag(data.shortDescriptionHTML) ?? "---";
  }

  ReposViewModel.fromTrendMap(model) {
    ownerName = model.name;
    if (model.contributors.length > 0) {
      ownerPic = model.contributors[0];
    } else {
      ownerPic = "";
    }
    repositoryName = model.reposName;
    repositoryStar = model.startCount;
    repositoryFork = model.forkCount;
    repositoryWatch = model.meta;
    repositoryType = model.language;
    repositoryDes = CommonUtils.removeTextTag(model.description);
  }
}
