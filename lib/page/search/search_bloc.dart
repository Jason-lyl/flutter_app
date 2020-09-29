import 'package:flutter/cupertino.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/dao/repos_dao.dart';
import 'package:flutter_app/page/search/widget/gsy_search_drawer.dart';

/**
 * @author: Jason
 * @create_at: Sep 29, 2020
 */



class SearchBLoC {

  ///搜索仓库还是人
  int selectIndex = 0;

  ///搜索文件
  String get searchText {
    return textEditingController.text;
  }

  ///排序类型
  String type = searchFilterType[0].value;

  ///排序
  String sort = sortType[0].value;

  ///过滤语言
  String language = searchLanguageType[0].value;

  final TextEditingController textEditingController  = TextEditingController();


  ///获取搜索数据
  getDataLogic(int page) async {
    return await ReposDao.searchRepositoryDao(searchText, language, type, sort,
        selectIndex == 0 ? null : 'user', page, Config.PAGE_SIZE);
  }

}