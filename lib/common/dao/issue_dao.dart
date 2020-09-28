import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_app/common/dao/dao_result.dart';
import 'package:flutter_app/common/net/address.dart';
import 'package:flutter_app/common/net/api.dart';
import 'package:flutter_app/db/provider/issue/issue_comment_db_provider.dart';
import 'package:flutter_app/db/provider/issue/issue_detail_db_provider.dart';
import 'package:flutter_app/db/provider/repos/repository_issue_db_provider.dart';
import 'package:flutter_app/model/Issue.dart';

/**
 * @author: Jason
 * @create_at: Sep 14, 2020
 */

class IssueDao {
  static getRepositoryIssueDao(userName, repository, state,
      {sort, direction, page = 0, needDb = false}) async {
    String fullName = userName + "/" + repository;
    String dbState = state ?? "*";
    RepositoryIssueDbProvider provider = new RepositoryIssueDbProvider();

    next() async {
      String url =
          Address.getReposIssue(userName, repository, state, sort, direction) +
              Address.getPageParams("&", page);
      var res = await httpManager.netFetch(
          url,
          null,
          {
            "Accept":
                'application/vnd.github.html,application/vnd.github.VERSION.raw'
          },
          null);
      if (res != null && res.result) {
        List<Issue> list = new List();
        var data = res.data;
        if (data == null || data.length == 0) {
          return new DataResult(null, false);
        }
        for (var i = 0; i < data.length; i++) {
          list.add(Issue.fromJson(data[i]));
        }
        if (needDb) {
          provider.insert(fullName, dbState, json.encode(data));
        }
        return new DataResult(list, true);
      } else {
        return new DataResult(null, false);
      }
    }

    if (needDb) {
      List<Issue> list = await provider.getData(fullName, dbState);
      if (list == null) {
        return await next();
      }
      DataResult dataResult = new DataResult(list, true, next: next);
      return dataResult;
    }
    return await next();
  }

  static searchRepositoryIssue(q, name, reposName, state, {page = 1}) async {
    String qu;
    if (state == null || state == "all") {
      qu = q + "+repo%3A${name}%2F${reposName}";
    } else {
      qu = q + "+repo%3A${name}%2F${reposName}+state%3A${state}";
    }
    String url =
        Address.repositoryIssueSearch(qu) + Address.getPageParams("&", page);
    var res = await httpManager.netFetch(url, null, null, null);
    if (res != null && res.result) {
      List<Issue> list = new List();
      var data = res.data["items"];
      if (data == null && data.length == 0) {
        return new DataResult(null, false);
      }
      for (var i = 0; i < data.length; i++) {
        list.add(Issue.fromJson(data[i]));
      }
      return new DataResult(list, true);
    } else {
      return new DataResult(null, false);
    }
  }

  static getIssueInfoDao(userName, repository, number, {needDb = true}) async {
    String fullName = userName + "/" + repository;
    IssueDetailDbProvider provider = new IssueDetailDbProvider();
    next() async {
      String url = Address.getIssueInfo(userName, repository, number);
      var res = await httpManager.netFetch(
          url, null, {"Accept": "application/vnd.github.VERSION.raw"}, null);

      if (res != null && res.result) {
        if (needDb) {
          provider.insert(fullName, number, json.encode(res.data));
        }
        return new DataResult(Issue.fromJson(res.data), true);
      } else {
        return new DataResult(null, false);
      }
    }

    if (needDb) {
      Issue issue = await provider.getRepository(fullName, number);
      if (issue == null) {
        return await next();
      }
      DataResult dataResult = new DataResult(issue, true, next: next);
      return dataResult;
    }
    return await next();
  }

  static getIssueCommentDao(username, repository, number,
      {page: 0, neeDb = false}) async {
    String fullName = username + "/" + repository;
    IssueCommentDbProvider provider = new IssueCommentDbProvider();
    next() async {
      String url = Address.getIssueComment(username, repository, number) +
          Address.getPageParams("?", page);
      var res = await httpManager.netFetch(
          url, null, {"Accept": "application/vnd.github.VERSION.raw"}, null);
      if (res != null && res.result) {
        List<Issue> list = new List();
        var data = res.data;
        if (data == null || data.length == 0) {
          return new DataResult(null, false);
        }
        if (neeDb) {
          provider.insert(fullName, number, json.encode(res.data));
        }
        for (var i = 0; i < data.length; i++) {
          list.add(Issue.fromJson(data[i]));
        }
        return new DataResult(list, true);
      } else {
        return new DataResult(null, false);
      }
    }

    if (neeDb) {
      List<Issue> list = await provider.getData(fullName, number);
      if (list == null) {
        return await next();
      }
      DataResult dataResult = new DataResult(list, true, next: next);
      return dataResult;
    }
    return await next();
  }

  static addIssueCommentDao(userName, repository, number, comment) async {
    String url = Address.addIssueComment(userName, repository, number);
    var res = await httpManager.netFetch(
        url,
        {"body": comment},
        {"Accept": 'application/vnd.github.VERSION.full+json'},
        new Options(method: 'POST'));
    if (res != null && res.result) {
      return new DataResult(res.data, true);
    } else {
      return new DataResult(null, false);
    }
  }

  static editIssueDao(userName, repository, number, issue) async {
    String url = Address.editIssue(userName, repository, number);
    var res = await httpManager.netFetch(
        url,
        issue,
        {"Accept": 'application/vnd.github.VERSION.full+json'},
        new Options(method: "PATCH"));
    if (res != null && res.data) {
      return new DataResult(res.data, true);
    } else {
      return new DataResult(null, false);
    }
  }

  static lockIssueDao(userName, repository, number, locked) async {
    String url = Address.lockIssue(userName, repository, number);
    var res = await httpManager.netFetch(
        url,
        null,
        {"Accept": 'application/vnd.github.VERSION.full+json'},
        new Options(method: locked ? "DELETE" : 'PUT'),
        noTip: true);
    if (res != null && res.result) {
      return new DataResult(res.data, true);
    } else {
      return DataResult(null, false);
    }
  }

  static createIssueDao(userName, repository, issue) async {
    String url = Address.createIssue(userName, repository);
    var res = await httpManager.netFetch(
        url,
        issue,
        {'Accept': 'application/vnd.github.VERSION.full+json'},
        new Options(method: 'POST'));
    if (res != null && res.result) {
      return new DataResult(res.data, true);
    } else {
      return new DataResult(null, false);
    }
  }

  static editCommentDao(
      userName, repository, number, commentId, comment) async {
    String url = Address.editComment(userName, repository, commentId);
    var res = await httpManager.netFetch(
        url,
        comment,
        {"Accept": 'application/vnd.github.VERSION.full+jso'},
        new Options(method: 'PATCH'));
    if (res != null && res.result) {
      return new DataResult(res.data, true);
    } else {
      return new DataResult(null, false);
    }
  }

  static deleteCommentDao(userName, repository, number, commentId) async {
    String url = Address.editComment(userName, repository, commentId);
    var res = await httpManager
        .netFetch(url, null, null, new Options(method: 'DELETE'), noTip: true);
    if (res != null && res.result) {
      return new DataResult(res.result, true);
    } else {
      return new DataResult(null, false);
    }
  }
}
