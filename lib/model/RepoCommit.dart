import 'package:flutter_app/model/CommitGitInfo.dart';
import 'package:flutter_app/model/User.dart';
import 'package:json_annotation/json_annotation.dart';
/**
 * @author: Jason
 * @create_at: Sep 10, 2020
 */

part 'RepoCommit.g.dart';

@JsonSerializable()
class RepoCommit {
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

  RepoCommit(
    this.sha,
    this.url,
    this.htmlUrl,
    this.commentsUrl,
    this.commit,
    this.author,
    this.committer,
    this.parents,
  );

  factory RepoCommit.fromJson(Map<String, dynamic> json) =>
      _$RepoCommitFromJson(json);
  Map<String, dynamic> toJson() => _$RepoCommitToJson(this);
}
