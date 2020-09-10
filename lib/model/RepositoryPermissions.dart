import 'package:json_annotation/json_annotation.dart';
/**
 * @author: Jason
 * @create_at: Sep 10, 2020
 */

part 'RepositoryPermissions.g.dart';

@JsonSerializable()
class RepositoryPermissions {
  bool admin;
  bool push;
  bool pull;

  RepositoryPermissions(
    this.admin,
    this.push,
    this.pull
  );

  factory RepositoryPermissions.fromJson(Map<String, dynamic> json) => _$RepositoryPermissionsFromJson(json);
  Map<String, dynamic> toJson() => _$RepositoryPermissionsToJson(this);
}
