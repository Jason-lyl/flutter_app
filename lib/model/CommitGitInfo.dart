
import 'package:flutter_app/model/CommitGitUser.dart';
import 'package:json_annotation/json_annotation.dart';
/**
 * @author: Jason
 * @create_at: Sep 10, 2020
 */


@JsonSerializable()
class CommitGitInfo {
    String message;
  String url;
  @JsonKey(name: "comment_count")
  int commentCount;
  CommitGitUser author;
  CommitGitUser committer;

  CommitGitInfo(
    this.message,
    this.url,
    this.commentCount,
    this.author,
    this.committer,
  );
}