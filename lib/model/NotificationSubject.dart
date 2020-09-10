import 'package:json_annotation/json_annotation.dart';

/**
 * @author: Jason
 * @create_at: Sep 10, 2020
 */

part 'NotificationSubject.g.dart';

@JsonSerializable()
class NotificationSubject {
  String title;
  String url;
  String type;

  NotificationSubject(this.title, this.url, this.type);

  factory NotificationSubject.fromJson(Map<String, dynamic> json) => _$NotificationSubjectFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationSubjectToJson(this);
}
