import 'package:flutter/material.dart';
import 'package:flutter_app/page/repos/repository_file_list_page.dart';

/**
 * @author: Jason
 * @create_at: Sep 16, 2020
 */

class RepositoryDetailPage extends StatefulWidget {
  final String userName;
  final String reposName;

  RepositoryDetailPage(this.userName, this.reposName);

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// class _RepositoryDetailPageState extends State<RepositoryDetailPage>
//     with SingleTickerProviderStateMixin {
//   // 文件列表页的 GlobalKey ，可用于当前控件控制文件页行为
//   GlobalKey<RepositoryDetailFileListPageState> fileListKey =
//       new GlobalKey<RepositoryDetailFileListPageState>();

//       // 详细信息页 ，可用于当前控件控制文件页行为
// }

///底部状态实体
class BottomStatusModel {
  final String watchText;
  final String starText;
  final IconData watchIcon;
  final IconData starIcon;

  BottomStatusModel(
      this.watchText, this.starText, this.watchIcon, this.starIcon);
}
