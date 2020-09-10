import 'package:json_annotation/json_annotation.dart';
/**
 * @author: Jason
 * @create_at: Sep 10, 2020
 */

part 'Template.g.dart';

@JsonSerializable()
class Template {
  String name;
  int id;
  @JsonKey(name: "push_id")
  int pushId;

  Template(this.name, this.id, this.pushId);

  factory Template.fromJson(Map<String, dynamic> json) =>
      _$TemplateFromJson(json);

  Map<String, dynamic> toJson() => _$TemplateToJson(this);
}
