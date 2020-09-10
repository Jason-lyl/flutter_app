import 'package:flutter_app/model/EventPayload.dart';
import 'package:flutter_app/model/Repository.dart';
import 'package:flutter_app/model/User.dart';
import 'package:json_annotation/json_annotation.dart';

/**
 * @author: Jason
 * @create_at: Sep 10, 2020
 */

part 'Event.g.dart';

@JsonSerializable()
class Event {

  String id;
  String type;
  User actor;
  Repository repo;
  User org;
  EventPayload payload;
  @JsonKey(name: "public")
  bool isPublic;
  @JsonKey(name: "created_at")
  DateTime createdAt;

  Event(
    this.id,
    this.type,
    this.actor,
    this.repo,
    this.org,
    this.payload,
    this.isPublic,
    this.createdAt,
  );

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  Map<String, dynamic> toJson() => _$EventToJson(this);
}
