import 'package:json_annotation/json_annotation.dart';

/**
 * @author: Jason
 * @create_at: Sep 10, 2020
 */

part 'License.g.dart';

@JsonSerializable()
class License {
  String name;
  License(this.name);

  factory License.fromJson(Map<String, dynamic> json) => _$LicenseFromJson(json);

  Map<String, dynamic> toJson() => _$LicenseToJson(this);
}
