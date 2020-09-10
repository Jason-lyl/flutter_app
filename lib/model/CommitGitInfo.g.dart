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
  
}