import 'package:json_annotation/json_annotation.dart';
/**
 * @author: Jason
 * @create_at: Sep 10, 2020
 */

part 'CommitGitUser.g.dart';

@JsonSerializable()
class CommitGitUser {
  String name;
  String email;
  DateTime data;

  CommitGitUser(this.name, this.email, this.data);

  factory CommitGitUser.fromJson(Map<String, dynamic> json) =>
      _$CommitGitUserFromJson(json);

  Map<String, dynamic> toJson() => _$CommitGitUserToJson(this);
}
