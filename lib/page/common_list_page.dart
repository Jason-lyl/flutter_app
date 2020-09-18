import 'package:flutter/material.dart';

/**
 * @author: Jason
 * @create_at: Sep 18, 2020
 */

class CommonListPage extends StatefulWidget {
  final String userName;
  final String reposName;
  final String showType;
  final String dataType;
  final String title;

  CommonListPage(this.title, this.showType, this.dataType, {this.userName, this.reposName});
  


  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
