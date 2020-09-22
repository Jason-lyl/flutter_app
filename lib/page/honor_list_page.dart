import 'package:flutter/material.dart';
import 'package:flutter_app/common/localization/default_localizations.dart';
import 'package:flutter_app/common/utils/navigator_utils.dart';
import 'package:flutter_app/page/repos/widget/repos_item.dart';

/**
 * @author: Jason
 * @create_at: Sep 16, 2020
 */

class HonorListPage extends StatefulWidget {
  final List list;
  HonorListPage(this.list);
  @override
  _HonorListPageState createState() => _HonorListPageState();
}

class _HonorListPageState extends State<HonorListPage> {
  _renderItem(item) {
    ReposViewModel reposViewModel = ReposViewModel.fromMap(item);
    return new ReposItem(reposViewModel, onPressed: () {
      NavigatorUtils.goReposDetail(
          context, reposViewModel.ownerName, reposViewModel.repositoryName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          GSYLocalizations.i18n(context).user_tab_honor,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return _renderItem(widget.list[index]);
        },
        itemCount: widget.list.length,
      ),
    );
  }
}
