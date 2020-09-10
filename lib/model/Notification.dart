import 'package:flutter_app/model/NotificationSubject.dart';
import 'package:flutter_app/model/Repository.dart';
import 'package:json_annotation/json_annotation.dart';

/**
 * @author: Jason
 * @create_at: Sep 10, 2020
 */

part 'Notification.g.dart';

@JsonSerializable()
class Notification {
  String id;
   bool unread;
  String reason;
  @JsonKey(name: "updated_at")
  DateTime updateAt;
  @JsonKey(name: "last_read_at")
  DateTime lastReadAt;
  Repository repository;
  NotificationSubject subject;

  Notification(this.id, this.unread, this.reason, this.updateAt, this.lastReadAt, this.repository, this.subject);

  factory Notification.fromJson(Map<String, dynamic> json) => _$NotificationFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationToJson(this);
}
