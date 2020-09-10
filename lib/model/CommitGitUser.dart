import 'package:json_annotation/json_annotation.dart';
/**
 * @author: Jason
 * @create_at: Sep 10, 2020
 */

@JsonSerializable()
class CommitGitUser {
  String name;
  String email;
  DateTime data;

  CommitGitUser(this.name, this.email, this.data);
  
}
