import 'package:flutter_app/model/CommitFile.dart';
import 'package:flutter_app/model/CommitGitInfo.dart';
import 'package:flutter_app/model/CommitStats.dart';
import 'package:flutter_app/model/RepoCommit.dart';
import 'package:flutter_app/model/User.dart';
import 'package:json_annotation/json_annotation.dart';
/**
 * @author: Jason
 * @create_at: Sep 10, 2020
 */

part 'PushCommit.g.dart';

@JsonSerializable()
class PushCommit {

  List<CommitFile> files;

  CommitStats stats;

  String sha;
  String url;
  @JsonKey(name: "html_url")
  String htmlUrl;
  @JsonKey(name: "comments_url")
  String commentsUrl;

  CommitGitInfo commit;
  User author;
  User committer;
  List<RepoCommit> parents;

  PushCommit(
    this.files,
    this.stats,
    this.sha,
    this.url,
    this.htmlUrl,
    this.commentsUrl,
    this.commit,
    this.author,
    this.committer,
    this.parents,
  );

  factory PushCommit.fromJson(Map<String, dynamic> json) => _$PushCommitFromJson(json);

  Map<String, dynamic> toJson() => _$PushCommitToJson(this);
}
