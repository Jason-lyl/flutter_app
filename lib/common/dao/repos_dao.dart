import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_app/common/config/config.dart';
import 'package:flutter_app/common/dao/dao_result.dart';
import 'package:flutter_app/common/localization/default_localizations.dart';
import 'package:flutter_app/common/net/address.dart';
import 'package:flutter_app/common/net/api.dart';
import 'package:flutter_app/common/net/graphql/client.dart';
import 'package:flutter_app/common/net/result_data.dart';
import 'package:flutter_app/common/net/trending/github_trending.dart';
import 'package:flutter_app/common/utils/common_utils.dart';
import 'package:flutter_app/db/provider/repos/read_history_db_provider.dart';
import 'package:flutter_app/db/provider/repos/repository_detail_db_provider.dart';
import 'package:flutter_app/db/provider/repos/repository_detail_readme_db_provider.dart';
import 'package:flutter_app/db/provider/repos/trend_repository_db_provider.dart';
import 'package:flutter_app/model/PushCommit.dart';
import 'package:flutter_app/model/Release.dart';
import 'package:flutter_app/model/Repository.dart';
import 'package:flutter_app/model/RepositoryQL.dart';
import 'package:flutter_app/model/TrendingRepoModel.dart';
import 'package:flutter_app/model/User.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info/package_info.dart';
import 'package:pub_semver/pub_semver.dart';

/**
 * @author: Jason
 * @create_at: Sep 24, 2020
 */

class ReposDao {
  /* 
  * 趋势数据
   * @param page 分页，趋势数据其实没有分页
   * @param since 数据时长， 本日，本周，本月
   * @param languageType 语言
   */
  static getTrendDao(
      {since = 'daily', languageType, page = 0, needDb = false}) async {
    TrendRepositoryDbProvider provider = new TrendRepositoryDbProvider();
    String languageTypeDb = languageType ?? "*";

    next() async {
      String url = Address.trendingApi(since, languageType);
      var result = await httpManager.netFetch(
          url, null, {"api-token": Config.API_TOKEN}, null,
          noTip: true);
      if (result != null && result.result && result.data is List) {
        List<TrendingRepoModel> list = new List();
        var data = result.data;
        if (data == null || data.length == 0) {
          return new DataResult(null, false);
        }
        if (needDb) {
          provider.insert(languageTypeDb + "V2", since, json.encode(data));
        }
        for (int i = 0; i < data.length; i++) {
          TrendingRepoModel model = TrendingRepoModel.fromJson(data[i]);
          list.add(model);
        }
        return new DataResult(list, true);
      } else {
        String url = Address.trending(since, languageType);
        var res = await new GitHubTrending().fetchTrending(url);
        if (res != null && res.result && res.data.length > 0) {
          List<TrendingRepoModel> list = new List();
          var data = res.data;
          if (data == null || data.length == 0) {
            return new DataResult(null, false);
          }
          if (needDb) {
            provider.insert(languageTypeDb + "V2", since, json.encode(data));
          }

          for (var i = 0; i < data.length; i++) {
            TrendingRepoModel model = data[i];
            list.add(model);
          }
          return new DataResult(list, true);
        } else {
          return new DataResult(null, false);
        }
      }
    }

    if (needDb) {
      List<TrendingRepoModel> list =
          await provider.getData(languageTypeDb + "V2", since);
      if (list == null || list.length == 0) {
        return await next();
      }
      DataResult dataResult = new DataResult(list, true, next: next);
      return dataResult;
    }
    return await next();
  }

  /*
  仓库的详情数据
  */ 

