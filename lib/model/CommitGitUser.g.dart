// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CommitGitUser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommitGitUser _$CommitGitUserFromJson(Map<String, dynamic> json) {
  return CommitGitUser(
    json['name'] as String,
    json['email'] as String,
    json['data'] == null ? null : DateTime.parse(json['data'] as String),
  );
}

Map<String, dynamic> _$CommitGitUserToJson(CommitGitUser instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'data': instance.data?.toIso8601String(),
    };