  static getRepositoryDetailDao(userName, reposName, branch,
      {needDb = true}) async {
    String fullName = userName + "/" + reposName + "v3";
    RepositoryDetailDbProvider provider = new RepositoryDetailDbProvider();

    next() async {
      var result = await getRepository(userName, reposName);
      if (result != null && result.data != null) {
        var data = result.data["repository"];
        if (data == null) {
          return new DataResult(null, false);
        }
        var repositoryQl = RepositoryQL.fromMap(data);
        if (needDb) {
          provider.insert(fullName, json.encode(data));
        }
        saveHistoryDao(fullName, DateTime.now(), json.encode(data));
        return new DataResult(repositoryQl, true);
      } else {
        return new DataResult(null, false);
      }
    }

    if (needDb) {
      RepositoryQL repositoryQL = await provider.getRepository(fullName);
      if (repositoryQL == null) {
        return await next();
      }
      DataResult dataResult = new DataResult(repositoryQL, true, next: next);
      return dataResult;
    }
    return await next();
  }

  /*
  详情remde 数据
  */
  static getRepositoryDetailReadmeDao(userName, reposName, branch,
      {needDb = true}) async {
    String fullName = userName + "/" + reposName;

    RepositoryDetailReadmeDbProvider provider =
        new RepositoryDetailReadmeDbProvider();
    next() async {
      String url = Address.readmeFile(userName + "/" + reposName, branch);
      var res = await httpManager.netFetch(
          url,
          null,
          {"Accept": "application/vnd.github.VERSION.raw"},
          new Options(contentType: "text/plain; charset=utf-8"));
      if (res != null && res.result) {
        if (needDb) {
          provider.insert(fullName, branch, res.data);
        }
        return new DataResult(res.data, true);
      }
      return new DataResult(null, false);
    }

    if (needDb) {
      String readme = await provider.getRepositoryReadme(fullName, branch);
      if (readme == null) {
        return await next();
      }
      DataResult dataResult = new DataResult(readme, true, next: next);
      return dataResult;
    }
    return await next();
  }

  /**
   * 搜索仓库
   * @param q 搜索关键字
   * @param sort 分类排序，beat match、most star等
   * @param order 倒序或者正序
   * @param type 搜索类型，人或者仓库 null \ 'user',
   * @param page
   * @param pageSize
   */

  static searchRepositoryDao(
      q, language, sort, order, type, page, pageSize) async {
    if (language != null) {
      q = q + "%2Blanguage%3A$language";
    }
    String url = Address.search(q, sort, order, type, page);
    var res = await httpManager.netFetch(url, null, null, null);
    if (type == null) {
      if (res != null && res.result != null && res.data["items"] != null) {
        List<Repository> list = new List();
        var datalist = res.data["items"];
        if (datalist == null && datalist.length == 0) {
          return new DataResult(null, false);
        }
        for (var i = 0; i < datalist.length; i++) {
          var data = datalist[i];
          list.add(Repository.fromJson(data));
        }
        return new DataResult(list, true);
      } else {
        return new DataResult(null, false);
      }
    } else {
      if (res != null && res.result != null && res.data["items"] != null) {
        List<User> list = new List();
        var data = res.data["items"];
        if (data == null && data.length == 0) {
          return new DataResult(null, false);
        }
        for (var i = 0; i < data.length; i++) {
          list.add(new User.fromJson(data[i]));
        }
        return new DataResult(list, true);
      } else {
        return new DataResult(null, false);
      }
    }
  }

  /*
  获取单个仓库提交详情
  */
  static getReposCommitsInfoDao(userName, reposName, sha) async {
    String url = Address.getReposCommitsInfo(userName, reposName, sha);
    var res = await httpManager.netFetch(url, null, null, null);
    if (res != null && res.result) {
      PushCommit pushCommit = PushCommit.fromJson(res.data);
      return new DataResult(pushCommit, true);
    } else {
      return new DataResult(null, false);
    }
  }

  /*
  获取仓库的release列表
  */

  static getRepositoryReleaseDao(userName, reposName, page,
      {needHtml = true, release = true}) async {
    String url = release
        ? Address.getReposRelease(userName, reposName) +
            Address.getPageParams("?", page)
        : Address.getReposTag(userName, reposName) +
            Address.getPageParams("?", page);

    var res = await httpManager.netFetch(
        url,
        null,
        {
          "Accept":
              'application/vnd.github.html,application/vnd.github.VERSION.raw'
        },
        null);

    if (res != null && res.result && res.data.length > 0) {
      List<Release> list = new List();
      var dataList = res.data;
      if (dataList == null || dataList.length == 0) {
        return new DataResult(null, false);
      }
      for (var i = 0; i < dataList.length; i++) {
        var data = dataList[i];
        list.add(Release.fromJson(data));
      }
      return new DataResult(list, true);
    } else {
      return new DataResult(null, false);
    }
  }

  /*
  版本跟新
   */
  static getNewsVersion(context, showTip) async {
    // ios 不检查跟新
    if (Platform.isIOS) {
      return;
    }
    var res = await getRepositoryReleaseDao(
        "CarGuo", 'gsy_github_app_flutter', 1,
        needHtml: false);
    if (res != null && res.result && res.data.length > 0) {
      Release release = res.data[0];
      String versionName = release.name;
      if (versionName != null) {
        if (Config.DEBUG) {
          print("versionName" + versionName);
        }
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        var appVersion = packageInfo.version;
        if (Config.DEBUG) {
          print("appVersion" + appVersion);
        }
        Version versionNameNum = Version.parse(versionName);
        Version currentNum = Version.parse(appVersion);
        int result = versionNameNum.compareTo(currentNum);
        if (Config.DEBUG) {
          print("versionNameNum " +
              versionNameNum.toString() +
              " currentNum " +
              currentNum.toString());
        }
        if (Config.DEBUG) {
          print("newsHad " + result.toString());
        }
        if (result > 0) {
          CommonUtils.showUpdateDialog(
              context, release.name + ": " + release.body);
        } else {
          if (showTip) {
            Fluttertoast.showToast(
                msg: GSYLocalizations.i18n(context).app_not_new_version);
          }
        }
      }
    }
  }

  /*
  获取issue总数
  */
  static getRepositoryIssueStateDao(userName, repository) async {
    String url = Address.getReposIssue(userName, repository, null, null, null) +
        "&per_page=1";
    var res = await httpManager.netFetch(url, null, null, null);
    if (res != null && res.result && res.headers != null) {
      try {
        List<String> link = res.headers["link"];
        if (link != null) {
          int indexStart = link[0].lastIndexOf("page=") + 5;
          int indexEnd = link[0].lastIndexOf(">");
          if (indexStart >= 0 && indexEnd >= 0) {
            String count = link[0].substring(indexStart, indexEnd);
            return new DataResult(count, true);
          }
        }
      } catch (e) {
        print(e);
      }
    }
    return new DataResult(null, false);
  }

  /*
   搜索话题
   */

  static searchTopicRepositoryDao(searchTopic, {page = 0}) async {
    String url =
        Address.searchTopic(searchTopic) + Address.getPageParams("&", page);
    var res = await httpManager.netFetch(url, null, null, null);
    var data = (res.data != null && res.data["items"] != null)
        ? res.data["items"]
        : res.data;
    if (res != null && res.result && data != null && data.length > 0) {
      List<Repository> list = new List();
      var dataList = data;
      if (dataList == null || data.length == 0) {
        return new DataResult(null, false);
      }
      for (var i = 0; i < dataList.length; i++) {
        var data = dataList[i];
        list.add(Repository.fromJson(data));
      }
      return new DataResult(list, true);
    } else {
      return new DataResult(null, false);
    }
  }

  /* 
  获取阅读历史
   */
  static getHistoryDao(page) async {
    ReadHistoryDbProvider provider = new ReadHistoryDbProvider();
    List<RepositoryQL> list = await provider.geData(page);
    if (list == null || list.length < 0) {
      return new DataResult(null, false);
    }
    return new DataResult(list, true);
  }

  /* 
  保存阅读历史
   */
  static saveHistoryDao(String fullName, DateTime dateTime, String data) {
    ReadHistoryDbProvider provider = new ReadHistoryDbProvider();
    provider.insert(fullName, dateTime, data);
  }
}
